local fileUtil = {}

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

---The most recent file used regardless of context
fileUtil.mostRecentFileUsed = ''

---The most recent file read from
fileUtil.mostRecentFileReadFrom = ''

---The most recent file written to
fileUtil.mostRecentFileWrittenTo = ''

---The version of fileUtil
fileUtil.Version = '1.0.1'

---Returns true if the file at `path` exists; else false
---@param path string
---@param startFromCurrentModDirectory boolean
---@return boolean
function fileUtil.doesFileExists(path, startFromCurrentModDirectory)
	if type(path) ~= 'string' then
		debugPrint('Expected string for path, got ' .. type(path) .. '.')
		return false -- use only strings for path
	elseif type(startFromCurrentModDirectory) ~= 'boolean' then
		debugPrint('Expected boolean for startFromCurrentModDirectory, got ' .. type(startFromCurrentModDirectory) .. '.')
		return false -- use only booleans for startFromCurrentModDirectory
	end

	if startFromCurrentModDirectory then
		-- begin from currentModDirectory
		path = currentModDirectory .. '/' .. path
	end

	if checkFileExists(path, not startFromCurrentModDirectory) then
		-- file exists
		fileUtil.mostRecentFileUsed = path
		return true
	end

	-- file doesn't exist
	return false
end

---Returns the contents of a list file as a table
---
---If the file at `path` cannot be found, it'll return an empty table.
---
---Refer to `characterList.txt`, `stageList.txt`, or `weekList.txt` for formatting of list files
---@param path string
---@param startFromCurrentModDirectory boolean
---@return table
function fileUtil.readListFile(path, startFromCurrentModDirectory)
	if type(path) ~= 'string' then
		debugPrint('Expected string for path, got ' .. type(path) .. '.')
		return {} -- use only strings for path
	elseif type(startFromCurrentModDirectory) ~= 'boolean' then
		debugPrint('Expected boolean for startFromCurrentModDirectory, got ' .. type(startFromCurrentModDirectory) .. '.')
		return {} -- use only booleans for startFromCurrentModDirectory
	end

	if not path:match('.txt', path:len() - 3) then
		-- user forgot to put .txt in the filename
		path = path .. '.txt'
	end

	if not fileUtil.doesFileExists(path, startFromCurrentModDirectory) then
		debugPrint('\'' .. path .. '\' does not exist.')
		return {} -- file does not exist
	end

	-- get text from file
	local file = getTextFromFile(fileUtil.mostRecentFileUsed, not startFromCurrentModDirectory)
	fileUtil.mostRecentFileReadFrom = fileUtil.mostRecentFileUsed

	local contentsOfFile = {}
	local returnLineOfContent = {0, 0}
	local startOfTableElement = 1

	while startOfTableElement < #file do
		-- return a line of content
		returnLineOfContent = ({ file:find('\n', startOfTableElement) })
		if returnLineOfContent[1] == nil then
			returnLineOfContent[1] = #file + 1
		end

		-- insert into contentsOfFile
		table.insert(contentsOfFile, file:sub(startOfTableElement, tonumber(returnLineOfContent[1]) - 1))
		startOfTableElement = tonumber(returnLineOfContent[1]) + 1
	end

	-- return table
	return contentsOfFile
end

---Writes to a list file using a table
---
---Any table elements that are not of type `number` or `string` will be skipped.
---If the file at `path` is an existing file, it'll be overwritten.
---If `startFromCurrentModDirectory` is false, then the `path` will start in the base folder where the .exe is located
---
---If `tableToInsert` is empty, this function does nothing
---@param path string
---@param tableToInsert table
---@param startFromCurrentModDirectory boolean
function fileUtil.writeListFile(path, tableToInsert, startFromCurrentModDirectory)
	if type(path) ~= 'string' then
		debugPrint('Expected string for path, got ' .. type(path) .. '.')
		return {} -- use only strings for path
	elseif type(tableToInsert) ~= 'table' then
		debugPrint('Expected boolean for tableToInsert, got ' .. type(tableToInsert) .. '.')
		return {} -- use only tables for tableToInsert
	elseif type(startFromCurrentModDirectory) ~= 'boolean' then
		debugPrint('Expected boolean for startFromCurrentModDirectory, got ' .. type(startFromCurrentModDirectory) .. '.')
		return {} -- use only booleans for startFromCurrentModDirectory
	end

	if #tableToInsert < 1 then
		debugPrint('tableToInsert is empty.')
		return -- tableToInsert is empty
	end

	if not stringEndsWith(path, '.txt') then
		path = path .. '.txt'
	end

	if not checkFileExists(path, startFromCurrentModDirectory) then
		if startFromCurrentModDirectory then
			path = currentModDirectory .. '/' .. path
		end
		debugPrint('\'' .. path .. '\' does not exist.')
		return -- file does not exist
	end

	local fileContent = ''
	if startFromCurrentModDirectory then
		fileUtil.mostRecentFileWrittenTo = currentModDirectory .. '/' .. path
	else
		fileUtil.mostRecentFileWrittenTo = path
	end

	local tableElement = nil
	for i = 1, #tableToInsert do
		tableElement = tableToInsert[i]
		if type(tableElement) == 'number' or type(tableElement) == 'string' then
			fileContent = fileContent .. tostring(tableElement) .. '\n'
		end
	end
	saveFile(fileUtil.mostRecentFileWrittenTo, fileContent, not startFromCurrentModDirectory)
end

---Returns one line of content from a file as a string
---
---If `linePosition` isn't specified, then this function will return a random line of content
---
---Returns `nil` if no file is found or if the file doesn't contain content
---@param path string
---@param startFromModDirectory boolean
---@param linePosition? integer
---@return string
---@return nil
function fileUtil.returnLineFromFile(path, startFromCurrentModDirectory, linePosition)
	local listOfContent = fileUtil.readListFile(path, startFromCurrentModDirectory)
	if listOfContent == nil or #listOfContent == 0 then
		return nil
	end

	if linePosition == nil or linePosition < 1 then
		return tostring(listOfContent[getRandomInt(1, #listOfContent)])
	end
	return tostring(listOfContent[linePosition])
end

return fileUtil