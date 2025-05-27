return; //Todo - disabled; this creates extra problems. Gotta return to this post-release.

//The Money Bag Buff icon overrides the Mannpower Regen Rune.
//TF2 disables the Regen Rune code outside of Mannpower,
//but if we're playing a Mannpower/Mobster hybrid, we don't want the money bag to apply the regen rune.
if (IsPowerupMode())
    return;

function SeekAndDestroyRuneEntities()
{
    DoEntFire("item_powerup_rune", "Kill", "", 0, null, null);
}

deathTime <- 0;

function CorectRuneStates()
{
    //printl("\na " + Time()+" "+GetListenServerHost().InCond(TF_COND_RUNE_REGEN))
    if (Time() <= deathTime)
        return;
    //printl("b " + Time())
    foreach (player in GetPlayers(TF_TEAM_BLUE)) //todo hardcoded
    {
        local inCond = player.InCond(TF_COND_RUNE_REGEN);
        local hasBuff = player in underMoneyBagEffect;
        if (hasBuff && !inCond)
            player.AddCond(TF_COND_RUNE_REGEN);
        else if (!hasBuff && inCond)
            player.RemoveCond(TF_COND_RUNE_REGEN);
    }
}

AddTimer(-1, SeekAndDestroyRuneEntities);
AddTimer(-1, CorectRuneStates);

OnGameEvent("OnTakeDamage", function(victim, params)
{
    if (victim.GetHealth() - params.damage > 10)
        return;

    deathTime = Time() + 1.5;
    //local attacker = GetPlayerFromUserID(params.attacker);
    params.attacker.RemoveCond(TF_COND_RUNE_REGEN);
});

OnGameEvent("player_death", function(victim, params)
{
    local attacker = GetPlayerFromUserID(params.attacker);
});