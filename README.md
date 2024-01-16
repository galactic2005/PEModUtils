# PEModUtils

![Banner](banner.png)

A repository containing various premade assets available to use for [Psych Engine](https://github.com/ShadowMario/FNF-PsychEngine) or any engines built off it.

* LUA Stage Recreations - stage recreations made in LUA.
* Utilities - utilities made for a variety of use cases.

If you have issues working with something in this repository, open an issue!

## How to Use

### Utilities

To use an utility, simply use `require()` to load the module and all its child functions and variables. Make sure to place the .lua files in their correct place.

```lua
-- Data Serialization
local haxeserialization = require(currentModDirectory .. '/haxeserialization')


-- Engine Specific
local psychonline = require(currentModDirectory .. '/psychonline')

-- File Manipulation
local file = require(currentModDirectory .. '/file')
local listfile = require(currentModDirectory .. '/listfile')

-- No Folder
local apicompatible = require(currentModDirectory .. '/apiocmpatible')
local color = require(currentModDirectory .. '/color')
local extramath = require(currentModDirectory .. '/extramath')
local mod = require(currentModDirectory .. '/mod')
```

To confirm it works, you can use `debugPrint()` to print out the `_VERSION` variable of a module.

```lua
debugPrint(fileutil._VERSION) -- returns the current version of fileutil
```

Refer to the documentation folder or online wiki for how to utilize the modules.

### LUA Stage Recreations

Place the associated .json and .lua file into the stages folder of a mod to use.

## Licensing and Usage

This utility is free software; you can redistribute it and/or modify it under the terms of the MIT license. See [LICENSE](LICENSE) for details.

Because of the license, crediting is optional. I do highly appreciate it though and would love to see how you've utilized my works.
