onEvent("PlayerDataLoaded", function(name, data)
	if name == 'Sharpiebot#0000' then 
		return syncGameData(data, name)
	end
	if table.contains(room.perban, name) then
		return TFM.chatMessage('You can not play #mycity anymore.', name)
	end
	if #data > 1500 then return TFM.chatMessage('You have reached your data limit. Please contact Fofinhoppp#0000 for more info.', name) end
    playerData:newPlayer(name, data)
	------- setting data values to players[name]
	local playerSettings = playerData:get(name, 'playerLog')
	players[name].settings.mirroredMode = playerSettings[2][1] or 0
	players[name].lang = langIDS[playerSettings[2][2]] or 'en'
	players[name].seasonStats[1][2] = playerSettings[1][2] or 0

	players[name].coins = playerData:get(name, 'coins')
	if players[name].coins < 0 then players[name].coins = 0 end
	players[name].bagLimit = playerData:get(name, 'bagStorage')
	players[name].spentCoins = playerData:get(name, 'spentCoins')
	players[name].lifeStats = playerData:get(name, 'lifeStats')
	players[name].receivedCodes = playerData:get(name, 'codes')
	local houses = playerData:get(name, 'houses')
	for i, v in next, houses do
		players[name].casas[i] = v
	end
	local counter = 0
	local vehicles = playerData:get(name, 'cars')
	for i, v in next, vehicles do
		if mainAssets.__cars[v] and not table.contains(players[name].cars, v) then 
			players[name].cars[#players[name].cars+1] = v
		end 
	end 
	players[name].questStep = playerData:get(name, 'quests')
	local item = playerData:get(name, 'bagItem')
	local quanty = playerData:get(name, 'bagQuant')

	players[name].bag = {}
	players[name].totalOfStoredItems.bag = 0
	players[name].houseData.chests.storage = {{}, {}}
	players[name].totalOfStoredItems.chest[1] = 0
	players[name].totalOfStoredItems.chest[2] = 0

	for i, v in next, item do
		if quanty[i] > 0 then
			addItem(bagIds[v].n, quanty[i], name, 0)
		end
	end

	players[name].houseTerrain = playerData:get(name, 'housesTerrains')
	players[name].houseTerrainAdd = playerData:get(name, 'housesTerrainsAdd')
	players[name].houseTerrainPlants = playerData:get(name, 'housesTerrainsPlants')

	----------------------------- FURNITURES -----------------------------
	players[name].houseData.furnitures.placed = {}
	players[name].houseData.furnitures.stored = {}
	local furnitures, storedFurnitures = playerData:get(name, 'houseObjects'), playerData:get(name, 'storedFurnitures')
	do
		local function storeFurniture(v)
			if not players[name].houseData.furnitures.stored[v] then 
				players[name].houseData.furnitures.stored[v] = {quanty = 1, type = v}
			else
				players[name].houseData.furnitures.stored[v].quanty = players[name].houseData.furnitures.stored[v].quanty + 1
			end
		end

		for i, v in next, furnitures do
			if v[2] > -50 and v[2] < 1550 then
				players[name].houseData.furnitures.placed[i] = {type = v[1], x = v[2], y = v[3]}
			else
				TFM.chatMessage('<g>Due to an invalid location, a furniture has been moved to your furniture depot.', name)
				storeFurniture(i)
			end
		end
		for i, v in next, storedFurnitures do
			storeFurniture(v)
		end
	end
	----------------------------------------------------------------------

	players[name].sideQuests = playerData:get(name, 'sideQuests')
	players[name].level = playerData:get(name, 'level')
	local jobStats = playerData:get(name, 'jobStats')
	for i, v in next, jobStats do 
		players[name].jobs[i] = v
	end
	players[name].badges = playerData:get(name, 'badges')

	local luckiness = playerData:get(name, 'luckiness')
	local fishingLuckiness = luckiness[1]
	players[name].lucky = {{normal = fishingLuckiness[1], rare = fishingLuckiness[2], mythical = fishingLuckiness[3], legendary = fishingLuckiness[4]}}

	local playerLogs = playerData:get(name, 'playerLog')
	players[name].favoriteCars = playerLogs[4] or players[name].favoriteCars
	players[name].dataLoaded = true

	syncVersion(name, playerLogs[3])
	if players[name].questStep[1] <= questsAvailable then
		_QuestControlCenter[players[name].questStep[1]].active(name, players[name].questStep[2])
	end

	loadMap(name)
	showOptions(name)
	showCarShop(name)
	sideQuest_update(name, 0)
	HouseSystem.new(name):loadTerrains()
	players[name].blockScreen = false
	for i = 1, 2 do
		showLifeStats(name, i)
	end

	for i, v in next, ROOM.playerList do
		if players[i].roomLog then
			TFM.chatMessage('<g>[•][roomLog] '..name..' joined the room.', i)
		end
		local level = players[i].level[1]
		generateLevelImage(i, level, name)
		generateLevelImage(name, players[name].level[1], i)
	end
	job_updatePlayerStats(name, 1, 0)
	if ROOM.playerList['Fofinhoppp#0000'] then
		giveBadge(name, 1)
	end
	addImage("170fa1a5400.png", ":1", 348, 355, name)
end)