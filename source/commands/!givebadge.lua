chatCommands.givebadge = {
	permissions = {'admin'},
	event = function(player, args)
		local target = string_nick(args[1])
		local badge = tonumber(args[2])
		if not players[target] then return chatMessage('<g>[•] $playerName not found.', player) end
		if not badges[badge] then chatMessage('<g>[•] Unknown Badge.', player) return end

		giveBadge(target, badge)
		chatMessage('<g>[•] Done! Badge '..badge..' given to '..target..'.', player)
	end
}

