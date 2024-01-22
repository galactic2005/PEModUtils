# enginecheck

## Usage

*enginecheck* is a module used for checking which engine the player is using.

## Functions

### getEngine()

Returns the engine the player is currently using alongside the version. Below is a list of supported engines alongside their returns:

* JS Engine - `'JS Engine ' .. jsVersion`
* Psych Online - `'Psych Online ' .. psychOnlineVersion`
* Unnamed Multiplayer Mod - `'Unnamed Multiplayer Mod ' .. UMMversion`

For any other engines or base-Psych Engine, it'll return `'Psych Engine' .. version`.
