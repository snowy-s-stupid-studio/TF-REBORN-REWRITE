//========= Copyright Valve Corporation, All rights reserved. ============//
//======== Copyright Snowy's stupid studio, all rights reserved. =========//
// haha crediting myself and putting a fake copyright is so funny
//
//=============================================================================
#include "cbase.h"
#include "tf_weapon_typewriter.h"

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