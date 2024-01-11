local datautil = {}

--#region general local functions and variables

--- @param decimal number
--- @param stringStart number
local function decimalToHex(decimal, stringStart)
    local stringHex = tostring(("%X"):format(tostring(decimal)))
    return stringHex:sub(#stringHex - stringStart, #stringHex)
end

-- https://gist.github.com/liukun/f9ce7d6d14fa45fe9b924a3eed5c3d99
local charToHex = function(c)
    return string.format("%%%02X", string.byte(c))
end

local urlEncode = function(url)
    if url == nil then
        return ''
    end
    return url:gsub("\n", "\r\n"):gsub("([^%w ])", charToHex):gsub(" ", "+")
end

local hexToChar = function(x)
    return string.char(tonumber(x, 16))
end

local urlDecode = function(url)
    if url == nil then
        return ''
    end
    return url:gsub("+", " "):gsub("%%(%x%x)", hexToChar)
end

--#endregion

--#region color

--- A version of `getPixelColor` that automatically converts variables using the other functions listed
---
--- Refer to documenation of  `getPixelColor` for more information on this function
--- @param obj string
--- @param x number
--- @param y number
local api_getPixelColor = function(obj, x, y)
    return decimalToHex(getPixelColor(obj, tonumber(x), tonumber(y)), 7)
end

--- Returns a client's RGB preference from a specified strum line as a string hex value
---
--- `strumNoteID` should be any integer between 0-3.
---
--- Any version of Psych Engine below 0.7.0 will return a table consisting of nil instead.
--- @param strumNoteID integer
--- @param usePixelRGB? boolean
--- @return table
local getClientRGBFromStrum = function (strumNoteID, usePixelRGB)
    if version < '0.7.0' then
        return {nil, nil, nil}
    end
    assert(strumNoteID > -1, 'strumNoteID is at a value of ' .. strumNoteID .. ', which is below 0.')
    assert(strumNoteID < 4, 'strumNoteID is at a value of ' .. strumNoteID .. ', which is above 3.')

    local arrowRGB = (usePixelRGB and 'data.arrowRGBPixel') or 'data.arrowRGB'
    local tableOfRGBUnconverted = getPropertyFromClass('backend.ClientPrefs', arrowRGB .. '[' .. strumNoteID .. ']')

    local r = decimalToHex(tableOfRGBUnconverted[1], 5)
    local g = decimalToHex(tableOfRGBUnconverted[2], 5)
    local b = decimalToHex(tableOfRGBUnconverted[3], 5)
    return {r, g, b}
end

--#endregion

--#region haxe

local haxe = {
    cache = {},
    stringCache = { unserialization = {}, serialization = {} },

    actualData = '',
    dataPosition = 1,
    fullDataLength = 0,
    useInternalData = false,

    --- @param newData string
    addData = function(newData)
        local data = datautil.haxe.serializedData
        datautil.haxe.serializedData = data .. newData
    end
}

--- @param data any
--- @param dataType string
local serialize = function(data, dataType) end

--- @param data string
local unserialize = function(data) end

--- @param cacheKey number
--- @param dataType string
local handleTableUnserialization = function(cacheKey, dataType) end

haxe.readDigits = function()
    local digits = 0

    local currentCharacter = ''
    local firstPosition = haxe.dataPosition
    local isNegative = false

    haxe.dataPosition = haxe.dataPosition + 1
    while true do
        currentCharacter = haxe.actualData:sub(haxe.dataPosition, haxe.dataPosition)
        if currentCharacter == '\n' then
            break
        elseif currentCharacter == '-' then
            if haxe.dataPosition ~= firstPosition then
                break
            end
            isNegative = true
            haxe.dataPosition = haxe.dataPosition + 1
        elseif currentCharacter:match('%d') ~= nil then
            digits = digits * 10 + tonumber(currentCharacter)
            haxe.dataPosition = haxe.dataPosition + 1
        else
            break
        end
    end

    if isNegative then
        digits = digits * -1
    end
    return digits
end

haxe.readFloat = function()
    local currentCharacter = ''
    local firstPosition = haxe.dataPosition

    haxe.dataPosition = haxe.dataPosition + 1
    while true do
        currentCharacter = haxe.actualData:sub(haxe.dataPosition, haxe.dataPosition)
        if currentCharacter == '\n' then
            break
        elseif currentCharacter:match('[+-9]') then
            haxe.dataPosition = haxe.dataPosition + 1
        else
            break
        end
    end

    return tonumber(haxe.actualData:sub(firstPosition + 1, haxe.dataPosition - firstPosition))
end

haxe.dataHandler = {
    ['n'] = function()
        -- nil
        haxe.dataPosition = haxe.dataPosition + 1
        return nil
    end,
    ['t'] = function()
        -- true
        haxe.dataPosition = haxe.dataPosition + 1
        return true
    end,
    ['f'] = function()
        -- false
        haxe.dataPosition = haxe.dataPosition + 1
        return false
    end,
    ['z'] = function()
        -- zero
        haxe.dataPosition = haxe.dataPosition + 1
        return 0
    end,
    ['i'] = function()
        -- integer
        return haxe.readDigits()
    end,
    ['d'] = function()
        -- float
        return haxe.readFloat()
    end,
    ['y'] = function()
        -- string
        local stringLength = haxe.readDigits()
        assert(haxe.actualData:sub(haxe.dataPosition, haxe.dataPosition) == ':' or haxe.fullDataLength - haxe.dataPosition < stringLength, 'Invalid string length.')

        local stringValue = urlDecode(haxe.actualData:sub(haxe.dataPosition + 1, haxe.dataPosition + stringLength))
        haxe.stringCache.unserialization[#haxe.stringCache.unserialization+1] = stringValue

        haxe.dataPosition = haxe.dataPosition + stringLength + 1
        return stringValue
    end,
    ['k'] = function()
        -- NaN
        haxe.dataPosition = haxe.dataPosition + 1
        return 0 / 0
    end,
    ['m'] = function()
        -- -infinity
        haxe.dataPosition = haxe.dataPosition + 1
        return -math.huge
    end,
    ['o'] = function()
        -- object
        local key = #haxe.cache + 1
        haxe.cache[key] = {}
        return handleTableUnserialization(key, 'object')
    end,
    ['g'] = function()
        -- object end
        return '__objectEnd'
    end,
    ['R'] = function()
        -- string cache reference
        local stringCacheNumber = haxe.readDigits()
        assert(stringCacheNumber > 0 or stringCacheNumber < #haxe.stringCache.unserialization, 'Invalid reference.')

        return haxe.stringCache.unserialization[stringCacheNumber]
    end,
    ['x'] = function()
        -- exception
        haxe.dataPosition = haxe.dataPosition + 1
        return assert(false)
    end,
    ['p'] = function()
        -- infinity
        haxe.dataPosition = haxe.dataPosition + 1
        return math.huge
    end
}

--- @param dataTable table
--- @param dataType string
local handleTableSerialization = function(dataTable, dataType)
    assert(type(dataTable) == 'table', 'Inserialized data is' .. type(dataTable) .. 'for dataType' .. dataType .. '. Must be table.')

    local data = nil
    local getListOfTableKeys = function(table)
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
        local nilAmountHandler = function()
            if nilAmount < 1 then
                return
            end

            if nilAmount == 1 then
                haxe.addData('n')
            else
                haxe.addData('u')
                haxe.addData(nilAmount)
            end
            nilAmount = 0
        end

        haxe.addData('a')
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
        haxe.addData('h')
    elseif dataType == 'list' then
        haxe.addData('l')
        for i = 1, #dataTable do
            data = dataTable[i]
            serialize(data, type(data))
        end
        haxe.addData('h')
    elseif dataType == 'object' or dataType == 'stringmap' then
        local listOfKeys = getListOfTableKeys(dataTable)

        haxe.addData((dataType == 'object' and 'o') or 'b')
        for _, key in ipairs(listOfKeys) do
            serialize(key, 'string')

            data = dataTable[key]
            serialize(data, type(data))
        end
        haxe.addData((dataType == 'object' and 'g') or 'h')
    end
end

--- @param cacheKey number
--- @param dataType string
handleTableUnserialization = function(cacheKey, dataType)
    local getCacheFinal = function()
        haxe.actualData = haxe.actualData:sub(2, #haxe.actualData)

        local cacheF = haxe.cache[cacheKey]
        haxe.cache[cacheKey] = nil
        return cacheF
    end

    if dataType == 'object' then
        local key = nil
        local objectLength = #haxe.actualData
        local value = nil

        while true do
            assert(haxe.dataPosition <= objectLength, 'Invalid object.')
            if haxe.actualData:sub(haxe.dataPosition, haxe.dataPosition) == 'g' then
                return getCacheFinal()
            else
                key = unserialize(haxe.actualData)
                if key == '__objectEnd' then
                    return getCacheFinal()
                end
                assert(type(key) == 'string', 'Invalid object key because it is type ' .. type(key) .. '.')

                value = unserialize(haxe.actualData)
                haxe.cache[cacheKey][key] = value
            end
        end
    end
end

--- @param data any
--- @param dataType string
serialize = function(data, dataType)
    if type(data) == 'table' and data['__tableDef'] ~= nil then
        dataType = data['__tableDef']
    end

    if dataType == 'boolean' then
        -- true or false
        haxe.addData(((data) and 't') or 'f')
    elseif dataType == 'list' then
        -- list
        handleTableSerialization(data, 'list')
    elseif dataType == nil or dataType == 'nil' then
        -- nil
        haxe.addData('n')
    elseif dataType == 'number' or dataType == 'float' or dataType == 'integer' then
        local numberData= tonumber(data)
        local i, f = math.modf(numberData)
        if f == 0 then
            if numberData == 0 then
                -- zero
                haxe.addData('z')
            else
                -- integer
                haxe.addData('i' .. numberData)
            end
        else
            if numberData ~= numberData then
                -- nan value
                haxe.addData('k')
            elseif math.abs(numberData) == math.huge then
                -- -infinity or infinity
                haxe.addData(((numberData < 0) and 'm') or 'p')
            else
                -- float
                haxe.addData('d' .. numberData)
            end
        end
    elseif dataType == 'object' then
        -- object
        handleTableSerialization(data, 'object')
    elseif dataType == 'string' then
        data = tostring(data)
        if haxe.stringCache.serialization[data] ~= nil then
            -- string cache reference
            haxe.addData('R' .. haxe.stringCache.serialization[data])
        else
            -- string
            data = urlEncode(data)
            haxe.addData('y' .. #data .. ':' .. data)
        end
    elseif dataType == 'stringmap' then
        -- stringmap
        handleTableSerialization(data, 'stringmap')
    elseif dataType == 'table' or dataType == 'array' then
        -- array
        handleTableSerialization(data, 'array')
    else
        assert(false, 'Cannot serialize ' .. dataType .. '.')
    end
end

unserialize = function()
    haxe.dataPosition = haxe.dataPosition + 1

    if haxe.actualData == nil or #haxe.actualData < 1 then
        return nil
    end
    local dataStartsWith = haxe.actualData:sub(haxe.dataPosition, haxe.dataPosition)
    local unserializedData = nil

    if haxe.dataHandler[dataStartsWith] then
		unserializedData = haxe.dataHandler[dataStartsWith]()
    end

    haxe.actualData = haxe.actualData:sub(haxe.dataPosition, #haxe.actualData)
    haxe.dataPosition = 0
    if haxe.useInternalData then
        datautil.haxe.serializedData = haxe.actualData
    end

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
--- @param forcedDataType? string|nil
local serializeData = function(unserializedData, forcedDataType)
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
--- If `serializedData` is left as nil or blank, then it'll use `haxe.serializedData`.
---
--- Refer to https://haxe.org/manual/std-serialization.html for more information on serialization.
--- @param serializedData? string|nil
--- @return any
local unserializeData = function(serializedData)
    haxe.useInternalData = serializedData == nil or serializedData == ''
    if haxe.useInternalData then
        serializedData = datautil.haxe.serializedData
    end
    assert(serializedData == nil or type(serializedData) == 'string', 'Expected nil or string, got ' .. type(serializedData) .. '.')

    haxe.actualData = serializedData
    haxe.fullDataLength = #serializedData

    haxe.dataPosition = 0
    return unserialize()
end

--- Returns a table of the whole unserialized data created in the Haxe format
--- @param serializedData? string|nil
--- @return table
local unserializeDataWhole = function(serializedData)
    haxe.useInternalData = serializedData == nil or serializedData == ''
    if haxe.useInternalData then
        serializedData = datautil.haxe.serializedData
    end
    assert(serializedData == nil or type(serializedData) == 'string', 'Expected nil or string, got ' .. type(serializedData) .. '.')

    haxe.actualData = serializedData
    haxe.fullDataLength = #serializedData

    haxe.dataPosition = 0

    local wholeData = {}
    while haxe.actualData ~= nil or #haxe.actualData > 0 do
        wholeData[#wholeData+1] = unserialize()
    end
    return wholeData
end

--#endregion

--- Rounds a number to the nearest whole number
--- @param numberToRound number
--- @return number
local round = function(numberToRound)
    local _, f = math.modf(numberToRound)
    return ((f < 0.5) and math.floor(numberToRound)) or math.ceil(numberToRound)
end

datautil = {
    _VERSION = '3.0.0',

    round = round,

    --- color class
    color = {
        getClientRGBFromStrum = getClientRGBFromStrum,
        getPixelColor = api_getPixelColor
    },

    -- haxe class
    haxe = {
        --- Serialized data that is created from the serializeData function.
        serializedData = '',

        serializeData = serializeData,
        unserializeData = unserializeData,
        unserializeDataWhole = unserializeDataWhole
    }
}

return datautil