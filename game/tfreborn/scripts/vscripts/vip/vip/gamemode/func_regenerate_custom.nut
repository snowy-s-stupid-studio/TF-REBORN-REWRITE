::regenDelay <- 3.0;

function FixRegen()
{
    for (local func_regenerate = null; func_regenerate = FindByClassname(func_regenerate, "func_regenerate");)
    {
        local trigger_multiple = SpawnEntityFromTable("trigger_multiple", {
            origin = func_regenerate.GetOrigin(),
            angles = func_regenerate.GetAbsAngles(),
            spawnflags = 1,
            StartDisabled = 0,
            wait = 1,
            model = GetPropString(func_regenerate, "m_ModelName"),
        });
        trigger_multiple.ValidateScriptScope();
        trigger_multiple.ConnectOutput("OnStartTouch", "OnCustomRegen");
        trigger_multiple.ConnectOutput("OnTrigger", "OnCustomRegen");
        local scope = trigger_multiple.GetScriptScope();
        scope.associatedModel <- GetPropEntity(func_regenerate, "m_hAssociatedModel");
        scope.OnCustomRegen <- OnCustomRegen;

        func_regenerate.Kill(); //todo i/o
    }
}
OnTickEnd(FixRegen);

function OnCustomRegen()
{
    local time = Time();

    if (activator.GetNextRegenTime() > time)
        return false;

    local customCharacter = GetCustomCharacter(activator);
    local regenState = 0;
    if (customCharacter)
    {
        regenState = customCharacter.OnRegenerate(self);
        if (regenState == 2)
        {
            activator.SetNextRegenTime(time + regenDelay);
            return false;
        }
    }

    if (activator.IsTaunting())
        return false;

    local roundState = GetRoundState();
    if (roundState == GR_STATE_STALEMATE)
        return false;
    else if (roundState != GR_STATE_TEAM_WIN)
    {
        local lockerTeam = self.GetTeam();
        if (lockerTeam > 1 && lockerTeam != activator.GetTeam())
            return false;
    }
    else if (GetWinningTeam() != activator.GetTeam())
        return false;

    if (regenState == 0)
        activator.Regenerate(true);
    activator.SetNextRegenTime(time + regenDelay);
	EmitSoundOnClient("Regenerate.Touch", activator);
	if (associatedModel && associatedModel.IsValid())
	{
        associatedModel.AcceptInput("SetAnimation", "open", null, null);
        EntFireByHandle(associatedModel, "SetAnimation", "close", regenDelay - 1.0, null, null);
	}
    return true;
}