loadHouse = function(player, houseType, terrainID)
	if room.terrains[terrainID].owner then return alert_Error(player, 'error', 'alreadyLand') end

	if players[player].houseData.houseid > 0 then
		HouseSystem.new(player):removeHouse()
	end

	removeTextArea(24+terrainID)
	removeTextArea(44+terrainID)
	removeTextArea(terrainID)

	players[player].houseData.houseid = terrainID
	players[player].houseData.currentHouse = houseType

	room.terrains[terrainID].bought = true
	room.terrains[terrainID].owner = player
	room.terrains[terrainID].settings = {isClosed = false, permissions = {[player] = 4}}

	HouseSystem.new(player)
		:genHouseFace()
			:genHouseGrounds()
end