local fileutil = {}

fileutil._VERSION = '3.0.0'

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

---The most recent file used regardless of context
fileutil.mostRecentFileUsed = ''

---The most recent file read from
fileutil.mostRecentFileReadFrom = ''

---The most recent file written to
fileutil.mostRecentFileWrittenTo = ''

---Returns the contents of a list file as a table
---
---Refer to `characterList.txt`, `stageList.txt`, or `weekList.txt` for formatting of list files
---@param path string
---@param startFromCurrentModDirectory boolean
---@return table
function fileutil.readListFile(path, startFromCurrentModDirectory)
	assert(type(path) == 'string', 'Expected string for path, got ' .. type(path) .. '.') -- use only strings for path
	assert(type(startFromCurrentModDirectory) == 'boolean', 'Expected boolean for startFromCurrentModDirectory, got ' .. type(startFromCurrentModDirectory) .. '.') -- use only booleans for startFromCurrentModDirectory

	if not path:match('.txt', path:len() - 3) then
		-- user forgot to put .txt in the filename
		path = path .. '.txt'
	end
	assert(checkFileExists(path, startFromCurrentModDirectory), 'File at ' .. path .. ' does not exist.') -- file does not exist

	-- get text from file
	local file = getTextFromFile(fileutil.mostRecentFileUsed, not startFromCurrentModDirectory)
	fileutil.mostRecentFileReadFrom = fileutil.mostRecentFileUsed

	local contentsOfFile = {}
	local returnLineOfContent = {0, 0}
	local startOfTableElement = 1

	while startOfTableElement < #file do
		-- return a line of content
		returnLineOfContent = ({ file:find('\n', startOfTableElement) })
		if not returnLineOfContent[1] then
			returnLineOfContent[1] = #file + 1
		end

		-- insert into contentsOfFile
		contentsOfFile[#contentsOfFile+1] = file:sub(startOfTableElement, tonumber(returnLineOfContent[1]) - 1)
		startOfTableElement = tonumber(returnLineOfContent[1]) + 1
	end

	-- return table
	return contentsOfFile
end

---Writes a list file using a table
---
---Any table elements in `tableToInsert` that are not a `number` or `string` will be skipped from being written.
---If the file at `path` is an existing file, it'll be overwritten.
---@param path string
---@param tableToInsert table
---@param startFromCurrentModDirectory boolean
function fileutil.writeListFile(path, tableToInsert, startFromCurrentModDirectory)
	-- type asserts
	assert(type(path) == 'string', 'Expected string for path, got ' .. type(path) .. '.') -- use only strings for path
	assert(type(tableToInsert) == 'table', 'Expected table for tableToInsert, got ' .. type(tableToInsert) .. '.')-- use only tables for tableToInsert
	assert(type(startFromCurrentModDirectory) == 'boolean', 'Expected boolean for startFromCurrentModDirectory, got ' .. type(startFromCurrentModDirectory) .. '.') -- use only booleans for startFromCurrentModDirectory
	
	-- table length assert
	assert(#tableToInsert > 0, 'tableToInsert is empty.') --- tableToInsert is empty

	if not stringEndsWith(path, '.txt') then
		path = path .. '.txt'
	end

	assert(checkFileExists(path, startFromCurrentModDirectory), 'File at ' .. path .. ' does not exist.') -- file does not exist

	local fileContent = ''
	if startFromCurrentModDirectory then
		fileutil.mostRecentFileWrittenTo = currentModDirectory .. '/' .. path
	else
		fileutil.mostRecentFileWrittenTo = path
	end

	local tableElement = nil
	for i = 1, #tableToInsert do
		tableElement = tableToInsert[i]
		if type(tableElement) == 'number' or type(tableElement) == 'string' then
			fileContent = fileContent .. tostring(tableElement) .. '\n'
		end
	end
	saveFile(fileutil.mostRecentFileWrittenTo, fileContent, not startFromCurrentModDirectory)
end

---Reads one line of content from a file as a string; or `nil` if no file is found or if the file doesn't contain content.
---
---If `linePosition` isn't specified, then this function will return a random line of content.
---@param path string
---@param startFromModDirectory boolean
---@param linePosition? integer
---@return string
---@return nil
function fileutil.readLineFromFile(path, startFromCurrentModDirectory, linePosition)
	-- type asserts
	assert(type(path) == 'string', 'Expected string for path, got ' .. type(path) .. '.') -- use only strings for path
	assert(type(startFromCurrentModDirectory) == 'boolean', 'Expected boolean for startFromCurrentModDirectory, got ' .. type(startFromCurrentModDirectory) .. '.') -- use only booleans for startFromCurrentModDirectory

	local listOfContent = fileutil.readListFile(path, startFromCurrentModDirectory)
	if (not listOfContent) or #listOfContent < 1 then
		return nil
	end

	if (not linePosition) or linePosition < 1 then
		return tostring(listOfContent[getRandomInt(1, #listOfContent)])
	end
	return tostring(listOfContent[linePosition])
end

return fileutil