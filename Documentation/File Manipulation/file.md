# file

## Usage

*file* is a module used to write or read from files.

## Variables

* `mostRecentFileUsed = ''` - the most recent file used regardless of context.

* `mostRecentFileReadFrom = ''` - the most recent file read from.

* `mostRecentFileWrittenTo = ''` - the most recent file written to.

## Functions

### getModsList(type?: boolean|string = 'all')

Gets the current mods list from `modsList.txt` as a table.

`type` should be one of the following:

* `'all'` - Gets all mods regardless of activeness; default parameter.
* `'active'` / `true` - Gets all mods that are active.
* `'inactive'` / `false` - Gets all mods that are inactive.

Example:

```lua
-- assume modsList.txt is like the following:
--[[
    Mod One|1
    Mod Two|1
    Mod Three|0
    Mod Four|0
]]

debugPrint(getModsList('all'))
-- { 'Mod One', 'Mod Two', 'Mod Three', 'Mod Four' }

debugPrint(getModsList('active'))
debugPrint(getModsList(true))
-- { 'Mod One', 'Mod Two' }

debugPrint(getModsList('inactive'))
debugPrint(getModsList(false))
-- { 'Mod Three', 'Mod Four' }

```

### isFolder(fileString: string, startFromCurrentModDirectory?: boolean = true)

Checks if `fileString` is a folder or not by searching for a period.
