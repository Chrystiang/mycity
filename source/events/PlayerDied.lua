onEvent("PlayerDied", function(player)
	if player and isExploiting[player] then return end
	if room.gameMode then return end
	if room.isInLobby or not players[player] or players[player].editingHouse or checkLocation_isInHouse(player) then return end
	if table_find(room.bannedPlayers, player) then return end
	wasDriving = players[player].driving
	checkIfPlayerIsDriving(player)
	respawnPlayer(player)
	if players[player].place == 'island' then
		movePlayer(player, 9230, 1944+room.y, false)
	else
		players[player].place = 'town'
		if wasDriving then
			movePlayer(player, 6240, 1944+room.y, false)
		end
	end
end)