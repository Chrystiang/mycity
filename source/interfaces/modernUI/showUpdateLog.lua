modernUI.showUpdateLog = function(self, badge)
	local id = self.id
	local player = self.player
	local x = self.width/2 + 30
	local y = 70

	local version = 'v'..table_concat(version, '.')
	local width = 520
	local height = 300
	showTextArea(id..'876', '', player, 5 - width/2, 0, 400, 400, 0x152d30, 0x152d30, 0, true) showTextArea(id..'877', '', player, 395 + width/2, 0, 400, 400, 0x152d30, 0x152d30, 0, true) showTextArea(id..'878', '', player, 0, 6 - height/2, 800, 200, 0x152d30, 0x152d30, 0, true) showTextArea(id..'879', '', player, 0, 194 + height/2, 800, 200, 0x152d30, 0x152d30, 0, true)

	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(versionLogs[version].banner, ":100", 155, 90, player)
	showTextArea(id..'891', '<font size="10">'..version, player, 610, 63, nil, nil, 0, 0, 0, true)
	showTextArea(id..'892', '<p align="center"><font color="#caed87" size="15"><b>'..translate('$VersionName', player), player, 0, 63, 800, nil, 0, 0, 0, true)

	addTimer(function()
		greenButton(200, 0, translate('confirmButton_Play', player), player, 
			function()
				for i = 800, 999 do
					removeTextArea((200)..i, player)
				end
				eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
				if players[player].dataLoaded then return end
				loadPlayerData(player)

				if room.gameMode and room.gameMode == 'buildmode' and players[player].dataLoaded then
					mainAssets.gamemodes.buildmode.afterDataLoad(player)
				else
					showDishOrders(player)
					mine_drawGrid(mine_optimizeGrid(grid, grid_width, grid_height), 60, Mine.position[1], Mine.position[2])
					addImage("170fef3117d.png", ":1", 660, 365, player)
					showTextArea(999997, "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', 4), player, 660, 365, 35, 35, 0x324650, 0x000000, 0, true, function(player) openProfile(player) end)

					addImage("170f8ccde22.png", ":3", 750, 365, player)
					showTextArea(999999, "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', 4), player, 750, 365, 35, 35, 0x324650, 0x000000, 0, true, function(player) openSettings(player) end)

					addImage("1744cc60c32.png", ":4", 750, 330, player)
					showTextArea(999996, "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', 4), player, 750, 330, 35, 35, 0x324650, 0x000000, 0, true, function(player) modernUI.new(player, 520, 300):build():showSettingsMenu(true) end)
					
					addImage("1744cf82bac.png", ":5", 705, 365, player)
					showTextArea(999995, "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', 4), player, 705, 365, 35, 35, 0x324650, 0x000000, 0, true, function(player) modernUI.new(player, 380, 280, translate('tradeSystem_title', player)):build():showAvailableTradingPlayers() end)
				end
			end, 
		350, 310, 100, 15)
	end, 4000, 1)
	return setmetatable(self, modernUI)
end
