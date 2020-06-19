chatCommands.ban = {
	permissions = {'admin', 'mod'},
	event = function(player, args)
		local target = string.nick(args[1])
		if not players[target] then return TFM.chatMessage('<g>[•] $playerName not found.', player) end
		room.bannedPlayers[#room.bannedPlayers+1] = target
		TFM.killPlayer(target)
		translatedMessage('playerBannedFromRoom', target)
		room.fileUpdated = true
	end
}