glowNameThing <- SpawnEntityFromTable("point_template", { targetname = "glow_name_thing" });

class ::GlowController
{
    glowControllers = {};

    displayHealth = true;

    glow_target = null;
    self = null;
    lastColor = 0;

    teleporter_ents = null;
    glow_ents = null;

    constructor(glow_target)
    {
        glowControllers[this] <- glow_target;

        this.glow_target = glow_target;
        self = glow_target; //todo kludge
        teleporter_ents = {};
        glow_ents = {};

        foreach(observer in FindObservers())
            ApplyGlow(observer);

        OnGameEvent("player_spawn", OnPlayerRespawn);
        OnGameEvent("player_team", PlayerTeamChangeOrDisconnect);
        OnGameEvent("player_disconnect", PlayerTeamChangeOrDisconnect);

        if (displayHealth)
        {
            OnSelfEvent("player_hurt", UpdateHealthColor);
            AddTimer(0.1, UpdateHealthColor);
            UpdateHealthColor();
        }
    }

    function GetHealthGlowColor()
    {
        local healthRatio = glow_target.GetHealth() / glow_target.GetMaxHealth().tofloat();
        if (healthRatio > 0.6)
            return 0xFF3ABF54; //RGBA 0.33 0.75 0.23 1.00
		else if(healthRatio > 0.3)
            return 0xFF3AB7BF; //RGBA 0.75 0.72 0.23 1.00
        return 0xFF3A3ABF;     //RGBA 0.75 0.23 0.23 1.00
    }

    function UpdateHealthColor()
    {
        local color = GetHealthGlowColor();
        if (color == lastColor)
            return;
        lastColor = color;
        foreach (glow in glow_ents)
            SetPropInt(glow, "m_glowColor", color)
    }

    function PlayerTeamChangeOrDisconnect(player)
    {
        if (player == glow_target)
            DestroyGlowController();
        else
            DeleteGlow(player);
    }

    function DestroyGlowController()
    {
        delete glowControllers[this];
        foreach(observer in FindObservers())
            DeleteGlow(observer);
    }

    function OnPlayerRespawn(player)
    {
        if (player == glow_target)
            foreach(observer in FindObservers())
                ApplyGlow(observer);
        else if (FindObservers().find(player) != null)
            ApplyGlow(player);
    }

    function FindObservers()
    {
        return GetPlayers(glow_target.GetTeam());
    }

    function DeleteGlow(observer)
    {
        if (observer in teleporter_ents)
            KillIfValid(teleporter_ents[observer]);
        if (observer in glow_ents)
            KillIfValid(glow_ents[observer]);
    }

    function ApplyGlow(observer)
    {
        if (observer == glow_target)
            return;
        local teleporter = observer in teleporter_ents ? teleporter_ents[observer] : null;
        local tf_glow = observer in glow_ents ? glow_ents[observer] : null;

        if (!IsValid(teleporter) || !IsValid(tf_glow))
        {
            KillIfValid(teleporter);
            KillIfValid(tf_glow);
            SpawnGlowEntities(observer);
        }
    }

    function SpawnGlowEntities(observer)
    {
        local teleporter = CreateByClassname("obj_teleporter");
        teleporter.SetAbsOrigin(glow_target.GetCenter());
        teleporter.DispatchSpawn();
        teleporter.SetModel(glow_target.GetModelName());
        teleporter.AddEFlags(EFL_NO_THINK_FUNCTION);
        teleporter.SetSolid(SOLID_NONE);
        SetPropBool(teleporter, "m_bPlacing", true);
        SetPropInt(teleporter, "m_fObjectFlags", 2);
        SetPropEntity(teleporter, "m_hBuilder", observer);

        SetPropInt(teleporter, "m_fEffects", 145);
        SetPropInt(teleporter, "m_nNextThinkTick", 0x7FFFFFFF);
        teleporter.AcceptInput("SetParent", "!activator", glow_target, glow_target);

        local tf_glow = SpawnEntityFromTable("tf_glow", {
            target = "glow_name_thing",
            StartDisabled = 0,
            origin = glow_target.GetCenter(),
            GlowColor = observer.GetTeam() == TF_TEAM_RED ? "190 48 48 255" : "179 225 255 255"
        });
        SetPropEntity(tf_glow, "m_hTarget", teleporter);
        tf_glow.AcceptInput("SetParent", "!activator", glow_target, glow_target);
        if (displayHealth)
            SetPropInt(tf_glow, "m_glowColor", GetHealthGlowColor())

        teleporter_ents[observer] <- teleporter;
        glow_ents[observer] <- tf_glow;
    }
}