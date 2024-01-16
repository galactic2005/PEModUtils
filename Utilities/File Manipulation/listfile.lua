local listfile = {
    _VERSION = '1.0.0',

    --- The most recent list file used regardless of context
    mostRecentFileUsed = '',

    --- The most recent list file read from
    mostRecentFileReadFrom = '',

    --- The most recent list file written to
    mostRecentFileWrittenTo = ''
}

--- Returns the contents of a list file as a table
---
--- If `startFromCurrentModDirectory` is not defined, it'll be `true`.
--- @param filePath string
--- @param startFromCurrentModDirectory? boolean
--- @return table
function listfile.read(filePath, startFromCurrentModDirectory)
    assert(type(filePath) == 'string', 'Expected string for path, got ' .. type(filePath) .. '.') -- use only strings for filePath
    if startFromCurrentModDirectory == nil then
        startFromCurrentModDirectory = true
    end

    if not stringEndsWith(filePath, '.txt') then
        -- user forgot to put .txt in the filename
        filePath = filePath .. '.txt'
    end
    assert(checkFileExists(filePath, startFromCurrentModDirectory), 'File at ' .. filePath .. ' does not exist.') -- file does not exist
    listfile.mostRecentFileUsed = filePath
    listfile.mostRecentFileReadFrom = filePath

    -- get text from file
    local file = getTextFromFile(filePath, not startFromCurrentModDirectory)

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

--- Reads one line of content from a file as a string; or `nil` if no file is found or if the file doesn't contain content
---
--- If `linePosition` isn't defined or is nil, then this function will return a random line of content.
---
--- If `startFromCurrentModDirectory` is not defined, it'll be `true`.
--- @param filePath string
--- @param startFromCurrentModDirectory? boolean
--- @param linePosition? integer
--- @return string
--- @return nil
function listfile.readLine(filePath, startFromCurrentModDirectory, linePosition)
    assert(type(filePath) == 'string', 'Expected string for path, got ' .. type(filePath) .. '.') -- use only strings for filePath
    if startFromCurrentModDirectory == nil then
        startFromCurrentModDirectory = true
    end

    local listOfContent = listfile.read(filePath, startFromCurrentModDirectory)
    if (not listOfContent) or #listOfContent < 1 then
        return nil
    end

    if (not linePosition) or linePosition < 1 then
        return tostring(listOfContent[getRandomInt(1, #listOfContent)])
    end
    return tostring(listOfContent[linePosition])
end

--- Reads all list files in the table given; if `indexPosition` is defined, then it'll read the list file at that index
---
--- Tables should be setup like the following:
---
--- ```lua
--- {
---     -- [1] path
---     -- [2] startFromCurrentModDirectory
---     {'', false},
---     {'data/credits.txt', true}
--- }
--- ```
--- @param tableOfListFiles table
--- @param indexPosition? number
--- @return string|table
function listfile.readTable(tableOfListFiles, indexPosition)
    assert(type(tableOfListFiles) == 'table', 'Expected table for tableOfListFiles, got ' .. type(tableOfListFiles) .. '.') -- use only tables for tableOfListFiles
    if indexPosition ~= nil then
        indexPosition = tonumber(indexPosition)
        if indexPosition < 1 then
            indexPosition = 1
        elseif indexPosition > #tableOfListFiles then
            indexPosition = #tableOfListFiles
        end

        return listfile.read(tableOfListFiles[indexPosition][1], tableOfListFiles[indexPosition][2])
    end

    local tableToReturn = {}
    for i = 1, #tableOfListFiles do
        tableToReturn[#tableToReturn+1] = listfile.read(tableOfListFiles[i][1], tableOfListFiles[i][2])
    end
    return tableToReturn
end

--- Writes a list file using a table
---
--- Any table elements in `tableToInsert` that are not a `number` or `string` will be skipped from being written.
--- If the file at `filePath` is an existing file, it'll be overwritten.
---
--- If `startFromCurrentModDirectory` is not defined, it'll be `true`.
--- @param filePath string
--- @param tableToInsert table
--- @param startFromCurrentModDirectory? boolean
function listfile.write(filePath, tableToInsert, startFromCurrentModDirectory)
    -- type asserts
    assert(type(filePath) == 'string', 'Expected string for path, got ' .. type(filePath) .. '.') -- use only strings for filePath
    assert(type(tableToInsert) == 'table', 'Expected table for tableToInsert, got ' .. type(tableToInsert) .. '.')-- use only tables for tableToInsert
    if startFromCurrentModDirectory == nil then
        startFromCurrentModDirectory = true
    end

    -- table length assert
    assert(#tableToInsert > 0, 'tableToInsert is empty.') --- tableToInsert is empty

    if not stringEndsWith(filePath, '.txt') then
        -- user forgot to put .txt in the filename
        filePath = filePath .. '.txt'
    end

    assert(checkFileExists(filePath, startFromCurrentModDirectory), 'File at ' .. filePath .. ' does not exist.') -- file does not exist
    if startFromCurrentModDirectory then
        filePath = currentModDirectory .. '/' .. filePath
    end

    local fileContent = ''
    listfile.mostRecentFileUsed = filePath
    listfile.mostRecentFileWrittenTo = filePath

    local tableElement = nil
    for i = 1, #tableToInsert do
        tableElement = tableToInsert[i]
        if type(tableElement) == 'number' or type(tableElement) == 'string' then
            fileContent = fileContent .. tostring(tableElement) .. '\n'
        end
    end
    saveFile(filePath, fileContent, not startFromCurrentModDirectory)
end

return listfile