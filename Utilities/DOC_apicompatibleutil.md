# apicompatibleutil

## Usage

apicompatibleutil is a module used to make compatability easier between different versions of PE.

Note that this module does not provide nor promise 100% compatability, especially with complex scripts or of scripts that rely on newer content not present in older versions.

## Variables

```lua
_VERSION = '1.0.0'

--- Whether `returnCompatibleClassName` and `returnCompatibleVariableName` output a debug message if no class name was found
returnClassNameDebugMessage = false
```

## Functions

### enableHueBrtSatNoteColorSystem()

Enables the HUE/Brt/Sat system that was used before 0.7.0.

Note that this function enables the system for all notes and strums.

## returnCompatibleClassName(className:String)

Returns the class name that is compatible with reflection functions in the version being played.

Example:

```lua
function onCreate()
    local playStateName = apicompatibleutil.returnCompatableClassName('PlayState') -- get compatible version of 'PlayState'
    debugPrint(playStateName)

    --[[ 
        returns 'PlayState' if 0.6.3 or lower
        returns 'states.PlayState' if 0.7.0 or higher
    ]]
end
```

Set `returnClassNameDebugMessage` to `true` if you wish to recieve debug messages when no class name is found.

## returnCompatibleVariableName(className:String, variableName:String)

Returns the variable name that is compatible with reflection functions in the version being played.

Set `returnClassNameDebugMessage` to `true` if you wish to recieve debug messages when no class name or variable name is found.

## returnClientPrefName(clientPrefName:String)

Returns the client preference name that is compatible with reflection functions in the version being played

In version 0.7.0 and above, you are required to prefix the client preference name with `.data` or else it wouldn't work.

## getPropertyFromClass(classVar:String, variable:String, ?allowMaps:Boolean = false)

A version of `getPropertyFromClass` that automatically converts variables using the other functions listed.

Refer to the documenation for `getPropertyFromClass` for more information on this function.

## setPropertyFromClass(classVar:String, variable:String, value:Dynamic, ?allowMaps:Boolean = false)

A version of `setPropertyFromClass` that automatically converts variables using the other functions listed.

Refer to the documenation for `setPropertyFromClass` for more information on this function.