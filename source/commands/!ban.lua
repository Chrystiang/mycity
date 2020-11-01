chatCommands.ban = {
	permissions = {'admin', 'mod'},
	event = function(player, args)
		local target = string_nick(args[1]) or args[1]
		room.bannedPlayers[#room.bannedPlayers+1] = target
		killPlayer(target)
		translatedMessage('playerBannedFromRoom', target)
		room.fileUpdated = true
	end
}