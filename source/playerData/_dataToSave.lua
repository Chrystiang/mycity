savedata = function(name)
	local playerInfos = players[name]
	if not playerInfos.dataLoaded then return end
	if ROOM.name ~= '*#fofinho' and ROOM.name ~= '*#fofinho1' then
		if string.find(ROOM.name:sub(1,1), '*') then
			TFM.chatMessage('<R>Stats are not saved in rooms with "*".', name)
			return
		elseif ROOM.uniquePlayers < room.requiredPlayers then
			TFM.chatMessage('<R>Stats are not saved if the room have less than 6 players.', name)
			return
		elseif ROOM.passwordProtected then
			TFM.chatMessage('<R>Stats are not saved if the room is protected with a password.', name)
			return
		elseif not table.contains(mainAssets.supportedCommunity, ROOM.community) then
			TFM.chatMessage('<R>Data save is not available in this community.', name)
			return
		end
	else
		--return TFM.chatMessage('ops! failed to save your data.', name)
	end
	playerData:set(name, 'coins', playerInfos.coins)
	playerData:set(name, 'spentCoins', playerInfos.spentCoins)
	playerData:set(name, 'bagStorage', playerInfos.bagLimit)
	local lifeStats = {}

	for i = 1, 2 do
		lifeStats[#lifeStats+1] = playerInfos.lifeStats[i]
 	end
 	playerData:set(name, 'lifeStats', lifeStats)

	local houses = playerData:get(name, 'houses')
	for i, v in next, playerInfos.casas do
		houses[i] = v
	end

	local housesTerrains = playerData:get(name, 'housesTerrains')
	for i, v in next, playerInfos.houseTerrain do
		housesTerrains[i] = v
	end

	local housesTerrainsAdd = playerData:get(name, 'housesTerrainsAdd')
	for i, v in next, playerInfos.houseTerrainAdd do
		housesTerrainsAdd[i] = v
	end

	local housesTerrainsPlants = playerData:get(name, 'housesTerrainsPlants')
	for i, v in next, playerInfos.houseTerrainPlants do
		housesTerrainsPlants[i] = v
	end

	local vehicles = playerData:get(name, 'cars')
	for i, v in next, playerInfos.cars do
		vehicles[i] = v
	end

	local quest = playerData:get(name, 'quests')
	for i, v in next, playerInfos.questStep do
		quest[i] = v
	end

	local item = {}
	local quanty = {}
	local amount = 0
	for i, v in next, playerInfos.bag do
		if amount > playerInfos.bagLimit then break end
		if v.qt > 0 then
			amount = amount + v.qt
			item[#item+1] = bagItems[v.name].id
			quanty[#quanty+1] = v.qt
		end
	end
	playerData:set(name, 'bagItem', item)
	playerData:set(name, 'bagQuant', quanty)

	local chestStorage = {{}, {}}
	local chestStorageQuanty = {{}, {}}
	for counter = 1, 2 do
		for i, v in next, playerInfos.houseData.chests.storage[counter] do
			chestStorage[counter][i] = bagItems[v.name].id
			chestStorageQuanty[counter][i] = v.qt
		end
	end
	playerData:set(name, 'chestStorage', chestStorage)
	playerData:set(name, 'chestStorageQuanty', chestStorageQuanty)

	----------------------------- FURNITURES -----------------------------
	local furnitures, furnitureCounter, storedFurnitures = {}, 0, {}
	do 
		for _, v in next, playerInfos.houseData.furnitures.placed do
			furnitureCounter = furnitureCounter + 1
			if furnitureCounter > maxFurnitureStorage then break end
			furnitures[#furnitures+1] = {v.type, v.x, v.y}
		end
		playerData:set(name, 'houseObjects', furnitures)

		for _, v in next, playerInfos.houseData.furnitures.stored do
			for i = 1, v.quanty do 
				storedFurnitures[#storedFurnitures+1] = v.type
			end
		end
		playerData:set(name, 'storedFurnitures', storedFurnitures)
	end
	----------------------------------------------------------------------

	local code = playerData:get(name, 'codes')
	for i, v in next, playerInfos.receivedCodes do
		code[i] = v
	end
	local sidequest = playerData:get(name, 'sideQuests')
	for i, v in next, playerInfos.sideQuests do
		sidequest[i] = v
	end
	local levelStats = playerData:get(name, 'level')
	for i, v in next, playerInfos.level do
		levelStats[i] = v
	end
	local jobStats = playerData:get(name, 'jobStats')
	for i, v in next, playerInfos.jobs do
		jobStats[i] = v
	end
	local bdg = playerData:get(name, 'badges')
	for i, v in next, playerInfos.badges do
		bdg[i] = v
	end
	local newLuckiness = {{}, {}}
	local fishingRarity = {'normal', 'rare', 'mythical', 'legendary'}
	for i = 1, 4 do
		newLuckiness[1][#newLuckiness[1]+1] = playerInfos.lucky[1][fishingRarity[i]] 
	end

	playerData:set(name, 'luckiness', newLuckiness)

	local playerLogs = {{mainAssets.season, playerInfos.seasonStats[1][2]}, {}, version, playerInfos.favoriteCars}

	playerLogs[2][1] = playerInfos.settings.mirroredMode
	for id, v in next, langIDS do 
		if v == playerInfos.lang then
			playerLogs[2][2] = id
			break
		end 
	end
	playerData:set(name, 'playerLog', playerLogs)

	local starIcons = playerData:get(name, 'starIcons')
	for i, v in next, playerInfos.starIcons.owned do
		starIcons[1][i] = v
	end
	starIcons[2] = playerInfos.starIcons.selected

	playerData:save(name)
end