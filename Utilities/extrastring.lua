local extrastring = {
    _AUTHORS = 'galactic_2005',
    _VERSION  = '1.0.0'
}

--- Returns a string with only it's first letter being uppercase
--- @param stringValue string
--- @return string
function extrastring.initalUppercase(stringValue)
    assert(type(stringValue) == 'string', 'Expected string for stringValue, got ' .. type(stringValue) .. '.') -- use only strings for stringValue
	if #stringValue < 2 then
        -- #stringValue == 0 ? '' : stringValue:upper()
        return (#stringValue == 0 and '') or stringValue:upper()
    end
    return stringValue:sub(0, 1):upper() .. stringValue:sub(2, #stringValue):lower()
end

return extrastring