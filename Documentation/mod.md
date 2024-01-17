# mod

## Usage

*mod* is a module used to manipulate mods or read data from other mods.

## Dependencies

* [dkjson](http://dkolf.de/src/dkjson-lua.fsl/home) - `dkJsonFilePath`

## Variables

* `dkJsonFilePath = 'mods/dkjson'` - the file where dkjson is located.

## Functions

### loadSongFromAnotherMod(weekJsonPath: string, songTitle: string, difficultyName: string)

Loads a song from a different mod folder.

`weekJsonPath` starts from `mods/`; to get the current mod directory use the following:

```lua
currentModDirectory .. 'weeks/weekFile'
```
