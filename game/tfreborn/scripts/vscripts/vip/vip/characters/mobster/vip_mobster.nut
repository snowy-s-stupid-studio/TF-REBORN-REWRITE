Include("vip/characters/mobster/mobster_weapons.nut");

::MobsterSoundBank <- class extends SoundBank
{
    recentMedicCallCount = 0;
    lastMedicTime = 0;

    function EmitVoiceLine(sound, params)
    {
        //Mobster's pain sounds don't need to be heard by half the server
        local sound = sound.tolower();
        if (startswith(sound, "pain"))
        {
            if (!RandomInt(0, 4))
                base.EmitVoiceLine(sound, params);
            return;
        }

        if (sound == "medic")
        {
            local time = Time();

            if (time - lastMedicTime < 10)
            {
                recentMedicCallCount++;
                if (recentMedicCallCount >= 3)
                {
                    sound = "MedicAngry";
                    recentMedicCallCount = 0;
                }
            }
            else
                recentMedicCallCount = 1;

            lastMedicTime = time;
        }

        //todo log error - why
        local myOrigin = player.GetOrigin();
        local restore = {};
        foreach(player in GetClients())
            if ((myOrigin - player.GetOrigin()).Length() < 512)
            {
                restore[player] <- player.GetOrigin();
                player.SetAbsOrigin(myOrigin);
            }

        base.EmitVoiceLine(sound, params);

        foreach (player, offset in restore)
            player.SetAbsOrigin(offset);
    }

    Medic = [
        "mvm/mobster_dev_r1a/mobster_medic01.mp3"
        "mvm/mobster_dev_r1a/mobster_medic02.mp3"
        "mvm/mobster_dev_r1a/mobster_medic03.mp3"
        "mvm/mobster_dev_r1a/mobster_medic04.mp3"
        "mvm/mobster_dev_r1a/mobster_medic05.mp3"
    ]

    medicfollow = [
        "mvm/mobster_dev_r1a/mobster_medic03.mp3"
        "mvm/mobster_dev_r1a/mobster_medicangry02.mp3"
        "mvm/mobster_dev_r1a/mobster_medicangry03.mp3"
    ]

    thanks = [
        "mvm/mobster_dev_r1a/mobster_thanks01.mp3"
        "mvm/mobster_dev_r1a/mobster_thanks02.mp3"
        "mvm/mobster_dev_r1a/mobster_thanks03.mp3"
        "mvm/mobster_dev_r1a/mobster_thanks04.mp3"
    ]
    go = [
        "mvm/mobster_dev_r1a/mobster_go01.mp3"
        "mvm/mobster_dev_r1a/mobster_go02.mp3"
        "mvm/mobster_dev_r1a/mobster_go03.mp3"
        "mvm/mobster_dev_r1a/mobster_go04.mp3"
        "mvm/mobster_dev_r1a/mobster_go05.mp3"
    ]
    moveup = [
        "mvm/mobster_dev_r1a/mobster_moveup01.mp3"
        "mvm/mobster_dev_r1a/mobster_moveup02.mp3"
    ]
    headleft = [
        "mvm/mobster_dev_r1a/mobster_headleft01.mp3"
    ]
    headright = [
        "mvm/mobster_dev_r1a/mobster_headright01.mp3"
    ]
    yes = [
        "mvm/mobster_dev_r1a/mobster_yes01.mp3"
        "mvm/mobster_dev_r1a/mobster_yes02.mp3"
        "mvm/mobster_dev_r1a/mobster_yes03.mp3"
        "mvm/mobster_dev_r1a/mobster_yes04.mp3"
    ]
    no = [
        "mvm/mobster_dev_r1a/mobster_no01.mp3"
        "mvm/mobster_dev_r1a/mobster_no02.mp3"
        "mvm/mobster_dev_r1a/mobster_no03.mp3"
        "mvm/mobster_dev_r1a/mobster_no04.mp3"

        "mvm/mobster_dev_r1a/mobster_norare01.mp3"
    ]
    incoming = [
        "mvm/mobster_dev_r1a/mobster_incoming01.mp3"
        "mvm/mobster_dev_r1a/mobster_incoming02.mp3"
        "mvm/mobster_dev_r1a/mobster_incoming03.mp3"
    ]

    cloakedspy = [
        "mvm/mobster_dev_r1a/mobster_cloakedspy01.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy02.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy03.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy04.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy05.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy06.mp3"
    ]
    //spy lines start
    //scout
    cloakedspyidentify01 = [
        "mvm/mobster_dev_r1a/mobster_cloakedspy01.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy02.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy03.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy04.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy05.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy06.mp3"
    ]
    //soldier
    cloakedspyidentify02 = [
        "mvm/mobster_dev_r1a/mobster_cloakedspy01.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy02.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy03.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy04.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy05.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy06.mp3"
    ]
    //heavy
    cloakedspyidentify03 = [
        "mvm/mobster_dev_r1a/mobster_cloakedspy01.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy02.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy03.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy04.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy05.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy06.mp3"
    ]
    //pyro
    cloakedspyidentify04 = [
        "mvm/mobster_dev_r1a/mobster_cloakedspy01.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy02.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy03.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy04.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy05.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy06.mp3"
    ]
    //demoman
    cloakedspyidentify05 = [
        "mvm/mobster_dev_r1a/mobster_cloakedspy01.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy02.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy03.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy04.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy05.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy06.mp3"
    ]
    //medic
    cloakedspyidentify06 = [
        "mvm/mobster_dev_r1a/mobster_cloakedspy01.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy02.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy03.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy04.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy05.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy06.mp3"
    ]
    //engineer
    cloakedspyidentify07 = [
        "mvm/mobster_dev_r1a/mobster_cloakedspy01.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy02.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy03.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy04.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy05.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy06.mp3"
    ]
    //sniper
    cloakedspyidentify08 = [
        "mvm/mobster_dev_r1a/mobster_cloakedspy01.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy02.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy03.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy04.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy05.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy06.mp3"
    ]
    //spy
    cloakedspyidentify09 = [
        "mvm/mobster_dev_r1a/mobster_cloakedspy01.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy02.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy03.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy04.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy05.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy06.mp3"
    ]
    //civilian
    cloakedspyidentify10 = [
        "mvm/mobster_dev_r1a/mobster_cloakedspy01.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy02.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy03.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy04.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy05.mp3"
        "mvm/mobster_dev_r1a/mobster_cloakedspy06.mp3"
    ]
    //spy lines end
    sentryahead = [
        "mvm/mobster_dev_r1a/mobster_sentryahead01.mp3"
        "mvm/mobster_dev_r1a/mobster_sentryahead02.mp3"
        "mvm/mobster_dev_r1a/mobster_sentryahead03.mp3"
        "mvm/mobster_dev_r1a/mobster_sentryahead04.mp3"
        "mvm/mobster_dev_r1a/mobster_sentryahead05.mp3"
    ]
    needteleporter = [
        "mvm/mobster_dev_r1a/mobster_needteleporter01.mp3"
        "mvm/mobster_dev_r1a/mobster_needteleporter02.mp3"
    ]
    needdispenser = [
        "mvm/mobster_dev_r1a/mobster_needdispenser01.mp3"
        "mvm/mobster_dev_r1a/mobster_needdispenser02.mp3"
        "mvm/mobster_dev_r1a/mobster_needdispenser03.mp3"
    ]
    needsentry = [
        "mvm/mobster_dev_r1a/mobster_needsentry01.mp3"
        "mvm/mobster_dev_r1a/mobster_needsentry02.mp3"
        "mvm/mobster_dev_r1a/mobster_needsentry03.mp3"
    ]
    activatecharge = [
        "mvm/mobster_dev_r1a/mobster_activatecharge01.mp3"
        "mvm/mobster_dev_r1a/mobster_activatecharge02.mp3"
        "mvm/mobster_dev_r1a/mobster_activatecharge03.mp3"
    ]
    helpme = [
        "mvm/mobster_dev_r1a/mobster_helpme01.mp3"
        "mvm/mobster_dev_r1a/mobster_helpme02.mp3"
        "mvm/mobster_dev_r1a/mobster_helpme03.mp3"
        "mvm/mobster_dev_r1a/mobster_helpme04.mp3"
        "mvm/mobster_dev_r1a/mobster_helpme05.mp3"
    ]
    helpmecapture = [
        "mvm/mobster_dev_r1a/mobster_helpmecapture01.mp3"
        "mvm/mobster_dev_r1a/mobster_helpmecapture02.mp3"
        "mvm/mobster_dev_r1a/mobster_helpmecapture03.mp3"
        "mvm/mobster_dev_r1a/mobster_helpmecapture04.mp3"
        "mvm/mobster_dev_r1a/mobster_helpmecapture05.mp3"
        "mvm/mobster_dev_r1a/mobster_helpmecapture06.mp3"
        "mvm/mobster_dev_r1a/mobster_helpmecapture07.mp3"
    ]
    helpmedefend = [
        "mvm/mobster_dev_r1a/mobster_helpmecapture01.mp3"
        "mvm/mobster_dev_r1a/mobster_helpmecapture02.mp3"
        "mvm/mobster_dev_r1a/mobster_helpmecapture03.mp3"
        "mvm/mobster_dev_r1a/mobster_helpmecapture04.mp3"
        "mvm/mobster_dev_r1a/mobster_helpmecapture05.mp3"
        "mvm/mobster_dev_r1a/mobster_helpmecapture06.mp3"
        "mvm/mobster_dev_r1a/mobster_helpmecapture07.mp3"
    ]
    battlecry = [
        "mvm/mobster_dev_r1a/mobster_battlecry01.mp3"
        "mvm/mobster_dev_r1a/mobster_battlecry02.mp3"
        "mvm/mobster_dev_r1a/mobster_battlecry03.mp3"
        "mvm/mobster_dev_r1a/mobster_battlecry04.mp3"
        "mvm/mobster_dev_r1a/mobster_battlecry05.mp3"
        "mvm/mobster_dev_r1a/mobster_battlecry06.mp3"
        "mvm/mobster_dev_r1a/mobster_battlecry07.mp3"
        "mvm/mobster_dev_r1a/mobster_battlecry08.mp3"
    ]
    meleedare = [
        "mvm/mobster_dev_r1a/mobster_meleedare01.mp3"
        "mvm/mobster_dev_r1a/mobster_meleedare02.mp3"
        "mvm/mobster_dev_r1a/mobster_meleedare03.mp3"
        "mvm/mobster_dev_r1a/mobster_meleedare04.mp3"
    ]
    cheers = [
        "mvm/mobster_dev_r1a/mobster_cheers01.mp3"
        "mvm/mobster_dev_r1a/mobster_cheers02.mp3"
        "mvm/mobster_dev_r1a/mobster_cheers03.mp3"
    ]
    jeers = [
        "mvm/mobster_dev_r1a/mobster_jeers01.mp3"
        "mvm/mobster_dev_r1a/mobster_jeers02.mp3"
        "mvm/mobster_dev_r1a/mobster_jeers03.mp3"
        "mvm/mobster_dev_r1a/mobster_jeers04.mp3"
    ]
    positivevocalization = [
        "mvm/mobster_dev_r1a/mobster_positivevocalization01.mp3"
        "mvm/mobster_dev_r1a/mobster_positivevocalization02.mp3"
        "mvm/mobster_dev_r1a/mobster_positivevocalization03.mp3"
        "mvm/mobster_dev_r1a/mobster_positivevocalization04.mp3"
        "mvm/mobster_dev_r1a/mobster_positivevocalization05.mp3"
        "mvm/mobster_dev_r1a/mobster_positivevocalization06.mp3"
    ]
    negativevocalization = [
        "mvm/mobster_dev_r1a/mobster_negativevocalization01.mp3"
        "mvm/mobster_dev_r1a/mobster_negativevocalization02.mp3"
        "mvm/mobster_dev_r1a/mobster_negativevocalization03.mp3"
        "mvm/mobster_dev_r1a/mobster_negativevocalization04.mp3"
    ]
    niceshot = [
        "mvm/mobster_dev_r1a/mobster_niceshot01.mp3"
        "mvm/mobster_dev_r1a/mobster_niceshot02.mp3"
        "mvm/mobster_dev_r1a/mobster_niceshot03.mp3"
    ]
    goodjob = [
        "mvm/mobster_dev_r1a/mobster_goodjob01.mp3"
        "mvm/mobster_dev_r1a/mobster_goodjob02.mp3"
        "mvm/mobster_dev_r1a/mobster_goodjob03.mp3"
    ]
    StandOnThePoint = [
        "mvm/mobster_dev_r1a/mobster_standonthepoint01.mp3"
        "mvm/mobster_dev_r1a/mobster_standonthepoint02.mp3"
        "mvm/mobster_dev_r1a/mobster_standonthepoint03.mp3"
    ]
    domination = [
        "mvm/mobster_dev_r1a/mobster_generickill01.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill02.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill03.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill04.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill05.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill06.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill07.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill08.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill09.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill10.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill11.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill12.mp3"
    ]
    PainCrticialDeath = [
        "mvm/mobster_dev_r1a/mobster_paincrticialdeath01.mp3"
        "mvm/mobster_dev_r1a/mobster_paincrticialdeath02.mp3"
        "mvm/mobster_dev_r1a/mobster_paincrticialdeath03.mp3"
    ]
    PainSevere = [
        "mvm/mobster_dev_r1a/mobster_painsevere01.mp3"
        "mvm/mobster_dev_r1a/mobster_painsevere02.mp3"
    ]
    PainSharp = [
        "mvm/mobster_dev_r1a/mobster_painsharp01.mp3"
        "mvm/mobster_dev_r1a/mobster_painsharp02.mp3"
        "mvm/mobster_dev_r1a/mobster_painsharp03.mp3"
        "mvm/mobster_dev_r1a/mobster_painsharp04.mp3"
        "mvm/mobster_dev_r1a/mobster_painsharp05.mp3"
        "mvm/mobster_dev_r1a/mobster_painsharp06.mp3"
        "mvm/mobster_dev_r1a/mobster_painsharp07.mp3"
    ]

    //custom lines
    MedicAngry = [
        "mvm/mobster_dev_r1a/mobster_medicangry01.mp3"
        "mvm/mobster_dev_r1a/mobster_medicangry02.mp3"
        "mvm/mobster_dev_r1a/mobster_medicangry03.mp3"
    ]
    LeaveSpawn = [
        "mvm/mobster_dev_r1a/mobster_leavespawn01.mp3"
        "mvm/mobster_dev_r1a/mobster_leavespawn02.mp3"
        "mvm/mobster_dev_r1a/mobster_leavespawn03.mp3"
    ]
    Robbery = [
        "mvm/mobster_dev_r1a/mobster_special01.mp3"
    ]
    Retry = [
        "mvm/mobster_dev_r1a/mobster_retry01.mp3"
    ]
    MeleeKill = [
        "mvm/mobster_dev_r1a/mobster_meleekill01.mp3"
        "mvm/mobster_dev_r1a/mobster_meleekill02.mp3"
        "mvm/mobster_dev_r1a/mobster_meleekill03.mp3"
    ]
    MeleeKillImmediate = [
        "mvm/mobster_dev_r1a/mobster_meleekillimmediate01.mp3"
        "mvm/mobster_dev_r1a/mobster_meleekillimmediate02.mp3"
        "mvm/mobster_dev_r1a/mobster_meleekillimmediate03.mp3"
    ]
    NoRare = [
        "mvm/mobster_dev_r1a/mobster_norare01.mp3"
    ]
    Laugh = [
        "mvm/mobster_dev_r1a/mobster_laugh01.mp3"
    ]
    //these play after kill, we need to remove that and make a unique line play when the civilian kills someone
    GenericKill = [
        "mvm/mobster_dev_r1a/mobster_generickill01.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill02.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill03.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill04.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill05.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill06.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill07.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill08.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill09.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill10.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill11.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill12.mp3"
        "mvm/mobster_dev_r1a/mobster_generickill13.mp3"
    ]
}

::VIPMobster <- class extends VIPShared
{
    playerClass = TF_CLASS_SCOUT;
    maxHealth = 500;
    model = "models/vip_mobster/player/mobster.mdl";
    scale = 1.2;
    soundBankClass = MobsterSoundBank;

    primary = null;
    secondary = null;
    melee = null;

    hp_bar1 = null;
    hp_bar2 = null;
    lastBarLength = -1;

    tauntsWithWeapons = [
        -1
    ];

    function ApplyCharacter()
    {
        base.ApplyCharacter();
        player.AddCustomAttribute("patient overheal penalty", 0.2, -1);
        player.AddCustomAttribute("airblast vulnerability multiplier", 0.4, -1);
        player.AddCustomAttribute("move speed bonus", 0.575, -1);
        player.AddCustomAttribute("no double jump", 1, -1);
        //player.AddCustomAttribute("override footstep sound set", 2, -1);

        primary = ProvideCustomWeapon(player, MobsterTypeWriter);
        secondary = ProvideCustomWeapon(player, MobsterMoneyBag);
        melee = ProvideCustomWeapon(player, MobsterLeadPipe);
        player.Weapon_Switch(primary); //todo revved heavy, medigun, etc

        CreateHPBar();

        OnGameEvent("player_death", OnPlayerDeath_CheckMeleeKillVoiceLines);
        OnSelfEvent("player_death", OnPlayerDeath_CheckDecapitation);
        OnSelfEvent("OnTakeDamage", OnTakeDamage_CheckForBackstab);

        RunWithDelay(RandomInt(1, 2), function()
        {
            EmitVoiceLine("LeaveSpawn");
        });
    }

    function OnPlayerDeath_CheckDecapitation(params)
    {
        if (params.customkill in TF_DMG_DECAPITATION_CUSTOMS)
        {
            //todo
        }
    }

    function OnPlayerDeath_CheckMeleeKillVoiceLines(params)
    {
        if ((params.damagebits & DMG_CLUB) && player == GetPlayerFromUserID(params.attacker))
        {
            switch(RandomInt(0, 2))
            {
                case 0:
                    RunWithDelay(0.4, EmitVoiceLine, "MeleeKillImmediate");
                    break;
                case 1:
                    RunWithDelay(2.0, EmitVoiceLine, "MeleeKill");
            }
        }
    }

    function OnTakeDamage_CheckForBackstab(params)
    {
        if (params.damage_custom != TF_DMG_CUSTOM_BACKSTAB)
            return;

        if (player.GetHealth() <= 400 || player.IsInvulnerable())
            return;

        local attacker = params.attacker;

        player.StunPlayerEx({
            stun_type = 2,
            stun_effects = false,
            stun_duration = 5,
            move_speed_reduction = 0.5,
            trigger_delay = -1,
            spawnflags = 1,
        });
        player.AddCondEx(TF_COND_HALLOWEEN_KART_DASH, 0.1, null);

        //Saving the Mobster from death
        SetPropInt(player, "m_lifeState", 1);
        OnTickEnd(function()
        {
            SetPropInt(player, "m_lifeState", 0);
            player.SetHealth(50);
        });

        local weaponScript = GetCustomWeapon(player.GetActiveWeapon());
        if (weaponScript)
            weaponScript.HideWorldModels();

        RunWithDelay(5, function()
        {
            local weaponScript = GetCustomWeapon(player.GetActiveWeapon());
            if (weaponScript)
                weaponScript.ShowWorldModels();
        })

        //Simulating Razorback
        local recoverTime = Time() + 2.0;
        attacker.AddCondEx(TF_COND_CANNOT_SWITCH_FROM_MELEE, 2, null);
        SetPropFloat(params.weapon, "m_flNextPrimaryAttack", recoverTime);
        SetPropFloat(attacker, "m_flNextAttack", recoverTime);
        SetPropFloat(attacker, "m_flStealthNextTraitTime", recoverTime);
        EmitSoundOn("Player.Spy_Shield_Break", player);

        local viewmodel = GetPropEntity(attacker, "m_hViewModel");
        if (viewmodel)
            viewmodel.ResetSequence(viewmodel.LookupSequence("knife_stun"));
    }

    function CreateHPBar()
    {
        hp_bar1 = SpawnEntityFromTable("point_worldtext",
        {
            font = 5,
            orientation = 1,
            textspacingX = -10,
            textsize = 20,
            color = "0 255 255 255",
            origin = player.EyePosition() + Vector(0, 0, 25)
        });
        hp_bar1.AcceptInput("SetParent", "!activator", player, player);

        hp_bar2 = SpawnEntityFromTable("point_worldtext",
        {
            font = 5,
            orientation = 1,
            textspacingX = -10,
            textsize = 20,
            color = "64 0 0 255",
            origin = player.EyePosition() + Vector(0, 0, 25)
        });
        hp_bar2.AcceptInput("SetParent", "!activator", player, player);

        OnSelfEvent("player_hurt", UpdateHPBar);
        OnTickEnd(UpdateHPBar);
        AddTimer(0.1, UpdateHPBar);
    }

    function UpdateHPBar()
    {
        if (!player || !player.IsValid()) //todo tmp
            return;
        local hpLength = ((player.GetHealth() - 1) * 16 / player.GetMaxHealth()) + 1;
        if (hpLength == lastBarLength)
            return;
        lastBarLength = hpLength;
        local str1 = "";
        local str2 = "";
        for (local i = 0; i < hpLength; i++)
        {
            str1 += ".";
            str2 += " ";
        }
        for (local i = hpLength; i < 15; i++)
        {
            str1 += " ";
            str2 += ".";
        }
        str1 += "   ";
        str2 += "   ";
        hp_bar1.AcceptInput("SetText", str1, null, null);
        hp_bar1.AcceptInput("SetColor", GetHealthGlowColor(), null, null);
        hp_bar2.AcceptInput("SetText", str2, null, null);
    }

    function GetHealthGlowColor()
    {
        local healthRatio = player.GetHealth() / player.GetMaxHealth().tofloat();
        if (healthRatio > 0.6)
            return "85 191 58 255"; //RGBA 0.33 0.75 0.23 1.00
		else if(healthRatio > 0.3)
            return "191 171 58 255"; //RGBA 0.75 0.72 0.23 1.00
        return "191 58 58 255";     //RGBA 0.75 0.23 0.23 1.00
    }

    tauntsSpeedups = {
        "1106": 0.7
        //"1107": 0.7
        //"1107": 0.7
        //"1118" : 0.2057971014492754
        //"1157" : 0.2057971014492754
        //"463" : 10.2057971014492754
        "1182": 1.08
    }

    function OnTauntStart()
    {
        local taundId = GetPropInt(player, "m_iTauntItemDefIndex");
        if (tauntsWithWeapons.find(taundId) == null)
        {
            local weaponScript = GetCustomWeapon(player.GetActiveWeapon());
            if (weaponScript)
                weaponScript.HideWorldModels();
        }
        if (taundId == 463) //Schadenfreude
        {
            EmitVoiceLine("laugh")
        }
        if (taundId.tostring() in tauntsSpeedups)
        {
            local speed = tauntsSpeedups[taundId.tostring()];
            player.AddCustomAttribute("gesture speed increase", speed, -1);

            /*local taunt_weapon = CreateByClassname("tf_weapon_bat");
            local active_weapon = player.GetActiveWeapon();
            player.StopTaunt(true);
            player.RemoveCond(7);
            SetPropInt(taunt_weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", taundId);
            SetPropBool(taunt_weapon, "m_AttributeManager.m_Item.m_bInitialized", true);
            SetPropBool(taunt_weapon, "m_bForcePurgeFixedupStrings", true);
            SetPropEntity(player, "m_hActiveWeapon", taunt_weapon);
            SetPropInt(player, "m_iFOV", 0);
            player.HandleTauntCommand(0);
            SetPropEntity(player, "m_hActiveWeapon", active_weapon);
            taunt_weapon.Kill();*/
        }
        AddTimer(-1, OnTauntTick);
    }

    function OnTauntTick()
    {
        if (!player || !player.IsTaunting())
            return;
        local tauntPartner = GetPropEntity(player, "m_hHighFivePartner");
        if (!tauntPartner)
            return;
        local taundId = GetPropInt(player, "m_iTauntItemDefIndex");
        local partnerTauntId = GetPropInt(tauntPartner, "m_iTauntItemDefIndex");
        if (taundId == 1106) // Square Dance
        {
            player.RemoveCustomAttribute("gesture speed increase");
            return TIMER_DELETE;
        }
        if (partnerTauntId == 1107) // Flippin' Awesome
        {
            RunWithDelay(1.8, function() {
                ScreenShake(player.GetOrigin(), 4, 5, 0.5, 1200, 0, true);
            })
            return TIMER_DELETE;
        }
    }

    function OnTauntStop()
    {
        if (!player || !player.IsValid()) //todo tmp
            return;
        player.RemoveCustomAttribute("gesture speed increase");
        local weaponScript = GetCustomWeapon(player.GetActiveWeapon());
        if (weaponScript)
            weaponScript.ShowWorldModels();
    }
}