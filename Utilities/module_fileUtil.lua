local fileUtil = {}

---The most recent file used regardless of context
fileUtil.mostRecentFileUsed = ''

---The most recent file read from
fileUtil.mostRecentFileReadFrom = ''

---The most recent file written to
fileUtil.mostRecentFileWrittenTo = ''

---The version of fileUtil
fileUtil.Version = '1.0.0'

---Returns true if the file at `path` exists; else false
---@param path string
---@param startFromCurrentModDirectory boolean
---@return boolean
function fileUtil.doesFileExists(path, startFromCurrentModDirectory)
	if startFromCurrentModDirectory == true then
		path = currentModDirectory .. '/' .. path
	end

	local file = getTextFromFile(path, startFromCurrentModDirectory)
	if getTextFromFile(path, not startFromCurrentModDirectory) ~= nil then
		fileUtil.mostRecentFileUsed = path
		return true
	end
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
	if not path:match('.txt', path:len() - 3) then
		path = path .. '.txt'
	end

	if path == '' or not fileUtil.doesFileExists(path, startFromCurrentModDirectory) then
		return {}
	end

	local file = getTextFromFile(fileUtil.mostRecentFileUsed, not startFromCurrentModDirectory)
	local returnLineOfContent = {}
	local contentsOfFile = {}
	local startOfTableElement = 1
	fileUtil.mostRecentFileReadFrom = fileUtil.mostRecentFileUsed

	while startOfTableElement < #file do
		returnLineOfContent = ({ file:find('\n', startOfTableElement) })
		if returnLineOfContent[1] == nil then
			returnLineOfContent[1] = #file + 1
		end
		table.insert(contentsOfFile, file:sub(startOfTableElement, tonumber(returnLineOfContent[1]) - 1))
		startOfTableElement = tonumber(returnLineOfContent[1]) + 1
	end
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
	local tableElement = nil
	if startFromCurrentModDirectory then
		fileUtil.mostRecentFileWrittenTo = currentModDirectory .. '/' .. path
	else
		fileUtil.mostRecentFileWrittenTo = path
	end

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