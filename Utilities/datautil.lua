local datautil = {}

datautil._VERSION = '1.0.0'

--- Returns a client's RGB preference from a specified strum line as a string hex value
---
--- `strumNoteID` should be any integer between 0-3.
---
--- Any version of Psych Engine below 0.7.0 will return a table consisting of nil instead.
--- @param strumNoteID integer
--- @param usePixelRGB boolean
--- @return table
function datautil.getClientRGBFromStrum(strumNoteID, usePixelRGB)
    if version < '0.7.0' then
        return {nil, nil, nil}
    end
    assert(strumNoteID > -1, 'strumNoteID is at a value of ' .. strumNoteID .. ', which is below 0.')
    assert(strumNoteID < 4, 'strumNoteID is at a value of ' .. strumNoteID .. ', which is above 3.')

    local function decimalToHex(decimal)
        local stringHex = tostring(("%X"):format(tostring(decimal)))
        return '0x' .. stringHex:sub(#stringHex - 5, #stringHex)
    end

    local arrowRGB = (usePixelRGB and 'data.arrowRGBPixel') or 'data.arrowRGB'
    local tableOfRGBUnconverted = getPropertyFromClass('backend.ClientPrefs', arrowRGB .. '[' .. strumNoteID .. ']')

    -- {r, g, b}
    return {tableOfRGBUnconverted[1], tableOfRGBUnconverted[2], tableOfRGBUnconverted[3]}
end

--- Rounds a number to the nearest whole number
--- @param numberToRound number
--- @return number
function datautil.round(numberToRound)
    local i, f = math.modf(numberToRound)
    return ((f < 0.5) and math.floor(numberToRound)) or math.ceil(numberToRound)
end

return datautil