local onlineUtil = {}

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

---Returns `{0, 0, 0, 0, 0, 0, '', false, false, false, 0}`
---
---These are the default stats of a player as defined in `online/scheme/Player.hx`
---@return table
function onlineUtil.getDefaultPlayerStats()
	return {0, 0, 0, 0, 0, 0, '', false, false, false, 0}
end

---Returns the current version of the module
---@return string
function onlineUtil.getPEOnlineUtilityVersion()
	return '1.0.0'
end

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
---`{nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}`
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
	return getPropertyFromClass('states.MainMenuState', 'psychOnlineVersion')
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
	return getPropertyFromClass('states.PlayState', 'opponentMode')
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

return onlineUtil