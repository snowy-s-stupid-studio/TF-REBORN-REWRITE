water_lod_control <- SpawnEntityFromTable("water_lod_control", {});

PrecacheModel("models/vip_mobster/hud/vip_compass.mdl");

::compassHelpers <- player_table();
::vipDeathTime <- [0, 0, 0, 0, 0]
::lastObserverMode <- player_table();

OnGameEvent("vip_gone", function(player, args)
{
    vipDeathTime[player.GetTeam()] = Time();
});

OnGameEvent("player_spawn_post", function(player, args)
{
    player.SetScriptOverlayMaterial("vip_mobster/hud/vip_compass");
    if (player in compassHelpers && compassHelpers[player] && IsValid(compassHelpers[player]))
        UpdateCompassAttachmentMode(player);
    else
        CreateCompassHelper(player);
});

AddTimer(-1, function()
{
    foreach(player in GetPlayers())
    {
        if (GetPropInt(player, "m_iObserverMode") > 1)
        {
            if (!(player in lastObserverMode) || lastObserverMode[player] < 1)
            {
                UpdateCompassAttachmentMode(player);
                lastObserverMode[player] <- 1;
            }
        }
        else
            lastObserverMode[player] <- 0;
    }
});

function CreateCompassHelper(player)
{
    local viewmodel = GetPropEntity(player, "m_hViewModel");
    if (!viewmodel)
        return;

    local newCompassHelper = CreateByClassname("obj_teleporter");
    newCompassHelper.DispatchSpawn();
    newCompassHelper.SetModel("models/vip_mobster/hud/vip_compass.mdl");
    newCompassHelper.SetModelScale(1, -1);
    newCompassHelper.AddEFlags(EFL_NO_THINK_FUNCTION);
    newCompassHelper.SetSolid(SOLID_NONE);
    SetPropBool(newCompassHelper, "m_bPlacing", true);
    SetPropInt(newCompassHelper, "m_fObjectFlags", 2);
    SetPropEntity(newCompassHelper, "m_hBuilder", player);
    SetPropInt(newCompassHelper, "m_clrRender", 0xAAFFFFFF);
    SetPropInt(newCompassHelper, "m_fEffects", 16);
    SetPropInt(newCompassHelper, "m_nNextThinkTick", 0x2FFFFFFF);
    newCompassHelper.AcceptInput("DisableShadow", null, null, null);

    newCompassHelper.SetAbsOrigin(viewmodel.GetOrigin() + player.EyeAngles().Forward() * 100);
    newCompassHelper.AcceptInput("SetParent", "!activator", viewmodel, viewmodel);

    compassHelpers[player] <- newCompassHelper;
    UpdateCompassAttachmentMode(player);
}

function UpdateCompassAttachmentMode(player)
{
    if (!(player in compassHelpers))
        return;

    local compassHelper = compassHelpers[player];
    if (!compassHelper || !compassHelper.IsValid())
        return;

    local observerMode = GetPropInt(player, "m_iObserverMode");
    local status = observerMode > 1 ? "2" : IsVIP(player) ? "1" : "0";

    local modify = SpawnEntityFromTable("material_modify_control", {
        materialName = "vip_mobster/hud/vip_compass",
        materialVar = "$data"
    });
    modify.AcceptInput("SetParent", "!activator", compassHelper, compassHelper);
    modify.AcceptInput("SetMaterialVar", status, null, null);
    EntFireByHandle(modify, "Kill", null, 0.3, null, null);
}

function UpdateCompassData()
{
    local target = FindVIP(TF_TEAM_BLUE);
    if (target && target.IsAlive())
    {
        SetPropFloat(water_lod_control, "m_flCheapWaterStartDistance", target.GetOrigin().x);
        SetPropFloat(water_lod_control, "m_flCheapWaterEndDistance", target.GetOrigin().y);

        local vipHPRatio = clampFloor(0, target.GetHealth() / target.GetMaxHealth().tofloat());
        SetPropVector(worldspawn, "m_WorldMins",
        Vector((vipHPRatio * 1000).tointeger(),
        isFirebrand ? 1 : 0,
        0));
    }
    else
    {
        SetPropVector(worldspawn, "m_WorldMins", Vector(-vipDeathTime[TF_TEAM_BLUE], isFirebrand ? 1 : 0, 0));
    }
}
AddTimer(-1, UpdateCompassData);