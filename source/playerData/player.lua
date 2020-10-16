giveCoin = function(coin, name, work)
	if room.isInLobby then return end
	local playerData = players[name]
	if not playerData then return end
	players[name].coins = playerData.coins + coin
	if players[name].coins < 0 then
		players[name].coins = 0
	end
	if work then
		setLifeStat(name, 1, playerData.job == 'farmer' and -2 or -15)
	end
	if coin < 0 then
		players[name].spentCoins = playerData.spentCoins - coin
	end
	local sidequest = sideQuests[playerData.sideQuests[1]].type
	if string.find(sidequest, 'type:coins') then
		if string.find(sidequest, 'get') and coin > 0 then
			sideQuest_update(name, coin)
		elseif string.find(sidequest, 'use') and coin < 0 then
			sideQuest_update(name, -coin)
		end
	end
	showOptions(name)
	savedata(name)
end

giveBadge = function(player, id)
	if table.contains(players[player].badges, id) then return end

	players[player].badges[#players[player].badges+1] = id

	modernUI.new(player, 240, 220, translate('newBadge', player))
	:build()
	:badgeInterface(id)
	:addConfirmButton(function() end, translate('confirmButton_Great', player))

	if id == 20 then
		removeImage(players[player].questScreenIcon)
		players[player].questScreenIcon = nil
		ui.removeTextArea(8541584, player)
		giveLevelOrb(player, 6)
	end
	savedata(player)
end

giveLevelOrb = function(player, orb)
	if table.contains(players[player].starIcons.owned, orb) then return end
	if not mainAssets.levelIcons.star[orb] then return end

	players[player].starIcons.owned[#players[player].starIcons.owned+1] = orb
	savedata(player)
	
	modernUI.new(player, 240, 220, translate('newLevelOrb', player))
	:build()
	:showNewLevelOrb(orb)
	:addConfirmButton(function() end, translate('confirmButton_Great', player))
end

giveExperiencePoints = function(player, xp)
	local playerData = players[player]
	players[player].level[2] = tonumber(playerData.level[2]) + xp

	local currentXP = tonumber(players[player].level[2])
	local currentLEVEL = tonumber(players[player].level[1])

	local sidequest = sideQuests[playerData.sideQuests[1]].type
	if string.find(sidequest, 'type:getXP') then
		sideQuest_update(player, xp)
	end
	setSeasonStats(player, 2, xp)

	if currentXP >= ((currentLEVEL * 2000) + 500) then
		players[player].level[1] = currentLEVEL + 1
		players[player].level[2] = currentXP - ((currentLEVEL * 2000) + 500)
		modernUI.new(player, 240, 220, translate('newLevel', player), translate('newLevelMessage', player)..'\n\n<p align="center"><font size="40"><CE>'..players[player].level[1])
			:build()
			:addConfirmButton(function() end, translate('confirmButton_Great', player))
		local currentXP = tonumber(players[player].level[2])
		local currentLEVEL = tonumber(players[player].level[1])
		if currentXP >= ((currentLEVEL * 2000) + 500) then 
			return giveExperiencePoints(player, 0)
		end

		for ii, vv in next, ROOM.playerList do
			TFM.chatMessage('<j>'..translate('levelUp', ii):format('<vp>'..player..'</vp>', '<vp>'..players[player].level[1]..'</vp>'), ii)
			generateLevelImage(player, players[player].level[1], ii)
		end
	end
	savedata(player)
end

setSeasonStats = function(player, stat, quanty)
	if not quanty then quanty = 0 end
	local playerData = players[player].seasonStats[1]
	if not playerData then return end
	if playerData[1] == mainAssets.season then 
		players[player].seasonStats[1][stat] = players[player].seasonStats[1][stat] + quanty
	end
	savedata(player)
end

openProfile = function(player, target)
	if not target then target = player end
	if not players[target].dataLoaded then return end
	modernUI.new(player, 520, 300, '<font size="20">'..target)
	:build()
	:profileInterface(target)
end

player_removeImages = function(tbl)
	if not tbl then return end
	for i = 1, #tbl do 
		removeImage(tbl[i])
		tbl[i] = nil
	end
end