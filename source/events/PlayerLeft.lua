onEvent("PlayerLeft", function(player)
	if room.isInLobby then return end
	local playerData = players[player]

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
		savedata(player)
	end
	setPlayerData(player)
end)