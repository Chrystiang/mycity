places = {
	market = {
		opened  = '-',
		tp      = {3600, 250},
		town_tp = {3473, 7770},
		saida   = {{3300, 3500}, {0, 300}},
		saidaF  = function(player)
			TFM.movePlayer(player, 3473, 7770, false)
			players[player].place = 'town'
			return true
		end
	},
	hospital = {
		opened = '-',
		tp      = {4600, 3650},
		saida   = {{4650, 4800}, {3400, 3700}},
		saidaF  = function(player)
			TFM.movePlayer(player, 4850, 7770, false)
			players[player].place = 'town'
			showOptions(player)
			return true
		end
	},
	police = {
		opened  = '-',
		tp      = {220+7100, 265+5950},
		saida   = {{7130, 7300}, {6116, 6230}},
		saidaF  = function(player)
			TFM.movePlayer(player, 1090, 7570, false)
			players[player].place = 'town'
			return true
		end
	},
	buildshop = {
		opened  = '08:00 19:00',
		tp      = {200, 250},
		town_tp = {495, 7570},
		saida   = {{0, 180}, {50, 300}},
		saidaF  = function(player)
			TFM.movePlayer(player, 495, 7570, false)
			players[player].place = 'town'
			return true
		end,
	},
	dealership = {
		opened  = '07:00 19:00',
		tp      = {8710, 240},
		town_tp = {5400, 7770},
		saida   = {{8000, 8680}, {0, 300}},
		saidaF  = function(player)
			TFM.movePlayer(player, 5000, 7770, false)
			players[player].place = 'town'
			return true
		end
	},
	bank = {
		opened  = '07:00 19:00',
		tp      = {5538, 5238},
		town_tp = {2775, 7770},
		clickDistance = {{5460, 5615}, {5100, 5250}},
		saida   = {{5273, 6012}, {5100, 5250}},
		saidaF  = function(player)
			if ROOM.playerList[player].x > 5460 and ROOM.playerList[player].x < 5615 and ROOM.playerList[player].y > 5100 and ROOM.playerList[player].y < 5250 then
				ui.addTextArea(-5551, "<font color='#FFFFFF' size='40'><a href='event:getOut_bank'>• •", player, 5508, 5150, nil, nil, 1, 1, 0, false)
				return true
			else
				ui.removeTextArea(-5551, player)
				return
			end
		end
	},
	pizzeria = {
		opened  = '-',
		tp      = {14200, 250},
		town_tp = {4410, 7770},
		saida   = {{14000, 14150}, {50, 300}},
		saidaF  = function(player)
			TFM.movePlayer(player, 4410, 7770, false)
			players[player].place = 'town'
			return true
		end,
	},
	fishShop = {
		opened  = '-',
		tp      = {12700, 250},
		town_tp = {6030, 7770},
		saida   = {{12600, 12695}, {50, 300}},
		saidaF  = function(player)
			TFM.movePlayer(player, 6030, 7770, false)
			players[player].place = 'town'
			return true
		end,
	},
	furnitureStore = {
		opened = '08:00 19:00',
		tp      = {16150, 248},
		town_tp = {5770, 7770},
		saida   = {{16000, 16100}, {100, 250}},
		saidaF  = function(player)
			TFM.movePlayer(player, 5770, 7770, false)
			players[player].place = 'town'
			return true
		end,
	},
	town = {
		opened  = '-',
		saida   = {{0, 1649}, {7600, 7800}},
		saidaF  = function(player)
			players[player].place = 'mine'
			checkIfPlayerIsDriving(player)
			if players[player].questLocalData.other.goToMine then
				quest_updateStep(player)
			end
			return true
		end
	},
	mine = {
		opened  = '-',
		saida   = {{995, 6000}, {7600, 8670}},
		saidaF  = function(player)
			local x = ROOM.playerList[player].x
			local y = ROOM.playerList[player].y
			if x >= 1650 and x <= 6000 and y >= 7600 and y <= 7800 then
				players[player].place = 'town'
				return true
			elseif x >= 995 and x <= 1100 and y >= 8490 and y <= 8670 then
				TFM.movePlayer(player, 1220, 8670, false)
				players[player].place = 'mine_labyrinth'
				setNightMode(player)
				return true
			end
		end
	},
	mine_labyrinth = {
		opened  = '-',
		saida   = {{1100, 1200}, {8490, 8670}},
		saidaF  = function(player)
			players[player].place = 'mine'
			TFM.movePlayer(player, 990, 8632, false)
			showOptions(player)
			return true
		end
	},
	mine_escavation = {
		opened = '-',
		saida   = {{5355, 5470}, {7830, 8200}},
		saidaF  = function(player)
			players[player].place = 'town'
			TFM.movePlayer(player, 5415, 7770, false)
		end
	},
	--- island
	cafe = {
		opened  = '-',
		tp      = {6150, 250},
		saida   = {{6000, 6140}, {50, 300}},
		saidaF  = function(player)
			TFM.movePlayer(player, 10470, 7770, false)
			players[player].place = 'island'
			return true
		end,
	},
	potionShop = {
		opened = '11:00 19:00',
		tp      = {10620, 248},
		island_tp = {9895, 7770},
		saida   = {{10500, 10615}, {100, 250}},
		saidaF  = function(player)
			TFM.movePlayer(player, 9895, 7770, false)
			players[player].place = 'island'
			return true
		end,
	},
	seedStore = {
		opened = '10:00 19:00',
		tp      = {11500, 248},
		island_tp = {12000, 7770},
		saida   = {{11350, 11460}, {100, 250}},
		saidaF  = function(player)
			TFM.movePlayer(player, 12000, 7770, false)
			players[player].place = 'island'
			return true
		end,
	},
}