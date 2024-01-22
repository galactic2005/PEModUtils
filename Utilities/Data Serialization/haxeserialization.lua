local haxeserialization = {
    _AUTHORS = 'galactic_2005',
    _VERSION = '1.0.0',

    --- Serialized data that is created from the serializeData function.
    serializedData = ''
}

-- http://lua-users.org/wiki/SwitchStatement
--
-- thanks LHF, DaveBollinger, EricTetz, and PeterPrade

local function switch(term, cases)
    local function contain(element, table)
        for _, value in pairs(table) do
            if value == element then
                return true
            end
        end
        return false
    end

    assert(type(cases) == 'table')
    local casetype, caseparm, casebody
    for _, case in ipairs(cases) do
        assert(type(case) == 'table' and #case == 3)
        casetype, caseparm, casebody = case[1], case[2], case[3]
        assert(type(casetype) == 'string' and type(casebody) == 'function')
        if
            (casetype == 'default')
        or  ((casetype == 'eq' or casetype == '') and caseparm == term)
        or  ((casetype == '!eq' or casetype == '!') and not caseparm == term)
        or  (casetype == 'in' and contain(term, caseparm))
        or  (casetype == '!in' and not contain(term, caseparm))
        then
            return casebody(term)
        elseif
            (casetype == 'default-fall')
        or  ((casetype == 'eq-fall' or casetype == 'fall') and caseparm == term)
        or  ((casetype == '!eq-fall' or casetype == '!-fall') and not caseparm == term)
        or  (casetype == 'in-fall' and contain(term, caseparm))
        or  (casetype == '!in-fall' and not contain(term, caseparm))
        then
            casebody(term)
        end
    end
end

local cache = {}
local stringCache = { unserialization = {}, serialization = {} }

local actualData = ''
local dataPosition = 1
local fullDataLength = 0
local isUsingExternalData = false

-- https://gist.github.com/liukun/f9ce7d6d14fa45fe9b924a3eed5c3d99
local function urlEncode(url)
    if url == nil then
        return ''
    end

    local function characterToHex(character)
        return string.format("%%%02X", string.byte(character))
    end

    return url:gsub("\n", "\r\n"):gsub("([^%w ])", characterToHex):gsub(" ", "+")
end

local function urlDecode(url)
    if url == nil then
        return ''
    end

    local function hexToCharacter(hex)
        return string.char(tonumber(hex, 16))
    end

    return url:gsub("+", " "):gsub("%%(%x%x)", hexToCharacter)
end

--- @param newData string
local function addData(newData)
    haxeserialization.serializedData = haxeserialization.serializedData .. newData
end

--- @param data any
--- @param dataType string
local function serialize(data, dataType) end

--- @param data string
local function unserialize(data) end

--- @param cacheKey number
--- @param dataType string
local function handleTableUnserialization(cacheKey, dataType) end

--- @return number
local function readDigits()
    local digits = 0

    local currentCharacter = ''
    local firstPosition = dataPosition
    local isNegative = false

    dataPosition = dataPosition + 1
    while true do
        currentCharacter = actualData:sub(dataPosition, dataPosition)
        if currentCharacter == '\n' then
            break
        elseif currentCharacter == '-' then
            if dataPosition ~= firstPosition then
                break
            end
            isNegative = true
            dataPosition = dataPosition + 1
        elseif currentCharacter:match('%d') ~= nil then
            digits = digits * 10 + tonumber(currentCharacter)
            dataPosition = dataPosition + 1
        else
            break
        end
    end

    if isNegative then
        digits = digits * -1
    end
    return digits
end

--- @return number
local function readFloat()
    local currentCharacter = ''
    local firstPosition = dataPosition

    dataPosition = dataPosition + 1
    while true do
        currentCharacter = actualData:sub(dataPosition, dataPosition)
        if currentCharacter == '\n' then
            break
        elseif currentCharacter:match('[+-9]') then
            dataPosition = dataPosition + 1
        else
            break
        end
    end

    return tonumber(actualData:sub(firstPosition + 1, dataPosition - firstPosition))
end

--- @param dataTable table
--- @param dataType string
local function handleTableSerialization(dataTable, dataType)
    assert(type(dataTable) == 'table', 'Unserialized data is' .. type(dataTable) .. 'for dataType' .. dataType .. '. Must be table.')

    local data = nil
    --- @param table table
    --- @return table
    local function getListOfTableKeys(table)
        local keyset = {}
        for key, _ in pairs(table) do
            if key ~= '__tableDef' then
                keyset[#keyset+1] = key
            end
        end
        return keyset
    end

    if dataType == 'array' then
        local nilAmount = 0
        local function nilAmountHandler()
            if nilAmount < 1 then
                return
            end

            if nilAmount == 1 then
                addData('n')
            else
                addData('u')
                addData(nilAmount)
            end
            nilAmount = 0
        end

        addData('a')
        for i = 1, #dataTable do
            data = dataTable[i]
            if data == nil then
                nilAmount = nilAmount + 1
            else
                nilAmountHandler()
                serialize(data, type(data))
            end
            nilAmountHandler()
        end
        addData('h')
    elseif dataType == 'list' then
        addData('l')
        for i = 1, #dataTable do
            data = dataTable[i]
            serialize(data, type(data))
        end
        addData('h')
    elseif dataType == 'object' or dataType == 'stringmap' then
        local listOfKeys = getListOfTableKeys(dataTable)

        addData((dataType == 'object' and 'o') or 'b')
        for _, key in ipairs(listOfKeys) do
            serialize(key, 'string')

            data = dataTable[key]
            serialize(data, type(data))
        end
        addData((dataType == 'object' and 'g') or 'h')
    else
        assert(false, 'Cannot serialize table with dataType of ' .. dataType '.')
    end
end

--- @param cacheKey number
--- @param dataType string
--- @return table
function handleTableUnserialization(cacheKey, dataType)
    --- @return table
    local getCacheFinal = function()
        actualData = actualData:sub(2, #actualData)

        local cacheFinal = cache[cacheKey]
        cache[cacheKey] = nil
        return cacheFinal
    end

    if dataType == 'object' then
        local key = nil
        local objectLength = #actualData
        local value = nil

        while true do
            assert(dataPosition <= objectLength, 'Object is invalid because it did not close properly.')
            if actualData:sub(dataPosition, dataPosition) == 'g' then
                return getCacheFinal()
            end
            key = unserialize(actualData)
            if key == '__objectEnd' then
                return getCacheFinal()
            end
            assert(type(key) == 'string', 'Invalid object key because it is type ' .. type(key) .. '. Must be string.')

            value = unserialize(actualData)
            cache[cacheKey][key] = value
        end
    end

    assert(false, 'Cannot unserialize table with dataType of ' .. dataType '.')
    return { }
end

--- @param data any
--- @param dataType string
function serialize(data, dataType)
    if type(data) == 'table' and data['__tableDef'] ~= nil then
        dataType = data['__tableDef']
    end

    switch(dataType, {
        {'eq', 'boolean', function()
            -- true or false
            addData(((data) and 't') or 'f')
        end},
        {'eq', 'list', function()
            -- list
            handleTableSerialization(data, 'list')
        end},
        {'eq', 'object', function()
            -- object
            handleTableSerialization(data, 'object')
        end},
        {'eq', 'string', function()
            -- string
            data = tostring(data)
            if stringCache.serialization[data] ~= nil then
                -- string cache reference
                addData('R' .. stringCache.serialization[data])
                return
            end

            -- string
            data = urlEncode(data)
            addData('y' .. #data .. ':' .. data)
        end},
        {'eq', 'stringmap', function()
            -- stringmap
            handleTableSerialization(data, 'stringmap')
        end},


        {'in', {nil, 'nil'}, function()
            -- nil
            addData('n')
        end},
        {'in', {'number', 'float', 'integer'}, function()
            local numberData= tonumber(data)
            local _, f = math.modf(numberData)
            if f == 0 then
                if numberData == 0 then
                    -- zero
                    addData('z')
                else
                    -- integer
                    addData('i' .. numberData)
                end
            else
                if numberData ~= numberData then
                    -- nan value
                    addData('k')
                elseif math.abs(numberData) == math.huge then
                    -- -infinity or infinity
                    addData(((numberData < 0) and 'm') or 'p')
                else
                    -- float
                    addData('d' .. numberData)
                end
            end
        end},
        {'in', {'table', 'array'}, function()
            -- array
            handleTableSerialization(data, 'array')
        end},

        -- default
        {'default', '', function()
            if type(data) == 'table' and data['__tableDef'] ~= nil then
                assert(false, 'Cannot serialize ' .. dataType .. ' from [\'__tableDef\'].')
                return
            end
            assert(false, 'Cannot serialize ' .. dataType .. '.')
        end}
    })
end

local unserializedDataHandler = {
    ['n'] = function()
        -- nil
        dataPosition = dataPosition + 1
        return nil
    end,
    ['t'] = function()
        -- true
        dataPosition = dataPosition + 1
        return true
    end,
    ['f'] = function()
        -- false
        dataPosition = dataPosition + 1
        return false
    end,
    ['z'] = function()
        -- zero
        dataPosition = dataPosition + 1
        return 0
    end,
    ['i'] = function()
        -- integer
        return readDigits()
    end,
    ['d'] = function()
        -- float
        return readFloat()
    end,
    ['y'] = function()
        -- string
        local stringLength = readDigits()
        assert(actualData:sub(dataPosition, dataPosition) == ':' or fullDataLength - dataPosition < stringLength, 'Invalid string length.')

        local stringValue = urlDecode(actualData:sub(dataPosition + 1, dataPosition + stringLength))
        stringCache.unserialization[#stringCache.unserialization+1] = stringValue

        dataPosition = dataPosition + stringLength + 1
        return stringValue
    end,
    ['k'] = function()
        -- NaN
        dataPosition = dataPosition + 1
        return 0 / 0
    end,
    ['m'] = function()
        -- -infinity
        dataPosition = dataPosition + 1
        return -math.huge
    end,
    ['o'] = function()
        -- object
        local key = #cache + 1
        cache[key] = {}
        return handleTableUnserialization(key, 'object')
    end,
    ['g'] = function()
        -- object end
        return '__objectEnd'
    end,
    ['R'] = function()
        -- string cache reference
        local stringCacheNumber = readDigits()
        assert(stringCacheNumber > 0 or stringCacheNumber < #stringCache.unserialization, 'Invalid reference.')

        return stringCache.unserialization[stringCacheNumber]
    end,
    ['x'] = function()
        -- exception
        dataPosition = dataPosition + 1
        return assert(false)
    end,
    ['p'] = function()
        -- infinity
        dataPosition = dataPosition + 1
        return math.huge
    end
}

function unserialize()
    local function setActualData()
        actualData = actualData:sub(dataPosition, #actualData)
        if isUsingExternalData then
            haxeserialization.serializedData = actualData
        end
        dataPosition = 0
    end

    dataPosition = dataPosition + 1

    local dataStartsWith = actualData:sub(dataPosition, dataPosition)
    local unserializedData = nil

    if unserializedDataHandler[dataStartsWith] then
        unserializedData = unserializedDataHandler[dataStartsWith]()
    else
        debugPrint('Cannot unserialize data that starts with \'' .. dataStartsWith .. '\'.')

        setActualData()
        return nil
    end

    setActualData()
    return unserializedData
end

--- Sterializes data in the Haxe format
---
--- Please refer to the documentation for manual types available with `forcedDataType`.
---
--- If `forcedDataType` is left blank or as a nil value, then it'll determine type automatically based on the `type(v)` function.
---
--- Refer to https://haxe.org/manual/std-serialization.html for more information on serialization.
--- @param unserializedData any
--- @param forcedDataType? string
function haxeserialization.serializeData(unserializedData, forcedDataType)
    local dataType = ''
    if not forcedDataType or forcedDataType == '' then
        dataType = type(unserializedData)
    else
        dataType = forcedDataType:lower()
    end
    serialize(unserializedData, dataType)
end

--- Returns unserialized data created in the Haxe format
---
--- Not all serialized data types are currently available; please refer to the documentation.
---
--- If `serializedData` is left as nil or blank, then it'll use `serializedData`.
---
--- Refer to https://haxe.org/manual/std-serialization.html for more information on serialization.
--- @param serializedData? string
--- @return any
--- @nodiscard
function haxeserialization.unserializeData(serializedData)
    isUsingExternalData = serializedData == nil or serializedData == ''
    if isUsingExternalData then
        serializedData = haxeserialization.serializedData
    end
    assert(type(serializedData) == 'string', 'Data is expected to be string, got ' .. type(serializedData) .. '.')

    actualData = serializedData
    fullDataLength = #serializedData

    dataPosition = 0
    return unserialize()
end

--- Returns a table of the whole unserialized data created in the Haxe format
--- @param serializedData? string|nil
--- @return table
--- @nodiscard
function haxeserialization.unserializeDataWhole(serializedData)
    isUsingExternalData = serializedData == nil or serializedData == ''

    if isUsingExternalData then
        serializedData = haxeserialization.serializedData
    end
    assert(type(serializedData) == 'string', 'Data is expected to be string, got ' .. type(serializedData) .. '.')

    actualData = serializedData
    fullDataLength = #serializedData

    dataPosition = 0

    local wholeData = {}
    while #actualData > 0 do
        wholeData[#wholeData+1] = unserialize()
    end
    return wholeData
end

return haxeserialization