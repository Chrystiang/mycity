onEvent("PlayerLeft", function(player)
	if player and isExploiting[player] then return end
	if room.isInLobby then return end
	local playerData = players[player]
	if playerData.trading then
		tradeSystem.endTrade(tradeSystem.trades[playerData.tradeId], false, player)
	end
	HouseSystem.new(player):removeHouse()
	if playerData.robbery.robbing then
		removeTimer(playerData.timer)
		arrestPlayer(player, 'AUTO')
		giveCoin(-300, player)
	end
	if playerData.job then
		job_fire(player)
	end
	if playerData.fishing[1] then
		stopFishing(player)
	end

	if playerData.dataLoaded then
		savedata(player, true)
	end
	setPlayerData(player)
end)