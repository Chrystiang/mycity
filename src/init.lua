startRoom = function()
	if not room.isInLobby then
		room.terrains = {}
		room.houseImgs = {}
		players = {}

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
		room.temporaryTimer = addTimer(function()
			for i, v in next, ROOM.playerList do
				updateBarLife(i)
			end
		end, 60000, 0)
		if character.orderList == {} then 
			for i = 1, 2 do 
				gameNpcs.setOrder(table.randomKey(gameNpcs.orders.canOrder))
			end
		end
	else
		players = {}
		for name in next, ROOM.playerList do 
			eventNewPlayer(name)
		end
	end
end

for i, v in next, recipes do
	newFoodValue(i)
	newEnergyValue(i)
	newDishPrice(i)
end


npcsStores.items = mergeItemsWithFurnitures(mainAssets.__furnitures, bagIds)
buildNpcsShopItems()

for item, data in next, Mine.ores do 
	bagItems['crystal_'..item].price = math.floor(200*(12/data.rarity))
end

if ROOM.name == "*#fofinho" or ROOM.community == 'sk' then
	room.requiredPlayers = 0
else
	TFM.setRoomPassword('')
	for player in next, ROOM.playerList do
		if ROOM.name:sub(1,1) == '*' and ROOM.name:find(player) then 
			system.bindMouse(player, true)
			room.requiredPlayers = 0
			TFM.setRoomMaxPlayers(1)
			TFM.setRoomPassword('blankRoom')
			TFM.chatMessage('You can teleport in this room!!!1', player)
		end
	end
end
TFM.setRoomMaxPlayers(room.maxPlayers)
system.loadFile(5)

addTimer(function()
	system.loadFile(5)
end, 120000, 0)
mine_generate()

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