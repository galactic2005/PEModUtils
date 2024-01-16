local extramath = {
    _VERSION = '1.0.0'
}

--- Clamps a number between two numbers
--- @param numberToClamp number
--- @param minimumClamp number
--- @param maximumClamp number
--- @return number
function extramath.clamp(numberToClamp, minimumClamp, maximumClamp)
    if numberToClamp < minimumClamp then
        return minimumClamp
    elseif numberToClamp > maximumClamp then
        return maximumClamp
    end
    return numberToClamp
end

--- Rounds a number to the nearest whole number
--- @param numberToRound number
--- @return number
function extramath.round(numberToRound)
    local _, f = math.modf(numberToRound)
    return ((f < 0.5) and math.floor(numberToRound)) or math.ceil(numberToRound)
end

return extramath