modernUI.shopInterface = function(self, itemList)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) - 12
	local y = (200 - height/2)

	for i = 1, #itemList do 
		local item = bagItems[itemList[i]]
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage("1717eaef706.png", ":20", 288, y+65 + (i-1)*45, player) -- Background
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(item.png, ":21", 310, y+60 + (i-1)*45, player) -- Item Image
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage("1717ed9210a.png", ":22", 353, y+90 + (i-1)*45, player) -- Hunger Icon
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage("1717edcf98f.png", ":23", 353, y+80 + (i-1)*45, player) -- Energy Icon
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage("1717ee908e4.png", ":24", 430, y+85 + (i-1)*45, player) -- Coins Bar

		ui.addTextArea(id..(900+(i-1)*5), string.format(translate('item_'..itemList[i], player).."\n<textformat leading='-2'><font size='10'><v>&nbsp;&nbsp;&nbsp;%s\n&nbsp;&nbsp;&nbsp;%s", item.power and item.power or 0, item.hunger and item.hunger or 0), player, 352, y+65 + (i-1)*45, nil, nil, 0xff0000, 0xff0000, 0, true)
		ui.addTextArea(id..(901+(i-1)*5), '<b><p align="center"><font color="#54391e">$'..item.price, player, 430, y+86 + (i-1)*45, 50, nil, 0xff0000, 0xff0000, 0, true)

	end
	return setmetatable(self, modernUI)
end
modernUI.tradeInterface = function(self)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) - 12
	local y = (200 - height/2)

	for i = 1, 3 do 
		math.randomseed(room.mathSeed * i^2)
		local offerID = math.random(1, #mainAssets.__farmOffers)
		local offer = mainAssets.__farmOffers[offerID]

		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage("1717eaef706.png", ":20", 288, y+65 + (i-1)*45, player) -- Background

		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('1717f0a6947.png', ":21",	315, y+66 + (i-1)*45, player) -- Item background1
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(bagItems[offer.requires[1]].png, ":22",	310, y+60 + (i-1)*45, player) -- Required Item Image

		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171830fd281.png', ":25",	377, y+70 + (i-1)*45, player) -- Arrow

		ui.addTextArea(id..(900+(i-1)*3), '<p align="right"><b><font size="9"><j>x<font size="12"><vp>'..offer.item[2], player, 447, y+86 + (i-1)*45, 30, nil, 0xff0000, 0xff0000, 0, true)

		if checkItemQuanty(offer.requires[1], offer.requires[2], player) then
			ui.addTextArea(id..(901+(i-1)*3), '<p align="right"><b><font size="9"><j>x<font size="12"><vp>'..offer.requires[2], player, 322, y+86 + (i-1)*45, 30, nil, 0xff0000, 0xff0000, 0, true)
			ui.addTextArea(id..(902+(i-1)*3), "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', 5), player, 320, y+65 + (i-1)*45, 155, 40, 0xff0000, 0xff0000, 0, true,
				function()
					if not checkItemQuanty(offer.requires[1], offer.requires[2], player) then return end
					removeBagItem(offer.requires[1], offer.requires[2], player)
					addItem(offer.item[1], offer.item[2], player)
					TFM.chatMessage('<j>'..translate('transferedItem', player):format('<vp>'..translate('item_'..offer.item[1], player)..' <fc>('..offer.item[2]..')</fc></vp>'), player)
					eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
				end)
		else
			ui.addTextArea(id..(901+(i-1)*3), '<p align="right"><b><font size="9"><j>x<font size="12"><r>'..offer.requires[2], player, 322, y+86 + (i-1)*45, 30, nil, 0xff0000, 0xff0000, 0, true)
			players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage("1717eaef706.png", ":30", 288, y+65 + (i-1)*45, player)
		end
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('1717f0a6947.png', ":23",	440, y+66 + (i-1)*45, player) -- Item background1
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(bagItems[offer.item[1]].png, ":24",	435, y+60 + (i-1)*45, player) -- Final Item Image
	end
	return setmetatable(self, modernUI)
end
modernUI.jobInterface = function(self, job)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - 161/2)
	local y = (200 - 161/2) + 40
	local color = '#'..jobs[job].color
	ui.addTextArea(id..'884', '<p align="center"><b><font color="#f4e0c5" size="14">'..translate(job, player), player, x+38, y-10, 110, 30, 0xff0000, 0xff0000, 0, true)

	local jobImage = jobs[job].icon
	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171d2f983ba.png', ":26", x+30, y-19, player)
	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(jobImage, ":27", x, y-20, player)

	return setmetatable(self, modernUI)
end
modernUI.questInterface = function(self)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - 270/2)
	local y = (200 - 90/2) - 30

	local images = {'171d71ed2cf.png', '171d724975e.png'} -- available, unavailaible

	local playerData = players[player]
	local getLang = playerData.lang

	for i = 1, 2 do
		local icon = 1
		local title, min, max, goal = '', 0, 100, '<p align="center"><font color="#999999">'..translate('newQuestSoon', player):format(questsAvailable+1, '<CE>'..syncData.quests.newQuestDevelopmentStage)
		if i == 1 then 
			if playerData.questStep[1] > questsAvailable then
				icon = 2
			else
				title = lang[getLang].quests[playerData.questStep[1]].name
				min = playerData.questStep[2]
				max = #lang['en'].quests[playerData.questStep[1]]
				goal = string.format(lang[getLang].quests[playerData.questStep[1]][playerData.questStep[2]]._add, quest_formatText(player, playerData.questStep[1], playerData.questStep[2]))
			end
		else 
			title = '['..translate('_2ndquest', player)..']'
			min = playerData.sideQuests[2] 
			max = sideQuests[playerData.sideQuests[1]].quanty
			goal = lang[getLang].sideQuests[playerData.sideQuests[1]]:format(playerData.sideQuests[2] .. '/' .. sideQuests[playerData.sideQuests[1]].quanty)
		end
		local progress = math.floor(min / max * 100)
		local progress2 = math.floor(min / max * 250/11.5)
		ui.addTextArea(id..(890+i), '<font color="#caed87" size="15"><b>'..title, player, x+10, y+5 + (i-1)*100, 250, nil, 0, 0x24474, 0, true)
		ui.addTextArea(id..(892+i), '<font color="#ebddc3" size="13">'..goal, player, x+10, y+30 + (i-1)*100, 250, 40, 0x1, 0x1, 0, true)

		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(images[icon], ":26", x, y + (i-1)*100, player)
		for ii = 1, progress2 do 
			players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171d74086d8.png', ":25", x+17 + (ii-1)*11, y+77 + (i-1)*100, player)
		end
		ui.addTextArea(id..(900+i), '<p align="center"><font color="#000000" size="14"><b>'..translate('percentageFormat', player):format(progress), player, x+11, y+73 + (i-1)*100, 250, nil, 0, 0x24474, 0, true)
		ui.addTextArea(id..(902+i), '<p align="center"><font color="#c6bb8c" size="14"><b>'..translate('percentageFormat', player):format(progress), player, x+10, y+72 + (i-1)*100, 250, nil, 0, 0x24474, 0, true)

		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171d736325c.png', ":27", x+10, y+70 + (i-1)*100, player)
	end 

	return setmetatable(self, modernUI)
end
modernUI.rewardInterface = function(self, rewards, title, text)
	local player = self.player
	if not title then title = translate('reward', player) end 
	if not text then text = translate('rewardText', player) end
	text = text..'\n'
	for i, v in next, rewards do 
		text = text..'\n<font size="11"><n>'..v.text..' ('..v.format..v.quanty..')'
	end
	self.title = title 
	self.text = text
	return setmetatable(self, modernUI)
end
modernUI.badgeInterface = function(self, badge)
	local id = self.id
	local player = self.player
	local x = (400 - 220/2)
	local y = (200 - 90/2) - 30

	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(badges[badge] and badges[badge].png, "&70", 385, 180, player)
	ui.addTextArea(id..'890', '<p align="center"><i><v>"'..translate('badgeDesc_'..badge, player)..'"', player, x+10, y+100, 200, nil, 0, 0x24474, 0, true)

	return setmetatable(self, modernUI)
end
modernUI.profileInterface = function(self, target)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2)
	local y = (200 - height/2)

    players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171dc2950de.png', ":26", x+170, y+80, player)
    players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171dc2950de.png', ":27", x+340, y+80, player)

    local targetData = players[target]
    local level = targetData.level[1]
    local minXP = targetData.level[2]
    local maxXP = (targetData.level[1] * 2000) + 500
   	local progress = math.floor(minXP/maxXP * 490/23.5)
    for i = 1, progress do
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171dc34c3f0.png', ":28", 155 + (i-1)*23.5, y+68, player)
	end
   	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171dc59da98.png', ":28", 150, y+48, player)

   	ui.addTextArea(id..'900', '<p align="center"><font color="#c6bb8c" size="20"><b>'..level, player, 380, y+54, 40, 40, 0, 0x24474, 0, true)
   	ui.addTextArea(id..'901', '<p align="center"><font color="#c6bb8c" size="12"><b>'..minXP..'/'..maxXP..'xp', player, 315, y+80, 170, nil, 0, 0x24474, 0, true)

   	for i, v in next, {translate('profile_basicStats', player), translate('profile_jobs', player), translate('profile_badges', player)} do 
   		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171dc5fbaf6.png', ":28", 150 + (i-1)*170, y+103, player)
   		ui.addTextArea(id..(902+i), '<p align="center"><font color="#c6bb8c" size="12"><b>'..v, player, 145 + (i-1)*170, y+105, 170, nil, 0, 0x24474, 0, true)
   	end
   	local text_General = 
   		string.replace(player, {["{0}"] = 'profile_coins', ["{1}"] = '$'..targetData.coins}) ..'\n' ..
   		string.replace(player, {["{0}"] = 'profile_spentCoins', ["{1}"] = '$'..targetData.spentCoins}) ..'\n' ..
   		string.replace(player, {["{0}"] = 'profile_purchasedHouses', ["{1}"] = #targetData.casas..'/'..#mainAssets.__houses-3}) ..'\n' ..
   		string.replace(player, {["{0}"] = 'profile_purchasedCars', ["{1}"] = #targetData.cars..'/'..#mainAssets.__cars-1}) ..'\n' ..
   		string.replace(player, {["{0}"] = 'profile_completedQuests', ["{1}"] = (targetData.questStep[1]-1)..'/'..questsAvailable}) ..'\n' ..
   		string.replace(player, {["{0}"] = 'profile_completedSideQuests', ["{1}"] = targetData.sideQuests[3]}) ..'\n' ..
   		string.replace(player, {["{0}"] = 'profile_questCoins', ["{1}"] = 'QP$'..targetData.sideQuests[4]}) ..'\n'

	local text_Jobs = {
		police 	= 	string.replace(player, {["{0}"] = 'profile_arrestedPlayers', ["{1}"] = targetData.jobs[1]}),
		thief 	= 	string.replace(player, {["{0}"] = 'profile_robbery', ["{1}"] = targetData.jobs[2]}),
		fisher 	= 	string.replace(player, {["{0}"] = 'profile_fishes', ["{1}"] = targetData.jobs[3]}),
		miner 	= 	string.replace(player, {["{0}"] = 'profile_gold', ["{1}"] = targetData.jobs[4]}),
		farmer 	= 	string.replace(player, {["{0}"] = 'profile_seedsPlanted', ["{1}"] = targetData.jobs[5]}) ..'\n' ..
					string.replace(player, {["{0}"] = 'profile_seedsSold', ["{1}"] = targetData.jobs[6]}),
		chef 	= 	string.replace(player, {["{0}"] = 'profile_cookedDishes', ["{1}"] = targetData.jobs[10]}) ..'\n' ..
					string.replace(player, {["{0}"] = 'profile_fulfilledOrders', ["{1}"] = targetData.jobs[9]}),
		ghostbuster = string.replace(player, {["{0}"] = 'profile_capturedGhosts', ["{1}"] = targetData.jobs[7]}),
   	}	
	ui.addTextArea(id..'910', '<font size="10" color="#ebddc3">'..text_General, player, 155, y+133, 150, 150, 0x152d30, 0x152d30, 1, true)
	local job = {'police', 'thief', 'fisher', 'miner', 'farmer', 'chef', 'ghostbuster'}
	if targetData.jobs[7] == 0 then job[7] = nil end 
	for i, v in next, job do 
		ui.addTextArea(id..(911+i), '<p align="left"><font size="11" color="#'..jobs[v].color..'">'..translate(v, player), player, 323, y+133 + (i-1)*17, 150, nil, 0x152d30, 0x152d3, 0, true)
		ui.addTextArea(id..(921+i), '<p align="left"><font size="11" color="#caed87">→', player, 460, y+133 + (i-1)*17, nil, nil, 0x152d30, 0x152d3, 0, true, 
			function(player, args) 
				ui.addTextArea(args.id..'930', '<font size="14" color="#'..jobs[args.title].color..'"><p align="center">'..translate(args.title, player)..'</p></font>\n'..args.data, 
					player, 480, 180 + args.y*17, 150, nil, 0x432c04, 0x7a5817, 1, true) 
				ui.addTextArea(args.id..'931', '<textformat leftmargin="1" rightmargin="1">'..string.rep('\n', 10), 
					player, 480, 180 + args.y*17, 150, nil, 0x432c04, 0x7a5817, 0, true, 
						function(player, args) 
							ui.removeTextArea(args.id..'930')
							ui.removeTextArea(args.id..'931')
						end, {id = id}) 
			end, {title = v, id = id, data = text_Jobs[v], y = i-1})
	end
	--ui.addTextArea(id..'912', text_Badges, player, 493, y+130, 150, 153, 0x152d30, 0x152d30, 1, true)

	for i, v in next, players[target].badges do
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(badges[v].png, ":33", x+352+((i-1)%5)*31, y+140+math.floor((i-1)/5)*31, player)
	end

	return setmetatable(self, modernUI)
end
modernUI.showPlayerItems = function(self, items, chest)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) + 20
	local y = (200 - height/2) + 65
	local currentPage = 1
	if not items then return alert_error(player, 'error', 'emptyBag') end
	local maxPages = math.ceil(#items/15)
	local usedSomething = false
	local storageLimits = {chest and players[player].totalOfStoredItems.chest[chest] or players[player].totalOfStoredItems.bag, chest and 50 or players[player].bagLimit}
	local storageAmount = storageLimits[1]..'/'..storageLimits[2]

	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('172763e41e1.jpg', ":27", x+337, y-14, player)
	ui.addTextArea(id..'895', '<font color="#95d44d">'..translate('itemAmount', player):format('<cs>'..storageAmount..'</cs>'), player, x, y -20, 312, nil, 0xff0000, 0xff0000, 0, true)
	local function showItems()
		local minn = 15 * (currentPage-1) + 1
		local maxx = currentPage * 15
		local i = 0
		for _ = 1, #items do 
			i = i + 1
			local v = items[_]
			if i >= minn and i <= maxx then
				local i = i - 15 * (currentPage-1)
				local image = bagItems[v.name].png or '16bc368f352.png'
				players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage('1722d2d8234.jpg', ":26", x + ((i-1)%5)*63, y + math.floor((i-1)/5)*65, player)
				players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage(image, ":26", x + 5 + ((i-1)%5)*63, y + 5 + math.floor((i-1)/5)*65, player)
				ui.addTextArea(id..(895+i*2), '<p align="right"><font color="#95d44d" size="13"><b>x'..v.qt, player, x + 5 + ((i-1)%5)*63, y + 42 + math.floor((i-1)/5)*65, 55, nil, 0xff0000, 0xff0000, 0, true)
				ui.addTextArea(id..(896+i*2), '\n\n\n\n', player, x + 3 + ((i-1)%5)*63, y + 3 + math.floor((i-1)/5)*65, 55, 55, 0xff0000, 0xff0000, 0, true,
					function(player)
						local itemName = v.name 
						local quanty = v.qt 
						local itemData = bagItems[v.name]
						local itemType = itemData.type
						local power = itemData.power or 0
						local hunger = itemData.hunger or 0
						local blockUse = not itemData.func
						if itemType == 'food' then blockUse = false end
						local selectedQuanty = 1
						player_removeImages(players[player]._modernUISelectedItemImages[1])
						for i = 0, 3 do 
							ui.removeTextArea(id..(930+i), player)
						end
						local description = item_getDescription(itemName, player)
						ui.addTextArea(id..'890', '<p align="center"><font size="13"><fc>'..translate('item_'..itemName, player), player, x+340, y-15, 135, 215, 0x24474D, 0x314e57, 0, true)
						ui.addTextArea(id..'891', '<font size="9"><bl>'..description, player, x+340, y+50, 135, nil, 0x24474D, 0x314e5, 0, true)
						ui.addTextArea(id..'892', '<font color="#cef1c3">'..translate('confirmButton_Select', player), player, x+337, y+121 + (blockUse and 30 or 0), nil, nil, 0x24474D, 0x314e5, 0, true)
						ui.addTextArea(id..'893', '<font color="#cef1c3">01', player, x+425, y+121 + (blockUse and 30 or 0), nil, nil, 0x24474D, 0x314e5, 0, true)

						players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(image, "&26", 542, 125, player)
						players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage('1722d33f76a.png', ":26", x + ((i-1)%5)*63-3, y + math.floor((i-1)/5)*65-3, player)

						local function button(i, text, callback, x, y, width, height)
							ui.addTextArea(id..(930+i*5), '', player, x-1, y-1, width, height, 0x95d44d, 0x95d44d, 1, true)
							ui.addTextArea(id..(931+i*5), '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
							ui.addTextArea(id..(932+i*5), '', player, x, y, width, height, 0x44662c, 0x44662c, 1, true)
							ui.addTextArea(id..(933+i*5), '<p align="center"><font color="#cef1c3" size="13">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, callback)
						end
						if not blockUse then
							button(0, translate(itemType == 'food' and 'eatItem' or 'use', player), 
							function(player) 
								if usedSomething then return end
								if quanty > 0 then
									if itemName == 'cheese' then 
										if players[player].whenJoined > os.time() then 
											return alert_Error(player, 'error', 'limitedItemBlock', '120')
										else 
											players[player].whenJoined = os.time() + 120*1000
										end
									end
									eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
									local condition = itemData.func and -1 or -selectedQuanty
									if not chest then 
										removeBagItem(v.name, condition, player)
									else 
										item_removeFromChest(v.name, condition, player, chest)
									end
									if itemType == 'food' then 
										setLifeStat(player, 1, power * selectedQuanty)
										setLifeStat(player, 2, hunger * selectedQuanty)
									else
										itemData.func(player)
									end
									local sidequest = sideQuests[players[player].sideQuests[1]].type
									if string.find(sidequest, 'type:items') then
										if string.find(sidequest, 'use') then
											sideQuest_update(player, 1)
									 	end
									end
									usedSomething = true
									savedata(player)
									return
								end
							end, 507, 265, 120, 13)
						end
						button(1, translate(chest and 'passToBag' or 'drop', player), 
							function(player)
								eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
								if usedSomething then return end
								if quanty > 0 then
									if not chest then
										removeBagItem(v.name, -selectedQuanty, player)
										item_drop(v.name, player, selectedQuanty)
									else
										item_removeFromChest(v.name, selectedQuanty, player, chest)
										addItem(v.name, selectedQuanty, player)
									end
									usedSomething = true
									savedata(player)
								end
							end, 507, 295, 120, 13)

						for i = 1, 2 do 
							button(1+i, i == 1 and '-' or '+', 
								function(player) 
									local calc = i == 1 and -1 or 1
									if (selectedQuanty + calc) > quanty or (selectedQuanty + calc) < 1 then return end
									selectedQuanty = selectedQuanty + calc
									ui.updateTextArea(id..'893', '<font color="#cef1c3">'..string.format("%.2d", selectedQuanty), player)
								end, 565 + (i-1)*50, 240 + (blockUse and 30 or 0), 10, 10)
						end
					end)
			end
		end
	end
	local function updateScrollbar()
		local function updatePage(count)
			if currentPage + count > maxPages or currentPage + count < 1 then return end 
			currentPage = currentPage + count
			player_removeImages(players[player]._modernUISelectedItemImages[1])
			player_removeImages(players[player]._modernUISelectedItemImages[3])
			for i = 897, 929 do 
				ui.removeTextArea(id..i, player)
			end
			updateScrollbar()
			showItems()
		end
		ui.addTextArea(id..'888', string.rep('\n', 10), player, x+2, y+200, 155, 10, 0x24474D, 0xff0000, 0, true, 
			function()
				updatePage(-1)
			end)
		ui.addTextArea(id..'889', string.rep('\n', 10), player, x+157, y+200, 155, 10, 0x24474D, 0xff0000, 0, true, 
			function()
				updatePage(1)
			end)

		player_removeImages(players[player]._modernUISelectedItemImages[2])
		players[player]._modernUISelectedItemImages[2][#players[player]._modernUISelectedItemImages[2]+1] = addImage('1729eacaeb5.jpg', ":26", x+2, y+205, player)
		for i = 1, (10 - math.min(8, maxPages)+1) do 
			players[player]._modernUISelectedItemImages[2][#players[player]._modernUISelectedItemImages[2]+1] = addImage('1729ebf25cc.jpg', ":27", x+2 + (i-1)*31 + (currentPage-1)*31, y+205, player)
		end
	end
	if maxPages > 1 then 
		updateScrollbar()
	end
	showItems(currentPage)
	return setmetatable(self, modernUI)
end
modernUI.showPlayerVehicles = function(self)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) + 45
	local y = (200 - height/2) + 70
	local currentPage = 1
	local filter = {'car', 'boat'}
	local pages = {'land', 'water', 'air'}
	local favorites = players[player].favoriteCars
	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('17238027fa4.jpg', ":26", x, y-16, player)

	local function showItems()
		ui.addTextArea(id..'890', '<font color="#ebddc3" size="13"><b><p align="center">'..translate(pages[currentPage]..'Vehicles', player), player, 350, y-25, 100, nil, 0x152d30, 0x152d30, 0, true)
		local i = 1
		for _ = 1, #players[player].cars do 
			local v = mainAssets.__cars[players[player].cars[_]]
			if v.type == filter[currentPage] then 
				players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage('17237e4b350.jpg', ":26", x + ((i-1)%4)*107, y + math.floor((i-1)/4)*65, player)
				players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage(v.icon, ":26", x + ((i-1)%4)*107, y + math.floor((i-1)/4)*65, player)
				local isFavorite = favorites[currentPage] == players[player].cars[_] and '17238fea420.png' or '17238fe6532.png'
				players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(isFavorite, ":27", x+82 + ((i-1)%4)*107, y +42 + math.floor((i-1)/4)*65, player)

				local vehicleName = lang.en['vehicle_'..players[player].cars[_]] and translate('vehicle_'..players[player].cars[_], player) or v.name
				ui.addTextArea(id..(895+i*3), '<p align="center"><font color="#95d44d" size="10">'..vehicleName, player, x + ((i-1)%4)*107, y-2 + math.floor((i-1)/4)*65, 104, nil, 0xff0000, 0xff0000, 0, true)
				ui.addTextArea(id..(896+i*3), '\n\n\n\n', player, x + 3 + ((i-1)%4)*107, y + 3 + math.floor((i-1)/4)*65, 104, 62, 0xff0000, 0xff0000, 0, true,
					function(player)
						local car = players[player].cars[_]
						if currentPage ~= 2 and (ROOM.playerList[player].y < 7000 or ROOM.playerList[player].y > 7800 or players[player].place ~= 'town' and players[player].place ~= 'island') and not players[player].canDrive then return alert_Error(player, 'error', 'vehicleError') end
						drive(player, car)
						eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
					end)
				ui.addTextArea(id..(897+i*3), "<textformat leftmargin='1' rightmargin='1'>\n\n\n\n", player, x + 82 + ((i-1)%4)*107, y + 42 + math.floor((i-1)/4)*65, 20, 20, 0xff0000, 0xff0000, 0, true,
					function(player)
						favorites[currentPage] = players[player].cars[_]
						players[player].favoriteCars[currentPage] = players[player].cars[_]
						showItems()
						savedata(player)
					end)
				i = i + 1
			end
		end
	end
	local function updateScrollbar()
		local function updatePage(count)
			if currentPage + count > 2 or currentPage + count < 1 then return end 
			currentPage = currentPage + count
			player_removeImages(players[player]._modernUISelectedItemImages[1])
			player_removeImages(players[player]._modernUISelectedItemImages[3])
			for i = 899, 929 do 
				ui.removeTextArea(id..i, player)
			end
			updateScrollbar()
			showItems()
		end
		ui.addTextArea(id..'888', string.rep('\n', 10), player, x, y+202, 212, 10, 0x24474D, 0xff0000, 0, true, 
			function()
				updatePage(-1)
			end)
		ui.addTextArea(id..'889', string.rep('\n', 10), player, x+213, y+202, 212, 10, 0x24474D, 0xff0000, 0, true, 
			function()
				updatePage(1)
			end)

		player_removeImages(players[player]._modernUISelectedItemImages[2])
		players[player]._modernUISelectedItemImages[2][#players[player]._modernUISelectedItemImages[2]+1] = addImage('172380798d8.jpg', ":26", x, y+205, player)
		for i = 1, 4 do 
			players[player]._modernUISelectedItemImages[2][#players[player]._modernUISelectedItemImages[2]+1] = addImage('172383aa660.jpg', ":27", x + (i-1)*85 + (currentPage-1)*85, y+205, player)
		end
	end

	updateScrollbar()
	showItems()
	return setmetatable(self, modernUI)
end
modernUI.showHouses = function(self, selectedTerrain)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) + 20
	local y = (200 - height/2) + 65
	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('172763e41e1.jpg', ":27", x+337, y-14, player)
	local i = 0
	for _ = 1, #mainAssets.__houses do
		local v = mainAssets.__houses[_]
		local isLimitedTime = v.properties.limitedTime
		local isOutOfSale = isLimitedTime and formatDaysRemaining(isLimitedTime, true)
		local showItem = true
		if isLimitedTime and (isOutOfSale and not table.contains(players[player].casas, _)) then
			showItem = false
		end
		if showItem then
			i = i + 1
			local image = v.properties.png or '16c25233487.png'
			players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage('1722d2d8234.jpg', ":26", x + ((i-1)%5)*63, y + math.floor((i-1)/5)*65, player)
			players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage(image, ":26", x + 5 + ((i-1)%5)*63, y + 5 + math.floor((i-1)/5)*65, player)
			if isLimitedTime and not isOutOfSale then 
				ui.addTextArea(id..(895+i*2), '<p align="center"><font size="9"><r>'..translate('daysLeft2', player):format(formatDaysRemaining(isLimitedTime)), player, x + 3 + ((i-1)%5)*63, y + 49 + math.floor((i-1)/5)*65, 55, nil, 0xff0000, 0xff0000, 0, true)
			end
			ui.addTextArea(id..(896+i*2), '\n\n\n\n', player, x + 3 + ((i-1)%5)*63, y + 3 + math.floor((i-1)/5)*65, 55, 55, 0xff0000, 0xff0000, 0, true,
				function(player, i)
					local itemName = translate('House'.._, player)
					player_removeImages(players[player]._modernUISelectedItemImages[1])
					ui.addTextArea(id..'890', '<p align="center"><font size="13"><fc>'..itemName, player, x+340, y-15, 135, 215, 0x24474D, 0x314e57, 0, true)
					local description = '<p align="center"><i>"'..translate('houseDescription_'.._, player)..'"</i>\n\n<p align="left">'
					if isLimitedTime and table.contains(players[player].casas, _) then 
						description = description..'<r>'..translate('collectorItem', player)
					end
					ui.addTextArea(id..'891', '<font size="9"><bl>'..description, player, x+340, y+80, 135, nil, 0x24474D, 0x314e5, 0, true)
					ui.addTextArea(id..'894', '', player, x + 3 + ((i-1)%5)*63, y + 3 + math.floor((i-1)/5)*65, 55, 55, 0xff0000, 0xff0000, 0, true)

					players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(image, "&26", 542, 125, player)
					players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage('1722d33f76a.png', ":26", x + ((i-1)%5)*63-3, y + math.floor((i-1)/5)*65-3, player)
					local function button(i, text, callback, x, y, width, height, blockClick)
						local colorPallete = {
							button_confirmBg = 0x95d44d,
							button_confirmFront = 0x44662c
						}
						if blockClick then 
							colorPallete.button_confirmBg = 0xbdbdbd
							colorPallete.button_confirmFront = 0x5b5b5b
						end
						ui.addTextArea(id..(930+i*5), '', player, x-1, y-1, width, height, colorPallete.button_confirmBg, colorPallete.button_confirmBg, 1, true)
						ui.addTextArea(id..(931+i*5), '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
						ui.addTextArea(id..(932+i*5), '', player, x, y, width, height, colorPallete.button_confirmFront, colorPallete.button_confirmFront, 1, true)
						ui.addTextArea(id..(933+i*5), '<p align="center"><font color="#cef1c3" size="13">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, not blockClick and callback or nil)
					end
				
					local buttonType = nil 
					local blockClick = false
					local buttonAction = nil
				    if table.contains(players[player].casas, _) then
			    		buttonType =  translate('use', player)
			    		buttonAction = 'use'
					elseif players[player].coins >= v.properties.price then
			    		buttonType = '<font size="11">'..translate('confirmButton_Buy', player):format('<b><fc>$'..v.properties.price)
			    		buttonAction = 'buy'
					else
						blockClick = true
			    		buttonType = '<r>$'..v.properties.price
					end

					button(1, buttonType, 
						function(player)
							if buttonAction == 'use' then 
								eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
								equipHouse(player, _, selectedTerrain)
							elseif buttonAction == 'buy' then 
								if room.terrains[selectedTerrain].owner then return alert_Error(player, 'error', 'alreadyLand') end
								if table.contains(players[player].casas, _) then return end

								eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
								players[player].casas[#players[player].casas+1] = _
								giveCoin(-v.properties.price, player)
								ui.removeTextArea(24 + selectedTerrain)
								ui.removeTextArea(44 + selectedTerrain)
								ui.removeTextArea(selectedTerrain)

								modernUI.new(player, 120, 120)
								:build()
								players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(v.properties.png, "&70", 400 - 50 * 0.5, 180, player)

								equipHouse(player, _, selectedTerrain)
							end
						end, 507, 295, 120, 13, blockClick)
				end, i)
		end
	end
	return setmetatable(self, modernUI)
end
modernUI.showHouseSettings = function(self)
	local id = self.id
	local player = self.player
	local height = self.height
	local x = (400 - 180/2)
	local y = (200 - height/2) + 50

	local function button(i, text, callback, x, y, width, height)
		local width = width or 180
		local height = height or 15
		ui.addTextArea(id..(930+i*5), '', player, x-1, y-1, width, height, 0x95d44d, 0x95d44d, 1, true)
		ui.addTextArea(id..(931+i*5), '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
		ui.addTextArea(id..(932+i*5), '', player, x, y, width, height, 0x44662c, 0x44662c, 1, true)
		ui.addTextArea(id..(933+i*5), '<p align="center"><font color="#cef1c3" size="13">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, callback)
	end
	local images = {bg = {}, icons = {}, pages = {}, expansions = {}}
	local terrainID = players[player].houseData.houseid
	local showFurnitures, updateScrollbar, updatePage
	local buildModeImages = {currentFurniture = nil, furnitures = {}}
	local playerFurnitures = table.copy(players[player].houseData.furnitures.stored)
	local playerFurnitures_length = table.getLength(playerFurnitures)
	local playerPlacedFurnitures = table.copy(players[player].houseData.furnitures.placed)
	local totalOfPlacedFurnitures = table.getLength(players[player].houseData.furnitures.placed)

	local function removeFurniture(index)
		if not players[player].editingHouse then return end
		local data = playerPlacedFurnitures[index]
		if not data then return end
		playerPlacedFurnitures[index] = false
		removeImage(data.image)
		ui.removeTextArea(- 85000 - (terrainID*200 + index), player)
		if mainAssets.__furnitures[data.type].grounds then
			TFM.removePhysicObject(- 7000 - (terrainID-1)*200 - index)
		end
		totalOfPlacedFurnitures = totalOfPlacedFurnitures - 1
		if not playerFurnitures[data.type] then 
			playerFurnitures[data.type] = {quanty = 1, type = data.type}
		else 
			playerFurnitures[data.type].quanty = playerFurnitures[data.type].quanty + 1
		end
		ui.updateTextArea(id..'891', '<font size="12"><cs>'..translate('placedFurnitures', player):format('<fc><b>'..totalOfPlacedFurnitures..'/'..maxFurnitureStorage..'</b></fc>'), player)
		updatePage(0)
	end
	local function placeFurniture(index)
		if not players[player].editingHouse then return end
		if totalOfPlacedFurnitures >= maxFurnitureStorage then return alert_Error(player, 'error', 'maxFurnitureStorage', maxFurnitureStorage) end
		if buildModeImages.currentFurniture then 
			removeImage(buildModeImages.currentFurniture)
			buildModeImages.currentFurniture = nil
		end
		local data = playerFurnitures[index]
		if not data then return alert_Error(player, 'error', 'unknownFurniture') end
		local furniture = mainAssets.__furnitures[data.type]
		buildModeImages.currentFurniture = addImage(furniture.image, '%'..player, furniture.align.x, furniture.align.y, player)
		images.icons[#images.icons+1] = addImage('172469fea71.jpg', ':25', 350, 317, player)
		ui.addTextArea(id..'892', '<p align="center"><b><fc><font size="14">'..translate('houseSettings_placeFurniture', player)..'\n', player, 350, 321, 100, 25, 0x24474D, 0x00ff00, 0, true, 
			function()
				ui.removeTextArea(id..'892', player)
				if not playerFurnitures[index] then return end
				if playerFurnitures[index].quanty <= 0 then return end
				local x, y = ROOM.playerList[player].x, ROOM.playerList[player].y
				if y < 1000 or y > 2000 then return end
				if x > terrainID*1500 or x < (terrainID-1)*1500+100 then return end

				playerFurnitures[index].quanty = playerFurnitures[index].quanty - 1
				totalOfPlacedFurnitures = totalOfPlacedFurnitures + 1
				ui.updateTextArea(id..'891', '<font size="12"><cs>'..translate('placedFurnitures', player):format('<fc><b>'..totalOfPlacedFurnitures..'/'..maxFurnitureStorage..'</b></fc>'), player)

				local id = terrainID

				TFM.killPlayer(player)
				TFM.respawnPlayer(player)
				TFM.movePlayer(player, x, y, false)

				local furniture_X = x + furniture.align.x 
				local furniture_Y = y + furniture.align.y
				local idd = #playerPlacedFurnitures+1
				playerPlacedFurnitures[idd] = {type = data.type, x = furniture_X - (id-1)*1500, y = furniture_Y - 1000, image = addImage(furniture.image, '?1000', furniture_X, furniture_Y, player)}
				ui.addTextArea(- 85000 - (id*200 + idd), "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', furniture.area[2]/8), player, furniture_X, furniture_Y, furniture.area[1], furniture.area[2], 1, 0xfff000, 0, false, 
					function()
						removeFurniture(idd)
					end)

				if furniture.grounds then
					furniture.grounds(furniture_X,  furniture_Y, - 7000 - (id-1)*200 - idd)
					TFM.movePlayer(player, 0, - 50, true)
				end

				if playerFurnitures[index].quanty <= 0 then 
					playerFurnitures[index] = false
				end
				updatePage(0)
			end)

	end
	local function sellFurniture(index)
		if not players[player].editingHouse then return end
		local data = playerFurnitures[index]
		if not data then return alert_Error(player, 'error', 'unknownFurniture') end
		local furniture = mainAssets.__furnitures[data.type]
		if playerFurnitures[index].quanty <= 0 then return end
		playerFurnitures[index].quanty = playerFurnitures[index].quanty - 1
		if playerFurnitures[index].quanty <= 0 then 
			playerFurnitures[index] = nil
		end
		if buildModeImages.currentFurniture then
			local x, y = ROOM.playerList[player].x, ROOM.playerList[player].y
			TFM.killPlayer(player)
			TFM.respawnPlayer(player)
			TFM.movePlayer(player, x, y, false)
			buildModeImages.currentFurniture = nil
			ui.removeTextArea(id..'892', player)
		end
		players[player].houseData.furnitures.stored = {}
		for i, v in next, playerFurnitures do
			if v then
				players[player].houseData.furnitures.stored[i] = v
			end
		end
		players[player].houseData.furnitures.placed = {}
		for i, v in next, playerPlacedFurnitures do 
			if v then
				players[player].houseData.furnitures.placed[i] = v
				removeImage(v.image)
				ui.removeTextArea(- 85000 - (terrainID*200 + i), player)
			end
		end
		giveCoin(furniture.price and furniture.price/2 or 0, player)
		updatePage(0)
	end
	local function closeExpansionMenu()
		player_removeImages(images.expansions)
		ui.removeTextArea(id..'889', player)
		ui.removeTextArea(id..'890', player)
		updatePage(0)
	end
	button(0, translate('houseSettings_permissions', player), function() 
		eventTextAreaCallback(0, player, 'modernUI_Close_'..id, 'errorUI')
		modernUI.new(player, 380, 280, translate('houseSettings_permissions', player))
		:build()
		:showHousePermissions()
	end, x, y)

	button(1, translate('houseSettings_buildMode', player), function() 
		if players[player].editingHouse then return end
		players[player].editingHouse = true
		for i = 0, 4 do 
			ui.removeTextArea(98900000000+i, player)
			ui.removeTextArea(999990+i, player)
		end

		player_removeImages(room.houseImgs[terrainID].furnitures)
		for i, furniture in next, playerPlacedFurnitures do
			local data = mainAssets.__furnitures[furniture.type]
			local x = furniture.x + ((terrainID-1)%terrainID)*1500
			local y = furniture.y + 1000
			furniture.image = addImage(data.image, '?1000', x, y, player)
			ui.addTextArea(- 85000 - (terrainID*200 + i), "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', data.area[2]/8), player, x, y, data.area[1], data.area[2], 1, 0xfff000, 0, false, 
				function()
					removeFurniture(i)
				end)
		end
		for guest in next, room.terrains[terrainID].guests do
			if room.terrains[terrainID].guests[guest] then 
				getOutHouse(guest, terrainID)
				alert_Error(guest, 'error', 'error_houseUnderEdit', player)
			end
		end
		room.terrains[terrainID].guests = {}

		eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
		for i = 0, 3 do
			if players[player].houseTerrainAdd[i+1] <= 1 then
				ui.addTextArea(id..(885+i), '<p align="center"><fc>'..translate('houseSettings_changeExpansion', player)..'\n', player, (terrainID-1)*1500 + 650 + i*175, 1740, 175, nil, 0x24474D, 0xff0000, 0, false,
					function()
						if images.expansions[1] then return end
						ui.addTextArea(id..'889', '', player, 0, 0, 800, 400, 0x24474D, 0xff0000, 0, true)
						local counter = 0
						for _ = 0, 3 do
							if _ ~= i then 
								images.expansions[#images.expansions+1] = addImage('17285e3d8e1.png', "!1000", (terrainID-1)*1500 + 650 + _*175, 1715, player)
							end
						end
						images.expansions[#images.expansions+1] = addImage('171d2a2e21a.png', ":25", 280, 140, player)
						ui.addTextArea(id..'890', string.rep('\n', 4), player, 487, 150, 25, 25, 0xff0000, 0xff0000, 0, true, function() closeExpansionMenu() end)
						for expansionID, v in next, houseTerrains do
							if players[player].houseTerrain[i+1] ~= expansionID then
								images.expansions[#images.expansions+1] = addImage(v.png, ":26", counter*109 + 324, 150, player)
								button(counter, translate('confirmButton_Buy2', player):format('<fc>'..translate('expansion_'..v.name, player)..'</fc>','<fc>$'..v.price..'</fc>'), 
									function()
										if players[player].coins < v.price or players[player].houseTerrain[i+1] == expansionID then return end
										players[player].houseTerrain[i+1] = expansionID
										players[player].houseTerrainAdd[i+1] = 1
										players[player].houseTerrainPlants[i+1] = 0
										HouseSystem.new(player):genHouseGrounds()
										giveCoin(-v.price, player)
										closeExpansionMenu()
									end, counter*109 + 299, 210, 95, 30)
								counter = counter + 1
							end
						end
					end)
			end
		end
		local currentPage = 1
		local maxPages = math.ceil(playerFurnitures_length/14)
		images.bg[#images.bg+1] = addImage('1723ed04fb4.jpg', ':25', 5, 340, player)
		images.bg[#images.bg+1] = addImage('172469fea71.jpg', ':25', 695, 317, player)

		ui.addTextArea(id..'891', '<font size="12"><cs>'..translate('placedFurnitures', player):format('<fc><b>'..totalOfPlacedFurnitures..'/'..maxFurnitureStorage..'</b></fc>'), player, 0, 321, nil, nil, 0x24474D, 0xff0000, 0, true)
		ui.addTextArea(id..'893', '', player, 0, 340, 800, 60, 0x24474D, 0xff0000, 0, true)
		ui.addTextArea(id..'894', '<p align="center"><b><font color="#95d44d" size="14">'..translate('houseSettings_finish', player)..'\n', player, 695, 321, 100, nil, 0x24474D, 0xff0000, 0, true, 
			function()
				if not players[player].editingHouse then return end
				local x, y = ROOM.playerList[player].x, ROOM.playerList[player].y
				TFM.killPlayer(player)
				TFM.respawnPlayer(player)
				TFM.movePlayer(player, x, y, false)

				players[player].houseData.furnitures.stored = {}
				for i, v in next, playerFurnitures do
					if v then
						players[player].houseData.furnitures.stored[i] = v
					end
				end
				players[player].houseData.furnitures.placed = {}
				for i, v in next, playerPlacedFurnitures do 
					if v then
						players[player].houseData.furnitures.placed[i] = v
						removeImage(v.image)
						ui.removeTextArea(- 85000 - (terrainID*200 + i), player)
					end
				end
				players[player].houseData.chests.position = {}
				players[player].editingHouse = false
				savedata(player)
				HouseSystem.new(player):genHouseFace()
				for i = 1, 2 do 
					showLifeStats(player, i)
				end
				showOptions(player)
				player_removeImages(images.icons)
				player_removeImages(images.pages)
				player_removeImages(images.bg)
				eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
			end)
		showFurnitures = function()
			local minn = 14 * (currentPage-1) + 1
			local maxx = currentPage * 14
			local i = 0
			for index, v in next, playerFurnitures do
				if v then
					i = i + 1
					if i >= minn and i <= maxx then
						local i = i - 14 * (currentPage-1)
						local furnitureData = mainAssets.__furnitures[v.type]
						images.icons[#images.icons+1] = addImage('1723ed07002.png', ':26', 37 + (i-1) * 52, 350, player)
						images.icons[#images.icons+1] = addImage(furnitureData.png, ':27', 39 + (i-1) * 52, 350, player)
						images.icons[#images.icons+1] = addImage('172559203c1.png', ':28', 37 + (i-1) * 52, 350, player)

						ui.addTextArea(id..(895+i*3), '<p align="right"><font color="#95d44d" size="13"><b>x'..v.quanty, player, 35 + (i-1)*52, 383, 54, nil, 0xff0000, 0xff0000, 0, true)
						ui.addTextArea(id..(896+i*3), '\n\n\n\n', player, 35 + (i-1)*52, 347, 55, 55, 0xff0000, 0xff0000, 0, true,
							function()
								placeFurniture(index)
							end)
						ui.addTextArea(id..(897+i*3), "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', 3), player, 37 + (i-1)*52, 350, 10, 10, 0xff0000, 0xff0000, 0, true,
							function()
								modernUI.new(player, 240, 220, translate('sellFurniture', player), translate('sellFurnitureWarning', player))
								:build()
								:addConfirmButton(function()
									sellFurniture(index)
								end, translate('confirmButton_Sell', player):format('<b><fc>$'..(furnitureData.price and furnitureData.price/2 or 0)..'</fc></b>'), 200)
							end)

					end
				end
			end
		end
		updatePage = function(count)
			if currentPage + count > maxPages or currentPage + count < 1 then return end 
			currentPage = currentPage + count
			player_removeImages(images.icons)
			player_removeImages(images.pages)
			for i = 895, 995 do
				ui.removeTextArea(id..i, player)
			end
			updateScrollbar()
			showFurnitures()
		end
		updateScrollbar = function()
			if currentPage > 1 then
				images.pages[#images.pages+1] = addImage('1723f16c0ba.jpg', ':25', 5, 340, player)
				ui.addTextArea(id..'895', string.rep('\n', 10), player, 12, 345, 20, 60, 0x24474D, 0xff0000, 0, true, 
					function()
						updatePage(-1)
					end)
			end
			if currentPage < maxPages then
				images.pages[#images.pages+1] = addImage('1723f16e3ba.jpg', ':25', 761, 340, player)
				ui.addTextArea(id..'896', string.rep('\n', 10), player, 767, 345, 20, 60, 0x24474D, 0xff0000, 0, true, 
					function()
						updatePage(1)
					end)
			end
		end
		if maxPages > 1 then 
			updateScrollbar()
		end
		showFurnitures()
	end, x, y+30)

	return setmetatable(self, modernUI)
end
modernUI.showHousePermissions = function(self)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) + 20
	local y = (200 - height/2) + 70
	local playerList = {}
	local i = 1
	local terrainID = players[player].houseData.houseid
	local function button(i, text, callback, x, y)
		local width = 150
		local height = 15
		ui.addTextArea(id..(930+i*5), '', player, x-1, y-1, width, height, 0x95d44d, 0x95d44d, 1, true)
		ui.addTextArea(id..(931+i*5), '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
		ui.addTextArea(id..(932+i*5), '', player, x, y, width, height, 0x44662c, 0x44662c, 1, true)
		ui.addTextArea(id..(933+i*5), '<p align="center"><font color="#cef1c3" size="13">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, callback)
	end
	for user in next, ROOM.playerList do
		if user ~= player and players[user] then
			ui.addTextArea(id..(896+i), user, player, x+4 + (i-1)%2*173, y + math.floor((i-1)/2)*15, nil, nil, -1, 0xff0000, 0, true, 
				function(player, i)
					if not room.terrains[terrainID].settings.permissions[user] then room.terrains[terrainID].settings.permissions[user] = 0 end
					local userPermission = room.terrains[terrainID].settings.permissions[user]
					ui.addTextArea(id..'930', '<p align="center"><ce>'..user..'</ce>\n<v><font size="10">«'..translate("permissions_"..mainAssets.housePermissions[userPermission], player)..'»</font></v>', player, x+4 + (i-1)%2*173, y + math.floor((i-1)/2)*15, 150, 70, 0x432c04, 0x7a5817, 1, true)
					local counter = 0
					for _ = -1, 1 do
						if _ ~= room.terrains[terrainID].settings.permissions[user] then
							ui.addTextArea(id..(931+counter), translate('setPermission', player):format(translate('permissions_'..mainAssets.housePermissions[_], player)), player, x+4 + (i-1)%2*173, y + 25 + math.floor((i-1)/2)*15 + counter*15, nil, nil, 0x432c04, 0x7a5817, 0, true,
								function()
									if room.terrains[terrainID].settings.permissions[user] == _ then return end
									room.terrains[terrainID].settings.permissions[user] = _
									for i = 930, 934 do
										ui.removeTextArea(id..i, player)
									end
									if _ == -1 then
										if room.terrains[terrainID].guests[user] then 
											getOutHouse(user, terrainID)
											alert_Error(user, 'error', 'error_blockedFromHouse', player)
										end
									end
								end)
							counter = counter + 1
						end
					end
				end, i)
			i = i + 1
		end
	end
	local function buttonAction(option)
		if option == 1 then
			if not room.terrains[terrainID].settings.isClosed then
				for guest in next, room.terrains[terrainID].guests do
					if room.terrains[terrainID].guests[guest] then 
						if not room.terrains[terrainID].settings.permissions[guest] then room.terrains[terrainID].settings.permissions[guest] = 0 end
						if room.terrains[terrainID].settings.permissions[guest] < 1 then
							getOutHouse(guest, terrainID)
							alert_Error(guest, 'error', 'error_houseClosed', player)
						end
					end
				end
			end
			room.terrains[terrainID].settings.isClosed = not room.terrains[terrainID].settings.isClosed
		elseif option == 2 then 
			room.terrains[terrainID].settings.permissions = {[player] = 4}
		end
		eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
	end
	for i, v in next, {room.terrains[terrainID].settings.isClosed and translate('houseSettings_unlockHouse', player) or translate('houseSettings_lockHouse', player), translate('houseSettings_reset', player)} do
		button(i, v, function() 
			buttonAction(i)
		end, x + 12 + (i-1)*166, y + 175)
	end
	return setmetatable(self, modernUI)
end
modernUI.showNPCShop = function(self, items)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) + 20
	local y = (200 - height/2) + 65
	local currentPage = 1
	local maxPages = math.ceil(#items/15)
	local boughtSomething = false -- for prevent players from duplicating rare items
	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('172763e41e1.jpg', ":27", x+337, y-14, player)

	local function showItems()
		local minn = 15 * (currentPage-1) + 1
		local maxx = currentPage * 15
		local i = 0
		for _ = minn, maxx do 
			local data = items[_]
			if not data then break end
			local selectedQuanty = 1
			local v = mainAssets.__furnitures[data[1]] or bagItems[data[2]]
			players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage('1722d2d8234.jpg', ":26", x + (i%5)*63, y + math.floor(i/5)*65, player)
			players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage(v.png, ":26", x + 5 + (i%5)*63, y + 5 + math.floor(i/5)*65, player)
			if v.stockLimit and checkIfPlayerHasFurniture(player, data[1]) then
				ui.addTextArea(id..(900+i), '<p align="center"><font size="9"><r>'..translate('error_maxStorage', player), player, x + (i%5)*63, y + 3 + math.floor(i/5)*65, 58, 55, 0xff0000, 0xff0000, 0, true)
				players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage('1725d179b2f.png', ":26", x + (i%5)*63, y + math.floor(i/5)*65, player)
			else
				ui.addTextArea(id..(900+i), '\n\n\n\n', player, x + 3 + (i%5)*63, y + 3 + math.floor(i/5)*65, 55, 55, 0xff0000, 0xff0000, 0, true,
				function(player, i)
					local name = mainAssets.__furnitures[data[1]] and translate('furniture_'..v.name, player) or translate('item_'..data[2], player)
					player_removeImages(players[player]._modernUISelectedItemImages[1])

					ui.addTextArea(id..'890', '<p align="center"><font size="13"><fc>'..name, player, x+340, y-15, 135, 215, 0x24474D, 0x314e57, 0, true)
					local description = item_getDescription(mainAssets.__furnitures[data[1]] and data[1] or data[2], player, mainAssets.__furnitures[data[1]])
					ui.addTextArea(id..'891', '<font size="9"><bl>'..description, player, x+340, y+50, 135, nil, 0x24474D, 0x314e5, 0, true)
					ui.addTextArea(id..'892', '<font color="#cef1c3">'..translate('confirmButton_Select', player), player, x+337, y+151, nil, nil, 0x24474D, 0x314e5, 0, true)
					ui.addTextArea(id..'894', '', player, x + 3 + (i%5)*63, y + 3 + math.floor(i/5)*65, 55, 55, 0xff0000, 0xff0000, 0, true)

					players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(v.png, "&26", 542, 125, player)
					players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage('1722d33f76a.png', ":26", x + (i%5)*63-3, y + math.floor(i/5)*65-3, player)
					local function button(i, text, callback, x, y, width, height, blockClick)
						local colorPallete = {
							button_confirmBg = 0x95d44d,
							button_confirmFront = 0x44662c
						}
						if blockClick then 
							colorPallete.button_confirmBg = 0xbdbdbd
							colorPallete.button_confirmFront = 0x5b5b5b
						end
						ui.addTextArea(id..(930+i*5), '', player, x-1, y-1, width, height, colorPallete.button_confirmBg, colorPallete.button_confirmBg, 1, true)
						ui.addTextArea(id..(931+i*5), '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
						ui.addTextArea(id..(932+i*5), '', player, x, y, width, height, colorPallete.button_confirmFront, colorPallete.button_confirmFront, 1, true)
						ui.addTextArea(id..(933+i*5), '<p align="center"><font color="#cef1c3" size="13">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, not blockClick and callback or nil)
					end
					local currency = v.qpPrice and {players[player].sideQuests[4], v.qpPrice*selectedQuanty} or {players[player].coins, v.price*selectedQuanty}
					local buttonTxt = nil 
					local blockClick = false
				    if currency[1] >= currency[2] then
			    		buttonTxt = '<font size="11">'..translate('confirmButton_Buy', player):format('<b><fc>'..(v.qpPrice and 'QP$'..(v.qpPrice*selectedQuanty) or '$'..(v.price*selectedQuanty)))
					else
						blockClick = true
			    		buttonTxt = '<r>'..(v.qpPrice and 'QP$'..v.qpPrice or '$'..v.price)
					end
					local function buyItem()
						if boughtSomething then return end
						if currency[1] < currency[2] then return alert_Error(player, 'error', 'error') end
						if mainAssets.__furnitures[data[1]] then 
							local total_of_storedFurnitures = 0
							for _, v in next, players[player].houseData.furnitures.stored do 
								total_of_storedFurnitures = total_of_storedFurnitures + v.quanty
							end
							if (total_of_storedFurnitures + selectedQuanty) > maxFurnitureDepot then return alert_Error(player, 'error', 'maxFurnitureDepot', maxFurnitureDepot) end
							if not players[player].houseData.furnitures.stored[data[1]] then 
								players[player].houseData.furnitures.stored[data[1]] = {quanty = selectedQuanty, type = data[1]}
							else 
								players[player].houseData.furnitures.stored[data[1]].quanty = players[player].houseData.furnitures.stored[data[1]].quanty + selectedQuanty
							end
						else
							if (players[player].totalOfStoredItems.bag + selectedQuanty) > players[player].bagLimit then return alert_Error(player, 'error', 'bagError') end
							local item = data[2]
							addItem(item, selectedQuanty, player) 
							for id, properties in next, players[player].questLocalData.other do 
								if id:find('BUY_') then
									if id:lower():find(item:lower()) then 
										if type(properties) == 'boolean' then 
											quest_updateStep(player)
										else 
											players[player].questLocalData.other[id] = properties - selectedQuanty
											if players[player].questLocalData.other[id] <= 0 then 
												quest_updateStep(player)
											end
										end
										break
									end
								end
							end
						end
						if v.qpPrice then
							players[player].sideQuests[4] = players[player].sideQuests[4] - currency[2]
						else
							giveCoin(-currency[2], player)
						end

						boughtSomething = true
						savedata(player)
						eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
					end
					local function addBuyButton(buttonTxt)
						button(0, buttonTxt, 
							function()
								buyItem()
							end, 507, 295, 120, 13, blockClick)
					end
					if not blockClick and not v.stockLimit then
						ui.addTextArea(id..'893', '<font color="#cef1c3">01', player, x+425, y+151, nil, nil, 0x24474D, 0x314e5, 0, true)
						for i = 1, 2 do 
							button(i, i == 1 and '-' or '+', 
								function(player) 
									local calc = i == 1 and -1 or 1
									if (selectedQuanty + calc) > 50 or (selectedQuanty + calc) < 1 then return end
									selectedQuanty = selectedQuanty + calc
									currency = v.qpPrice and {players[player].sideQuests[4], v.qpPrice*selectedQuanty} or {players[player].coins, v.price*selectedQuanty}
									ui.updateTextArea(id..'893', '<font color="#cef1c3">'..string.format("%.2d", selectedQuanty), player)
									buttonTxt = '<font size="11">'..translate('confirmButton_Buy', player):format('<b><fc>'..(v.qpPrice and 'QP$'..(v.qpPrice*selectedQuanty) or '$'..(v.price*selectedQuanty))..'</fc></b>')
									addBuyButton(buttonTxt)
								end, 565 + (i-1)*50, 270, 10, 10)
						end
					end
					addBuyButton(buttonTxt)
				end, i)	
			end
			i = i + 1
		end
	end
	local function updateScrollbar()
		local function updatePage(count)
			if currentPage + count > maxPages or currentPage + count < 1 then return end 
			currentPage = currentPage + count
			player_removeImages(players[player]._modernUISelectedItemImages[1])
			player_removeImages(players[player]._modernUISelectedItemImages[3])
			for i = 897, 929 do 
				ui.removeTextArea(id..i, player)
			end
			updateScrollbar()
			showItems()
		end
		ui.addTextArea(id..'888', string.rep('\n', 10), player, x+2, y+200, 155, 10, 0x24474D, 0xff0000, 0, true, 
			function()
				updatePage(-1)
			end)
		ui.addTextArea(id..'889', string.rep('\n', 10), player, x+157, y+200, 155, 10, 0x24474D, 0xff0000, 0, true, 
			function()
				updatePage(1)
			end)

		player_removeImages(players[player]._modernUISelectedItemImages[2])
		players[player]._modernUISelectedItemImages[2][#players[player]._modernUISelectedItemImages[2]+1] = addImage('1729eacaeb5.jpg', ":26", x+2, y+205, player)
		for i = 1, (10 - math.min(8, maxPages)+1) do 
			players[player]._modernUISelectedItemImages[2][#players[player]._modernUISelectedItemImages[2]+1] = addImage('1729ebf25cc.jpg', ":27", x+2 + (i-1)*31 + (currentPage-1)*31, y+205, player)
		end
	end
	if maxPages > 1 then 
		updateScrollbar()
	end
	showItems()
	return setmetatable(self, modernUI)
end
modernUI.showSettingsMenu = function(self)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) + 20
	local y = (200 - height/2) + 65
	local selectedWindow = 1

	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('17281987ff2.jpg', ":26", x-3, y-23, player)
	local function button(i, text, callback, x, y, width, height)
		local width = width or 110
		local height = height or 15
		ui.addTextArea(id..(930+i*5), '', player, x-1, y-1, width, height, 0x95d44d, 0x95d44d, 1, true)
		ui.addTextArea(id..(931+i*5), '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
		ui.addTextArea(id..(932+i*5), '', player, x, y, width, height, 0x44662c, 0x44662c, 1, true)
		ui.addTextArea(id..(933+i*5), '<p align="center"><font color="#cef1c3" size="13">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, callback)
	end
	local buttons = {}
	local function addToggleButton(setting, name, state, _id)
		if not state then state = players[player].settings[setting] == 1 and true or false end
		buttonType = buttons[_id] and _id or #buttons+1
		buttons[buttonType] = {state = state}
		local buttonID = buttonType
		local x = x + 15
		local y = y + 5 + (#buttons-1)*20
		ui.addTextArea(id..(900+(buttonID-1)*6), "", player, x-1, y-1, 2, 2, 1, 1, 1, true)
		ui.addTextArea(id..(901+(buttonID-1)*6), "", player, x, y, 2, 2, 0x3A5A66, 0x3A5A66, 1, true)
		ui.addTextArea(id..(902+(buttonID-1)*6), "", player, x, y, 1, 1, 0x233238, 0x233238, 1, true)
		ui.addTextArea(id..(903+(buttonID-1)*6), state and '<font size="17">•' or '', player, x-6, y-13, nil, nil, 1, 1, 0, true)
		ui.addTextArea(id..(904+(buttonID-1)*6), '\n', player, x-5, y-5, 10, 10, 1, 0xffffff, 0, true, function(player, buttonID)
			buttons[buttonID].state = not buttons[buttonID].state
			players[player].settings[setting] = buttons[buttonID].state and 1 or 0
			addToggleButton(setting, name, buttons[buttonID].state, buttonID)
		end, buttonID)
		ui.addTextArea(id..(905+(buttonID-1)*6), '<cs>'..name, player, x+10, y-7, nil, nil, 1, 1, 0, true)
	end
	local selectedLang = players[player].lang:upper()
	local function addLangSwitch()
		for i = 0, 20 do 
			ui.removeTextArea(id..(910+i), player)
		end 
		player_removeImages(players[player]._modernUISelectedItemImages[1])
		local x = x + 15
		local y = y + 50
		ui.addTextArea(id..'910', '', player, x-1, y-1, 70, 15, 1, 1, 1, true)
		players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(community[selectedLang:lower()], "&26", x+5, y+3, player)
		ui.addTextArea(id..'911', '<n2>'..selectedLang..'\t↓', player, x+22, y-1, nil, nil, 1, 1, 0, true,
			function()
				local toChoose = {}
				for i, v in next, langIDS do
					if v:upper() ~= selectedLang then 
						toChoose[#toChoose+1] = v:upper()
					end 
				end
				local txt = '\n'..table.concat(toChoose, '\n')
				ui.addTextArea(id..'910', '<font color="#000000">'..txt, player, x-1, y-1, 70, nil, 1, 1, 1, true)
				ui.addTextArea(id..'911', '<n2>'..selectedLang..'\t↑', player, x+22, y-1, nil, nil, 1, 1, 0, true, function()
						addLangSwitch()
					end)
				for i, v in next, toChoose do
					players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(community[v:lower()], "&26", x+5, y+17 + (i-1)*14, player)
					ui.addTextArea(id..(911+i), v, player, x+22, y+14 + (i-1)*14, nil, nil, 1, 1, 0, true, function()
						selectedLang = v
						players[player].lang = lang[v:lower()] and v:lower() or 'en'
						addLangSwitch()
					end)
				end
			end)
	end
	local function showOptions(window)
		selectedWindow = window
		if selectedWindow == 1 then
			ui.addTextArea(id..900, '<font color="#ebddc3" size="13"> '
				..translate('settings_helpText', player)
				..'\n\n\n\n<font size="15">'
				..translate('settings_helpText2', player)
				..'</font>\n'
				..translate('command_profile', player), player, x, y -23, 485, 200, 0xff0000, 0xff0000, 0, true)
			button(5, 'Mycity Wiki', function(player) TFM.chatMessage('<rose>https://transformice.fandom.com/wiki/Mycity', player) end, x+22, y+30, 435, 12)
		elseif selectedWindow == 2 then
			buttons = {}
			ui.addTextArea(id..931, '<font color="#ebddc3" size="13">\n\n\n'..translate('settings_config_lang', player), player, x, y -23, 485, nil, 0xff0000, 0xff0000, 0, true)
			addToggleButton('mirroredMode', translate('settings_config_mirror', player))
			addLangSwitch()
		elseif selectedWindow == 3 then
			players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage('17281d1a0f9.png', ":26", 505, y+10, player)
			local credit = mainAssets.credits 
			local counter = 0

			for i, v in next, credit.translations do 
				players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(community[v], "&70", x+32, y + 7 + counter*13, player)
				ui.addTextArea(id..902+counter, '<g>'..i, player, x+50, y + 4 + counter*13, nil, nil, 0xff0000, 0xff0000, 0, true)
				counter = counter + 1
			end
			ui.addTextArea(id..900, '<font color="#ebddc3"> '..
				translate('settings_creditsText', player)
				:format(table.concat(credit.creator),
					table.concatFancy(credit.arts, ", ", translate('wordSeparator', player)))
				, player, x, y -23, 485, 200, 0xff0000, 0xff0000, 0, true)
			ui.addTextArea(id..901, '<font color="#ebddc3"> '..
				translate('settings_creditsText2', player)
				:format(table.concatFancy(credit.help, ", ", translate('wordSeparator', player)))
				, player, x, y + 145, 485, nil, 0xff0000, 0xff0000, 0, true)

		elseif selectedWindow == 4 then
			players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage('17136fe68cc.png', ":26", 520, y - 20, player)
			ui.addTextArea(id..900, '<font color="#ebddc3" size="10"> '..translate('settings_donateText', player), player, x, y -23, 365, 200, 0xff0000, 0xff0000, 0, true)
			--ui.addTextArea(id..901, '<font size="10"><rose>'..translate('settings_donateText2', player), player, x, y +112, 485, nil, 0xff0000, 0xff0000, 0, true)

			button(5, translate('settings_donate', player), function(player) TFM.chatMessage('<rose>https://a801-luadev.github.io/?redirect=mycity', player) end, x+50, y+150, 250)
		end
		ui.addTextArea(id..899, '', player, x + (window-1)*123.5, y + 197, 110, 15, 0xbdbdbd, 0xbdbdbd, 0.5, true)
	end
	for i, v in next, {translate('settings_help', player), translate('settings_settings', player), translate('settings_credits', player), translate('settings_donate', player)} do 
		button(i, v, function()
			if i == selectedWindow then return end
			player_removeImages(players[player]._modernUISelectedItemImages[1])
			for i = 0, 3 do 
				ui.removeTextArea(id..(955+i), player)
			end
			for i = 899, 931 do 
				ui.removeTextArea(id..i, player)
			end
			showOptions(i)
		end, x + (i-1)*123.5, y + 197)
	end
	showOptions(1)
	return setmetatable(self, modernUI)
end