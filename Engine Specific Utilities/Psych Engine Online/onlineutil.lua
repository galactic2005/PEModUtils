local onlineutil = {}

--- Returns a player's current stat
---
--- If the `stat` does not exist, then it'll return `nil`
--- @param player any
--- @param stat string
--- @return any
local getPlayerStat = function(player, stat)
    assert(type(stat) == 'string', 'Expected string for stat, got ' .. type(stat) .. '.') -- use only strings for stat

    local playerType = tostring(player)
    assert(playerType == '1' or playerType == '2', 'player is ' .. playerType .. ', not \'1\' or \'2\'.') -- only player one or two
    return getPropertyFromClass('online.GameClient', 'room.state.player' .. playerType .. stat)
end

--- Returns a player's current stats
--- @param player any
--- @return table
local getPlayerStatsTable = function(player)
    local playerType = tostring(player)
    assert(playerType == '1' or playerType == '2', 'playerType is ' .. playerType .. ', not \'1\' or \'2\'.') -- only player one or two

    local statTable = {}
    local statToGrab = nil
    for index = 1, #onlineutil.tablePlayerStatStrings do
        statToGrab = getPropertyFromClass('online.GameClient', 'room.state.player' .. playerType .. '.' .. onlineutil.tablePlayerStatStrings[index])
        statTable[#statTable+1] = statToGrab
    end

    return statTable
end

--- Returns the current Psych Engine Online version.
--- @return string
local getPsychEngineOnlineVersion = function()
    local classForMainMenuState = 'states.MainMenuState'
    if version < '0.7.0' then
        -- 0.6.3 or lower
        classForMainMenuState = 'MainMenuState'
    end

    return getPropertyFromClass(classForMainMenuState, 'psychOnlineVersion')
end

--- Returns `true` if Anarchy Mode is enabled; else false
--- @return boolean
local isAnarchyMode = function()
    return getPropertyFromClass('online.GameClient', 'room.state.anarchyMode')
end

--- Returns `true` if the client is online; else false
--- @return boolean
local isClientOnline = function()
    return getPropertyFromClass('online.GameClient', 'room') ~= nil
end

--- Returns `true` if the client is the owner; else false
--- @return boolean
local isClientOwner = function()
    return getPropertyFromClass('online.GameClient', 'isOwner')
end

--- Returns `true` if the client is the opponent; else false
---
--- When offline, it'll return `opponentMode` from the class `states.PlayState`
--- @return boolean
local isOpponent = function()
    if getPropertyFromClass('online.GameClient', 'room') ~= nil then
        if getPropertyFromClass('online.GameClient', 'room.state.swagSides') then
            return not getPropertyFromClass('online.GameClient', 'isOwner')
        end
        return getPropertyFromClass('online.GameClient', 'isOwner')
    end

    local classForPlayState = 'states.PlayState'
    if version < '0.7.0' then
        -- 0.6.3 or lower
        classForPlayState = 'PlayState'
    end
    return getPropertyFromClass(classForPlayState, 'opponentMode')
end

--- Returns `true` if the game is private; else false
--- @return boolean
local isPrivateRoom = function()
    return getPropertyFromClass('online.GameClient', 'room.state.isPrivate')
end

--- Returns `true` if Swap Sides is enabled; else false
--- @return boolean
local isSwapSides = function()
    return getPropertyFromClass('online.GameClient', 'room.state.swagSides')
end

--- Toggles `opponentMode`; does not work online
local toggleOpponentMode = function()
    if getPropertyFromClass('online.GameClient', 'room') ~= nil then
        return
    end

    local classForPlayState = 'states.PlayState'
    if version < '0.7.0' then
        -- 0.6.3 or lower
        classForPlayState = 'PlayState'
    end

    local currentOpponentMode = getPropertyFromClass(classForPlayState, 'opponentMode')
    setPropertyFromClass(classForPlayState, 'opponentMode', not currentOpponentMode)

    -- switch sides
    setProperty('boyfriend.isPlayer', not getProperty('boyfriend.isPlayer'))
    setProperty('dad.isPlayer', not getProperty('dad.isPlayer'))

    if getProperty('boyfriend.isPlayer') then
        setHealth(2)
    else
        setHealth(-2)
    end
end

onlineutil = {
    _VERSION = '3.0.0',

    --- Table of default player stats in order
    tableDefaultPlayerStats = {
        0,
        0,
        0,
        0,
        0,
        0,
        '',
        false,
        false,
        false,
        0
    },

    --- Table of player stats in order as defined in `online/scheme/Player.hx`
    tablePlayerStatStrings = {
        'score',
        'misses',
        'sicks',
        'goods',
        'bads',
        'shits',
        'name',
        'hasSong',
        'hasLoaded',
        'hasEnded',
        'ping'
    },

    getPlayerStat = getPlayerStat,
    getPlayerStatsTable = getPlayerStatsTable,
    getPsychEngineOnlineVersion = getPsychEngineOnlineVersion,
    isAnarchyMode = isAnarchyMode,
    isClientOnline = isClientOnline,
    isClientOwner = isClientOwner,
    isOpponent = isOpponent,
    isPrivateRoom = isPrivateRoom,
    isSwapSides = isSwapSides,
    toggleOpponentMode = toggleOpponentMode
}

return onlineutil