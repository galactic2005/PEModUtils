# extramath

## Usage

*extramath* is a module used to do math functions that are not included with the math library.

## Functions

### clamp(number: number, minimumClamp: number, maximumClamp: number)

Returns a number that's clamped between two numbers.

```lua
local number = 10

debugPrint(extramath.clamp(number, 0, 30))
-- 10

debugPrint(extramath.clamp(number, 20, 30))
-- 20

debugPrint(extramath.clamp(number, 0, 5))
-- 5
```

### copySign(number: number, numberToCopy: number)

Returns a number with the sign of `numberToCopy`

```lua
debugPrint(extramath.copySign(5, -1))
-- -5

debugPrint(extramath.copySign(5, 3))
-- 5

debugPrint(extramath.copySign(5, 0))
-- 5
```

### degreeToRadian(degree: number)

Returns the degree converted into radians.

### lerp(startingValue: number, endingValue: number, interpolationValue: number)

Returns the interpolated number between two numbers.

### mean(dataSet: table)

Returns the mean of a dataset of numbers.

### negativeAbs(number: number)

Returns the negative absolute of a number.

```lua
debugPrint(extramath.negativeAbs(10))
-- -10

debugPrint(extramath.negativeAbs(-10))
-- -10
```

### radianToDegree(radian: number)

Returns the radian converted into degrees.

### round(numberToRound: number)

Returns a number that's rounded nearest whole number.

### sign(number: number)

Returns an integer that indicates the sign of a number.

```lua
debugPrint(extramath.sign(5))
-- 1

debugPrint(extramath.sign(0))
-- 0

debugPrint(extramath.sign(-5))
-- -1
```
