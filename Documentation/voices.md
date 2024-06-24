# voices

## Usage

*voices* is a module used to manipulate the voices of the opponent or player.

## Functions

### reloadCharacterVoice(characterName: string)

Reloads the character voice to use their postfix, allowing dynamic reloading of the character voices. This also allows you to switch characters mid-song and load the appropiate voice file.

The `characterName` accepts player or opponent sides, girlfriend will result in the function doing nothing.

```lua
voices.reloadCharacterVoice('dad')
-- reload dad voice

voices.reloadCharacterVoice('boyfriend')
-- reload boyfriend voice

voices.reloadCharacterVoice('girlfriend')
-- does nothing
```

If the current version of Psych Engine is 0.7.2 or lower, the function will do nothing.