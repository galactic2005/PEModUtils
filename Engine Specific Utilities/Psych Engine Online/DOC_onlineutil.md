# onlineitil

## Usage

*onlineutil* is a module used for [Psych Engine Online](https://github.com/Snirozu/Funkin-Psych-Online/) by Snirozu.

## Variables

```lua
--- Table of default player stats in order
tableDefaultPlayerStats = {
    0,
    0,
    0,
    0,
    0,
    0,
    '',
    false,
    false,
    false,
    0
}

--- Table of player stats in order as defined in `online/scheme/Player.hx`
tablePlayerStatStrings = {
    'score',
    'misses',
    'sicks',
    'goods',
    'bads',
    'shits',
    'name',
    'hasSong',
    'hasLoaded',
    'hasEnded',
    'ping'
}
```

## Functions

### getPlayerStat(player:Dynamic, stat:String)

Returns a player's current stat. If `player` isn't one or two or if the `stat` does not exist, then it'll return `nil`.

If `player` is not a string, it'll be converted to one. This allows you to input numbers to check for specific players.

The following stats can be retrieved:

* `score` - The current amount of song score the player has.
* `misses` - The current amount of song misses the player has.
* `sicks` - The current amount of sick ratings the player has.
* `goods` - The current amount of good ratings the player has.
* `bads` - The current amount of bad ratings the player has.
* `shits` - The current amount of shit ratings the player has.
* `name` - The player's name.
* `hasSong` - Checks if the player has the song being played or not.
* `hasLoaded` - Checks if the player has loaded into the song or not.
* `hasEnded` - Checks if the player has ended the song or not.
* `ping` - The current ping the player has in miliseconds.

### getPlayerStatsTable(player:Dynamic)

Returns a player's current stats as a table. If `player` isn't one or two, then it'll return the following table:

```lua
{nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
```

If `player` is not a string, it'll be converted to one. This allows you to input numbers to check for specific players.

### getPsychEngineOnlineVersion()

Returns the current Psych Engine Online version.

### isAnarchyMode()

Returns `true` if Anarchy Mode is enabled; else false.

### isClientOnline()

Returns `true` if the client is online; else false.

### isClientOwner()

Returns `true` if the client is the owner; else false.

### isOpponent()

Returns `true` if the client is the opponent; else false.

When offline, it'll return `opponentMode` from the class `states.PlayState`.

### isPrivateRoom()

Returns `true` if the game is private; else false.

### isSwapSides()

Returns `true` if Swap Sides is enabled; else false.

### toggleOpponentMode()

Toggles `opponentMode`; does not work online.
