chatCommands.moveme = {
	permissions = {'admin', 'mod', 'helper'},
	event = function(player, args)
		if not args[1] then return end
		local target = string.nick(args[1])
		if players[target] then
			TFM.chatMessage('[•] ['..target .. '] teleporting to ['.. player .. '] ('..players[player].place..')...', player)
			TFM.movePlayer(target, ROOM.playerList[player].x, ROOM.playerList[player].y, false)
			players[target].place = players[player].place
		else
			TFM.chatMessage('<g>[•] $playerName not found.', player)
		end
	end
}
