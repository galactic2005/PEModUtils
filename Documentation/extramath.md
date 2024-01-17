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

### round(numberToRound: number)

Returns a number that's rounded nearest whole number.
