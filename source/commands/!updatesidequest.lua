chatCommands.updatesidequest = {
	permissions = {'admin'},
	event = function(player, args)
		local value = tonumber(args[1])
		if not value then return chatMessage('<g>[•] invalid value.', player) end
		local target = string_nick(args[2])
		if not players[target] then target = player end

		sideQuest_update(target, value)
		savedata(target)
		chatMessage('<g>[•] Done! Side Quest updated to '..target..'.', player)
	end
}