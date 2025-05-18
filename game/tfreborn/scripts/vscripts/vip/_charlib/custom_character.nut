::InitCustomCharacterSystem <- function()
{
    if ("leftoverCustomCharacters" in ROOT)
        foreach (player in leftoverCustomCharacters)
        {
            if (IsValidPlayer(player))
            {
                OnTickEnd(function(player)
                {
                    if (!IsValidPlayer(player))
                        PrintWarning(player);
                    else
                        player.SetHealth(player.GetMaxHealth());
                }, player)
            }
        }
    ::leftoverCustomCharacters <- [];
    ::nextCustomChar <- player_table();
    OnGameEvent("post_inventory_application_post", 20, ProcessCustomCharacterInternal_PostInvApp);
}

::CTFPlayer.GetCustomCharacter <- function()
{
    if (this in CustomCharacter.customCharacters)
        return CustomCharacter.customCharacters[this];
    return null;
}
::CTFBot.GetCustomCharacter <- CTFPlayer.GetCustomCharacter;

::GetCustomCharacter <- function(player)
{
    if (player in CustomCharacter.customCharacters)
        return CustomCharacter.customCharacters[player];
    return null;
}

::GetUpcomingCustomCharacter <- function(player)
{
    return player in nextCustomChar ? nextCustomChar[player] : null;
}

::ProcessCustomCharacterInternal_PostInvApp <- function(player, params)
{
    if (player in nextCustomChar)
    {
        local cc = delete nextCustomChar[player];
        cc(player);
    }
}

::ConvertToCustomCharacter <- function(player, charScript)
{
    nextCustomChar[player] <- charScript;
    if (charScript.deleteItems)
        player.ForceRegenerateAndRespawnInPlace();
}

::CustomCharacter <- class
{
    customCharacters = {};
    player = null;

    //Custom character definition
    abilityClasses = null;
    playerClass = null;
    customRagdoll = true;
    model = null;
    scale = null;
    deleteItems = false;
    mute = false;
    keepAfterDeath = false;
    keepAfterClassChange = false;
    cleanAttachments = true;
    maxHealth = null;
    soundBankClass = null;

    //Dynamic data
    soundBank = null;
    isDead = false;
    abilities = null; //[]
    wasEngineer = false;
    isTaunting = false;
    isTauntingPrevTick = false;

    //Precaching
    needsPrecaching = true;
    function Precache() { }

    constructor(player)
    {
        if (getclass().needsPrecaching)
        {
            local myClass = getclass();
            myClass.needsPrecaching = false;
            if (model)
                PrecacheEntityFromTable({ classname = "tf_generic_bomb", model = model });
            Precache();
        }

        CustomCharacter.customCharacters[player] <- this;

        this.player = player;
        if (soundBankClass)
        {
            soundBank = soundBankClass();
            soundBank.charScript = this;
            soundBank.player = player;
        }

        ApplyCharacterInternal();

        OnSelfEvent("player_death", 100, function()
        {
            if (mute) //This disables underlying class' death scream
            {
                //todo hardcode
                EmitSoundEx({
                    sound_name = RandomElement([
                        "mvm/mobster_brooklynn_r1a/mobster_paincrticialdeath01.mp3",
                        "mvm/mobster_brooklynn_r1a/mobster_paincrticialdeath02.mp3",
                        "mvm/mobster_brooklynn_r1a/mobster_paincrticialdeath03.mp3"]),
                    entity = player,
                    speaker_entity = player,
                    filter_type = RECIPIENT_FILTER_PAS_ATTENUATION,
                    sound_level = 150,
                    channel = CHAN_VOICE,
                    volume = 1
                });

                SetPropInt(player, "m_PlayerClass.m_iClass", 0);
            }
            if (wasEngineer)
                SetPropInt(player, "m_PlayerClass.m_iClass", 9);
            ClearCustomCharacter(true);
            if (keepAfterDeath)
                nextCustomChar[player.entindex()] = this.getclass();
        });

        OnSelfEvent("post_inventory_application", function(params)
        {
            if (keepAfterClassChange)
                nextCustomChar[player.entindex()] = this.getclass();
            else
            {
                ClearCustomCharacter();
                if (deleteItems)
                {
                    local player = player;
                    OnTickEnd(function() {
                        player.ForceRegenerateAndRespawnInPlace();
                    }, main_script);
                }
            }
        });
        OnSelfEvent("player_disconnect", 0, ClearCustomCharacter);
        OnSelfEvent("player_team", 0, ClearCustomCharacter);
        OnGameEvent("scorestats_accumulated_update", function()
        {
            leftoverCustomCharacters.push(player);
            ClearCustomCharacter();
        });

        if ("OnTauntStart" in this || "OnTauntStop" in this)
            AddTimer(-1, ProcessTaunting);
    }

    function ApplyCharacterInternal()
    {
        wasEngineer = player.GetPlayerClass() == TF_CLASS_ENGINEER;
        local asd = this;
        if (playerClass)
            player.SetPlayerClass(playerClass);
        if (deleteItems)
            foreach(item in player.GetAttachments())
            {
                if (item.GetClassname() == "tf_weapon_medigun")
                {
                    SetPropBool(item, "m_bLowered", true);
                    OnTickEnd(KillIfValid, item);
                }
                else
                    KillIfValid(item);
            }
        if (model) player.SetCustomModelWithClassAnimations(model);
        if (scale) player.SetModelScale(scale, 0);
        if (mute) player.AddCustomAttribute("voice pitch scale", 0, -1);

        if (maxHealth != null)
        {
            OnTickEnd(function()
            {
                local baseClassHP = TF_CLASS_HEALTH[playerClass];
                player.SetHealth(maxHealth);
                player.SetMaxHealth(maxHealth);
                player.RemoveCustomAttribute("max health additive bonus");
                player.AddCustomAttribute("max health additive bonus", maxHealth - baseClassHP, -1);
            }, asd)

            if (GetPropInt(player, "m_Shared.m_nNumHealers") > 0)
            {
                foreach (otherPlayer in GetAlivePlayers(player.GetTeam()))
                {
                    if (otherPlayer.GetPlayerClass() == TF_CLASS_MEDIC)
                    {
                        local medigun = otherPlayer.GetWeaponBySlot(1);
                        if (player == GetPropEntity(medigun, "m_hHealingTarget"))
                        {
                            otherPlayer.Weapon_Switch(otherPlayer.GetWeaponBySlot(2));
                            otherPlayer.Weapon_Switch(medigun);
                            //todo make better
                        }
                    }
                }
            }
        }

        abilities = [];
        if (abilityClasses)
        {
            foreach (ability in abilityClasses)
                abilities.push(ability(this));
            foreach (ability in abilities)
                ability.ApplyAbility();
        }

        ApplyCharacter();

        try { FireCustomEvent.call(this, "custom_character", { userid = player.GetUserID() }); } catch(e) { }
    }

    function ApplyCharacter() { /* abstract function */ }

    function ProcessTaunting()
    {
        local isTaunting = player && player.IsTaunting();
        if (isTaunting && !isTauntingPrevTick)
        {
            isTauntingPrevTick = true;
            if ("OnTauntStart" in this)
                OnTauntStart();
        }
        else if (!isTaunting && isTauntingPrevTick)
        {
            isTauntingPrevTick = false;
            if ("OnTauntStop" in this)
                OnTauntStop();
        }
    }

    function CreateWorldModel(wmIndex)
    {
        local hWorldModel = CreateByClassname("tf_wearable");
        hWorldModel.Teleport(true, player.GetOrigin(), true, player.GetAbsAngles(), false, Vector());
        SetPropInt(hWorldModel, "m_nModelIndex", wmIndex);
        SetPropBool(hWorldModel, "m_bValidatedAttachedEntity", true);
        SetPropBool(hWorldModel, "m_AttributeManager.m_Item.m_bInitialized", true);
        SetPropEntity(hWorldModel, "m_hOwnerEntity", player);
        hWorldModel.SetOwner(player);
        hWorldModel.DispatchSpawn();
        hWorldModel.AcceptInput("SetParent", "!activator", player, player);
        SetPropInt(hWorldModel, "m_fEffects", 129); //EF_BONEMERGE | EF_BONEMERGE_FASTCULL
        return hWorldModel;
    }

    function ClearCustomCharacter(onDeath = false)
    {
        if (!player || !player.IsValid())
            PrintWarning("player is null: "+player+" "+this)

        FireCustomEvent.call(this, "clear_custom_character", { userid = player.GetUserID() });

        foreach (ability in abilities)
        {
            ability.OnCleanup();
            ability.player = null;
            ability.charScript = null;
        }
        abilities.clear();

        if (soundBank)
        {
            soundBank.player = null;
            soundBank.charScript = null;
        }
        OnCleanup();

        if (cleanAttachments)
        {
            foreach(item in player.GetAttachments()) //todo these weapons have something odd about them
                if (item && item.IsValid() && item.GetClassname() != "tf_weapon_invis" && item.GetClassname() != "tf_weapon_medigun")
                    KillIfValid(item);
            if (onDeath)
            {
                local origin = player.GetOrigin();
                for (local droppedWeapon = null; droppedWeapon = FindByClassnameWithin(droppedWeapon, "tf_dropped_weapon", origin, 128);)
                    droppedWeapon.Kill();
            }
        }

        if (model)
        {
            if (!onDeath)
                player.SetCustomModelWithClassAnimations("");
            else
            {
                local player = player;
                RunWithDelay(0.1, function() {
                    if (player && player.IsValid())
                        player.SetCustomModelWithClassAnimations("");
                }, main_script);
            }
        }
        if (scale)
            player.SetModelScale(1.0, 0);

        if (player in CustomCharacter.customCharacters)
            delete CustomCharacter.customCharacters[player];
        else
        {
            PrintWarning("player not in collection " + (player ? player.tostring() : player))
            foreach(k, v in CustomCharacter.customCharacters)
                PrintWarning2(k + " -> "+v)
        }
        player = null;
    }

    function OnCleanup() { /* abstract function */ }

    function FindAbility(abilityClass)
    {
        if (typeof(abilityClass) == "string")
        {
            abilityClass = safeget(this, abilityClass, safeget(ROOT, abilityClass, null));
            if (abilityClass == null)
                return null;
        }
        foreach(ability in abilities)
            if (ability instanceof abilityClass)
                return ability;
        return null;
    }

    function OnRegenerate(fakeRegenTrigger)
    {
        return 1;
    }

    function EmitSoundBank(sound, params = null)
    {
        if (soundBank)
            soundBank.EmitSoundBank(sound, params);
    }

    function EmitAnnouncerLine(sound, params = null)
    {
        if (soundBank)
            soundBank.EmitAnnouncerLine(sound, params);
    }

    function EmitVoiceLine(sound, params = null)
    {
        if (soundBank)
        {
            if (mute)
            {
                if (!params)
                    params = {};
                params.channel <- 141;
            }
            soundBank.EmitVoiceLine(sound, params);
        }
    }

    function EmitVoiceLineGlobal(sound, params = null)
    {
        if (soundBank)
            soundBank.EmitVoiceLineGlobal(sound, params);
    }

    function EmitVoiceLineToSingleListener(listener, sound, params = null)
    {
        if (soundBank)
            soundBank.EmitVoiceLineToSingleListener(listener, sound, params);
    }

    function EmitSoundBankSimple(sound, params = null)
    {
        if (soundBank)
            soundBank.EmitSoundBankSimple(sound, params);
    }

    function EmitSoundBankSingle(sound, params = null)
    {
        if (soundBank)
            soundBank.EmitSoundBankSingle(sound, params);
    }
}

::SoundBank <- class
{
    lowercased = null;
    charScript = null;
    player = null;

    //Precaching
    needsPrecaching = true;

    constructor()
    {
        local myClass = getclass();
        if (myClass.needsPrecaching)
        {
            myClass.needsPrecaching = false;
            local lowercased = {};
            myClass.lowercased = lowercased;
            foreach(key, value in myClass)
                if (typeof(value) == "array")
                {
                    foreach (soundEntry in value)
                        PrecacheSound(soundEntry);
                    lowercased[key.tolower()] <- value;
                }
        }
        lowercased = myClass.lowercased;
    }

    function GetSoundBank(sound)
    {
        if (!sound)  //todo log error
            return null;
        sound = sound.tolower();
        return sound in lowercased ? RandomElement(lowercased[sound]) : null;
    }

    function EmitSoundBank(sound, params)
    {
        if (!sound)  //todo log error
            return;
        sound = sound.tolower();
        if (sound in lowercased)
        {
            params.sound_name <- RandomElement(lowercased[sound]);
            EmitSoundEx(params);
        }
    }

    function EmitAnnouncerLine(sound, params = null)
    {
        EmitSoundBank(sound, combinetables({
            entity = player,
            filter_type = RECIPIENT_FILTER_GLOBAL,
            sound_level = 0,
            channel = CHAN_ANNOUNCER,
            volume = 1
        }, params));
    }

    function EmitVoiceLine(sound, params = null)
    {
        EmitSoundBank(sound, combinetables({
            entity = player,
            speaker_entity = player,
            sound_level = 150,
            channel = CHAN_VOICE,
            volume = 1
        }, params));
    }

    function EmitVoiceLineGlobal(sound, params = null)
    {
        EmitSoundBank(sound, combinetables({
            entity = player,
            speaker_entity = player,
            filter_type = RECIPIENT_FILTER_GLOBAL,
            sound_level = 150,
            channel = CHAN_ANNOUNCER,
            volume = 1
        }, params));
    }

    function EmitVoiceLineToSingleListener(listener, sound, params = null)
    {
        if (!sound || !((sound = sound.tolower()) in lowercased))
            return;

        params = combinetables({
            sound_name = RandomElement(lowercased[sound]),
            entity = player,
            speaker_entity = player,
            filter_type = RECIPIENT_FILTER_PAS_ATTENUATION,
            sound_level = 150,
            channel = CHAN_VOICE,
            volume = 1
        }, params);

        local farAway = Vector(99999, 99999, 99999);
        local offsets = [];
        foreach (player in GetPlayers())
            if (player != listener)
            {
                offsets.push([player, GetPropVector(player, "m_vecViewOffset")]);
                SetPropVector(player, "m_vecViewOffset", farAway);
            }
        EmitSoundEx(params);
        params.channel = CHAN_STATIC;
        EmitSoundEx(params);

        foreach (entry in offsets)
            SetPropVector(entry[0], "m_vecViewOffset", entry[1]);
    }

    function EmitSoundBankSimple(sound, params = null)
    {
        EmitSoundBank(sound, combinetables({
            entity = player,
            speaker_entity = player,
            sound_level = 150,
            channel = CHAN_STATIC,
            volume = 1
        }, params));
    }

    function EmitSoundBankSingle(sound, params = null)
    {
        EmitSoundBank(sound, combinetables({
            filter_type = RECIPIENT_FILTER_SINGLE_PLAYER,
            entity = player,
            speaker_entity = player,
            sound_level = 0,
            channel = CHAN_STATIC,
            volume = 1
        }, params));
    }
}

::BaseAbility <- class
{
    //Init data
    charScript = null;
    player = null;

    //Ability definitions
    maxCooldown = 0;
    maxCharges = 0;
    rechargeLength = 0;

    //Dynamic data
    nextCooldownTS = 0;
    currentCharges = 0;
    rechargeLength = 0;
    nextRechargeTS = 0;
    isOnCooldown = false;
    isTaunting = false;
    isTauntingPrevTick = false;

    //Precaching
    needsPrecaching = true;
    function Precache() { }

    constructor(charScript)
    {
        if (getclass().needsPrecaching)
        {
            getclass().needsPrecaching = false;
            Precache();
        }

        this.charScript = charScript;
        player = charScript.player;
        AddTimer(-1, function()
        {
            if (currentCharges < 0 || currentCharges > maxCharges)
                currentCharges = maxCharges;
            return TIMER_DELETE;
        });

        AddTimer(-1, ProcessTimestamps);
    }

    function ApplyAbility() { }

    function ProcessTimestamps()
    {
        local notOnCooldownNew = CheckCooldown();
        if (isOnCooldown && notOnCooldownNew)
            OnCooldownEnd();
        isOnCooldown = !notOnCooldownNew;

        local maxCharges = GetMaxCharges();
        if (maxCharges > 0)
        {
            local charges = GetCharges();
            if (charges < maxCharges && GetRechargeTimeLeft() <= 0)
            {
                nextRechargeTS = Time() + GetRechargeLength();
                currentCharges++;
                OnChargeRegen();
            }
        }
    }

    function CheckInput() { return true; }
    function CheckCooldown() { return GetCooldown() <= 0; }
    function CheckCharges() { return GetMaxCharges() <= 0 || GetCharges() > 0; }
    function CheckAbleToUse()
    {
        return !player.IsTaunting()
            && (GetRoundState() != GR_STATE_TEAM_WIN || player.GetTeam() == GetWinningTeam());
    }
    function CanPerform() { return CheckCooldown() && CheckCharges() && CheckInput() && CheckAbleToUse(); }
    function Perform() { }

    function GetCooldown() { return clampFloor(0, GetCooldownTimeStamp() - Time()); }
    function GetMaxCooldown() { return maxCooldown; }
    function GetCooldownTimeStamp() { return nextCooldownTS; }
    function OnCooldownEnd() { }

    function GetCharges() { return currentCharges; }
    function GetMaxCharges() { return maxCharges; }
    function GetRechargeLength() { return rechargeLength; }
    function GetRechargeTimeLeft() { return clampFloor(0, GetRechargeTimeStamp() - Time()); }
    function GetRechargeTimeStamp() { return nextRechargeTS; }
    function OnChargeRegen() { }

    function ConsumeCooldown() { nextCooldownTS = Time() + GetMaxCooldown(); }
    function ConsumeCharge()
    {
        nextRechargeTS = Time() + GetRechargeLength();
        if (GetCharges() > 0)
            currentCharges--;
    }

    function OnCleanup() { }
}