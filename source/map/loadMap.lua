loadMap = function(name) -- TO REWRITE
	if room.bankBeingRobbed and players[name].driving then return end
	showTextArea(1028, '<font size="15"><p align="center"><a href="event:enter_buildshop">' .. translate('goTo', name) .. '\n</a>', name, 440, 1600+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	showTextArea(1021, '<font size="15"><p align="center"><a href="event:enter_police">' .. translate('goTo', name) .. '\n</a>', name, 990, 1600+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	showTextArea(1022, '<font size="15"><p align="center"><a href="event:enter_market">' .. translate('goTo', name) .. '\n</a>', name, 3445, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	showTextArea(1025, '<font size="15"><p align="center"><a href="event:enter_hospital">' .. translate('goTo', name) .. '\n</a>', name, 4675, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	showTextArea(1027, '<font size="19"><p align="center"><a href="event:enter_dealership">' .. translate('goTo', name) .. '\n</a>', name, 4960, 1775+room.y+11, 310, 40, 0x122528, 0x122528, 0.7)
	showTextArea(459, '<font size="15"><p align="center"><a href="event:joinHouse_12">' .. translate('goTo', name) .. '\n</a>', name, 11177, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)	
	showTextArea(458, '<font size="15"><p align="center"><a href="event:joinHouse_11">' .. translate('goTo', name) .. '\n</a>', name, 10027, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)	

	showTextArea(1051, '<font size="19"><p align="center"><a href="event:enter_fishShop">' .. translate('goTo', name) .. '\n</a>', name, 5868, 7615, 200, 30, 0x122528, 0x122528, 0.7)

	if room.bankBeingRobbed then
		showTextArea(1029, '<font size="15" color="#FF0000"><p align="center">' .. translate('robberyInProgress', name) .. '\n</a>', name, 2670, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	else
		showTextArea(1029, '<font size="15"><p align="center"><a href="event:enter_bank">' .. translate('goTo', name) .. '\n</a>', name, 2670, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	end

	showTextArea(1026, '<font size="15"><p align="center"><a href="event:enter_cafe">' .. translate('goTo', name) .. '\n</a>', name, 10950+300, 8750, 200, 30, 0x122528, 0x122528, 0.7)
	if players[name].questStep[1] > 1 then
		showTextArea(1036, '<font size="19"><p align="center"><a href="event:enter_furnitureStore">' .. translate('goTo', name) .. '\n</a>', name, 5622, 7615, 200, 30, 0x122528, 0x122528, 0.7)
	else
		showTextArea(1036, '<font size="10"><r>' .. translate('enterQuestPlace', name):format(translate('req_1', name)), name, 5622, 7615, 200, 30, 0x122528, 0x122528, 0.7)
	end
	if players[name].questStep[1] > 2 then
		showTextArea(1031, '<font size="15"><p align="center"><a href="event:enter_potionShop">' .. translate('goTo', name) .. '\n</a>', name, 9730, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	else
		showTextArea(1031, '<font size="10"><r>' .. translate('enterQuestPlace', name):format(translate('req_2', name)), name, 9730, 1800+room.y, 200, nil, 0x122528, 0x122528, 0.7)
	end
	if players[name].questStep[1] > 3 then
		showTextArea(1026, '<font size="15"><p align="center"><a href="event:enter_cafe">' .. translate('goTo', name) .. '\n</a>', name, 10300, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	else
		showTextArea(1026, '<font size="10"><r>' .. translate('enterQuestPlace', name):format(translate('req_3', name)), name, 10300, 1800+room.y, 200, nil, 0x122528, 0x122528, 0.7)
	end
	if players[name].questStep[1] > 4 then
		showTextArea(1032, '<font size="15"><p align="center"><a href="event:enter_pizzeria">' .. translate('goTo', name) .. '\n</a>', name, 4310, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	else
		showTextArea(1032, '<font size="10"><r>'.. translate('enterQuestPlace', name):format(translate('req_4', name)), name, 4310, 1800+room.y, 200, nil, 0x122528, 0x122528, 0.7)
	end
	showTextArea(1034, '<font size="19"><p align="center"><a href="event:enter_seedStore">' .. translate('goTo', name), name, 11858, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
end