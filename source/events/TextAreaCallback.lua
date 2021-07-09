onEvent("TextAreaCallback", function(id, player, callback, serverRequest)
	if player and isExploiting[player] then return end
	if room.isInLobby then return end
	local playerData = players[player]
	if not playerData then return end
	if not serverRequest then
		if players[player].lastCallback.when > os_time()-500 then
			if players[player].lastCallback.when > os_time()-50 then
				players[player].lastCallback.when = os_time()
			end
			return
		end
	end
	players[player].lastCallback.when = os_time()

	local args = {}
	for i in callback:gmatch('[^_]+') do
		args[#args+1] = i
	end
	-------------- REWRITTEN PART
	local event = table_remove(args, 1)
	if event == 'changePage' then
		local menu = args[1]
		local button = args[2]
		local totalPages = tonumber(args[3])
		local callbackPage = players[player]
		if button == 'next' then
			if callbackPage.callbackPages[menu] > totalPages then return end
			players[player].callbackPages[menu] = callbackPage.callbackPages[menu] + 1
		else
			if callbackPage.callbackPages[menu] > 1 then
				players[player].callbackPages[menu] = callbackPage.callbackPages[menu] - 1
			end
		end

		eventTextAreaCallback(0, player, menu, true)
	elseif event == 'modernUI' then
		if args[1] == 'ButtonAction' then
			local action = playerData._modernUIHistory[tonumber(args[2])][tonumber(args[3])]
			action.toggleEvent(player, action.args)
			if action.warningUI then return end
		elseif args[1] == 'CallbackEvent' then
			return playerData._modernUIOtherCallbacks[tonumber(args[2])].event(player, playerData._modernUIOtherCallbacks[tonumber(args[2])].callbacks)
		end

		local ui_ID = tonumber(args[2])
		for i = 870, 1200 do
			removeTextArea(ui_ID..i, player)
		end
		removeGroupImages(playerData._modernUIImages[ui_ID])

		if args[3] ~= 'errorUI' then
			for i = 1, #playerData._modernUISelectedItemImages do
				removeGroupImages(playerData._modernUISelectedItemImages[i])
			end
			if args[3] == 'configMenu' then
				loadMap(player)
				HouseSystem.new(player):loadTerrains()
				savedata(player)
			end
		end

		local shortcutGui = args[4] or ''
		if shortcutGui ~= '' then
			if players[player][shortcutGui..'_isOpen'] then
				players[player][shortcutGui..'_isOpen'] = nil
			end
		end
	elseif event == 'npcDialog' then
		if args[1] == 'nextPage' then
			local npc = args[2]
			local npcID = tonumber(args[3])
			local isQuest = args[4]
			local currentPage = tonumber(args[5])
			local dialog = false
			local lang = playerData.lang
			if isQuest ~= 'not' then
				dialog = npcDialogs
					.quests
					  [lang]
						[playerData.questStep[1]]
						 [playerData.questStep[2]]
						  [currentPage]
			else
				dialog = dialogs[player].text[currentPage]
			end
			if dialog then
				dialogs[player].running = true
			else
				for i = -88002, -88000 do
					removeTextArea(i, player)
				end
				for i = 1, #players[player]._npcDialogImages do
					removeImage(players[player]._npcDialogImages[i])
				end
				players[player]._npcDialogImages = {}
				if playerData._npcsCallbacks.ending[npcID] then
					playerData._npcsCallbacks.ending[npcID].callback(player)
				end
				if isQuest ~= 'not' then
					quest_updateStep(player)
				end
			end
		elseif args[1] == 'skipAnimation' then
			dialogs[player].length = 1000
		elseif args[1] == 'talkWith' then
			local npcID = tonumber(args[2])
			local location = ROOM.playerList[player]
			local npcRange = playerData._npcsCallbacks.clickArea[npcID]
			if math_hypo(npcRange[1], npcRange[2], location.x, location.y) <= 60 then
				local npcName = npcRange[3]
				local order = gameNpcs.orders.orderList[npcName]
				if order and order.fulfilled[player] then
					if not order.fulfilled[player].completed then
						if checkItemAmount(order.order, 1, player) then
							removeBagItem(order.order, 1, player)
							order.fulfilled[player].completed = true
							
							removeGroupImages(order.fulfilled[player].icons)
							local reactions = {'17537c7a6ea.png', '17537c7c444.png', '17537c7dd86.png'}
							local npcEmoji = addImage(reactions[random(#reactions)], '!100', npcRange[1]-50, npcRange[2]-70, player)
							addTimer(function(time)
								removeImage(npcEmoji)
							end, 2000, 0)

							job_updatePlayerStats(player, 9)
							sideQuest_sendTrigger(player, 'deliver', 1)

							for id, properties in next, players[player].questLocalData.other do 
								if id:find('deliverOrder') then
									if type(properties) == 'boolean' then 
										quest_updateStep(player)
									else
										players[player].questStep[3] = players[player].questStep[3] - 1
										players[player].questLocalData.other[id] = players[player].questStep[3]
										if players[player].questLocalData.other[id] == 0 then 
											quest_updateStep(player)
										end
									end
									break
								end
							end

							giveExperiencePoints(player, 200)
							giveCoin(bagItems[order.order].sellingPrice, player, true)
							chatMessage('<j>'..translate('orderCompleted', player):format('<CE>'..npcName..'</CE>', '<vp>$'..bagItems[order.order].sellingPrice..'</vp>', player), player)
							return
						end
					end
				end
				if playerData._npcsCallbacks.starting[npcID] then
					playerData._npcsCallbacks.starting[npcID].callback(player)
				else
					local npc = args[3]
					local png = args[4]
					local questDialog = args[5]
					gameNpcs.talk({name = npc, image = png, npcID = npcID, questDialog = questDialog}, player)
				end
			end
		end
	elseif event == 'collectDroppedItem' then
		item_collect(tonumber(args[1]), player)
	elseif event == 'updateBlock' then
		local blockID = tonumber(args[1])
		local blockData = Mine.blocks[blockID]
		local x = tfm.get.room.playerList[player].x
		local y = tfm.get.room.playerList[player].y
		local hit = 1
		if math_hypo(x, y, blockData.x, blockData.y) <= Mine.blockLength+Mine.blockLength/2 and not blockData.removed then
			blockData.life[1] = blockData.life[1] + hit
			mine_updateBlockLife(blockID)
			if blockData.life[1] >= blockData.life[2] then
				removeGroupImages(blockData.images)
				if blockData.ore then
					removeGroupImages(blockData.oreImages)
					for i = 1, 4 do
						item_drop('crystal_'..blockData.ore, {x = blockData.x - 50 + (i-1)*20, y = blockData.y + 3})
					end
				end
				Mine.blocks[blockID].removed = true
				Mine.availableRocks[blockID] = false
				for i = 0, 10 do
					removeTextArea(blockID..(40028922+i))
				end

				local xx = Mine.blocks[blockID].column
				local yy = Mine.blocks[blockID].line
				for i = 1, #groundIDS do
					removeGround(groundIDS[i])
				end
				groundIDS = {}
				grid_height = mine_removeBlock(grid, grid_width, grid_height, xx, yy)
				mine_drawGrid(mine_optimizeGrid(grid, grid_width, grid_height), 60, Mine.position[1], Mine.position[2])
				mine_generateBlockAssets(blockID)
			end
		end
	elseif event == 'buyhouse' then
		local terrain = tonumber(args[1])
		modernUI.new(player, 520, 300, translate('houses', player))
			:build()
			:showHouses(terrain)
	elseif event == 'joinHouse' then
		if playerData.robbery.robbing then return end
		local id = tonumber(args[1])
		local terrainData = room.terrains[id]
		if not terrainData.owner then return end
		if not terrainData.settings.permissions[player] then terrainData.settings.permissions[player] = 0 end
		if terrainData.settings.permissions[player] == -1 then return alert_Error(player, 'error', 'error_blockedFromHouse', terrainData.owner) end
		if players[terrainData.owner].editingHouse then return alert_Error(player, 'error', 'error_houseUnderEdit', terrainData.owner) end
		if terrainData.settings.isClosed and terrainData.settings.permissions[player] == 0 then
			return alert_Error(player, 'error', 'error_houseClosed', terrainData.owner)
		end
		goToHouse(player, id)
	end
	if playerData.editingHouse then return end
	-----------------------------------------
	-----------------------------------------
	-------------- TO REWRITE ---------------
	-----------------------------------------
	-----------------------------------------
	if callback:sub(1,6) == 'enter_' then
		local place = callback:sub(7)
		local placeData = places[place]
		eventTextAreaCallback(102, player, 'close3_1', true)
		if checkGameHour(places[place].opened) or places[place].opened == '-' then
			for i, v in next, players[player].questLocalData.other do
				if i:lower():find(place:lower()) and i:find('goTo') then
					quest_updateStep(player)
				end
			end
			if place == "dealership" then
				showCarShop(player)
			elseif place == 'hospital' then
				if players[player].robbery.robbing then return end
				loadHospital(player, false)
			end
			if players[player].questLocalData.other.goToIsland and room.event:find('christmas') then
				quest_updateStep(player)
			end
			if placeData.exitSensor then
				movePlayer(
					player, 
					placeData.exitSensor[1] + (placeData.spawnAtLeft and -55 or 40), 
					placeData.exitSensor[2], 
					false
				)
			else
				movePlayer(
					player,
					places[place].tp[1],
					places[place].tp[2],
					false
				)
			end
			players[player].place = place
			showOptions(player)
			checkIfPlayerIsDriving(player)
		else
			alert_Error(player, 'timeOut', 'closed_'..place)
		end
	elseif callback == 'elevator' then
		if players[player].hospital.hospitalized then return end
		local andar = players[player].hospital.currentFloor
		local calc = ((andar-1)%andar)*900+4388
		local x = ROOM.playerList[player].x
		local y = ROOM.playerList[player].y
		if math_hypo(x, y, calc, 188 + (andar > 0 and 3000 or 3400)) <= 150 then
			sendMenu(33, player, '<font size="15"><p align="center"><j>'..translate('elevator', player)..'</j></p><br><p align="center"><textformat leading="4"><b><rose><a href="event:andar4">4<br><a href="event:andar3">3<br><a href="event:andar2">2<br><a href="event:andar1">1<br><a href="event:andar0">P<br>', 390 - 200 *0.5, 160, 200, 170, 1, false, '', false, false, false, 11)
		end
	elseif callback == 'getDiscordLink' then
		chatMessage('<rose>'..room.discordServerUrl, player)
	-----------BANK-------------
	elseif callback:sub(1,20) == 'insertVaultPassword_' then
		local digit = callback:sub(21)
		if digit then
			if digit == '*' then
				players[player].bankPassword = nil
			elseif digit == '#' then
				if players[player].bankPassword then
					if #players[player].bankPassword < 1 then return end
					players[player].bankPassword = players[player].bankPassword:sub(1, #players[player].bankPassword-1)
				end
			else
				if players[player].bankPassword then
					players[player].bankPassword = players[player].bankPassword .. digit
				else
					players[player].bankPassword = digit
				end
			end
		end
		showPopup(1, player, '', '', 400 - 100 *0.5, 200 - 150*0.5, 100, 180, false, 18, '', true)
	elseif callback == 'closeVaultPassword' then
		local id = 1
		for i = 869, 940 do
			removeTextArea(id..i, player)
		end
		for i = 1, 13 do
			removeTextArea(id..(889+(i-1)*14), player)
			removeTextArea(id..(890+(i-1)*14), player)
		end
		removeGroupImages(players[player].callbackImages)
	elseif callback == 'getVaultPassword' then
		if math_hypo(ROOM.playerList[player].x, ROOM.playerList[player].y, room.bank.paperPlaces[room.bank.paperCurrentPlace].x, room.bank.paperPlaces[room.bank.paperCurrentPlace].y) <= 80 then
			alert_Error(player, 'password', '<p align="center">'..room.bankVaultPassword:sub(1, 3)..'_')
		end
	elseif callback == 'lever' then
		if room.bankBeingRobbed then
			if room.bankRobStep == 'lazers' then
				if math_hypo(5988, 4940, ROOM.playerList[player].x, ROOM.playerList[player].y) <= 100 then
					if players[player].mouseSize >= 1 then
						room.bankRobStep = 'puzzle1'
						removeImage(room.bankDoors[4])
						removeImage(room.bankDoors[3])
						removeImage(room.bankDoors[5])
						room.bankDoors[4] = addImage("16bb98ddd7d.png", "!38", 5988, 4930) -- lever
						addGround(9994, 809+5000, 320+4555, {type = 14, width = 25, height = 130})
						removeGround(9996) -- lazer
						removeGround(9995) -- lazer
						addGround(9997, 260+5000, 105+4555, {type = 14, width = 25, height = 130})
						removeImage(room.bankDoors[2])
						showTextArea(-510, '<a href="event:insertVaultPassword_">'..string.rep('\n', 10), nil, 5785, 4715, 30, 70, 1, 1, 0)
					else
						alert_Error(player, 'error', 'mouseSizeError')
					end
				end
			end
		end
	--------- Bag -----------
	elseif callback == 'closebag' then
		removeTextArea(2040, player)
		for i = 0, 9 do
			closeMenu(99+i, player)
		end
	elseif callback == 'upgradeBag' then
		showPopup(5, player, nil, '', 400 - 250 *0.5, 200 - 110 * 0.5, 250, 110, false, '9_6')
	--------------- HOUSES ----------------------
	elseif callback:sub(1,8) == 'harvest_' then
		local id = tonumber(callback:sub(9))
		local owner = player
		if string_find(players[player].place, 'house_') then
			local house_ = tonumber(players[player].place:sub(7))
			if house_ == 12 then
				owner = 'Oliver'
			end
		end
		if players[owner].houseTerrainPlants[id] == 0 then return end
		local crop = HouseSystem.plants[players[owner].houseTerrainPlants[id]]

		for id, properties in next, players[player].questLocalData.other do
			if id:lower():find(crop.name) then
				quest_updateStep(player)
			end
		end
		if players[owner].houseTerrainAdd[id] == #crop.stages then
			addItem(crop.name..'Seed', crop.quantyOfSeeds, player)
			addItem(crop.name, crop.quantyOfSeeds, player)
			removeTextArea('-730'..(id..tonumber(players[owner].houseData.houseid)*10), nil)
			players[owner].houseTerrainAdd[id] = 1
			players[owner].houseTerrainPlants[id] = 0
			HouseSystem.new(owner):genHouseGrounds()
			savedata(player)
			sideQuest_sendTrigger(owner, "harvest", 1)
			if players[player].job == 'farmer' then
				job_updatePlayerStats(player, 5)
				giveExperiencePoints(player, owner == 'Oliver' and 12 or 50)
			end
		end
	elseif callback == 'recipes' then
		modernUI.new(player, 520, 300, translate('recipes', player))
			:build()
			:showRecipes()		
	elseif callback:sub(1,5) == 'andar' then
		if players[player].place ~= 'hospital' then eventTextAreaCallback(0, player, 'closeInfo_33', true) return end
		local i = tonumber(callback:sub(6))
		if i ~= players[player].hospital.currentFloor then
			if i ~= 0 then
				players[player].hospital.currentFloor = i
				loadHospitalFloor(player)
			else
				players[player].hospital.currentFloor = -1
				loadHospital(player, true)
			end
			eventTextAreaCallback(0, player, 'closeInfo_33', true)
		end
	elseif callback:sub(1,10) == 'closeInfo_' then
		local v = callback:sub(11)
		closeMenu(v, player)
		removeTextArea(1020, player)
		for i = v..'001', v..'012' do
			removeTextArea(i, player)
		end
	----------------- QUESTS -----------------
	elseif callback:sub(1,6) == 'Quest_' then
		if callback:sub(7, 8) == '02' then
			if callback:sub(10) == 'key' then
				if players[player].questStep[2] == 3 then
					if math_hypo(ROOM.playerList[player].x, ROOM.playerList[player].y, 1405, 8758) <= 50 then
						quest_updateStep(player)
					end
				elseif players[player].questStep[2] == 6 then
					if math_hypo(ROOM.playerList[player].x, ROOM.playerList[player].y, 1635, 8820) <= 50 then
						quest_updateStep(player)
					end
				end
			end
		elseif callback:sub(7, 8) == '03' then
			if callback:sub(10) == 'cloth' then
				if players[player].questStep[2] == 7 then
					if math_hypo(ROOM.playerList[player].x, ROOM.playerList[player].y, 5700, 4990) <= 50 then
						quest_updateStep(player)
					end
				end
			elseif callback:sub(10) == 'paper' then
				if players[player].questStep[2] == 12 then
					if math_hypo(ROOM.playerList[player].x, ROOM.playerList[player].y, 6250, 3250) <= 50 then
						quest_updateStep(player)
					end
				end
			end
		end
	----------------- CLOSE ------------------
	elseif callback:sub(0,6) == 'fechar' then
		id = callback:sub(8)
		closeMenu(id, player)
	elseif callback:sub(0,7) == 'close3_' then
		for i = 879,940 do
			removeTextArea(callback:sub(8)..i, player)
		end
		if players[player].callbackImages[1] then
			for i, v in next, players[player].callbackImages do
				removeImage(players[player].callbackImages[i])
			end
			players[player].callbackImages = {}
		end
		job_updatePlayerStats(player, 1, 0)
	end
end)