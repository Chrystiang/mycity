-- DataHandler, made by Laagaadoo#0000
local DataHandler = {}
do
	DataHandler.VERSION = '1.5'
	DataHandler.__index = DataHandler

	function DataHandler.new(moduleID, skeleton, otherOptions)
		local self = setmetatable({}, DataHandler)
		assert(moduleID, 'Invalid module ID (nil)')
		assert(moduleID ~= '', 'Invalid module ID (empty text)')
		assert(skeleton, 'Invalid skeleton (nil)')

		for k, v in next, skeleton do
			v.type = v.type or type(v.default())
		end

		self.players = {}
		self.moduleID = moduleID
		self.moduleSkeleton = skeleton
		self.moduleIndexes = {}
		self.otherOptions = otherOptions
		self.otherData = {}
		self.originalStuff = {}

		for k, v in next, skeleton do
			self.moduleIndexes[v.index] = k
		end

		if self.otherOptions then
			self.otherModuleIndexes = {}
			for k, v in next, self.otherOptions do
				self.otherModuleIndexes[k] = {}
				for k2, v2 in next, v do
					v2.type = v2.type or type(v2.default())
					self.otherModuleIndexes[k][v2.index] = k2
				end
			end
		end

		return self
	end

	function DataHandler.newPlayer(self, name, dataString)
		assert(name, 'Invalid player name (nil)')
		assert(name ~= '', 'Invalid player name (empty text)')

		self.players[name] = {}
		self.otherData[name] = {}

		dataString = dataString or ''

		-- turns a simple table into a string
		local function turnStringToTable(str)
			local output = {}
			for data in gsub(str, '%b{}', function(b) return b:gsub(',', '\0') end):gmatch('[^,]+') do
				data = data:gsub('%z', ',')

				if string.match(data, '^{.-}$') then
					output[#output+1] = turnStringToTable(string.match(data, '^{(.-)}$'))
				else
					output[#output+1] = tonumber(data) or data
				end
			end
			return output
		end

		-- get the field index
		local function getDataIndexName(skeleton, index)
			for k, v in next, skeleton do
				if v.index == index then
					return k
				end
			end
			return 0
		end

		-- gets the higher index
		local function getHigherIndex(skeleton)
			local higher = 0
			for k, v in next, skeleton do
				if v.index > higher then
					higher = v.index
				end
			end
			return higher
		end

		-- creates the fields in the player's table
		-- loads the other modules' data too
		local function handleModuleData(moduleID, skeleton, moduleData, makeTable)
			local dataIndex = 1
			local higherIndex = getHigherIndex(skeleton)

			moduleID = "__" .. moduleID
			if makeTable then
				self.players[name][moduleID] = {}
			end

			local function setPlayerData(data, dataType, dataName, dataDefault)
				local value
				if dataType == "number" then
					value = tonumber(data) or dataDefault
				elseif dataType == "string" then
					-- unescape double quotes
					value = string.match(data and data:gsub('\\"', '"') or '', "^\"(.-)\"$") or dataDefault
				elseif dataType == "table" then
					value = string.match(data or '', "^{(.-)}$")
					value = value and turnStringToTable(value) or dataDefault
				elseif dataType == "boolean" then
					if data then
						value = data == '1'
					else
						value = dataDefault
					end
				end

				if makeTable then
					self.players[name][moduleID][dataName] = value
				else
					self.players[name][dataName] = value
				end
			end

			if #moduleData > 0 then
				for data in gsub(moduleData, '%b{}', function(b) return b:gsub(',', '\0') end):gmatch('[^,]+') do
				-- for data in gsub(moduleData, '({.*()})', function(b) return b:gsub(',', '\0') end):gmatch('[^,]+') do
					data = data:gsub('%z', ','):gsub('\9', ',')

					-- pega info a respeito do esqueleto
					local dataName = getDataIndexName(skeleton, dataIndex)
					local dataType = skeleton[dataName].type
					local dataDefault = skeleton[dataName].default()

					setPlayerData(data, dataType, dataName, dataDefault)

					dataIndex = dataIndex + 1
				end
			end

			-- fields are missing, will set them to default
			if dataIndex <= higherIndex then
				for i = dataIndex, higherIndex do
					local dataName = getDataIndexName(skeleton, i)
					local dataType = skeleton[dataName].type
					local dataDefault = skeleton[dataName].default()

					setPlayerData(nil, dataType, dataName, dataDefault)
				end
			end
		end

		local modules, originalStuff = self:getModuleData(dataString)
		-- keeps other unrelated stuff
		self.originalStuff[name] = originalStuff

		if not modules[self.moduleID] then
			modules[self.moduleID] = '{}'
		end

		handleModuleData(self.moduleID, self.moduleSkeleton, modules[self.moduleID]:sub(2,-2), false)

		if self.otherOptions then
			-- if the player does not have the other modules' data and we need them
			-- then creates the data using the default values provided
			for moduleID, skeleton in next, self.otherOptions do
				if not modules[moduleID] then
					local strBuilder = {}
					for k, v in next, skeleton do
						local dataType = v.type or type(v.default())
						if dataType == 'string' then
							strBuilder[v.index] = '"'..tostring(v.default():gsub('"', '\\"'))..'"'
						elseif dataType == 'table' then
							strBuilder[v.index] = '{}'
						elseif dataType == 'number' then
							strBuilder[v.index] = v.default()
						elseif dataType == 'boolean' then
							strBuilder[v.index] = v.default() and '1' or '0'
						end
					end
					modules[moduleID] = '{'..table_concat(strBuilder, ',')..'}'
				end
			end
		end

		-- loads the player's data from other modules
		for moduleID, moduleData in next, modules do
			if moduleID ~= self.moduleID then
				if self.otherOptions and self.otherOptions[moduleID] then
					handleModuleData(moduleID, self.otherOptions[moduleID], moduleData:sub(2,-2), true)
				else
					self.otherData[name][moduleID] = moduleData
				end
			end
		end
	end

	function DataHandler.dumpPlayer(self, name)
		-- dumps player data to string
		local output = {}

		-- turns a simple table into a string
		local function turnTableToString(tbl)
			local output = {}
			for k, v in next, tbl do
				local valueType = type(v)
				if valueType == 'table' then
					output[#output+1] = '{'
					output[#output+1] = turnTableToString(v)

					if output[#output]:sub(-1) == ',' then
						output[#output] = output[#output]:sub(1, -2)
					end
					output[#output+1] = '}'
					output[#output+1] = ','
				else
					if valueType == 'string' then
						output[#output+1] = '"'
						output[#output+1] = v:gsub('"', '\\"')
						output[#output+1] = '"'
					elseif valueType == 'boolean' then
						output[#output+1] = v and '1' or '0'
					else
						output[#output+1] = v
					end
					output[#output+1] = ','
				end
			end
			if output[#output] == ',' then
				output[#output] = ''
			end
			return table_concat(output)
		end

		-- returns a module's data in string
		local function getPlayerDataFrom(name, moduleID)
			local output = {moduleID, '=', '{'}
			local player = self.players[name]
			local moduleIndexes = self.moduleIndexes
			local moduleSkeleton = self.moduleSkeleton

			if self.moduleID ~= moduleID then
				moduleIndexes = self.otherModuleIndexes[moduleID]
				moduleSkeleton = self.otherOptions[moduleID]
				moduleID = '__'..moduleID
				player = self.players[name][moduleID]
			end

			if not player then
				return ''
			end

			for i = 1, #moduleIndexes do
				local dataName = moduleIndexes[i]
				local dataType = moduleSkeleton[dataName].type
				if dataType == 'string' then
					-- inserts "string" with escaped double quotes
					output[#output+1] = '"'
					output[#output+1] = player[dataName]:gsub('"', '\\"')
					output[#output+1] = '"'

				elseif dataType == 'number' then
					-- inserts number
					output[#output+1] = player[dataName]

				elseif dataType == 'boolean' then
					output[#output+1] = player[dataName] and '1' or '0'

				elseif dataType == 'table' then
					-- inserts table
					output[#output+1] = '{'
					output[#output+1] = turnTableToString(player[dataName])
					output[#output+1] = '}'
				end

				output[#output+1] = ','
			end

			if output[#output] == ',' then
				output[#output] = '}'
			else
				output[#output+1] = '}'
			end

			return table_concat(output)
		end

		output[#output+1] = getPlayerDataFrom(name, self.moduleID)

		-- builds the output
		if self.otherOptions then
			for k, v in next, self.otherOptions do
				local moduleData = getPlayerDataFrom(name, k)
				if moduleData ~= '' then
					output[#output+1] = ','
					output[#output+1] = moduleData
				end
			end
		end

		for k, v in next, self.otherData[name] do
			output[#output+1] = ','
			output[#output+1] = k
			output[#output+1] = '='
			output[#output+1] = v
		end

		return table_concat(output)..self.originalStuff[name]
	end

	function DataHandler.get(self, name, dataName, moduleName)
		-- returns some player data
		if not moduleName then
			return self.players[name][dataName]
		else
			assert(self.players[name]['__'..moduleName], 'Module data not available ('..moduleName..')')
			return self.players[name]['__'..moduleName][dataName]
		end
	end

	function DataHandler.set(self, name, dataName, value, moduleName)
		-- sets some player data

		if moduleName then
			self.players[name]['__'..moduleName][dataName] = value
		else
			self.players[name][dataName] = value
		end

		return self
	end

	function DataHandler.save(self, name)
		savePlayerData(name, self:dumpPlayer(name))
	end

	-- gets the module data and stores it
	function DataHandler.getModuleData(self, str)
		local output = {}

		for moduleID, moduleData in string.gmatch(str, '([0-9A-Za-z_]+)=(%b{})') do
			local texts = self:getTextBetweenQuotes(moduleData:sub(2,-2))
			for i = 1, #texts do
				texts[i] = texts[i]:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")
				moduleData = moduleData:gsub(texts[i], texts[i]:gsub(',', '\9'))
			end
			output[moduleID] = moduleData
		end

		for k, v in next, output do
			str = str:gsub(k..'='..v:gsub('\9', ','):gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")..',?', '')
		end
		return output, str
	end

	-- get the text between double quotes
	function DataHandler.getTextBetweenQuotes(self, str)
		local output = {}
		local startIndex = 1
		local symbols = 0

		local ignore = false
		for i = 1, #str do
			local char = str:sub(i, i)

			if char == '"' then
				if str:sub(i-1,i-1) ~= '\\' then
					if symbols == 0 then
						startIndex = i
						symbols = symbols + 1
					else
						symbols = symbols - 1
						if symbols == 0 then
							output[#output+1] = str:sub(startIndex, i)
						end
					end
				end
			end
		end
		return output
	end
end