//If your timer function returns this, it will delete the timer.
CONST.TIMER_DELETE <- INT_MAX - 1;

::AddTimer <- function(interval, func, ...)
{
    local scope = func.getinfos().parameters.len() - 1 < vargv.len()
        ? vargv.pop()
        : null;
    if (scope == null)
        scope = this;
    local entry = [func, vargv, scope.weakref(), "IsValid" in scope, Time() + interval, interval];
    ::lizardTimers.push(entry);
    ::lizardTimersLen++;
    return entry;
}
::OnTimer <- AddTimer;

::RunWithDelay <- function(delay, func, ...)
{
    local scope = func.getinfos().parameters.len() - 1 < vargv.len()
        ? vargv.pop()
        : null;
    if (scope == null)
        scope = this;
    local entry = [func, vargv, scope.weakref(), "IsValid" in scope, Time() + delay, INT_MAX];
    ::lizardTimers.push(entry);
    ::lizardTimersLen++;
    return entry;
}
::Schedule <- RunWithDelay;

::OnTickEnd <- function(delayedFunc, scope = null)
{
    return RunWithDelay(-1, delayedFunc, scope);
}

::OnNextTick <- function(delayedFunc, scope = null)
{
    return RunWithDelay(0.01, delayedFunc, scope);
}

::DeleteTimer <- function(timerEntry)
{
    if (timerEntry)
        timerEntry[2] = null;
}

//Internal function
::TickLizardTimers <- function()
{
    EntFireByHandle(self, "RunScriptCode", "TickLizardTimers()", 0.01, null, null);
    local time = Time();
    for (local i = 0; i < ::lizardTimersLen; i++)
    {
        local entry = ::lizardTimers[i];
        if (!entry[2] || (entry[3] && !entry[2].IsValid()))
        {
            ::lizardTimers.remove(i--);
            ::lizardTimersLen--;
            continue;
        }

        if (time < entry[4])
            continue;
        entry[4] += entry[5];

        local result;
        try { result = entry[0].acall([entry[2]].extend(entry[1])); } catch (e) { }
        if (result == TIMER_DELETE || entry[5] == INT_MAX)
        {
            ::lizardTimers.remove(i--);
            ::lizardTimersLen--;
        }
    }
}