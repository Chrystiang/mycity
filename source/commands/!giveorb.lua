chatCommands.giveorb = {
	permissions = {'admin'},
	event = function(player, args)
		local target = string.nick(args[1])
		local orb = tonumber(args[2])
		if not players[target] then return TFM.chatMessage('<g>[•] $playerName not found.', player) end
		if not mainAssets.levelIcons.star[orb] then TFM.chatMessage('<g>[•] Unknown Orb.', player) return end

		giveLevelOrb(target, orb)
		TFM.chatMessage('<g>[•] Done! Orb '..orb..' given to '..target..'.', player)
	end
}
