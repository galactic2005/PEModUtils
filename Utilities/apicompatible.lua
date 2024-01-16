-- http://lua-users.org/wiki/SwitchStatement
--
-- thanks LHF, DaveBollinger, EricTetz, and PeterPrade

local function switch(term, cases)
    local function contain(element, table)
        for _, value in pairs(table) do
            if value == element then
                return true
            end
        end
        return false
    end

    assert(type(cases) == 'table')
    local casetype, caseparm, casebody
    for i,case in ipairs(cases) do
        assert(type(case) == 'table' and #case == 3)
        casetype, caseparm, casebody = case[1], case[2], case[3]
        assert(type(casetype) == 'string' and type(casebody) == 'function')
        if
            (casetype == 'default')
        or  ((casetype == 'eq' or casetype == '') and caseparm == term)
        or  ((casetype == '!eq' or casetype == '!') and not caseparm == term)
        or  (casetype == 'in' and contain(term, caseparm))
        or  (casetype == '!in' and not contain(term, caseparm))
        then
            return casebody(term)
        elseif
            (casetype == 'default-fall')
        or  ((casetype == 'eq-fall' or casetype == 'fall') and caseparm == term)
        or  ((casetype == '!eq-fall' or casetype == '!-fall') and not caseparm == term)
        or  (casetype == 'in-fall' and contain(term, caseparm))
        or  (casetype == '!in-fall' and not contain(term, caseparm))
        then
            casebody(term)
        end
    end
end

--- @param preVersionSeven string
--- @param versionSeven string
local function returnBasedOnVersion(preVersionSeven, versionSeven)
    if version < '0.7.0' then
        -- 0.1.0 to 0.6.3h
        return preVersionSeven
    end

    -- 0.7.0 to 0.7.x
    return versionSeven
end

local apicompatible = {
    _VERSION = '1.0.2',

    --- Whether `returnCompatibleClassName` and `returnCompatibleVariableName` output a debug message if no class name was found
    returnCompatibleNameDebugMessage = false
}

--- A version of `getPropertyFromClass` that automatically converts variables using the other functions listed
---
--- Refer to the documenation for `getPropertyFromClass` for more information on this function
--- @param classVar string
--- @param variable string
--- @param allowMaps? boolean
--- @return any property
function apicompatible.getPropertyFromClass(classVar, variable, allowMaps)
    assert(type(classVar) == 'string', 'Expected string for classVar, got ' .. type(classVar) .. '.') -- use only strings for classVar
    assert(type(variable) == 'string', 'Expected string for variable, got ' .. type(variable) .. '.') -- use only strings for variable
    if allowMaps == nil then
        allowMaps = false
    end

    return getPropertyFromClass(apicompatible.returnCompatibleClassName(classVar), variable, allowMaps)
end

--- A version of `setPropertyFromClass` that automatically converts variables using the other functions listed
---
--- Refer to the documenation for `setPropertyFromClass` for more information on this function
--- @param classVar string
--- @param variable string
--- @param value any
--- @param allowMaps? boolean
function apicompatible.setPropertyFromClass(classVar, variable, value, allowMaps)
    assert(type(classVar) == 'string', 'Expected string for classVar, got ' .. type(classVar) .. '.') -- use only strings for classVar
    assert(type(variable) == 'string', 'Expected string for variable, got ' .. type(variable) .. '.') -- use only strings for variable
    if allowMaps == nil then
        allowMaps = false
    end

    local classToUse = apicompatible.returnCompatibleClassName(classVar)
    setPropertyFromClass(classToUse, apicompatible.returnCompatibleVariableName(classToUse, variable), value, allowMaps)
end

--- Enables the HUE/Brt/Sat system that was used before 0.7.0
---
--- Note that this function enables the system for all notes and strums.
function apicompatible.enableHueBrtSatNoteColorSystem()
    if version < '0.7.0' then
        -- don't run if we're already using the system
        return
    end

    for i = 0, getProperty('strumLineNotes.length')-1 do -- strumLineNotes
        setPropertyFromGroup('strumLineNotes', i, 'useRGBShader', false)
    end

    for i = 0, getProperty('unspawnNotes.length')-1 do -- unspawnNotes
        setPropertyFromGroup('unspawnNotes', i, 'rgbShader.enabled', false)
        setPropertyFromGroup('unspawnNotes', i, 'noteSplashData.useRGBShader', false)
    end
end

--- Returns the client preference name that is compatible with reflection functions in the version being played
--- @param clientPrefName string
--- @return string
function apicompatible.returnClientPrefName(clientPrefName)
    assert(type(clientPrefName) == 'string', 'Expected string for clientPrefName, got ' .. type(clientPrefName) .. '.') -- use only strings for clientPrefName
    return returnBasedOnVersion(clientPrefName, 'data.' .. clientPrefName)
end

--- Returns the class name that is compatible with reflection functions in the version being played
--- @param className string
--- @return string compatibleClassName
function apicompatible.returnCompatibleClassName(className)
    assert(type(className) == 'string', 'Expected string for className, got ' .. type(className) .. '.') -- use only strings for className

    local classNameToReturn = className
    switch(stringTrim(className:lower()), {
        -- backend package
        {'in', {'achievements', 'backend.achievements'}, function()
            classNameToReturn = returnBasedOnVersion('Achievements', 'backend.Achievements')
        end},
        {'in', {'clientprefs', 'backend.clientprefs'}, function()
            classNameToReturn = returnBasedOnVersion('ClientPrefs', 'backend.ClientPrefs')
        end},
        {'in', {'conductor', 'backend.conductor'}, function()
            classNameToReturn = returnBasedOnVersion('Conductor', 'backend.Conductor')
        end},
        {'in', {'controls', 'backend.controls'}, function()
            classNameToReturn = returnBasedOnVersion('Controls', 'backend.Controls')
        end},
        {'in', {'coolutil', 'backend.coolutil'}, function()
            classNameToReturn = returnBasedOnVersion('CoolUtil', 'backend.CoolUtil')
        end},
        {'in', {'customfadetransition', 'backend.customfadetransition'}, function()
            classNameToReturn = returnBasedOnVersion('CustomFadeTransition', 'backend.CustomFadeTransition')
        end},
        {'eq', 'backend.difficulty', function()
            classNameToReturn = returnBasedOnVersion('CoolUtil', 'backend.Difficulty')
        end},
        {'in', {'discord', 'backend.discord'}, function()
            classNameToReturn = returnBasedOnVersion('Discord', 'backend.Discord')
        end},
        {'in', {'highscore', 'backend.highscore'}, function()
            classNameToReturn = returnBasedOnVersion('Highscore', 'backend.Highscore')
        end},
        {'in', {'inputformatter', 'backend.inputformatter'}, function()
            classNameToReturn = returnBasedOnVersion('InputFormatter', 'backend.InputFormatter')
        end},
        {'in', {'musicbeatstate', 'backend.musicbeatstate'}, function()
            classNameToReturn = returnBasedOnVersion('MusicBeatState', 'backend.MusicBeatState')
        end},
        {'in', {'musicbeatsubstate', 'backend.musicbeatsubstate'}, function()
            classNameToReturn = returnBasedOnVersion('MusicBeatSubstate', 'backend.MusicBeatSubstate')
        end},
        {'in', {'paths', 'backend.paths'}, function()
            classNameToReturn = returnBasedOnVersion('Paths', 'backend.Paths')
        end},
        {'eq', 'rating', function()
            classNameToReturn = returnBasedOnVersion('Conductor', 'backend.Rating')
        end},
        {'in', {'section', 'backend.section'}, function()
            classNameToReturn = returnBasedOnVersion('Section', 'backend.Section')
        end},
        {'in', {'song', 'backend.song'}, function()
            classNameToReturn = returnBasedOnVersion('Song', 'backend.Song')
        end},
        {'in', {'stagedata', 'backend.stagedata'}, function()
            classNameToReturn = returnBasedOnVersion('StageData', 'backend.StageData')
        end},
        {'in', {'weekdata', 'backend.weekdata'}, function()
            classNameToReturn = returnBasedOnVersion('WeekData', 'backend.WeekData')
        end},

        -- cutscenes package
        {'in', {'cutscenehandler', 'cutscenes.cutscenehandler'}, function()
            classNameToReturn = returnBasedOnVersion('CutsceneHandler', 'cutscenes.CutsceneHandler')
        end},
        {'in', {'dialoguebox', 'cutscenes.dialoguebox'}, function()
            classNameToReturn = returnBasedOnVersion('DialogueBox', 'cutscenes.DialogueBox')
        end},
        {'in', {'dialogueboxpsych', 'cutscenes.dialogueboxpsych'}, function()
            classNameToReturn = returnBasedOnVersion('DialogueBoxPsych', 'cutscenes.DialogueBoxPsych')
        end},
        {'eq', 'cutscenes.dialoguecharacter', function()
            classNameToReturn = returnBasedOnVersion('DialogueBoxPsych', 'cutscenes.DialogueCharacter')
        end},

        -- debug package
        {'in', {'openfl.display.fps', 'debug.fpscounter'}, function()
            classNameToReturn = returnBasedOnVersion('openfl.display.FPS', 'debug.FPSCounter')
        end},

        -- flixel/addons/ui package
        {'in', {'flxuidropdownmenucustom', 'flixel.addons.ui.flxuidropdownmenucustom'}, function()
            classNameToReturn = returnBasedOnVersion('FlxUIDropDownMenuCustom', 'flixel.addons.ui.FlxUIDropDownMenuCustom')
        end},

        -- objects package
        {'in', {'alphabet', 'objects.alphabet'}, function()
            classNameToReturn = returnBasedOnVersion('Alphabet', 'objects.Alphabet')
        end},
        {'in', {'attachedsprite', 'objects.attachedsprite'}, function()
            classNameToReturn = returnBasedOnVersion('AttachedSprite', 'objects.AttachedSprite')
        end},
        {'in', {'attachedtext', 'objects.attachedtext'}, function()
            classNameToReturn = returnBasedOnVersion('AttachedText', 'objects.AttachedText')
        end},
        {'in', {'bgsprite', 'objects.bgsprite'}, function()
            classNameToReturn = returnBasedOnVersion('BGSprite', 'objects.BGSprite')
        end},
        {'in', {'character', 'objects.character'}, function()
            classNameToReturn = returnBasedOnVersion('Character', 'objects.Character')
        end},
        {'in', {'checkboxthingie', 'objects.checkboxthingie'}, function()
            classNameToReturn = returnBasedOnVersion('CheckboxThingie', 'objects.CheckboxThingie')
        end},
        {'in', {'healthicon', 'objects.healthicon'}, function()
            classNameToReturn = returnBasedOnVersion('HealthIcon', 'objects.HealthIcon')
        end},
        {'in', {'menucharacter', 'objects.menucharacter'}, function()
            classNameToReturn = returnBasedOnVersion('MenuCharacter', 'objects.MenuCharacter')
        end},
        {'in', {'menuitem', 'objects.menuitem'}, function()
            classNameToReturn = returnBasedOnVersion('MenuItem', 'objects.MenuItem')
        end},
        {'in', {'note', 'objects.note'}, function()
            classNameToReturn = returnBasedOnVersion('Note', 'objects.Note')
        end},
        {'in', {'notesplash', 'objects.notesplash'}, function()
            classNameToReturn = returnBasedOnVersion('NoteSplash', 'objects.NoteSplash')
        end},
        {'in', {'strumnote', 'objects.strumnote'}, function()
            classNameToReturn = returnBasedOnVersion('StrumNote', 'objects.StrumNote')
        end},
        {'in', {'typedalphabet', 'objects.typedalphabet'}, function()
            classNameToReturn = returnBasedOnVersion('TypedAlphabet', 'objects.TypedAlphabet')
        end},

        -- psychlua package
        {'eq', 'psychlua.callbackhandler', function()
            classNameToReturn = returnBasedOnVersion('FunkinLua', 'psychlua.CallbackHandler')
        end},
        {'eq', 'psychlua.customsubstate', function()
            classNameToReturn = returnBasedOnVersion('FunkinLua', 'psychlua.CustomSubstate')
        end},
        {'eq', 'psychlua.debugluatext', function()
            classNameToReturn = returnBasedOnVersion('FunkinLua', 'psychlua.DebugLuaText')
        end},
        {'eq', 'psychlua.extrafunctions', function()
            classNameToReturn = returnBasedOnVersion('FunkinLua', 'psychlua.ExtraFunctions')
        end},
        {'in', {'funkinlua', 'psychlua.funkinlua'}, function()
            classNameToReturn = returnBasedOnVersion('FunkinLua', 'psychlua.FunkinLua')
        end},
        {'eq', 'psychlua.hscript', function()
            classNameToReturn = returnBasedOnVersion('FunkinLua', 'psychlua.HScript')
        end},
        {'eq', 'psychlua.luautils', function()
            classNameToReturn = returnBasedOnVersion('FunkinLua', 'psychlua.LuaUtils')
        end},
        {'eq', 'psychlua.modchartanimatesprite', function()
            classNameToReturn = returnBasedOnVersion('FunkinLua', 'psychlua.ModchartAnimateSprite')
        end},
        {'eq', 'psychlua.modchartsprite', function()
            classNameToReturn = returnBasedOnVersion('FunkinLua', 'psychlua.ModchartSprite')
        end},
        {'eq', 'psychlua.reflectionfunctions', function()
            classNameToReturn = returnBasedOnVersion('FunkinLua', 'psychlua.ReflectionFunctions')
        end},
        {'eq', 'psychlua.shaderfunctions', function()
            classNameToReturn = returnBasedOnVersion('FunkinLua', 'psychlua.ShaderFunctions')
        end},
        {'eq', 'psychlua.textfunctions', function()
            classNameToReturn = returnBasedOnVersion('FunkinLua', 'psychlua.TextFunctions')
        end},

        -- states/editors package
        {'in', {'editors.charactereditorstate', 'states.editors.charactereditorstate'}, function()
            classNameToReturn = returnBasedOnVersion('editors.CharacterEditorState', 'states.editors.CharacterEditorState')
        end},
        {'in', {'editors.chartingstate', 'states.editors.chartingstate'}, function()
            classNameToReturn = returnBasedOnVersion('editors.ChartingState', 'states.editors.ChartingState')
        end},
        {'in', {'editors.dialoguecharactereditorstate', 'states.editors.dialoguecharactereditorstate'}, function()
            classNameToReturn = returnBasedOnVersion('editors.DialogueCharacterEditorState', 'states.editors.DialogueCharacterEditorState')
        end},
        {'in', {'editors.dialogueeditorstate', 'states.editors.dialogueeditorstate'}, function()
            classNameToReturn = returnBasedOnVersion('editors.DialogueEditorState', 'states.editors.DialogueEditorState')
        end},
        {'eq', 'editors.editorlua', function()
            classNameToReturn = returnBasedOnVersion('editors.EditorLua', 'psychlua.FunkinLua')
        end},
        {'in', {'editors.editorplaystate', 'states.editors.editorplaystate'}, function()
            classNameToReturn = returnBasedOnVersion('editors.EditorPlaystate', 'states.editors.EditorPlaystate')
        end},
        {'in', {'editors.mastereditormenu', 'states.editors.mastereditormenu'}, function()
            classNameToReturn = returnBasedOnVersion('editors.MasterEditorMenu', 'states.editors.MasterEditorMenu')
        end},
        {'in', {'editors.menucharactereditorstate', 'states.editors.menucharactereditorstate'}, function()
            classNameToReturn = returnBasedOnVersion('editors.MenuCharacterEditorState', 'states.editors.MenuCharacterEditorState')
        end},
        {'in', {'editors.weekeditorstate', 'states.editors.weekeditorstate'}, function()
            classNameToReturn = returnBasedOnVersion('editors.WeekEditorState', 'states.editors.WeekEditorState')
        end},

        -- states/stages/objects package
        {'in', {'backgrounddancer', 'states.stages.objects.backgrounddancer'}, function()
            classNameToReturn = returnBasedOnVersion('BackgroundDancer', 'states.stages.objects.BackgroundDancer')
        end},
        {'in', {'backgroundgirls', 'states.stages.objects.backgroundgirls'}, function()
            classNameToReturn = returnBasedOnVersion('BackgroundGirls', 'states.stages.objects.BackgroundGirls')
        end},
        {'eq', 'backgroundtank', function()
            classNameToReturn = returnBasedOnVersion('PlayState', 'states.stages.objects.BackgroundTank')
        end},
        {'eq', 'dadbattlefog', function()
            classNameToReturn = returnBasedOnVersion('PlayState', 'states.stages.objects.DadBattleFog')
        end},
        {'eq', 'mallcrowd', function()
            classNameToReturn = returnBasedOnVersion('PlayState', 'states.stages.objects.MallCrowd')
        end},
        {'in', {'tankmenbg' or 'states.stages.objects.tankmenbg'}, function()
            classNameToReturn = returnBasedOnVersion('TankmenBG', 'states.stages.objects.TankmenBG')
        end},

        -- shaders package
        {'in', {'blendmodeeffect', 'shaders.blendmodeeffect'}, function()
            classNameToReturn = returnBasedOnVersion('BlendModeEffect', 'shaders.BlendModeEffect')
        end},
        {'in', {'colorswap', 'shaders.colorswap'}, function()
            classNameToReturn = returnBasedOnVersion('ColorSwap', 'shaders.ColorSwap')
        end},
        {'in', {'overlayshader', 'shaders.overlayshader'}, function()
            classNameToReturn = returnBasedOnVersion('OverlayShader', 'shaders.OverlayShader')
        end},
        {'in', {'wiggleeffect', 'shaders.wiggleeffect'}, function()
            classNameToReturn = returnBasedOnVersion('WiggleEffect', 'shaders.WiggleEffect')
        end},

        -- states package
        {'in', {'achievementsmenustate', 'states.achievementsmenustate'}, function()
            classNameToReturn = returnBasedOnVersion('AchievementsMenuState', 'states.AchievementsMenuState')
        end},
        {'in', {'creditsstate', 'states.creditsstate'}, function()
            classNameToReturn = returnBasedOnVersion('CreditsState', 'states.CreditsState')
        end},
        {'in', {'flashingstate', 'states.flashingstate'}, function()
            classNameToReturn = returnBasedOnVersion('FlashingState', 'states.FlashingState')
        end},
        {'in', {'freeplaystate', 'states.freeplaystate'}, function()
            classNameToReturn = returnBasedOnVersion('FreeplayState', 'states.FreeplayState')
        end},
        {'in', {'loadingstate', 'states.loadingstate'}, function()
            classNameToReturn = returnBasedOnVersion('LoadingState', 'states.LoadingState')
        end},
        {'in', {'modsmenustate', 'states.modsmenustate'}, function()
            classNameToReturn = returnBasedOnVersion('ModsMenuState', 'states.ModsMenuState')
        end},
        {'in', {'outdatedstate', 'states.outdatedstate'}, function()
            classNameToReturn = returnBasedOnVersion('OutdatedState', 'states.OutdatedState')
        end},
        {'in', {'playstate', 'states.playstate'}, function()
            classNameToReturn = returnBasedOnVersion('PlayState', 'states.PlayState')
        end},
        {'in', {'storymenustate', 'states.storymenustate'}, function()
            classNameToReturn = returnBasedOnVersion('StoryMenuState', 'states.StoryMenuState')
        end},
        {'in', {'titlestate', 'states.titlestate'}, function()
            classNameToReturn = returnBasedOnVersion('TitleState', 'states.TitleState')
        end},

        -- substates package
        {'in', {'gameoversubstate', 'substates.gameoversubstate'}, function()
            classNameToReturn = returnBasedOnVersion('GameOverSubstate', 'substates.GameOverSubstate')
        end},
        {'in', {'gameplaychangerssubstate', 'substates.gameplaychangerssubstate'}, function()
            classNameToReturn = returnBasedOnVersion('GameplayChangersSubstate', 'substates.GameplayChangersSubstate')
        end},
        {'in', {'pausesubstate', 'substates.pausesubstate'}, function()
            classNameToReturn = returnBasedOnVersion('PauseSubState', 'substates.PauseSubState')
        end},
        {'in', {'prompt', 'substates.prompt'}, function()
            classNameToReturn = returnBasedOnVersion('Prompt', 'substates.Prompt')
        end},
        {'in', {'resetscoresubstate', 'substates.resetscoresubstate'}, function()
            classNameToReturn = returnBasedOnVersion('ResetScoreSubState', 'substates.ResetScoreSubState')
        end},

        -- unused package
        {'in', {'buttonremapsubstate', 'unused.buttonremapsubstate'}, function()
            classNameToReturn = returnBasedOnVersion('ButtonRemapSubstate', 'unused.ButtonRemapSubstate')
        end},
        {'in', {'chartparser', 'unused.chartparser'}, function()
            classNameToReturn = returnBasedOnVersion('ChartParser', 'unused.ChartParser')
        end},
        {'in', {'gitaroopause', 'unused.gitaroopause'}, function()
            classNameToReturn = returnBasedOnVersion('GitarooPause', 'unused.GitarooPause')
        end},
        {'in', {'latencystate', 'unused.latencystate'}, function()
            classNameToReturn = returnBasedOnVersion('LatencyState', 'unused.LatencyState')
        end},
        {'in', {'snd', 'unused.snd'}, function()
            classNameToReturn = returnBasedOnVersion('Snd', 'unused.Snd')
        end},
        {'in', {'sndtv', 'unused.sndtv'}, function()
            classNameToReturn = returnBasedOnVersion('SndTV', 'unused.SndTV')
        end},

        -- default
        {'default', '', function()
            if apicompatibleutil.returnCompatibleNameDebugMessage then
                debugPrint('Could not find ' .. className .. ' class for ' .. version .. '. Returned className.')
            end
        end}
    })
    return classNameToReturn
end

--- Returns the variable name that is compatible with reflection functions in the version being played
---
--- If `className` is nil or isn't defined, it'll return a `PlayState` or `states.PlayState` variable.
--- @param variableName string
--- @param className? string
--- @return string compatibleVariableName
function apicompatible.returnCompatibleVariableName(variableName, className)
    assert(type(variableName) == 'string', 'Expected string for variableName, got ' .. type(variableName) .. '.') -- use only strings for variableName
    if className == nil then
        className = 'PlayState'
    end

    local variableNameToReturn = variableName
    switch(stringTrim(className:lower()), {
        -- backend package
        {'in', {'clientprefs', 'backend.clientprefs'}, function()
            switch(stringTrim(variableName:lower()), {
                -- clientprefs class
                {'in', {'globalantialiasing', 'antialiasing'}, function()
                    variableNameToReturn = returnBasedOnVersion('globalAntialiasing', 'antialiasing')
                end},
                {'default', '', function()
                    if apicompatibleutil.returnCompatibleNameDebugMessage then
                        debugPrint('Could not find ' .. variableName .. ' variable for ' .. version .. ' in ' .. className .. '. Returned variableName.')
                    end
                end}
            })
        end},
        {'in', {'conductor', 'backend.conductor'}, function()
            switch(stringTrim(variableName:lower()), {
                -- conductor class
                {'eq', 'lastSongPos', function()
                    variableNameToReturn = returnBasedOnVersion('lastSongPos', 'songPosition')
                end},
                {'default', '', function()
                    if apicompatibleutil.returnCompatibleNameDebugMessage then
                        debugPrint('Could not find ' .. variableName .. ' variable for ' .. version .. ' in ' .. className .. '. Returned variableName.')
                    end
                end}
            })
        end},

        -- objects package
        {'in', {'note', 'objects.note'}, function()
            switch(stringTrim(variableName:lower()), {
                -- note class
                {'in', {'notesplashdisabled', 'notesplashdata.disabled'}, function()
                    variableNameToReturn = returnBasedOnVersion('noteSplashDisabled', 'noteSplashData.disabled')
                end},
                {'in', {'notesplashtexture', 'notesplashdata.texture'}, function()
                    variableNameToReturn = returnBasedOnVersion('noteSplashTexture', 'noteSplashData.texture')
                end},
                {'eq', 'noteSplashData.antialiasing', function()
                    variableNameToReturn = returnBasedOnVersion('antialiasing', 'noteSplashData.antialiasing')
                end},
                {'default', '', function()
                    if apicompatibleutil.returnCompatibleNameDebugMessage then
                        debugPrint('Could not find ' .. variableName .. ' variable for ' .. version .. ' in ' .. className .. '. Returned variableName.')
                    end
                end}
            })
        end},

        -- states package
        {'in', {'playstate', 'states.playstate'}, function()
            switch(stringTrim(variableName:lower()), {
                -- playstate class
                {'eq', 'bads', function()
                    variableNameToReturn = returnBasedOnVersion('bads', 'ratingsData[2].hits')
                end},
                {'in', {'camFollowPos', 'camGame.scroll'}, function()
                    variableNameToReturn = returnBasedOnVersion('camFollowPos', 'camGame.scroll')
                end},
                {'eq', 'goods', function()
                    variableNameToReturn = returnBasedOnVersion('goods', 'ratingsData[1].hits')
                end},
                {'in', {'healthbarbg', 'healthbar.bg'}, function()
                    variableNameToReturn = returnBasedOnVersion('healthBarBG', 'healthBar.bg')
                end},
                {'eq', 'prevCamFollowPos', function()
                    variableNameToReturn = returnBasedOnVersion('prevCamFollowPos', 'camGame.scroll')
                end},
                {'eq', 'sicks', function()
                    variableNameToReturn = returnBasedOnVersion('sicks', 'ratingsData[0].hits')
                end},
                {'eq', 'shits', function()
                    variableNameToReturn = returnBasedOnVersion('shits', 'ratingsData[3].hits')
                end},
                {'in', {'timebarbg', 'timebar.bg'}, function()
                    variableNameToReturn = returnBasedOnVersion('timeBarBG', 'timeBar.bg')
                end},
                {'default', '', function()
                    if apicompatibleutil.returnCompatibleNameDebugMessage then
                        debugPrint('Could not find ' .. variableName .. ' variable for ' .. version .. ' in ' .. className .. '. Returned variableName.')
                    end
                end}
            })
        end},

        -- substates package
        {'in', {'gameoversubstate', 'substates.gameoversubstate'}, function()
            switch(stringTrim(variableName:lower()), {
                -- gameoversubstate class
                {'in', {'camFollowPos', 'camGame.scroll'}, function()
                    variableNameToReturn = returnBasedOnVersion('camFollowPos', 'camGame.scroll')
                end},
                {'in', {'updateCamera', 'moveCamera'}, function()
                    variableNameToReturn = returnBasedOnVersion('updateCamera', 'moveCamera')
                end},
                {'default', '', function()
                    if apicompatibleutil.returnCompatibleNameDebugMessage then
                        debugPrint('Could not find ' .. variableName .. ' variable for ' .. version .. ' in ' .. className .. '. Returned variableName.')
                    end
                end}
            })
        end},

        -- default
        {'default', '', function()
            if apicompatibleutil.returnCompatibleNameDebugMessage then
                debugPrint('Could not find ' .. className .. ' class for ' .. version .. '. Returned variableName.')
            end
        end}
    })
    return variableNameToReturn
end

return apicompatible