modernUI.showSettingsMenu = function(self, donate)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) + 20
	local y = (200 - height/2) + 65
	local selectedWindow = 1

	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('17281987ff2.jpg', ":26", x-3, y-23, player)
	local function button(i, text, callback, x, y, width, height)
		local width = width or 146
		local height = height or 15
		showTextArea(id..(960+i*5), '', player, x-1, y-1, width, height, 0x95d44d, 0x95d44d, 1, true)
		showTextArea(id..(961+i*5), '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
		showTextArea(id..(962+i*5), '', player, x, y, width, height, 0x44662c, 0x44662c, 1, true)
		showTextArea(id..(963+i*5), '<p align="center"><font color="#cef1c3" size="13">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, callback)
	end
	local buttons = {}
	local function addToggleButton(setting, name, state, _id)
		if not state then state = players[player].settings[setting] == 1 and true or false end
		buttonType = buttons[_id] and _id or #buttons+1
		buttons[buttonType] = {state = state}
		local buttonID = buttonType
		local x = x + 15
		local y = y + 5 + (_id and (_id-1)*20 or (#buttons-1)*20)
		showTextArea(id..(900+(buttonID-1)*6), "", player, x-1, y-1, 2, 2, 1, 1, 1, true)
		showTextArea(id..(901+(buttonID-1)*6), "", player, x, y, 2, 2, 0x3A5A66, 0x3A5A66, 1, true)
		showTextArea(id..(902+(buttonID-1)*6), "", player, x, y, 1, 1, 0x233238, 0x233238, 1, true)
		showTextArea(id..(903+(buttonID-1)*6), state and '<font size="17">•' or '', player, x-6, y-13, nil, nil, 1, 1, 0, true)
		showTextArea(id..(904+(buttonID-1)*6), '\n', player, x-5, y-5, 10, 10, 1, 0xffffff, 0, true, function(player, buttonID)
			buttons[buttonID].state = not buttons[buttonID].state
			players[player].settings[setting] = buttons[buttonID].state and 1 or 0
			addToggleButton(setting, name, buttons[buttonID].state, buttonID)
		end, buttonID)
		showTextArea(id..(905+(buttonID-1)*6), '<cs>'..name, player, x+10, y-7, nil, nil, 1, 1, 0, true)
	end
	local selectedLang = players[player].lang:upper()
	local function addLangSwitch()
		for i = 0, 20 do 
			removeTextArea(id..(920+i), player)
		end 
		removeGroupImages(players[player]._modernUISelectedItemImages[1])
		local x = x + 15
		local y = y + 70
		showTextArea(id..'920', '', player, x-1, y-1, 70, 15, 1, 1, 1, true)
		players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(community[selectedLang:lower()], "&26", x+5, y+1, player)
		showTextArea(id..'921', '<n2>'..selectedLang..'\t↓', player, x+22, y-1, nil, nil, 1, 1, 0, true,
			function()
				local toChoose = {}
				for i, v in next, langIDS do
					if v:upper() ~= selectedLang then 
						toChoose[#toChoose+1] = v:upper()
					end 
				end
				local txt = '\n'..table_concat(toChoose, '\n')
				showTextArea(id..'920', '<font color="#000000">'..txt, player, x-1, y-1, 70, nil, 1, 1, 1, true)
				showTextArea(id..'921', '<n2>'..selectedLang..'\t↑', player, x+22, y-1, nil, nil, 1, 1, 0, true, function()
						addLangSwitch()
					end)
				for i, v in next, toChoose do
					players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(community[v:lower()], "&26", x+5, y+16 + (i-1)*14, player)
					showTextArea(id..(921+i), v, player, x+22, y+14 + (i-1)*14, nil, nil, 1, 1, 0, true, function()
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
			showTextArea(id..900, '<font color="#ebddc3" size="13"> '
				..translate('settings_helpText', player)
				..'\n\n\n\n<font size="15">'
				..translate('settings_helpText2', player)
				..'</font>\n'
				..translate('command_profile', player), player, x, y -23, 485, 200, 0xff0000, 0xff0000, 0, true)
			button(5, 'Mycity Wiki', function(player) chatMessage('<rose>https://transformice.fandom.com/wiki/Mycity', player) end, x+22, y+70, 435, 12)
		elseif selectedWindow == 2 then
			buttons = {}
			showTextArea(id..951, '<font color="#ebddc3" size="13">'..translate('settings_config_lang', player), player, x, y+35, 485, nil, 0xff0000, 0xff0000, 0, true)
			addToggleButton('mirroredMode', translate('settings_config_mirror', player))
			addToggleButton('disableTrades', translate('settings_config_disableTrades', player))
			addLangSwitch()
		elseif selectedWindow == 3 then
			players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage('17281d1a0f9.png', ":26", 505, y+10, player)
			local credit = mainAssets.credits 
			local counter = 0

			for i, v in next, credit.translations do 
				players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(community[v], "&70", x+12 + counter%2*180, y + 17 + floor(counter/2)*13, player)
				showTextArea(id..902+counter, '<g>'..i, player, x+30 + counter%2*180, y + 14 + floor(counter/2)*13, nil, nil, 0xff0000, 0xff0000, 0, true)
				counter = counter + 1
			end

			showTextArea(id..900, '<font color="#ebddc3"> '..
				translate('settings_creditsText', player)
				:format(table_concat(credit.creator),
					table_concatFancy(credit.arts, ", ", translate('wordSeparator', player)))
				, player, x, y -23, 485, 200, 0xff0000, 0xff0000, 0, true)
			showTextArea(id..901, '<font color="#ebddc3"> '..
				translate('settings_creditsText2', player)
				:format(table_concatFancy(credit.help, ", ", translate('wordSeparator', player)))
				, player, x, y + 130, 485, nil, 0xff0000, 0xff0000, 0, true)

		elseif selectedWindow == 4 then
			players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('17281987ff2.jpg', ":24", x-3, y+5, player)
			players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage('17136fe68cc.png', ":26", 520, y, player)
			showTextArea(id..900, '<font color="#ebddc3"> '..translate('settings_donateText', player), player, x, y -23, 365, 200, 0xff0000, 0xff0000, 0, true)

			button(5, translate('settings_donate', player), function(player) chatMessage('<rose>https://a801-luadev.github.io/?redirect=mycity', player) end, x, y+190, 480)
		end
		if not donate then
			showTextArea(id..899, '', player, x + (window-1)*167, y + 197, 146, 15, 0xbdbdbd, 0xbdbdbd, 0.5, true)
		end
	end
	if not donate then
		for i, v in next, {translate('settings_help', player), translate('settings_settings', player), translate('settings_credits', player)} do 
			button(i, v, function()
				if i == selectedWindow then return end
				removeGroupImages(players[player]._modernUISelectedItemImages[1])
				for i = 0, 3 do 
					removeTextArea(id..(985+i), player)
				end
				for i = 899, 959 do 
					removeTextArea(id..i, player)
				end
				showOptions(i)
			end, x + (i-1)*167, y + 197)
		end
		showOptions(1)
	else
		showOptions(4)
	end
	return setmetatable(self, modernUI)
end