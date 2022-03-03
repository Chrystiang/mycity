modernUI.showHouses = function(self, selectedTerrain)
	local id 		= self.id
	local player 	= self.player
	local width 	= self.width
	local height 	= self.height
	local x 		= (400 - width/2) + 20
	local y 		= (200 - height/2) + 65
	local i 		= 0

	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('172763e41e1.jpg', "~27", x+337, y-14, player)
	
	for _ = 1, #mainAssets.__houses do
		local v = mainAssets.__houses[_]
		local isLimitedTime = v.properties.limitedTime
		local isOutOfSale 	= isLimitedTime and formatDaysRemaining(isLimitedTime, true)
		local showItem 		= true

		if isLimitedTime and (isOutOfSale and not table_find(players[player].houses, _)) then
			showItem = false
		end

		if v.properties.requires and showItem then
			showItem = v.properties.requires(player)
		end

		if showItem then
			i = i + 1

			local image = v.properties.png or '16c25233487.png'
			players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage('1722d2d8234.jpg', "~26", x + ((i-1)%5)*63, y + floor((i-1)/5)*65, player)
			players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage(image, "~26", x + 5 + ((i-1)%5)*63, y + 5 + floor((i-1)/5)*65, player)
			
			if isLimitedTime and not isOutOfSale then
				showTextArea(id..(895+i*2), '<p align="center"><font size="9"><r>'..translate('daysLeft2', player):format(formatDaysRemaining(isLimitedTime)), player, x + 3 + ((i-1)%5)*63, y + 49 + floor((i-1)/5)*65, 55, nil, 0xff0000, 0xff0000, 0, true)
			end

			showTextArea(id..(896+i*2), '\n\n\n\n', player, x + 3 + ((i-1)%5)*63, y + 3 + floor((i-1)/5)*65, 55, 55, 0xff0000, 0xff0000, 0, true,
				function(player, i)
					local itemName = translate('House'.._, player)
					removeGroupImages(players[player]._modernUISelectedItemImages[1])
					showTextArea(id..'890', '<p align="center"><font size="13"><fc>'..itemName, player, x+340, y-15, 135, 215, 0x24474D, 0x314e57, 0, true)
					local description = '<p align="center"><i>"'..translate('houseDescription_'.._, player)..'"</i>\n\n'
					if isLimitedTime and table_find(players[player].houses, _) then
						description = description..'<r>'..translate('collectorItem', player)
					end
					showTextArea(id..'891', '<font size="9"><bl>'..description, player, x+340, y+65, 135, nil, 0x24474D, 0x314e5, 0, true)
					showTextArea(id..'894', '', player, x + 3 + ((i-1)%5)*63, y + 3 + floor((i-1)/5)*65, 55, 55, 0xff0000, 0xff0000, 0, true)

					players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(image, "&26", 542, 125, player)
					players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage('1722d33f76a.png', "~26", x + ((i-1)%5)*63-3, y + floor((i-1)/5)*65-3, player)
					local function button(i, text, callback, x, y, width, height, blockClick)
						local colorPallete = {
							button_confirmBg = 0x95d44d,
							button_confirmFront = 0x44662c
						}
						if blockClick then
							colorPallete.button_confirmBg = 0xbdbdbd
							colorPallete.button_confirmFront = 0x5b5b5b
						end
						showTextArea(id..(930+i*5), '', player, x-1, y-1, width, height, colorPallete.button_confirmBg, colorPallete.button_confirmBg, 1, true)
						showTextArea(id..(931+i*5), '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
						showTextArea(id..(932+i*5), '', player, x, y, width, height, colorPallete.button_confirmFront, colorPallete.button_confirmFront, 1, true)
						showTextArea(id..(933+i*5), '<p align="center"><font color="#cef1c3" size="13">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, not blockClick and callback or nil)
					end

					local buttonType 	= nil
					local blockClick 	= false
					local buttonAction 	= nil

					if table_find(players[player].houses, _) then
						buttonType =  translate('use', player)
						buttonAction = 'use'
					elseif players[player].coins >= v.properties.price then
						local color = mainAssets.currencies.coin.color

						buttonType = color .. (v.properties.price)
						buttonAction = 'buy'
					else
						blockClick = true
						buttonType = '<r>$'..v.properties.price
					end

					button(1, buttonType,
						function(player)
							if buttonAction == 'use' then
								eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
								modernUI.new(player, 240, 170, translate('chooseSaveSlot', player))
									:build()
										:showHouseSlotsToChoose(_, selectedTerrain)

							elseif buttonAction == 'buy' then
								if room.terrains[selectedTerrain].owner then return alert_Error(player, 'error', 'alreadyLand') end
								if table_find(players[player].houses, _) then return end

								eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
								players[player].houses[#players[player].houses+1] = _
								giveCoin(-v.properties.price, player)
								removeTextArea(24 + selectedTerrain)
								removeTextArea(44 + selectedTerrain)
								removeTextArea(selectedTerrain)

								modernUI.new(player, 120, 120)
								:build()
								players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(v.properties.png, "&70", 400 - 50 * 0.5, 180, player)
							end
						end, 507, 295, 120, 13, blockClick)
				end, i)
		end
	end
	return setmetatable(self, modernUI)
end