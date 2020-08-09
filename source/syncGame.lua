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
    
    players[player].houseData.chests.storage = {{}, {}}
    players[player].totalOfStoredItems.chest[1] = 0
    players[player].totalOfStoredItems.chest[2] = 0

	if playerVersion < 300 then
        if type(chest_Item) ~= 'table' then
    		for i, v in next, chest_Item do
    			item_addToChest(bagIds[v].n, chest_Quanty[i], player, 1)
    		end
        end
	else
		for counter = 1, 2 do
			for i, v in next, chest_Item[counter] do
				item_addToChest(bagIds[v].n, chest_Quanty[counter][i], player, counter)
			end
		end
	end
    if players[player].seasonStats[1][1] ~= mainAssets.season then
        players[player].seasonStats[1][1] = mainAssets.season
        players[player].seasonStats[1][2] = 0
    end
    if mainAssets.fileCopy._ranking:find(player) then
        if not table.contains(players[player].starIcons.owned, 3) then
            giveBadge(player, 12)
            players[player].starIcons.owned[#players[player].starIcons.owned+1] = 3
            players[player].starIcons.selected = 3
        end
        if not table.contains(players[player].cars, 14) then
            players[player].cars[#players[player].cars+1] = 14
            modernUI.new(player, 240, 220, translate('seasonReward', player), translate('unlockedCar', player))
            :build()
            :addConfirmButton(function() end, translate('confirmButton_Great', player))
        end
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

    system.saveFile(table.concat(bannedPlayers, ';')..'|'..table.concat(unrankedPlayers, ';')..'|'..table.concat(mainAssets.roles.admin, ';')..'|'..table.concat(mainAssets.roles.mod, ';')..'|'..table.concat(mainAssets.roles.helper, ';'), 1)
end

saveGameData = function(bot)
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