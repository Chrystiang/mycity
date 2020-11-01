chatCommands.setgravity = {
	permissions = {'admin'},
	event = function(player, args)
		local gravity = tonumber(args[1])
		room.map.gravity = gravity
		TFM.setWorldGravity(room.map.wind, room.map.gravity)

		chatMessage('<g>[•] Done! Map gravity set to '..gravity..'.', player)
	end
}