modernUI.showPlayerItems = function(self, items, chest)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) + 20
	local y = (200 - height/2) + 65
	local currentPage = 1
	if not items then return alert_error(player, 'error', 'emptyBag') end
	local usedSomething = false
	local storageLimits = {chest and players[player].totalOfStoredItems.chest[chest] or players[player].totalOfStoredItems.bag, chest and 50 or players[player].bagLimit}
	local storageAmount = storageLimits[1]..'/'..storageLimits[2]
	local sizeScale = {}
	if #items > 15 then
		--[[
			[1] Max items per page, 
			[2] itemSize, 
			[3] background image, 
			[4] selected image,
			[5] items per line, 
			[6] item image align,
			[7] item amount align,
			[8] item amount text size
			[9] background image if is a collector's item
		]]
		sizeScale = {32, 42, '174283c22c9.jpg', '174284cb5fc.png', 8, -5, 27, 10, '174eae7e0e1.jpg'}
	else
		sizeScale = {15, 62, '1722d2d8234.jpg', '1742b444b05.png', 5, 5, 42, 13, '174eae7bca9.jpg'}
	end
	local maxPages = math.ceil(#items/sizeScale[1])

	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('172763e41e1.jpg', ":27", x+337, y-14, player)
	showTextArea(id..'895', '<font color="#95d44d">'..translate('itemAmount', player):format('<cs>'..storageAmount..'</cs>'), player, x, y -20, 312, nil, 0xff0000, 0xff0000, 0, true)
	local function showItems()
		local minn = 32 * (currentPage-1) + 1
		local maxx = currentPage * 32
		local i = 0
		for _ = 1, #items do 
			i = i + 1 
			local v = items[_]
			if i >= minn and i <= maxx then
				local itemData = bagItems[v.name]
				local i = i - 32 * (currentPage-1)
				local image = itemData.png or '16bc368f352.png'
				local _x = x + ((i-1)%sizeScale[5]) * sizeScale[2]
				local _y = y + floor((i-1)/sizeScale[5]) * sizeScale[2]
				local bgImage = itemData.limitedTime and 9 or 3

				players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage(sizeScale[bgImage], ":26", _x, _y, player)
				players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage(image, ":26", _x + sizeScale[6], _y + sizeScale[6], player)
				showTextArea(id..(895+i*2), '<p align="right"><font color="#95d44d" size="'..sizeScale[8]..'"><b>x'..v.qt, player, _x, _y + sizeScale[7], sizeScale[2] - 2, nil, 0xff0000, 0xff0000, 0, true)
				showTextArea(id..(896+i*2), '\n\n\n\n', player, _x + 3, _y + 3, sizeScale[2] - 2, sizeScale[2] -2, 0xff0000, 0xff0000, 0, true,
					function(player)
						local itemName = v.name 
						local quanty = v.qt 
						local itemType = itemData.type
						local power = itemData.power or 0
						local hunger = itemData.hunger or 0
						local blockUse = not itemData.func
						if (itemType == 'food' or itemType == 'holdingItem') then blockUse = false end
						if (chest and itemType == 'holdingItem') then blockUse = true end
						local selectedQuanty = 1

						removeGroupImages(players[player]._modernUISelectedItemImages[1])
						for i = 0, 8 do 
							removeTextArea(id..(990+i), player)
						end
						for ii = 1, 50 do
							removeTextArea(id..(1000+ii), player)
						end
						local description = item_getDescription(itemName, player)
						if itemName:find('_luckyFlowerSeed') then
							itemName = 'luckyFlowerSeed'
						elseif itemName:find('_luckyFlower') then
							itemName = 'luckyFlower'
						end
						showTextArea(id..'890', '<p align="center"><font size="13"><fc>'..translate('item_'..itemName, player), player, x+340, y-15, 135, 215, 0x24474D, 0x314e57, 0, true)
						showTextArea(id..'891', '<font size="9"><bl>'..description, player, x+340, y+50, 135, nil, 0x24474D, 0x314e5, 0, true)

						players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(image, ":200", 542, 125, player)
						players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(sizeScale[4], ":26", _x - 1, _y - 1, player)

						local function button(i, text, callback, x, y, width, height)
							showTextArea(id..(990+i*5), '', player, x-1, y-1, width, height, 0x95d44d, 0x95d44d, 1, true)
							showTextArea(id..(991+i*5), '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
							showTextArea(id..(992+i*5), '', player, x, y, width, height, 0x44662c, 0x44662c, 1, true)
							showTextArea(id..(993+i*5), '<p align="center"><font color="#cef1c3" size="13">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, callback)
						end
						if not blockUse then
							button(0, translate(itemType == 'food' and 'eatItem' or 'use', player), 
							function(player)
								if usedSomething then return end
								if players[player].isTrading then return alert_Error(player, 'error', 'error') end
								if players[player].canDrive then return alert_Error(player, 'error', 'error') end
								if quanty <= 0 then return alert_Error(player, 'error', 'error') end
								if selectedQuanty > quanty then return alert_Error(player, 'error', 'error') end
								
								if itemName == 'cheese' then 
									if players[player].whenJoined > os_time() then 
										return alert_Error(player, 'error', 'limitedItemBlock', '120')
									else 
										players[player].whenJoined = os_time() + 120*1000
									end
								end
								eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
								local condition = (itemData.func and not itemData.fertilizingPower) and -1 or -selectedQuanty
								if itemType ~= 'holdingItem' then
									if not chest then
										if not checkItemQuanty(v.name, condition*-1, player) then return end
										removeBagItem(v.name, condition, player)
									else
										item_removeFromChest(v.name, condition, player, chest)
									end
								end
								if itemType == 'food' then 
									setLifeStat(player, 1, power * selectedQuanty)
									setLifeStat(player, 2, hunger * selectedQuanty)
								elseif itemType == 'holdingItem' then
									local playerData = players[player]
									local holdingItem = v.name 
									local holdingImage
									playerData.holdingItem = holdingItem
									showTextArea(9901327, '', player, -5, -5, 820, 420, 1, 1, 0.5, true)
									showTextArea(98900000019, '<p align="center"><b><font color="#00FF00" size="20">✓\n', player, 350, 330, 100, nil, 1, 1, 0, true,
										function()
											if not playerData.holdingItem then return end
											local x = ROOM.playerList[player].x
											local y = ROOM.playerList[player].y

											local seed = nil
											local seedToDrop = holdingItem

											if holdingItem == 'random_luckyFlowerSeed' then
												local colors = {5, 10, 11, 12, 13, 14, 15}
												seed = colors[random(#colors)]

												holdingItem = 'seed'
											else
												if string_find(holdingItem, 'Seed') then
													for i, v in next, HouseSystem.plants do
														if string_find(v.name, holdingItem:gsub('Seed', '')) then
															holdingItem = 'seed'
															seed = i
														end
													end
												end
											end

											local used = false

											if not bagItems[holdingItem].fertilizingPower then 
												if not bagItems[holdingItem].placementFunction(player, x, y, seed) then
													if not seedToDrop then return end
													eventTextAreaCallback(0, player, 'closebag', true)
												else
													if not checkItemQuanty(v.name, condition*-1, player) then return end
													used = true
													for id, properties in next, playerData.questLocalData.other do
														if id:find('plant_') then
															if id:lower():find(seedToDrop:lower()) then
																quest_updateStep(player)
															end
														end
													end
												end
											else
												if not checkItemQuanty(v.name, condition*-1, player) then return end
												used = true
												bagItems[holdingItem].placementFunction(player, selectedQuanty * itemData.fertilizingPower)
											end
											-- Remove Item
											if used then
												removeBagItem(v.name, condition, player)
											end

											removeImage(holdingImage)
											playerData.holdingItem = false
											removeTextArea(9901327, player)
											removeTextArea(98900000019, player)
											savedata(player)
										end)
									
									local isFacingRight = ROOM.playerList[player].isFacingRight
									local image = bagItems[holdingItem].holdingImages[(isFacingRight and 2 or 1)]
									local x = bagItems[holdingItem].holdingAlign[(isFacingRight and 2 or 1)][1]
									local y = bagItems[holdingItem].holdingAlign[(isFacingRight and 2 or 1)][2]

									holdingImage = addImage(image, '$'..player, x, y)

									local holdingTimer
									holdingTimer = addTimer(function()
										if not playerData.holdingItem then
											removeTimer(holdingTimer)
											return
										else
											isFacingRight = ROOM.playerList[player].isFacingRight
											image = bagItems[holdingItem].holdingImages[(isFacingRight and 2 or 1)]
											x = bagItems[holdingItem].holdingAlign[(isFacingRight and 2 or 1)][1]
											y = bagItems[holdingItem].holdingAlign[(isFacingRight and 2 or 1)][2]

											if image ~= holdingImage then
												removeImage(holdingImage)
												holdingImage = addImage(image, "$" .. player, x, y)
											end
										end
									end, 500, 0)
								else
									itemData.func(player, selectedQuanty)
								end
								local sidequest = sideQuests[players[player].sideQuests[1]].type
								if string_find(sidequest, 'type:items') then
									if string_find(sidequest, 'use') then
										sideQuest_update(player, 1)
								 	end
								end
								usedSomething = true
								savedata(player)
								return
							end, 507, 265, 120, 13)
						end
						button(1, translate(chest and 'passToBag' or 'drop', player), 
							function(player)
								eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
								if usedSomething then return end
								if players[player].isTrading then return alert_Error(player, 'error', 'error') end
								if quanty > 0 then
									if not chest then
										if checkItemQuanty(v.name, selectedQuanty, player) then
											removeBagItem(v.name, -selectedQuanty, player)
											item_drop(v.name, player, selectedQuanty)
										end
									else
										item_removeFromChest(v.name, selectedQuanty, player, chest)
										addItem(v.name, selectedQuanty, player)
									end
									usedSomething = true
									savedata(player)
								end
							end, 507, 295, 120, 13)

						local x = 503
						local y = y+121 + (blockUse and 30 or 0)
						local length = 120


						local selectAmount 
						selectAmount = function()
							for i = quanty, 1, -1 do
									showTextArea(id..(1000+i), '<font color="#cef1c3"><p align="center">'..string.format("%.2d", i), player, x - 8 + ((i-1)%6)*25, y - 25 - math.floor((i-1)/6)*25, nil, nil, 0x1, 0x1, 0.8, true, 
										function()
											selectedQuanty = i
											showTextArea(id..'893', '<font color="#cef1c3"><p align="center">'..string.format("%.2d", selectedQuanty), player, x+8, y, length, nil, 0x44662c, 0x44662c, 0, true,
												function()
													selectAmount()
												end)
											for ii = 1, quanty do
												removeTextArea(id..(1000+ii), player)
											end
										end)
								end
						end
						showTextArea(id..'893', '<font color="#cef1c3"><p align="center">01\n', player, x+8, y, length, nil, 0x44662c, 0x44662c, 0, true,
							function()
								selectAmount()
							end)

						--[[
						for i = 1, 2 do 
							button(1+i, i == 1 and '-' or '+', 
								function(player) 
									local calc = i == 1 and -1 or 1
									if (selectedQuanty + calc) > quanty or (selectedQuanty + calc) < 1 then return end
									selectedQuanty = selectedQuanty + calc
									ui.updateTextArea(id..'893', '<font color="#cef1c3">'..string.format("%.2d", selectedQuanty), player)
								end, 565 + (i-1)*50, 240 + (blockUse and 30 or 0), 10, 10)
						end]]
					end)
			end
		end
	end
	local function updateScrollbar()
		local function updatePage(count)
			if currentPage + count > maxPages or currentPage + count < 1 then return end 
			currentPage = currentPage + count
			removeGroupImages(players[player]._modernUISelectedItemImages[1])
			removeGroupImages(players[player]._modernUISelectedItemImages[3])
			for i = 897, 1020 do 
				removeTextArea(id..i, player)
			end
			updateScrollbar()
			showItems()
		end
		showTextArea(id..'888', string.rep('\n', 10), player, x+2, y+200, 155, 10, 0x24474D, 0xff0000, 0, true, 
			function()
				updatePage(-1)
			end)
		showTextArea(id..'889', string.rep('\n', 10), player, x+157, y+200, 155, 10, 0x24474D, 0xff0000, 0, true, 
			function()
				updatePage(1)
			end)

		removeGroupImages(players[player]._modernUISelectedItemImages[2])
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