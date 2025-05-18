PrecacheModel("models/vip_mobster/mobster_pickup.mdl");
PrecacheParticle("mobster_smoke");

::canePickupScript <- null;

class ::CanePickup
{
    pickup_ent = null;
    pushaway_ent = null;
    display_ent = null;

    character = null;
    team = null;
    model = null;
    origin = null;
    angles = null;
    enabled = false;
    disable2 = false;
    disableTS = 0;

    //Precaching
    needsPrecaching = true;
    function Precache() { }

    constructor(model, origin, angles, character, team)
    {
        if (getclass().needsPrecaching)
        {
            local myClass = getclass();
            myClass.needsPrecaching = false;
            if (model)
                PrecacheModel(model);
            Precache();
        }

        canePickupScript = this;
        this.model = model;
        this.origin = origin
        this.angles = angles;
        this.character = character;
        this.team = team;

        AddTimer(-1, CheckForAliveVIP);
        AddTimer(-1, TempRotation);
        OnGameEvent("teamplay_round_win", DisablePickup);

        if (!pushaway_ent || !pushaway_ent.IsValid())
        {
            pushaway_ent = CreateByClassname("obj_attachment_sapper");
            pushaway_ent.DispatchSpawn();
            pushaway_ent.SetAbsOrigin(origin);
            pushaway_ent.SetTeam(team);
            pushaway_ent.SetSize(Vector(-75, -75, 0), Vector(75, 75, 65));
            pushaway_ent.SetCollisionGroup(21);
        }

        if (!display_ent || !display_ent.IsValid())
        {
            display_ent = CreateByClassname("prop_dynamic");
            display_ent.SetModel("models/vip_mobster/mobster_pickup.mdl");
            display_ent.SetModelScale(0.75, -1);
            display_ent.DispatchSpawn();
            display_ent.SetAbsOrigin(origin);
            display_ent.SetAbsAngles(angles);
            display_ent.AcceptInput("SetDefaultAnimation", "closed", null, null);
        }

        if (!FindVIP(team))
            EnablePickup();
    }

    function EnablePickup()
    {
        if (GetRoundState() == GR_STATE_TEAM_WIN)
            return;
        enabled = true;
        if (pickup_ent && pickup_ent.IsValid())
            return;

        pickup_ent = CreateByClassname("item_armor");
        pickup_ent.DispatchSpawn();
        pickup_ent.SetModel("models/empty.mdl");
        pickup_ent.SetAbsOrigin(origin);
        pickup_ent.SetAbsAngles(angles);
        //pickup_ent.SetAbsOrigin(origin - Vector(0, 0, 20));
        pickup_ent.SetTeam(team);
        pickup_ent.SetSolid(SOLID_BBOX);
        local yaw = angles.Yaw();
        if ((yaw > 50 && yaw < 140) || (yaw > 220 && yaw < 320))
            pickup_ent.SetSize(Vector(-75, -35, -25), Vector(75, 35, 65));
        else
            pickup_ent.SetSize(Vector(-35, -75, -25), Vector(35, 75, 65));
        //pickup_ent.SetSize(Vector(-85, -65, -65), Vector(85, 65, 65));
        pickup_ent.SetPlaybackRate(1)

        pickup_ent.ValidateScriptScope();
        pickup_ent.ConnectOutput("OnCacheInteraction", "OnCacheInteraction");
        local scope = pickup_ent.GetScriptScope();
        scope.script <- this;
        scope.OnCacheInteraction <- OnCaneTouch.bindenv(this);

        EntFireByHandle(SpawnEntityFromTable("info_particle_system",
        {
            origin = pickup_ent.GetOrigin(),
            effect_name = "spellbook_major_burning",
            start_active = 1
        }), "SetParent", "!activator", -1, pickup_ent, pickup_ent);

        if (display_ent && display_ent.IsValid())
        {
            display_ent.AcceptInput("SetAnimation", "opening", null, null);
            display_ent.SetSequence(display_ent.LookupSequence("opening"));
            display_ent.AcceptInput("SetDefaultAnimation", "open", null, null);
        }

        disable2 = false;

        /*display_ent.SetAbsOrigin(origin - Vector(0, 0, 20));
        AddTimer(-1, function(timeEnd)
        {
            if (Time() > timeEnd)
            {
                display_ent.SetAbsOrigin(origin)
                return TIMER_DELETE;
            }
            display_ent.SetAbsOrigin(display_ent.GetOrigin() + Vector(0, 0, 20.0 / 66.6))
        }, Time() + 1)*/
    }

    function DisablePickup()
    {
        enabled = false;
        if (disable2)
            return;
        disable2 = true;
        if (pickup_ent && pickup_ent.IsValid())
            pickup_ent.AcceptInput("Kill", "", null, null);

        if (display_ent && display_ent.IsValid())
        {
            display_ent.AcceptInput("SetAnimation", "closing", null, null);
            display_ent.SetSequence(display_ent.LookupSequence("closing"));
            display_ent.AcceptInput("SetDefaultAnimation", "closed", null, null);
        }

        /*AddTimer(-1, function(timeEnd)
        {
            if (Time() > timeEnd)
            {
                display_ent.SetAbsOrigin(origin - Vector(0, 0, 20))
                return TIMER_DELETE;
            }
            display_ent.SetAbsOrigin(display_ent.GetOrigin() - Vector(0, 0, 20.0 / 66.6))
        }, Time() + 1)*/
    }

    function OnCaneTouch()
    {
        if (activator.GetTeam() == team && !FindVIP(team))
            DoCanePickup(activator);
    }

    function DoCanePickup(player)
    {
        if (!enabled)
            return;
        enabled = false;
        disableTS = Time() + 1;
        OnTickEnd(DisablePickup);
        RunWithDelay(0.05, function()
        {
            ConvertToCustomCharacter(player, character);
            AddTimer(-1, function(time)
            {
                if (Time() > time)
                    return TIMER_DELETE;
                if (GetPropInt(player, "m_StuckLast") > 1)
                    UnstuckPlayer(player);
            }, Time() + 1)
        })
        DispatchParticleEffect("mobster_smoke", player.GetCenter() + Vector(0, 0, 20), Vector());
    }

    function CheckForAliveVIP()
    {
        if (Time() < disableTS)
            return;
        if (FindVIP(team))
        {
            DisablePickup();
            return;
        }

        if (!pickup_ent || !IsValid(pickup_ent))
            EnablePickup();
    }

    function TempRotation()
    {
        if (!pickup_ent || !pickup_ent.IsValid())
            return;
        local frame = GetPropInt(pickup_ent, "m_ubInterpolationFrame");
        pickup_ent.SetAbsAngles(pickup_ent.GetAbsAngles() + QAngle(0, 1, 0));
        SetPropInt(pickup_ent, "m_ubInterpolationFrame", frame);
    }

    function MovePickup()
    {
        KillIfValid(pushaway_ent);
        KillIfValid(display_ent);
        canePickupScript.DisablePickup();
    }
}

::UnstuckPlayer <- function(player)
{
    local myPos = player.GetOrigin() + Vector(0, 0, 12);
    local areas = {};
    NavMesh.GetNavAreasInRadius(myPos, 180, areas);
    local tpPos = null;
    local tpDist = 9999;
    foreach (area in areas)
    {
        local center = area.GetCenter() + Vector(0, 0, 32);
        if (IsSpaceFree(center, player))
        {
            local dist = (center - myPos).Length();
            if (dist < tpDist)
            {
                tpDist = dist;
                tpPos = center;
            }
        }
    }
    if (tpPos)
        player.Teleport(true, tpPos, false, QAngle(), true, Vector());
}

::IsSpaceFree <- function(location, player)
{
    local traceTable = {
        start = location,
        end = location,
        hullmin = player.GetPlayerMins(),
        hullmax = player.GetPlayerMaxs(),
        ignore = player
    }
    TraceHull(traceTable);
    return !("enthit" in traceTable);
}