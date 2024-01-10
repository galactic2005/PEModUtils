-- https://gist.github.com/liukun/f9ce7d6d14fa45fe9b924a3eed5c3d99
local charToHex = function(c)
    return string.format("%%%02X", string.byte(c))
end

local function urlEncode(url)
    if url == nil then
        return
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

local datautil = {}

---@param serializedData string
function datautil.unserializeDataHaxe(serializedData)

end

datautil.serializedData = ''

---@param unserializedData any
function datautil.serializeDataHaxe(unserializedData)
    ---@param s string
    local addData = function(s)
        local data = datautil.serializedData
        data = data .. s
    end

    local dataType = type(unserializedData)
    if dataType == 'boolean' then
        addData(((unserializedData) and 't') or 'f')
    elseif dataType == 'nil' then
        addData('n')
    elseif dataType == 'number' then
        
    elseif dataType == 'string' then
        unserializedData = urlEncode(unserializedData)
        addData('y' .. #unserializedData .. ':' .. unserializedData)
    end
end

return datautil