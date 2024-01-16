# haxeserialization

## Usage

*haxeserialization* is a module used to handle serialized data in the haxe format through serialization or unserialization

Refer to <https://haxe.org/manual/std-serialization.html> for more information on serialized data.

## Variables

```lua
--- Serialized data that is created from the serializeData function.
serializedData = ''
```

## Functions

### serializeData(unserializedData: any, forcedDataType?: string|nil)

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

All data that is serialized will be placed into `haxeserialization.serializedData`.

### unserializeData(serializedData?: string|nil)

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

If `serializedData` is left as nil or blank, then it'll use `haxeserialization.serializedData`. Unserializing data from this variable will cause it to deplete.

Example:

```lua
-- 't'
haxeserialization.serializedData = 'y1:t'

debugPrint(haxeserialization.serializedData)
> 'y1:t'

-- unserialize data
debugPrint(haxeserialization.unserializeData())
> 't'

debugPrint(haxeserialization.unserializeData())
>
```

### unserializeDataWhole(serializedData?: string|nil)

Returns a table of the whole unserialized data created in the Haxe format.

Example:

```lua
-- 't', 't', 3, 4
haxeserialization.serializedData = 'y1:ty1:ti3i4'

debugPrint(haxeserialization.unserializeData())
> 't'
debugPrint(haxeserialization.unserializeData())
> 't'
debugPrint(haxeserialization.unserializeData())
> 3
debugPrint(haxeserialization.unserializeData())
> 4

-- 't', 't', 3, 4
haxeserialization.serializedData = 'y1:ty1:ti3i4'

debugPrint(haxeserialization.unserializeDataWhole())
> { 't', 't', 3, 4 }
```
