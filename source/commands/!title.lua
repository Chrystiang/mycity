chatCommands.title = {
	permissions = {'admin'},
	event = function(player, args)
		local target = string_nick(args[2])
		local id = args[1]
		if not players[target] then return chatMessage('<g>[•] $playerName not found.', player) end
		system.giveEventGift(target, id)

		chatMessage('<g>[•] Done! Title '..id..' given to '..target..'.', player)
	end
}