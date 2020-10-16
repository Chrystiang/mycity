chatCommands.whitelist = {
	permissions = {'admin'},
	event = function(player, args)
		local target = string.nick(args[1])
		if not players[target] then return TFM.chatMessage('<g>[•] $playerName not found.', player) end
		players[target].lucky[2] = not players[target].lucky[2]
		savedata(target)
		TFM.chatMessage('<g>[•] Done! '..target..' is '.. (players[target].lucky[2] and 'not' or 'now') ..' whitelisted.', player)
	end
}