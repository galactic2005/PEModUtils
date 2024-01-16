# mod

## Usage

*mod* is a module used to manipulate mods or read data from other mods.

## Dependencies

* [dkjson](http://dkolf.de/src/dkjson-lua.fsl/home)

Remember to set `mod.dkJsonFilePath` to the appropiate file path (without the extension or spaces).

## Variables

```lua
--- The file where dkjson is located
dkJsonFilePath = 'mods/dkjson'
```

## Functions

### loadSongFromAnotherMod(weekJsonPath: string, songTitle: string, difficultyName: string)

Loads a song from a different mod folder.

`weekJsonPath` starts from `mods/`; to get the current mod directory use the following:

```lua
currentModDirectory .. 'weeks/weekFile'
```
