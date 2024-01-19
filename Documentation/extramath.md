# extramath

## Usage

*extramath* is a module used to do math functions that are not included with the math library.

## Functions

### clamp(numberToClamp: number, minimumClamp: number, maximumClamp: number)

Returns a number that's clamped between two numbers.

Example:

```lua
local number = 10

debugPrint(extramath.clamp(number, 0, 30))
-- 10

debugPrint(extramath.clamp(number, 20, 30))
-- 20

debugPrint(extramath.clamp(number, 0, 5))
-- 5
```

### lerp(startingValue: number, endingValue: number, interpolationValue: number)

Returns the interpolated number between two numbers.

### negativeAbs(number: number)

Returns the negative absolute of a number.

Example:

```lua
debugPrint(extramath.negativeAbs(10))
-- -10

debugPrint(extramath.negativeAbs(-10))
-- -10
```

### round(numberToRound: number)

Returns a number that's rounded nearest whole number.

### sign(number: number)

Returns an integer that indicates the sign of a number.

Example:

```lua
debugPrint(extramath.sign(5))
-- 1

debugPrint(extramath.sign(0))
-- 0

debugPrint(extramath.sign(-5))
-- -1
```
