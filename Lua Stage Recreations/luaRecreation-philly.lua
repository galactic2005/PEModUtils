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

local phillyLightColors = {0x31A2FD, 0x31FD8C, 0xFB33F5, 0xFD4531, 0xFBA633}

-- train variables
local moving = false
local finishing = false
local startedMoving = false
local frameTiming = 0

local cars = 8
local cooldown = 0

function onCreate()
	if not lowQuality then
		makeLuaSprite('bg', 'philly/sky', -100, 0)
		addLuaSprite('bg', false)

		setScrollFactor('bg', 0.1, 0.1)
	end

	makeLuaSprite('city', 'philly/city', -10, 0)
	addLuaSprite('city', false)

	scaleObject('city', 0.85, 1)
	updateHitbox('city')
	setScrollFactor('city', 0.3, 0.3)

	makeLuaSprite('phillyWindow', 'philly/window', -10, 0)
	addLuaSprite('phillyWindow', false)

	scaleObject('phillyWindow', 0.85, 1)
	updateHitbox('phillyWindow')
	setScrollFactor('phillyWindow', 0.3, 0.3)
	setProperty('phillyWindow.alpha', 0)

	if not lowQuality then
		makeLuaSprite('streetBehind', 'philly/behindTrain', -40, 50)
		addLuaSprite('streetBehind', false)
	end

	makeLuaSprite('phillyTrain', 'philly/train', 2000, 360)
	addLuaSprite('phillyTrain', false)

	makeLuaSprite('phillyStreet', 'philly/street', -40, 50)
	addLuaSprite('phillyStreet', false)
end

function onUpdate(elapsed)
	if moving then
		frameTiming = frameTiming + elapsed
		if frameTiming >= 1 / 24 then
			frameTiming = 0
		end
	end

	setProperty('phillyWindow.alpha', getProperty('phillyWindow.alpha') - ((crochet / 1000) * elapsed * 1.5))
end

function updateTrainPos()
	if getSoundTime('trainSound') > 4700 then
		startedMoving = true
		playAnim('gf', 'hairBlow', true)
		setProperty('gf.specialAnim', true)
	end

	if startedMoving then
		setProperty('phillyTrain.x', getProperty('phillyTrain.x') - 400)

		if getProperty('phillyTrain.x') < -2000 and not finishing then
			setProperty('phillyTrain.x', -1150)
			cars = cars - 1

			if cars <= 0 then
				finishing = true
			end
		end

		if getProperty('philllyTrain.x') < -4000 and finishing then
			trainReset()
		end
	end
end

function trainReset()
	setProperty('gf.danced', false)
	playAnim('gf', 'hairFall', true)
	setProperty('gf.specialAnim', true)

	setProperty('phillyTrain.x', screenWidth + 200)
	moving = false
	cars = 8
	finishing = false
	startedMoving = false
end

function onBeatHit()
	if curBeat % 4 == 0 then
		curLight = math.random(1, #phillyLightColors)
		setProperty('phillyWindow.color', phillyLightColors[curLight])
		setProperty('phillyWindow.alpha', 1)
	end

	-- extra code so you can hide the train mid-song
	local isTrainActive = (luaSpriteExists('phillyTrain') and getProperty('phillyTrain.visible') == true)

	if isTrainActive and not moving then
		cooldown = cooldown + 1
	end

	if isTrainActive then
		if curBeat % 8 == 4 and getRandomInt(0, 30) == 30 and cooldown > 8 and not moving then
			cooldown = math.random(-4,0)

			trainStart()
		end
	end
end

function trainStart()
	moving = true
	playSound('train_passes', 1, 'trainSound')
end

function onPause()
	pauseSound('trainSound')

	return Function_Continue;
end

function onResume()
	resumeSound('trainSound')
end