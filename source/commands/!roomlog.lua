chatCommands.roomlog = {
	permissions = {'admin', 'mod', 'helper'},
	event = function(player)
		players[player].roomLog = not players[player].roomLog
		TFM.chatMessage('<g>[•] roomLog status: '..tostring(players[player].roomLog), player)
	end
}