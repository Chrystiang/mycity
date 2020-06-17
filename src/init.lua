startRoom = function()
	if not room.isInLobby then
		room.terrains = {}
		room.houseImgs = {}
		for i = 1, #mainAssets.__terrainsPositions do
			room.terrains[i] = {img = {}, bought = false, owner = nil, settings = {}, groundsLoadedTo = {}, guests = {}}
			room.houseImgs[i] = {img = {}, furnitures = {}, expansions = {}}
		end
		room.started = true
		players = {}
		for name in next, ROOM.playerList do 
			eventNewPlayer(name)
		end
		eventNewPlayer('Oliver')
		eventNewPlayer('Remi')
		players['Oliver'].lastCallback.when = 0
		players['Oliver'].houseTerrain = {2, 2, 2, 2}
		players['Oliver'].houseTerrainAdd = {math.random(2,5), math.random(2,5), math.random(2,5), math.random(2,5)}
		players['Oliver'].houseTerrainPlants = {6, 6, 6, 6}
		players['Oliver'].houseData.furnitures.placed = {[1] = {y = 656,x = 958,type = 46},[2] = {y = 656,x = 1036,type = 46},[3] = {y = 656,x = 1114,type = 46},[4] = {y = 656,x = 1192,type = 46},[5] = {y = 656,x = 1270,type = 46},[6] = {y = 656,x = 1348,type = 46},[7] = {y = 656,x = 1426,type = 46},[8] = {y = 670,x = 34,type = 12},[9] = {y = 670,x = 120,type = 12},[10] = {y = 632,x = 96,type = 12},[11] = {y = 676,x = 218,type = 9},[12] = {y = 609,x = 127,type = 32},[13] = {y = 657,x = 1334,type = 3},[14] = {y = 654,x = 1140,type = 30},[15] = {y = 655,x = 1456,type = 30},[16] = {y = 574,x = 971,type = 31},[17] = {y = 656,x = 802,type = 46},[18] = {y = 657,x = 880,type = 46},[19] = {y = 657,x = 724,type = 46},[20] = {y = 656,x = 646,type = 46},[21] = {y = 657,x = 568,type = 46}}
		equipHouse('Oliver', 4, 11)
		players['Remi'].lastCallback.when = 0
		players['Remi'].houseData.furnitures.placed = {[1] = {y = 664,x = 423,type = 44},[2] = {y = 664,x = 527,type = 44},[3] = {y = 664,x = 632,type = 44},[4] = {y = 663,x = 738,type = 44},[5] = {y = 670,x = 916,type = 42},[6] = {y = 667,x = 954,type = 39},[7] = {y = 667,x = 1000,type = 39},[8] = {y = 670,x = 1047,type = 42},[9] = {y = 670,x = 1081,type = 42},[10] = {y = 620,x = 878,type = 40},[11] = {y = 670,x = 880,type = 43},[12] = {y = 620,x = 1043,type = 41},[13] = {y = 559,x = 952,type = 45}}
		equipHouse('Remi', 9, 10)

		removeTimer(room.temporaryTimer)
		addTimer(function()
			for i, v in next, ROOM.playerList do
				updateBarLife(i)
			end
		end, 60000, 0)
		for i = 1, 2 do 
			gameNpcs.setOrder(table.randomKey(gameNpcs.orders.canOrder))
		end
		for i, v in next, recipes do
			newFoodValue(i)
			newEnergyValue(i)
			newDishPrice(i)
		end
	else
		players = {}
		for name in next, ROOM.playerList do 
			eventNewPlayer(name)
		end
	end
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