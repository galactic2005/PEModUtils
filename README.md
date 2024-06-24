# PEModUtils

![Banner](banner.png)

*PEModUtils* is a repository containing various premade assets available to use for [Psych Engine](https://github.com/ShadowMario/FNF-PsychEngine) or any engines built off it.

* Lua Stage Recreations - stage recreations made in Lua.
* Utilities - utilities made for a variety of use cases.

This allows you to focus on what's needed in your project with not having to deal with manually creating backend code or debugging code.

## Cloning

Use [git](https://git-scm.com/) to clone.

```git
git clone https://github.com/galactic2005/PEModUtils.git
```

If you'd like to use the experimental branch, use the following command instead:

```git
git clone -b experimental https://github.com/galactic2005/PEModUtils.git
```

It's highly recommended to use [Releases](https://github.com/galactic2005/PEModUtils/releases) or the master branch for your modding needs. If you plan on contributing, it's required to use the experimental branch.

## Setup/Usage

### Lua Stage Recreations

Place the associated `.json` and `.lua` file into the `stages/` folder of a mod.

### Utilities

To use an utility, use `require()`.

```lua
local file = require(currentModDirectory .. '/file')

-- returns the current version of file
debugPrint(file._VERSION)
```

> See [require.lua](require.lua) for all requires.

Refer to the `Documentation/` folder or the [PEModUtils Wiki](https://github.com/galactic2005/PEModUtils/wiki) for information on modules and how to use them.

## Help

If you need help with setting up or if there's a problem with code, please open an issue.

Alternatively, you can contact me through Discord at `galactic_2005`. I'll provide assistance to the best of my ability.

## Contributing

This repository is open to contributions. See [CONTRIBUTING](CONTRIBUTING.md) for details.

If you'd like to see who contributed, see [CONTRIBUTORS](CONTRIBUTORS.md)

## License

This utility is free software; you can redistribute it and/or modify it under the terms of the MIT license. See [LICENSE](LICENSE) for details.
