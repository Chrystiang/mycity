chatCommands.giveorb = {
	permissions = {'admin'},
	event = function(player, args)
		local target = string_nick(args[1])
		local orb = tonumber(args[2])
		if not players[target] then return chatMessage('<g>[•] $playerName not found.', player) end
		if not mainAssets.levelIcons.star[orb] then chatMessage('<g>[•] Unknown Orb.', player) return end

		giveLevelOrb(target, orb)
		chatMessage('<g>[•] Done! Orb '..orb..' given to '..target..'.', player)
	end
}
