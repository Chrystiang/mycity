places = {
	market = {
		id = 1,
		opened  = '-',
		exitSensor = {3524, 230},
		tp_town = {3473, 7770},
	},
	hospital = {
		id = 2,
		opened = '-',
		exitSensor = {4658, 3635},
		tp_town = {4850, 7770},
		spawnAtLeft = true,
	},
	police = {
		id = 3,
		opened  = '-',
		exitSensor = {7275, 6210},
		tp_town = {1090, 7570},
	},
	buildshop = {
		id = 4,
		opened  = '08:00 19:00',
		tp_town = {495, 7570},
		exitSensor = {144, 230},
	},
	dealership = {
		id = 5,
		opened  = '07:00 19:00',
		tp_town = {5000, 7770},
		exitSensor = {8550, 230},
	},
	bank = {
		id = 6,
		opened  = '07:00 19:00',
		tp_town = {2775, 7770},
		exitSensor = {5540, 5230},
		afterExit  = function(player)
			if room.bankBeingRobbed then
				local shield = addImage('1566af4f852.png', '$'..player, -45, -45)
				players[player].robbery.usingShield = true
				addTimer(function()
					removeImage(shield)
					players[player].robbery.usingShield = false
				end, 7000, 1)
			end
		end
	},
	pizzeria = {
		id = 7,
		opened  = '-',
		tp_town = {4410, 7770},
		exitSensor = {14080, 230},
	},
	fishShop = {
		id = 8,
		opened  = '-',
		tp_town = {6030, 7770},
		exitSensor = {12648, 230},
	},
	furnitureStore = {
		id = 9,
		opened = '08:00 19:00',
		tp_town = {5770, 7770},
		exitSensor = {16070, 230},
	},
	town = {
		id = 10,
		opened  = '-',
		exitSensor = {980, 8610},
		tp_mine = {1260, 8650},
	},
	mine = {
		id = 11,
		opened  = '-',
		exitSensor = {1210, 8645},
		tp_town = {895, 8600},
	},
	mine_excavation = {
		id = 12,
		opened = '-',
		exitSensor = {5433, 8122},
		tp_town = {5415, 7770},
	},
	cafe = {
		id = 13,
		opened  = '-',
		exitSensor = {6090, 230},
		tp_island = {10470, 7770},
	},
	potionShop = {
		id = 14,
		opened = '11:00 19:00',
		tp_island = {9895, 7770},
		exitSensor = {10575, 230},
	},
	seedStore = {
		id = 15,
		opened = '10:00 19:00',
		tp_island = {12000, 7770},
		exitSensor = {11430, 230},
	},
	boatShop = {
		id = 16,
		opened = '-',
		exitSensor = {1917, 8810},
		tp_boatShop = {1455, 9300},
		afterExit = function(player)
			showBoatShop(player, 1)
			showTextArea(1053, string.rep('\n', 10), player, 1425, 9125, 50, 200, 0, 0, 0, false, 
				function(player)
					players[player].place = 'mine'
					setNightMode(player)
					movePlayer(player, 1873, 8810, false)
				end)
		end,
	},
	clockTower = {
		id = 17,
		opened = '-',
		tp_town = {2155, 7770},
		exitSensor = {9570, 5245},
	},
	penguinVillage = {
		id = 18,
		opened = '-',
		tp_town = {8063, 7750},
		exitSensor = {11084, 5245},
	},
}