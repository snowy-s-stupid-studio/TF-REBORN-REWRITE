PrecacheSound("vo/null.mp3");

::ProvideCustomWeapon <- function(player, customWeaponClass)
{
    local weaponEnt = CreateByClassname(customWeaponClass.baseclass);
    SetPropInt(weaponEnt, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", customWeaponClass.baseid);
    SetPropBool(weaponEnt, "m_AttributeManager.m_Item.m_bInitialized", true);
    SetPropBool(weaponEnt, "m_bValidatedAttachedEntity", true);
    weaponEnt.DispatchSpawn();
    player.Weapon_Equip(weaponEnt);

    local instance = customWeaponClass(player, weaponEnt);
    weaponEnt.ValidateScriptScope();
    weaponEnt.GetScriptScope().weaponScript <- instance;
    instance.OnEquipInternal();
    return weaponEnt;
}

::GetCustomWeapon <- function(weaponEntity)
{
    if (!weaponEntity)
        return null;
    local scope = weaponEntity.GetScriptScope();
    return scope ? scope.weaponScript : null;
}

::CustomWeaponBase <- class
{
    //Weapon Definition
    itemClass = null;
    itemID = null;
    clip = null;
    maxAmmo = null;
    ammoSlot = null;
    //independentReserveAmmo = false;
    mute = false;

    viewModels = [];
    worldModels = [];
    playerModel = null;

    //Runtime
    player = null;
    charScript = null;
    weapon = null;

    vmIndices = null; //[]
    wmIndices = null; //[]

    hViewModels = null; //[]
    hWorldModels = null; //[]

    isActive = false;
    weaponActivePrevTick = null;
    lastFireTimePrevTick = 0;
    isTauntingPrevTick = false;

    //Precaching
    needsPrecaching = true;

    constructor(player, weapon)
    {
        local myClass = getclass();
        if (myClass.needsPrecaching)
        {
            myClass.needsPrecaching = false;

            myClass.vmIndices = [];
            foreach (viewModel in myClass.viewModels)
                myClass.vmIndices.push(PrecacheModel(viewModel));

            myClass.wmIndices = [];
            foreach (worldModel in myClass.worldModels)
                myClass.wmIndices.push(PrecacheModel(worldModel));

            if (playerModel)
                PrecacheModel(playerModel);
            OnPrecache();
        }
        vmIndices = myClass.vmIndices;
        wmIndices = myClass.wmIndices;
        hViewModels = [];
        hWorldModels = [];

        this.player = player;
        this.weapon = weapon;
        this.charScript = "GetCustomCharacter" in ROOT ? GetCustomCharacter(player) : null;
        OnSelfEvent("clear_custom_character", 0, OnDestroyInternal);
        AddTimer(-1, ProcessStuff);
    }

    function OnEquipInternal()
    {
        if (vmIndices.len() > 0)
        {
            CreateViewModels();
            CreateWorldModels();
		    SetPropInt(weapon, "m_nRenderMode", kRenderTransColor);
		    SetPropInt(weapon, "m_clrRender", 0);
        }

        if (clip != null)
        {
            local clipSize = weapon.GetMaxClip1().tofloat();
            local ratio = clip / clipSize;
            weapon.SetClip1(clip);
            if (ratio != 1)
                weapon.AddAttribute("clip size penalty HIDDEN", clip / clipSize, -1);
        }

        if (maxAmmo != null)
        {
            local ammoType = weapon.GetPrimaryAmmoType();
            if (ammoType >= 0)
            {
                SetPropIntArray(player, "m_iAmmo", maxAmmo, ammoType);

                local attribute = TF_CLASS_AMMO_TYPES[ammoType];
                if (attribute)
                {
                    local maxAmmoBuff = maxAmmo / TF_CLASS_AMMO[player.GetPlayerClass()][ammoType].tofloat();
                    weapon.AddAttribute(attribute, maxAmmoBuff, -1);
                }
            }
        }

        OnEquip();

        if ("OnDamage" in this)
        {
            OnGameEvent("OnTakeDamage", function(victim, params)
            {
                if (params.weapon == weapon)
                    OnDamage(victim, params);
            });
        }
    }

    function CreateViewModels()
    {
        if (vmIndices.len() == 0)
            return;

        foreach (hViewModel in hViewModels)
            KillIfValid(hViewModel);
        hViewModels = [];

        weapon.SetModelSimple(viewModels[0]);
        weapon.SetCustomViewModelModelIndex(vmIndices[0]);
        SetPropInt(weapon, "m_iViewModelIndex", vmIndices[0]);
        //SetPropBool(weapon, "m_bBeingRepurposedForTaunt", true); //todo

        foreach (vmIndex in vmIndices)
            CreateViewModel(vmIndex);
    }

    function CreateViewModel(vmIndex)
    {
        local hViewModel = CreateByClassname("tf_wearable_vm");
        SetPropInt(hViewModel, "m_nModelIndex", vmIndex);
        SetPropBool(hViewModel, "m_bValidatedAttachedEntity", true);
        SetPropEntity(hViewModel, "m_hWeaponAssociatedWith", weapon); //todo
        SetPropEntity(weapon, "m_hExtraWearableViewModel", hViewModel);
        hViewModel.DispatchSpawn();
        player.EquipWearableViewModel(hViewModel);
        if (!isActive)
            hViewModel.DisableDraw();
        hViewModels.push(hViewModel);
    }

    function CreateWorldModels()
    {
        if (wmIndices.len() == 0)
            return;

        foreach (hWorldModel in hWorldModels)
            KillIfValid(hWorldModel);
        hWorldModels = [];

        foreach (wmIndex in wmIndices)
            CreateWorldModel(wmIndex);
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
        if (!isActive)
            hWorldModel.DisableDraw();
        hWorldModels.push(hWorldModel);
    }

    tempFlag = true;

    function ShowWorldModels()
    {
        if (isActive)
            foreach (hWorldModel in hWorldModels)
                hWorldModel.EnableDraw();
    }

    function HideWorldModels()
    {
        if (isActive)
            foreach (hWorldModel in hWorldModels)
                hWorldModel.DisableDraw();
    }

    function OnDestroyInternal()
    {
        foreach (hViewModel in hViewModels)
            KillIfValid(hViewModel);
        foreach (hWorldModel in hWorldModels)
            KillIfValid(hWorldModel);
        OnSwitchOff();
        OnDestroy();
    }

    function ProcessStuff()
    {
        //Weapon Switching
        local activeWeapon = player.GetActiveWeapon();

        isActive = activeWeapon == weapon;

        if (!isActive && weapon == weaponActivePrevTick)
            OnSwitchOffInternal();
        if (isActive && weapon != weaponActivePrevTick)
            OnSwitchToInternal();

        weaponActivePrevTick = activeWeapon;
        if (!isActive)
            return;

        //Taunting
        local isTaunting = player.IsTaunting();
        if (isTaunting && !isTauntingPrevTick)
        {
            isTauntingPrevTick = true;
            CreateWorldModels();
            foreach (hWorldModel in hWorldModels)
                hWorldModel.EnableDraw();
            OnTauntStart();
        }
        else if (!isTaunting && isTauntingPrevTick)
        {
            isTauntingPrevTick = false;
            OnTauntStop();
        }

        //Firing
        //todo doesn't work on melee weapons... good thing the Mobster doesn't care
        local lastFireTime = GetPropFloat(weapon, "m_flLastFireTime");
        if (lastFireTime > lastFireTimePrevTick)
        {
            lastFireTimePrevTick = lastFireTime;
            OnFire();
        }

        //Mute sounds if instructed to
        if (mute)
            EmitSoundEx({
                sound_name = "vo/null.mp3",
                entity = player,
                channel = CHAN_WEAPON,
                sound_level = 150,
                volume = 1,
            });
    }

    function OnSwitchToInternal()
    {
        foreach (hViewModel in hViewModels)
            hViewModel.EnableDraw();
        foreach (hWorldModel in hWorldModels)
            hWorldModel.EnableDraw();
        if (playerModel)
            player.SetCustomModelWithClassAnimations(playerModel);
        OnSwitchTo();
    }

    function OnSwitchOffInternal()
    {
        foreach (hViewModel in hViewModels)
            if (hViewModel && hViewModel.IsValid())
                hViewModel.DisableDraw();
        foreach (hWorldModel in hWorldModels)
            if (hWorldModel && hWorldModel.IsValid())
                hWorldModel.DisableDraw();
        OnSwitchOff();
    }

    function OnPrecache() { }
    function OnEquip() { }
    function OnDestroy() { }
    function OnSwitchTo() { }
    function OnSwitchOff() { }
    function OnFire() { }
    function OnTauntStart() { }
    function OnTauntStop() { }
}