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

for resource, callback in next, initialization do
	callback()
end

initializingModule = false