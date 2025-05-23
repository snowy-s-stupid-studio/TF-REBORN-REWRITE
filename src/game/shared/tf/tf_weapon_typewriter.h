//========= Copyright Valve Corporation, All rights reserved. ============//
//
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
#define CTFTYPEWRITER C_TFChargedTYPEWRITER
#define CTFChargedTYPEWRITER C_TFTYPEWRITER
#endif

//=============================================================================
//
// TF Weapon Sub-machine gun.
//
class CTFTYPEWRITER : public CTFWeaponBaseGun
{
public:

	DECLARE_CLASS( CTFTYPEWRITER, CTFWeaponBaseGun );
	DECLARE_NETWORKCLASS(); 
	DECLARE_PREDICTABLE();

// Server specific.
#ifdef GAME_DLL
	DECLARE_DATADESC();
#endif

	CTFTYPEWRITER() {}
	~CTFTYPEWRITER() {}

	virtual int		GetWeaponID( void ) const			{ return TF_WEAPON_SMG; }

	virtual int		GetDamageType( void ) const;
	virtual bool	CanFireCriticalShot( bool bIsHeadshot, CBaseEntity *pTarget = NULL ) OVERRIDE;

	bool			CanHeadshot( void ) const { int iMode = 0; CALL_ATTRIB_HOOK_INT( iMode, set_weapon_mode ); return (iMode == 1); };

private:

	CTFTYPEWRITER( const CTFTYPEWRITER& ) {}
};

//=============================================================================
//
// TF Weapon Charged Sub-machine gun.
//
class CTFChargedTYPEWRITER : public CTFTYPEWRITER
{
public:
	DECLARE_CLASS( CTFCharged_TYPEWRITER, CTFTYPEWRITER);
	DECLARE_NETWORKCLASS();
	DECLARE_PREDICTABLE();

	// Server specific.
#ifdef GAME_DLL
	DECLARE_DATADESC();
#endif

	CTFChargedTYPEWRITER() {}
	~CTFChargedTYPEWRITER() {}

	virtual int		GetWeaponID( void ) const			{ return TF_WEAPON_CHARGED_TYPEWRITER; }

	const char*		GetEffectLabelText( void ) { return "#TF_SmgCharge"; }
	float			GetProgress( void );
	bool			ShouldFlashChargeBar();
	void			SecondaryAttack() OVERRIDE;
	bool			CanPerformSecondaryAttack() const OVERRIDE;
	void			WeaponReset() OVERRIDE;

#ifdef GAME_DLL
	void	ApplyOnHitAttributes( CBaseEntity *pVictimBaseEntity, CTFPlayer *pAttacker, const CTakeDamageInfo &info ) OVERRIDE;
#endif

protected:
	CNetworkVar( float, m_flMinicritCharge );

	float m_flMinicritStartTime;

private:
	CTFChargedTYPEWRITER( const CTFChargedTYPEWRITER& ) {}
};


#endif // TF_WEAPON_TYPEWRITER_H
