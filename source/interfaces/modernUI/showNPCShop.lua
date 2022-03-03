modernUI.showNPCShop = function(self, items, npc)
	local id = self.id
	local player = self.player
	local width = self.width
	local height = self.height
	local x = (400 - width/2) + 20
	local y = (200 - height/2) + 65
	local currentPage = 1
	local maxPages = math.ceil(#items/15)
	local boughtSomething = false -- for prevent players from duplicating items
	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('172763e41e1.jpg', "~27", x+337, y-14, player)

	local function showItems()
		local minn = 15 * (currentPage-1) + 1
		local maxx = currentPage * 15
		local i = 0
		for _ = minn, maxx do
			local data = items[_]
			if not data then break end
			local selectedQuanty = 1
			local v = mainAssets.__furnitures[data[1]] or bagItems[data[2]]

			players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage('1722d2d8234.jpg', "~26", x + (i%5)*63, y + floor(i/5)*65, player)
			players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage(v.png, "~26", x + 5 + (i%5)*63, y + 5 + floor(i/5)*65, player)
			if v.stockLimit and checkIfPlayerHasFurniture(player, data[1]) then
				showTextArea(id..(900+i*2), '<p align="center"><font size="9"><r>'..translate('error_maxStorage', player), player, x + (i%5)*63, y + 3 + floor(i/5)*65, 58, 55, 0xff0000, 0xff0000, 0, true)
				players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage('1725d179b2f.png', "~26", x + (i%5)*63, y + floor(i/5)*65, player)
			elseif v.requireQuest and players[player].questStep[1] <= v.requireQuest then
				showTextArea(id..(900+i*2), '<p align="center"><font size="9"><r>'..translate('locked_quest', player):format(v.requireQuest), player, x + (i%5)*63, y + 3 + floor(i/5)*65, 58, 55, 0xff0000, 0xff0000, 0, true)
				players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage('1725d179b2f.png', "~26", x + (i%5)*63, y + floor(i/5)*65, player)
			else
				if v.limitedTime and not formatDaysRemaining(v.limitedTime, true) then
					showTextArea(id..(901+i*2), '<p align="center"><font size="9"><r>'..translate('daysLeft2', player):format(formatDaysRemaining(v.limitedTime)), player, x + 3 + (i%5)*63, y + 49 + floor(i/5)*65, 55, nil, 0xff0000, 0xff0000, 0, true)
				end

				showTextArea(id..(900+i*2), '\n\n\n\n', player, x + 3 + (i%5)*63, y + 3 + floor(i/5)*65, 55, 55, 0xff0000, 0xff0000, 0, true,
				function(player, i)
					local isFurniture = mainAssets.__furnitures[data[1]]
					local name = isFurniture and translate('furniture_'..v.name, player) or translate('item_'..data[2], player)
					removeGroupImages(players[player]._modernUISelectedItemImages[1])

					if not isFurniture and data[2]:find('energymax') then
						name = translate('item_energymax', player)
					end

					showTextArea(id..'890', '<p align="center"><font size="13"><fc>'..name, player, x+340, y-15, 135, 215, 0x24474D, 0x314e57, 0, true)
					local description = item_getDescription(mainAssets.__furnitures[data[1]] and data[1] or data[2], player, mainAssets.__furnitures[data[1]])

					showTextArea(id..'891', '<font size="9"><bl>'..description, player, x+340, y+50, 135, nil, 0x24474D, 0x314e5, 0, true)
					showTextArea(id..'894', '', player, x + 3 + (i%5)*63, y + 3 + floor(i/5)*65, 55, 55, 0xff0000, 0xff0000, 0, true)

					players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(v.png, "&26", 542, 125, player)
					players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage('1722d33f76a.png', "~26", x + (i%5)*63-3, y + floor(i/5)*65-3, player)
					local function button(i, text, callback, x, y, width, height, blockClick)
						local colorPallete = {
							button_confirmBg = 0x95d44d,
							button_confirmFront = 0x44662c
						}
						if blockClick then
							colorPallete.button_confirmBg = 0xbdbdbd
							colorPallete.button_confirmFront = 0x5b5b5b
						end
						showTextArea(id..(990+i*5), '', player, x-1, y-1, width, height, colorPallete.button_confirmBg, colorPallete.button_confirmBg, 1, true)
						showTextArea(id..(991+i*5), '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
						showTextArea(id..(992+i*5), '', player, x, y, width, height, colorPallete.button_confirmFront, colorPallete.button_confirmFront, 1, true)
						showTextArea(id..(993+i*5), '<p align="center"><font color="#cef1c3" size="13">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, not blockClick and callback or nil)
					end
					local isWithDiamond = v.qpPrice
					local currency = isWithDiamond and {players[player].sideQuests[4], v.qpPrice*selectedQuanty} or {players[player].coins, v.price*selectedQuanty}
					local buttonTxt = nil
					local blockClick = false
					local color = isWithDiamond and mainAssets.currencies.diamond.color or mainAssets.currencies.coin.color

					if currency[1] >= currency[2] then
						buttonTxt = color..(v.qpPrice or v.price)
					else
						blockClick = true
						buttonTxt = '<r>$'..(v.qpPrice or v.price)
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
							giveDiamond(-currency[2], player)
						else
							giveCoin(-currency[2], player)
						end

						sideQuest_sendTrigger(player, 'buy_from_npc', selectedQuanty, npc)
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
						showTextArea(id..'892', '<font color="#cef1c3">'..translate('confirmButton_Select', player), player, x+337, y+151, nil, nil, 0x24474D, 0x314e5, 0, true)
						showTextArea(id..'893', '<font color="#cef1c3">01', player, x+425, y+151, nil, nil, 0x24474D, 0x314e5, 0, true)
						for i = 1, 2 do
							button(i, i == 1 and '-' or '+',
								function(player)
									local calc = i == 1 and -1 or 1
									if (selectedQuanty + calc) > 50 or (selectedQuanty + calc) < 1 then return end
									selectedQuanty = selectedQuanty + calc
									currency = v.qpPrice and {players[player].sideQuests[4], v.qpPrice*selectedQuanty} or {players[player].coins, v.price*selectedQuanty}
									ui.updateTextArea(id..'893', '<font color="#cef1c3">'..string.format("%.2d", selectedQuanty), player)
									buttonTxt = color..(v.qpPrice and (v.qpPrice*selectedQuanty) or (v.price*selectedQuanty))
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
		players[player]._modernUISelectedItemImages[2][#players[player]._modernUISelectedItemImages[2]+1] = addImage('1729eacaeb5.jpg', "~26", x+2, y+205, player)
		for i = 1, (10 - math.min(8, maxPages)+1) do
			players[player]._modernUISelectedItemImages[2][#players[player]._modernUISelectedItemImages[2]+1] = addImage('1729ebf25cc.jpg', "~27", x+2 + (i-1)*31 + (currentPage-1)*31, y+205, player)
		end
	end
	if maxPages > 1 then
		updateScrollbar()
	end
	showItems()
	return setmetatable(self, modernUI)
end
