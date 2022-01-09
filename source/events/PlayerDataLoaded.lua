onEvent("PlayerDataLoaded", function(name, data)
	if name and isExploiting[name] then return end
	
	if name == 'Sharpiebot#0000' then
		return syncGameData(data, name)
	end

	if playerFinder.requests[name] then
		playerFinder.requests[name](data)
		playerFinder.requests[name] = nil
		return
	end

	if table_find(room.bannedPlayers, name) then
		return chatMessage('You can not play #mycity anymore.', name)
	end

	if #data > 3000 then 
		return chatMessage('You have reached your data size limit. Please contact Fofinhoppp#0000 for more informations.\nCurrent data size: <vp>'..#data, name) 
	end

	playerData:newPlayer(name, data)
	------- setting data values to players[name]
	local playerLogs = playerData:get(name, 'playerLog')
	local playerSettings = playerData:get(name, 'playerLog')
	players[name].settings.mirroredMode = playerSettings[2][1] or 0
	players[name].settings.disableTrades = playerSettings[2][3] or 0
	players[name].lang = langIDS[playerSettings[2][2]] or 'en'
	players[name].seasonStats[1][1] = playerSettings[1][1] or 0
	players[name].seasonStats[1][2] = playerSettings[1][2] or 0

	players[name].coins = playerData:get(name, 'coins')
	if players[name].coins < 0 then players[name].coins = 0 end
	players[name].bagLimit = playerData:get(name, 'bagStorage')
	players[name].spentCoins = playerData:get(name, 'spentCoins')
	players[name].lifeStats = playerData:get(name, 'lifeStats')
	players[name].receivedCodes = playerData:get(name, 'codes')
	players[name].currentBagIcon = playerData:get(name, 'currentBagIcon')
	
	local houses = playerData:get(name, 'houses')
	for i, v in next, houses do
		players[name].houses[i] = v
	end
	local counter = 0
	local vehicles = playerData:get(name, 'cars')
	for i, v in next, vehicles do
		if mainAssets.__cars[v] and not table_find(players[name].cars, v) then
			players[name].cars[#players[name].cars+1] = v
		end
	end
	players[name].questStep = playerData:get(name, 'quests')
	local item = playerData:get(name, 'bagItem')
	local quanty = playerData:get(name, 'bagQuant')

	players[name].bag = {}
	players[name].totalOfStoredItems.bag = 0

	for i, v in next, item do
		if quanty[i] > 0 then
			addItem(bagIds[v].n, quanty[i], name, 0)
		end
	end

	players[name].houseTerrain = playerData:get(name, 'housesTerrains')
	players[name].houseTerrainAdd = playerData:get(name, 'housesTerrainsAdd')
	players[name].houseTerrainPlants = playerData:get(name, 'housesTerrainsPlants')

	players[name].sideQuests = playerData:get(name, 'sideQuests')
	
	if players[name].sideQuests[8] then
		players[name].sideQuests[8]= players[name].sideQuests[8]:gsub('"', '')
	end
	
	players[name].level = playerData:get(name, 'level')
	local jobStats = playerData:get(name, 'jobStats')
	for i, v in next, jobStats do
		players[name].jobs[i] = v
	end
	players[name].badges = playerData:get(name, 'badges')

	local luckiness = playerData:get(name, 'luckiness')
	local fishingLuckiness = luckiness[1]
	players[name].lucky = {{normal = fishingLuckiness[1], rare = fishingLuckiness[2], mythical = fishingLuckiness[3], legendary = fishingLuckiness[4]}, (type(luckiness[2]) == 'table' and false or luckiness[2])}

	players[name].favoriteCars = playerLogs[4] or players[name].favoriteCars

	local starIcons = playerData:get(name, 'starIcons')
	for i, v in next, starIcons[1] do
		players[name].starIcons.owned[i] = v
	end
	players[name].starIcons.selected = starIcons[2]

	--players[name].timePlayed = playerData:get(name, 'timePlayed')
	
	if not syncVersion(name, playerLogs[3]) then
		chatMessage('Data not loaded: Version error.', name)
		return 
	end

	players[name].dataLoaded = true

	if players[name].questStep[1] <= questsAvailable then
		_QuestControlCenter[players[name].questStep[1]].active(name, players[name].questStep[2])
		if players[name].questLocalData.other.goToIsland and room.event:find('christmas') then
			quest_updateStep(name)
		end
	end

	loadMap(name)
	updateCurrencies(name)
	showCarShop(name)
	sideQuest_update(name, 0)
	HouseSystem.new(name):loadTerrains()
	players[name].blockScreen = false
	for i = 1, 2 do
		showLifeStats(name, i)
	end

	for i, v in next, ROOM.playerList do
		if players[i].roomLog then
			chatMessage('<g>[•][roomLog] '..name..' joined the room.', i)
		end
		local level = players[i].level[1]
		generateLevelImage(i, level, name)
		generateLevelImage(name, players[name].level[1], i)
	end
	job_updatePlayerStats(name, 1, 0)
	if ROOM.playerList['Fofinhoppp#0000'] then
		giveBadge(name, 1)
	end

	local icons = {
		{
			image = "17da6308116.png",
			onClick = function()
				openBag(name)
			end
		},
		{
			image = "17da6310177.png",
			onClick = function()
				openQuests(name)
			end
		},
		{
			image = "17da630001b.png",
			onClick = function()
				modernUI.new(name, 520, 300, translate('vehicles', name))
				:addButton('1729f83fb5f.png', function()
					modernUI.new(name, 240, 180, translate('confirmButton_tip', name), translate('tip_vehicle', name), 'errorUI')
					:build()
				end)
				--[[:addButton('1787e8f568f.png', function()
					modernUI.new(name, 240, 180, translate('confirmButton_customizeVehicle', name), '', 'errorUI')
					:build()
				end)]]
				:build()
				:showPlayerVehicles()
			end
		},
		{
			image = "17da62f9e1e.png",
			onClick = function()
				if not checkLocation_isInHouse(name) then return end
				modernUI.new(name, 240, 120, translate('houseSettings', name))
					:build()
					:showHouseSettings()
			end
		}
	}

	local tot = 44 * #icons
	for id, data in next, icons do
		local i = id-1
		local posX = 400 - tot/2 + i*44
		addImage(data.image, ":3", posX, 365, name)
		showTextArea(999970+i, "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', 4), name, posX, 365, 35, 35, 1, 1, 0, true, data.onClick)
	end

	addImage("17b349cc328.png", ":1", 650, 20, name)
	loadBackpackIcon(name)
end)