chatCommands.hour = {
	permissions = {'admin'},
	event = function(player, args)
		room.currentGameHour = args[1] or 0
		chatMessage('<rose>' ..updateHour(player, true))
	end
}