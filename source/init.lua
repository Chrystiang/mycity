startRoom = function()
	if not room.isInLobby then
		room.terrains = {}
		room.houseImgs = {}
		players = {}
		room.gameLoadedTimes = room.gameLoadedTimes + 1
		
		for i = 1, #mainAssets.__terrainsPositions do
			room.terrains[i] = {img = {}, bought = false, owner = nil, settings = {}, groundsLoadedTo = {}, guests = {}}
			room.houseImgs[i] = {img = {}, furnitures = {}, expansions = {}}
		end
		room.started = true

		for name in next, ROOM.playerList do 
			eventNewPlayer(name)
		end

		eventNewPlayer('Oliver')
		eventNewPlayer('Remi')

		removeTimer(room.temporaryTimer)
		if room.gameLoadedTimes == 1 then 
			for i = 1, 2 do 
				gameNpcs.setOrder(table.randomKey(gameNpcs.orders.canOrder))
			end

			addTimer(function()
				for i, v in next, ROOM.playerList do
					updateBarLife(i)
				end
			end, 60000, 0)
		end
	else
		players = {}
		for name in next, ROOM.playerList do 
			eventNewPlayer(name)
		end
	end
end

genDaveOffers = function()
	daveOffers = {}
	local i = 1
	while #daveOffers < 3 do
		math.randomseed(room.mathSeed * i^2)
		local offerID = math.random(1, #mainAssets.__farmOffers)
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
	math.randomseed(os.time())
end

for i, v in next, recipes do
	newFoodValue(i)
	newEnergyValue(i)
	newDishPrice(i)
end

for i, v in next, HouseSystem.plants do
	if bagItems[v.name] then
		bagItems[v.name].sellingPrice = v.pricePerSeed/10
		bagItems[v.name].isFruit = true
	end
end

npcsStores.items = mergeItemsWithFurnitures(mainAssets.__furnitures, bagIds)
buildNpcsShopItems()
genDaveOffers()

for item, data in next, Mine.ores do 
	bagItems['crystal_'..item].price = math.floor(200*(12/data.rarity))
end

mine_generate()

if ROOM.name == "*#fofinho" or ROOM.community == 'sk' or ROOM.name == "*Mycity hu" then
	room.requiredPlayers = 0
else
	TFM.setRoomPassword('')
	if string.match(ROOM.name, "^en%-#mycity[1-9]$") then
		room.requiredPlayers = 2
		room.maxPlayers = math.ceil(room.maxPlayers/2)
		RUNTIME_LIMIT = 35
	end
end

TFM.setRoomMaxPlayers(room.maxPlayers)
system.loadFile(1)

local lastFile = 5
addTimer(function()
	if lastFile == 5 then
		if room.fileUpdated then
			syncFiles()
			room.fileUpdated = false
		else
			system.loadFile(1)
		end
		lastFile = 1
	elseif lastFile == 1 then
		system.loadFile(5)
		lastFile = 5
	end
end, 90000, 0)

if ROOM.uniquePlayers >= room.requiredPlayers then
	genMap()
else
	genLobby()
end

local syncTimer = system.newTimer(function()
	if tonumber(os.date('%S'))%10 == 0 then
		system.loadPlayerData('Sharpiebot#0000')
	end
end, 1000, true)