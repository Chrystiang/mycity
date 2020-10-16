onEvent("PlayerRespawn", function(player)
	if room.gameMode then return end
	if room.isInLobby then return end
	local level = players[player].level[1]
	for i, v in next, ROOM.playerList do
		generateLevelImage(player, level, i)
	end
end)