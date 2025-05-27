// CONFIG
::MOBSTER_CLASS_INDEX <- 7; // Replace with actual Mobster class index if different
::MOBSTER_ARMS_MODEL <- "models/vip_mobster/weapons/c_mobster_arms.mdl";

// Hook: Called whenever a weapon is equipped
function OnWeaponEquipped(player, weapon)
{
    if (!player || !weapon || !player.IsValid() || !weapon.IsValid())
        return;

    // Check if player is Mobster class (custom class check)
    if (player.GetPlayerClass() != MOBSTER_CLASS_INDEX)
        return;

    // Set mobster arms as secondary viewmodel
    local hVM1 = player.GetViewModel(0); // primary weapon model
    local hVM2 = player.GetViewModel(1); // usually used for arms

    if (hVM2 && hVM2.IsValid())
    {
        hVM2.SetModel(MOBSTER_ARMS_MODEL);
        printl(">> Mobster arms applied to VM2.");
    }
    else if (hVM1 && hVM1.IsValid()) // fallback: replace primary if only one viewmodel
    {
        hVM1.SetModel(MOBSTER_ARMS_MODEL);
        printl(">> Mobster arms applied to VM1 as fallback.");
    }
}

// Register global equip callback
::MobsterGlobalArmsEnforcer <- class {
    constructor() {
        OnGameEvent("player_spawn", 0, function(event) {
            local player = GetPlayerFromUserID(event.userid);
            if (!player || !player.IsValid())
                return;

            RunWithDelay(0.1, function() {
                local weapon = player.GetActiveWeapon();
                if (weapon && weapon.IsValid())
                    OnWeaponEquipped(player, weapon);
            });
        });

        // Optional: Add support for weapon switches
        AddThinkHook("mobster_arms_switch_hook", function() {
            foreach (player in GetAllPlayers()) {
                if (player.GetPlayerClass() != MOBSTER_CLASS_INDEX)
                    continue;

                local weapon = player.GetActiveWeapon();
                if (weapon && weapon.IsValid()) {
                    OnWeaponEquipped(player, weapon);
                }
            }
        }, 0.5); // Every 0.5s
    }
}

// Initialize script
MobsterGlobalArmsEnforcer();
