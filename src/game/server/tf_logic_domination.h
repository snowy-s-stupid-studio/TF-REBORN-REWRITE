#pragma once

#include "cbase.h"
#include "team_control_point.h"
#include "tf_player.h"

class CDominationLogic : public CBaseEntity
{
    DECLARE_CLASS(CDominationLogic, CBaseEntity);
    DECLARE_DATADESC();

public:
    CDominationLogic();

    virtual void Spawn() OVERRIDE;
    virtual void Activate() OVERRIDE;

    void OnRoundStart();
    void OnPointCaptured();
    void ScoreRedPoint();
    void ScoreBluePoint();
    void CheckForWinner();
    void CalculateScoreDifference();
    void RoundEnd();

    void OnRoundStart(inputdata_t &inputData);

private:
    int m_totalCaps;
    int m_totalRedCaps;
    int m_totalBlueCaps;
    int m_totalRedPoints;
    int m_totalBluePoints;
    int m_maxPoints;
    float m_domRate;
    float m_domPointDif;
    int m_domPointDifLeader;
    bool m_isRedScoring;
    bool m_isBlueScoring;
    bool m_isRoundOver;

    // Add handles to optional entities as needed
};