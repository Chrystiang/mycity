showTextArea = function(id, text, player, x, y, width, height, color1, color2, alpha, followPlayer, callback, args)
	if players[player] and players[player].settings.mirroredMode == 1 then
		if not text:find('align="center"') and not text:find('align="left"') and not text:find('align="right"') then
			text = '<p align="right">'..text
		elseif text:find('align="right"') or text:find("align='right'") then
			text = text:gsub('right', 'left')
		end
	end
	if callback and players[player] then
		players[player]._modernUIOtherCallbacks[#players[player]._modernUIOtherCallbacks+1] = {event = callback, callbacks = args}
		text = '<a href="event:modernUI_CallbackEvent_'..#players[player]._modernUIOtherCallbacks..'">'..text
	end
	return addTextArea(id, text, player, x, y, width, height, color1, color2, alpha, followPlayer)
end

addButton = function(id, text, player, x, y, width, height, blocked, ...)
	showTextArea(id+1, '', player, x-1, y-1, width, height, 0x97a6aa, 0x97a6aa, 1, true)
	showTextArea(id+2, '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
	if blocked then
		showTextArea(id+3, '', player, x, y, width, height, 0x22363c, 0x22363c, 1, true)
		showTextArea(id+4, '<p align="center"><font color="#999999">'..text, player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true)
	else
		showTextArea(id+3, '', player, x, y, width, height, 0x314e57, 0x314e57, 1, true)
		showTextArea(id+4, '<p align="center">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, ...)
	end
end

showPopup = function(id, player, title, text, x, y, width, height, button, type, arg, ativado)
	eventTextAreaCallback(0, player, 'closebag', true)
	local txt = text
	local x = x - 12
	showTextArea(id..'879', '', player, -5, -5, 820, 420, 1, 1, 0.5, true)
	showTextArea(id..'880', '', player, x+-2, y+18, width+24, height+14, 0x2E221B, 0x2E221B, 1, true)
	showTextArea(id..'881', '', player, x-1, y+19, width+22, height+12, 0x78462b, 0x78462b, 1, true)

	showTextArea(id..'886', '', player, x+2, y+22, width+16, height+6, 0x171311, 0x171311, 1, true)
	showTextArea(id..'887', '', player, x+3, y+23, width+14, height+4, 0x0C191C, 0x0C191C, 1, true)

	if title then
		showTextArea(id..'888', '\n'..txt, player, x+4, y+28, width+12, height+-2, 0x152d30, 0x152d30, 1, true)
   		showTextArea(id..'889', '', player, x-2, y+10, width+24, 23, 0x110a08, 0x110a08, 1, true)
		showTextArea(id..'890', '<p align="center"><font size="10" color="#ffd991">'..title, player, x-1, y+11, width+22, 20, 0x38251a, 0x38251a, 1, true)
	else
		showTextArea(id..'888', txt, player, x+4, y+24, width+12, height+2, 0x152d30, 0x152d30, 1, true)
		players[player].callbackImages[#players[player].callbackImages+1] = addImage("155cbe99c72.png", "&1", x-8, y+12, player)
		players[player].callbackImages[#players[player].callbackImages+1] = addImage("155cbea943a.png", "&1", (x+width)+1, y+12, player)
	end

	players[player].callbackImages[#players[player].callbackImages+1] = addImage("155cbe97a3f.png", "&1", x-8, (y+height)+10, player)
	players[player].callbackImages[#players[player].callbackImages+1] = addImage("155cbe9bc9b.png", "&1", (x+width)+1, (y+height)+10, player)

	if not button then
		showTextArea(id..'891', '', player, x+14, y+height-20+25, width-10, 15, 0x97a6aa, 0x97a6aa, 1, true)
		showTextArea(id..'892', '', player, x+16, y+height-20+27, width-10, 15, 0x1, 0x1, 1, true)
		showTextArea(id..'893', '<p align="center"><a href="event:close3_'..id..'"><N>'.. translate('close', player) ..'</a>', player, x+15, y+height-20+26, width-10, nil, 0x314e57, 0x314e57, 1, true)
	end

	if type == 18 then -- VAULT PASSWORD
		if not players[player].place == 'bank' then return end
		showTextArea(id..'891', '', player, x+14, y+height-20+25, width-10, 15, 0x97a6aa, 0x97a6aa, 1, true)
		showTextArea(id..'892', '', player, x+16, y+height-20+27, width-10, 15, 0x1, 0x1, 1, true)
		showTextArea(id..'893', '<p align="center"><a href="event:closeVaultPassword"><N>'.. translate('close', player) ..'</a>', player, x+15, y+height-20+26, width-10, 15, 0x314e57, 0x314e57, 1, true)

		for i = 1, 9 do
			showTextArea(id..(889+(i-1)*14), '<vp><p align="center">'..i, player, x+25 + floor((i-1)%3)*26, y+26+50 + floor((i-1)/3)*26, 15, 15, 0x314e57, 0x314e57, 0.5, true)
			showTextArea(id..(890+(i-1)*14), '<a href="event:insertVaultPassword_'..i..'">'..string.rep('\n', 5), player, x+22 + floor((i-1)%3)*26, y+23+50 + floor((i-1)/3)*26, 20, 20, 0xff0000, 0xff0000, 0, true)
		end
		local teclas = {'*', '0', '#'}
		for i = 1, 3 do
			showTextArea(id..(889+(8+i)*14), '<vp><p align="center">'..teclas[i], player, x+25 + (i-1)*26, y+26+50 + floor((9+i-1)/3)*26, 15, 15, 0x314e57, 0x314e57, 0.5, true)
			showTextArea(id..(890+(8+i)*14), '<a href="event:insertVaultPassword_'..teclas[i]..'">'..string.rep('\n', 5), player, x+22 + (i-1)*26, y+23+50 + floor((9+i-1)/3)*26, 20, 20, 0xff0000, 0xff0000, 0, true)
		end
		local password = ''
		if players[player].bankPassword then
			for i = 1, #players[player].bankPassword do
				password = password .. players[player].bankPassword:sub(i, i).. ' '
			end
			if #players[player].bankPassword < 4 then
				password = password .. string.rep('_ ', 4 - #players[player].bankPassword)
			else
				if players[player].bankPassword == room.bankVaultPassword then
					password = '<vp>'.. password
					addTimer(function()
						room.bankRobStep = 'vault'
						removeTextArea(-510, nil)
						removeImage(room.bankDoors[1])
						removeGround(9999)
						for players in next, ROOM.playerList do
							eventTextAreaCallback(0, players, 'closeVaultPassword', true)
						end
					end, 1000, 1)
				else
					password = '<r>'.. password
					showTextArea(id..(890+(8+5)*14), '', player, x+20, y+20, width, height, 0xff0000, 0xff0000, 0, true)

					addTimer(function()
						password = '_ _ _ _'
						removeTextArea(id..(890+(8+5)*14), player)
						showTextArea(id..(890+(8+4)*14), '<p align="center"><font color="#ffffff" size="15">'..password, player, x+10 , y+25, width, 40, 0xff0000, 0xff0000, 0, true)
					end, 1000, 1)
				end
				players[player].bankPassword = nil
			end
		else
			password = '_ _ _ _'
		end
		showTextArea(id..(890+(8+4)*14), '<p align="center"><font color="#ffffff" size="15">'..password, player, x+10 , y+25, width, 40, 0xff0000, 0xff0000, 0, true)
	end
end

sendMenu = function(id, player, text, x, y, width, height, alpha, close, arg, prof, interface, tela, type, coin, showCoin)
	local playerData = players[player]
	if type and type ~= 16 and type ~= -10 then
		showTextArea(9901327, '', player, -5, -5, 820, 420, 1, 1, 0.5, true)
	end
	showTextArea(id..'0', '', player, x+-2, y+18, width+24, height+14, 0x2E221B, 0x2E221B, alpha, true)
	showTextArea(id..'00', '', player, x+-1, y+19, width+22, height+12, 0x78462b, 0x78462b, alpha, true)
	showTextArea(id..'000', '', player, x, y+20, width+20, height+10, 0x171311, 0x171311, alpha, true)
	showTextArea(id..'0000', '', player, x+3, y+23, width+14, height+4, 0x0C191C, 0x0C191C, alpha, true)
	showTextArea(id..'00000', '', player, x+4, y+24, width+12, height+2, 0x24474D, 0x24474D, alpha, true)
	showTextArea(id..'000000', '', player, x+5, y+25, width+10, height+0, 0x183337, 0x183337, alpha, true)
	showTextArea(id..'0000000', text, player, x+6, y+26, width+8, height+-2, 0x122528, 0x122528, alpha, true)

	if close then
		showTextArea(id..'00000000', '', player, x+15, y+height-20+25, width-10, 15, 0x97a6aa, 0x97a6aa, alpha, true)
		showTextArea(id..'000000000', '', player, x+15, y+height-20+27, width-10, 15, 0x1, 0x1, alpha, true)
	  	showTextArea(id..'0000000000', '<p align="center"><a href="event:fechar@'..id..'"><N>'.. translate('close', player) ..'</a>', player, x+15, y+height-20+26, width-10, nil, 0x314e57, 0x314e57, alpha, true)
	end
	if tela then
		showTextArea(id..'00000000', '', player, x+15, y+height-20+10, width-10, 15, 0x5D7D90, 0x5D7D90, alpha, true)
		showTextArea(id..'000000000', '', player, x+15, y+height-20+12, width-10, 15, 0x11171C, 0x11171C, alpha, true)
		showTextArea(id..'0000000000', '<p align="center"><a href="event:fechar@'..id..'"><N>'.. translate('close', player) ..'</a>', player, x+15, y+height-20+11, width-10, 15, 0x3C5064, 0x3C5064, alpha, true)
	end
	if type == 11 then
		local names = {[1] = {}, [2] = {},}
		for i = 1, 4 do
			for v = 1, 2 do
				if room.hospital[i][v].name then
					names[v][#names[v]+1] = '<cs>'..room.hospital[i][v].name
				else
					names[v][#names[v]+1] = '<n>---'
				end
			end
		end
		table_sort(names[1], function(a, b) return a > b end)
		table_sort(names[2], function(a, b) return a > b end)

		showTextArea(id..'001', '<p align="right"><textformat leading="9">'..table_concat(names[1], '<br>'), player, 400 - 200 * 0.5, 225, 85, 120, 0xffff, 0xffff, 0, true)
		showTextArea(id..'002', '<textformat leading="9">'..table_concat(names[2], '<br>'), player, 515 - 200 * 0.5, 225, 85, 120, 0xffff, 0xffff, 0, true)
		showTextArea(1020, '<p align="center"><font size="15" color="#ff0000"><a href="event:closeInfo_33"><b>X', player, 470, 180, 60, 50, 0x122528, 0x122528, 0, true)
	end
end

loadBackpackIcon = function(player)
	local playerInfo = players[player]
	if not playerInfo.dataLoaded then return end
	local images = playerInfo.interfaceImg
	if images[1] then
		for i = 1, #images do
			removeImage(images[i])
		end
		players[player].interfaceImg = {}
		images = players[player].interfaceImg
	end

	players[player].interfaceImg[#images+1] = addImage(bagIcons[playerInfo.currentBagIcon], ":5000", 318, 371, player, 0.8, 0.8)
end

updateCurrencies = function(player)
	local playerInfo = players[player]
	showTextArea(98910000000, '<b><font size="14" color="#000000"><p align="right">$'..playerInfo.coins, player, 686, 30, 110, 20, 1, 1, 0, true)
	showTextArea(98910000001, '<b><font size="14" color="#CFEFFC3"><p align="right">'..mainAssets.currencies.coin.color .. playerInfo.coins, player, 685, 29, 110, 20, 1, 1, 0, true)
	showTextArea(98910000002, '<b><font size="14" color="#000000"><p align="right">$'..playerInfo.sideQuests[4], player, 686, 62, 110, 20, 1, 1, 0, true)
	showTextArea(98910000003, '<b><font size="14" color="#FEFFC3"><p align="right">'..mainAssets.currencies.diamond.color .. playerInfo.sideQuests[4], player, 685, 61, 110, 20, 1, 1, 0, true)
end

closeMenu = function(id, player)
	for x = 13,0,-1 do
		id = id..'0'
		removeTextArea(id, player)
	end
	removeTextArea(9901327, player)
	removeGroupImages(players[player].images)
	removeImage(players[player].bannerLogin)
end