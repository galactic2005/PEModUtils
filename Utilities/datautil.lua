local function decimalToHex(decimal, stringStart)
    local stringHex = tostring(("%X"):format(tostring(decimal)))
    return '0x' .. stringHex:sub(#stringHex - stringStart, #stringHex)
end

-- NON-MODULE CODE ABOVE --

local datautil = {}

datautil._VERSION = '1.0.1'

--[[
    MIT License

    Copyright (c) 2023-2024 galatic_2005

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
]]

--- A version of `getPixelColor` that automatically converts variables using the other functions listed
---
--- Refer to the documenation for `getPixelColor` for more information on this function
function datautil.getPixelColor(obj, x, y)
    return decimalToHex(getPixelColor(obj, x, y), 7)
end

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

    local arrowRGB = (usePixelRGB and 'data.arrowRGBPixel') or 'data.arrowRGB'
    local tableOfRGBUnconverted = getPropertyFromClass('backend.ClientPrefs', arrowRGB .. '[' .. strumNoteID .. ']')

    local r = decimalToHex(tableOfRGBUnconverted[1], 5)
    local g = decimalToHex(tableOfRGBUnconverted[2], 5)
    local b = decimalToHex(tableOfRGBUnconverted[3], 5)
    return {r, g, b}
end

--- Rounds a number to the nearest whole number
--- @param numberToRound number
--- @return number
function datautil.round(numberToRound)
    local i, f = math.modf(numberToRound)
    return ((f < 0.5) and math.floor(numberToRound)) or math.ceil(numberToRound)
end

return datautil