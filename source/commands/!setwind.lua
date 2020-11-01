chatCommands.setwind = {
	permissions = {'admin'},
	event = function(player, args)
		local wind = tonumber(args[1])
		room.map.wind = wind
		TFM.setWorldGravity(room.map.wind, room.map.gravity)

		chatMessage('<g>[•] Done! Map wind set to '..wind..'.', player)
	end
}