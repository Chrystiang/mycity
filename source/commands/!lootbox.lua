chatCommands.lootbox = {
	permissions = {'admin'},
	event = function(player)
		local x = math.random(0, 12000)
		addLootDrop(x, 7200, 20)
		for i, v in next, ROOM.playerList do 
			TFM.movePlayer(i, x, 7600, false)
		end
	end
}