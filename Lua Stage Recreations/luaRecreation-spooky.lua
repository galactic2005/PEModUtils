--[[
	MIT License

	Copyright (c) 2023 galatic_2005

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
]]

local lightningStrikeBeat = 0
local lightningOffset = 8

function onCreate()
	if lowQuality then
		makeLuaSprite('halloweenBG', 'halloween_bg_low', -200, -100)
	else
		makeAnimatedLuaSprite('halloweenBG', 'halloween_bg', -200, -100)
			addAnimationByPrefix('halloweenBG', 'halloweem bg lightning strike', 'halloweem bg lightning strike', 24, false)
			addAnimationByPrefix('halloweenBG', 'halloweem bg', 'halloweem bg', 0, false)
	end
	addLuaSprite('halloweenBG', false)
	playAnim('halloweenBG', 'halloweem bg', true)

	precacheSound('thunder_1')
	precacheSound('thunder_2')
end

function onCreatePost()
	makeLuaSprite('halloweenWhite', '', -800, -400)
	makeGraphic('halloweenWhite', screenWidth * 2, screenHeight * 2, 'FFFFFF')
	setProperty('halloweenWhite.alpha', 0)
	setBlendMode('halloweenWhite', 'add')
	setScrollFactor('halloweenWhite', 0, 0)

	addLuaSprite('halloweenWhite', false)
end

function onBeatHit()
	if getRandomInt(0, 10) == 10 and curBeat > lightningStrikeBeat + lightningOffset then
		lightningStrikeShit()
	end
end

function lightningStrikeShit()
	playSound('thunder_' .. getRandomInt(1, 2), 1)
	if not lowQuality then
		playAnim('halloweenBG', 'halloweem bg lightning strike', true)
	end

	lightningStrikeBeat = curBeat
	lightningOffset = getRandomInt(8, 24)

	playAnim('boyfriend', 'scared', true)
	playAnim('dad', 'scared', true)
	playAnim('gf', 'scared', true)

	if cameraZoomOnBeat then
		setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.015)
		setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.03)

		if not getProperty('camZooming') then
			doTweenZoom('camGameTween', 'camGame', getProperty('defaultCamZoom'), 0.5, 'linear')
			doTweenZoom('camHUDTween', 'camHUD', 1, 0.5, 'linear')
		end
	end

	if flashingLights then
		setProperty('halloweenWhite.alpha', 0.4)

		doTweenAlpha('halloweenWhiteTween', 'halloweenWhite', 0.5, 0.075, 'linear')
		runTimer('halloweenWhiteSecondTween', 0.15)
	end
end

---
--- @param tag string
--- @param loops integer
--- @param loopsLeft integer
---
function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'halloweenWhiteSecondTween' then
		doTweenAlpha('halloweenWhiteTween', 'halloweenWhite', 0, 0.25, 'linear')
	end
end