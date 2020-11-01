chatCommands.update = {
	permissions = {'admin'},
	event = function(player, args)
		if not syncData.connected then return chatMessage('<fc>[•] Failed to update. Reason: Data not synced.', player) end
		local msg = args[1] and table_concat(args, ' ') or ''
		syncData.updating.updateMessage = msg
		saveGameData('Sharpiebot#0000')
		chatMessage('<fc>[•] Update requested. Message: '..msg, player)
	end
}