# Lua Style Guide

This style guide contains a list of guidelines to follow for PEModUtils to provide consistency across every LUA file or code block snippet in Markdown.

This style guide was based upon [Olivine's Labs LUA Style Guide](https://github.com/Olivine-Labs/lua-style-guide).

## Table of Contents

* [Comments](Comments)

## Comments

* Leave one space of room between the -- and comment.

```lua
-- example comment
```

* Multi-line comments should have their brackets on separate lines from the actual comment.

```lua
--[[
    example comment
]]
```

## Functions

* When defining functions, avoid variable syntax.

```lua
-- bad
local foo = function()

end

-- good
local function foo()

end
```

## Strings

* Use single quotes for strings.

```lua
local stringValue = ''
```

## Tables

* Tables spread over multiple lines should have ending commas on all items except the last.

```lua
local t = {
    1,
    2,
    3
}
```

* Access module properties using dot notation.

```lua
local color = {
    _VERSION = '1.0.0'
}

debugPrint(color._VERSION)
-- '1.0.0'
```

* Access other tables using subscript notation.

```lua
local t = { 1, 2, 3, 'a' = 'testString' }

debugPrint(t[1])
-- 1

debugPrint(t['a'])]
-- 'testString'
```

## Variables

* Always use `local` to declare variables unless you're using built-in engine functions.

```lua
local variableName = true

local function foo()

end

function onCreate()
    -- built-in Psych Engine function; don't use local
end
```

## Conditions

* Prefer *true* statements over *false* statements.

```lua
-- bad
if not hasFile then
    -- false
else
    -- true
end

-- good
if hasFile then
    -- true
else
    -- false
end
```

## Dependencies

* In the case of a module, it should contain a variable of `moduleExampleFilePath` (using camelCase) and have it be set by default to `'mods/moduleexample'`

```lua
local weekdata = {
    --- The file where dkjson is located
    dkJsonFilePath = 'mods/dkjson'
}
```

## Error Handling

* Perform error handling as soon as possible.

```lua
local function canCreateTextFileHere(filePath)
    assert(type(filePath) == 'string', 'Expected string for filePath, got ' .. type(filePath) .. '.') -- use only strings for filePath

    if not stringEndsWith(filePath, '.txt') then
        -- user forgot to put .txt in the filename
        filePath = filePath .. '.txt'
    end

    -- now this is where the actual function code is
    return checkFileExists(filePath, true)
end
```

* Leave a comment on the end of an assert explaining how to fix. You can also reword the second parameter and use that, but it's not recommended.

```lua
assert(false, 'File is empty.') -- file should contain some content
```

## Naming Convention

* Don't use single-letter function or variable names. Be descriptive enough.

```lua
-- bad
local h = 'Top Hat'

-- bad
local theThatHatImCurrentlyWearingOnTopOfMyHead = 'Top Hat'

-- good
local hatBeingWorn = 'Top Hat'
```

* Use underscores for ignored variables in loops or built-in engine functions.

```lua
local tableOfValues = { 'one', 'two', 'three' }
local tableOfNewValues = { }

for _, value in ipairs(tableOfValues) do
    tableOfNewValues[#tableOfNewValues+1] = value
end

function onEvent(eventName, value1, _, _)
    if eventName == 'Set Boyfriend X Scale' then
        setProperty('boyfriend.scale.x', tonumber(value1))
    end
end
```

* Use camelCase for all naming conventions except module names. If the word is one word long it should be in lowercase.

```lua
local function exampleFunction()

end

local exampleVariable = nil

-- one word long
local name = 'Boyfriend'
```

* Use flatcase (all lowercase) when naming modules.

```lua
local foomodulename = {}
```

## Module Classes

* Modules should not have classes. If your module needs classes, chances are it can be separated into separate modules.

```lua
-- bad
local data = {
    color = { },
    math = { }
}

-- good
local color = { }
local data = { }
local math = { }
```

## Semicolons

* Never use semicolons. Separate statements into separate lines.

```lua
-- bad
local a = 1; local b = 2; local c = 3;

-- good
local a = 1
local b = 2
local c = 3
```

## Version Differences

* Use the `version` variable to avoid version conflicts.

```lua
local playStateClass = 'states.PlayState'
if version < '0.7.0' then
    playStateClass = 'PlayState'
end

setPropertyFromClass(playStateClass, 'isPixelStage', false)
```

* In cases where it's unavoidable to resolve version conflicts, stop the function or return `nil`.

## Whitespace

* Use 4-space soft-tabs for indentenion.

* Use one space before opening and closing braces in tables and after commas.

```lua
local a = { }
local b = { 1, 2, 3 }

function foo(elementOne, elementTwo)

end

foo(a, b)
```

* Surround operators with one space.

```lua
local a = 1
local b = 2 + a
local c = 3 * b

local stringValue = 'I am ' .. ' stringValue!'
```

* Remove unnecessary whitespace at the end of lines.
