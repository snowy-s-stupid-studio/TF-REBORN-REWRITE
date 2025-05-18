::VIPShared <- class extends CustomCharacter
{
    deleteItems = true;
    mute = true;
    keepAfterDeath = false;
    keepAfterClassChange = false;

    lastNag = 0;
    playersOnCountCounter = 0;

    weaponPickupAntiLoop = false;
    teamPointOrigins = null; //[]

    function ApplyCharacter()
    {
        base.ApplyCharacter();
        local glowController = GlowController(player);
        OnSelfEvent("vip_gone", glowController.DestroyGlowController.bindenv(glowController));

        local myTeam = player.GetTeam();
        teamPointOrigins = [];
        for (local point; point = FindByClassname(point, "team_control_point");)
            if (myTeam != point.GetTeam())
                teamPointOrigins.push(point.GetOrigin());

        AddTimer(3, ProcessPointNag);
        AddTimer(0.2, ProcessWeaponPickupBlock); //todo tmp

        AddTimer(0.5, ProcessAntiSpawnAFK);
        OnGameEvent("OnTakeDamage", OnTakeDamageAntiSpawnAFK)
        OnGameEvent("teamplay_setup_finished", function()
        {
            afkHeartbeat = Time();
        })
    }

    function ProcessPointNag()
    {
        if (!player || !player.IsValid()) //todo tmp
            return;
        local pointPos = null;
        foreach (pointOrigin in teamPointOrigins)
        {
            playersOnCountCounter = 0;

            foreach (teammate in GetAlivePlayers(player.GetTeam()))
                if (teammate != player && (teammate.GetOrigin() - pointOrigin).Length() < 400)
                    playersOnCountCounter++;

            if (playersOnCountCounter >= 2)
                pointPos = pointOrigin;
        }

        if (playersOnCountCounter >= 2 && Time() - lastNag > 10 && pointPos && (player.GetOrigin() - pointPos).Length() > 600)
        {
            lastNag = Time();
            SendGlobalGameEvent("show_annotation",
            {
                worldPosX = pointPos.x,
                worldPosY = pointPos.y,
                worldPosZ = pointPos.z,
                id = 123,
                text = "Your team contests Point!",
                lifetime = 5,
                visibilityBitfield = 1 << player.entindex(),
                play_sound = "ui/hint.wav"
            });
            EmitSoundEx({
                sound_name = RandomElement([
                    "vo/announcer_am_capincite01.mp3",
                    "vo/announcer_am_capincite03.mp3"
                ]),
                entity = player,
                filter_type = RECIPIENT_FILTER_SINGLE_PLAYER,
                volume = 1,
                sound_level = 0
            });
        }
    }

    function ProcessWeaponPickupBlock()
    {
        if (!player || !player.IsValid()) //todo tmp
            return;
        for (local droppedWeapon = null, origin = player.GetOrigin(); droppedWeapon = FindByClassnameWithin(droppedWeapon, "tf_dropped_weapon", origin, 200);)
            droppedWeapon.Kill();

        local weapon = player.GetActiveWeapon();
        if (weapon && weapon != primary && weapon != secondary && weapon != melee)
            player.TakeDamageCustom(
                player,
                player,
                null,
                Vector(),
                Vector(),
                9999,
                TF_DMG_CUSTOM_TELEFRAG,
                DMG_PREVENT_PHYSICS_FORCE);
    }

    debuffs = [ //todo move to good place
        TF_COND_BURNING,
        TF_COND_URINE,
        TF_COND_MAD_MILK,
        TF_COND_BLEEDING,
        TF_COND_ENERGY_BUFF,
        TF_COND_CANNOT_SWITCH_FROM_MELEE,
        TF_COND_PHASE,
        TF_COND_PARACHUTE_DEPLOYED,
        TF_COND_PLAGUE
    ]

    function OnRegenerate(fakeRegenTrigger)
    {
        primary.SetClip1(MobsterTypeWriter.clip);
        secondary.SetClip1(1);
        SetPropIntArray(player, "m_iAmmo", MobsterTypeWriter.maxAmmo, primary.GetPrimaryAmmoType());
        SetPropIntArray(player, "m_iAmmo", 1, secondary.GetPrimaryAmmoType());

        player.SetHealth(player.GetMaxHealth());

        foreach (debuff in debuffs)
            player.RemoveCond(debuff);

        return 1;
    }


    // Anti Spawn AFK

    afkHeartbeat = Time();
    isInsideSpawn = false;

    function ProcessAntiSpawnAFK()
    {
        if (!player || !player.IsValid()) //todo tmp
            return;
        if (isRoundSetup)
            return;
        //local inSpawn = nav_area.HasAttributeTF(TF_NAV_SPAWN_ROOM_BLUE | TF_NAV_SPAWN_ROOM_RED);

        local inSpawn = false;
        local myPos = player.GetCenter();
        for (local spawnTrigger; spawnTrigger = FindByClassname(spawnTrigger, "func_respawnroom");)
        {
            spawnTrigger.RemoveSolidFlags(FSOLID_NOT_SOLID);
            spawnTrigger.SetCollisionGroup(COLLISION_GROUP_NONE);
            local trace = {
                start = myPos,
                end = myPos,
                mask  = 1
            }
            TraceLineEx(trace);
            spawnTrigger.AddSolidFlags(FSOLID_NOT_SOLID);
            spawnTrigger.SetCollisionGroup(25) //TFCOLLISION_GROUP_RESPAWNROOMS
            if (trace.hit && trace.enthit == spawnTrigger)
            {
                inSpawn = true;
                break;
            }
        }

        if (!inSpawn)
        {
            isInsideSpawn = false;
            return;
        }
        if (!isInsideSpawn)
        {
            isInsideSpawn = true;
            afkHeartbeat = Time();
        }
        if (Time() - afkHeartbeat > 30)
        {
            //todo jank code
            DispatchParticleEffect("mobster_smoke", player.GetCenter(), Vector());
            local playerA = player;
            ClearCustomCharacter();
            playerA.ForceRespawn();
            playerA.SetHealth(playerA.GetMaxHealth());
        }
    }

    function OnTakeDamageAntiSpawnAFK(victim, params)
    {
        if (victim == player || params.attacker == player)
            afkHeartbeat = Time();
    }
}