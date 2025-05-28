//==================================================================
//Cold Breath by Lizard Of Oz - 72 Hour Jam 2024.
//==================================================================

//Change this variable to make the script turn on cold breath
//  when the ceiling above is TOOLSSKYBOX and disable when it's not (crude outdoors/indoors check).
//Warning: midly expensive (0.5ms on once in 0.5s on a 24 player server).
TRACE_SKY_ACCESS <- false;

//==================================================================
//Don't edit past this point unless you know what you're doing
//==================================================================

::cold_breath_scope <- this;
alivePlayers <- [];
breathParticles <- {};

effect_viewmodel <- "cold_breath_vm";
effect_worldmodel <- "cold_breath_wm";
effect_intence_viewmodel <- "cold_breath_vm_intence";
effect_intence_worldmodel <- "cold_breath_wm_intence";

PrecacheEntityFromTable({ classname = "info_particle_system", effect_name = effect_viewmodel });
PrecacheEntityFromTable({ classname = "info_particle_system", effect_name = effect_worldmodel });
PrecacheEntityFromTable({ classname = "info_particle_system", effect_name = effect_intence_worldmodel });
PrecacheEntityFromTable({ classname = "info_particle_system", effect_name = effect_intence_worldmodel });

if (!("SCENE_FLAGGED" in getroottable()))
{
    local roottable = getroottable();

    foreach (k, v in ::NetProps.getclass())
        if (k != "IsValid")
            roottable[k] <- ::NetProps[k].bindenv(::NetProps);

    foreach (_, cGroup in Constants)
        foreach (k, v in cGroup)
            roottable[k] <- v != null ? v : 0;

    ::SCENE_FLAGGED <- EFL_NO_ROTORWASH_PUSH;
}

traceThinkCounter <- 0;

function Think()
{
    if (TRACE_SKY_ACCESS && ++traceThinkCounter >= 5)
    {
        traceThinkCounter = 0;
        foreach (player in alivePlayers)
        {
            local eyepos = player.EyePosition();
            local trace = {
                start = eyepos,
                end = eyepos + Vector(0, 0, 5000),
                mask = CONTENTS_SOLID,
                ignore = player
            };
            TraceLineEx(trace);
            if (trace.surface_name == "TOOLS/TOOLSSKYBOX")
                EquipBreathParticles(player);
            else
                UnequipBreathParticles(player);
        }
    }

    local time = Time();
    for (local scene = null; scene = Entities.FindByClassname(scene, "instanced_scripted_scene");)
    {
        if (scene.IsEFlagSet(SCENE_FLAGGED))
            continue;
        scene.AddEFlags(SCENE_FLAGGED);
        SetPropBool(scene, "m_bForcePurgeFixedupStrings", true);

        local path = GetPropString(scene, "m_szInstanceFilename");
        local split = split(path, "/");
        local char = split[split.len() - 1][0];
        if (char >= '0' && char <= '9')
        {
            local player = GetPropEntity(scene, "m_hOwner");
            if (player)
                EquipIntenseBreathParticles(player);
        }
    }
    return 0.1;
}
AddThinkToEnt(self, "Think");

//==================================================================
//Particle Entity Stuff
//==================================================================

function HasBreathParticles(player)
{
    return player in breathParticles;
}

function EquipBreathParticles(player)
{
    if (HasBreathParticles(player) || player.GetPlayerClass() == TF_CLASS_SPY)
        return;

    local particle;
    local particles = [null, null];
    breathParticles[player] <- particles;

    particle = particles[0] = SpawnEntityFromTable("info_particle_system", {
        effect_name = effect_viewmodel,
        start_active = 1
    });
    SetPropBool(particle, "m_bForcePurgeFixedupStrings", true);

    local viewmodel = GetPropEntity(player, "m_hViewModel");
    if (viewmodel)
    {
        particle.SetAbsOrigin(viewmodel.GetOrigin());
        particle.SetAbsAngles(QAngle(10, player.EyeAngles().Yaw(), 0))
        EntFireByHandle(particle, "SetParent", "!activator", 0, viewmodel, viewmodel);
    }

    particle = particles[1] = SpawnEntityFromTable("info_particle_system", {
        effect_name = effect_worldmodel,
        start_active = 1
    });
    particle.SetAbsOrigin(player.EyePosition());
    SetPropBool(particle, "m_bForcePurgeFixedupStrings", true);
    EntFireByHandle(particle, "SetParent", "!activator", 0, player, player);
    EntFireByHandle(particle, "SetParentAttachment", "head", 0, null, null);
}

function EquipIntenseBreathParticles(player)
{
    if (!HasBreathParticles(player))
        return;

    local particle = SpawnEntityFromTable("info_particle_system", {
        effect_name = effect_intence_viewmodel,
        start_active = 1
    });
    SetPropBool(particle, "m_bForcePurgeFixedupStrings", true);

    local viewmodel = GetPropEntity(player, "m_hViewModel");
    if (viewmodel)
    {
        particle.SetAbsOrigin(viewmodel.GetOrigin());
        particle.SetAbsAngles(QAngle(10, player.EyeAngles().Yaw(), 0))
        EntFireByHandle(particle, "SetParent", "!activator", 0, viewmodel, viewmodel);
    }
    EntFireByHandle(particle, "Kill", "", 2, null, null);

    particle = SpawnEntityFromTable("info_particle_system", {
        effect_name = effect_intence_worldmodel,
        start_active = 1
    });
    particle.SetAbsOrigin(player.EyePosition());
    SetPropBool(particle, "m_bForcePurgeFixedupStrings", true);
    EntFireByHandle(particle, "SetParent", "!activator", 0, player, player);
    EntFireByHandle(particle, "SetParentAttachment", "eyes", 0, null, null);
    EntFireByHandle(particle, "Kill", "", 2, null, null);
}

function UnequipBreathParticles(player)
{
    if (!HasBreathParticles(player))
        return;
    local clouds = breathParticles[player];
    delete breathParticles[player];
    for (local i = 0; i < 2; i++)
        if (clouds[i] && clouds[i].IsValid())
            clouds[i].Kill();
}

//==================================================================
//Triggers which turn cold breath on/off
//==================================================================

EQUIP_ON_SPAWN <- !TRACE_SKY_ACCESS;

for (local trigger = null; trigger = Entities.FindByName(trigger, "trigger_enable_cold_breath");)
{
    ENABLE_ON_SPAWN = false;
    SetPropBool(trigger, "m_bForcePurgeFixedupStrings", true);
    EntityOutputs.AddOutput(trigger,
        "OnStartTouch",
        "!self",
        "RunScriptCode",
        "cold_breath_scope.EquipBreathParticles(activator)",
        0, -1);
    EntityOutputs.AddOutput(trigger,
        "OnEndTouch",
        "!self",
        "RunScriptCode",
        "cold_breath_scope.UnequipBreathParticles(activator)",
        0, -1);
}

for (local trigger = null; trigger = Entities.FindByName(trigger, "trigger_disable_cold_breath");)
{
    SetPropBool(trigger, "m_bForcePurgeFixedupStrings", true);
    EntityOutputs.AddOutput(trigger,
        "OnEndTouch",
        "!self",
        "RunScriptCode",
        "cold_breath_scope.EquipBreathParticles(activator)",
        0, -1);
    EntityOutputs.AddOutput(trigger,
        "OnStartTouch",
        "!self",
        "RunScriptCode",
        "cold_breath_scope.UnequipBreathParticles(activator)",
        0, -1);
}

//==================================================================
//Event listeners
//==================================================================

::coldBreathListener <- {};

coldBreathListener.OnGameEvent_player_spawn <- function(params)
{
    local player = GetPlayerFromUserID(params.userid);
    if (!player) return;

    local index = alivePlayers.find(player);
    if (index != null) alivePlayers.push(player);

    if (EQUIP_ON_SPAWN)
    {
        UnequipBreathParticles(player);
        EquipBreathParticles(player);
    }
}.bindenv(this);

coldBreathListener.OnGameEvent_player_death <- function(params)
{
    if (params.death_flags & 32) return; //Dead Ringer's fake death
    local player = GetPlayerFromUserID(params.userid);
    if (!player) return;

    local index = alivePlayers.find(player);
    if (index != null) alivePlayers.remove(index);

    UnequipBreathParticles(player);
}.bindenv(this);

coldBreathListener.OnGameEvent_player_disconnect <- function(params)
{
    local player = GetPlayerFromUserID(params.userid);
    if (!player) return;

    local index = alivePlayers.find(player);
    if (index != null) alivePlayers.remove(index);

    SetPropBool(player, "m_bForcePurgeFixedupStrings", true);
    UnequipBreathParticles(player);
}.bindenv(this);

__CollectGameEventCallbacks(coldBreathListener);

for (local i = 1, player; i <= MaxClients(); i++)
    if ((player = PlayerInstanceFromIndex(i)) && player.IsAlive())
        alivePlayers.push(player);