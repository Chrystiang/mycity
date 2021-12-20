startRoom = function()
	players = {}
	for name in next, ROOM.playerList do 
		eventNewPlayer(name)
	end
	if not room.isInLobby then
		room.terrains = {}
		room.houseImgs = {}
		room.gameLoadedTimes = room.gameLoadedTimes + 1
		
		for i = 1, #mainAssets.__terrainsPositions do
			room.terrains[i] = {img = {}, bought = false, owner = nil, settings = {}, groundsLoadedTo = {}, guests = {}}
			room.houseImgs[i] = {img = {}, furnitures = {}, expansions = {}}
		end
		room.started = true

		eventNewPlayer('Oliver')
		eventNewPlayer('Remi')

		removeTimer(room.temporaryTimer)
		if room.gameLoadedTimes == 1 then 
			for i = 1, 2 do 
				gameNpcs.setOrder(table_randomKey(gameNpcs.orders.canOrder))
			end

			addTimer(function()
				for player in next, ROOM.playerList do
					--players[player].timePlayed = players[player].timePlayed + 1/60/60
					updateBarLife(player)
					TFM.snow(1000, 10)
				end
			end, 60000, 0)

			local totalOfSpawnedGifts = 0
			addTimer(function()
				if room.isInLobby then return end
				local giftPosition = random(1, #room.giftsPositions)
				local giftsLeft = 3
				local giftId = 1000 + totalOfSpawnedGifts

				local allImages = {}
				local playerImages = {}

				giftPosition = room.giftsPositions[giftPosition]
				TouchSensor.add(
					0,
					giftPosition.x,
					giftPosition.y-20,
					giftId,
					0,
					false,
					0,
					function(player)
						if giftsLeft > 0 then
							giftsLeft = giftsLeft - 1

							modernUI.new(player, 120, 120)
							:build()
							players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(bagItems['goldenPresent'].png, ":70", 400 - 50 * 0.5, 180, player)

							addItem('goldenPresent', 1, player)
							job_updatePlayerStats(player, 21, 1)

							removeImage(playerImages[player])
							if giftsLeft == 0 then
								TouchSensor.remove(giftId)
								removeGroupImages(allImages)
							end
						end
					end,
					false
				)
				for player in next, ROOM.playerList do
					local _img = addImage('17dd48d1819.png', "!10", giftPosition.x-15, giftPosition.y-15-20, player)

					allImages[#allImages+1] = _img
					playerImages[player] = _img

					TouchSensor.add(
						0,
						giftPosition.x,
						giftPosition.y-20,
						giftId,
						0,
						false,
						player
					)
				end
				totalOfSpawnedGifts = totalOfSpawnedGifts + 1
			end, 10 * 60 * 1000, 0)
		end
	end
end

genDaveOffers = function()
	daveOffers = {}
	local i = 1
	while #daveOffers < 5 do
		randomseed(room.mathSeed * i^2)
		local offerID = random(1, #mainAssets.__farmOffers)
		local nextItem = mainAssets.__farmOffers[offerID].item[1]
		local alreadySelling = false
		for id, offer in next, daveOffers do
			local item = mainAssets.__farmOffers[offer].item[1]
			if item == nextItem then
				alreadySelling = true
			end
		end
		if not alreadySelling then
			daveOffers[#daveOffers+1] = offerID
		end
		i = i + 1
	end
end

for id, data in next, mainAssets.__cars do
	if data.type == 'car' then
		local width = data.size[1]
		local leftWheel  = width - data.wheels[2][1] - data.wheelsSize[2]
		local rightWheel = width - data.wheels[1][1] - data.wheelsSize[1]
		data.wheels = {data.wheels, {{leftWheel, data.wheels[2][2]}, {rightWheel, data.wheels[1][2]}}}
	end
end

for i, v in next, recipes do
	if v.require then
		newFoodValue(i)
		newEnergyValue(i)
		newDishPrice(i)
	end
end

for i, v in next, HouseSystem.plants do
	if bagItems[v.name] then
		bagItems[v.name].sellingPrice = bagItems[v.name].sellingPrice or v.pricePerSeed/10
		bagItems[v.name].isFruit = true
	end
end

npcsStores.items = mergeItemsWithFurnitures(mainAssets.__furnitures, bagIds)
buildNpcsShopItems()
genDaveOffers()

for item, data in next, Mine.ores do 
	bagItems['crystal_'..item].price = floor(200*(12/data.rarity))
	bagItems['crystal_'..item].sellingPrice = floor(200*(12/data.rarity))
end
mine_generate()

for place, data in next, places do
	local placeToGo
	local placeToGoPosition
	for property, v in next, data do
		if property:find('tp_') then
			placeToGo = property:gsub('tp_', '')
			placeToGoPosition = v
			break
		end
	end

	if data.exitSensor then
		TouchSensor.add(
			0,
			data.exitSensor[1],
			data.exitSensor[2],
			data.id,
			0,
			false,
			0,
			function(player)
				if players[player].place == placeToGo then return end
				movePlayer(player, placeToGoPosition[1], placeToGoPosition[2], false)
				players[player].place = placeToGo

				checkIfPlayerIsDriving(player)
				if placeToGo == 'mine' or placeToGo == 'mine_excavation' then
					setNightMode(player, false)
				else
					setNightMode(player, true)
				end

				for i, v in next, players[player].questLocalData.other do
					if i:lower():find(players[player].place:lower()) and i:find('goTo') then
						quest_updateStep(player)
					end
				end
				if data.afterExit then
					data.afterExit(player)
				end
			end,
			true
		)
	end
end

do 
	--[[local modeName, argsPos = string.match(ROOM.name, "%d+([%a_]+)()")
	local gameMode = mainAssets.gamemodes[modeName]
	if gameMode then
		for name in next, ROOM.playerList do 
			eventNewPlayer(name)
		end
		room.gameMode = modeName
		room.maxPlayers = gameMode.maxPlayers
		room.requiredPlayers = gameMode.requiredPlayers
		gameMode.init()
	else]]--
		if ROOM.name == "*#mytest" or ROOM.isTribeHouse then
			room.requiredPlayers = 0
		else
			TFM.setRoomPassword('')
			if string.match(ROOM.name, "^*#mycity[1-9]$") then
				room.requiredPlayers = 2
				room.maxPlayers = 10
			end
		end
		if ROOM.uniquePlayers >= room.requiredPlayers then
			genMap()
		else
			genLobby()
		end
	--end
	setPlayerLimit(room.maxPlayers)
end

system.looping(function()
	if GAME_PAUSED then return end
	updateDialogs(4)
	timersLoop(100)
end, 10)

loadFile(1)

local lastFile = 30
addTimer(function()
	if lastFile == 30 then
		if room.fileUpdated then
			syncFiles()
			room.fileUpdated = false
		else
			loadFile(1)
		end
		lastFile = 1
	elseif lastFile == 1 then
		loadFile(30)
		lastFile = 30
	end
end, 15000, 0)

local syncTimer = system.newTimer(function()
	if tonumber(os_date('%S'))%10 == 0 then
		loadPlayerData('Sharpiebot#0000')
	end
end, 1000, true)

initializingModule = false