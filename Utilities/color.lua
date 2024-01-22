local color = {
    _AUTHORS = 'galactic_2005',
    _VERSION  = '1.0.0'
}

--- @param decimal number
--- @param stringStart number
--- @return string
--- @nodiscard
local function decimalToHex(decimal, stringStart)
    local stringHex = tostring(("%X"):format(tostring(decimal)))
    return stringHex:sub(#stringHex - stringStart, #stringHex)
end

--- Returns a client's RGB preference from a specified strum line as a string hex value
---
--- Any version of Psych Engine below 0.7.0 will return a table consisting of nil instead.
---
--- `strumNoteID` should be any integer between 0 to 3 in 4 key/mania. See documentation for details on multikey support.
--- @param strumNoteID integer
--- @param usePixelRGB? boolean
--- @return table
--- @nodiscard
function color.getClientRGBFromStrum(strumNoteID, usePixelRGB)
    if version < '0.7.0' then
        return { nil, nil, nil }
    end

    -- multikey support
    local strumLength = nil
    if getProperty('strumLineNotes.length') ~= nil then
        strumLength = (getProperty('strumLineNotes.length') - 1) * 0.5
    else
        strumLength = 3
    end

    assert(strumNoteID > -1, 'strumNoteID is at a value of ' .. strumNoteID .. ', which is below 0.')
    assert(strumNoteID < strumLength, 'strumNoteID is at a value of ' .. strumNoteID .. ', which is above' .. tostring(strumLength - 1) .. '.')

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