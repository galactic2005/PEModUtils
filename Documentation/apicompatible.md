# apicompatible

## Usage

*apicompatible* is a module used to make compatibility easier between different versions of Pysch Engine.

This module is used for both compatibility with older versions of Psych Engine, alongside newer versions when they come out and this module is updated accordingly.

> Note that this module does not promise nor provides 100% compatibility, especially with complex scripts or of scripts that rely on newer content not present in older versions (object functions, RGB note colors, etc..)

## Variables

```lua
--- Whether `returnCompatibleClassName` and `returnCompatibleVariableName` output a debug message if no class name was found
returnClassNameDebugMessage = false
```

## Functions

### enableHueBrtSatNoteColorSystem()

Enables the HUE/Brt/Sat system that was used before 0.7.0.

Note that this function enables the system for all notes and strums.

### returnCompatibleClassName(className: string)

Returns the class name that is compatible with reflection functions in the version being played.

Example:

```lua
local playStateName = apicompatible.returnCompatableClassName('PlayState') -- get compatible version of 'PlayState'
debugPrint(playStateName)

--[[
    returns 'PlayState' if 0.6.3 or lower
    returns 'states.PlayState' if 0.7.0 or higher
]]
```

Set `returnClassNameDebugMessage` to `true` if you wish to recieve debug messages when no class name is found.

### returnCompatibleVariableName(variableName: string, className?: string = 'PlayState')

Returns the variable name that is compatible with reflection functions in the version being played.

Set `returnClassNameDebugMessage` to `true` if you wish to recieve debug messages when no class name or variable name is found.

### returnClientPrefName(clientPrefName: string)

Returns the client preference name that is compatible with reflection functions in the version being played

In version 0.7.0 and above, you are required to prefix the client preference name with `.data` or else it wouldn't work.

### getPropertyFromClass(classVar: string, variable: string, ?allowMaps: boolean = false)

A version of `getPropertyFromClass` that automatically converts variables using the other functions listed.

Refer to the documenation for `getPropertyFromClass` for more information on this function.

### setPropertyFromClass(classVar: string, variable: string, value: any, ?allowMaps: boolean = false)

A version of `setPropertyFromClass` that automatically converts variables using the other functions listed.

Refer to the documenation for `setPropertyFromClass` for more information on this function.
