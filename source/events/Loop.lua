onEvent("Loop", function()
	if room.gameMode then return end
	if room.started then
		room.currentGameHour = room.currentGameHour + 1
		checkWorkingTimer()
		if room.currentGameHour%15 == 0 then
			updateHour()
		elseif room.currentGameHour == 1440 then
			room.currentGameHour = 0
		end
		HouseSystem.gardening()
	end
	if ROOM.uniquePlayers >= room.requiredPlayers then
		if room.isInLobby then	
			genMap()
			removeTextArea(0, nil)
			removeTextArea(1, nil)
		end
	else
		if not room.isInLobby then
			genLobby()
			removeTextArea(0, nil)
			removeTextArea(1, nil)
		end
	end
end)