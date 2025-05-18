::main_script <- this;
::main_script_entity <- self;
::CONST <- getroottable(); //todo getconsttable
::ROOT <- getroottable(); //todo getconsttable
::tf_player_manager <- Entities.FindByClassname(null, "tf_player_manager");
::tf_objective_resource <- Entities.FindByClassname(null, "tf_objective_resource");
::worldspawn <- Entities.FindByClassname(null, "worldspawn");
::tf_gamerules <- Entities.FindByClassname(null, "tf_gamerules");

if (!("BeginBenchmark" in ROOT))
{
    ::RealTime <- function() { return 0.0; };
    ::PushBenchmark <- function() {};
    ::PopBenchmark <- function() { return 0.0; };
    ::BeginBenchmark <- function() {};
    ::EndBenchmark <- function() { return 0.0 };
}
if (!("PrintWarning" in ROOT))
{
    ::PrintWarning <- function(...) { }
    ::PrintDebug <- function(...) { }
    ::OnDevCommand <- function(...) { }
}
if (!("ErrorHandler" in ROOT))
    ::ErrorHandler <- function(e) {};


::projectDir <- gamemode_name+"/";

::Include <- function(path, scope = null)
{
    PushBenchmark();
    IncludeScript(projectDir + path, scope);
    printf("  Loading `"+path+"` took %.4f ms\n", PopBenchmark());
}

::IncludeIfNot <- function(path, condition, scope = null)
{
    if (useDebugReload || !condition) Include(path, scope);
}

try { IncludeScript(gamemode_name + "_addons/prepreload.nut"); } catch(e) { }

printl("=====================================================================\nCore...");
IncludeIfNot("__lizardcore/constants.nut", "SpawnEntityFromTableOriginal" in ROOT);

::lizardLibBaseCallbacks <- {};
::lizardLibEvents <- {};

IncludeIfNot("__lizardcore/listeners.nut", "AddListener" in ROOT);

::lizardTimers <- [];
::lizardTimersLen <- 0;
IncludeIfNot("__lizardcore/timers.nut", "TickLizardTimers" in ROOT);
EntFireByHandle(self, "RunScriptCode", "TickLizardTimers()", 0, null, null);

Include("__lizardcore/players.nut");
IncludeIfNot("__lizardcore/util.nut", "FindEnemiesInRadius" in ROOT);

printl("=====================================================================\nPreload...");
if ("Preload" in this)
    Preload();
try { IncludeScript(gamemode_name + "_addons/preload.nut"); } catch(e) { }

printl("=====================================================================\nLoading main...");
if ("Mainload" in this)
    Mainload();
try { IncludeScript(gamemode_name + "_addons/postload.nut"); } catch(e) { }
printl("=====================================================================");