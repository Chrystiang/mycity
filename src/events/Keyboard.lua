onEvent("Keyboard", function(player, key, down, x, y)
	if room.isInLobby then return end
	local playerInfo = players[player]
	if not playerInfo then return end
	if down then
		if playerInfo.canDrive then
			if key == 2 or key == 0 then
				removeCarImages(player)
				playerInfo.driving = true
				playerInfo.currentCar.direction = key == 2 and 1 or 2
				playerInfo.carImages[#playerInfo.carImages+1] = addImage(mainAssets.__cars[playerInfo.selectedCar].image[playerInfo.currentCar.direction], "$"..player, mainAssets.__cars[playerInfo.selectedCar].x, mainAssets.__cars[playerInfo.selectedCar].y)
			elseif key == 3 then
				playerInfo.currentCar.direction = 0
			else
				if playerInfo.driving and key == 1 and mainAssets.__cars[playerInfo.selectedCar].type ~= 'boat' then
					if mainAssets.__cars[playerInfo.selectedCar].type ~= 'helicopter' then
						removeCarImages(player)
						playerInfo.selectedCar = false
						playerInfo.driving = false
						playerInfo.canDrive = false
						playerInfo.currentCar.direction = nil
						freezePlayer(player, false)
						loadMap(player)
						showOptions(player)
					else
						playerInfo.driving = true
						playerInfo.currentCar.direction = 3
					end
				end
			end
		end
		if key == 32 then
			if playerInfo.job == 'fisher' and not playerInfo.fishing[1] then
				if not playerInfo.selectedCar or mainAssets.__cars[playerInfo.selectedCar].type ~= 'car' then
					local biome = false
					for place, settings in next, room.fishing.biomes do 
						if math.range(settings.location, {x = x, y = y}) then 
							biome = place
							break
						end
					end
					if biome then
						playerFishing(player, x, y, biome)
					else
						TFM.chatMessage('<r>'..translate('fishWarning', player), player)
					end
				end
			elseif playerInfo.job == 'police' then
				if playerInfo.time > os.time() then return TFM.chatMessage('<r>'..translate('copError', player), player) end
				for i, v in next, ROOM.playerList do
					if math.hypo(x, y, v.x, v.y) <= 60 and i ~= player and not ROOM.playerList[player].isDead and not v.isDead then
						if players[i].job == 'thief' and players[i].robbery.robbing or players[i].robbery.escaped then
							if playerInfo.place == players[i].place and not players[i].robbery.usingShield then
								arrestPlayer(i, player)
								break
							end
						end
					end
				end
				if playerInfo.questLocalData.other.arrestRobber then
					if math.hypo(x, y, 1930, 8530) <= 60 then
						arrestPlayer('Robber', player)
						quest_updateStep(player)
					end
				end
			elseif playerInfo.job == 'thief' then
				if not playerInfo.robbery.robbing then
					for i, v in next, gameNpcs.robbing do
						if gameNpcs.characters[i].visible then
							if math.hypo(v.x, v.y, x, y) <= 60 then
								startRobbery(player, i)
								break
							end
						end
					end
				end
			end
		elseif key <= 3 then
			if playerInfo.fishing[1] then
				stopFishing(player)
			end
		elseif key == 70 or key == 71 then 
			local vehicleType = key-69
			local car = playerInfo.favoriteCars[vehicleType]
			drive(player, car)
		end
	end
end)