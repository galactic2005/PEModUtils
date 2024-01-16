# listfile

## Usage

*listfile* is a module used to write or read from list files.

Refer to `characterList.txt`, `stageList.txt`, or `weekList.txt` for the formatting of list files.

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

### read(filePath:String, startFromCurrentModDirectory:Boolean)

Returns the contents of a list file as a table.

If `startFromCurrentModDirectory` is not defined, it'll be `true`.

### readLine(filePath: string, startFromCurrentModDirectory?: boolean = true, linePosition?: integer)

Returns one line of content from a file as a string; or `nil` if no file is found or if the file doesn't contain content.

If `linePosition` isn't defined or is nil, then this function will return a random line of content.

### readTable(tableOfListFiles: table, indexPosition?: integer)

Reads all list files in the table given; if `indexPosition` is defined, then it'll read the list file at that index.

Tables should be setup like the following:

```lua
{
    -- [1] filePath
    -- [2] startFromCurrentModDirectory
    {'', false},
    {'data/credits.txt', true}
}
```

### write(filePath: string, tableToInsert: table, startFromCurrentModDirectory?: boolean = true)

Writes a list file using a table.

Any table elements in `tableToInsert` that are not of a `number` or `string` will be skipped from being written.

If the file at `filePath` is an existing file, it'll be overwritten.
