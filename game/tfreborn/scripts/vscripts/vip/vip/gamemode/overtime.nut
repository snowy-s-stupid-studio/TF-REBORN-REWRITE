//todo hardcode for a/d cp with blu
overtimeStartTime <- null;
game_text_overtime <- null;

RunWithDelay(1, function()
{
    SetOvertimeAllowedForCTF(true);

    local flag_ent = SpawnEntityFromTable("item_teamflag", {
        origin = Vector(0, 0, 0),
        flag_model = "models/empty.mdl"
        teamnum = TF_TEAM_BLUE
    });
    SetPropInt(flag_ent, "m_nFlagStatus", 1);
});

AddTimer(0.1, function()
{
    if (!InOvertime() || GetRoundState() == GR_STATE_TEAM_WIN)
    {
        if (overtimeStartTime) //Captured A during overtime
        {
            overtimeStartTime = null;
            SetPropString(game_text_overtime, "m_iszMessage", "");
            game_text_overtime.AcceptInput("Display", null, null, null);
        }
        return;
    }
    if (!overtimeStartTime) //Overtime _just_ began
    {
        overtimeStartTime = Time();

        game_text_overtime = SpawnEntityFromTable("game_text",
        {
            color = "236 227 203",
            color2 = "0 0 0",
            channel = 0,
            holdtime = 5,
            message = "",
            spawnflags = 1,
            x = -1,
            y = 0.1
        });
    }
    local timeLeft = clampFloor(0, 30 - (Time() - overtimeStartTime));

    local anyPointsContested = false;
    for (local i = 0; i < 7; i++)
        if (GetPropIntArray(tf_objective_resource, "m_iCappingTeam", i))
        {
            anyPointsContested = true;
            break;
        }

    if (!FindVIP(TF_TEAM_BLUE) || (timeLeft <= 0 && !anyPointsContested))
    {
        local roundWin = SpawnEntityFromTable("game_round_win",
        {
            win_reason = "0",
            force_map_reset = "1",
            TeamNum = TF_TEAM_RED.tostring(),
            switch_teams = "1"
        });
        roundWin.AcceptInput("RoundWin", "", null, null);
        overtimeStartTime = null;
        SetPropString(game_text_overtime, "m_iszMessage", "");
        game_text_overtime.AcceptInput("Display", null, null, null);
        return TIMER_DELETE;
    }
    SetPropString(game_text_overtime, "m_iszMessage", format("Time Left∶ %d", timeLeft));
    game_text_overtime.AcceptInput("Display", null, null, null);
});