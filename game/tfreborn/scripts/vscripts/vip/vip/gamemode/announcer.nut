vipDiedTeammate <- [
    "vo/announcer_failure.mp3",
    "vo/announcer_you_failed.mp3",
    "vo/announcer_sd_monkeynaut_end_crash01.mp3",
    "vo/announcer_sd_monkeynaut_end_crash02.mp3",
    "vo/mvm_wave_lose04.mp3",
    "vo/mvm_wave_lose06.mp3"
];

vipDiedEnemy <- [
    "vo/announcer_am_killstreak01.mp3",
    "vo/announcer_am_killstreak02.mp3",
    "vo/announcer_dec_kill01.mp3",
    "vo/announcer_dec_kill02.mp3",
    "vo/announcer_am_killstreak06.mp3",
    "vo/announcer_dec_kill15.mp3",
    "vo/announcer_dec_kill13.mp3",
    "vo/announcer_dec_kill08.mp3",
    "vo/announcer_dec_kill09.mp3",
    "vo/mvm_general_destruction01.mp3",
    "vo/mvm_general_destruction02.mp3",
    "vo/mvm_general_destruction09.mp3",
    "vo/mvm_general_destruction10.mp3",
    "vo/mvm_general_destruction12.mp3"
];

foreach (sound in vipDiedTeammate)
    PrecacheSound(sound);
foreach (sound in vipDiedEnemy)
    PrecacheSound(sound);

OnGameEvent("player_death", 0, function(player, params)
{
    if (!IsVIP(player))
        return;
    local attacker = GetPlayerFromUserID(params.attacker);
    if (!attacker || attacker == player)
        return;
    //ClientPrint(null, Constants.EHudNotify.HUD_PRINTTALK, "\x07FFCC22VIP died!");

    SendGlobalGameEvent("player_death", {
        userid = params.userid,
        attacker = params.attacker,
        weapon = player.GetTeam() == TF_TEAM_BLUE ? "redcapture": "bluecapture",
        fake = true
    })

    EmitSoundEx({
        sound_name = RandomElement(vipDiedTeammate),
        filter_type = RECIPIENT_FILTER_TEAM,
        channel = CHAN_ANNOUNCER,
        filter_param = player.GetTeam()
    });

    EmitSoundEx({
        sound_name = RandomElement(vipDiedEnemy),
        filter_type = RECIPIENT_FILTER_TEAM,
        channel = CHAN_ANNOUNCER,
        filter_param = player.GetEnemyTeam()
    });
});
