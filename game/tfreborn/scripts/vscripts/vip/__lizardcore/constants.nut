::AddPropFloat <- function(entity, property, value)
{
    SetPropFloat(entity, property, GetPropFloat(entity, property) + value);
}

::AddPropInt <- function(entity, property, value)
{
    SetPropInt(entity, property, GetPropInt(entity, property) + value);
}

::CreateByClassname <- function(classname)
{
    local entity = Entities.CreateByClassname(classname);
    SetPropBool(entity, "m_bForcePurgeFixedupStrings", true);
    return entity;
}

::FindByClassname <- function(previous, classname)
{
    local entity = Entities.FindByClassname(previous, classname);
    SetPropBool(entity, "m_bForcePurgeFixedupStrings", true);
    return entity;
}

::FindByClassnameNearest <- function(classname, center, radius)
{
    local entity = Entities.FindByClassnameNearest(classname, center, radius);
    SetPropBool(entity, "m_bForcePurgeFixedupStrings", true);
    return entity;
}

::FindByClassnameWithin <- function(previous, classname, origin, radius)
{
    local entity = Entities.FindByClassnameWithin(previous, classname, origin, radius);
    SetPropBool(entity, "m_bForcePurgeFixedupStrings", true);
    return entity;
}

::FindByName <- function(previous, name)
{
    local entity = Entities.FindByName(previous, name);
    SetPropBool(entity, "m_bForcePurgeFixedupStrings", true);
    return entity;
}

if (!("SpawnEntityFromTableOriginal" in ROOT))
    ::SpawnEntityFromTableOriginal <- ::SpawnEntityFromTable;
::SpawnEntityFromTable <- function(name, keyvalues)
{
    local entity = SpawnEntityFromTableOriginal(name, keyvalues);
    SetPropBool(entity, "m_bForcePurgeFixedupStrings", true);
    return entity;
}

::GetPropEntity <- function(entity, property)
{
    local entity = NetProps.GetPropEntity(entity, property);
    SetPropBool(entity, "m_bForcePurgeFixedupStrings", true);
    return entity;
}

::GetPropEntityArray <- function(entity, property, index)
{
    local entity = NetProps.GetPropEntityArray(entity, property, index);
    SetPropBool(entity, "m_bForcePurgeFixedupStrings", true);
    return entity;
}

//=============================================================

foreach (k, v in ::NetProps.getclass())
    if (k != "IsValid")
        ROOT[k] <- ::NetProps[k].bindenv(::NetProps);

foreach (_, cGroup in Constants)
    foreach (k, v in cGroup)
        ROOT[k] <- v != null ? v : 0;

CONST.TF_TEAM_UNASSIGNED <- TEAM_UNASSIGNED;
CONST.TF_TEAM_SPECTATOR <- TEAM_SPECTATOR;
CONST.TF_CLASS_HEAVY <- TF_CLASS_HEAVYWEAPONS;
CONST.MAX_CLIENTS <- MaxClients().tointeger();

::TF_CLASS_NAMES <- [
    "undefined",
    "scout",
    "sniper",
    "soldier",
    "demo",
    "medic",
    "heavy",
    "pyro",
    "spy",
    "engineer",
    "civilian"
];

::TF_CLASS_HEALTH <- [
    125, //UNDEFINED
    125, //SCOUT
    125, //SNIPER
    200, //SOLDIER
    175, //DEMO
    150, //MEDIC
    300, //HEAVY
    175, //PYRO
    125, //SPY
    125, //ENGINEER
    125  //CIVLIAN
];

::TF_CLASS_MOVESPEED <- [
    1.33, //UNDEFINED
    1.33, //SCOUT
    1.0,  //SNIPER
    0.8,  //SOLDIER
    0.93, //DEMO
    1.07, //MEDIC
    0.77, //HEAVY
    1.0,  //PYRO
    1.07, //SPY
    1.0,  //ENGINEER
    1.0   //CIVILIAN
];

::TF_CLASS_AMMO <- [
    [0, 32, 36, 100, 1, 1, 1],   //UNDEFINED
    [0, 32, 36, 100, 1, 1, 1],   //SCOUT
    [0, 25, 75, 100, 1, 0, 0],   //SNIPER
    [0, 20, 32, 100, 1, 1, 1],   //SOLDIER
    [0, 16, 24, 100, 1, 1, 1],   //DEMO
    [0, 150, 150, 100, 0, 0, 0], //MEDIC
    [0, 200, 32, 100, 1, 1, 1],  //HEAVY
    [0, 200, 32, 100, 1, 0, 0],  //PYRO
    [0, 20, 24, 100, 0, 1, 1],   //SPY
    [0, 32, 200, 200, 1, 1, 1],  //ENGINEER
    [0, 32, 36, 100, 1, 1, 1]    //CIVILIAN
];

::TF_CLASS_AMMO_TYPES <- [
    null,
    "hidden primary max ammo bonus",
    "hidden secondary max ammo penalty",
    "maxammo metal increased",
    "maxammo grenades1 increased",
    null,
    null
];

::TF_DMG_DECAPITATION_CUSTOMS <- [
    TF_DMG_CUSTOM_DECAPITATION,
    TF_DMG_CUSTOM_TAUNTATK_BARBARIAN_SWING,
    TF_DMG_CUSTOM_DECAPITATION_BOSS,
    TF_DMG_CUSTOM_HEADSHOT_DECAPITATION,
    TF_DMG_CUSTOM_MERASMUS_DECAPITATION
]

const SND_NOFLAGS = 0;
const SND_CHANGE_VOL = 1;
const SND_CHANGE_PITCH = 2;
const SND_STOP = 4;
const SND_SPAWNING = 8;
const SND_DELAY = 16;
const SND_STOP_LOOPING = 32;
const SND_SPEAKER = 64;
const SND_SHOULDPAUSE = 128;
const SND_IGNORE_PHONEMES = 256;
const SND_IGNORE_NAME = 512;
const SND_DO_NOT_OVERWRITE_EXISTING_ON_CHANNEL = 1024;

const MAX_CONTROL_POINTS = 8;

const CHAN_REPLACE = -1;
const CHAN_AUTO = 0;
const CHAN_WEAPON = 1;
const CHAN_VOICE = 2;
const CHAN_ITEM = 3;
const CHAN_BODY = 4;
const CHAN_STREAM = 5;
const CHAN_STATIC = 6;
const CHAN_VOICE2 = 7;
const CHAN_ANNOUNCER = 7;
const CHAN_VOICE_BASE = 8;
const CHAN_USER_BASE = 136;

CONST.DMG_MELEE <- DMG_CLUB;
CONST.DMG_TRAIN <- DMG_VEHICLE;
CONST.DMG_SAWBLADE <- DMG_NERVEGAS;
CONST.DMG_CRIT <- DMG_ACID;
CONST.DMG_USEDISTANCEMOD <- DMG_SLOWBURN;

const INT_MAX = 2147483647;

const MAX_WEAPON_COUNT = 8;