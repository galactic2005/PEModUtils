# fileutil

## Usage

fileutil is a module used to create list files or to read one line from a file.

## Variables

```lua
_VERSION = '3.0.0'

---The most recent file used regardless of context
mostRecentFileUsed = ''

---The most recent file read from
mostRecentFileReadFrom = ''

---The most recent file written to
mostRecentFileWrittenTo = ''
```

## Functions

### readListFile(path:String, startFromCurrentModDirectory:Boolean)

Returns the contents of a list file as a table.

Refer to `characterList.txt`, `stageList.txt`, or `weekList.txt` for the formatting of list files.

### writeListFile(path:String, tableToInsert:Table, startFromCurrentModDirectory:Boolean)

Writes a list file using a table.

Any table elements in `tableToInsert` that are not of a `number` or `string` will be skipped from being written.

If the file at `path` is an existing file, it'll be overwritten.

### returnLineFromFile(path:String, startFromCurrentModDirectory:Boolean, ?linePosition:Integer)

Returns one line of content from a file as a string; or `nil` if no file is found or if the file doesn't contain content.

If `linePosition` isn't specified, then this function will return a random line of content.