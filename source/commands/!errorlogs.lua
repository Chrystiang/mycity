chatCommands.errorlogs = {
	event = function(player, args)
		local gameVersion = 'v'..table_concat(version, '.')
		modernUI.new(player, 520, 300, 'Error Logs - '..gameVersion..' ['..versionLogs[gameVersion].releaseDate..']', '<font size="10">'..table_concat(room.errorLogs, '\n'), 'errorUI')
		:build()
	end
}