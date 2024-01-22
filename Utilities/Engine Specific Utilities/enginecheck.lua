local enginecheck = {
    _AUTHORS = 'galactic_2005',
    _VERSION  = '1.0.0'
}

--- Returns the engine the player is currently using alongside the version; see documentation for a list of supported engines
--- @return string
--- @nodiscard
function enginecheck.getEngine()
    local classForMainMenuState = 'states.MainMenuState'
    if version < '0.7.0' then
        -- 0.6.3 or lower
        classForMainMenuState = 'MainMenuState'
    end

    if getPropertyFromClass(classForMainMenuState, 'psychEngineJSVersion') ~= nil then
        return 'JS Engine ' .. getPropertyFromClass(classForMainMenuState, 'psychEngineJSVersion')
    elseif getPropertyFromClass(classForMainMenuState, 'psychOnlineVersion') ~= nil then
        return 'Psych Online ' .. getPropertyFromClass(classForMainMenuState, 'psychOnlineVersion')
    elseif UMMversion ~= nil then
        return 'Unnamed Multiplayer Mod ' .. UMMversion
    end

    return 'Psych Engine ' .. version
end

return enginecheck