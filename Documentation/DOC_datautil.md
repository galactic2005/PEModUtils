# datautil

## Usage

*datautil* is a module used to convert or handle data.

## Variables

```lua
--- Serialized data that is created from the serializeData function.
haxe.serializedData = '',
```

## Functions

### round(numberToRound:Number)

Rounds a number to the nearest whole number.

### color Class

#### color.getClientRGBFromStrum(strumNoteID: integer, usePixelRGB?: boolean = false)

Returns a client's RGB preference from a specified strum line as a string hex value. Any version of Psych Engine below 0.7.0 will return a table consisting of nil instead.

`strumNoteID` should be any integer between 0-3.

#### color.getPixelColor(obj: string, x: number, y: number)

A version of `getPixelColor` that automatically converts variables using the other functions listed.

Refer to documenation of  `getPixelColor` for more information on this function.

### haxe Class

Refer to <https://haxe.org/manual/std-serialization.html> for more information on serialized data.

#### serializeData(unserializedData: any, forcedDataType?: string|nil)

Sterializes data in the Haxe format.

`forcedDataType` by default determines how to serialize data using the `type(v)` function. Hoewver, by putting a string value here, it'll override the `type(v)` function. Below is a full list of data type overrides currently available:

* `'array'` / `'table'` - A storage for values; default behavior if a `table` is passed in.

* `'boolean'` - A value that can only be true or false; default behavior if a `boolean` is passed in.

* `'list'` - A collection for storing elements; use a table.

* `'object'` - A collection of `key:value` pairs; use a table.

* `'nil'` - A definiton without value; default behavior if a `nil` is passed in.

* `'number'` / `'integer'` / `'float'` - A value of mathamatical value; default behavior if a `number` is passed in.

* `'stringmap'` - A collection of `key => value` pairs; use a table.

Tables inside other tables must contain a key called `'__tableDef'`, with appropiate labelling for table handling.

Example:

```lua
-- array
local tArray ={
    1,
    2,
    3,
    
    -- object inside array
    {
        ['__tableDef'] = 'object'
        ['a'] = 1
        ['b'] = 2
        ['c'] = 3
    }
}
```

All data that is serialized will be placed into `haxe.serializedData`.

#### unserializeData(serializedData?: string|nil)

Returns unserialized data created in the Haxe format.

Not all serialized data types are currently available. Below is a full list of availiable data types:

* Boolean
* Exception (*No Messaege*)
* Float
* Integer
* List
* NaN
* Nil
* Object
* Object End
* Positive and Negative Infinity
* String
* String Cache Reference
* Zero

If `serializedData` is left as nil or blank, then it'll use  `haxe.serializedData`. Unserializing data from this variable will cause it to deplete.

Example:

```lua
-- 't'
datautil.haxe.serializedData = 'y1:t'
debugPrint(datautil.haxe.serializedData)
> 'y1:t'

-- unserialize data
local data = datautil.haxe.unserializeData()
debugPrint(data)
> 't'

debugPrint(datautil.haxe.serializedData)
>
```

#### unserializeDataWhole(serializedData?: string|nil)

Returns a table of the whole unserialized data created in the Haxe format.

Example:

```lua
-- 't', 't', 3, 4
datautil.haxe.serializedData = 'y1:ty1:ti3i4'

debugPrint(datautil.haxe.unserializeData())
> 't'
debugPrint(datautil.haxe.unserializeData())
> 't'
debugPrint(datautil.haxe.unserializeData())
> 3
debugPrint(datautil.haxe.unserializeData())
> 4

-- 't', 't', 3, 4
datautil.haxe.serializedData = 'y1:ty1:ti3i4'

debugPrint(datautil.haxe.unserializeDataWhole())
> { 't', 't', 3, 4 }
```
