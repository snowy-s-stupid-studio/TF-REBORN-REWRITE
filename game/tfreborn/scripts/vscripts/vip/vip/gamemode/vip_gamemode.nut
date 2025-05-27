Include("vip/gamemode/func_regenerate_custom.nut");

IncludeIfNot("vip/gamemode/capture_point_filtering.nut", "GiveControlPointsVIPLock" in ROOT);
OnTickEnd(GiveControlPointsVIPLock);

IncludeIfNot("vip/gamemode/cane_pickup.nut", "CanePickup" in ROOT);
::canePickupScript <- null;

Include("vip/gamemode/outline.nut");
Include("vip/gamemode/compass.nut");
Include("vip/gamemode/announcer.nut");
Include("vip/gamemode/overtime.nut");
//Include("vip/gamemode/buff_icon.nut");

Convars.SetValue("tf_bot_reevaluate_class_in_spawnroom", "0");

::FindVIP <- function(team)
{
    foreach (player in GetPlayers(team))
        if (IsVIP(player))
            return player;
    return null;
}

::IsVIP <- function(player)
{
    return GetCustomCharacter(player) instanceof VIPShared;
}

RunWithDelay(1.0, function()
{
    local player = RandomElement(GetAlivePlayers(TF_TEAM_BLUE));
    if (player)
        ConvertToCustomCharacter(player, VIPMobster);
});

function SpawnBlueCaneAt(targetname)
{
    local ent = FindByName(null, targetname);
    if (canePickupScript)
        try {canePickupScript.MovePickup(); } catch(e) { }
    CanePickup(
        "models/vip_mobster/weapons/w_typewriter.mdl",
        ent.GetOrigin() - Vector(0, 0, 15),
        ent.GetAbsAngles(),
        VIPMobster,
        TF_TEAM_BLUE);
}

OnGameEvent("clear_custom_character", function(player, params)
{
    if (IsVIP(player))
        FireCustomEvent("vip_gone", params);
});

OnGameEvent("player_spawn", function(player, args)
{
    if (GetUpcomingCustomCharacter(player) || GetCustomCharacter(player))
        return;
    local myClass = VIP_CLASS_CHARACTERS[player.GetPlayerClass()];
    if (myClass)
        ConvertToCustomCharacter(player, myClass);
});

OnGameEvent("post_inventory_application", function(player, args)
{
    if (GetUpcomingCustomCharacter(player) || GetCustomCharacter(player))
        return;
    local myClass = VIP_CLASS_CHARACTERS[player.GetPlayerClass()];
    if (myClass)
        ConvertToCustomCharacter(player, myClass);
});

OnGameEvent("teamplay_setup_finished", function()
{
    isRoundSetup = false;
});

function ShowVIPAnnotation(player)
{
    local vip = FindVIP(player.GetTeam());
    if (!vip || vip == player)
        return;
    local myPos = vip.GetOrigin() + Vector(0, 0, 120);
    SendGlobalGameEvent("show_annotation",
    {
        worldPosX = myPos.x,
        worldPosY = myPos.y,
        worldPosZ = myPos.z,
        id = 121,
        text = "VIP",
        lifetime = 6,
        follow_entindex = vip.entindex(),
        visibilityBitfield = 1 << player.entindex()
    });
}
OnGameEvent("player_spawn_post", ShowVIPAnnotation);
OnGameEvent("player_teleported", ShowVIPAnnotation);

/*function FixPointHUDLayout()
{
    for (local i = 0; i < 8; i++)
        if (GetPropFloatArray(tf_objective_resource, "m_flCustomPositionY", i) == -1)
            SetPropFloatArray(tf_objective_resource, "m_flCustomPositionY", 0.886, i)
}
EntFireByHandle(self, "RunScriptCode", "FixPointHUDLayout()", 0, null, null);*/