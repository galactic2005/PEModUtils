local onlineUtil = {}

--[[
	MIT License

	Copyright (c) 2023 galatic_2005

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
onlineUtil.tableDefaultPlayerStats = {
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
onlineUtil.tablePlayerStatStrings = {
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

---The version of onlineUtil
onlineUtil.Version = '2.0.0'

---Returns a player's current stat
---
---If `player` isn't one or two or if the `stat` does not exist, then it'll return `nil`
---@param player any
---@param stat string
---@return any
function onlineUtil.getPlayerStat(player, stat)
	local playerType = tostring(player)
	if playerType ~= '1' and playerType ~= '2' then
		return nil
	end
	return getPropertyFromClass('online.GameClient', 'room.state.player' .. playerType .. stat)
end

---Returns a player's current stats
---
---If `player` isn't one or two, it returns the following table:
---
---```lua
---{nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
---```
---@param player any
---@return table
function onlineUtil.getPlayerStatsTable(player)
	local playerType = tostring(player)
	if playerType ~= '1' and playerType ~= '2' then
		return {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
	end
	local statTable = {}

	local statToGrab = nil
	for index = 1, #onlineUtil.tablePlayerStatStrings do
		statToGrab = getPropertyFromClass('online.GameClient', 'room.state.player' .. playerType .. '.' .. onlineUtil.tablePlayerStatStrings[index])
		table.insert(statTable, statToGrab)
	end

	return statTable
end

---Returns the current Psych Engine Online version.
---@return string
function onlineUtil.getPsychEngineOnlineVersion()
	local classForMainMenuState = 'states.MainMenuState'
	if version < '0.7.0' then
		-- 0.6.3 or lower
		classForMainMenuState = 'MainMenuState'
	end

	return getPropertyFromClass(classForMainMenuState, 'psychOnlineVersion')
end

---Returns `true` if Anarchy Mode is enabled; else false
---@return boolean
function onlineUtil.isAnarchyMode()
	return getPropertyFromClass('online.GameClient', 'room.state.anarchyMode')
end

---Returns `true` if the client is online; else false
---@return boolean
function onlineUtil.isClientOnline()
	return getPropertyFromClass('online.GameClient', 'room') ~= nil
end

---Returns `true` if the client is the owner; else false
---@return boolean
function onlineUtil.isClientOwner()
	return getPropertyFromClass('online.GameClient', 'isOwner')
end

---Returns `true` if the client is the opponent; else false
---
---When offline, it'll return `opponentMode` from the class `states.PlayState`
---@return boolean
function onlineUtil.isOpponent()
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

---Returns `true` if the game is private; else false
---@return boolean
function onlineUtil.isPrivateRoom()
	return getPropertyFromClass('online.GameClient', 'room.state.isPrivate')
end

---Returns `true` if Swap Sides is enabled; else false
---@return boolean
function onlineUtil.isSwapSides()
	return getPropertyFromClass('online.GameClient', 'room.state.swagSides')
end

---Toggles `opponentMode`; does not work online
function onlineUtil.toggleOpponentMode()
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
		addHealth(2)
	else
		addHealth(-2)
	end
end

return onlineUtil