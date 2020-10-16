syncVersion = function(player, vs)
	if not vs then vs = {0} end
	local playerVersion = tonumber(table.concat(vs))
	local gameVersion = tonumber(table.concat(version))
	if playerVersion == 0 then
		for i = 1, players[player].questStep[1]-1 do
			quest_setNewQuest(player, i)
		end
	end
	if playerVersion <= 300 then
		if players[player].questStep[1] < 5 then
			if not lang['en'].quests[players[player].questStep[1]][players[player].questStep[2]] then
				quest_setNewQuest(player)
			end
		else
			players[player].questStep[1] = 5
			players[player].questStep[2] = 0
		end
	end
	local chest_Item = playerData:get(player, 'chestStorage')
	local chest_Quanty = playerData:get(player, 'chestStorageQuanty')

	players[player].houseData.chests.storage = {{}, {}, {}}
	players[player].totalOfStoredItems.chest[1] = 0
	players[player].totalOfStoredItems.chest[2] = 0
	players[player].totalOfStoredItems.chest[3] = 0

	if playerVersion < 300 then
		if type(chest_Item) ~= 'table' then
			for i, v in next, chest_Item do
				item_addToChest(bagIds[v].n, chest_Quanty[i], player, 1)
			end
		end
		savedata(player)
		players[player].gameVersion = 'v'..table.concat(version, '.')
		return
	end
	if playerVersion >= 300 then
		for counter = 1, 3 do
			if not chest_Item[counter] then 
				chest_Item[counter] = {} 
				chest_Quanty[counter] = {}
			end
			for i, v in next, chest_Item[counter] do
				item_addToChest(bagIds[v].n, chest_Quanty[counter][i], player, counter)
			end
		end
	end
	if playerVersion < 310 then
		chest_Item[3] = {}
		chest_Quanty[3] = {}
	end

	if playerVersion <= 320 then
		if table.contains(players[player].cars, 15) and not mainAssets.fileCopy._ranking:find(player) then
			TFM.chatMessage('<g>Due to an error, your season 3 rewards given incorrectly have been removed.', player)
			players[player].favoriteCars[1] = 0
			for i, v in next, players[player].cars do
				if v == 15 then
					table.remove(players[player].cars, i)
					break
				end
			end
			for i, v in next, players[player].starIcons.owned do
				if v == 4 then
					table.remove(players[player].starIcons.owned, i)
					players[player].starIcons.selected = 1
					break
				end
			end
			for i, v in next, players[player].badges do
				if v == 13 then
					table.remove(players[player].badges, i)
					break
				end
			end
			savedata(player)
		end

		local refund = 0
		local inBag = checkItemQuanty('luckyFlowerSeed', 1, player)
		if inBag then
			removeBagItem('luckyFlowerSeed', 50, player)
			refund = refund + inBag * 10000
		end

		local inChest = checkItemInChest('luckyFlowerSeed', 1, player)
		if inChest then
			item_removeFromChest('luckyFlowerSeed', inChest, player)
			refund = refund + inChest * 10000
		end
		for i = 1, 4 do
			if players[player].houseTerrainPlants[i] == 5 then
				players[player].houseTerrainPlants[i] = 0
				players[player].houseTerrainAdd[i] = 1
				refund = refund + 12000
			end
		end
		if refund > 0 then
			if refund > 50000 then refund = 50000 end
			giveCoin(refund, player)
			TFM.chatMessage('<r>Seems like you had at least 1 lucky flower seed in your bag/chest.\n<cs>A new lucky flower system has been added in V3.2.2 and it was needed to remove them from your bag.', player)
			TFM.chatMessage(string.format('<pt>You just received <fc>$%s</fc> as refund.', refund), player)
		end
		if players[player].spentCoins > 100000000 then 
			players[player].spentCoins = players[player].spentCoins - 100000000
		end
		players[player].houseTerrain[5] = 0
		players[player].houseTerrainAdd[5] = 1
		players[player].houseTerrainPlants[5] = 0
	end
	if playerVersion <= 322 then
		local inBag = checkItemQuanty('pumpkinSeed', 5, player)
		if inBag and players[player].jobs[7] <= 5 then
			removeBagItem('pumpkinSeed', 50, player)
			addItem('pumpkinSeed', 5, player)
		end
	end
	if playerVersion < 330 then
		if players[player].favoriteCars[1] == 9 then
			players[player].favoriteCars[1] = 0
		end
	end

	if players[player].seasonStats[1][1] ~= mainAssets.season then
		players[player].seasonStats[1][1] = mainAssets.season
		players[player].seasonStats[1][2] = 0
	end

	if mainAssets.fileCopy._ranking:find(player) then
		if not table.contains(players[player].starIcons.owned, 5) then
			giveBadge(player, 21)
			giveLevelOrb(player, 5)
		end
		giveCar(player, 16)
	end
	players[player].gameVersion = 'v'..table.concat(version, '.')
end

syncFiles = function()
	local bannedPlayers = {}
	local unrankedPlayers = {}

	for _, player in next, room.bannedPlayers do
		bannedPlayers[#bannedPlayers+1] = player..',0'
	end
	for _, player in next, room.unranked do
		unrankedPlayers[#unrankedPlayers+1] = player..',0'
	end

	system.saveFile(table.concat(bannedPlayers, ';')..'|'..table.concat(unrankedPlayers, ';')..'|'..table.concat(mainAssets.roles.admin, ';')..'|'..table.concat(mainAssets.roles.mod, ';')..'|'..table.concat(mainAssets.roles.helper, ';')..'|'..table.concat(mainAssets.roles.moduleTeam, ';'), 1)
end

saveGameData = function(bot)
	if not syncData.connected then return end
	sharpieData:set(bot, 'canUpdate', syncData.updating.updateMessage)
	sharpieData:save(bot)
end

syncGameData = function(data, bot)
	sharpieData:newPlayer(bot, data)
	syncData.quests.newQuestDevelopmentStage = sharpieData:get(bot, 'questDevelopmentStage')
	local updatingData = sharpieData:get(bot, 'updating')
	syncData.updating.updateMessage = sharpieData:get(bot, 'canUpdate')

	syncData.connected = true
	if sharpieData:get(bot, 'canUpdate') ~= '' and not syncData.updating.isUpdating then
		nextUpdateAnimation()
		syncData.updating.isUpdating = true
	end
end

nextUpdateAnimation = function()
	local width = 800
	local height = 400
	local x = -2
	local y = -2
	local stage = 0
	local speed = 20

	local a = system.looping(function()
		if stage == 0 then
			width = width - speed
			height = height - speed/2
			x = x + speed/2
			y = y + speed/4
			if width == 60 then stage = 1 end
		elseif stage == 1 then
			y = y - speed/4
			if y == 28 then stage = 2 end
		elseif stage == 2 then
			x = x - speed/2
			width = width + speed
			if width == 200 then stage = 3 end
		elseif stage == 3 then
			height = height + speed
			if height == 70 then stage = 4 end
		elseif stage == 4 then
			stage = 5
			local maxTime = 300
			ui.addTextArea(-888888888889, '<p align="center"><font size="15" color="#95d44d">Updating...</p><ce>'..syncData.updating.updateMessage..'</ce>\n<font size="20" color="#c6bb8c">'..string.format("%.2d:%.2d", maxTime/60%60, maxTime%60)..'</font>', nil, x, y, width, height, 0x432c04, 0xc6bb8c, 1, true)
			addTimer(function(j)
				local time = maxTime - j
				time = string.format("%.2d:%.2d", time/60%60, time%60)
				ui.addTextArea(-888888888889, '<p align="center"><font size="15" color="#95d44d">Updating...</p><ce>'..syncData.updating.updateMessage..'</ce>\n<font size="20" color="#c6bb8c">'..time..'</font>', nil, x, y, width, height, 0x432c04, 0xc6bb8c, 1, true)
				if j == maxTime then
					syncData.updating.updateMessage = ''
					saveGameData('Sharpiebot#0000')
				end
			end, 1000, maxTime)
		end
		if stage < 4 then
			ui.addTextArea(-888888888888, '', nil, x, y, width, height, 0x432c04, 0x432c04, 1, true)
		end
	end, 15)
end