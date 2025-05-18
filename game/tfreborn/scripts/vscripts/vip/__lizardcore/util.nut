::isRoundSetup <- true;

::FindPlayersInRadiusAndLoS <- function(origin, radius, team = 0)
{
    local players = [];
    foreach (player in GetAlivePlayers(team))
        if ((origin - player.GetOrigin()).Length() <= radius)
            players.push(player);

    return players;
}

::FindEnemiesInRadius <- function(origin, radius, myTeam, includeNonPlayers = 2)
{
    local enemies = [];
    foreach (player in GetAlivePlayers())
        if (player.GetTeam() != myTeam && (origin - player.GetOrigin()).Length() <= radius)
            enemies.push(player);

    if (includeNonPlayers > 0)
        for (local building = null; building = FindByClassnameWithin(building, "obj_*", origin, radius);)
            if (building.GetTeam() != myTeam)
                enemies.push(building);

    if (includeNonPlayers > 1)
    {
        for (local npc = null; npc = FindByClassnameWithin(npc, "base_boss", origin, radius);)
            if (npc.GetTeam() != myTeam)
                enemies.push(npc);
        for (local npc = null; npc = FindByClassnameWithin(npc, "tf_zombie", origin, radius);)
            if (npc.GetTeam() != myTeam)
                enemies.push(npc);
    }
    return enemies;
}

::CreateAoE <- function(origin, radius, applyFunc)
{
    foreach(target in GetAlivePlayers())
    {
        local normalVector = target.GetOrigin() - origin;
        local distance = normalVector.Norm();
        if (distance <= radius)
            applyFunc(target, normalVector, distance);
    }

    for (local target = null; target = FindByClassname(target, "obj_*");)
    {
        local normalVector = target.GetOrigin() - origin;
        local distance = normalVector.Norm();
        if (distance <= radius)
            applyFunc(target, normalVector, distance);
    }
}

::CreateAoEAABB <- function(origin, min, max, applyFunc)
{
    local min = origin + min;
    local max = origin + max;
    foreach(target in GetAlivePlayers())
    {
        local targetOrigin = target.GetCenter();
        if (targetOrigin.x >= min.x
            && targetOrigin.y >= min.y
            && targetOrigin.z >= min.z
            && targetOrigin.x <= max.x
            && targetOrigin.y <= max.y
            && targetOrigin.z <= max.z)
            {
                local normalVector = targetOrigin - origin;
                applyFunc(target, normalVector, normalVector.Norm());
            }
    }

    for (local target = null; target = FindByClassname(target, "obj_*");)
    {
        local targetOrigin = target.GetCenter();
        if (targetOrigin.x >= min.x
            && targetOrigin.y >= min.y
            && targetOrigin.z >= min.z
            && targetOrigin.x <= max.x
            && targetOrigin.y <= max.y
            && targetOrigin.z <= max.z)
            {
                local normalVector = targetOrigin - origin;
                applyFunc(target, normalVector, normalVector.Norm());
            }
    }
}

::clampCeiling <- function(valueA, valueB)
{
    if (valueA < valueB)
        return valueA;
    return valueB;
}
::min <- clampCeiling;

::clampFloor <- function(valueA, valueB)
{
    if (valueA > valueB)
        return valueA;
    return valueB;
}
::max <- clampFloor;

::clamp <- function(value, min, max)
{
    if (max < min)
    {
        local tmp = min;
        min = max;
        max = tmp;
    }
    if (value < min)
        return min;
    if (value > max)
        return max;
    return value;
}

::safeget <- function(table, field, defValue)
{
    return table && field in table ? table[field] : defValue;
}

::safegetfunction <- function(table, functionName, defValue)
{
    return table && functionName in table ? table[functionName].bindenv(table) : defValue;
}

::IsValid <- function(entity)
{
    return entity && entity.IsValid();
}

::SetEntityColor <- function(entity, rgba)
{
    local color = rgba[0] | (rgba[1] << 8) | (rgba[2] << 16) | (rgba[3] << 24);
    SetPropInt(entity, "m_clrRender", color);
}

::ShuffleArray <- function(array)
{
    local currentIndex = array.len() - 1;
    local swap;
    local randomIndex;

    while (currentIndex > 0)
    {
        randomIndex = RandomInt(0, currentIndex);
        currentIndex -= 1;

        swap = array[currentIndex];
        array[currentIndex] = array[randomIndex];
        array[randomIndex] = swap;
    }

    return array;
}

::RandomElement <- function(array)
{
    local len = array.len();
    return len > 0 ? array[RandomInt(0, len - 1)] : null;
}

::combinetables <- function(tableA, tableB)
{
    if (tableB)
        foreach(k, v in tableB)
            tableA[k] <- v;
    return tableA;
}

::KillIfValid <- function(entity)
{
    if (entity && entity.IsValid())
        entity.Kill();
    return null;
}

/*::GetItemId <- function(item)
{
    return GetPropInt(item, "m_AttributeManager.m_Item.m_iItemDefinitionIndex");
}*/

::PrecacheParticle <- function(effect)
{
    PrecacheEntityFromTable({ classname = "info_particle_system", effect_name = effect });
}

::GetAttribute <- function(item, name, defValue)
{
    return item ? item.GetAttribute(name, defValue) : defValue;
}

::SetItemId <- function(item, id)
{
    if (item != null)
        SetPropInt(item, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", id);
}

::lastTimePlayedDamageResSound <- player_table();

::PlayDamageResistSound <- function(player, reductionRate)
{
    local time = Time();
    if (player in lastTimePlayedDamageResSound && time - lastTimePlayedDamageResSound[player] <= 0.1 )
        return;

    EmitSoundEx({
        sound_name = reductionRate >= 0.75
            ? "Player.ResistanceLight"
            : reductionRate <= 0.25
                ? "Player.ResistanceHeavy"
                : "Player.ResistanceMedium",
        entity = player,
        volume = 1
    });
    lastTimePlayedDamageResSound[player] <- time;
}

::PrecacheMaterial <- function(material)
{
    local temp = SpawnEntityFromTable("vgui_screen", {
        overlaymaterial = material,
        width = 0,
        height = 0
    })
    local index = GetPropInt(temp, "m_nOverlayMaterial");
    temp.Kill();
    return index;
}