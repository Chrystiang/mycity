onEvent("Loop", function()
	timersLoop()
	if room.started then
		room.currentGameHour = room.currentGameHour + 1
		checkWorkingTimer()
		for name, data in next, ROOM.playerList do
			player = players[name]
			if not player then break end
			if player.holdingItem and not mainAssets.__furnitures[player.holdingItem] then
				local image, x, y
				if data.isFacingRight then
					if player.holdingDirection ~= "right" then
						image = bagItems[player.holdingItem].holdingImages[2]
						x = bagItems[player.holdingItem].holdingAlign[2][1]
						y = bagItems[player.holdingItem].holdingAlign[2][2]

						player.holdingDirection = "right"
					end
				else
					if player.holdingDirection ~= "left" then
						image = bagItems[player.holdingItem].holdingImages[1]
						x = bagItems[player.holdingItem].holdingAlign[1][1]
						y = bagItems[player.holdingItem].holdingAlign[1][2]

						player.holdingDirection = "left"
					end
				end
				if image then
					if player.holdingImage then
						removeImage(player.holdingImage)
					end
					player.holdingImage = addImage(image, "$" .. name, x, y)
				end
			end
			if not player.hospital.hospitalized or not player.robbery.arrested then
				moveTo(name)
			end
			if player.driving then
				if player.currentCar.direction == 1 then
					local vel = mainAssets.__cars[player.selectedCar].maxVel
					TFM.movePlayer(name, 0, 0, true, vel, 0, false)
				elseif player.currentCar.direction == 2 then
					local vel = mainAssets.__cars[player.selectedCar].maxVel
					TFM.movePlayer(name, 0, 0, true, -(vel), 0, false)
				elseif player.currentCar.direction == 3 then
					local vel = mainAssets.__cars[player.selectedCar].maxVel
					TFM.movePlayer(name, 0, 0, true, 0, -(vel/2), false)
				end
				if mainAssets.__cars[player.selectedCar].effects then
					mainAssets.__cars[player.selectedCar].effects(name)
				end
			end
		end
		if room.currentGameHour%15 == 0 then
			updateHour()
		elseif room.currentGameHour == 1440 then
			room.currentGameHour = 0
		end

		gardening()
	end
	if ROOM.uniquePlayers >= room.requiredPlayers then
		if room.isInLobby then	
			genMap()
			ui.removeTextArea(0, nil)
			ui.removeTextArea(1, nil)
		end
	else
		if not room.isInLobby then
			genLobby()
			ui.removeTextArea(0, nil)
			ui.removeTextArea(1, nil)
		end
	end
end)