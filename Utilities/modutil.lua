--- Loads a song from a different mod folder
---
--- `weekJsonPath` starts from `mods/`; to get the current mod directory use the following:
---
--- ```lua
--- currentModDirectory .. 'weeks/weekFile'
--- ```
--- @param weekJsonPath string
--- @param songTitle string
--- @param difficultyName string
local loadSongFromAnotherMod = function(weekJsonPath, songTitle, difficultyName)
    assert(type(weekJsonPath) == 'string', 'Expected string for weekJsonPath, got ' .. type(weekJsonPath) .. '.') -- use only strings for weekJsonPath
    assert(type(songTitle) == 'string', 'Expected string for songTitle, got ' .. type(songTitle) .. '.') -- use only strings for songTitle
    assert(type(difficultyName) == 'string', 'Expected string for difficultyName, got ' .. type(difficultyName) .. '.') -- use only strings for difficultyName

    if stringStartsWith(weekJsonPath, 'mods/') then
        -- user put mods/ in the filename
        weekJsonPath = weekJsonPath:sub(5, #weekJsonPath)
    end

    local modJsonPathString = 'mods/' .. weekJsonPath
    if not stringEndsWith(modJsonPathString, '.json') then
        -- user forgot to put .json in the filename
        modJsonPathString = modJsonPathString .. '.json'
        weekJsonPath = weekJsonPath .. '.json'
    end
    assert(checkFileExists(modJsonPathString, true), 'File at ' .. modJsonPathString .. ' does not exist.') -- file does not exist

    local dkjson = require(modutil.dkJsonFilePath)
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
        difficultiesAsTable[#difficultiesAsTable+1] = stringTrim(difficultyList:sub(startOfTableElement, tonumber(returnLineOfContent[1]) - 1))
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
    assert(difficultyToLoad ~= nil, '\'' .. difficultyName .. '\' difficulty does not exist. Refer to the following table.\n' .. difficultiesAsTable)

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

local modutil = {
    _VERSION = '2.0.0',

    --- The file where dkjson is located
    dkJsonFilePath = 'mods/dkjson',

    loadSongFromAnotherMod = loadSongFromAnotherMod
}

return modutil