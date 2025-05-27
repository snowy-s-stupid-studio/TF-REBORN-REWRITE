// Constants
::MOBSTER_CLASS_INDEX <- 10; // Change to actual index if needed
::MOBSTER_ARMS_MODEL <- "models/vip_mobster/weapons/c_mobster_arms.mdl";

// Function to apply arms
function OnWeaponEquipped(player, weapon)
{
    if (!player || !weapon || !player.IsValid() || !weapon.IsValid())
        return;

    if (player.GetPlayerClass() != MOBSTER_CLASS_INDEX)
        return;

    local vm1 = player.GetViewModel(0);
    local vm2 = player.GetViewModel(1);

    if (vm2 && vm2.IsValid()) {
        vm2.SetModel(MOBSTER_ARMS_MODEL);
        printl(">> Mobster arms applied to VM2.");
    } else if (vm1 && vm1.IsValid()) {
        vm1.SetModel(MOBSTER_ARMS_MODEL);
        printl(">> Mobster arms applied to VM1 (fallback).");
    }
}

// Think-based polling approach
::MobsterArmsThinker <- class {
    constructor() {
        AddThinkHook("mobster_arms_poll", function() {
            foreach (player in GetAllPlayers()) {
                if (!player || !player.IsValid())
                    continue;

                if (player.GetPlayerClass() != MOBSTER_CLASS_INDEX)
                    continue;

                local weapon = player.GetActiveWeapon();
                if (weapon && weapon.IsValid())
                    OnWeaponEquipped(player, weapon);
            }
        }, 0.5); // Check every 0.5 seconds
    }
}

MobsterArmsThinker();
