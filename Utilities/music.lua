local music = {
	_AUTHORS = 'galactic_2005',
	_VERSION = '1.0.0'
}

--- Reloads the character voice to use their postfix, allowing dynamic alterations of the character voices
---
--- The `characterName` variable accepts player or opponent sides, girlfriend will result in the function doing nothing.
---
--- If the current version of Psych Engine is 0.7.2 or lower, the function will do nothing.
--- @param character string
function music:reloadCharacterVoice(character)
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
	]] .. extraCode)
end

--- Reloads the instrumental to use the specified postfix, allowing dynamic alterations of the instrumental
---
--- If the current version of Psych Engine is 0.7.2 or lower, this function will do nothing.
--- @param postfix string
function music:reloadInstrumental(postfix)
	if version < '0.7.3' then return end
	local postfixType = type(postfix)
	assert(postfixType == 'number' or postfixType == 'string', 'Expected string for postfix, got ' .. postfixType .. '.') -- use only strings for postfix

	if postfix ~= '' then
		local newPostfixName = '-' .. stringTrim(tostring(postfix):lower())
	end

	runHaxeCode([[
		var songKey = '${Paths.formatToSongPath(song)}/Inst]] .. postfix .. [[';
		if (songKey == null) songKey = '${Paths.formatToSongPath(song)}/Inst';
		var newInst = Path.returnSound(null, songKey, 'songs');
		inst.loadEmbedded(newInst);
	]])
end

return music