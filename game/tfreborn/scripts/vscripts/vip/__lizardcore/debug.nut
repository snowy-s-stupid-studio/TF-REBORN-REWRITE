//=========================================================================
//If this is in a Workshop build, please let us know.
//This isn't supposed to happen.
//=========================================================================

::steamidWhitelist <- ["[U:1:61845546]",
    "[U:1:464940145]",
    "[U:1:33154594]",
    "[U:1:71264411]"];

for (local devListEnt = null; devListEnt = FindByName(devListEnt, "dev_list");)
{
    local entry;
    for (local i = 0; i < 63; i++)
        if ((entry = strip(GetPropString(configEnt, format("m_iszControlPointNames[%d]", i)))) != "")
            steamidWhitelist.push(entry)
}

::IsDev <- function(player)
{
    return steamidWhitelist.find((GetPropString(player, "m_szNetworkIDString"))) != null;
}

//======================================
//Dev Commands
//======================================

::chatCommands <- {};
::devCommands <- {};

::OnChatCommand <- function(command, func)
{
    chatCommands[command] <- func;
}

::OnDevCommand <- function(command, func)
{
    devCommands[command] <- func;
}

::FindPlayer <- function(name)
{
    for (local i = 1, player; i <= MAX_CLIENTS; i++)
        if ((player = PlayerInstanceFromIndex(i)) && GetPropString(player, "m_szNetname").tolower().find(name.tolower()) != null)
            return player;
}

::FindPlayerByArgs <- function(player, args)
{
    if (args.len() == 0)
        return player;
    for (local i = 1, otherPlayer; i <= MAX_CLIENTS; i++)
        if ((otherPlayer = PlayerInstanceFromIndex(i)) && GetPropString(otherPlayer, "m_szNetname").tolower().find(args[0]) != null)
            return otherPlayer;
    return player;
}

::debugListener <- {};
::debugListener.OnGameEvent_player_say <- function(params)
{
    local player = GetPlayerFromUserID(params.userid);
    if ((!startswith(params.text, "!") && !startswith(params.text, "/")))
        return;

    SetPropFloat(player, "m_flPlayerTalkAvailableMessagesTier1", 99);
    SetPropFloat(player, "m_flPlayerTalkAvailableMessagesTier2", 99);
    SetPropFloat(player, "m_fLastPlayerTalkTime", 0);
    local splits = split(params.text.slice(1), " ");
    local command = splits.remove(0);
    if (command in chatCommands)
        chatCommands[command].call(this, player, splits);
    else if (IsDev(player) && command in devCommands)
        devCommands[command].call(this, player, splits);
}.bindenv(this);
__CollectGameEventCallbacks(debugListener);

OnDevCommand("error", function(player, args)
{
    throw args[0];
});

OnDevCommand("fakeerror", function(player, args)
{
    ErrorHandler(args[0]);
});

OnDevCommand("kill", function(player, args)
{
    local targetPlayer = FindPlayer(args[0]);
    targetPlayer.TakeDamageEx(
        targetPlayer,
        targetPlayer,
        null,
        Vector(),
        Vector(),
        9999,
        TF_DMG_CUSTOM_TELEFRAG);
    ClientPrint(targetPlayer, HUD_PRINTTALK, "\x07250f3dYou were killed by a debug command.");
    ClientPrint(player, HUD_PRINTTALK, "\x07250f3d"+NetProps.GetPropString(player, "m_szNetname")+" was killed by a debug command.");
});

OnDevCommand("restart", function(player, args)
{
    ClientPrint(null, 3, "RESTARTING THE ROUND!")
    ClientPrint(null, 3, "RESTARTING THE ROUND!")
    ClientPrint(null, 3, "RESTARTING THE ROUND!")
    ClientPrint(null, 3, "RESTARTING THE ROUND!")
    ClientPrint(null, 3, "RESTARTING THE ROUND!")
    ClientPrint(null, 1, "RESTARTING THE ROUND!")
    ClientPrint(null, 4, "RESTARTING THE ROUND!")

    local team = args.len() < 1 ? "0" : args[0];

    local roundWin = SpawnEntityFromTable("game_round_win",
    {
        win_reason = "0",
        force_map_reset = "1", //not having
        TeamNum = team,        //these 3 lines
        switch_teams = "0"     //causes the crash when trying to fire game_round_win
    });
    EntFireByHandle(roundWin, "SetTeam", team, 0, null, null);
    EntFireByHandle(roundWin, "RoundWin", "", 0, null, null);

    local bonustime = Convars.GetInt("mp_bonusroundtime");
    Convars.SetValue("mp_bonusroundtime", 5);
    RunWithDelay(1, function()
    {
        Convars.SetValue("mp_bonusroundtime", bonustime);
    }, main_script)
});

OnDevCommand("restart2", function(player, args)
{
    ClientPrint(null, 3, "RESTARTING THE ROUND!")
    ClientPrint(null, 3, "RESTARTING THE ROUND!")
    ClientPrint(null, 3, "RESTARTING THE ROUND!")
    ClientPrint(null, 3, "RESTARTING THE ROUND!")
    ClientPrint(null, 3, "RESTARTING THE ROUND!")
    ClientPrint(null, 1, "RESTARTING THE ROUND!")
    ClientPrint(null, 4, "RESTARTING THE ROUND!")

    Convars.SetValue("mp_restartgame_immediate", "1");
});

OnDevCommand("taunt", function(player, args)
{
    if (args.len() > 1)
    {
        player = FindPlayerByArgs(player, args);
        args.remove(0);
    }
	local taunt_weapon = CreateByClassname("tf_weapon_bat");
	local active_weapon = player.GetActiveWeapon();
	player.StopTaunt(true);
	player.RemoveCond(7);
	SetPropInt(taunt_weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", args[0].tointeger());
	SetPropBool(taunt_weapon, "m_AttributeManager.m_Item.m_bInitialized", true);
	SetPropBool(taunt_weapon, "m_bForcePurgeFixedupStrings", true);
	SetPropEntity(player, "m_hActiveWeapon", taunt_weapon);
	SetPropInt(player, "m_iFOV", 0);
	player.HandleTauntCommand(0);
	SetPropEntity(player, "m_hActiveWeapon", active_weapon);
	taunt_weapon.Kill()
});

//======================================
//Print Debug
//======================================

::detectedIssues <- {};

::ErrorHandler <- function (e)
{
    local stackInfo = getstackinfos(2);
    local key = format("'%s' @ %s#%d", e, stackInfo.src, stackInfo.line);

    if (!(key in detectedIssues))
    {
        detectedIssues[key] <- [e, 1];
        foreach(player in FindValidDevs())
            PrintError(player, "A NEW ERROR HAS OCCURRED", e);
    }
    else
    {
        detectedIssues[key][1]++;
        local count = detectedIssues[key][1];
        if (count < 100
            || (count < 200 && count % 2 == 0)
            || (count < 1000 && count % 10 == 0)
            || count % 50 == 0
            )
        foreach(player in FindValidDevs())
            ClientPrint(player, 3, format("AN ERROR HAS OCCURRED [%d] TIMES: [%s]", detectedIssues[key][1], key));
    }
}
if (IsDedicatedServer())
    seterrorhandler(ErrorHandler);

local sourceTVPlayer = null;

::FindSourceTV <- function()
{
    if (sourceTVPlayer)
        return sourceTVPlayer;
    if (sourceTVPlayer == false)
        return null;
    sourceTVPlayer = false;
    for (local i = 1; i <= MAX_CLIENTS; i++)
        if (PlayerInstanceFromIndex(i) == null)
        {
            local entity = EntIndexToHScript(i);
            if (entity && entity.IsPlayer())
                sourceTVPlayer = entity;
        }
    return sourceTVPlayer;
}

::FindValidDevs <- function()
{
    local devs = [];
    for (local i = 1, player; i <= MAX_CLIENTS; i++)
        if ((player = PlayerInstanceFromIndex(i)) && IsDev(player))
            devs.push(player);
    local stv_player = FindSourceTV();
    if (stv_player)
        devs.push(stv_player);
    return devs;
}

::PrintError <- function(player, title, e, printfunc = null)
{
    if (!printfunc)
        printfunc = @(m) ClientPrint(player, 3, m);
    printfunc(format("\n%s [%s]", title, e))
    printfunc("CALLSTACK")
    local s, l = 3
    while (s = getstackinfos(l++))
        printfunc(format("*FUNCTION [%s()] %s line [%d]", s.func, s.src, s.line))
    printfunc("LOCALS")
    if (s = getstackinfos(3))
        foreach (n, v in s.locals)
        {
            local t = type(v)
            t ==    "null" ? printfunc(format("[%s] NULL"  , n))    :
            t == "integer" ? printfunc(format("[%s] %d"    , n, v)) :
            t ==   "float" ? printfunc(format("[%s] %.14g" , n, v)) :
            t ==  "string" ? printfunc(format("[%s] \"%s\"", n, v)) :
                             printfunc(format("[%s] %s %s" , n, t, v.tostring()))
        }
}

//======================================
//Dev Warning Print
//======================================

::PrintWarning <- function(message)
{
    ErrorHandler(message);
}

::PrintWarning2 <- function(message)
{
    foreach(player in FindValidDevs())
        ClientPrint(player, 3, message);
}

::PrintSTVLog <- function(message)
{
    local stv = FindSourceTV();
    if (stv)
        ClientPrint(player, 3, stv);
    //printl(message);
}

::PrintDebug <- function(message)
{
    foreach(player in FindValidDevs())
        ClientPrint(player, 3, message);
}

/*AddTimer(-1, function()
{
    local player = GetListenServerHost();
    local viewmodel = GetPropEntity(player, "m_hViewModel");
    printl(viewmodel.GetSequence()+" "+viewmodel.GetSequenceName(viewmodel.GetSequence()))
})*/