# modutil

## Usage

modutil is a module used for manipulating mods or reading data from other mods.

## Dependencies

* [dkjson](http://dkolf.de/src/dkjson-lua.fsl/home)

Remember to set `modutil.dkJsonFilePath` to the appropiate file path (without the extension or spaces).

## Variables

```lua
_VERSION = '2.0.0'

--- The file where dkjson is located
dkJsonFilePath = 'mods/scripts/dkjson'
```

## Functions

### loadSongFromAnotherMod(weekJsonPath:String, songTitle:String, difficultyName:String)

Loads a song from a different mod folder.

`weekJsonPath` starts from `mods/`; to get the current mod directory use the following:

```lua
currentModDirectory .. 'weeks/weekFile'
```
