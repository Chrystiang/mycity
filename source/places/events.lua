closePlaces = function()
	for place, v in next, places do 
		if not checkGameHour(v.opened) and v.opened ~= '-' then
			kickPlayersFromPlace(place)
		end
	end
end

kickPlayersFromPlace = function(place)
	for name in next, ROOM.playerList do 
		local playerData = players[name]
		if playerData.place == place then
			if places[place].town_tp then
				TFM.movePlayer(name, places[place].town_tp[1], places[place].town_tp[2], false)
				playerData.place = 'town'
			else
				TFM.movePlayer(name, places[place].island_tp[1], places[place].island_tp[2], false)
				playerData.place = 'island'
			end
			alert_Error(name, 'timeOut', 'closed_'..place) 
			showOptions(name)
		end
	end
end

goToHouse = function(player, terrainID)
	players[player].place = 'house_'..terrainID
	loadFound(player, terrainID)
	TFM.movePlayer(player, ((terrainID-1)%terrainID)*1500+400, 1690, false)
	showOptions(player)
	checkIfPlayerIsDriving(player)
	ui.addTextArea(400, string.rep('\n', 3), player, ((terrainID-1)%terrainID)*1500 + 317, 1616 + 45, 25, 25, 0, 0, 0, false, 
		function()
			getOutHouse(player, terrainID)
		end)
	if room.terrains[terrainID].owner ~= player then 
		room.terrains[terrainID].guests[player] = true
	end
	if players[player].questLocalData.other.goToHouse or (terrainID == 12 and players[player].questLocalData.other.goToOliver) then
		quest_updateStep(player)
	end

	if not room.terrains[terrainID].groundsLoadedTo[player] then 
		HouseSystem.new(room.terrains[terrainID].owner):genHouseGrounds(player)
		room.terrains[terrainID].groundsLoadedTo[player] = true
	end
end

getOutHouse = function(player, terrainID)
	if not string.find(players[player].place, 'house_') or players[player].editingHouse then return end
	if terrainID == 12 then -- Oliver's Farm
		TFM.movePlayer(player, 11275, 7770, false)
	elseif terrainID == 11 then -- Remi's Restaurant
		TFM.movePlayer(player, 10200, 7770, false)
	else
		TFM.movePlayer(player, mainAssets.__terrainsPositions[terrainID][1], mainAssets.__terrainsPositions[terrainID][2]+184, false)
	end
	if terrainID >= 10 then
		players[player].place = 'island'
	else
		players[player].place = 'town'
	end
	room.terrains[terrainID].guests[player] = false
	showOptions(player)
end

equipHouse = function(player, houseType, terrainID)
	if room.terrains[terrainID].owner then return alert_Error(player, 'error', 'alreadyLand') end
	if players[player].houseData.houseid > 0 then
		HouseSystem.new(player):removeHouse()
	end
	ui.removeTextArea(24+terrainID)
	ui.removeTextArea(44+terrainID)
	ui.removeTextArea(terrainID)
	players[player].houseData.houseid = terrainID
	players[player].houseData.currentHouse = houseType
	room.terrains[terrainID].bought = true
	room.terrains[terrainID].owner = player
	room.terrains[terrainID].settings = {isClosed = false, permissions = {[player] = 4}}
	showOptions(player)

	HouseSystem.new(player):genHouseFace():genHouseGrounds()
end