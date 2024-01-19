local extramath = {
    _AUTHORS = 'galactic_2005',
    _VERSION = '1.1.0'
}

--- Returns a number that's clamped between two numbers
--- @param numberToClamp number
--- @param minimumClamp number
--- @param maximumClamp number
--- @return number
--- @nodiscard
function extramath.clamp(numberToClamp, minimumClamp, maximumClamp)
    if numberToClamp < minimumClamp then
        return minimumClamp
    elseif numberToClamp > maximumClamp then
        return maximumClamp
    end
    return numberToClamp
end

--- Returns the interpolated number between two numbers
--- @param startingValue number
--- @param endingValue number
--- @param interpolationValue number
--- @return number
--- @nodiscard
function extramath.lerp(startingValue, endingValue, interpolationValue)
    return startingValue + (endingValue - startingValue) * interpolationValue
end

--- Returns the negative absolute of a number
--- @param number number
--- @return number
--- @nodiscard
function extramath.negativeAbs(number)
    return -math.abs(number)
end

--- Returns a number that's rounded nearest whole number
--- @param numberToRound number
--- @return number
--- @nodiscard
function extramath.round(numberToRound)
    local _, f = math.modf(numberToRound)
    return ((f < 0.5) and math.floor(numberToRound)) or math.ceil(numberToRound)
end

--- Returns an integer that indicates the sign of a number
--- @param number number
--- @return integer
--- @nodiscard
function extramath.sign(number)
    if number < 0 then
        return -1
    elseif number > 0 then
        return 1
    end
    return 0
end

return extramath