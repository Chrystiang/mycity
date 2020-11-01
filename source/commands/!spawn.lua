chatCommands.spawn = {
	permissions = {'admin', 'mod', 'helper'},
	event = function(player, args)
		local target = string_nick(args[1])
		if not players[target] then return chatMessage('<g>[•] $playerName not found.', player) end
		chatMessage('<g>[•] moving '..target..' to spawn...', player)
		players[target].place = 'town'
		killPlayer(target)
	end
}