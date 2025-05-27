//A convention I made for myself: "player" excludes clients in teams UNASSIGNED and SPECTATOR.
//Team #0 is repurposed to hold players across both teams, rather than team UNASSIGNED
::client_cache <- [];
::player_cache <- [ [], [], [], [] ];
::alive_player_cache <- [ [], [], [], [] ];
::userid_cache <- {};

for (local i = 1; i <= MAX_CLIENTS; i++)
{
    local player = PlayerInstanceFromIndex(i);
    if (!player)
        continue;
    player.ValidateScriptScope();
    local team = player.GetTeam();

    client_cache.push(player);
    userid_cache[player] <- GetPropIntArray(tf_player_manager, "m_iUserID", player.entindex());
    if (team > 1)
    {
        player_cache[0].push(player);
        player_cache[team].push(player);
        if (player.IsAlive())
        {
            alive_player_cache[0].push(player);
            alive_player_cache[team].push(player);
        }
    }
}

//Called from player_spawn event if params.team < 2
::ClientCache_Join <- function(player, userid)
{
    player.ValidateScriptScope();
    if (client_cache.find(player) == null)
        client_cache.push(player);
    userid_cache[player] <- userid;
}

OnGameEvent("player_team", -1000, function(player, params)
{
    foreach(team in [0, params.oldteam])
    {
        local index = player_cache[team].find(player);
        if (index != null) player_cache[team].remove(index);
        index = alive_player_cache[team].find(player);
        if (index != null) alive_player_cache[team].remove(index);
    }

    if (params.team >= 2)
    {
        player_cache[0].push(player);
        player_cache[params.team].push(player);
        if (player.IsAlive())
            foreach(team in [0, params.team])
                if (alive_player_cache[team].find(player) == null)
                    alive_player_cache[team].push(player);
    }
});

OnGameEvent("player_spawn", -1000, function(player, params)
{
    foreach(team in [0, player.GetTeam()])
        if (alive_player_cache[team].find(player) == null)
            alive_player_cache[team].push(player);
});

OnGameEvent("player_death", 1000, function(player, params)
{
    local index;
    foreach(team in [0, player.GetTeam()])
        if ((index = alive_player_cache[team].find(player)) != null)
            alive_player_cache[team].remove(index);
});

OnGameEvent("player_disconnect", 1000, function(player, params)
{
    local index = client_cache.find(player);
    if (index != null) client_cache.remove(index);

    if (!player || !("GetTeam" in player))
    {
        return; //todo tmp
        PrintWarning("GetTeam not found: " + player + " " + index);
        foreach(k, v in params)
            PrintWarning2(k+" -> "+v)
        PrintWarning("client_cache:")
        foreach(k, v in client_cache)
            PrintWarning2(k+" -> "+v)
    }

    delete userid_cache[player];
    foreach(team in [0, player.GetTeam()])
    {
        index = player_cache[team].find(player);
        if (index != null) player_cache[team].remove(index);
        index = alive_player_cache[team].find(player);
        if (index != null) alive_player_cache[team].remove(index);
    }
});

//A convention I made for myself: "player" excludes clients in teams UNASSIGNED and SPECTATOR.
::GetClients <- function()
{
    return client_cache;
}

//A convention I made for myself: "player" excludes clients in teams UNASSIGNED and SPECTATOR.
//No argument or team = 0 means getting players across both teams.
::GetPlayers <- function(team = 0)
{
    return player_cache[team];
}

::GetAlivePlayers <- function(team = 0)
{
    return alive_player_cache[team];
}

//=============================================================

::CTFPlayer.IsOnGround <- function()
{
    return GetPropEntity(this, "m_hGroundEntity") != null;
}
::CTFBot.IsOnGround <- CTFPlayer.IsOnGround;

//A valid _client_ can be a spectator. A valid _player_ can not.
::IsValidClient <- function(player)
{
    try
    {
        return player && player.IsValid() && player.IsPlayer();
    }
    catch(e)
    {
        return false;
    }
}

//A valid _client_ can be a spectator. A valid _player_ can not.
::IsValidPlayer <- function(player)
{
    try
    {
        return player && player.IsValid() && player.IsPlayer() && player.GetTeam() > 1;
    }
    catch(e)
    {
        return false;
    }
}

::IsValidPlayerOrBuilding <- function(entity)
{
    try
    {
        return entity
            && entity.IsValid()
            && entity.GetTeam() > 1
            && (entity.IsPlayer() || startswith(entity.GetClassname(), "obj_"));
    }
    catch(e)
    {
        return false;
    }
}

::IsValidBuilding <- function(building)
{
    try
    {
        return building
            && building.IsValid()
            && startswith(building.GetClassname(), "obj_")
            && building.GetTeam() > 1;
    }
    catch(e)
    {
        return false;
    }
}

::CTFPlayer.GetUserID <- function()
{
    return userid_cache[this];
}
::CTFBot.GetUserID <- CTFPlayer.GetUserID;

::CTFPlayer.Yeet <- function(vector)
{
    SetPropEntity(this, "m_hGroundEntity", null);
    this.ApplyAbsVelocityImpulse(vector);
    this.RemoveFlag(FL_ONGROUND);
}
::CTFBot.Yeet <- CTFPlayer.Yeet;

//Normal ForceChangeTeam will not work if the player is dueling. This is a workaround.
::CTFBot.SwitchTeam <- function(team)
{
    this.ForceChangeTeam(team, true);
    SetPropInt(this, "m_iTeamNum", team);
}

//Normal ForceChangeTeam will not work if the player is dueling. This is a workaround.
::CTFPlayer.SwitchTeam <- function(team)
{
    SetPropInt(this, "m_bIsCoaching", 1);
    this.ForceChangeTeam(team, true);
    SetPropInt(this, "m_bIsCoaching", 0);
}

::CTFPlayer.GetWeaponsAndCosmetics <- function()
{
    local items = [];
    local extraVM;
    for (local item = FirstMoveChild(); item != null; item = item.NextMovePeer())
    {
        SetPropBool(item, "m_bForcePurgeFixedupStrings", true);
        local className = item.GetClassname();
        if (startswith(className, "tf_we") || className == "tf_powerup_bottle")
        {
            items.push(item);
            extraVM = GetPropEntity(item, "m_hExtraWearableViewModel");
            if (extraVM && extraVM.IsValid())
                items.push(extraVM);
        }
    }
    return items;
}
::CTFBot.GetWeaponsAndCosmetics <- CTFPlayer.GetWeaponsAndCosmetics;

::CTFPlayer.GetAttachments <- function()
{
    local items = [];
    local extraVM;
    for (local item = FirstMoveChild(); item != null; item = item.NextMovePeer())
    {
        SetPropBool(item, "m_bForcePurgeFixedupStrings", true);
        if (item.GetClassname() != "tf_viewmodel")
        {
            items.push(item);
            extraVM = GetPropEntity(item, "m_hExtraWearableViewModel");
            if (extraVM && extraVM.IsValid())
                items.push(extraVM);
        }
    }
    return items;
}
::CTFBot.GetAttachments <- CTFPlayer.GetAttachments;

::CTFPlayer.GetWeaponBySlot <- function(slot)
{
	for (local i = 0; i < MAX_WEAPON_COUNT; i++)
	{
		local weapon = GetPropEntityArray(this, "m_hMyWeapons", i);
        if (weapon && weapon.GetSlot() == slot)
            return weapon;
	}
    return null;
}
::CTFBot.GetWeaponBySlot <- CTFPlayer.GetWeaponBySlot;

::CTFPlayer.GetWeapons <- function()
{
    local result = [];
	for (local i = 0; i < MAX_WEAPON_COUNT; i++)
	{
		local weapon = GetPropEntityArray(this, "m_hMyWeapons", i);
        if (weapon)
            result.push(weapon);
	}
    return result;
}
::CTFBot.GetWeapons <- CTFPlayer.GetWeapons;

::CTFPlayer.GetWeaponsAndAttachments <- function()
{
    local result = [];
    local extraVM;
	for (local i = 0; i < MAX_WEAPON_COUNT; i++)
	{
		local weapon = GetPropEntityArray(this, "m_hMyWeapons", i);
        if (weapon)
        {
            result.push(weapon);
            extraVM = GetPropEntity(weapon, "m_hExtraWearableViewModel");
            if (extraVM && extraVM.IsValid())
                result.push(extraVM);
            extraVM = GetPropEntity(weapon, "m_hExtraWearable");
            if (extraVM && extraVM.IsValid())
                result.push(extraVM);
        }
	}
    return result;
}
::CTFBot.GetWeapons <- CTFPlayer.GetWeaponsAndAttachments;

::CTFPlayer.Heal <- function(healing, dispalyOnHud = true)
{
    local oldHP = this.GetHealth();
    local newHP = clampFloor(oldHP, clampCeiling(oldHP + healing, this.GetMaxHealth()));
    this.SetHealth(newHP);
    if (dispalyOnHud && newHP - oldHP > 0)
        SendGlobalGameEvent("player_healonhit", {
            entindex = this.entindex(),
            amount = newHP - oldHP
        });
}
::CTFBot.Heal <- CTFPlayer.Heal;

::GetEnemyTeam <- function(playerOrTeam)
{
    if (playerOrTeam == TF_TEAM_RED)
        return TF_TEAM_BLUE;
    else if (playerOrTeam == TF_TEAM_BLUE)
        return TF_TEAM_RED;
    else if (type(playerOrTeam) == "instance" && playerOrTeam.IsPlayer())
        return GetEnemyTeam(playerOrTeam.GetTeam());
    return 0;
}

::CTFPlayer.GetEnemyTeam <- function()
{
    return ::GetEnemyTeam(this.GetTeam());
}
::CTFBot.GetEnemyTeam <- CTFPlayer.GetEnemyTeam;

::CTFPlayer.PlayViewModelAnim <- function(animation)
{
    local viewmodel = GetPropEntity(this, "m_hViewModel");
    if (viewmodel)
        viewmodel.SetSequence(viewmodel.LookupSequence(animation));
}
::CTFBot.PlayViewModelAnim <- CTFPlayer.PlayViewModelAnim;

::CTFPlayer.ForceRegenerateAndRespawnInPlace <- function()
{
    local origin = this.GetOrigin();
    local eyeAngles = this.EyeAngles();
    local velocity = this.GetAbsVelocity();
    this.ForceRegenerateAndRespawn();
    this.SetHealth(this.GetMaxHealth());
    this.Teleport(true, origin, false, QAngle(), true, velocity);
    this.SnapEyeAngles(eyeAngles);
}
::CTFBot.ForceRegenerateAndRespawnInPlace <- CTFPlayer.ForceRegenerateAndRespawnInPlace;

::CTFPlayer.StunPlayerEx <- function(params)
{
    local stunTrigger = SpawnEntityFromTable("trigger_stun", params);
    stunTrigger.AcceptInput("EndTouch", null, this, this);
    stunTrigger.AcceptInput("Kill", null, this, this);
}
::CTFBot.StunPlayerEx <- CTFPlayer.StunPlayerEx;

::player_table <- function()
{
    local table = {};
    OnGameEvent("player_disconnect", 999, function(player, params)
    {
        if (player in this)
            delete this[player];
    }, table);
    return table;
}