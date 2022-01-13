initialization.Room = function()
	if ROOM.name == "*#mytest" or ROOM.isTribeHouse then
		room.requiredPlayers = 0
	elseif ROOM.name:find("@") then
		TFM.setRoomPassword('')
		room.requiredPlayers = 4
	else
		TFM.setRoomPassword('')
		if string.match(ROOM.name, "^*#mycity[1-9]$") then
			room.requiredPlayers = 2
			room.maxPlayers = 10
		end
	end

	if ROOM.uniquePlayers >= room.requiredPlayers then
		genMap()
	else
		genLobby()
	end
	
	setPlayerLimit(room.maxPlayers)
end