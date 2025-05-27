#include "cbase.h"
#include "tf_logic_domination.h"
#include "team_control_point.h"
#include "entitylist.h"
#include "igameevents.h"

LINK_ENTITY_TO_CLASS(logic_domination, CDominationLogic);

BEGIN_DATADESC(CDominationLogic)
DEFINE_INPUTFUNC(FIELD_VOID, "OnRoundStart", OnRoundStart),
DEFINE_INPUTFUNC(FIELD_VOID, "ScoreRedPoint", ScoreRedPoint),
DEFINE_INPUTFUNC(FIELD_VOID, "ScoreBluePoint", ScoreBluePoint),
DEFINE_FIELD(m_totalCaps, FIELD_INTEGER),
DEFINE_FIELD(m_totalRedCaps, FIELD_INTEGER),
DEFINE_FIELD(m_totalBlueCaps, FIELD_INTEGER),
DEFINE_FIELD(m_totalRedPoints, FIELD_INTEGER),
DEFINE_FIELD(m_totalBluePoints, FIELD_INTEGER),
DEFINE_FIELD(m_maxPoints, FIELD_INTEGER),
DEFINE_FIELD(m_domRate, FIELD_FLOAT),
DEFINE_FIELD(m_isRedScoring, FIELD_BOOLEAN),
DEFINE_FIELD(m_isBlueScoring, FIELD_BOOLEAN),
DEFINE_FIELD(m_isRoundOver, FIELD_BOOLEAN),
END_DATADESC()

CDominationLogic::CDominationLogic()
{
    m_maxPoints = 100;
    m_domRate = 1.0f;
    m_totalCaps = 0;
    m_totalRedCaps = 0;
    m_totalBlueCaps = 0;
    m_totalRedPoints = 0;
    m_totalBluePoints = 0;
    m_isRedScoring = false;
    m_isBlueScoring = false;
    m_isRoundOver = false;
}

void CDominationLogic::Spawn()
{
    BaseClass::Spawn();
}

void CDominationLogic::Activate()
{
    BaseClass::Activate();
    gameeventmanager->AddListener(this, "teamplay_round_start", false);
    gameeventmanager->AddListener(this, "teamplay_point_captured", false);
}

void CDominationLogic::OnRoundStart(inputdata_t& inputData)
{
    m_totalCaps = 0;
    for (CBaseEntity* ent = nullptr; (ent = gEntList.FindEntityByClassname(ent, "team_control_point")) != nullptr;)
    {
        m_totalCaps++;
    }
    m_totalRedCaps = 0;
    m_totalBlueCaps = 0;
    m_totalRedPoints = 0;
    m_totalBluePoints = 0;
    m_isRedScoring = false;
    m_isBlueScoring = false;
    m_isRoundOver = false;
}

void CDominationLogic::ScoreRedPoint(inputdata_t& inputData)
{
    if (!m_isRedScoring || m_isRoundOver)
        return;

    m_totalRedPoints++;
    CheckForWinner();
}

void CDominationLogic::ScoreBluePoint(inputdata_t& inputData)
{
    if (!m_isBlueScoring || m_isRoundOver)
        return;

    m_totalBluePoints++;
    CheckForWinner();
}

void CDominationLogic::FireGameEvent(IGameEvent* event)
{
    const char* name = event->GetName();
    if (FStrEq(name, "teamplay_round_start"))
    {
        inputdata_t dummy = {};
        OnRoundStart(dummy);
    }
    else if (FStrEq(name, "teamplay_point_captured"))
    {
        UpdateCaps();
    }
}

void CDominationLogic::UpdateCaps()
{
    int newRedCaps = 0;
    int newBlueCaps = 0;

    for (CBaseEntity* ent = nullptr; (ent = gEntList.FindEntityByClassname(ent, "team_control_point")) != nullptr;)
    {
        CTeamControlPoint* pPoint = dynamic_cast<CTeamControlPoint*>(ent);
        if (!pPoint)
            continue;

        int owner = pPoint->GetOwner();
        if (owner == TF_TEAM_RED)
            newRedCaps++;
        else if (owner == TF_TEAM_BLUE)
            newBlueCaps++;
    }

    m_totalRedCaps = (newRedCaps < 0) ? 0 : (newRedCaps > m_totalCaps ? m_totalCaps : newRedCaps);
    m_totalBlueCaps = (newBlueCaps < 0) ? 0 : (newBlueCaps > m_totalCaps ? m_totalCaps : newBlueCaps);

    m_isRedScoring = (m_totalRedCaps > 0);
    m_isBlueScoring = (m_totalBlueCaps > 0);
}

void CDominationLogic::CheckForWinner()
{
    if (m_totalRedPoints >= m_maxPoints && m_totalBluePoints >= m_maxPoints)
    {
        RoundEnd();
        // Fire stalemate output
    }
    else if (m_totalRedPoints >= m_maxPoints)
    {
        RoundEnd();
        // Fire red win output
    }
    else if (m_totalBluePoints >= m_maxPoints)
    {
        RoundEnd();
        // Fire blue win output
    }
}

void CDominationLogic::RoundEnd()
{
    m_isRoundOver = true;
    m_isRedScoring = false;
    m_isBlueScoring = false;
    // Disable timers if needed
}