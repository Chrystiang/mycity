giveCoin = function(coin, name, work)
	if room.isInLobby then return end
	local playerData = players[name]
	if not playerData then return end
	if not coin then return end
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
	if string_find(sidequest, 'type:coins') then
		if string_find(sidequest, 'get') and coin > 0 then
			sideQuest_update(name, coin)
		elseif string_find(sidequest, 'use') and coin < 0 then
			sideQuest_update(name, -coin)
		end
	end
	showOptions(name)
	savedata(name)
end

giveBadge = function(player, id)
	if table_find(players[player].badges, id) then return end

	players[player].badges[#players[player].badges+1] = id

	modernUI.new(player, 240, 220, translate('newBadge', player))
	:build()
	:badgeInterface(id)
	:addConfirmButton(function(player) if id == 24 then giveLevelOrb(player, 9) end end, translate('confirmButton_Great', player))

	savedata(player)
end

giveLevelOrb = function(player, orb)
	if table_find(players[player].starIcons.owned, orb) then return end
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

	sideQuest_sendTrigger(player, 'getXP', xp)
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
			chatMessage('<j>'..translate('levelUp', ii):format('<vp>'..player..'</vp>', '<vp>'..players[player].level[1]..'</vp>'), ii)
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

openBag = function(player)
	local Gui = modernUI.new(player, 520, 300, translate('bag', player), nil, nil, 'Bag')
	if Gui then
		local TabID = players[player]._modernUIOpenedTabs - 1 + 10
		Gui:addButton('1787e839abd.png', function()
				eventTextAreaCallback(0, player, 'modernUI_Close_'..TabID, true)
				modernUI.new(player, 240, 180, translate('confirmButton_backpackIcon', player))
				:build()
				:showBagIcons()
			end)

			:build()
				:showPlayerItems(players[player].bag)
	end
end

openProfile = function(player, target)
	if not target then target = player end
	if not players[target].dataLoaded then return end
	local Gui = modernUI.new(player, 520, 300, '<font size="20">'..target, nil, nil, 'Profile')
	if Gui then
		Gui:build()
			:profileInterface(target)
	end
end

openQuests = function(player)
	local Gui = modernUI.new(player, 310, 280, translate('questsName', player), nil, nil, 'Quests')
	if Gui then
		Gui:build()
			:questInterface()
	end
end

openSettings = function(player)
	local Gui = modernUI.new(player, 520, 300, nil, nil, 'configMenu', 'Settings')
	if Gui then
		Gui:build()
			:showSettingsMenu()
	end
end

removeGroupImages = function(tbl)
	if not tbl then return end
	for i = 1, #tbl do 
		removeImage(tbl[i])
		tbl[i] = nil
	end
end