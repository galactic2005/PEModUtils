# songutil

## Usage

songutil is a module used for loading or manipulating songs.

## Dependencies

* [dkjson](http://dkolf.de/src/dkjson-lua.fsl/home)

Remember to set `songUtil.dkJsonFilePath` to the appropiate file path (without the extension or spaces).

## Variables

```lua
_VERSION = '1.0.0'

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
