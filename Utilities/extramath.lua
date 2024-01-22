local extramath = {
    _AUTHORS = 'galactic_2005',
    _VERSION = '1.2.0'
}

--- Returns a number that's clamped between two numbers
--- @param number number
--- @param minimumClamp number
--- @param maximumClamp number
--- @return number
--- @nodiscard
function extramath.clamp(number, minimumClamp, maximumClamp)
    if number < minimumClamp then
        return minimumClamp
    elseif number > maximumClamp then
        return maximumClamp
    end
    return number
end

--- Returns a number with the sign of `numberToCopy`
--- @param number any
--- @param numberToCopy any
--- @return number
--- @nodiscard
function extramath.copySign(number, numberToCopy)
    if numberToCopy < 0 then
        return -math.abs(number)
    end
    return math.abs(number)
end

--- Returns the degree converted into radians
--- @param degree number
--- @return number
--- @nodiscard
function extramath.degreeToRadian(degree)
    return degree * math.pi / 180
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

--- Returns the mean of a dataset of numbers
--- @param dataSet table
--- @return number
--- @nodiscard
function extramath.mean(dataSet)
    assert(type(dataSet) == 'table','Expected table for dataSet, got ' .. type(dataSet) .. '.') -- use only tables for dataSet
    local dataAmount = 0
    local sum = 0

    for _, value in ipairs(dataSet) do
        value = tonumber(value)
        if type(value) == 'number' then
            dataAmount = dataAmount + 1
            sum = sum + value
        end
    end

    if dataAmount == 0 then
        return 0
    end
    return sum / dataAmount
end

--- Returns the negative absolute of a number
--- @param number number
--- @return number
--- @nodiscard
function extramath.negativeAbs(number)
    return -math.abs(number)
end

--- Returns the radian converted into degrees
--- @param radian number
--- @return number
--- @nodiscard
function extramath.radianToDegree(radian)
    return radian * 180 / math.pi
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