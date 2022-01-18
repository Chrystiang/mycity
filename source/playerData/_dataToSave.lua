savedata = function(name, forceSave)
	local playerInfos = players[name]
	if not playerInfos.dataLoaded then return end

	--[[if true then
		chatMessage('<R>Stats are not being saved in this room.', name)
		return
	end]]
	if ROOM.name ~= '*#mytest' then
		if ROOM.uniquePlayers < room.requiredPlayers then
			chatMessage('<R>Stats are not saved if the room have less than '..room.requiredPlayers..' players.', name)
			return
		elseif ROOM.passwordProtected then
			chatMessage('<R>Stats are not saved if the room is protected with a password.', name)
			return
		elseif ROOM.isTribeHouse or ROOM.name:find('\3') then
			chatMessage('<R>Stats are not saved in tribe house.', name)
			return
		end
	end

	playerData:set(name, 'coins', playerInfos.coins)
	playerData:set(name, 'spentCoins', playerInfos.spentCoins)
	playerData:set(name, 'bagStorage', playerInfos.bagLimit)
	playerData:set(name, 'currentBagIcon', playerInfos.currentBagIcon)

	local lifeStats = {}

	for i = 1, 2 do
		lifeStats[#lifeStats+1] = playerInfos.lifeStats[i]
 	end
 	playerData:set(name, 'lifeStats', lifeStats)

	local houses = playerData:get(name, 'houses')
	for i, v in next, playerInfos.houses do
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

	local chestStorage = {{}, {}, {}, {}}
	local chestStorageQuanty = {{}, {}, {}, {}}
	for counter = 1, 4 do
		for i, v in next, playerInfos.houseData.chests.storage[counter] do
			chestStorage[counter][i] = bagItems[v.name].id
			chestStorageQuanty[counter][i] = v.qt
		end
	end
	playerData:set(name, 'chestStorage', chestStorage)
	playerData:set(name, 'chestStorageQuanty', chestStorageQuanty)

	----------------------------- FURNITURES -----------------------------
	local houseSaves = {}
	local storedFurnitures = {}

	for saveId, data in next, playerInfos.houseData.furnitures.placed do
		houseSaves[saveId] = {}
		local furnitureCounter = 0

		for id, furnitureData in next, data do
			furnitureCounter = furnitureCounter + 1
			if furnitureCounter > maxPlacedFurnitures then break end

			houseSaves[saveId][id] = {furnitureData.type * (furnitureData.mirrored and -1 or 1), furnitureData.x, furnitureData.y}
		end
	end

	playerData:set(name, 'houseSaves', houseSaves)

	-- Save all furnitures bought
	for _, v in next, playerInfos.houseData.furnitures.stored do
		-- If the furniture amount is greater than 1, save it in a table, with the id and the amount
		if v.quanty > 1 then
			storedFurnitures[#storedFurnitures+1] = {v.type, v.quanty}

		-- If is equal to 1, save it using it's id
		----> Since we know there is only one of them, we will use less characters to save!
		elseif v.quanty == 1 then
			storedFurnitures[#storedFurnitures+1] = v.type
		end
	end

	playerData:set(name, 'storedFurnitures', storedFurnitures)
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
	playerLogs[2][3] = playerInfos.settings.disableTrades
	for id, v in next, langIDS do 
		if v == playerInfos.lang then
			playerLogs[2][2] = id
			break
		end 
	end
	playerData:set(name, 'playerLog', playerLogs)
	playerData:set(name, 'timePlayed', playerInfos.timePlayed)

	local starIcons = playerData:get(name, 'starIcons')
	for i, v in next, playerInfos.starIcons.owned do
		starIcons[1][i] = v
	end
	starIcons[2] = playerInfos.starIcons.selected

	playerData:save(name)
end