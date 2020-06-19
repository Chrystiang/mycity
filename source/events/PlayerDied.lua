onEvent("PlayerDied", function(player)
	if room.isInLobby or not players[player] or players[player].editingHouse or checkLocation_isInHouse(player) then return end
	if table.contains(room.bannedPlayers, player) then return end
	if players[player].driving then
    	players[player].driving = false
	end
    TFM.respawnPlayer(player)
	if players[player].place == 'island' then
		TFM.movePlayer(player, 9230, 1944+room.y, false)
	else
		players[player].place = 'town'
	end
	showOptions(player)
end)