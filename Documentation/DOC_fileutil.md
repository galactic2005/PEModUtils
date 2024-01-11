# fileutil

## Usage

*fileutil* is a module used to write or read from files in specific ways.

## Variables

```lua
--- The most recent file used regardless of context
mostRecentFileUsed = ''

--- The most recent file read from
mostRecentFileReadFrom = ''

--- The most recent file written to
mostRecentFileWrittenTo = ''
```

## Functions

### getModsList(type?: string = 'all')

Gets the current mods list from `modsList.txt`.

`type` should be one of the following:

* `'all'` - Gets all mods regardless of activeness.
* `'active'` - Gets all mods that are active.
* `'inactive'` - Gets all mods that are inactive.

### isFolder(fileString: string, startFromCurrentModDirectory?: boolean = true)

Checks if `fileString` is a folder or not by searching for a period.

### listFile Class

Refer to `characterList.txt`, `stageList.txt`, or `weekList.txt` for the formatting of list files.

#### listFile.read(path:String, startFromCurrentModDirectory:Boolean)

Returns the contents of a list file as a table.

If `startFromCurrentModDirectory` is not defined, it'll be `true`.

#### listFile.readLine(path: string, linePosition?: integer, startFromCurrentModDirectory?: boolean = true)

Returns one line of content from a file as a string; or `nil` if no file is found or if the file doesn't contain content.

If `linePosition` isn't defined or is nil, then this function will return a random line of content.

#### listFile.write(path: string, tableToInsert: table, startFromCurrentModDirectory?: boolean = true)

Writes a list file using a table.

Any table elements in `tableToInsert` that are not of a `number` or `string` will be skipped from being written.

If the file at `path` is an existing file, it'll be overwritten.
