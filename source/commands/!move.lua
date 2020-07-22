chatCommands.move = {
	permissions = {'admin', 'mod', 'helper'},
	event = function(player, args)
		if not args[1] or not args[2] then return end
		local target1 = string.nick(args[1])
		local target2 = string.nick(args[2])
		if players[target1] then
			if players[target2] then
				TFM.chatMessage('[•] ['..target1 .. '] teleporting to ['.. target2 ..'] ('..players[target2].place..')...', player)
				TFM.movePlayer(target1, ROOM.playerList[target2].x, ROOM.playerList[target2].y, false)
				players[target1].place = players[target2].place
			else
				TFM.chatMessage('<g>[•] $playerName not found. ('..target2..')', player)
			end
		else
			TFM.chatMessage('<g>[•] $playerName not found. ('..target1..')', player)
		end
	end
}
