chatCommands.jail = {
	permissions = {'admin', 'mod', 'helper'},
	event = function(player, args)
		local target = string.nick(args[1])
		if not players[target] then return TFM.chatMessage('<g>[•] $playerName not found.', player) end
		TFM.chatMessage('<g>[•] arresting '..target..'...', player)
		arrestPlayer(target, 'Colt')
	end
}

