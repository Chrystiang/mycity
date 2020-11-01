chatCommands.whitelist = {
	permissions = {'admin'},
	event = function(player, args)
		local target = string_nick(args[1])
		if not players[target] then return chatMessage('<g>[•] $playerName not found.', player) end
		players[target].lucky[2] = not players[target].lucky[2]
		savedata(target)
		chatMessage('<g>[•] Done! '..target..' is '.. (players[target].lucky[2] and 'not' or 'now') ..' whitelisted.', player)
	end
}