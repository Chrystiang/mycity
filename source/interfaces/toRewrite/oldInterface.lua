ui.addTextArea = function(id, text, player, x, y, width, height, color1, color2, alpha, followPlayer, callback, args)
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
removeImages = function(player)
    if not players[player] then return end
    if not players[player].images then 
    	players[player].images = {}
    end
    for i = 1, #players[player].images do
        removeImage(players[player].images[i])
    end
end
addButton = function(id, text, player, x, y, width, height, blocked, ...)
	ui.addTextArea(id+1, '', player, x-1, y-1, width, height, 0x97a6aa, 0x97a6aa, 1, true)
	ui.addTextArea(id+2, '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
	if blocked then
		ui.addTextArea(id+3, '', player, x, y, width, height, 0x22363c, 0x22363c, 1, true)
		ui.addTextArea(id+4, '<p align="center"><font color="#999999">'..text, player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true)
	else
		ui.addTextArea(id+3, '', player, x, y, width, height, 0x314e57, 0x314e57, 1, true)
		ui.addTextArea(id+4, '<p align="center">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, ...)
	end
end
showPopup = function(id, player, title, text, x, y, width, height, button, type, arg, ativado)
	eventTextAreaCallback(0, player, 'closebag', true)
	local txt = text
	local x = x - 12
	ui.addTextArea(id..'879', '', player, -5, -5, 820, 420, 1, 1, 0.5, true)
	ui.addTextArea(id..'880', '', player, x+-2, y+18, width+24, height+14, 0x2E221B, 0x2E221B, 1, true)
    ui.addTextArea(id..'881', '', player, x-1, y+19, width+22, height+12, 0x78462b, 0x78462b, 1, true)

    ui.addTextArea(id..'886', '', player, x+2, y+22, width+16, height+6, 0x171311, 0x171311, 1, true)
    ui.addTextArea(id..'887', '', player, x+3, y+23, width+14, height+4, 0x0C191C, 0x0C191C, 1, true)

	if title then 
		ui.addTextArea(id..'888', '\n'..txt, player, x+4, y+28, width+12, height+-2, 0x152d30, 0x152d30, 1, true)
   		ui.addTextArea(id..'889', '', player, x-2, y+10, width+24, 23, 0x110a08, 0x110a08, 1, true)
    	ui.addTextArea(id..'890', '<p align="center"><font size="10" color="#ffd991">'..title, player, x-1, y+11, width+22, 20, 0x38251a, 0x38251a, 1, true)
    else 
    	ui.addTextArea(id..'888', txt, player, x+4, y+24, width+12, height+2, 0x152d30, 0x152d30, 1, true)
    	players[player].callbackImages[#players[player].callbackImages+1] = addImage("155cbe99c72.png", "&1", x-8, y+12, player)
    	players[player].callbackImages[#players[player].callbackImages+1] = addImage("155cbea943a.png", "&1", (x+width)+1, y+12, player)
    end 

    players[player].callbackImages[#players[player].callbackImages+1] = addImage("155cbe97a3f.png", "&1", x-8, (y+height)+10, player)
    players[player].callbackImages[#players[player].callbackImages+1] = addImage("155cbe9bc9b.png", "&1", (x+width)+1, (y+height)+10, player)

	if not button then
    	ui.addTextArea(id..'891', '', player, x+14, y+height-20+25, width-10, 15, 0x97a6aa, 0x97a6aa, 1, true)
		ui.addTextArea(id..'892', '', player, x+16, y+height-20+27, width-10, 15, 0x1, 0x1, 1, true)
    	ui.addTextArea(id..'893', '<p align="center"><a href="event:close3_'..id..'"><N>'.. translate('close', player) ..'</a>', player, x+15, y+height-20+26, width-10, nil, 0x314e57, 0x314e57, 1, true)
	end
	if type == 6 then
    	ui.addTextArea(id..'891', '', player, x+8, y+height-20+25, width -5 -width/2, 15, 0x97a6aa, 0x97a6aa, 1, true)
		ui.addTextArea(id..'892', '', player, x+10, y+height-20+27, width -5 -width/2, 15, 0x1, 0x1, 1, true)
    	ui.addTextArea(id..'893', '<p align="center"><a href="event:verify_'..arg..'"><N>'..translate('submit', player) ..'</a>', player, x+9, y+height-20+26, width -5 -width/2, 15, 0x314e57, 0x314e57, 1, true)
    	ui.addTextArea(id..'894', '', player, x +width/1.7 - 10, y+height-20+25, width -5 -width/2, 15, 0x97a6aa, 0x97a6aa, 1, true)
		ui.addTextArea(id..'895', '', player, x +width/1.7 + 2 - 10, y+height-20+27, width -5 -width/2, 15, 0x1, 0x1, 1, true)
    	ui.addTextArea(id..'896', '<p align="center"><a href="event:close3_'..id..'"><N>'..translate('cancel', player)..'</a>', player, x +width/1.7 +1 - 10, y+height-20+26, width -5 -width/2, 15, 0x314e57, 0x314e57, 1, true)
	elseif tostring(type):sub(1, 1) == '9' then
		local whatToSell = tonumber(type:sub(3))
		if type:sub(3, 3) == '-' then
			whatToSell = 0
		end
		
		players[player].shopMenuType = type:sub(3)
		players[player].shopMenuHeight = height
		local list = {
			[0] = {type:sub(4)}, -- IF IS A SINGLE ITEM
			[1] = {'energyDrink_Basic', 'energyDrink_Mega', 'energyDrink_Ultra'}, -- MARKET
			[5] = {'coffee', 'hotChocolate', 'milkShake'}, -- CAFÉ
			[6] = {'bag'}, -- BAG
		}

		for i, v in next, list[whatToSell] do
			if bagItems[v].type == 'food' then
				ui.addTextArea(id..(894+(i-1)*3), '<textformat leftmargin="-5"><g><font size="9">'.. string.format(translate('energyInfo', player) ..'\n'.. translate('hungerInfo', player), bagItems[v].power and bagItems[v].power or 0, bagItems[v].hunger and bagItems[v].hunger or 0), player, x+15, y+73 + (i-1)*68, width-10, 28, 0x314e57, 0x314e57, 0.5, true)
			elseif bagItems[v].type == 'complementItem' then
				ui.addTextArea(id..(894+(i-1)*3), '<textformat leftmargin="-5"><p align="center"><g><font size="9">"'.. translate('itemDesc_'..v, player):format(bagItems[v].complement) .. '"', player, x+15, y+73 + (i-1)*68, width-10, 28, 0x314e57, 0x314e57, 0.5, true)
			elseif bagItems[v].type == 'bag' then
				if players[player].bagLimit < 45 then
					ui.addTextArea(id..(894+(i-1)*3), '<textformat leftmargin="-5"><g><font size="9">'.. translate('itemDesc_bag', player):format(bagItems[v].capacity), player, x+15, y+73 + (i-1)*68, width-10, 28, 0x314e57, 0x314e57, 0.5, true)
				else
					ui.addTextArea(id..(894+(i-1)*3), '<textformat leftmargin="-5"><r><font size="9">'.. translate('error_maxStorage', player), player, x+15, y+73 + (i-1)*68, width-10, 28, 0x314e57, 0x314e57, 0.5, true)
				end
			else
				ui.addTextArea(id..(894+(i-1)*3), '<textformat leftmargin="-5"><p align="center"><g><font size="9">"'.. translate('itemDesc_'..v, player) .. '"', player, x+15, y+73 + (i-1)*68, width-10, 28, 0x314e57, 0x314e57, 0.5, true)
			end
			if players[player].coins >= bagItems[v].price then
    			ui.addTextArea(id..(895+(i-1)*3), translate('item_'..v, player), player, x+15, y+50 + (i-1)*68, width-10, 20, 0x314e57, 0x314e57, 1, true)
				if bagItems[v].type == 'bag' and players[player].bagLimit >= 45 then
					ui.addTextArea(id..(896+(i-1)*3), '', player, x+15, y+50 + (i-1)*68, width-10, 20, 0x314e57, 0x314e, 0, true)
				else
					ui.addTextArea(id..(896+(i-1)*3), '<p align="right"><a href="event:buyBagItem_'.. v ..'"><vp>$'.. bagItems[v].price ..'</p>', player, x+15, y+50 + (i-1)*68, width-10, 20, 0x314e57, 0x314e, 0, true)
				end
			else
				ui.addTextArea(id..(895+(i-1)*3), '<font color="#999999">'.. translate('item_'..v, player), player, x+15, y+50 + (i-1)*68, width-10, 20, 0x22363c, 0x22363c, 1, true)
				ui.addTextArea(id..(896+(i-1)*3), '<p align="right"><r>$'.. bagItems[v].price ..'</p>', player, x+15, y+50 + (i-1)*68, width-10, 20, 0x314e57, 0x314e, 0, true)
			end
		end
	elseif type == 10 then
		ui.addTextArea(id..'891', '', player, x+8, y+height-20+25, width -5 -width/2, 15, 0x97a6aa, 0x97a6aa, 1, true)
		ui.addTextArea(id..'892', '', player, x+10, y+height-20+27, width -5 -width/2, 15, 0x1, 0x1, 1, true)
		ui.addTextArea(id..'893', '<p align="center"><a href="event:getCode"><N>'..translate('submit', player) ..'</a>', player, x+9, y+height-20+26, width -5 -width/2, 15, 0x314e57, 0x314e57, 1, true)
		ui.addTextArea(id..'894', '', player, x +width/1.7 - 10, y+height-20+25, width -5 -width/2, 15, 0x97a6aa, 0x97a6aa, 1, true)
		ui.addTextArea(id..'895', '', player, x +width/1.7 + 2 - 10, y+height-20+27, width -5 -width/2, 15, 0x1, 0x1, 1, true)
		ui.addTextArea(id..'896', '<p align="center"><a href="event:close3_'..id..'"><N>'..translate('cancel', player)..'</a>', player, x +width/1.7 +1 - 10, y+height-20+26, width -5 -width/2, 15, 0x314e57, 0x314e57, 1, true)

		local keys = {'QWERTYUIOP', 'ASDFGHJKL', 'ZXCVBNM'}
		local x = 400 - 243 * 0.5
		local y = 180
		for i = 1, #keys[1] do
			local letter = keys[1]:sub(i, i)
			ui.addTextArea(id..(900+i), "<a href='event:keyboard_"..letter.."'><p align='center'>"..letter.."</p></a>", player, x + (i-1)*24 + 6, y+56, 15, 17, 0x122528, 0x183337, alpha, true)
		end
		for i = 1, #keys[2] do
			local letter = keys[2]:sub(i, i)
			ui.addTextArea(id..(913+i), "<a href='event:keyboard_"..letter.."'><p align='center'>"..letter.."</p></a>", player, x + (i-1)*24 + 17, y+81, 15, 17, 0x122528, 0x183337, alpha, true)
		end
		for i = 1, #keys[3] do
			local letter = keys[3]:sub(i, i)
			ui.addTextArea(id..(925+i), "<a href='event:keyboard_"..letter.."'><p align='center'>"..letter.."</p></a>", player, x + (i-1)*24 + 42, y+106, 15, 17, 0x122528, 0x183337, alpha, true)
		end
	elseif type == 18 then -- VAULT PASSWORD
		if not players[player].place == 'bank' then return end
		ui.addTextArea(id..'891', '', player, x+14, y+height-20+25, width-10, 15, 0x97a6aa, 0x97a6aa, 1, true)
		ui.addTextArea(id..'892', '', player, x+16, y+height-20+27, width-10, 15, 0x1, 0x1, 1, true)
    	ui.addTextArea(id..'893', '<p align="center"><a href="event:closeVaultPassword"><N>'.. translate('close', player) ..'</a>', player, x+15, y+height-20+26, width-10, 15, 0x314e57, 0x314e57, 1, true)

		for i = 1, 9 do
			ui.addTextArea(id..(889+(i-1)*14), '<vp><p align="center">'..i, player, x+25 + math.floor((i-1)%3)*26, y+26+50 + math.floor((i-1)/3)*26, 15, 15, 0x314e57, 0x314e57, 0.5, true)
			ui.addTextArea(id..(890+(i-1)*14), '<a href="event:insertVaultPassword_'..i..'">'..string.rep('\n', 5), player, x+22 + math.floor((i-1)%3)*26, y+23+50 + math.floor((i-1)/3)*26, 20, 20, 0xff0000, 0xff0000, 0, true)
		end
		local teclas = {'*', '0', '#'}
		for i = 1, 3 do
			ui.addTextArea(id..(889+(8+i)*14), '<vp><p align="center">'..teclas[i], player, x+25 + (i-1)*26, y+26+50 + math.floor((9+i-1)/3)*26, 15, 15, 0x314e57, 0x314e57, 0.5, true)
			ui.addTextArea(id..(890+(8+i)*14), '<a href="event:insertVaultPassword_'..teclas[i]..'">'..string.rep('\n', 5), player, x+22 + (i-1)*26, y+23+50 + math.floor((9+i-1)/3)*26, 20, 20, 0xff0000, 0xff0000, 0, true)
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
						ui.removeTextArea(-510, nil)
						removeImage(room.bankDoors[1])
						removeGround(9999)
						for players in next, ROOM.playerList do
							eventTextAreaCallback(0, players, 'closeVaultPassword', true)
						end
					end, 1000, 1)
				else
					password = '<r>'.. password
					ui.addTextArea(id..(890+(8+5)*14), '', player, x+20, y+20, width, height, 0xff0000, 0xff0000, 0, true)

					addTimer(function()
						password = '_ _ _ _'
						ui.removeTextArea(id..(890+(8+5)*14), player)
						ui.addTextArea(id..(890+(8+4)*14), '<p align="center"><font color="#ffffff" size="15">'..password, player, x+10 , y+25, width, 40, 0xff0000, 0xff0000, 0, true)
					end, 1000, 1)
				end
				players[player].bankPassword = nil
			end
		else
			password = '_ _ _ _'
		end
		ui.addTextArea(id..(890+(8+4)*14), '<p align="center"><font color="#ffffff" size="15">'..password, player, x+10 , y+25, width, 40, 0xff0000, 0xff0000, 0, true)
	end
	if type == 6 or type == 5 then
		local keys = {'QWERTYUIOP', 'ASDFGHJKL', 'ZXCVBNM'}
		local x = 400 - 243 * 0.5
		local y = 120
		for i = 1, #keys[1] do
			local letter = keys[1]:sub(i, i)
			ui.addTextArea(id..(900+i), "<a href='event:keyboard_"..letter.."'><p align='center'>"..letter.."</p></a>", player, x + (i-1)*24 + 6, y+56, 15, 17, 0x122528, 0x183337, alpha, true)
		end
		for i = 1, #keys[2] do
			local letter = keys[2]:sub(i, i)
			ui.addTextArea(id..(913+i), "<a href='event:keyboard_"..letter.."'><p align='center'>"..letter.."</p></a>", player, x + (i-1)*24 + 17, y+81, 15, 17, 0x122528, 0x183337, alpha, true)
		end
		for i = 1, #keys[3] do
			local letter = keys[3]:sub(i, i)
			ui.addTextArea(id..(925+i), "<a href='event:keyboard_"..letter.."'><p align='center'>"..letter.."</p></a>", player, x + (i-1)*24 + 42, y+106, 15, 17, 0x122528, 0x183337, alpha, true)
		end
	end
end
sendMenu = function(id, player, text, x, y, width, height, alpha, close, arg, prof, interface, tela, type, coin, showCoin)
	local playerData = players[player]
	if type and type ~= 16 and type ~= -10 then
		ui.addTextArea(9901327, '', player, -5, -5, 820, 420, 1, 1, 0.5, true)
	end
    ui.addTextArea(id..'0', '', player, x+-2, y+18, width+24, height+14, 0x2E221B, 0x2E221B, alpha, true)
    ui.addTextArea(id..'00', '', player, x+-1, y+19, width+22, height+12, 0x78462b, 0x78462b, alpha, true)
    ui.addTextArea(id..'000', '', player, x, y+20, width+20, height+10, 0x171311, 0x171311, alpha, true)
    ui.addTextArea(id..'0000', '', player, x+3, y+23, width+14, height+4, 0x0C191C, 0x0C191C, alpha, true)
    ui.addTextArea(id..'00000', '', player, x+4, y+24, width+12, height+2, 0x24474D, 0x24474D, alpha, true)
    ui.addTextArea(id..'000000', '', player, x+5, y+25, width+10, height+0, 0x183337, 0x183337, alpha, true)
    ui.addTextArea(id..'0000000', text, player, x+6, y+26, width+8, height+-2, 0x122528, 0x122528, alpha, true)

	if close then
    	ui.addTextArea(id..'00000000', '', player, x+15, y+height-20+25, width-10, 15, 0x97a6aa, 0x97a6aa, alpha, true)
		ui.addTextArea(id..'000000000', '', player, x+15, y+height-20+27, width-10, 15, 0x1, 0x1, alpha, true)
	  	ui.addTextArea(id..'0000000000', '<p align="center"><a href="event:fechar@'..id..'"><N>'.. translate('close', player) ..'</a>', player, x+15, y+height-20+26, width-10, nil, 0x314e57, 0x314e57, alpha, true)
	end
	if tela then
		ui.addTextArea(id..'00000000', '', player, x+15, y+height-20+10, width-10, 15, 0x5D7D90, 0x5D7D90, alpha, true)
    	ui.addTextArea(id..'000000000', '', player, x+15, y+height-20+12, width-10, 15, 0x11171C, 0x11171C, alpha, true)
    	ui.addTextArea(id..'0000000000', '<p align="center"><a href="event:fechar@'..id..'"><N>'.. translate('close', player) ..'</a>', player, x+15, y+height-20+11, width-10, 15, 0x3C5064, 0x3C5064, alpha, true)
	end
	if type == 5 then
		ui.addTextArea(id..'000', '', player, x+-2, y+18, width+24, height+14, 0x2E221B, 0x2E221B, alpha, true)
        ui.addTextArea(id..'001', '', player, x+-1, y+19, width+22, height+12, 0x986742, 0x986742, alpha, true)
        -- bordas
        ui.addTextArea(id..'002', '', player, x + width - 9, y+19, 30, height/4, 0x78462b, 0x78462b, alpha, true)
		ui.addTextArea(id..'003', '', player, x - 1, y+19, 30, height/4, 0x78462b, 0x78462b, alpha, true)
		ui.addTextArea(id..'004', '', player, x - 1, ((y + height) - height/4) + 31.5, width/4, height/4, 0x78462b, 0x78462b, alpha, true)
		ui.addTextArea(id..'005', '', player, x + width - 54, ((y + height) - height/4) + 31.5, width/4, height/4, 0x78462b, 0x78462b, alpha, true)
		  -----
        ui.addTextArea(id..'006', '', player, x+2, y+22, width+16, height+6, 0x171311, 0x171311, alpha, true)
        ui.addTextArea(id..'007', '', player, x+3, y+23, width+14, height+4, 0x0C191C, 0x0C191C, alpha, true)
		ui.addTextArea(id..'008', '', player, x+4, y+28, width+12, height+-2, 0x152d30, 0x152d30, alpha, true)

        ui.addTextArea(id..'011', '', player, x-2, y+10, width+24, 17, 0x110a08, 0x110a08, alpha, true)
        ui.addTextArea(id..'012', '<p align="center"><font size="10" color="#ffd991">'..text, player, x-1, y+11, width+22, 15, 0x38251a, 0x38251a, alpha, true)

        ui.addTextArea(id..'013', '', player, x+14, y+height-20+25, width-10, 15, 0x97a6aa, 0x97a6aa, alpha, true)
    	ui.addTextArea(id..'014', '', player, x+16, y+height-20+27, width-10, 15, 0x1, 0x1, alpha, true)
        ui.addTextArea(id..'015', '<p align="center"><a href="event:close2"><N>'.. translate('close', player) ..'</a>', player, x+15, y+height-20+26, width-10, 15, 0x314e57, 0x314e57, alpha, true)
	elseif type == 11 then
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
	    table.sort(names[1], function(a, b) return a > b end)
	    table.sort(names[2], function(a, b) return a > b end)

		ui.addTextArea(id..'001', '<p align="right"><textformat leading="9">'..table.concat(names[1], '<br>'), player, 400 - 200 * 0.5, 225, 85, 120, 0xffff, 0xffff, 0, true)
		ui.addTextArea(id..'002', '<textformat leading="9">'..table.concat(names[2], '<br>'), player, 515 - 200 * 0.5, 225, 85, 120, 0xffff, 0xffff, 0, true)
		ui.addTextArea(1020, '<p align="center"><font size="15" color="#ff0000"><a href="event:closeInfo_33"><b>X', player, 470, 180, 60, 50, 0x122528, 0x122528, 0, true)		
	elseif type == 15 then
		if playerData.joinMenuPage > 1 then
			addButton(id..'081', '<a href="event:joiningMessage_back">«', player, 550, 325, 10, 10)
		else
			addButton(id..'081', '«', player, 550, 325, 10, 10, true)
		end
		if playerData.joinMenuPage == versionLogs[playerData.gameVersion].maxPages then
			addButton(id..'091', '<a href="event:joiningMessage_close">'..translate('close', player), player, 550, 350, 150, 10)
			addButton(id..'086', '»', player, 690, 325, 10, 10, true)
		else
			addButton(id..'091', translate('close', player), player, 550, 350, 150, 10, true)
			addButton(id..'086', '<a href="event:joiningMessage_next">»', player, 690, 325, 10, 10)
		end
		ui.addTextArea(id..'080', '<p align="left">'..translate('$VersionText', player), player, x+6, y+70, 430, height+-2, 0x122528, 0xff0000, 0, true)
		addButton(id..'097', playerData.joinMenuPage..'/'..versionLogs[playerData.gameVersion].maxPages, player, 575, 325, 100, 10, true)
		playerData.joinMenuImages[#playerData.joinMenuImages+1] = addImage(versionLogs[playerData.gameVersion].images[playerData.joinMenuPage], '&1', 550, 100, player)
	elseif type == 18 then -- RECIPES
		if playerData.callbackImages[1] then
			for i, v in next, playerData.callbackImages do
				removeImage(playerData.callbackImages[i])
			end
			playerData.callbackImages = {}
		end
		local txt1 = ''
		local txt2 = ''
		local minn = (9 * playerData.callbackPages.recipes - 9) + 1
		local maxx = playerData.callbackPages.recipes * 9
		local i = 0
		local ii = 0
		x = x + 10
		y = y + 30
		for item, v in next, recipes do
			i = i + 1
			ii = ii + 1
			if ii >= minn and ii <= maxx then 
				if i > 9 then
					i = i - (9 * playerData.callbackPages.recipes - 9)
				end
				sendMenu(id+i, player, '', ((i-1)%3)*105+x-1, y+26 + math.floor((i-1)/3)*85, 70, 60, 1)
				addButton(id..'0'..(10+(i-1)*5), '<a href="event:showRecipe_'..item..'">+', player, x+7 + 63 +((i-1)%3)*105, y+98+ math.floor((i-1)/3)*85, 10, 10)
				playerData.callbackImages[#playerData.callbackImages+1] = addImage(bagItems[item].png and bagItems[item].png or '16bc368f352.png', "&70", x+17+((i-1)%3)*105, y+math.floor((i-1)/3)*85+48, player)
			end
		end
		local totalPages = math.ceil(ii/9)
		if playerData.callbackPages.recipes == 1 then
			addButton(id..'081', '«', player, 500, 315, 10, 10, true)
		else
			addButton(id..'081', '<a href="event:changePage_recipes_back_'..totalPages..'">«', player, 500, 315, 10, 10)
		end
		if playerData.callbackPages.recipes == totalPages then
			addButton(id..'086', '»', player, 600, 315, 10, 10, true)
		else
			addButton(id..'086', '<a href="event:changePage_recipes_next_'..totalPages..'">»', player, 600, 315, 10, 10)
		end
		addButton(id..'091', playerData.callbackPages.recipes..'/'..totalPages, player, 525, 315, 60, 10, true)
	end
end
showVehiclesButton = function(player, expandedInterface)
	local x = 445
	if expandedInterface then 
		x = 546
	end
	ui.addTextArea(98900000002, string.rep('\n', 4), player, x, 360, 50, 50, 1, 1, 0, true,
		function(player)
			modernUI.new(player, 520, 300, translate('vehicles', player))
			:addButton('1729f83fb5f.png', function() 
				modernUI.new(player, 240, 180, translate('confirmButton_tip', player), translate('tip_vehicle', player), 'errorUI')
				:build()
			end)
			:build()
			:showPlayerVehicles()
		end)
end
showOptions = function(player)
	local playerInfo = players[player]
	if playerInfo.blockScreen or playerInfo.holdingItem or playerInfo.hospital.hospitalized or playerInfo.editingHouse then return end
	if not playerInfo.robbery.robbing and not playerInfo.robbery.arrested then
		local images = playerInfo.interfaceImg
		if images[1] then 
			for i = 1, #images do
				removeImage(images[i])
			end
			players[player].interfaceImg = {}
			images = players[player].interfaceImg
		end
		for i = 1, 4 do 
			ui.removeTextArea(98900000000+i, player)
		end
		local function showBag()
			players[player].interfaceImg[#images+1] = addImage("170fa5dddd8.png", ":2", 298, 353, player)
			players[player].interfaceImg[#images+1] = addImage(bagUpgrades[playerInfo.bagLimit], ":3", 307, 362, player)

			ui.addTextArea(98900000001, string.rep('\n', 4), player, 300, 360, 50, 50, 1, 1, 0, true,
				function(player)
					modernUI.new(player, 520, 300, translate('bag', player))
					:build()
					:showPlayerItems(playerInfo.bag)
				end)
		end 
		local function showCar()
			players[player].interfaceImg[#images+1] = addImage("170fa60a8a4.png", ":3", 440, 353, player)
			players[player].interfaceImg[#images+1] = addImage("15b318c5f77.png", ":4", 452, 366, player)
			showVehiclesButton(player)
		end
		local function showHouse()
			players[player].interfaceImg[#images+1] = addImage("170fa60a8a4.png", ":3", 440, 353, player)
			players[player].interfaceImg[#images+1] = addImage("15a197246f0.png", ":5", 451, 357, player)
			ui.addTextArea(98900000002, string.rep('\n', 4), player, 445, 360, 50, 50, 1, 1, 0, true,
				function(player)
					modernUI.new(player, 240, 120, translate('houseSettings', player))
					:build()
					:showHouseSettings()
				end)
		end
		local allowedVehiclesPlaces = {'town', 'island', 'mine', 'mine_labyrinth', 'mine_escavation'}
		if table.contains(allowedVehiclesPlaces, playerInfo.place) then
			showCar()
		elseif playerInfo.place:find('house') and checkLocation_isInHouse(player) then
			showHouse()
		end
		showBag()

		local size = playerInfo.coins < 999999 and 16 or 13
		ui.addTextArea(98900000000, '<b><font size="'..size..'" color="#371616"><p align="center">$'..playerInfo.coins, player, 350, size == 16 and 366 or 368, 100, 50, 1, 1, 0, true)
	end
end
closeInterface = function(player, found, coin, placingItem, radioactiveMine, item, expandInterface)
	local playerInfo = players[player]
	if playerInfo.holdingItem and not placingItem then return end
	local images = playerInfo.interfaceImg
	if images[1] then 
		for i = 1, #images do
			removeImage(images[i])
		end
		players[player].interfaceImg = {}
		images = players[player].interfaceImg
	end
    for i = 1, 4 do 
		ui.removeTextArea(98900000000+i, player)
	end

    if placingItem then
    	ui.addTextArea(9901327, '', player, -5, -5, 820, 420, 1, 1, 0.5, true)
		ui.addTextArea(98900000019, '<p align="center"><b><font color="#00FF00" size="20"><a href="event:confirmPosition">✓', player, 350, 330, 100, nil, 1, 1, 0, true)
		if playerInfo.mouseSize == 1 then
			local image = ROOM.playerList[player].isFacingRight and bagItems[playerInfo.holdingItem].holdingImages[2] or bagItems[playerInfo.holdingItem].holdingImages[1]
			local x = ROOM.playerList[player].isFacingRight and bagItems[playerInfo.holdingItem].holdingAlign[2][1] or bagItems[playerInfo.holdingItem].holdingAlign[1][1]
			local y = ROOM.playerList[player].isFacingRight and bagItems[playerInfo.holdingItem].holdingAlign[2][2] or bagItems[playerInfo.holdingItem].holdingAlign[1][2]
			if playerInfo.holdingImage then
				removeImage(playerInfo.holdingImage)
				playerInfo.holdingImage = nil
			end
			playerInfo.holdingImage = addImage(image, '$'..player, x, y)
		end
    end
	if expandInterface then
		players[player].interfaceImg[#images+1] = addImage("170fa9bd6a6.png", ":1", 248, 355, player)
		if not playerInfo.robbery.arrested and not playerInfo.hospital.hospitalized then
			players[player].interfaceImg[#images+1] = addImage("170fa60a8a4.png", ":3", 541, 353, player)
			players[player].interfaceImg[#images+1] = addImage("15b318c5f77.png", ":3", 553, 366, player)
			showVehiclesButton(player, true)
		end
	end
end
closeMenu = function(id, player)
    for x = 13,0,-1 do
        id = id..'0'
        ui.removeTextArea(id, player)
    end
	ui.removeTextArea(9901327, player)
    removeImages(player)
    removeImage(players[player].bannerLogin)
end