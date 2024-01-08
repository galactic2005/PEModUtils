local fileutil = {}

fileutil._VERSION = '3.0.2'

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

--- The most recent file used regardless of context
fileutil.mostRecentFileUsed = ''

--- The most recent file read from
fileutil.mostRecentFileReadFrom = ''

--- The most recent file written to
fileutil.mostRecentFileWrittenTo = ''

--- Gets the current mods list from `modsList.txt`
---
--- `type` should be one of the following:
---
--- * `'all'` - Gets all mods regardless of activeness.
--- * `'active'` - Gets all mods that are active.
--- * `'inactive'` - Gets all mods that are inactive.
---
--- If `type` is not of one of these three strings, then it'll default to `'all'`.
--- @param type string
--- @return table
function fileutil.getModsList(type)
    type = type:lower()
    if type == 'enabled' then
        type = 'active'
    elseif type == 'disabled' then
        type = 'inactive'
    elseif type ~= 'all' and type ~= 'active' and type ~= 'inactive' then
        type = 'all'
    end
    assert(checkFileExists('modsList.txt', true), 'modsList.txt does not exist.') -- modsList.txt does not exist

    local modsListFile = getTextFromFile('../modsList.txt', false)
    fileutil.mostRecentFileUsed = 'modsList.txt'
    fileutil.mostRecentFileReadFrom = 'modsList.txt'

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
            addModToList = type == 'all' or type == 'active'
        else
            addModToList = type == 'all' or type == 'inactive'
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

--- Converts lua scripts to remove their depreciate counterparts
---
--- As this currently only renames functions, remember to manually touch-up your script.
--- @param path string
--- @param startFromCurrentModDirectory boolean
function fileutil.removeDepreciatesFromScript(path, startFromCurrentModDirectory)
    assert(type(path) == 'string', 'Expected string for path, got ' .. type(path) .. '.') -- use only strings for path
    assert(type(startFromCurrentModDirectory) == 'boolean', 'Expected boolean for startFromCurrentModDirectory, got ' .. type(startFromCurrentModDirectory) .. '.') -- use only booleans for startFromCurrentModDirectory

    if startFromCurrentModDirectory then
        path = currentModDirectory .. '/' .. path
    end

    if not stringEndsWith(path, '.lua') then
        -- user forgot to put .lua in the filename
        path = path .. '.lua'
    end
    assert(checkFileExists(path, false), 'File at ' .. path .. ' does not exist.') -- file does not exist
    fileutil.mostRecentFileUsed = path
    fileutil.mostRecentFileReadFrom = path
    fileutil.mostRecentFileWrittenTo = path

    -- get text from file
    local file = getTextFromFile(path, false)

    -- lots of gsub
    local result = nil
    result = file:gsub('luaSpriteMakeGraphic', 'makeGraphic')
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
    saveFile(path, result, false)
end

--- Returns the contents of a list file as a table
---
--- Refer to `characterList.txt`, `stageList.txt`, or `weekList.txt` for formatting of list files
--- @param path string
--- @param startFromCurrentModDirectory boolean
--- @return table
function fileutil.readListFile(path, startFromCurrentModDirectory)
    assert(type(path) == 'string', 'Expected string for path, got ' .. type(path) .. '.') -- use only strings for path
    assert(type(startFromCurrentModDirectory) == 'boolean', 'Expected boolean for startFromCurrentModDirectory, got ' .. type(startFromCurrentModDirectory) .. '.') -- use only booleans for startFromCurrentModDirectory

    if not stringEndsWith(path, '.txt') then
        -- user forgot to put .txt in the filename
        path = path .. '.txt'
    end
    assert(checkFileExists(path, startFromCurrentModDirectory), 'File at ' .. path .. ' does not exist.') -- file does not exist
    fileutil.mostRecentFileUsed = path
    fileutil.mostRecentFileReadFrom = path

    -- get text from file
    local file = getTextFromFile(path, not startFromCurrentModDirectory)

    local contentsOfFile = {}
    local returnLineOfContent = {0, 0}
    local startOfTableElement = 1

    while startOfTableElement < #file do
        -- return a line of content
        returnLineOfContent = ({ file:find('\n', startOfTableElement) })
        if not returnLineOfContent[1] then
            returnLineOfContent[1] = #file + 1
        end

        -- insert into contentsOfFile
        contentsOfFile[#contentsOfFile+1] = file:sub(startOfTableElement, tonumber(returnLineOfContent[1]) - 1)
        startOfTableElement = tonumber(returnLineOfContent[1]) + 1
    end

    -- return table
    return contentsOfFile
end

--- Writes a list file using a table
---
--- Any table elements in `tableToInsert` that are not a `number` or `string` will be skipped from being written.
--- If the file at `path` is an existing file, it'll be overwritten.
---@param path string
---@param tableToInsert table
---@param startFromCurrentModDirectory boolean
function fileutil.writeListFile(path, tableToInsert, startFromCurrentModDirectory)
    -- type asserts
    assert(type(path) == 'string', 'Expected string for path, got ' .. type(path) .. '.') -- use only strings for path
    assert(type(tableToInsert) == 'table', 'Expected table for tableToInsert, got ' .. type(tableToInsert) .. '.')-- use only tables for tableToInsert
    assert(type(startFromCurrentModDirectory) == 'boolean', 'Expected boolean for startFromCurrentModDirectory, got ' .. type(startFromCurrentModDirectory) .. '.') -- use only booleans for startFromCurrentModDirectory

    -- table length assert
    assert(#tableToInsert > 0, 'tableToInsert is empty.') --- tableToInsert is empty

    if not stringEndsWith(path, '.txt') then
        -- user forgot to put .txt in the filename
        path = path .. '.txt'
    end

    assert(checkFileExists(path, startFromCurrentModDirectory), 'File at ' .. path .. ' does not exist.') -- file does not exist
    if startFromCurrentModDirectory then
        path = currentModDirectory .. '/' .. path
    end

    local fileContent = ''
    fileutil.mostRecentFileUsed = path
    fileutil.mostRecentFileWrittenTo = path

    local tableElement = nil
    for i = 1, #tableToInsert do
        tableElement = tableToInsert[i]
        if type(tableElement) == 'number' or type(tableElement) == 'string' then
            fileContent = fileContent .. tostring(tableElement) .. '\n'
        end
    end
    saveFile(path, fileContent, not startFromCurrentModDirectory)
end

--- Reads one line of content from a file as a string; or `nil` if no file is found or if the file doesn't contain content.
---
--- If `linePosition` isn't specified, then this function will return a random line of content.
--- @param path string
--- @param startFromModDirectory boolean
--- @param linePosition? integer
--- @return string
--- @return nil
function fileutil.readLineFromFile(path, startFromCurrentModDirectory, linePosition)
    -- type asserts
    assert(type(path) == 'string', 'Expected string for path, got ' .. type(path) .. '.') -- use only strings for path
    assert(type(startFromCurrentModDirectory) == 'boolean', 'Expected boolean for startFromCurrentModDirectory, got ' .. type(startFromCurrentModDirectory) .. '.') -- use only booleans for startFromCurrentModDirectory

    local listOfContent = fileutil.readListFile(path, startFromCurrentModDirectory)
    if (not listOfContent) or #listOfContent < 1 then
        return nil
    end

    if (not linePosition) or linePosition < 1 then
        return tostring(listOfContent[getRandomInt(1, #listOfContent)])
    end
    return tostring(listOfContent[linePosition])
end

return fileutil