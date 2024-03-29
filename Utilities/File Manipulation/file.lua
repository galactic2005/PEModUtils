local file = {
    _AUTHORS = 'galactic_2005',
    _VERSION = '5.0.0',

    --- The most recent file used regardless of context
    mostRecentFileUsed = '',

    --- The most recent file read from
    mostRecentFileReadFrom = '',

    --- The most recent file written to
    mostRecentFileWrittenTo = '',
}

--- Gets the current mods list from `modsList.txt` as a table
---
--- `fetchType` should be one of the following:
---
--- * `'all'` - Gets all mods regardless of activeness.
--- * `'active'` / `true` - Gets all mods that are active.
--- * `'inactive'` / `false` - Gets all mods that are inactive.
---
--- If `fetchType` is not of one of these three strings, is nil, or isn't defined, it'll default to `'all'`.
--- @param fetchType? boolean|string
--- @return table
function file.getModsList(fetchType)
    if type(fetchType) == 'boolean' then
        if fetchType then
            fetchType = 'active'
        else
            fetchType = 'inactive'
        end
    else
        fetchType = fetchType:lower()
        if fetchType == 'active' or fetchType == 'enabled' then
            fetchType = 'active'
        elseif fetchType == 'inactive' or fetchType == 'disabled' then
            fetchType = 'inactive'
        else
            fetchType = 'all'
        end
    end
    assert(checkFileExists('modsList.txt', true), 'modsList.txt does not exist.') -- make sure modsList.txt exists

    local modsListFile = getTextFromFile('../modsList.txt', false)
    file.mostRecentFileUsed = 'modsList.txt'
    file.mostRecentFileReadFrom = 'modsList.txt'

    local addModToList = false
    local listOfMods = {}
    local modName = ''
    local returnLineOfContent = {0, 0}
    local startOfTableElement = 1

    while startOfTableElement < #modsListFile do
        -- return a line of content
        returnLineOfContent = ({ modsListFile:find('\n', startOfTableElement) })
        if not returnLineOfContent[1] then
            returnLineOfContent[1] = #modsListFile + 1
        end

        modName = stringTrim(modsListFile:sub(startOfTableElement, tonumber(returnLineOfContent[1]) - 1))
        if stringEndsWith(modName, '1') then
            addModToList = fetchType == 'all' or fetchType == 'active'
        else
            addModToList = fetchType == 'all' or fetchType == 'inactive'
        end

        if addModToList then
            -- insert into listOfMods
            modName = modName:sub(1, #modName - 2)
            listOfMods[#listOfMods+1] = modName
        end
        startOfTableElement = tonumber(returnLineOfContent[1]) + 1
    end

    -- return table
    return listOfMods
end

--- Checks if `fileString` is a folder or not by searching for a period (.)
---
--- If `startFromCurrentModDirectory` is not defined, it'll be `true`.
--- @param filePath string
--- @param startFromCurrentModDirectory? boolean
--- @return boolean
function file.isFolder(filePath, startFromCurrentModDirectory)
    assert(type(filePath) == 'string', 'Expected string for filePath, got ' .. type(filePath) .. '.') -- use only strings for filePath
    if startFromCurrentModDirectory == nil then
        startFromCurrentModDirectory = true
    end

    if startFromCurrentModDirectory then
        filePath = 'mods/' .. currentModDirectory .. '/' .. filePath
    end
    return not filePath:find('%.')
end

--- Converts lua scripts to remove their depreciate counterparts
---
--- As this currently only renames functions, remember to manually touch-up your script.
---
--- If `startFromCurrentModDirectory` is not defined, it'll be `true`.
--- @param filePath string
--- @param startFromCurrentModDirectory? boolean
function file.removeDepreciatesFromScript(filePath, startFromCurrentModDirectory)
    assert(type(filePath) == 'string', 'Expected string for filePath, got ' .. type(filePath) .. '.') -- use only strings for filePath
    if startFromCurrentModDirectory == nil then
        startFromCurrentModDirectory = true
    end

    if startFromCurrentModDirectory then
        filePath = currentModDirectory .. '/' .. filePath
    end

    if not stringEndsWith(filePath, '.lua') then
        -- user forgot to put .lua in the filename
        filePath = filePath .. '.lua'
    end
    assert(checkFileExists(filePath, false), 'File at ' .. filePath .. ' does not exist.') -- make sure the file you've selected exists
    file.mostRecentFileUsed = filePath
    file.mostRecentFileReadFrom = filePath
    file.mostRecentFileWrittenTo = filePath

    -- get text from file
    local luaFile = getTextFromFile(filePath, false)

    -- lots of gsub
    local result = luaFile:gsub('luaSpriteMakeGraphic', 'makeGraphic')
    result = result:gsub('luaSpriteAddAnimationByPrefix', 'addAnimationByPrefix')
    result = result:gsub('luaSpriteAddAnimationByIndices', 'addAnimationByIndices')
    result = result:gsub('addAnimationByIndicesLoop', 'addAnimationByIndices')
    result = result:gsub('luaSpritePlayAnimation', 'playAnim')
    result = result:gsub('objectPlayAnimation', 'playAnim')
    result = result:gsub('characterPlayAnim', 'playAnim')
    result = result:gsub('setLuaSpriteCamera', 'setObjectCamera')
    result = result:gsub('setLuaSpriteScrollFactor', 'setScrollFactor')
    result = result:gsub('scaleLuaSprite', 'scaleObject')
    result = result:gsub('setPropertyLuaSprite', 'setProperty')
    result = result:gsub('getPropertyLuaSprite', 'getProperty')
    result = result:gsub('musicFadeIn', 'soundFadeIn')
    result = result:gsub('musicFadeOut', 'soundFadeOut')

    -- save file
    saveFile(filePath, result, false)
end

return file