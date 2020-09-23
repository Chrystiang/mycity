chatCommands.unban = {
	permissions = {'admin'},
	event = function(player, args)
		local target = string.nick(args[1]) or args[1]
		for i, banned in next, room.bannedPlayers do
			if banned == target then
				table.remove(room.bannedPlayers, i)
				translatedMessage('playerUnbannedFromRoom', target)
				TFM.respawnPlayer(target)
				room.fileUpdated = true
				return
			end
		end
		translatedMessage('<g>[•] '..target..' hadn\'t been banned.', player)
	end
}