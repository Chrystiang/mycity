drive = function(name, vehicle)
	local playerData = players[name]
	if playerData.canDrive or playerData.place == 'mine' or not playerData.cars[1] then return end
	local car = mainAssets.__cars[vehicle]
	if not car then return end
	if car.type ~= 'boat' and (ROOM.playerList[name].y < 7000 or ROOM.playerList[name].y > 7800 or players[name].place ~= 'town' and players[name].place ~= 'island') then return end
	if car.type == 'boat' then
		local canUseBoat = false
		for where, biome in next, room.fishing.biomes do
			if biome.canUseBoat then
				if math.range(biome.location, {x = ROOM.playerList[name].x, y = ROOM.playerList[name].y}) then
					canUseBoat = where
					break
				end
			end
		end
		if not canUseBoat then return end
		local align = players[name].place == room.fishing.biomes[canUseBoat].between[1] and room.fishing.biomes[canUseBoat].location[1].x+100 or room.fishing.biomes[canUseBoat].location[3].x-80
		tfm.exec.movePlayer(name, align, room.fishing.biomes[canUseBoat].location[1].y + (vehicle == 11 and -50 or 70), false)
		local function getOutVehicle(player, side)
			players[player].place = room.fishing.biomes[canUseBoat].between[side]
			removeCarImages(player)
			players[player].selectedCar = false
			players[player].driving = false
			players[player].canDrive = false
			players[player].currentCar.direction = nil
			freezePlayer(player, false)
			loadMap(player)
			ui.removeTextArea(-2000, player)
			ui.removeTextArea(-2001, player)
			if players[player].questLocalData.other.goToIsland and players[player].place == 'island' then
				quest_updateStep(player)
			end
			if players[player].fishing[1] then
				stopFishing(player)
			end
			tfm.exec.movePlayer(player, room.fishing.biomes[canUseBoat].location[side+1].x-60, room.fishing.biomes[canUseBoat].location[1].y+30, false)
		end
		ui.addTextArea(-2001, string.rep('\n', 500/4), name, room.fishing.biomes[canUseBoat].location[1].x-900, room.fishing.biomes[canUseBoat].location[1].y-1500, 1000, 2000, 0x1, 0x1, 0, false,
			function(player)
				getOutVehicle(player, 1)
			end)
		ui.addTextArea(-2000, string.rep('\n', 500/4), name, room.fishing.biomes[canUseBoat].location[3].x-100, room.fishing.biomes[canUseBoat].location[3].y-1500, 1000, 2000, 0x1, 0x1, 0, false,
			function(player)
				getOutVehicle(player, 2)
			end)
	end
	for i = 1021, 1051 do
		ui.removeTextArea(i, name)
	end
	freezePlayer(name, true)
	playerData.selectedCar = vehicle
	playerData.canDrive = true
	removeCarImages(name)
	playerData.carImages[#playerData.carImages+1] = addImage(car.image[1], "$"..name, car.x, car.y)
end

checkIfPlayerIsDriving = function(name)
	local playerData = players[name]
	if playerData.canDrive then
		removeCarImages(name)
		playerData.selectedCar = nil
		playerData.driving = false
		playerData.canDrive = false
		playerData.currentCar.direction = nil
		freezePlayer(name, false)
		showOptions(name)
		loadMap(name)
	end
end

removeCarImages = function(player)
	if not players[player] then return end
    player_removeImages(players[player].carImages)
    player_removeImages(players[player].carLeds)
end

showBoatShop = function(player, floor)
	if not room.boatShop2ndFloor then
		addGround(7777777777, 1125, 9280, {type = 14, height = 300, width = 20})
	else 
		ui.addTextArea(5005, string.rep('\n', 20), player, 1000, 9290, 121, 120, 0x1, 0x1, 0, false, 
			function(player)
				TFM.movePlayer(player, 1060, 9710)
				players[player].place = 'boatShop_2'
				showBoatShop(player, 2)
			end)
		ui.addTextArea(5006, string.rep('\n', 20), player, 1000, 9590, 121, 120, 0x1, 0x1, 0, false, 
			function(player)
				TFM.movePlayer(player, 1060, 9410)
				players[player].place = 'boatShop'
				showBoatShop(player, 1)
			end)
	end
	local vehicles = {{6, 8}, {12, 11}}
	local position = {{1510, 1710}, {775, 1150}}
	local width = {{180, 180}, {180, 580}}
	for i, v in next, vehicles[floor] do 
		local carInfo = mainAssets.__cars[v]
		ui.addTextArea(5005+i*5, '<p align="center"><font color="#000000" size="14">'..translate('vehicle_'..v, player), player, position[floor][i], 9425+(floor-1)*300, width[floor][i], 80, 0x46585e, 0x46585e, 1)
		ui.addTextArea(5006+i*5, ''..translate('speed', player):format(math.floor(carInfo.maxVel/(carInfo.type == 'boat' and 1.85 or 1)))..' '..translate(carInfo.type == 'boat' and 'speed_knots' or 'speed_km', player), player, position[floor][i], 9445+(floor-1)*300, width[floor][i], nil, 0x46585e, 0x00ff00, 0)
		if not table.contains(players[player].cars, v) then
			if carInfo.price <= players[player].coins then
				ui.addTextArea(5007+i*5, '<p align="center"><vp>$'..carInfo.price..'\n', player, position[floor][i], 9485+(floor-1)*300, width[floor][i], nil, nil, 0x00ff00, 0.5, false, 
					function(player)
						if table.contains(players[player].cars, v) then return end
						players[player].cars[#players[player].cars+1] = v
						giveCoin(-mainAssets.__cars[v].price, player)
						showBoatShop(player, floor)
					end)
			else
				ui.addTextArea(5007+i*5, '<p align="center"><r>$'..carInfo.price, player, position[floor][i], 9485+(floor-1)*300, width[floor][i], nil, nil, 0xff0000, 0.5)
			end
		else
			ui.addTextArea(5007+i*5, '<p align="center">'..translate('owned', player), player, position[floor][i], 9485+(floor-1)*300, width[floor][i], nil, nil, 0x0000ff, 0.5)
		end
	end
end

showCarShop = function(player)
	local counter = #mainAssets.__cars+1
	local currentCount = 0
	for v = 1, 7 do
		local carInfo = mainAssets.__cars[v]
		if carInfo then
			if carInfo.type == 'car' then
				ui.addTextArea(5005+v*counter, '<p align="center"><font color="#000000" size="14">'..carInfo.name, player, (currentCount)*200 + 8805, 130+140, 180, 80, 0x46585e, 0x46585e, 1)
				ui.addTextArea(5006+v*counter, ''..translate('speed', player):format(carInfo.maxVel)..' '..translate('speed_km', player), player, (currentCount)*200 + 8805, 130+160, 180, nil, 0x46585e, 0x00ff00, 0)

				if not table.contains(players[player].cars, v) then
					if carInfo.price <= players[player].coins then
						ui.addTextArea(5007+v*counter, '<p align="center"><vp>$'..carInfo.price..'\n', player, (currentCount)*200 + 8805, 130+200, 180, nil, nil, 0x00ff00, 0.5, false, 
							function(player)
								if table.contains(players[player].cars, v) then return end
								players[player].cars[#players[player].cars+1] = v
								players[player].selectedCar = v
								players[player].place = 'town'

								TFM.movePlayer(player, 5000, 1980+room.y, false)
								giveCoin(-mainAssets.__cars[v].price, player)
								drive(player, v)
							end)
					else
						ui.addTextArea(5007+v*counter, '<p align="center"><r>$'..carInfo.price, player, (currentCount)*200 + 8805, 130+200, 180, nil, nil, 0xff0000, 0.5)
					end
				else
					ui.addTextArea(5007+v*counter, '<p align="center">'..translate('owned', player), player, (currentCount)*200 + 8805, 130+200, 180, nil, nil, 0x0000ff, 0.5)
				end
				currentCount = currentCount + 1
			end
		end
	end
end