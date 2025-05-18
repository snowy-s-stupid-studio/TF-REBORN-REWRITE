PrecacheScriptSound("VIPMobster.Typewriter.Single");
PrecacheScriptSound("VIPMobster.Typewriter.SingleLow");
PrecacheScriptSound("VIPMobster.Typewriter.SingleCrit");
PrecacheScriptSound("VIPMobster.Typewriter.SingleLowCrit");
PrecacheScriptSound("VIPMobster.Typewriter.NoAmmo");
PrecacheModel("models/vip_mobster/weapons/w_moneybag_open.mdl");
PrecacheSound("vip_mobster_brooklynn_r1a/moneybag_resist.mp3")
PrecacheSound("vip_mobster_brooklynn_r1a/moneybag_hitsound.mp3")

class ::MobsterTypeWriter extends CustomWeaponBase
{
    baseclass = "tf_weapon_handgun_scout_primary";
    baseid = 220;
    viewModels = [
        "models/vip_mobster/weapons/v_typewriter.mdl",
        "models/vip_mobster/weapons/c_mobster_arms.mdl"
    ];
    worldModels = [
        "models/vip_mobster/weapons/w_typewriter.mdl"
    ];
    cigarModelIndex = PrecacheModel("models/vip_mobster/weapons/w_stoogie.mdl");
    clip = 40;
    maxAmmo = 200;
    mute = true;

    needToPlayEmptyClipSFX = 0;
    isFiringCrits = false;
    nextShoveTime = 0;
    hCigarModel = null;

    function OnEquip()
    {
        weapon.AddAttribute("bullets per shot bonus", 0.75, -1);
        weapon.AddAttribute("fire rate bonus", 0.34, -1);
        weapon.AddAttribute("damage bonus HIDDEN", 0.55, -1);
        weapon.AddAttribute("Reload time increased", 1.33, -1);
        weapon.AddAttribute("dmg bonus vs buildings", 1.25, -1);
        weapon.AddAttribute("particle effect use head origin", 1, -1);
        weapon.AddAttribute("particle effect vertical offset", -9999, -1);

        //AddTimer(-1, ProcessShove);
        AddTimer(0.05, ProcessEmptyAmmoSFX);
        OnGameEvent("OnWorldHit", function(params)
        {
            if (weapon == params.weapon)
                isFiringCrits = params.damage_type & DMG_CRIT;
        });
    }

    function OnFire()
    {
        player.ViewPunch(QAngle(-0.3, 0, 0));

        local isLow = weapon.Clip1() <= 10;
        local firingSound;
        if (isFiringCrits)
        {
            if (isLow)
                firingSound = "VIPMobster.Typewriter.SingleLowCrit"
            else
                firingSound = "VIPMobster.Typewriter.SingleCrit"
        }
        else if (isLow)
            firingSound = "VIPMobster.Typewriter.SingleLow"
        else
            firingSound = "VIPMobster.Typewriter.Single"

        EmitSoundEx({
            sound_name = firingSound,
            volume = 1,
            sound_level = 94,
            entity = player,
            speaker_entity = player
        });

        /*local gunModel = hWorldModels[0];
        if (gunModel && gunModel.IsValid())
        {
            local particle = SpawnEntityFromTable("info_particle_system", {
                effect_name = "muzzle_bignasty",
                start_active = 0
            });
            particle.AcceptInput("SetParent", "!activator", gunModel, gunModel);
            particle.AcceptInput("SetParentAttachment", "muzzle", null, null);
            EntFireByHandle(particle, "Start", "", 0.1, null, null);
            EntFireByHandle(particle, "Kill", "", 1, null, null);
        }*/ //todo visible for the Mobster himself
    }

    function OnDamage(victim, params)
    {
        isFiringCrits = params.damage_type & DMG_CRIT;

        //Making the <s>Shortstop</s> Typewriter Shove do 65 damage instead of 1.
        if (params.damage_type & DMG_MELEE)
        {
            params.damage = 65;
            params.damage_type = params.damage_type | DMG_PREVENT_PHYSICS_FORCE;
        }
    }

    function ProcessShove()
    {
        //if (!(GetPropInt(player, "m_nButtons") & IN_ATTACK2))
        //    return;
        local time = Time();
        //if (time < nextShoveTime)
        //    return;
        nextShoveTime = time + 1.5;
        //SetPropFloat(weapon, "m_flNextAttack", Time()+10);
        SetPropFloat(weapon, "m_flNextAttack", 0);
        SetPropFloat(weapon, "m_flNextPrimaryAttack", 0);
        SetPropFloat(weapon, "m_flNextSecondaryAttack", 0);
    }

    function OnTauntStart()
    {
        if (!GetPropEntity(player, "m_hHighFivePartner") && GetPropInt(player, "m_iTauntItemDefIndex") == -1)
        {
            local hasCigar = hCigarModel && hCigarModel.IsValid();
            KillIfValid(hCigarModel);
            hCigarModel = charScript.CreateWorldModel(cigarModelIndex);

            player.StopTaunt(true);
            player.RemoveCond(TF_COND_TAUNTING);
            //player.AddCustomAttribute("gesture speed increase", 0.752, -1);
            player.AddCustomAttribute("gesture speed increase", 0.533, -1);
            weapon.KeyValueFromString("classname", "tf_weapon_scattergun");
            SetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", hasCigar ? 13 : 45);
            player.HandleTauntCommand(0);
            weapon.KeyValueFromString("classname", "tf_weapon_handgun_scout_primary");
            SetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", 220);
        }
    }

    function OnTauntStop()
    {
        player.RemoveCustomAttribute("gesture speed increase");
    }

    function ProcessEmptyAmmoSFX()
    {
        if (!player || !player.IsValid() || !weapon || !weapon.IsValid()) //todo tmp
            return;
        if (weapon.Clip1() > 0)
        {
            needToPlayEmptyClipSFX = true;
            return;
        }
        if (!needToPlayEmptyClipSFX)
            return;
        needToPlayEmptyClipSFX = false;

        EmitSoundEx({
            sound_name = "VIPMobster.Typewriter.NoAmmo",
            entity = player,
            channel = 6,
            sound_level = 90
        });
    }

    /*glowController = null;

    function OnSwitchTo()
    {
        printl("!OnSwitchTo "+hWorldModels[0])
        glowController = GlowController(hWorldModels[0]);
    }

    function OnSwitchFrom()
    {
        printl("!OnSwitchFrom "+glowController)
        if (glowController)
            glowController.DestroyGlowController();
        glowController = null;
    }*/
};

class ::MobsterLeadPipe extends CustomWeaponBase
{
    baseclass = "tf_weapon_shovel";
    baseid = 450;
    viewModels = [
        "models/vip_mobster/weapons/v_leadpipe.mdl",
        "models/vip_mobster/weapons/c_mobster_arms.mdl"
    ];
    worldModels = [
        "models/vip_mobster/weapons/w_leadpipe.mdl"
    ];

    modelState = 0;

    function OnEquip()
    {
        weapon.AddAttribute("dmg penalty vs players", 1, -1);
        weapon.AddAttribute("single wep deploy time increased", 1, -1);
    }

    function OnTauntStart()
    {
        if (!GetPropEntity(player, "m_hHighFivePartner") && GetPropInt(player, "m_iTauntItemDefIndex") == -1)
        {
            player.StopTaunt(true);
            player.RemoveCond(TF_COND_TAUNTING);
            player.AddCustomAttribute("gesture speed increase", 1.27, -1);
            player.HandleTauntCommand(0);
        }
    }

    function OnTauntStop()
    {
        player.RemoveCustomAttribute("gesture speed increase");
    }

    function OnDamage(victim, params)
    {
        local newValue = params.damage_type & DMG_CRIT || params.damage >= victim.GetHealth() ? 2 : 1;
        if (newValue > modelState)
        {
            hViewModels[0].SetBodygroup(0, newValue);
            modelState = newValue;
        }
    }
};

class ::MobsterMoneyBag extends CustomWeaponBase
{
    baseclass = "tf_weapon_cleaver";
    baseid = 812;
    viewModels = [
        "models/vip_mobster/weapons/v_moneybag.mdl",
        "models/vip_mobster/weapons/c_mobster_arms.mdl"
    ];
    worldModels = [
        "models/vip_mobster/weapons/w_moneybag_closed.mdl"
    ];

    function OnEquip()
    {
        SetPropIntArray(player, "m_iAmmo", 1, weapon.GetPrimaryAmmoType());
        weapon.AddAttribute("effect bar recharge rate increased", 6, -1);
        weapon.AddAttribute("killstreak_tier", 1, -1);
    }

    function OnFire()
    {
        AddTimer(-1, ProcessKillingCleaverProjectile, Time() + 3);

        RunWithDelay(0.2, function() {
            MoneyBagProjectile(player);
            hViewModels[0].DisableDraw();
            hWorldModels[0].DisableDraw();
        });
    }

    function ProcessKillingCleaverProjectile(endTime)
    {
        if (Time() > endTime)
            return TIMER_DELETE;
        for (local projectile = null; projectile = FindByClassnameWithin(projectile, "tf_projectile_cleaver", player.GetCenter(), 128);)
        {
            if (GetPropEntity(projectile, "m_hThrower") == player)
            {
                projectile.Kill();
                return TIMER_DELETE;
            }
        }
    }

    function OnDamage(victim, params)
    {
        params.damage = 0;
        params.early_out = true;
    }
};

class ::MoneyBagFountain
{
    model = "models/vip_mobster/weapons/w_moneybag_open.mdl";
    deploySound = "VIPMobster.MoneyBag.Deploy";
    particle = "utaunt_cash_confetti";
    duration = 5.0;

    hMoneyBagOwner = null;
    hPropDynamic = null;
    team = 0;

    affectedPlayers = null; //{}

    constructor(hMoneyBagOwner, origin)
    {
        this.hMoneyBagOwner = hMoneyBagOwner;
        this.team = hMoneyBagOwner.GetTeam();
        affectedPlayers = {};

        hPropDynamic = SpawnEntityFromTable("prop_dynamic",
        {
            origin = origin,
            model = model
        });
        hPropDynamic.SetOwner(hMoneyBagOwner);
        hPropDynamic.ValidateScriptScope();
        hPropDynamic.GetScriptScope().script <- this;
        EntFireByHandle(hPropDynamic, "Kill", null, duration, null, null);

        PrecacheScriptSound(deploySound);
        EmitSoundEx({
            sound_name = deploySound,
            entity = hPropDynamic,
            volume = 1,
            sound_level = 90
        });

        EntFireByHandle(SpawnEntityFromTable("info_particle_system",
        {
            origin = hPropDynamic.GetOrigin(),
            effect_name = "weapon_moneybag_parent",
            start_active = 1
        }), "SetParent", "!activator", -1, hPropDynamic, hPropDynamic);

        AddTimer(0.2, TickMoneyBagFountain);
    }

    function TickMoneyBagFountain()
    {
        if (!hPropDynamic || !hPropDynamic.IsValid())
        {
            underMoneyBagEffect.clear();
            return TIMER_DELETE;
        }

        local myPos = hPropDynamic.GetOrigin() + Vector(0, 0, 20);
        foreach (teammate in GetAlivePlayers())
        {
            local tTeam = teammate.GetTeam();
            if (tTeam != team && !teammate.InCond(TF_COND_DISGUISED))
                continue;
            local eyePos = teammate.EyePosition();
            if ((myPos - eyePos).Length() < 375 && TraceLine(myPos, eyePos, null) > 0.95)
            {
                if (teammate in affectedPlayers)
                    affectedPlayers[teammate].expireTime = Time() + 1;
                else
                    affectedPlayers[teammate] <- MoneyBagEffect(hMoneyBagOwner, teammate);
            }
        }
    }
}

::underMoneyBagEffect <- player_table();

class ::MoneyBagEffect
{
    hEffectCarrier = null;
    hMoneyBagOwner = null;

    expireTime = null;

    constructor(hMoneyBagOwner, hEffectCarrier)
    {
        this.hEffectCarrier = hEffectCarrier;
        this.hMoneyBagOwner = hMoneyBagOwner;
        expireTime = Time() + 1;
        underMoneyBagEffect[hEffectCarrier] <- 1;

        AddTimer(0.2, Think);
        OnGameEvent("OnTakeDamage", 1, OnTakeDamage)
        OnGameEvent("player_hurt", 0, OnPlayerHurt)
    }

    function Think()
    {
        if (!hEffectCarrier || !hEffectCarrier.IsValid() || Time() > expireTime) //todo
        {
            if (hEffectCarrier in underMoneyBagEffect)
                delete underMoneyBagEffect[hEffectCarrier];
            return;
        }

        hEffectCarrier.Heal(hEffectCarrier.GetMaxHealth() * 0.03, false);
    }

    function OnTakeDamage(victim, params)
    {
        if (params.early_out)
            return;
        if (victim == hEffectCarrier)
        {
            PlayDamageResistMoneySound(victim);
            params.damage *= 0.85;
        }
        else if (params.attacker == hEffectCarrier)
        {
            params.damage *= 1.15;
            EmitSoundEx({
                sound_name = "vip_mobster_brooklynn_r1a/moneybag_hitsound.mp3",
                entity = params.attacker,
                filter_type = RECIPIENT_FILTER_SINGLE_PLAYER,
                volume = 0.15,
                sound_level = 0
            });
        }
    }

    //This is to grant the assist to the VIP. It doesn't actually make people take increased damage.
    function OnPlayerHurt(victim, params)
    {
        if (victim.GetHealth() > 0)
            return;

        local attacker = GetPlayerFromUserID(params.attacker);
        if (!attacker || hEffectCarrier != attacker || attacker == hMoneyBagOwner)
            return;

        victim.StunPlayer(0, 0, 2, hMoneyBagOwner);
        victim.StopSound("TFPlayer.StunImpact");
        attacker.StopSound("TFPlayer.StunImpact");
    }
}

class ::MoneyBagProjectile
{
    model = "models/vip_mobster/weapons/w_moneybag_closed.mdl";
    moneyBagFountainClass = MoneyBagFountain;

    hPhysProp = null;
    hAirblastDetector = null;
    hOwner = null;

    constructor(hOwner)
    {
        this.hOwner = hOwner;
        local forwardOffset = hOwner.EyeAngles().Forward() * 50;
        local forwardVelocity = CalcThrowVelocity();

        hPhysProp = SpawnEntityFromTable("prop_physics_override", {
            model = model,
            origin = hOwner.EyePosition() + forwardOffset,
            spawnflags = 4,
            massscale = 5
        });
        hPhysProp.SetModelScale(1.4, -1);
        hPhysProp.SetPhysVelocity(forwardVelocity);
        hPhysProp.SetPhysAngularVelocity(Vector(-550, -550, 50));
        hPhysProp.AcceptInput("DisableFloating", null, null, null);

        hPhysProp.ValidateScriptScope();
        hPhysProp.GetScriptScope().script <- this;

        RunWithDelay(0.1, function()
        {
            if (hPhysProp && hPhysProp.IsValid())
                hPhysProp.SetPhysVelocity(forwardVelocity);
        });

        /*hAirblastDetector = CreateByClassname("tf_projectile_cleaver");
        hAirblastDetector.SetAbsOrigin(hPhysProp.GetCenter());
        SetPropInt(hAirblastDetector, "m_fEffects", 129);
        SetPropInt(hAirblastDetector, "m_nNextThinkTick", 0x7FFFFFFF);
        hAirblastDetector.SetSolid(0);
        hAirblastDetector.SetMoveType(0, 0);
        hAirblastDetector.DispatchSpawn();
        hAirblastDetector.SetModelSimple("models/empty.mdl");
        hAirblastDetector.SetTeam(hOwner.GetTeam());
        hAirblastDetector.AcceptInput("SetParent", "!activator", hPhysProp, hPhysProp);*/
        //todo restore

        AddTimer(-1, TickMoneyBagProjectile);
        EntFireByHandle(hPhysProp, "Kill", null, 15, null, null);
    }

    function CalcThrowVelocity()
    {
        return hOwner.EyeAngles().Forward() * 4400 + Vector(0, 0, 200);
    }

    function TickMoneyBagProjectile()
    {
        if (hAirblastDetector && GetPropInt(hAirblastDetector, "m_iDeflected") > 0)
        {
            OnDeflect(GetPropEntity(hAirblastDetector, "m_hDeflectOwner"));
            hAirblastDetector.Kill();
            hAirblastDetector = null;
        }

        if (hPhysProp && hPhysProp.IsValid())
        {
            local myPos = hPhysProp.GetOrigin();
            local fraction = TraceLine(myPos, myPos - Vector(0, 0, 25), null);
            if (fraction < 0.98)
            {
                hPhysProp.Kill();
                local groundPos = myPos - Vector(0, 0, 25) * fraction;
                moneyBagFountainClass(hOwner, groundPos);
            }
        }
    }

    function OnDeflect(deflectOwner)
    {
        printl("OnDeflect! "+deflectOwner);
    }
}

::moneydmgresthing <- player_table();

::PlayDamageResistMoneySound <- function(player)
{
    local time = Time();
    if (player in moneydmgresthing && time - moneydmgresthing[player] <= 0.1 )
        return;

    EmitSoundEx({
        sound_name = "vip_mobster_brooklynn_r1a/moneybag_resist.mp3",
        entity = player,
        volume = 1
        sound_level = 45
    });
    moneydmgresthing[player] <- time;
}