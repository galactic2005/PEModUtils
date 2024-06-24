local voices = {
    _AUTHORS = 'galactic_2005',
    _VERSION = '1.0.0'
}

---Reloads the character voice to use their postfix, allowing dynamic reloading of the character voices
---
---The `characterName` variable accepts player or opponent sides, girlfriend will result in the function doing nothing.
---
---If the current version of Psych Engine is 0.7.2 or lower, the function will do nothing.
---@param character string
function voices.reloadCharacterVoice(character)
    if version < '0.7.3' then return end
    local characterType = type(character)
    assert(characterType == 'number' or characterType == 'string', 'Expected string for characterName, got ' .. characterType .. '.') -- use only strings for characterName

	local newCharacterName = stringTrim(tostring(character):lower())
	local isGirlfriend = (newCharacterName == '2' or newCharacterName == 'gf' or newCharacterName == 'girlfriend')
	if isGirlfriend then return end

	local isDad = (newCharacterName == '1' or newCharacterName == 'dad' or newCharacterName == 'opponent')
	local character = (isDad and 'dad' or 'boyfriend')

    local backupVocalsFile = (isDad and 'Opponent' or 'Player')
    local extraCode = (isDad and
    'if(newVocals != null) opponentVocals.loadEmbedded(newVocals);' or
    'vocals.loadEmbedded(newVocals != null ? newVocals : Paths.voices(song));')

    runHaxeCode([[
        var song = PlayState.SONG.song;
        var newVocals = Paths.voices(song, (]] .. character .. [[.vocalsFile == null || ]] .. character .. [[.vocalsFile.length < 1) ? ']] .. backupVocalsFile .. [[' : ]] .. character .. [[.vocalsFile);
    ]] .. extraCode
    )
end

return voices