chatCommands.spawn = {
	permissions = {'admin', 'mod', 'helper'},
	event = function(player, args)
		local target = string.nick(args[1])
		if not players[target] then return TFM.chatMessage('<g>[•] $playerName not found.', player) end
		TFM.chatMessage('<g>[•] moving '..target..' to spawn...', player)
		players[target].place = 'town'
		TFM.killPlayer(target)
	end
}