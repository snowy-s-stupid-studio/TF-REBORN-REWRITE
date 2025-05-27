local capturePointIcons = [
    PrecacheMaterial("vip_mobster/hud/vip_point_0"),
    PrecacheMaterial("vip_mobster/hud/vip_point_1"),
    PrecacheMaterial("vip_mobster/hud/vip_point_2"),
    PrecacheMaterial("vip_mobster/hud/vip_point_3")
];

local announcerVIPNag = [
    "vo/announcer_am_capincite01.mp3",
    "vo/announcer_am_capincite03.mp3"
];

local announcerDefend = [
    "vo/announcer_security_alert.mp3",
    "vo/announcer_security_warning.mp3",
    "vo/mvm_wave_start01.mp3",
    "vo/mvm_wave_start09.mp3",
    "vo/mvm_wave_start10.mp3",
    "vo/mvm_wave_start11.mp3",
    "vo/announcer_plr_racegeneral03.mp3"
];

foreach (sound in announcerVIPNag)
    PrecacheSound(sound);
foreach (sound in announcerDefend)
    PrecacheSound(sound);

::GiveControlPointsVIPLock <- function()
{
    for (local capture_area = null; capture_area = FindByClassname(capture_area, "trigger_capture_area");)
    {
        capture_area.AcceptInput("Disable", null, null, null);

        local trigger_multiple = SpawnEntityFromTable("trigger_multiple", {
            origin = capture_area.GetOrigin(),
            angles = capture_area.GetAbsAngles(),
            model = GetPropString(capture_area, "m_ModelName"),
            spawnflags = 1,
            StartDisabled = 0
        });

        trigger_multiple.ValidateScriptScope();
        trigger_multiple.ConnectOutput("OnStartTouch", "OnStartTouch");
        trigger_multiple.ConnectOutput("OnEndTouch", "OnEndTouch");

        local scope = trigger_multiple.GetScriptScope();
        scope.modifiedTrigger <- ModifiedCapturePointTrigger(trigger_multiple, capture_area);
        scope.OnStartTouch <- scope.modifiedTrigger.OnStartTouch.bindenv(scope.modifiedTrigger);
        scope.OnEndTouch <- scope.modifiedTrigger.OnEndTouch.bindenv(scope.modifiedTrigger);
    }
}

class ::ModifiedCapturePointTrigger
{
    trigger_multiple = null;
    capture_area = null;
    pointIndex = -1;
    team = 0;

    vipOnPoint = null;
    isVIPInvul = false;
    playersInsideTrigger = null;

    lastTimeWasAnnounced = 0;

    constructor(trigger_multiple, capture_area)
    {
        local point = FindByName(null, GetPropString(capture_area, "m_iszCapPointName"));

        this.trigger_multiple = trigger_multiple;
        this.capture_area = capture_area;
        this.pointIndex = GetPropInt(point, "m_iPointIndex");
        //this.team = point.GetTeam();
        this.team = TF_TEAM_BLUE; //todo hardcoded
        this.playersInsideTrigger = player_table();

        UpdatePointIcon();

        AddTimer(-1, ProcessVIPInvul);
        OnGameEvent("player_death", OnEndTouch2);
    }


    function OnStartTouch()
    {
        if (activator.GetTeam() != team)
            return;

        if (IsVIP(activator))
            OnVIPStartTouch(activator);
        else
            OnNonVIPStartTouch(activator);
    }

    function OnVIPStartTouch(player)
    {
        vipOnPoint = player;
        if (player.IsInvulnerable() || player.InCond(TF_COND_MEGAHEAL))
            return;

        capture_area.AcceptInput("Enable", null, null, null);
        UpdatePointIcon();
    }

    function OnNonVIPStartTouch(player)
    {
        if (player.InCond(TF_COND_DISGUISED) || player.InCond(TF_COND_STEALTHED))
            return;
        playersInsideTrigger[player] <- 1;
        UpdatePointIcon();

        /*if (playersInsideTrigger.len() <= 1 && Time() - lastTimeWasAnnounced > 10) //todo fix later
        {
            lastTimeWasAnnounced = Time();
            local teamStr = team == TF_TEAM_BLUE ? "PlayVORed": "PlayVOBlue";
            tf_gamerules.AcceptInput(teamStr, RandomElement(announcerDefend), null, null);

            EmitSoundEx({
                sound_name = RandomElement(announcerVIPNag),
                entity = FindVIP(team),
                filter_type = RECIPIENT_FILTER_SINGLE_PLAYER,
                volume = 1,
                sound_level = 0
            });
        }*/
    }


    function OnEndTouch()
    {
        OnEndTouch2(activator);
    }

    function OnEndTouch2(player)
    {
        if (player && player.GetTeam() != team)
            return;

        if (IsVIP(player))
            OnVIPEndTouch(player)
        else
            OnNonVIPEndTouch(player);
    }

    function OnVIPEndTouch(player)
    {
        vipOnPoint = null;
        capture_area.AcceptInput("DisableAndEndTouch", null, null, null);
        UpdatePointIcon();
    }

    function OnNonVIPEndTouch(player)
    {
        if (player in playersInsideTrigger)
            delete playersInsideTrigger[player];
        UpdatePointIcon();
    }


    function UpdatePointIcon()
    {
        local nonVIPCount = playersInsideTrigger.len();
        local displayCount = vipOnPoint ? 0 : clampCeiling(3, nonVIPCount);
        local arrayIndex = GetEnemyTeam(team) * MAX_CONTROL_POINTS + pointIndex;
        SetPropIntArray(tf_objective_resource, "m_iTeamIcons", capturePointIcons[displayCount], arrayIndex);
        OnTickEnd(function()
        {
            SendGlobalGameEvent("controlpoint_updateimages", {
                index = pointIndex
            })
        })
    }

    function ProcessVIPInvul()
    {
        if (!vipOnPoint || !vipOnPoint.IsValid())
            return;

        if (!isVIPInvul)
        {
            if (vipOnPoint.IsInvulnerable() || vipOnPoint.InCond(TF_COND_MEGAHEAL))
            {
                isVIPInvul = true;
                capture_area.AcceptInput("DisableAndEndTouch", null, null, null);
            }
        }
        else
        {
            if (!vipOnPoint.IsInvulnerable() && !vipOnPoint.InCond(TF_COND_MEGAHEAL))
            {
                isVIPInvul = false;
                capture_area.AcceptInput("Enable", null, null, null);
            }
        }
    }
}