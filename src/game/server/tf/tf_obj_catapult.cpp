//========= Copyright Valve Corporation, All rights reserved. ============//
//========= Copyright Snowy's stupid studio, All rights reserved. ============//
//
//			Self explanatory, it's the jumppad basically lol
//=============================================================================
#include "cbase.h"
#include "tf_obj_catapult.h"
#include "tf_player.h"
#include "engine/IEngineSound.h"
#include "mathlib/mathlib.h"
#include "tf_gamestats.h"
#include "tf_team.h"
#include "in_buttons.h"
#include "tf_shareddefs.h"

#define CATAPULT_THINK_CONTEXT				"CatapultContext"

#define CATAPULT_MODEL	"models/buildables/bouncepad_light.mdl"

const Vector CATAPULT_MINS = Vector(-24, -24, 0);
const Vector CATAPULT_MAXS = Vector(24, 24, 12);

ConVar tf_engineer_catapult_force("tf_engineer_catapult_force", "1000");

// Separate cooldown delays for catapult levels (in seconds)
int g_iCatapultLaunchDelays[4] = {
	0,   // Level 0 (no cooldown)
	8,   // Level 1 delay
	5,   // Level 2 delay
	3    // Level 3 delay
};

//IMPLEMENT_SERVERCLASS_ST( CObjectCatapult, DT_ObjectCatapult )
//END_SEND_TABLE()

BEGIN_DATADESC(CObjectCatapult)
DEFINE_THINKFUNC(CatapultThink),
END_DATADESC()

PRECACHE_REGISTER(obj_catapult);

LINK_ENTITY_TO_CLASS(obj_catapult, CObjectCatapult);

CObjectCatapult::CObjectCatapult()
{
	int iHealth = GetMaxHealthForCurrentLevel();

	SetMaxHealth(iHealth);
	SetHealth(iHealth);
	UseClientSideAnimation();

	SetType(OBJ_CATAPULT);
}

void CObjectCatapult::Spawn()
{
    SetSolid(SOLID_VPHYSICS);
    SetMoveType(MOVETYPE_NONE);
    m_takedamage = DAMAGE_NO;
    SetModel(CATAPULT_MODEL);

    int nBodyDir = FindBodygroupByName("teleporter_direction");
    if (nBodyDir != -1)
    {
        SetBodygroup(nBodyDir, 0);
    }

    UTIL_SetSize(this, CATAPULT_MINS, CATAPULT_MAXS);

    BaseClass::Spawn();

    // Spin building 180 degrees if your model needs this fix
    RotateBuildAngles();
    RotateBuildAngles();

    UpdateDesiredBuildRotation(5.f);

    // Set collision group for solid objects that players collide with
    SetCollisionGroup(COLLISION_GROUP_PLAYER);
    
    // Create physics object to enable collisions
    if (VPhysicsInitNormal(SOLID_VPHYSICS, 0, false) == false)
    {
        DevMsg("Failed to initialize physics for catapult!\n");
    }
}




void CObjectCatapult::Precache()
{
	BaseClass::Precache();

	PrecacheModel(CATAPULT_MODEL);
	PrecacheScriptSound("weapons/jumppad_fire.wav");
}

void CObjectCatapult::CatapultThink()
{
	if (IsCarried())
		return;

	SetContextThink(&CObjectCatapult::CatapultThink, gpGlobals->curtime + 0.1f, CATAPULT_THINK_CONTEXT);

	for (int i = 0; i < m_jumpers.Count(); )
	{
		const Jumper_t& jumper = m_jumpers[i];

		if (!jumper.m_hJumper)
		{
			m_jumpers.Remove(i);
			continue;
		}

		CTFPlayer* pPlayer = ToTFPlayer(jumper.m_hJumper);
		if (!pPlayer)
		{
			m_jumpers.Remove(i);
			continue;
		}

		// Launch ONLY when the player jumps (presses jump button)
		if (pPlayer->m_nButtons & IN_JUMP)
		{
			Launch(jumper.m_hJumper);
			m_jumpers.Remove(i);
		}
		else
		{
			++i;
		}
	}
}


void CObjectCatapult::OnGoActive()
{
	BaseClass::OnGoActive();

	SetContextThink(&CObjectCatapult::CatapultThink, gpGlobals->curtime + 0.1, CATAPULT_THINK_CONTEXT);

	int nBodyDir = FindBodygroupByName("teleporter_direction");
	if (nBodyDir != -1)
	{
		SetBodygroup(nBodyDir, 1);
	}
}

bool CObjectCatapult::IsPlacementPosValid(void)
{
	bool bResult = BaseClass::IsPlacementPosValid();

	if (!bResult)
	{
		return false;
	}

	// m_vecBuildOrigin is the proposed build origin

	// start above the teleporter position
	Vector vecTestPos = m_vecBuildOrigin;
	vecTestPos.z += CATAPULT_MAXS.z;

	// make sure we can fit a player on top in this pos
	trace_t tr;
	UTIL_TraceHull(vecTestPos, vecTestPos, VEC_HULL_MIN, VEC_HULL_MAX, MASK_SOLID | CONTENTS_PLAYERCLIP, this, COLLISION_GROUP_PLAYER_MOVEMENT, &tr);

	return (tr.fraction >= 1.0);
}

void CObjectCatapult::StartTouch(CBaseEntity* pOther)
{
	BaseClass::StartTouch(pOther);

	if (pOther->IsPlayer())
	{
		CTFPlayer* pPlayer = ToTFPlayer(pOther);
		if (!pPlayer)
			return;

		// Only allow players on the same team as the catapult's builder to use it
		CTFPlayer* pBuilder = ToTFPlayer(GetBuilder());
		if (pBuilder && pPlayer->GetTeamNumber() != pBuilder->GetTeamNumber())
		{
			// Different team, do NOT add as jumper
			return;
		}

		// Uncomment below for debugging touches
		// DevMsg("Player touched catapult: %s\n", pPlayer->GetPlayerName());

		int index = m_jumpers.AddToTail();
		Jumper_t& jumper = m_jumpers[index];
		jumper.m_hJumper = pOther;
		jumper.flTouchTime = gpGlobals->curtime;
	}
}

void CObjectCatapult::EndTouch(CBaseEntity* pOther)
{
	BaseClass::EndTouch(pOther);

	for (int i = 0; i < m_jumpers.Count(); ++i)
	{
		if (m_jumpers[i].m_hJumper == pOther)
		{
			m_jumpers.Remove(i);
			return;
		}
	}
}

void CObjectCatapult::Launch(CBaseEntity* pEnt)
{
	// Convert to player
	CTFPlayer* pPlayer = ToTFPlayer(pEnt);
	if (!pPlayer)
		return;

	int iTeam = pPlayer->GetTeamNumber();

	if (pPlayer->IsPlayerClass(TF_CLASS_SPY) && pPlayer->m_Shared.InCond(TF_COND_DISGUISED))
	{
		CTFPlayer* pBuilder = ToTFPlayer(GetBuilder());
		if (pBuilder && iTeam != pBuilder->GetTeamNumber())
		{
			iTeam = pBuilder->GetTeamNumber();  // just assign, no int here
		}
	}

	Vector vForward;
	QAngle qEyeAngle = pEnt->EyeAngles();
	AngleVectors(pEnt->EyeAngles(), &vForward);
	vForward.NormalizeInPlace();
	vForward.z += 2.0f;
	vForward.NormalizeInPlace();

	// Apply impulse
	pPlayer->ApplyGenericPushbackImpulse(tf_engineer_catapult_force.GetFloat() * vForward, nullptr);

	// Play sound from the catapult itself
	EmitSound("weapons/jumppad_fire.wav");

	// Also play the sound from the player
	pPlayer->EmitSound("weapons/jumppad_fire.wav");
}
