chatCommands.lootbox = {
	permissions = {'admin'},
	event = function(player)
		local x = random(0, 12000)
		addLootDrop(x, 7200, 20)
		for i, v in next, ROOM.playerList do 
			movePlayer(i, x, 7600, false)
		end
	end
}