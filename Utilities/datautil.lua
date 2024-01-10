local function decimalToHex(decimal, stringStart)
    local stringHex = tostring(("%X"):format(tostring(decimal)))
    return stringHex:sub(#stringHex - stringStart, #stringHex)
end

-- NON-MODULE CODE ABOVE --

local datautil = {
    _VERSION = '2.0.0',

    --- Rounds a number to the nearest whole number
    --- @param numberToRound number
    --- @return number
    round = function(numberToRound)
        local i, f = math.modf(numberToRound)
        return ((f < 0.5) and math.floor(numberToRound)) or math.ceil(numberToRound)
    end,

    --- class for color data
    color = {
        --- Returns a client's RGB preference from a specified strum line as a string hex value
        ---
        --- `strumNoteID` should be any integer between 0-3.
        ---
        --- Any version of Psych Engine below 0.7.0 will return a table consisting of nil instead.
        --- @param strumNoteID integer
        --- @param usePixelRGB boolean
        --- @return table
        getClientRGBFromStrum = function (strumNoteID, usePixelRGB)
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
        end,

        --- A version of `getPixelColor` that automatically converts variables using the other functions listed
        ---
        --- Refer to documenation of  `getPixelColor` for more information on this function
        --- @param obj string
        --- @param x number
        --- @param y number
        getPixelColor = function(obj, x, y)
            return decimalToHex(getPixelColor(obj, tonumber(x), tonumber(y)), 7)
        end,
    }
}

return datautil