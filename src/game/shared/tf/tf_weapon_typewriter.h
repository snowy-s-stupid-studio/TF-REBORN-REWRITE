//========= Copyright Valve Corporation, All rights reserved. ============//
//
//=============================================================================
#ifndef TF_WEAPON_TYPEWRITER_H
#define TF_WEAPON_TYPEWRITER_H
#ifdef _WIN32
#pragma once
#endif

#include "tf_weaponbase_gun.h"

// Client specific.
#ifdef CLIENT_DLL
#define CTFTYPEWRITER C_TFTYPEWRITER
#define CTFChargedTYPEWRITER C_TFTYPEWRITER
class C_TFTYPEWRITER; // Forward declaration for client builds
#else
#define CTFTYPEWRITER CTFTYPEWRITER // Ensure CTFTYPEWRITER is defined for server builds as well
#endif

//=============================================================================
//
// TF Weapon Sub-machine gun.
//
class CTFTYPEWRITER : public CTFWeaponBaseGun
{
public:

	DECLARE_CLASS(CTFTYPEWRITER, CTFWeaponBaseGun);
	DECLARE_NETWORKCLASS();
	DECLARE_PREDICTABLE();

#ifdef GAME_DLL
	DECLARE_DATADESC();
#endif

	CTFTYPEWRITER() {}
	~CTFTYPEWRITER() {}

	virtual int		GetWeaponID(void) const { return TF_WEAPON_SMG; }

	virtual int		GetDamageType(void) const;
	virtual bool	CanFireCriticalShot(bool bIsHeadshot, CBaseEntity* pTarget = NULL) OVERRIDE;

	bool			CanHeadshot(void) const { int iMode = 0; CALL_ATTRIB_HOOK_INT(iMode, set_weapon_mode); return (iMode == 1); };

private:

	CTFTYPEWRITER(const CTFTYPEWRITER&) {}
};

#endif // TF_WEAPON_TYPEWRITER_H