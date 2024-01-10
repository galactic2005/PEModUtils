-- https://gist.github.com/liukun/f9ce7d6d14fa45fe9b924a3eed5c3d99
local charToHex = function(c)
    return string.format("%%%02X", string.byte(c))
end

local urlEncode = function(url)
    if url == nil then
        return ''
    end
    url = url:gsub("\n", "\r\n")
    url = url:gsub("([^%w ])", char_to_hex)
    url = url:gsub(" ", "+")
    return url
end

local hexToChar = function(x)
    return string.char(tonumber(x, 16))
end

local urlDecode = function(url)
    if url == nil then
        return ''
    end
    url = url:gsub("+", " ")
    url = url:gsub("%%(%x%x)", hex_to_char)
    return url
end

local datautil = {
    -- classes
    haxe = {

    }
}

--- @param serializedData string
function datautil.haxe.unserializeData(serializedData)

end

datautil.haxe.serializedData = ''

--- @param unserializedData any
--- @param forcedDataType string
function datautil.haxe.serializeData(unserializedData, forcedDataType)
    ---@param s string
    local addData = function(s)
        local data = datautil.haxe.serializedData
        data = data .. s
    end

    ---@param t table
    local serializeTable = function(t)

    end

    local dataType = ''
    if forcedDataType ~= '' and forcedDataType ~= nil then
        dataType = forcedDataType
    else
        dataType = type(unserializedData)
    end

    if dataType == 'boolean' then
        addData(((unserializedData) and 't') or 'f')
    elseif dataType == 'nil' then
        addData('n')
    elseif dataType == 'number' then
        local s = tostring(unserializedData)
        local v = tonumber(unserializedData)
        if  math.type(v) == 'float' then
            -- float
            if v ~= v then
                -- nan value
                addData('k')
            elseif math.abs(v) == math.huge then
                addData(((v < 0) and 'm') or 'p')
            else
                addData('d' .. v)
            end
        else
            -- integer
            if v == 0 then
                addData('z')
                return
            end
            addData('i' .. v)
        end
    elseif dataType == 'string' then
        unserializedData = urlEncode(unserializedData)
        addData('y' .. #unserializedData .. ':' .. unserializedData)
    elseif dataType == 'table' then

    else
        assert(false, 'Cannot serialize ' .. dataType .. '.')
    end
end

return datautil