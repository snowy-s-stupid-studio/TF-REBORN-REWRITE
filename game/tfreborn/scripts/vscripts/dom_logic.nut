ClearGameEventCallbacks()

local pdLogic = Entities.FindByName(null, "logic_pd")
local resource = Entities.FindByClassname(null, "tf_objective_resource")

local totalCaps = 0
local totalRedCaps = 0
local totalBlueCaps = 0
local totalRedPoints = 0
local totalBluePoints = 0
local delayRed = 0
local delayBlue = 0
local maxPoints = 100
local domRate = 1.0
local domPointDif = 0
local domPointDifLeader = -1 //-1 - No entity, 0 - Neutral, 1 - Red, 2 - Blue
local isRedScoring = false
local isBlueScoring = false
local isRoundOver = false

//Optional entities not required for the map to function
local domRateEntity = Entities.FindByName(null, "dom_rate_*")
local domPointDifEntity = Entities.FindByName(null, "dom_point_difference_*")
local domPointDifRelayRed = Entities.FindByName(null, "dom_point_relay_red")
local domPointDifRelayBlue = Entities.FindByName(null, "dom_point_relay_blue")
local domPointDifRelayNeutral = Entities.FindByName(null, "dom_point_relay_neutral")

function OnGameEvent_teamplay_round_start(params)
{
    NetProps.SetPropInt(pdLogic, "m_nMaxPoints", maxPoints)

    for (local ent; ent = Entities.FindByClassname(ent, "team_control_point"); )
    {
        totalCaps++
    }

    //Find rate entity
    if (domRateEntity != null)
        domRate = domRateEntity.GetName().slice(9).tofloat()

    //Find point difference entity
    if (domPointDifEntity != null)
    {
        domPointDif = domPointDifEntity.GetName().slice(21).tofloat()
        domPointDifLeader = 0
    }
}

function OnGameEvent_teamplay_point_captured(params)
{
    local newRedCaps = 0
    local newBlueCaps = 0
    
    //Check which team owns which control points
    for (local ent; ent = Entities.FindByClassname(ent, "team_control_point"); )
    {
        local owner = NetProps.GetPropIntArray(resource, "m_iOwner", NetProps.GetPropInt(ent, "m_iPointIndex"))
        if (owner == 2)
        {
            newRedCaps++
        }
        else if (owner == 3)
        {
            newBlueCaps++
        }
    }

    //Clamp total caps
    totalRedCaps = Clamp(newRedCaps)
    totalBlueCaps = Clamp(newBlueCaps)

    //Calculate scoring delays
    delayRed = ((totalCaps.tofloat() * 2) - totalRedCaps.tofloat()) / domRate
    delayBlue = ((totalCaps.tofloat() * 2) - totalBlueCaps.tofloat()) / domRate

    //Check to see if red scoring should be enabled or disabled
    if (totalRedCaps != 0) //Does red own a control point?
    {
        if (isRedScoring == false) //Was red previously not scoring?
        {
            isRedScoring = true
            EntFire("point_timer_red", "RefireTime", delayRed.tostring(), 0, null)
            EntFire("point_timer_red", "Enable", "", 0, null)
        }
    }
    else //Red has no control points
    {
        isRedScoring = false
        EntFire("point_timer_red", "Disable", "", 0, null)
    }
    //Check to see if blue scoring should be enabled or disabled
    if (totalBlueCaps != 0) //Does blue own a control point?
    {
        if (isBlueScoring == false) //Was blue previously not scoring?
        {
            isBlueScoring = true
            EntFire("point_timer_blue", "RefireTime", delayBlue.tostring(), 0, null)
            EntFire("point_timer_blue", "Enable", "", 0, null)
        }
    }
    else //Blue has no control points
    {   
        isBlueScoring = false
        EntFire("point_timer_blue", "Disable", "", 0, null)
    }
}

function ScoreRedPoint()
{
    if (isRedScoring == false || isRoundOver == true)
        return

    totalRedPoints++

    //Update PD UI
    NetProps.SetPropInt(pdLogic, "m_nRedScore", totalRedPoints)
    NetProps.SetPropInt(pdLogic, "m_nRedTargetPoints", totalRedPoints)

    EntFire("point_timer_red", "RefireTime", delayRed.tostring(), 0, null) //Fire timer
    CheckForWinner()

    if (domPointDifLeader != -1)
        CalculateScoreDifference()
}

function ScoreBluePoint()
{
    if (isBlueScoring == false || isRoundOver == true)
        return

    totalBluePoints++

    //Update PD UI
    NetProps.SetPropInt(pdLogic, "m_nBlueScore", totalBluePoints)
    NetProps.SetPropInt(pdLogic, "m_nBlueTargetPoints", totalBluePoints)

    EntFire("point_timer_blue", "RefireTime", delayBlue.tostring(), 0, null) //Fire timer
    CheckForWinner()

    if (domPointDifLeader != -1)
        CalculateScoreDifference()
}

function CheckForWinner()
{
    if (totalRedPoints >= maxPoints && totalBluePoints >= maxPoints) //Check for stalemate
    {
        RoundEnd()
        EntFire("win_stalemate", "RoundWin", "", 0, null)
    }
    else if (totalRedPoints >= maxPoints) //Check for red win
    {
        RoundEnd()
        EntFire("win_red", "RoundWin", "", 0, null)
    }
    else if (totalBluePoints >= maxPoints) //Check for blue win
    {
        RoundEnd()
        EntFire("win_blue", "RoundWin", "", 0, null)
    }
}

function CalculateScoreDifference()
{
    if (totalRedPoints > totalBluePoints + domPointDif && domPointDifRelayRed != null) //Red has more points than Blue + the difference
    {
        if (domPointDifLeader == 1)
            return

        domPointDifLeader = 1
        EntFireByHandle(domPointDifRelayRed, "Trigger", "", 0.0, null, null)
    }
    else if (totalBluePoints > totalRedPoints + domPointDif && domPointDifRelayBlue != null) //Blue has more points than Red + the difference
    {
        if (domPointDifLeader == 2)
            return

        domPointDifLeader = 2
        EntFireByHandle(domPointDifRelayBlue, "Trigger", "", 0.0, null, null)
    }
    else if (domPointDifRelayNeutral != null) //Neither Red or Blue has more than the other + the difference
    {
        if (domPointDifLeader == 0)
            return

        domPointDifLeader = 0
        EntFireByHandle(domPointDifRelayNeutral, "Trigger", "", 0.0, null, null)
    }
}

function RoundEnd()
{
    isRoundOver = true
    EntFire("point_timer_red", "Disable", "", 0, null)
    EntFire("point_timer_blue", "Disable", "", 0, null)
}

function Clamp(value)
{
    if (value > totalCaps)
        return totalCaps

    if (value < 0)
        return 0

    return value
}

__CollectGameEventCallbacks(this)