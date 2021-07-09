drive = function(name, vehicle)
	local playerData = players[name]
	if playerData.canDrive or not playerData.cars[1] then return end
	if playerData.holdingItem then return end
	local car = mainAssets.__cars[vehicle]
	if not car then return end
	if car.type ~= 'boat' and (ROOM.playerList[name].y < 7000 or ROOM.playerList[name].y > 7800 or players[name].place ~= 'town' and players[name].place ~= 'island') then return end
	if car.type == 'boat' then
		local canUseBoat = false
		for where, biome in next, room.fishing.biomes do
			if biome.canUseBoat then
				if math_range(biome.location, {x = ROOM.playerList[name].x, y = ROOM.playerList[name].y}) then
					canUseBoat = where
					if where == 'sea' and room.event:find('christmas') then
						return alert_Error(name, 'error', 'frozenLake')
					end
					break
				end
			end
		end
		if not canUseBoat then return end
		local align = players[name].place == room.fishing.biomes[canUseBoat].between[1] and room.fishing.biomes[canUseBoat].location[1].x+120 or room.fishing.biomes[canUseBoat].location[3].x-130
		movePlayer(name, align, room.fishing.biomes[canUseBoat].location[1].y + ((vehicle == 11 or vehicle == 18) and -50 or 70), false)
		local function getOutVehicle(player, side)
			players[player].place = room.fishing.biomes[canUseBoat].between[side]
			removeCarImages(player)
			players[player].selectedCar = false
			players[player].driving = false
			players[player].canDrive = false
			players[player].currentCar.direction = nil
			freezePlayer(player, false)
			loadMap(player)
			removeTextArea(-2000, player)
			removeTextArea(-2001, player)
			if players[player].questLocalData.other.goToIsland and players[player].place == 'island' then
				quest_updateStep(player)
			end
			if players[player].fishing[1] then
				stopFishing(player)
			end
			if side == 1 then
				movePlayer(player, room.fishing.biomes[canUseBoat].location[side+1].x-60, room.fishing.biomes[canUseBoat].location[1].y+30, false)
			else
				movePlayer(player, room.fishing.biomes[canUseBoat].location[side+1].x+60, room.fishing.biomes[canUseBoat].location[1].y+30, false)
			end
		end
		showTextArea(-2001, string.rep('\n', 500/4), name, room.fishing.biomes[canUseBoat].location[1].x-900, room.fishing.biomes[canUseBoat].location[1].y-1500, 1000, 2000, 0x1, 0x1, 0, false,
			function(player)
				getOutVehicle(player, 1)
			end)
		showTextArea(-2000, string.rep('\n', 500/4), name, room.fishing.biomes[canUseBoat].location[3].x-100, room.fishing.biomes[canUseBoat].location[3].y-1500, 1000, 2000, 0x1, 0x1, 0, false,
			function(player)
				getOutVehicle(player, 2)
			end)
	end
	for i = 1021, 1051 do
		removeTextArea(i, name)
	end
	if car.type ~= 'air' then
		freezePlayer(name, true)
	end
	playerData.selectedCar = vehicle
	playerData.canDrive = true
	removeCarImages(name)

	playerData.carImages[#playerData.carImages+1] = addImage(car.image, "$"..name, car.x, car.y)
	removeGroupImages(playerData.carWheels)
	playerData.carWheels.angle = 0

	if car.wheels then
		for index, pos in next, car.wheels[1] do
			local wheelID = (direction == 1 and index or (index == 1 and 2 or 1))
			local scale_x = car.wheelsSize[wheelID] / 60
			local scale_y = car.wheelsSize[wheelID] / 60
			playerData.carWheels[#playerData.carWheels+1] = addImage('17870b5a75c.png', '$'..name, pos[1] + car.x, pos[2] + car.y, nil, scale_x, scale_y)
		end
	end

	local vehicleMoving
	vehicleMoving = addTimer(function()
		local player = players[name]
		if (not player.canDrive) or (player.selectedCar ~= vehicle) or (player.robbery.arrested) then
			checkIfPlayerIsDriving(name)
			removeTimer(vehicleMoving)
			return
		else
			local direction = player.currentCar.direction
			if direction == 1 then
				local vel = car.speed
				movePlayer(name, 0, 0, true, vel, 0, false)
			elseif direction == 2 then
				local vel = car.speed
				movePlayer(name, 0, 0, true, -(vel), 0, false)
			elseif direction == 3 then
				local vel = car.speed
				movePlayer(name, 0, 0, true, 0, -(vel/2), false)
			end
			if car.wheels then
				if direction == 1 or direction == 2 then
					local wheels = car.wheels[direction]
					local left, right = wheels[1], wheels[2]
					removeGroupImages(player.carWheels)
					player.carWheels.angle = player.carWheels.angle + math.rad(30 * (direction == 2 and -1 or 1))

					for index, pos in next, wheels do
						local wheelID = (direction == 1 and index or (index == 1 and 2 or 1))
						local scale_x = car.wheelsSize[wheelID] / 60
						local scale_y = car.wheelsSize[wheelID] / 60
						local x = pos[1] + car.x + car.wheelsSize[wheelID]/2
						local y = pos[2] + car.y + car.wheelsSize[wheelID]/2
						player.carWheels[#player.carWheels+1] = addImage('17870b5a75c.png', '$'..name, x, y, nil, scale_x, scale_y, player.carWheels.angle, 1, .5, .5)
					end
				end
			end
			if mainAssets.__cars[player.selectedCar].effects then
				mainAssets.__cars[player.selectedCar].effects(name)
			end
		end
	end, 100, 0)
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
	removeGroupImages(players[player].carImages)
	removeGroupImages(players[player].carLeds)
	removeGroupImages(players[player].carWheels)
end

showBoatShop = function(player, shopFloor)
	local vehicles = {{6, 8}, {12, 11}}
	local position = {{1510, 1710}, {775, 1150}}
	local width = {{180, 180}, {180, 580}}

	if not room.boatShop2ndFloor then
		addGround(7777777777, 1125, 9280, {type = 14, height = 300, width = 20})
	else
		showTextArea(5005, string.rep('\n', 20), player, 1000, 9290, 121, 120, 0x1, 0x1, 0, false,
			function(player)
				movePlayer(player, 1060, 9710)
				players[player].place = 'boatShop_2'
				showBoatShop(player, 2)
			end
		)
		showTextArea(5006, string.rep('\n', 20), player, 1000, 9590, 121, 120, 0x1, 0x1, 0, false,
			function(player)
				movePlayer(player, 1060, 9410)
				players[player].place = 'boatShop'
				showBoatShop(player, 1)
			end
		)
	end
	
	for i, v in next, vehicles[shopFloor] do
		local carInfo = mainAssets.__cars[v]
		showTextArea(5005+i*5, '<p align="center"><font color="#000000" size="14">'..translate('vehicle_'..v, player), player, position[shopFloor][i], 9425+(shopFloor-1)*300, width[shopFloor][i], 80, 0x46585e, 0x46585e, 1)
		showTextArea(5006+i*5, ''..translate('speed', player):format(floor(carInfo.speed/(carInfo.type == 'boat' and 1.85 or 1)))..' '..translate(carInfo.type == 'boat' and 'speed_knots' or 'speed_km', player), player, position[shopFloor][i], 9445+(shopFloor-1)*300, width[shopFloor][i], nil, 0x46585e, 0x00ff00, 0)
		if not table_find(players[player].cars, v) then
			if carInfo.price <= players[player].coins then
				showTextArea(5007+i*5, '<p align="center"><vp>$'..carInfo.price..'\n', player, position[shopFloor][i], 9485+(shopFloor-1)*300, width[shopFloor][i], nil, nil, 0x00ff00, 0.5, false,
					function(player)
						if table_find(players[player].cars, v) then return end
						giveCar(player, v)
						giveCoin(-mainAssets.__cars[v].price, player)
						showBoatShop(player, shopFloor)
					end)
			else
				showTextArea(5007+i*5, '<p align="center"><r>$'..carInfo.price, player, position[shopFloor][i], 9485+(shopFloor-1)*300, width[shopFloor][i], nil, nil, 0xff0000, 0.5)
			end
		else
			showTextArea(5007+i*5, '<p align="center">'..translate('owned', player), player, position[shopFloor][i], 9485+(shopFloor-1)*300, width[shopFloor][i], nil, nil, 0x0000ff, 0.5)
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
				showTextArea(5005+v*counter, '<p align="center"><font color="#000000" size="14">'..carInfo.name, player, (currentCount)*200 + 8805, 130+140, 180, 80, 0x46585e, 0x46585e, 1)
				showTextArea(5006+v*counter, ''..translate('speed', player):format(carInfo.speed)..' '..translate('speed_km', player), player, (currentCount)*200 + 8805, 130+160, 180, nil, 0x46585e, 0x00ff00, 0)

				if not table_find(players[player].cars, v) then
					if carInfo.price <= players[player].coins then
						showTextArea(5007+v*counter, '<p align="center"><vp>$'..carInfo.price..'\n', player, (currentCount)*200 + 8805, 130+200, 180, nil, nil, 0x00ff00, 0.5, false,
							function(player)
								if table_find(players[player].cars, v) then return end
								giveCar(player, v)
								players[player].selectedCar = v
								players[player].place = 'town'

								movePlayer(player, 5000, 1980+room.y, false)
								giveCoin(-mainAssets.__cars[v].price, player)
								drive(player, v)
							end)
					else
						showTextArea(5007+v*counter, '<p align="center"><r>$'..carInfo.price, player, (currentCount)*200 + 8805, 130+200, 180, nil, nil, 0xff0000, 0.5)
					end
				else
					showTextArea(5007+v*counter, '<p align="center">'..translate('owned', player), player, (currentCount)*200 + 8805, 130+200, 180, nil, nil, 0x0000ff, 0.5)
				end
				currentCount = currentCount + 1
			end
		end
	end
end