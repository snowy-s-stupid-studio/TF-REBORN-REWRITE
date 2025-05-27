//!CompilePal::IncludeDirectory("materials/vip_mobster")
//!CompilePal::IncludeFile("materials/vip_mobster/hud/vip_compass.vtf")
//!CompilePal::IncludeDirectory("models/vip_mobster")
//!CompilePal::IncludeDirectory("sound/vip_mobster_brooklynn_r1a")
//!CompilePal::IncludeDirectory("sound/mvm/mobster_brooklynn_r1a")
//!CompilePal::IncludeDirectory("sound/vo/mercs_brooklynn_r1a")
//!CompilePal::IncludeDirectory("scripts/vscripts/vip")
//!CompilePal::IncludeFile("shaders/fxc/vip_compass_ps20b.vcs")

gamemode_name <- "vip";
::useDebugReload <- true;

function Mainload()
{
    Convars.SetValue("tf_use_fixed_weaponspreads", "0");
    IncludeIfNot("_charlib/custom_character.nut", "CustomCharacter" in ROOT);
    InitCustomCharacterSystem();

    IncludeIfNot("_charlib/custom_weapon.nut", "CustomWeaponBase" in ROOT);
    IncludeIfNot("vip/characters/vip_shared.nut", "VIPShared" in ROOT);
    IncludeIfNot("vip/characters/merc_voice_lines.nut", "VIPMercCharacter" in ROOT);

    IncludeIfNot("vip/characters/mobster/vip_mobster.nut", "VIPMobster" in ROOT);
    Include("_charlib/vcd_replacer.nut");

    Include("vip/gamemode/vip_gamemode.nut");
    NetProps.SetPropInt(tf_gamerules, "m_nHudType", 2);
}

IncludeScript(gamemode_name + "/__lizardcore/_core.nut");
try { IncludeScript(gamemode_name + "/__lizardcore/debug.nut"); } catch (e) { }

/*OnDevCommand("mobster", function(player, args)
{
    ConvertToCustomCharacter(FindPlayerByArgs(player, args), VIPMobster);
});*/

/*AddTimer(0.1, function()
{
    local player = GetListenServerHost();
    local viewmodel = GetPropEntity(player, "m_hViewModel");
    printl(viewmodel.GetSequence()+" "+viewmodel.GetSequenceName(viewmodel.GetSequence()))
})*/

SetPropInt(worldspawn, "m_takedamage", 1);

::isFirebrand <- GetMapName().find("firebrand") != null