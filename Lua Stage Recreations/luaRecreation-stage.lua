--[[
	MIT License

	Copyright (c) 2023-2024 galatic_2005

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

function onCreate()
	makeLuaSprite('bg', 'stageback', -600, -200)
	addLuaSprite('bg', false)

	setScrollFactor('bg', 0.9, 0.9)

	makeLuaSprite('stageFront', 'stagefront', -650, 600)
	addLuaSprite('stageFront', false)

	scaleObject('stageFront', 1.1, 1)
	updateHitbox('stageFront')
	setScrollFactor('stageFront', 0.9, 0.9)

	if not lowQuality then
		makeLuaSprite('stageLight_one', 'stage_light', -125, -100)
		addLuaSprite('stageLight_one', false)

		scaleObject('stageLight_one', 1.1, 1)
		updateHitbox('stageLight_one')
		setScrollFactor('stageLight_one', 0.9, 0.9)

		makeLuaSprite('stageLight_two', 'stage_light', 1225, -100)
		addLuaSprite('stageLight_two', false)

		scaleObject('stageLight_two', 1.1, 1)
		updateHitbox('stageLight_two')
		setScrollFactor('stageLight_two', 0.9, 0.9)
		setProperty('stageLight_two.flipX', true)

		makeLuaSprite('stageCurtains', 'stagecurtains', -500, -300)
		addLuaSprite('stageCurtains', false)

		scaleObject('stageCurtains', 0.9, 1)
		updateHitbox('stageCurtains')
		setScrollFactor('stageCurtains', 1.3, 1.3)
	end

	-- Dadbattle Spotlight
	makeGraphic('dadbattleBlackDarkness', screenWidth * 2, screenHeight * 2, '0xFF000000')
	makeLuaSprite('dadbattleBlack', 'dadbattleBlackDarkness', -800, -400)
	addLuaSprite('dadbattleBlack', false)

	setScrollFactor('dadbattleBlack', 0, 0)
	setProperty('dadbattleBlack.alpha', 0.25)
	setProperty('dadbattleBlack.visible', false)

	makeLuaSprite('dadbattleLight', 'dadbattleBlackDarkness', 400, -400)
	addLuaSprite('dadbattleLight', false)

	setBlendMode('dadbattleLight', 'ADD')
	setProperty('dadbattleLight.alpha', 0.375)
	setProperty('dadbattleLight.visible', false)

	local offsetX = 200
	makeLuaSprite('smoke_one', 'smoke', -1550 + offsetX, 600 + getRandomFloat(-20, 20))
	addLuaSprite('smoke_one', false)

	setBlendMode('smoke_one', 'ADD')
	setScrollFactor('smoke_one', 1.2, 1.05)
	scaleObject('smoke_one', 1.1, 1.22)
	updateHitbox('smoke_one')
	setProperty('smoke_one.alpha', 0)
	setProperty('smoke_one.velocity.x', getRandomFloat(15, 22))
	setProperty('smoke_one.visible', false)

	makeLuaSprite('smoke_two', 'smoke', 1550 + offsetX, 600 + getRandomFloat(-20, 20))
	addLuaSprite('smoke_two', false)

	setBlendMode('smoke_two', 'ADD')
	setScrollFactor('smoke_two', 1.2, 1.05)
	scaleObject('smoke_two', 1.1, 1.22)
	updateHitbox('smoke_two')
	setProperty('smoke_two.alpha', 0)
	setProperty('smoke_two.flipX', true)
	setProperty('smoke_two.velocity.x', getRandomFloat(-15, -22))
	setProperty('smoke_two.visible', false)
end

function onEvent(eventName, value1, value2, strumTime)
	if eventName == 'Dadbattle Spotlight' then
		local val = math.floor(tonumber(value1))
		if val > 0 then
			if val == 1 then
				setProperty('dadbattleBlack.visible', true)
				setProperty('dadbattleLight.visible', true)
				setProperty('smoke_one.visible', true)
				setProperty('smoke_two.visible', true)

				setProperty('defaultCamZoom', getProperty('defaultCamZoom') + 0.12)
			end

			local who = 'dad'
			if val > 2 then
				who = 'boyfriend'
			end
			setProperty('dadbattleLight.alpha', 0)
			runTimer('dadbattleLightTimer', 0.12)

			setProperty('dadbattleLight.x', getGraphicMidpointX(who) - getProperty('dadbattleLight.width') * 0.5)
			setProperty('dadbattleLight.y', getProperty(who .. '.y') + getProperty(who .. '.height') - getProperty('dadbattleLight.height') + 50)

			doTweenAlpha('dadbattleFogOne_fadeOut', 'smoke_one.alpha', 0.7, 1.5, 'quadInOut')
			doTweenAlpha('dadbattleFogTwo_fadeOut', 'smoke_two.alpha', 0.7, 1.5, 'quadInOut')
		else
			setProperty('dadbattleBlack.visible', false)
			setProperty('dadbattleLight.visible', false)

			setProperty('defaultCamZoom', getProperty('defaultCamZoom') - 0.12)
			doTweenAlpha('dadbattleFogOne_fadeOut', 'smoke_one.alpha', 0, 0.7, 'linear')
			doTweenAlpha('dadbattleFogTwo_fadeOut', 'smoke_two.alpha', 0, 0.7, 'linear')
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'dadbattleLightTimer' then
		setProperty('dadbattleLight.alpha', 0.375)
	end
end

function onTweenCompleted(tag, vars)
	if tag == 'dadbattleFogOne_fadeOut' then
		setProperty('smoke_one.visible', false)
		setProperty('smoke_two.visible', false)
	end
end