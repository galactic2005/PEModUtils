local onlineutil = {}

onlineutil._VERSION = '3.0.0'

--[[
    MIT License

    Copyright (c) 2023-2024 galatic_2005

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
]]

---Table of default player stats in order
onlineutil.tableDefaultPlayerStats = {
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
}

---Table of player stats in order as defined in `online/scheme/Player.hx`
onlineutil.tablePlayerStatStrings = {
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
}

--- Returns a player's current stat
---
--- If the `stat` does not exist, then it'll return `nil`
--- @param player any
--- @param stat string
--- @return any
function onlineutil.getPlayerStat(player, stat)
    assert(type(stat) == 'string', 'Expected string for stat, got ' .. type(stat) .. '.') -- use only strings for stat

    local playerType = tostring(player)
    assert(playerType == '1' or playerType == '2', 'player is ' .. playerType .. ', not \'1\' or \'2\'.') -- only player one or two
    return getPropertyFromClass('online.GameClient', 'room.state.player' .. playerType .. stat)
end

--- Returns a player's current stats
--- @param player any
--- @return table
function onlineutil.getPlayerStatsTable(player)
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
function onlineutil.getPsychEngineOnlineVersion()
    local classForMainMenuState = 'states.MainMenuState'
    if version < '0.7.0' then
        -- 0.6.3 or lower
        classForMainMenuState = 'MainMenuState'
    end

    return getPropertyFromClass(classForMainMenuState, 'psychOnlineVersion')
end

--- Returns `true` if Anarchy Mode is enabled; else false
--- @return boolean
function onlineutil.isAnarchyMode()
    return getPropertyFromClass('online.GameClient', 'room.state.anarchyMode')
end

--- Returns `true` if the client is online; else false
--- @return boolean
function onlineutil.isClientOnline()
    return getPropertyFromClass('online.GameClient', 'room') ~= nil
end

--- Returns `true` if the client is the owner; else false
--- @return boolean
function onlineutil.isClientOwner()
    return getPropertyFromClass('online.GameClient', 'isOwner')
end

--- Returns `true` if the client is the opponent; else false
---
--- When offline, it'll return `opponentMode` from the class `states.PlayState`
--- @return boolean
function onlineutil.isOpponent()
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
function onlineutil.isPrivateRoom()
    return getPropertyFromClass('online.GameClient', 'room.state.isPrivate')
end

--- Returns `true` if Swap Sides is enabled; else false
--- @return boolean
function onlineutil.isSwapSides()
    return getPropertyFromClass('online.GameClient', 'room.state.swagSides')
end

--- Toggles `opponentMode`; does not work online
function onlineutil.toggleOpponentMode()
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

return onlineutil