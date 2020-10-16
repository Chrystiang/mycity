loadMap = function(name) -- TO REWRITE
	if room.bankBeingRobbed and players[name].driving then return end
	ui.addTextArea(1028, '<font size="15"><p align="center"><a href="event:enter_buildshop">' .. translate('goTo', name) .. '\n</a>', name, 440, 1600+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	ui.addTextArea(1021, '<font size="15"><p align="center"><a href="event:enter_police">' .. translate('goTo', name) .. '\n</a>', name, 990, 1600+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	ui.addTextArea(1022, '<font size="15"><p align="center"><a href="event:enter_market">' .. translate('goTo', name) .. '\n</a>', name, 3445, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	ui.addTextArea(1025, '<font size="15"><p align="center"><a href="event:enter_hospital">' .. translate('goTo', name) .. '\n</a>', name, 4675, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	ui.addTextArea(1027, '<font size="19"><p align="center"><a href="event:enter_dealership">' .. translate('goTo', name) .. '\n</a>', name, 4960, 1775+room.y+11, 310, 40, 0x122528, 0x122528, 0.7)
	ui.addTextArea(1023, '<p align="center"><font color="#E8E8E8"><b>SODA', name, 4459, 138, 65, nil, 0x1, 0x1, 0)
	ui.addTextArea(1033, "<textformat leftmargin='1' rightmargin='1'><a href='event:upgradeBag'>" .. string.rep('\n', 15), name, 4545, 140, 40, 110, 0x122528, 0x122528, 0)
	ui.addTextArea(1024, '<font size="5" color="#ff0000"><b><p align="center"><a href="event:BUY_1">--------', name, 4463, 186, 15, nil, 0x1, 0x1, 0)
	ui.addTextArea(1035, "<textformat leftmargin='1' rightmargin='1'><a href='event:BUY_salt'>" .. string.rep('\n', 3), name, 4600, 190, 40, 20, 0x122528, 0x122528, 0)
	ui.addTextArea(1018, "<textformat leftmargin='1' rightmargin='1'><a href='event:BUY_cornFlakes'>" .. string.rep('\n', 15), name, 4130, 140, 130, 40, 0x122528, 0x122528, 0)
	ui.addTextArea(459, '<font size="15"><p align="center"><a href="event:joinHouse_12">' .. translate('goTo', name) .. '\n</a>', name, 11177, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)	
	ui.addTextArea(458, '<font size="15"><p align="center"><a href="event:joinHouse_11">' .. translate('goTo', name) .. '\n</a>', name, 10027, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)	

	ui.addTextArea(1039, "<textformat leftmargin='1' rightmargin='1'><a href='event:BUY_sugar'>" .. string.rep('\n', 15), name, 4608, 220, 90, 30, 0x122528, 0x122528, 0)
	ui.addTextArea(1049, "<textformat leftmargin='1' rightmargin='1'><a href='event:BUY_chocolate'>" .. string.rep('\n', 15), name, 4600, 140, 40, 40, 0x122528, 0x122528, 0)
	ui.addTextArea(1051, '<font size="19"><p align="center"><a href="event:enter_fishShop">' .. translate('goTo', name) .. '\n</a>', name, 5868, 7615, 200, 30, 0x122528, 0x122528, 0.7)

	if room.bankBeingRobbed then
		ui.addTextArea(1029, '<font size="15" color="#FF0000"><p align="center">' .. translate('robberyInProgress', name) .. '\n</a>', name, 2670, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	else
		ui.addTextArea(1029, '<font size="15"><p align="center"><a href="event:enter_bank">' .. translate('goTo', name) .. '\n</a>', name, 2670, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	end

	ui.addTextArea(-24, '<a href="event:BUY_milk">' .. string.rep('\n', 4), name, 4218, 212, 60, 35, 1, 1, 0)
	ui.addTextArea(1026, '<font size="15"><p align="center"><a href="event:enter_cafe">' .. translate('goTo', name) .. '\n</a>', name, 10950+300, 8750, 200, 30, 0x122528, 0x122528, 0.7)
	if players[name].questStep[1] > 1 then
		ui.addTextArea(1052, string.rep('\n', 10), name, 1900, 8820, 36, 192, 0, 0, 0.7, false, 
			function(player)
				if players[player].place ~= 'mine_labyrinth' then return end
				showBoatShop(player, 1)
				players[player].place = 'boatShop'
				TFM.movePlayer(player, 1455, 9300, false)
				ui.addTextArea(1053, string.rep('\n', 10), player, 1425, 9125, 50, 200, 0, 0, 0, false, 
					function(player)
						players[player].place = 'mine_labyrinth'
						setNightMode(player)
						TFM.movePlayer(player, 1918, 8820, false)
					end)
			end)
		ui.addTextArea(1036, '<font size="19"><p align="center"><a href="event:enter_furnitureStore">' .. translate('goTo', name) .. '\n</a>', name, 5622, 7615, 200, 30, 0x122528, 0x122528, 0.7)
	else
		ui.addTextArea(1036, '<font size="10"><r>' .. translate('enterQuestPlace', name):format(translate('req_1', name)), name, 5622, 7615, 200, 30, 0x122528, 0x122528, 0.7)
	end
	if players[name].questStep[1] > 2 then
		ui.addTextArea(1031, '<font size="15"><p align="center"><a href="event:enter_potionShop">' .. translate('goTo', name) .. '\n</a>', name, 9730, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	else
		ui.addTextArea(1031, '<font size="10"><r>' .. translate('enterQuestPlace', name):format(translate('req_2', name)), name, 9730, 1800+room.y, 200, nil, 0x122528, 0x122528, 0.7)
	end
	if players[name].questStep[1] > 3 then
		ui.addTextArea(1026, '<font size="15"><p align="center"><a href="event:enter_cafe">' .. translate('goTo', name) .. '\n</a>', name, 10300, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	else
		ui.addTextArea(1026, '<font size="10"><r>' .. translate('enterQuestPlace', name):format(translate('req_3', name)), name, 10300, 1800+room.y, 200, nil, 0x122528, 0x122528, 0.7)
	end
	if players[name].questStep[1] > 4 then
		ui.addTextArea(1032, '<font size="15"><p align="center"><a href="event:enter_pizzeria">' .. translate('goTo', name) .. '\n</a>', name, 4310, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	else
		ui.addTextArea(1032, '<font size="10"><r>'.. translate('enterQuestPlace', name):format(translate('req_4', name)), name, 4310, 1800+room.y, 200, nil, 0x122528, 0x122528, 0.7)
	end
	ui.addTextArea(1034, '<font size="19"><p align="center"><a href="event:enter_seedStore">' .. translate('goTo', name), name, 11858, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
end