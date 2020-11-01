chatCommands.jail = {
	permissions = {'admin', 'mod', 'helper'},
	event = function(player, args)
		local target = string_nick(args[1])
		if not players[target] then return chatMessage('<g>[•] $playerName not found.', player) end
		chatMessage('<g>[•] arresting '..target..'...', player)
		arrestPlayer(target, 'Colt')
	end
}

