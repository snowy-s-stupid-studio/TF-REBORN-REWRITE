#include "cbase.h"
#include "tf_logic_domination.h"
#include "team_control_point.h"
#include "tf_player.h"
#include "entitylist.h"
#include "igameevents.h"

LINK_ENTITY_TO_CLASS(logic_domination, CDominationLogic);

BEGIN_DATADESC(CDominationLogic)
    DEFINE_INPUTFUNC(FIELD_VOID, "OnRoundStart", OnRoundStart),
    DEFINE_INPUTFUNC(FIELD_VOID, "OnPointCaptured", OnPointCaptured),
    DEFINE_INPUTFUNC(FIELD_VOID, "ScoreRedPoint", ScoreRedPoint),
    DEFINE_INPUTFUNC(FIELD_VOID, "ScoreBluePoint", ScoreBluePoint),
    DEFINE_OUTPUT(m_redWinOutput, "RedWin"),
    DEFINE_OUTPUT(m_blueWinOutput, "BlueWin"),
    DEFINE_OUTPUT(m_stalemateOutput, "Stalemate"),
    DEFINE_FIELD(m_totalCaps, FIELD_INTEGER),
    DEFINE_FIELD(m_totalRedCaps, FIELD_INTEGER),
    DEFINE_FIELD(m_totalBlueCaps, FIELD_INTEGER),
    DEFINE_FIELD(m_totalRedPoints, FIELD_INTEGER),
    DEFINE_FIELD(m_totalBluePoints, FIELD_INTEGER),
    DEFINE_FIELD(m_maxPoints, FIELD_INTEGER),
    DEFINE_FIELD(m_domRate, FIELD_FLOAT),
    DEFINE_FIELD(m_domPointDif, FIELD_FLOAT),
    DEFINE_FIELD(m_domPointDifLeader, FIELD_INTEGER),
    DEFINE_FIELD(m_isRedScoring, FIELD_BOOLEAN),
    DEFINE_FIELD(m_isBlueScoring, FIELD_BOOLEAN),
	DEFINE_FIELD(m_isRoundOver, FIELD_BOOLEAN),
END_DATADESC()

CDominationLogic::CDominationLogic()
{
    m_totalCaps = 0;
    m_totalRedCaps = 0;
    m_totalBlueCaps = 0;
    m_totalRedPoints = 0;
    m_totalBluePoints = 0;
    m_maxPoints = 100;
    m_domRate = 1.0f;
    m_domPointDif = 0.0f;
    m_domPointDifLeader = -1;
    m_isRedScoring = false;
    m_isBlueScoring = false;
    m_isRoundOver = false;
}

void CDominationLogic::Spawn()
{
    BaseClass::Spawn();
    // Initialization logic
}

void CDominationLogic::Activate()
{
    BaseClass::Activate();
    // Register for game events, e.g.:
    gameeventmanager->AddListener(this, "teamplay_round_start", false);
    gameeventmanager->AddListener(this, "teamplay_point_captured", false);
}

void CDominationLogic::OnRoundStart(inputdata_t &inputData)
{
    m_totalCaps = 0;
    for (CBaseEntity* ent = NULL; (ent = gEntList.FindEntityByClassname(ent, "team_control_point")) != NULL;)
    {
        m_totalCaps++;
    }
}

void CDominationLogic::OnPointCaptured()
{
   // TODO!!!
    // Handle point capture logic, update scores, etc.
    // Example: Check which team captured the point and update scores accordingly
    CTeamControlPoint* pPoint = dynamic_cast<CTeamControlPoint*>(this);
    if (pPoint)
    {
        if (pPoint->GetTeam() == TF_TEAM_RED)
        {
            m_totalRedCaps++;
            ScoreRedPoint();
        }
        else if (pPoint->GetTeam() == TF_TEAM_BLUE)
        {
            m_totalBlueCaps++;
            ScoreBluePoint();
        }
    }
	CheckForWinner();
}

void CDominationLogic::ScoreRedPoint()
{
    if (!m_isRedScoring || m_isRoundOver)
        return;
    m_totalRedPoints++;
    // Update UI, fire outputs, check for winner, etc.
}

void CDominationLogic::ScoreBluePoint()
{
    if (!m_isBlueScoring || m_isRoundOver)
        return;
    m_totalBluePoints++;
    // Update UI, fire outputs, check for winner, etc.
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

void CDominationLogic::CalculateScoreDifference()
{
    // Implement logic for domPointDifLeader and relay triggers
}

void CDominationLogic::RoundEnd()
{
    m_isRoundOver = true;
    // Disable timers, etc.
}