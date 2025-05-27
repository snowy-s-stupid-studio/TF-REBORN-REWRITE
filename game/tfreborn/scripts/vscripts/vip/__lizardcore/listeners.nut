//If your event listener returns this, it will delete this specific listener.
CONST.EVENT_DELETE <- INT_MAX - 1;
CONST.LISTENER_DELETE <- CONST.EVENT_DELETE;
//If your event listener returns this, it will prevent the following listeners of this event from being called.
CONST.EVENT_EARLY_OUT <- INT_MAX - 2;

if (!("GameEventCallbacks" in ROOT))
    ::GameEventCallbacks <- {};
if (!("ScriptHookCallbacks" in ROOT))
    ::ScriptHookCallbacks <- {};

::RegisterNewEventType <- function(eventName)
{
    RegisterScriptGameEventListener(eventName);
    lizardLibEvents[eventName] <- [];
    lizardLibBaseCallbacks["OnGameEvent_" + eventName] <- FireWithPreconditions(eventName);
    if (!(eventName in GameEventCallbacks))
        GameEventCallbacks[eventName] <- [];
    else
    {
        local array = GameEventCallbacks[eventName];
        for (local i = 0; i < array.len(); i++)
            if (!array[i])
                array.remove(i--);

    }
    GameEventCallbacks[eventName].push(lizardLibBaseCallbacks.weakref());
}

::RegisterNewHookType <- function(eventName)
{
    RegisterScriptHookListener(eventName);
    lizardLibEvents[eventName] <- [];
    lizardLibBaseCallbacks["OnScriptHook_" + eventName] <- function(params)
    {
        local target = params.const_entity;
        if (!target)
            return;
        if (target == worldspawn)
        {
            FireCustomEvent("OnWorldHit", params);
            return;
        }
        if (target.IsPlayer())
        {
            FireListeners(eventName, params, target);
            if (IsValidPlayer(params.attacker))
            {
                params.userid <- params.attacker.GetUserID();
                FireCustomEvent("OnDealDamage", params);
            }
        }
        else
        {
            FireCustomEvent("OnTakeDamageNonPlayer", params);
            if (IsValidPlayer(params.attacker))
            {
                params.userid <- params.attacker.GetUserID();
                FireCustomEvent("OnDealDamageNonPlayer", params);
            }
        }
        params.damage_stats = params.damage_custom;
    };
    if (!(eventName in ScriptHookCallbacks))
        ScriptHookCallbacks[eventName] <- [];
    else
    {
        local array = ScriptHookCallbacks[eventName];
        for (local i = 0; i < array.len(); i++)
            if (!array[i])
                array.remove(i--);

    }
    ScriptHookCallbacks[eventName].push(lizardLibBaseCallbacks.weakref());
}

::FireWithPreconditions <- function(eventName)
{
    if (eventName == "player_spawn")
        return function(params)
        {
            if (!("userid" in params)) //todo add logs if no userid can even happen
                return;
            local player = GetPlayerFromUserID(params.userid);
            if (!player)
                return;
            if (params.team < 2)
                ClientCache_Join(player, params.userid);
            else
                FireListeners(eventName, params, player);
        }

    if (eventName == "player_death")
        return function(params)
        {
            if ("fake" in params) //not for dead ringer, but for custom death notification messages
                return;
            if (params.death_flags & 32)
                FireCustomEvent("player_death_feign", params);
            else if ("userid" in params) //todo add logs if no userid can even happen
            {
                local player = GetPlayerFromUserID(params.userid);
                if (player)
                    FireListeners(eventName, params, player);
            }
        }

    if (eventName == "player_connect")
        return function(params)
        {
            FireListeners(eventName, params, null);
        }

    return function(params)
    {
        local player = "userid" in params ? GetPlayerFromUserID(params.userid) : null;
        FireListeners(eventName, params, player);
    }
}

::FireCustomEvent <- function(eventName, params)
{
    if (eventName in GameEventCallbacks)
    {
        local fullName = "OnGameEvent_" + eventName;
        foreach(callbackClass in GameEventCallbacks[eventName])
            if (fullName in callbackClass)
                try { callbackClass[fullName].call(this, params); } catch(e) { }
    }
}

::eventCleanUpCounter <- 0;

::FireListeners <- function(eventName, params, player)
{
    local cleanup = true;
    local entryQueue = lizardLibEvents[eventName];
    eventCleanUpCounter++;
    foreach (aEntry in entryQueue)
    {
        local entry = aEntry;
        local scope = entry[2];
        if (!scope)
        {
            entry[2] = null;
            cleanup = true;
            continue;
        }
        try
        {
            local flags = entry[3];
            if (flags & 16 && (!("self" in scope) || scope.self != player) && (!("player" in scope) || scope.player != player))
                continue;
            local args = [scope];
            if (flags & 4)
                args.push(player);
            if (flags & 8)
                args.push(params);

            local delayType = flags & 3;
            if (delayType == 0)
            {
                local result = entry[1].acall(args);
                if (result == EVENT_DELETE)
                    entry[2] = null;
                if (result == EVENT_EARLY_OUT)
                    break;
            }
            else if (delayType == 1) //todo temphacks
            {
                OnTickEnd(function()
                {
                    local result = entry[1].acall(args);
                    if (result == EVENT_DELETE)
                        entry[2] = null;
                }, scope);
            }
            else if (delayType == 2)
            {
                OnNextTick(FireListeners_delayedExec, function()
                {
                    local result = entry[1].acall(args);
                    if (result == EVENT_DELETE)
                        entry[2] = null;
                }, scope);
            }
        }
        catch (e) { } //This allows us to see the error in console, but it won't stop this cycle
    }
    eventCleanUpCounter--;
    if (cleanup && !eventCleanUpCounter)
    {
        for (local i = 0; i < entryQueue.len(); i++)
            if (!entryQueue[i][2])
                entryQueue.remove(i--);
    }
}


//You can skip `order` parameter. Default value is 0.
::OnGameEvent <- function(eventName, order, func = null, scope = null, isSelfListener = false)
{
    if (typeof(order) == "function")
    {
        isSelfListener = scope;
        scope = func;
        func = order;
        order = 0;
    }
    local delayType = 0;
    if (endswith(eventName, "_post"))
    {
        delayType = 1;
        eventName = eventName.slice(0, eventName.len() - 5);
    }
    if (endswith(eventName, "_next"))
    {
        delayType = 2;
        eventName = eventName.slice(0, eventName.len() - 5);
    }

    return AddListener(eventName, order, func, scope, isSelfListener, delayType);
}

::OnSelfEvent <- function(eventName, order, func = null, scope = null)
{
    if (typeof(order) == "function")
        return OnGameEvent(eventName, 0, order, func, true)
    return OnGameEvent(eventName, order, func, scope, true)
}

::AddListener <- function(eventName, order, func, scope, isSelfListener, delayType)
{
    if (!(eventName in lizardLibEvents))
    {
        if ((eventName == "OnDealDamage" || eventName == "OnTakeDamageNonPlayer" || eventName == "OnDealDamageNonPlayer") && !("OnTakeDamage" in lizardLibEvents))
            RegisterNewHookType("OnTakeDamage");
        if (eventName == "OnTakeDamage")
            RegisterNewHookType(eventName);
        else
            RegisterNewEventType(eventName);
    }

    if (!scope)
        scope = this;
    else if ("IsValid" in scope)
    {
        scope.ValidateScriptScope();
        scope = scope.GetScriptScope();
    }
    scope = scope.weakref();

    local parameters = func.getinfos().parameters; //note: parameters[0] is hidden and it's always _scope_
    local paramLen = parameters.len();
    local firstArgIsPlayer = paramLen == 3 || (paramLen == 2 && (parameters[1] != "params" && parameters[1] != "args"));
    local secondArgIsParams = paramLen == (firstArgIsPlayer ? 3 : 2);
    local flags = delayType + (firstArgIsPlayer ? 4 : 0) + (secondArgIsParams ? 8 : 0) + (isSelfListener ? 16 : 0)

    local entryQueue = lizardLibEvents[eventName];
    local i = 0;
    for (local len = entryQueue.len(); i < len && entryQueue[i][0] < order; i++) { }
    entryQueue.insert(i, [order, func, scope, flags]);

    return entryQueue;
}

::SetDestroyCallback <- function(entity, callback)
{
	entity.ValidateScriptScope();
	local scope = entity.GetScriptScope();
	scope.setdelegate({}.setdelegate({
			parent   = scope.getdelegate(),
			id       = entity.GetScriptId(),
			index    = entity.entindex(),
			callback = callback
			_get = function(k)
			{
				return parent[k];
			}
			_delslot = function(k)
			{
				if (k == id)
				{
					entity = EntIndexToHScript(index);
					local scope = entity.GetScriptScope();
					scope.self <- entity;
					callback.pcall(scope);
				}
				delete parent[k];
			}
		})
	)
}