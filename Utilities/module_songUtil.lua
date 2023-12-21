local songUtil = {}

---The file where dkjson is located
songUtil.dkJsonFilePath = 'mods/scripts/dkjson'

---The version of songUtil
songUtil.Version = '1.0.0'

---Loads a song from a different mod folder
---
---`weekJsonPath` starts from `mods/`, and `songTitle` and `difficultyName` must be exact.
---@param weekJsonPath string
---@param songTitle string
---@param difficultyName string
function songUtil.loadSongFromAnotherMod(weekJsonPath, songTitle, difficultyName)
	if type(weekJsonPath) ~= 'string' then
		debugPrint('Expected string for weekJsonPath, got ' .. type(weekJsonPath) .. '.')
		return -- use only strings for weekJsonPath
	elseif type(songTitle) ~= 'string' then
		debugPrint('Expected string for songTitle, got ' .. type(songTitle) .. '.')
		return -- use only strings for songTitle
	elseif type(difficultyName) ~= 'string' then
		debugPrint('Expected string for difficultyName, got ' .. type(difficultyName) .. '.')
		return -- use only strings for difficultyName
	end

	if stringStartsWith(weekJsonPath, 'mods/') then
		-- someone put mods/ in the filename
		weekJsonPath = weekJsonPath:sub(5, #weekJsonPath)
	end

	local modJsonPathString = 'mods/' .. weekJsonPath
	if not stringEndsWith(modJsonPathString, '.json') then
		-- someone forgot to put .json in the file ame
		modJsonPathString = modJsonPathString .. '.json'
		weekJsonPath = weekJsonPath .. '.json'
	end

	if not checkFileExists(modJsonPathString, true) then
		debugPrint('\'' .. modJsonPathString .. '\' does not exist.')
		return -- file does not exist
	end
	local dkjson = require(songUtil.dkJsonFilePath)
	local jsonContent = getTextFromFile(weekJsonPath, false)

	-- decode the json
	local jsonFileDK = dkjson.decode(jsonContent, 1, nil)
	local difficultyList = jsonFileDK.difficulties

	local difficultiesAsTable = {}
	local returnLineOfContent = {}
	local startOfTableElement = 1

	-- use lowercase, everything is case senseti
	difficultyName = difficultyName:lower()

	-- separate json difficulties into one list
	while startOfTableElement < #difficultyList do
		returnLineOfContent = ({ difficultyList:find(',', startOfTableElement) })
		if returnLineOfContent[1] == nil then
			returnLineOfContent[1] = #difficultyList + 1
		end
		table.insert(difficultiesAsTable, stringTrim(difficultyList:sub(startOfTableElement, tonumber(returnLineOfContent[1]) - 1)))
		startOfTableElement = tonumber(returnLineOfContent[1]) + 1
	end

	-- does the difficulty we're trying to play even exist.
	local difficultyToLoad = nil
	for i = 1, #difficultiesAsTable, 1 do
		if string.lower(difficultiesAsTable[i]) == 'normal' then
			-- normal difficulty should be treated as default difficulty
			difficultiesAsTable[i] = 'Normal'
		end

		if string.lower(difficultiesAsTable[i]) == difficultyName then
			difficultyToLoad = i - 1
		end
	end

	if difficultyToLoad == nil then
		debugPrint('\'' .. difficultyName .. '\' difficulty does not exist. Refer to the following table.')
		debugPrint(difficultiesAsTable)
		return -- difficulty does not exist
	end

	-- compatability with different versions of Psych Engine
	local classForCurrentModDirectory = 'backend.Mods'
	local classForDifficulty = 'backend.Difficulty'
	local difficultyArrayInClass = 'list'
	if version < '0.7.0' then
		-- 0.6.3 or lower
		classForCurrentModDirectory = 'Paths'
		classForDifficulty = 'CoolUtil'
		difficultyArrayInClass = 'difficulties'
	end

	-- set difficulties
	for i = 1, math.max(#difficultiesAsTable, getPropertyFromClass(classForDifficulty, difficultyArrayInClass .. '.length')), 1 do
		local difficultyNameFromHaxeArray = difficultyArrayInClass .. '[' .. i - 1 .. ']'

		if difficultiesAsTable[i] ~= nil then
			-- not nill because something there, funny
			setPropertyFromClass(classForDifficulty, difficultyNameFromHaxeArray, difficultiesAsTable[i])
		else
			-- nil because nothing there, scary
			setPropertyFromClass(classForDifficulty, difficultyNameFromHaxeArray, nil)
			setPropertyFromClass(classForDifficulty, difficultyArrayInClass .. '.length', i - 1)
		end
	end

	-- load mod directory
	local modFolderPath = weekJsonPath:sub(1, weekJsonPath:find('/') - 1)
	setPropertyFromClass(classForCurrentModDirectory, 'currentModDirectory', modFolderPath)

	loadSong(songTitle, difficultyToLoad)
end

return songUtil