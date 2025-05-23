::VIPMercCharacter <- class extends CustomCharacter
{
    setupLinesPlayedInTotal = [0];

    //Definitions
    deleteItems = false;
    mute = false;
    keepAfterDeath = false;
    keepAfterClassChange = false;
    cleanAttachments = false;
    lastTimePlayedDamageResSound = 0;

    function ApplyCharacter()
    {
        base.ApplyCharacter();

        AddTimer(RandomFloat(0.49, 0.51), TickEnemyLocationVO);
        RemovePyrovision();
    }

    function RemovePyrovision()
    {
        foreach(item in player.GetWeaponsAndCosmetics())
	        item.AddAttribute("vision opt in flags", 0, -1);
    }

    function OnRegenerate(fakeRegenTrigger)
    {
        return 0;
    }

    //======================================
    //Enemy location lines
    //======================================

    tickInverval = 0.5;
    sharedPlayInterval = 20;
    sharedPlayPool = 3;
    lastTimeBossWasInSightline = Time() + 16 + 10;
    lastTimeLookedAtBoss = Time() + 16 + 10;
    lastTimePlayedLine = {};

    function TickEnemyLocationVO()
    {
        local boss = FindVIP(player.GetEnemyTeam());
        if (!boss)
            return;
        local time = Time();

        local myEyePos = player.EyePosition();
        local bossCenter = boss.GetCenter();

        //Checking light of sight between this player and Boss
        if (TraceLine(myEyePos, bossCenter, null) < 0.99)
            return;

        local deltaVector = bossCenter - myEyePos;
        local playerEyes = player.EyeAngles().Forward();

        if (!ShouldPlayVoiceLine(time))
        {
            lastTimeBossWasInSightline = time;
            deltaVector.Norm();
            if (playerEyes.Dot(deltaVector) > 0.3)
                lastTimeLookedAtBoss = lastTimeBossWasInSightline;
            return;
        }

        local deltaVectorXY = Vector(deltaVector.x, deltaVector.y, 0);
        local playerEyesXY = Vector(playerEyes.x, playerEyes.y, 0);

        deltaVector.Norm();
        playerEyes.Norm();
        deltaVectorXY.Norm();
        playerEyesXY.Norm();

        local dotXY = playerEyesXY.Dot(deltaVectorXY);
        local deltaZ = boss.IsOnGround() ? 0 : deltaVector.z;
        local timeWithNoSightline = time - lastTimeBossWasInSightline;
        local timeNotLookedAtBoss = time - lastTimeLookedAtBoss;

        /*if (deltaZ > 0.3 && timeNotLookedAtBoss > 4 && deltaVectorXY.Length() < 1300)
        {
        }
        else if (dotXY < -0.3 && timeNotLookedAtBoss > 7 && deltaVector.Length() < 1300)
        {
        }
        else*/ if (dotXY > 0.2 && timeWithNoSightline > 7)
        {
            lastTimePlayedLine[player] <- time;
            EmitVoiceLine("contact", {
                filter_type = RECIPIENT_FILTER_TEAM,
                filter_param = player.GetTeam()
            });
        }

        lastTimeBossWasInSightline = time;
        if (dotXY > 0.3)
            lastTimeLookedAtBoss = lastTimeBossWasInSightline;
    }

    function ShouldPlayVoiceLine(time)
    {
        if (lastTimePlayedLine.len() > 200) //Easy anti-memory leak fix
            lastTimePlayedLine = {};
        local playSlotsOccupied = 0;
        foreach (teammate, lastPlayTime in lastTimePlayedLine)
            if (time - lastPlayTime < sharedPlayInterval
                && (++playSlotsOccupied >= sharedPlayPool || player == teammate || time - lastPlayTime < 3))
                    return false;
        return true;
    }
}

::VIPEngineerSoundBank <- class extends SoundBank
{
    contact = [
        "vo/mercs_dev_r1a/engineer_contact_01.mp3"
        "vo/mercs_dev_r1a/engineer_contact_02.mp3"
    ]
}

::VIPEngineer <- class extends VIPMercCharacter
{
    soundBankClass = VIPEngineerSoundBank;
    lastBlueprintTracked = null;

    function ApplyCharacter()
    {
        base.ApplyCharacter();

        if ("VIPMobster" in ROOT)
            AddTimer(-1, CheckTeleporter);
    }

    function CheckTeleporter()
    {
        local weapon = player.GetActiveWeapon();
        if (GetPropInt(weapon, "m_iObjectType") != 1) //OBJ_TELEPORTER
            return;

        local buildingBlueprint = GetPropEntity(weapon, "m_hObjectBeingBuilt");

        if (lastBlueprintTracked != buildingBlueprint)
        {
            lastBlueprintTracked = buildingBlueprint;
            SetPropVector(buildingBlueprint, "m_vecBuildMins", Vector(-29, -29, 0.0));
            SetPropVector(buildingBlueprint, "m_vecBuildMaxs", Vector(29, 29, 99));
        }
    }
}

::VIPDemoSoundBank <- class extends SoundBank
{
    contact = [
        "vo/mercs_dev_r1a/demo_contact_01.mp3"
    ]
}

::VIPDemo <- class extends VIPMercCharacter
{
    soundBankClass = VIPDemoSoundBank;
}

::VIPHeavySoundBank <- class extends SoundBank
{
    contact = [
        "vo/mercs_dev_r1a/heavy_contact_01.mp3"
        "vo/mercs_dev_r1a/heavy_contact_02.mp3"
        "vo/mercs_dev_r1a/heavy_contact_03.mp3"
        "vo/mercs_dev_r1a/heavy_contact_04.mp3"
        "vo/mercs_dev_r1a/heavy_contact_05.mp3"
    ]
}

::VIPHeavy <- class extends VIPMercCharacter
{
    soundBankClass = VIPHeavySoundBank;
}

::VIPMedicSoundBank <- class extends SoundBank
{
    contact = [
        "vo/mercs_dev_r1a/medic_contact_uber_01.mp3"
    ]
}

::VIPMedic <- class extends VIPMercCharacter
{
    soundBankClass = VIPMedicSoundBank;
}

::VIPScoutSoundBank <- class extends SoundBank
{
    contact = [
        "vo/mercs_dev_r1a/scout_contact_01.mp3"
        "vo/mercs_dev_r1a/scout_contact_02.mp3"
        "vo/mercs_dev_r1a/scout_contact_03.mp3"
        "vo/mercs_dev_r1a/scout_contact_04.mp3"
    ]
}

::VIPScout <- class extends VIPMercCharacter
{
    soundBankClass = VIPScoutSoundBank;
}

::VIPSoldierSoundBank <- class extends SoundBank
{
    contact = [
        "vo/mercs_dev_r1a/soldier_contact_01.mp3"
        "vo/mercs_dev_r1a/soldier_contact_02.mp3"
        "vo/mercs_dev_r1a/soldier_contact_03.mp3"
    ]
}

::VIPSoldier <- class extends VIPMercCharacter
{
    soundBankClass = VIPSoldierSoundBank;
}

::VIP_CLASS_CHARACTERS <- [
    VIPMercCharacter,        //UNKNOWN
    VIPScout,    //SCOUT
    VIPMercCharacter,        //SNIPER
    VIPSoldier,  //SOLDIER
    VIPDemo,     //DEMO
    VIPMedic,    //MEDIC
    VIPHeavy,    //HEAVY
    VIPMercCharacter,        //PYRO
    VIPMercCharacter,        //SPY
    VIPEngineer, //ENGINEER
    VIPMercCharacter         //CIVLIAN (the technical class, not the vscript character)
];