#pragma once

#include "cbase.h"
#include "igameevents.h"

class CDominationLogic : public CBaseEntity, public IGameEventListener2
{
    DECLARE_CLASS(CDominationLogic, CBaseEntity);
    DECLARE_DATADESC();

public:
    CDominationLogic();

    void Spawn() override;
    void Activate() override;

    // Input functions
    void OnRoundStart(inputdata_t& inputData);
    void ScoreRedPoint(inputdata_t& inputData);
    void ScoreBluePoint(inputdata_t& inputData);

    // Game event handler
    void FireGameEvent(IGameEvent* event) override;

    // Helper logic
    void UpdateCaps();
    void CheckForWinner();
    void RoundEnd();

    int m_totalCaps;
    int m_totalRedCaps;
    int m_totalBlueCaps;
    int m_totalRedPoints;
    int m_totalBluePoints;
    int m_maxPoints;
    float m_domRate;
    bool m_isRedScoring;
    bool m_isBlueScoring;
    bool m_isRoundOver;
};