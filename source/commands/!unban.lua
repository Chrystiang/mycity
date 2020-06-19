chatCommands.unban = {
	permissions = {'admin', 'mod'},
	event = function(player, args)
		local target = string.nick(args[1])
		if not players[target] then return TFM.chatMessage('<g>[•] $playerName not found.', player) end
		if not table.contains(room.bannedPlayers, target) then return end
		for i, v in next, room.bannedPlayers do
			if v == target then
				table.remove(room.bannedPlayers, i)
				break
			end
		end
		TFM.respawnPlayer(target)
		translatedMessage('playerUnbannedFromRoom', target)
		room.fileUpdated = true
	end
}
