local color = {
    _AUTHORS = 'galactic_2005',
    _VERSION  = '1.0.0'
}

--- @param decimal number
--- @param stringStart number
--- @nodiscard
local function decimalToHex(decimal, stringStart)
    local stringHex = tostring(("%X"):format(tostring(decimal)))
    return stringHex:sub(#stringHex - stringStart, #stringHex)
end

--- Returns a client's RGB preference from a specified strum line as a string hex value
---
--- `strumNoteID` should be any integer between 0-3.
---
--- Any version of Psych Engine below 0.7.0 will return a table consisting of nil instead.
--- @param strumNoteID integer
--- @param usePixelRGB? boolean
--- @return table
--- @nodiscard
function color.getClientRGBFromStrum(strumNoteID, usePixelRGB)
    if version < '0.7.0' then
        return { nil, nil, nil }
    end
    assert(strumNoteID > -1, 'strumNoteID is at a value of ' .. strumNoteID .. ', which is below 0.')
    assert(strumNoteID < 4, 'strumNoteID is at a value of ' .. strumNoteID .. ', which is above 3.')

    local arrowRGB = (usePixelRGB and 'data.arrowRGBPixel') or 'data.arrowRGB'
    local tableOfRGBUnconverted = getPropertyFromClass('backend.ClientPrefs', arrowRGB .. '[' .. strumNoteID .. ']')

    -- { r, g, b }
    return {
        decimalToHex(tableOfRGBUnconverted[1], 5),
        decimalToHex(tableOfRGBUnconverted[2], 5),
        decimalToHex(tableOfRGBUnconverted[3], 5)
    }
end

--- A version of `getPixelColor` that automatically converts variables using the other functions listed
---
--- Refer to documenation of  `getPixelColor` for more information on this function
--- @param obj string
--- @param x number
--- @param y number
--- @return string
--- @nodiscard
function color.getPixelColor(obj, x, y)
    return decimalToHex(getPixelColor(obj, tonumber(x), tonumber(y)), 7)
end

return color