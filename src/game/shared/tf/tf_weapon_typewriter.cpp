//========= Copyright Valve Corporation, All rights reserved. ============//
//======== Copyright Snowy's stupid studio, all rights reserved. =========//
// haha crediting myself and putting a fake copyright is so funny
//
//=============================================================================
#include "cbase.h"
#include "tf_weapon_typewriter.h"

static const float DAMAGE_TO_FILL_MINICRIT_METER = 100.0f;

// Client specific.
#ifdef CLIENT_DLL
#include "c_tf_player.h"
// Server specific.
#else
#include "tf_player.h"
#endif
//=============================================================================
//
// Weapon tables.
//

// ---------- Regular SMG -------------

CREATE_SIMPLE_WEAPON_TABLE( TFTYPEWRITER, tf_weapon_typewriter )

// Server specific.
#ifndef CLIENT_DLL
BEGIN_DATADESC( CTFTYPEWRITER)
END_DATADESC()
#endif

// ---------- Charged SMG -------------

IMPLEMENT_NETWORKCLASS_ALIASED( TFChargedTYPEWRITER, DT_WeaponChargedTypewriter )

BEGIN_NETWORK_TABLE( CTFChargedTYPEWRITER, DT_WeaponChargedTypewriter)
// Client specific.
#ifdef CLIENT_DLL
RecvPropFloat( RECVINFO( m_flMinicritCharge ) ),
// Server specific.
#else
SendPropFloat( SENDINFO( m_flMinicritCharge ), 4, SPROP_NOSCALE, 0.0f, DAMAGE_TO_FILL_MINICRIT_METER ),
#endif
END_NETWORK_TABLE()

// Server specific
#ifndef CLIENT_DLL
BEGIN_DATADESC( CTFChargedTYPEWRITER)
END_DATADESC()
#endif

// Client specific
#ifdef CLIENT_DLL
BEGIN_PREDICTION_DATA( CTFChargedTYPEWRITER)
DEFINE_FIELD(  m_flMinicritCharge, FIELD_FLOAT )
END_PREDICTION_DATA()
#endif

LINK_ENTITY_TO_CLASS( tf_weapon_charged_TYPEWRITER, CTFChargedTYPEWRITER);
PRECACHE_WEAPON_REGISTER( tf_weapon_charged_TYPEWRITER);

//=============================================================================
//
// Weapon SMG functions.

//-----------------------------------------------------------------------------
// Purpose: 
//-----------------------------------------------------------------------------
int	CTFTYPEWRITER::GetDamageType( void ) const
{
	if ( CanHeadshot() )
	{
		int iDamageType = BaseClass::GetDamageType() | DMG_USE_HITLOCATIONS;
		return iDamageType;
	}

	return BaseClass::GetDamageType();
}

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
bool CTFTYPEWRITER::CanFireCriticalShot( bool bIsHeadshot, CBaseEntity *pTarget /*= NULL*/ )
{
	if ( !BaseClass::CanFireCriticalShot( bIsHeadshot, pTarget ) )
		return false;

	CTFPlayer *pPlayer = GetTFPlayerOwner();
	if ( pPlayer && pPlayer->m_Shared.IsCritBoosted() )
		return true;

	if ( !bIsHeadshot )
		return !CanHeadshot();

	return true;
}

//-----------------------------------------------------------------------------
// Purpose:	Determine if secondary fire is available.
//-----------------------------------------------------------------------------
bool CTFChargedTYPEWRITER::CanPerformSecondaryAttack() const
{
	return ( m_flMinicritCharge >= DAMAGE_TO_FILL_MINICRIT_METER && BaseClass::CanPerformSecondaryAttack() );
}

//-----------------------------------------------------------------------------
// Purpose: Determine whether to flash the HUD element showing the charge bar
//-----------------------------------------------------------------------------
bool CTFChargedTYPEWRITER::ShouldFlashChargeBar()
{
	return m_flMinicritCharge >= DAMAGE_TO_FILL_MINICRIT_METER;
}

//-----------------------------------------------------------------------------
// Purpose: Get HUD charge bar progress amount
//-----------------------------------------------------------------------------
float CTFChargedTYPEWRITER::GetProgress( void )
{
	// Progress bar shows charge amount if we're charging up, otherwise drains over time if we're mini-crit boosted.
	CTFPlayer *pPlayer = ToTFPlayer( GetOwner() );
	if ( pPlayer && pPlayer->m_Shared.InCond( TF_COND_ENERGY_BUFF ) )
	{
		int flBuffDuration = 0;
		CALL_ATTRIB_HOOK_FLOAT( flBuffDuration, minicrit_boost_when_charged );
		if ( flBuffDuration > 0 )
		{
			float flElapsed = gpGlobals->curtime - m_flMinicritStartTime;
			float flRemainingPortion = Clamp( (flBuffDuration - flElapsed) / flBuffDuration, 0.0f, 1.0f );
			return flRemainingPortion;
		}
		else
		{
			return 0.0f;
		}
	}
	else
	{
		return m_flMinicritCharge / DAMAGE_TO_FILL_MINICRIT_METER;
	}
}

//-----------------------------------------------------------------------------
// Purpose: Reset weapon state
//-----------------------------------------------------------------------------
void CTFChargedTYPEWRITER::WeaponReset()
{
	BaseClass::WeaponReset();
	m_flMinicritCharge = 0.0f;
	m_flMinicritStartTime = 0.0f;
}

//-----------------------------------------------------------------------------
// Purpose: Perform secondary attack
//-----------------------------------------------------------------------------
void CTFChargedTYPEWRITER::SecondaryAttack()
{
	BaseClass::SecondaryAttack();

	m_flMinicritCharge = 0.0f;

	CTFPlayer *pPlayer = ToTFPlayer( GetOwner() );
	if ( pPlayer )
	{
		float flBuffDuration = 0;
		CALL_ATTRIB_HOOK_FLOAT( flBuffDuration, minicrit_boost_when_charged );
		if ( flBuffDuration > 0 )
		{
			pPlayer->m_Shared.AddCond( TF_COND_ENERGY_BUFF, flBuffDuration );
			m_flMinicritStartTime = gpGlobals->curtime;
		}
	}
}

#ifdef GAME_DLL
//-----------------------------------------------------------------------------
// Purpose: Update state when we score a hit with this weapon
//-----------------------------------------------------------------------------
void CTFChargedTYPEWRITER::ApplyOnHitAttributes( CBaseEntity *pVictimBaseEntity, CTFPlayer *pAttacker, const CTakeDamageInfo &info )
{
	BaseClass::ApplyOnHitAttributes( pVictimBaseEntity, pAttacker, info );
	if ( pAttacker )
	{
		CTFPlayer *pPlayer = ToTFPlayer( GetOwner() );
		if ( pPlayer && !pPlayer->m_Shared.InCond( TF_COND_ENERGY_BUFF ) )
		{
			float damage = info.GetDamage();
			float flChargeRate = 0.0f;
			CALL_ATTRIB_HOOK_FLOAT( flChargeRate, minicrit_boost_charge_rate );
			m_flMinicritCharge += damage * flChargeRate;
			if ( m_flMinicritCharge > DAMAGE_TO_FILL_MINICRIT_METER )
			{
				m_flMinicritCharge = DAMAGE_TO_FILL_MINICRIT_METER;
			}
		}
	}
}
#endif
