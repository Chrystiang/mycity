chatCommands.ban = {
	permissions = {'admin', 'mod'},
	event = function(player, args)
		local target = string.nick(args[1]) or args[1]
		room.bannedPlayers[#room.bannedPlayers+1] = target
		TFM.killPlayer(target)
		translatedMessage('playerBannedFromRoom', target)
		room.fileUpdated = true
	end
}