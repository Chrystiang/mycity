chatCommands.sidequest = {
	permissions = {'admin'},
	event = function(player, args)
		local nextQuest = tonumber(args[1])
		if not sideQuests[nextQuest] then return TFM.chatMessage('<g>[•] invalid sidequest ID.', player) end
		local target = string.nick(args[2])
		if not players[target] then target = player end

		players[target].sideQuests[1] = nextQuest
		players[target].sideQuests[2] = 0
		savedata(target)
		TFM.chatMessage('<g>[•] Done! Quest '..nextQuest..' set to '..target..'.', player)
	end
}