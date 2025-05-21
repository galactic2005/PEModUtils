# music

## Usage

*music* is a module used to manipulate the music.

## Functions

### reloadCharacterVoice(characterName: string)

Reloads the character voice to use their postfix, allowing dynamic alterations of the character voices. This also allows you to switch characters mid-song and load the appropriate voice file.

The `characterName` accepts player or opponent sides, girlfriend will result in the function doing nothing.

```lua
voices.reloadCharacterVoice('dad')
-- reload dad voice

voices.reloadCharacterVoice('boyfriend')
-- reload boyfriend voice

voices.reloadCharacterVoice('girlfriend')
-- does nothing
```

If the current version of Psych Engine is 0.7.2 or lower, this function does nothing.

### reloadInstrumental(postfix: string)

Reloads the instrumental to use the specified postfix, allowing dynamic alterations of the instrumental.

```lua
music.reloadInstrumental('')
-- reloads instrumental, searches for 'Inst'

music.reloadInstrumental('erect')
-- reloads instrumental, searches for 'Inst-erect'
```

If the current version of Psych Engine is 0.7.2 or lower, this function does nothing.
