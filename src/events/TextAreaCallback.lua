onEvent("TextAreaCallback", function(id, player, callback, serverRequest)
	if room.isInLobby then return end
	local playerData = players[player]
	if not playerData then return end
	if not serverRequest then 
		if players[player].lastCallback.when > os.time()-1000 then 
			return 
		end
	end
	players[player].lastCallback.when = os.time()

	local args = {}
    for i in callback:gmatch('[^_]+') do
        args[#args+1] = i
    end
	-------------- REWRITTEN PART
	local event = table.remove(args, 1)
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
		for i = 876, 995 do
			ui.removeTextArea(ui_ID..i, player)
		end
		player_removeImages(playerData._modernUIImages[ui_ID])
		if args[3] ~= 'errorUI' then
			for i = 1, #playerData._modernUISelectedItemImages do
				player_removeImages(playerData._modernUISelectedItemImages[i])
			end
			if args[3] == 'configMenu' then
				loadMap(player)
				HouseSystem.new(player):loadTerrains()
				savedata(player)
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
					ui.removeTextArea(i, player)
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
			if math.hypo(npcRange[1], npcRange[2], location.x, location.y) <= 60 then
				local npcName = npcRange[3]
				local order = gameNpcs.orders.orderList[npcName]
				if order and order.fulfilled[player] then 
					if not order.fulfilled[player].completed then 
						if checkItemQuanty(order.order, 1, player) then 
							removeBagItem(order.order, 1, player)
							job_updatePlayerStats(player, 9)
							order.fulfilled[player].completed = true
							for i = 1, #order.fulfilled[player].icons do 
								removeImage(order.fulfilled[player].icons[i])
							end 
							local sidequest = sideQuests[players[player].sideQuests[1]].type
							if string.find(sidequest, 'type:deliver') then
								sideQuest_update(player, 1)
							end
							giveExperiencePoints(player, 200)
							giveCoin(bagItems[order.order].orderValue, player, true)
							TFM.chatMessage('<j>'..translate('orderCompleted', player):format('<CE>'..npcName..'</CE>', '<vp>$'..bagItems[order.order].orderValue..'</vp>', player), player)
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
		if math.hypo(x, y, blockData.x, blockData.y) <= Mine.blockLength+Mine.blockLength/2 and not blockData.removed then 
			blockData.life[1] = blockData.life[1] + hit
			mine_updateBlockLife(blockID)
			if blockData.life[1] >= blockData.life[2] then 
				player_removeImages(blockData.images)
				if blockData.ore then 
					player_removeImages(blockData.oreImages)
					for i = 1, 4 do
						item_drop('crystal_'..blockData.ore, {x = blockData.x - 50 + (i-1)*20, y = blockData.y + 3})
					end
				end
				Mine.blocks[blockID].removed = true
				Mine.availableRocks[blockID] = false
				for i = 0, 10 do 
					ui.removeTextArea(blockID..(40028922+i))
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
	---------- TO REWRITE 
	if callback:sub(1,4) == 'BUY_' then
		local item = callback:sub(5)
		local complement = tonumber(item) and '' or '-'
		local y = complement == '-' and 110 or 250
		showPopup(5, player, nil, '', 400 - 250 *0.5, 200 - y * 0.5, 250, y, false, '9_'..complement ..item)
	---------- ENTRAR NOS LOCAIS ---------
	elseif callback:sub(1,6) == 'enter_' then
		local place = callback:sub(7)
		eventTextAreaCallback(102, player, 'close3_1', true)
		if checkGameHour(places[place].opened) or places[place].opened == '-' then
			TFM.movePlayer(player, places[place].tp[1], places[place].tp[2], false)
			players[player].place = place
			if place == "dealership" then
				showCarShop(player)
			elseif place == 'police' then
				if players[player].questLocalData.other.goToPolice then
					quest_updateStep(player)
				end
			elseif place == 'bank' then
				if players[player].questLocalData.other.goToBank then
					quest_updateStep(player)
				end
			elseif place == 'hospital' then
				if players[player].robbery.robbing then return end

				loadHospital(player, false)
				if players[player].questLocalData.other.goToHospital then
					quest_updateStep(player)
				end
			elseif place == 'seedStore' then
				if players[player].questLocalData.other.goToSeedStore then
					quest_updateStep(player)
				end
			elseif place == 'market' then
				if players[player].questLocalData.other.goToMarket then
					quest_updateStep(player)
				end
			end
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
		if math.hypo(x, y, calc, 188 + (andar > 0 and 3000 or 3400)) <= 150 then
			sendMenu(33, player, '<font size="15"><p align="center"><j>'..translate('elevator', player)..'</j></p><br><p align="center"><textformat leading="4"><b><rose><a href="event:andar4">4<br><a href="event:andar3">3<br><a href="event:andar2">2<br><a href="event:andar1">1<br><a href="event:andar0">P<br>', 390 - 200 *0.5, 160, 200, 170, 1, false, '', false, false, false, 11)
		end
	-----------SAIR DOS LOCAIS--------------
	elseif callback:sub(1, 7) == 'getOut_' then
		local place = callback:sub(8)
		if ROOM.playerList[player].x > places[place].clickDistance[1][1] and ROOM.playerList[player].x < places[place].clickDistance[1][2] and ROOM.playerList[player].y > places[place].clickDistance[2][1] and ROOM.playerList[player].y < places[place].clickDistance[2][2] then
			players[player].place = 'town'
			TFM.movePlayer(player, places[place].town_tp[1], places[place].town_tp[2], false)
		end
		eventTextAreaCallback(0, player, 'close3_5', true)
		showOptions(player)
		checkIfPlayerIsDriving(player)
		if place == 'bank' then 
			if room.bankBeingRobbed then
				local shield = addImage('1566af4f852.png', '$'..player, -45, -45)
				players[player].robbery.usingShield = true
				addTimer(function()
					removeImage(shield)
					players[player].robbery.usingShield = false
				end, 7000, 1)
			end
		end
	-----------RESGATAR CODIGOS--------------
	elseif callback == 'enterCode' then
		players[player].codigo = {}
		showPopup(1, player, nil, '\n\n'..translate('codeInfo', player), 400 - 300 *0.5, 95, 300, 215, true, 10, '', true)
		ui.addTextArea(1897, '<V><p align="center"><font size="13">'..translate('code', player), player, 400 - 300 *0.5, 120, 300, 20, 0x314e57, 0x314e57, 0.8, true)
	elseif callback == 'getCode' then
		local code = table.concat(players[player].codigo, '')
		players[player].codigo = {}
		if codes[code] then
			for i, v in next, players[player].receivedCodes do
				if v == codes[code].id then
					ui.addTextArea(1897, '<R><p align="center"><font size="13">'..translate('codeAlreadyReceived', player), player, 400 - 300 *0.5, 120, 300, 20, 0x314e57, 0x314e57, 0.8, true)
					return
				end
			end
			if codes[code].available then
				if codes[code].level then 
					if codes[code].level > players[player].level[1] then
						return alert_Error(player, 'error', 'codeLevelError', codes[code].level)
					end
				end
				eventTextAreaCallback(102, player, 'close3_1', true)
				players[player].receivedCodes[#players[player].receivedCodes+1] = codes[code].id
				codes[code].reward(player)
				return
			else
				ui.addTextArea(1897, '<R><p align="center"><font size="13">'..translate('codeNotAvailable', player), player, 400 - 300 *0.5, 120, 300, 20, 0x314e57, 0x314e57, 0.8, true)
				return
			end
		else
			ui.addTextArea(1897, '<R><p align="center"><font size="13">'..translate('incorrect', player), player, 400 - 300 *0.5, 120, 300, 20, 0x314e57, 0x314e57, 0.8, true)
		end
	elseif callback == 'getDiscordLink' then
		TFM.chatMessage('<rose>'..room.discordServerUrl, player)
	elseif callback:sub(1, 9) == 'keyboard_' then
		local key = callback:sub(10)
		if #players[player].codigo <= 14 then
			players[player].codigo[#players[player].codigo+1] = key
		end
		ui.addTextArea(1897, '<V><p align="center"><font size="13">'..table.concat(players[player].codigo, ''), player, 400 - 300 *0.5, 120, 300, 20, 0x314e57, 0x314e57, 0.8, true)
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
			ui.removeTextArea(id..i, player)
		end
		for i = 1, 13 do
			ui.removeTextArea(id..(889+(i-1)*14), player)
			ui.removeTextArea(id..(890+(i-1)*14), player)
		end
		player_removeImages(players[player].callbackImages)
	elseif callback == 'getVaultPassword' then
		if math.hypo(ROOM.playerList[player].x, ROOM.playerList[player].y, room.bank.paperPlaces[room.bank.paperCurrentPlace].x, room.bank.paperPlaces[room.bank.paperCurrentPlace].y) <= 80 then
			alert_Error(player, 'password', '<p align="center">'..room.bankVaultPassword:sub(1, 3)..'_')
		end
	elseif callback == 'lever' then
		if room.bankBeingRobbed then
			if room.bankRobStep == 'lazers' then
				if math.hypo(5988, 4940, ROOM.playerList[player].x, ROOM.playerList[player].y) <= 100 then
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
						ui.addTextArea(-510, '<a href="event:insertVaultPassword_">'..string.rep('\n', 10), nil, 5785, 4715, 30, 70, 1, 1, 0)
					else
						alert_Error(player, 'error', 'mouseSizeError')
					end
				end
			end
		end
	--------- Bag -----------
	elseif callback:sub(1, 10) == 'buyBagItem' then
		local item = callback:sub(12)
		local checker = callback:sub(11, 11)
		if checker == '_' then
			if item == 'bag' then
				if players[player].bagLimit < 45 then
					players[player].bagLimit = players[player].bagLimit + 5
					giveCoin(-bagItems[item].price, player)
				end
			else
				addItem(item, 1, player, bagItems[item].price)
			end
			for id, properties in next, playerData.questLocalData.other do 
				if id:find('BUY_') then
					if id:lower():find(item:lower()) then 
						if type(properties) == 'boolean' then 
							quest_updateStep(player)
						else 
							playerData.questLocalData.other[id] = properties - 1
							if playerData.questLocalData.other[id] == 0 then 
								quest_updateStep(player)
							end
						end
						break
					end
				end
			end
			showPopup(5, player, nil, '', 400 - 250 *0.5, 200 - (players[player].shopMenuHeight * 0.5), 250, players[player].shopMenuHeight, false, '9_'..players[player].shopMenuType)
		else
			if bagItems[item].type2 and bagItems[item].type2:find('limited-') then
				if not checkItemQuanty(coins[bagItems[item].type2], 1, player) then return end
				if checkItemQuanty(coins[bagItems[item].type2], 1, player) < bagItems[item].qpPrice then return end
				removeBagItem(coins[bagItems[item].type2], bagItems[item].qpPrice, player)
				addItem(item, 1, player, 0)
				eventTextAreaCallback(0, player, 'closebag', true)
			else
				if players[player].sideQuests[4] < bagItems[item].qpPrice then return end
				players[player].sideQuests[4] = players[player].sideQuests[4] - bagItems[item].qpPrice
				addItem(item, 1, player, 0)
				eventTextAreaCallback(0, player, 'closebag', true)
			end
		end
		savedata(player)			
	elseif callback == 'closebag' then
		ui.removeTextArea(2040, player)
		eventTextAreaCallback(0, player, 'close2', true)
		for i = 0, 9 do
			closeMenu(99+i, player)
		end
	elseif callback == 'upgradeBag' then
		showPopup(5, player, nil, '', 400 - 250 *0.5, 200 - 110 * 0.5, 250, 110, false, '9_6')
	--------------- HOUSES ----------------------
	elseif callback:sub(1,8) == 'harvest_' then
		local id = tonumber(callback:sub(9))
		local owner = player
		if string.find(players[player].place, 'house_') then
			local house_ = tonumber(players[player].place:sub(7))
			if house_ == 11 then
				owner = 'Oliver'
			end
		end
		if players[owner].houseTerrainPlants[id] == 0 then return end
		local crop = houseTerrainsAdd.plants[players[owner].houseTerrainPlants[id]]

		for id, properties in next, players[player].questLocalData.other do 
			if id:lower():find(crop.name) then 
				quest_updateStep(player)
			end
		end
		if players[owner].houseTerrainAdd[id] == #crop.stages then
			addItem(crop.name..'Seed', crop.quantyOfSeeds, player)
			addItem(crop.name, crop.quantyOfSeeds, player)
			ui.removeTextArea('-730'..(id..tonumber(players[owner].houseData.houseid)*10), nil)
			players[owner].houseTerrainAdd[id] = 1
			players[owner].houseTerrainPlants[id] = 0
			HouseSystem.new(owner):genHouseGrounds()
			savedata(player)
			if players[player].job == 'farmer' then
				job_updatePlayerStats(player, 5)
				giveExperiencePoints(player, 250)
			end
		end
	elseif callback == 'recipes' then
		if players[player].selectedItem.image then
			removeImage(players[player].selectedItem.image)
			players[player].selectedItem.image = nil
		end
		sendMenu(99, player, '<p align="center"><font size="16">'.. translate('recipes', player), 400 - 465 *0.5, 10, 445, 300, 1, false, 1, false, false, false, 18)
		ui.addTextArea(2040, '<p align="center"><font size="15" color="#ff0000"><a href="event:closebag"><b>X', player, 590, 30, 60, 50, 0x122528, 0x122528, 0, true)
	elseif callback:sub(1, 11) == 'showRecipe_' then
		if players[player].selectedItem.images[1] then
			for i, v in next, players[player].selectedItem.images do
				removeImage(players[player].selectedItem.images[i])
			end
			players[player].selectedItem.images = {}
		end
		if players[player].selectedItem.image then
			removeImage(players[player].selectedItem.image)
			players[player].selectedItem.image = nil
		end
		local item = callback:sub(12)

		ui.addTextArea(99106, '<p align="center"><CE>'..translate('item_'..item, player), player, 500, 85, 110, 190, 0x24474D, 0x314e57, 1, true)
		local canCook = true
		local counter = 0
		for i, v in next, recipes[item].require do
			counter = counter + 1
			players[player].selectedItem.images[#players[player].selectedItem.images+1] = addImage(bagItems[i].png, "&70", ((counter-1)%2)*55+485, math.floor((counter-1)/2)*30+160, player)
			if checkItemQuanty(i, v, player) then
				ui.addTextArea(99106+counter, '<vp>'..v, player, ((counter-1)%2)*55+530, math.floor((counter-1)/2)*30+177, nil, nil, 0x24474D, 0xff0000, 0, true)
			else
				ui.addTextArea(99106+counter, '<r>'..v, player, ((counter-1)%2)*55+530, math.floor((counter-1)/2)*30+177, nil, nil, 0x24474D, 0xff0000, 0, true)
			end
		end
		for i, v in next, recipes[item].require do
			if not checkItemQuanty(i, v, player) then
				canCook = false
				break
			end
		end
		if canCook then
			addButton(99096, '<a href="event:cook_'..item..'">'..translate('cook', player), player, 500, 240+40, 110, 10)
		else
			addButton(99096, translate('cook', player), player, 500, 240+40, 110, 10, true)
		end
		players[player].selectedItem.images[#players[player].selectedItem.images+1] = addImage(bagItems[item].png and bagItems[item].png or '16bc368f352.png', "&70", 530, 120, player)
	elseif event == 'cook' then
		local item = args[1]
		for i, v in next, recipes[item].require do
			if not checkItemQuanty(i, v, player) then return end
			removeBagItem(i, v, player)
		end
		eventTextAreaCallback(0, player, 'closebag', true)
		sendMenu(99, player, '', 400 - 120 * 0.5, (300 * 0.5), 100, 100, 1, true)
		addItem(item, 1, player)
		players[player].images[#players[player].images+1] = addImage(bagItems[item].png and bagItems[item].png or '16bc368f352.png', "&70", 400 - 50 * 0.5, 180, player)

		if players[player].job == 'chef' then
			job_updatePlayerStats(player, 10)
		end

		local sidequest = sideQuests[players[player].sideQuests[1]].type
		if sidequest == 'type:cook' or string.find(sidequest, item) then
			sideQuest_update(player, 1)
		end

		for id, properties in next, playerData.questLocalData.other do 
			if id:find('cook') then
				if id:lower():find(item:lower()) then 
					if type(properties) == 'boolean' then 
						quest_updateStep(player)
					else 
						playerData.questLocalData.other[id] = properties - 1
						if playerData.questLocalData.other[id] == 0 then 
							quest_updateStep(player)
						end
					end
					break
				end
			end
		end
	elseif callback:sub(1, 15) == 'joiningMessage_' then
		local type = callback:sub(16)
		player_removeImages(players[player].joinMenuImages)
		local currentVersion = 'v'..table.concat(version, '.')
		players[player].joinMenuImages = {}
		if type == 'close' then
			ui.removeTextArea(20880, player)
			eventTextAreaCallback(0, player, 'close2', true)
			removeImage(players[player].bannerLogin)
			system.loadPlayerData(player)
			mine_drawGrid(mine_optimizeGrid(grid, grid_width, grid_height), 60, Mine.position[1], Mine.position[2])
			addImage("170fef3117d.png", ":1", 660, 365, player)
			ui.addTextArea(999997, "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', 4), player, 660, 365, 35, 35, 0x324650, 0x000000, 0, true, function(player) openProfile(player) end)

			addImage("170f8773bcb.png", ":2", 705, 365, player)
			ui.addTextArea(999998, "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', 4), player, 705, 365, 35, 35, 0x324650, 0x000000, 0, true, function(player) modernUI.new(player, 310, 280, translate('questsName', player)):build():questInterface() end)

			addImage("170f8ccde22.png", ":3", 750, 365, player)
			ui.addTextArea(999999, "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', 4), player, 750, 365, 35, 35, 0x324650, 0x000000, 0, true, function(player) modernUI.new(player, 520, 300, nil, nil, 'configMenu'):build():showSettingsMenu() end)

		elseif type == 'next' then
			if players[player].joinMenuPage < versionLogs[currentVersion].maxPages then
				players[player].joinMenuPage = players[player].joinMenuPage + 1
			end
			sendMenu(99, player, '<p align="center"><font size="16"><vp>'..currentVersion..'</vp> - '.. translate('$VersionName', player) ..'</font>', 400 - 620 *0.5, 200 - 320*0.5, 600, 300, 1, false, 1, false, false, false, 15)
		elseif type == 'back' then
			if players[player].joinMenuPage > 1 then
				players[player].joinMenuPage = players[player].joinMenuPage - 1
			end
			sendMenu(99, player, '<p align="center"><font size="16"><vp>'..currentVersion..'</vp> - '.. translate('$VersionName', player) ..'</font>', 400 - 620 *0.5, 200 - 320*0.5, 600, 300, 1, false, 1, false, false, false, 15)
		end			
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
		ui.removeTextArea(1020, player)
		for i = v..'001', v..'012' do
			ui.removeTextArea(i, player)
		end
	------------------ NPCS ------------------
	elseif callback == 'NPC_coffeeShop' then
		showPopup(5, player, nil, '', 400 - 250 *0.5, 200 - 250 * 0.5, 250, 250, false, '9_5')
	----------------- QUESTS -----------------			
	elseif callback:sub(1,6) == 'Quest_' then
		if callback:sub(7, 8) == '02' then
			if callback:sub(10) == 'key' then
				if players[player].questStep[2] == 3 then
					if math.hypo(ROOM.playerList[player].x, ROOM.playerList[player].y, 1405, 8758) <= 50 then
						quest_updateStep(player)
					end
				elseif players[player].questStep[2] == 6 then
					if math.hypo(ROOM.playerList[player].x, ROOM.playerList[player].y, 1635, 8820) <= 50 then
						quest_updateStep(player)
					end
				end
			end
		elseif callback:sub(7, 8) == '03' then
			if callback:sub(10) == 'cloth' then
				if players[player].questStep[2] == 7 then
					if math.hypo(ROOM.playerList[player].x, ROOM.playerList[player].y, 5700, 4990) <= 50 then
						quest_updateStep(player)
					end
				end
			elseif callback:sub(10) == 'paper' then
				if players[player].questStep[2] == 12 then
					if math.hypo(ROOM.playerList[player].x, ROOM.playerList[player].y, 6250, 3250) <= 50 then
						quest_updateStep(player)
					end
				end
			end
		end
	----------------- CLOSE ------------------
	elseif callback == 'close2' then
		closeMenu(99, player)
		for i = 7850, 7900 do
			ui.removeTextArea(i, player)
		end
		for i = 99000, 99140 do
			ui.removeTextArea(i, player)
		end
		ui.removeTextArea(990000000000001, player)
		ui.removeTextArea(990000000000002, player)
		ui.removeTextArea(990000000000003, player)

		local _callbackImages = playerData.callbackImages
		local _selectedItemImage = playerData.selectedItem.image
		local _selectedItemImages = playerData.selectedItem.images
		if _callbackImages[1] then
			for i = 1, #_callbackImages do
				removeImage(_callbackImages[i])
			end
			players[player].callbackImages = {}
		end
		if _selectedItemImage then
			removeImage(_selectedItemImage)
			players[player].selectedItem.image = nil
		end
		if _selectedItemImages[1] then
			for i = 1, #_selectedItemImages do
				removeImage(_selectedItemImages[i])
			end
			players[player].selectedItem.images = {}
		end
	elseif callback:sub(0,6) == 'fechar' then
		id = callback:sub(8)
		closeMenu(id, player)
	elseif callback == 'close' then
		for i = 100, 120 do
			ui.removeTextArea(i, player)
		end
	elseif callback:sub(0,6) == 'Fechar' then
		id = callback:sub(8)
		closeMenu(id, player)
		ui.removeTextArea(1019, player)
		ui.removeTextArea(100, player)
		ui.removeTextArea(101, player)
		ui.removeTextArea(102, player)
	elseif callback:sub(0,7) == 'close3_' then
		for i = 879,940 do
			ui.removeTextArea(callback:sub(8)..i, player)
		end
		if players[player].callbackImages[1] then
			for i, v in next, players[player].callbackImages do
				removeImage(players[player].callbackImages[i])
			end
			players[player].callbackImages = {}
		end
		job_updatePlayerStats(player, 1, 0)
	--------------------------------------------
	elseif callback == 'confirmPosition' then
		if not players[player].holdingItem then return end
		local item = players[player].holdingItem
		local x = ROOM.playerList[player].x
		local y = ROOM.playerList[player].y
		local seed = nil
		local seedToDrop = item
		if string.find(item, 'Seed') then
			for i, v in next, houseTerrainsAdd.plants do
				if string.find(item, v.name) then
					seedToDrop = item
					item = 'seed'
					seed = i
				end
			end
		end
		if not bagItems[item].placementFunction(player, x, y, seed) then
			if not seedToDrop then return end
			addItem(seedToDrop, 1, player)
			eventTextAreaCallback(0, player, 'closebag', true)
		else 
			for id, properties in next, players[player].questLocalData.other do 
				if id:find('plant_') then 
					if id:lower():find(seedToDrop:lower()) then
						quest_updateStep(player)
					end
				end
			end
		end
		players[player].holdingDirection = nil
		removeImage(players[player].holdingImage)
		players[player].holdingImage = nil
		players[player].holdingItem = false
		ui.removeTextArea(9901327, player)
		ui.removeTextArea(98900000019, player)
		showOptions(player)
		savedata(player)		
	end
end)