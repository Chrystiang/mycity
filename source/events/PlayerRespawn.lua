onEvent("PlayerRespawn", function(player)
	if room.gameMode then return end
	if room.isInLobby then return end
	if not player then return end
	if not players[player] then return end
	if not players[player].dataLoaded then return end
	if isExploiting[player] then return end
	
	--[[if lastRevive[player] then
		if lastRevive[player] > os_time()-10000 and not players[player].editingHouse then
			isExploiting[player] = true
			return
		end
	end]]
	lastRevive[player] = os_time()

	local level = players[player].level[1]
	for i, v in next, ROOM.playerList do
		generateLevelImage(player, level, i)
	end
end)