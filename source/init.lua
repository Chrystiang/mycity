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
					players[player].timePlayed = players[player].timePlayed + 1
					updateLifeBar(player)
				end
			end, 60000, 0)
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
	if ROOM.name == "*#mytest" or ROOM.isTribeHouse then
		room.requiredPlayers = 0
	elseif ROOM.name:find("@") then
		TFM.setRoomPassword('')
		room.requiredPlayers = 4
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
	
	setPlayerLimit(room.maxPlayers)
end

system.looping(function()
	if GAME_PAUSED then return end
	updateDialogs(4)
	timersLoop(100)
end, 10)

loadFile(1)

addTimer(function()
	if room.fileUpdated then
		syncFiles()
		room.fileUpdated = false
	else
		loadFile(1)
	end
end, 15000, 0)

local syncTimer = system.newTimer(function()
	if tonumber(os_date('%S'))%10 == 0 then
		loadPlayerData('Sharpiebot#0000')
	end
end, 1000, true)

initializingModule = false