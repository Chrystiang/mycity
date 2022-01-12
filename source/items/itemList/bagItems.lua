lootDrops = {
	redPresent = {},
	goldenPresent = {},
}

bagIds = {}

bagItems = {
	energymax_green = {
		id = 1,
		price = 25,
		png = '179588a8be3.png',
		power = 10,
		type = 'food',
		npcShop = 'kariina, gominha',
		canBeFoundIn = {'redPresent'},
	},
	energymax_orange = {
		id = 2,
		price = 30,
		png = '179588aaa39.png',
		power = 15,
		type = 'food',
		npcShop = 'kariina, gominha',
		canBeFoundIn = {'redPresent'},
	},
	energymax_blue = {
		id = 3,
		price = 60,
		png = '179588a6bd9.png',
		power = 30,
		type = 'food',
		npcShop = 'kariina, gominha',
		canBeFoundIn = {'redPresent'},
	},
	pickaxe = {
		id = 4,
		price = 20,
		png = '16bdd10faea.png',
		type = 'item',
		npcShop = '-',
		miningPower = 2,
		blockUse = true,
	},
	clock = {
		id = 5,
		price = 5,
		png = '16c00f60557.png',
		type = 'item',
		func = function(i)
			chatMessage('<font color="#DAA520">'..updateHour(nil, true), i)
		end,
		npcShop = 'john',
	},
	milk = {
		id = 6,
		price = 5,
		png = '174acaef78b.png',
		hunger = 1,
		type = 'food',
		npcShop = 'gominha',
	},
	goldNugget = {
		id = 7,
		price = 115,
		png =  '16bc53d823f.png',
		limitedTime = os_time{day = 20, year = 2020, month = 4},
		blockUse = true,
	},
	dynamite = {
		id = 8,
		price = 150,
		png = '16bfb79a95f.png',
		type = 'holdingItem',
		miningPower = 10,
		holdingImages = {'16b94a559d7.png', '16b94a57834.png'}, -- left, right
		holdingAlign = {{-19, -9}, {1, -9}}, -- left, right
		placementFunction = function(player, x, y)
			local y = y-20
			if x > 5250 and x < 5310 and y > 5180 and y < 5250 then -- BANCO
				x = 5255
				y = 5200

				if room.gameDayStep ~= 'night' then
					players[player].place = 'police'
					addTimer(function(timer)
						if timer == 1 then
							showTextArea(-32000, "<font color='#FF00000'><p align='center'>"..translate('hey', player), player, 5255, 5201-15, 100, nil, 1, 1, 0.5, false)
						elseif timer == 3 then
							removeTextArea(-32000, player)
							arrestPlayer(player, 'Colt')
						end
					end, 1000, 3)
					return
				end
			elseif x > 2715 and x < 2830 and y > 1890+room.y then -- ENTRADA DO BANCO
				if room.gameDayStep == 'night' then
					x = 2771
					y = 1923 + room.y
				end
			end

			local imgToRemove = addImage('16b94de70fd.png', '!99999', x, y)


			addTimer(function()
				removeImage(imgToRemove)
				TFM.explosion(x, y, 50, 100, false)
				TFM.displayParticle(10, x, y)
				if x == 5255 and y == 5200 then -- BANCO
					if room.bankBeingRobbed then return end
					room.bankRobStep = 'robStarted'
					removeTimer('bankDoorsBroken')
					removeGroupImages(room.bankImages)
					addBankRobbingAssets()
					reloadBankAssets()

				elseif x == 2771 and y == 1923 + room.y then -- ENTRADA DO BANCO
					if room.bankBeingRobbed then return end
					if room.bankRobStep then return end
					room.bankImages[#room.bankImages+1] = addImage("16ba618ef7d.png", "?99999", 2700, 1674+room.y)
					room.bankRobStep = 'doorsBroken'
					addTimer(function(timer)
						for i, v in next, ROOM.playerList do
							if players[i].job ~= 'police' then 
								if math_hypo(x, y, v.x, v.y) <= 100 then
									checkIfPlayerIsDriving(i)
									movePlayer(i, places['bank'].exitSensor[1]-70, places['bank'].exitSensor[2], false)
									players[i].place = 'bank'
								end
							end
						end
					end, 1000, 10, 'bankDoorsBroken')
				end
			end, 5000, 1)
			return true
		end,
		npcShop = 'john',
	},
	shrinkPotion = {
		id = 9,
		price = 40,
		png = '16bc54ccf7a.png',
		complement = 30,
		type = 'complementItem',
		func = function(i)
			local random = random(0, 100)
			players[i].mouseSize = players[i].mouseSize - 0.7
			changeSize(i, players[i].mouseSize)
			showTextArea(989000000020+random, '', i, 400 - 84 * 0.5, 365, 84, 25, 0x19ba4d, 0x19ba4d, 0.5, true)
			local _timer
			_timer = addTimer(function(time)
				if not players[i].inRoom then removeTimer(_timer) end
				local width = 84 - floor(time/60 * 80)
				showTextArea(989000000020+random, '', i, 400 - 84 * 0.5, 365, width, 25, 0x19ba4d, 0x19ba4d, 0.5, true)
				if players[i].place == 'bank' then
					if room.bankRobStep == 'robStarted' then
						room.bankRobStep = 'lazers'
					end
				end
				if time == 60 then
					players[i].mouseSize = players[i].mouseSize + 0.7
					changeSize(i, players[i].mouseSize)
					removeTextArea(989000000020+random, i)
				end
			end, 500, 60)
		end,
		npcShop = 'indy',
	},
	growthPotion = {
		id = 10,
		price = 40,
		png = '16bc54cf1cd.png',
		complement = 30,
		type = 'complementItem',
		func = function(i)
			local random = random(0, 100)
			players[i].mouseSize = players[i].mouseSize + 2
			changeSize(i, players[i].mouseSize)
			showTextArea(989000000020+random, '', i, 400 - 84 * 0.5, 365, 84, 25, 0xf169ef, 0xf169ef, 0.5, true)
			local _timer
			_timer = addTimer(function(time)
				if not players[i].inRoom then removeTimer(_timer) end
				local width = 84 - floor(time/60 * 80)
				showTextArea(989000000020+random, '', i, 400 - 84 * 0.5, 365, width, 25, 0xf169ef, 0xf169ef, 0.5, true)
				if time == 60 then
					changeSize(i, 1)
					players[i].mouseSize = players[i].mouseSize - 2
					changeSize(i, players[i].mouseSize)
					removeTextArea(989000000020+random, i)
				end
			end, 500, 60)
		end,
		npcShop = 'indy',
	},
	coffee = {
		id = 11,
		price = 50,
		power = 25,
		hunger = 1,
		png = '16c00e1f53b.png',
		type = 'food',
		npcShop = 'alicia',
	},
	hotChocolate = {
		id = 12,
		price = 168,
		png = '17157e81a35.png',
		type = 'food',
		npcShop = 'alicia',
		credits = '<CS>Klei Entertainment</CS>',
		canBeFoundIn = {'redPresent'},
	},
	milkShake = {
		id = 13,
		price = 260,
		png = '17157f95ae1.png',
		type = 'food',
		npcShop = 'kariina, alicia',
		canBeFoundIn = {'redPresent'},
	},
	seed = {
		id = 14,
		price = 50,
		png = '16bf5c783fe.png',
		type = 'holdingItem',
		holdingImages = {'16bf622f30a.png', '16bf622a802.png'}, -- left, right
		holdingAlign = {{-20, 0}, {0, -5}}, -- left, right
		placementFunction = function(player, x, y, seed)
			if not seed then
				local numeroRandom = random(1, 10000)
				local total = 0
				seed = 1
				for id, data in next, players[player].seeds do
					total = total + data.rarity
					if total >= numeroRandom then
						seed = id
						if seed == 5 then 
							if players[player].jobs[5] >= 1000 then
								local colors = {5, 10, 11, 12, 13, 14, 15}
								seed = colors[random(#colors)]
							else
								seed = 1
							end
						end
						break
					end
				end
			end

			if string_find(players[player].place, 'house_') then
				local house_ = tonumber(players[player].place:sub(7))
				local owner = player
				if house_ == 12 then
					owner = 'Oliver'
					if players[player].job ~= 'farmer' then
						return
					end
				end
				if table_find(players[owner].houseTerrain, 2) then
					local idx = tonumber(players[owner].houseData.houseid)
					local yy = 1500 + 90
					for i, v in next, players[owner].houseTerrain do
						if v == 2 then
							if math_hypo(((idx-1)%idx)*1500+737 + (i-1)*175, yy+170, x, y) <= 90 then
								if players[owner].houseTerrainAdd[i] > 1 then return end
								players[owner].houseTerrainAdd[i] = 2
								players[owner].houseTerrainPlants[i] = seed
								HouseSystem.new(owner):genHouseGrounds()
								room.gardens[#room.gardens+1] = {owner = owner, timer = os_time(), terrain = i, idx = idx, plant = seed}
								local sidequest = sideQuests[players[player].sideQuests[1]].type
								if string_find(sidequest, 'type:plant') then
									if string_find(sidequest, 'oliver') and owner == 'Oliver' then
										sideQuest_update(player, 1)
									elseif not string_find(sidequest, 'oliver') then
										sideQuest_update(player, 1)
									end
								end
								return true
							end
						end
					end
				end
			end
		end,
		npcShop = 'body',
	},
	fertilizer = {
		id = 15,
		price = 200,
		png = '16bf5e01ec9.png',
		type = 'holdingItem',
		holdingImages = {'16bf5e01ec9.png', '16bf5e01ec9.png'}, -- left, right
		holdingAlign = {{-19, -9}, {1, -9}}, -- left, right
		fertilizingPower = 3,
		placementFunction = function(player, speed)
			return HouseSystem.fertilize(player, speed)
		end,
		npcShop = 'body',
	},
	water = {
		id = 16,
		price = 80,
		png = '1715a31e135.png',
		type = 'holdingItem',
		holdingImages = {'16bf5e003db.png', '16bf5e003db.png'}, -- left, right
		holdingAlign = {{-19, -9}, {1, -9}}, -- left, right
		fertilizingPower = 0.2,
		placementFunction = function(player, speed)
			local used = HouseSystem.fertilize(player, speed)
			
			if used then
				addItem('bucket', 1, player)
			end

			return used
		end,
		npcShop = 'body',
	},
	tomato = {
		id = 17,
		price = 2,
		png = '174acaf266f.png',
		hunger = .5,
		type = 'food',
	},
	bag = {
		id = 18,
		price = 3000,
		capacity = 5,
		type = 'bag',
	},
	tomatoSeed = {
		id = 18,
		png = '16c00dafc00.png',
	},
	oregano = {
		id = 19,
		price = 2,
		png = '16bfcb07a36.png',
		hunger = .1,
		type = 'food',
	},
	oreganoSeed = {
		id = 20,
		png = '16c258cc26c.png',
	},
	lemon = {
		id = 21,
		price = 2,
		png = '174acae248f.png',
		power = 2,
		hunger = 3,
		type = 'food',
	},
	lemonSeed = {
		id = 22,
		png = '16c00db153d.png',
		canBeFoundIn = {'redPresent'},
	},
	salt = {
		id = 23,
		price = 2,
		type = 'food',
		png = '16c1bfca398.png',
		hunger = -15,
		npcShop = 'gominha',
	},
	pepper = {
		id = 24,
		price = 2,
		power = 10,
		hunger = -15,
		type = 'food',
		png = '174acaf0efe.png',
	},
	pepperSeed = {
		id = 25,
		png = '1739ecf9ca7.png',
		canBeFoundIn = {'redPresent'},
	},
	luckyFlower = {
		id = 26,
		price = 2,
		power = 100,
		type = 'food',
		png = '16c258971c0.png',
		canBeFoundIn = {'redPresent'},
		sellingPrice = 2000,
	},
	luckyFlowerSeed = {
		id = 27,
		png = '174acaeb139.png',
	},
	sauce = {
		id = 28,
		price = 30,
		type = 'food',
		png = '17157debbd9.png',
		npcShop = 'kariina',
		credits = '<CS>Klei Entertainment</CS>',
	},
	hotsauce = {
		id = 29,
		price = 30,
		type = 'food',
		png = '17157e02ea4.png',
		npcShop = 'kariina',
		credits = '<CS>Klei Entertainment</CS>',
	},
	dough = {
		id = 30,
		price = 70,
		type = 'food',
		png = '1715f1bd94a.png',
		limitedTime = os_time{day = 20, year = 2020, month = 4},
	},
	wheat = {
		id = 31,
		price = 20,
		type = 'food',
		png = '16f94cd95c0.png',
	},
	wheatSeed = {
		id = 32,
		png = '16c2ae989c5.png',
	},
	pizza = {
		id = 33,
		price = 286,
		type = 'food',
		png = '171576bbb9e.png',
		power = 20,
		npcShop = 'kariina',
		credits = '<CS>Klei Entertainment</CS>',
	},
	cornFlakes = {
		id = 34,
		price = 80,
		type = 'food',
		png = '16c35643411.png',
		power = 15,
		hunger = 10,
		npcShop = 'gominha',
	},
	pumpkin = {
		id = 35,
		price = 500,
		png = '16de6657786.png',
		type = 'food',
		power = 30,
		hunger = 20,
	},
	pumpkinSeed = {
		id = 36,
		png = '16db258644e.png',
		limitedTime = os_time{day=11, year=2019, month=11},
	},
	superFertilizer = {
		id = 37,
		qpPrice = 8,
		png = '16dcab532fa.png',
		type = 'holdingItem',
		holdingImages = {'16dcab532fa.png', '16dcab532fa.png'}, -- left, right
		holdingAlign = {{-35, -15}, {-15, -15}}, -- left, right
		fertilizingPower = 6,
		placementFunction = function(player, speed)
			return HouseSystem.fertilize(player, speed)
		end,
		npcShop = 'marcus',
		canBeFoundIn = {'redPresent'},
	},
	cookies = {
		id = 38,
		price = 100,
		png = '17157d3d7b0.png',
		type = 'food',
		npcShop = 'alicia',
		credits = '<CS>Klei Entertainment</CS>',
	},
	sugar = {
		id = 39,
		price = 3,
		png = '174b29dfe45.png',
		type = 'food',
		npcShop = 'gominha',
	},
	chocolate = {
		id = 40,
		price = 30,
		png = '17dd92683fc.png',
		type = 'food',
		power = 6,
		hunger = 2,
		npcShop = 'gominha',
	},
	blueberries = {
		id = 41,
		price = 100,
		type = 'food',
		png = '17097199d00.png',
		power = 10,
		hunger = 5,
	},
	blueberriesSeed = {
		id = 42,
		qpPrice = 4,
		png = '16f23b75123.png',
		type2 = 'limited-christmas2019',
		limitedTime = os_time{day=15, year=2020, month=1},
	},
	cheese = {
		id = 43,
		price = 100,
		type = 'item',
		png = '170b6b4db9c.png',
		func = function(i)
			local oldPositions = {ROOM.playerList[i].x, ROOM.playerList[i].y}
			TFM.giveCheese(i)
			TFM.playerVictory(i)
			respawnPlayer(i)
			if players[i].isBlind then setNightMode(i) end
			if players[i].isFrozen then freezePlayer(i, true) end
			movePlayer(i, oldPositions[1], oldPositions[2], false)
		end,
	},
	fish_Smolty = {
		id = 44,
		price = 15,
		type = 'food',
		png = '17b349bffc0.png',
		power = -10,
		hunger = -10,
	},
	fish_Lionfish = {
		id = 45,
		price = 300,
		type = 'food',
		png = '17b34958a82.png',
		power = -10,
		hunger = -10,
	},
	fish_Dogfish = {
		id = 46,
		price = 300,
		type = 'food',
		png = '17b349a213a.png',
		power = -10,
		hunger = -10,
	},
	fish_Catfish = {
		id = 47,
		price = 300,
		type = 'food',
		png = '17b349ad3d6.png',
		power = -10,
		hunger = -10,
	},
	fish_Guppy = {
		id = 48,
		price = 50,
		type = 'food',
		png = '17b3491ffd6.png',
		power = -10,
		hunger = -10,
	},
	fish_Lobster = {
		id = 49,
		price = 1000,
		type = 'food',
		png = '17b3483f370.png',
		power = -20,
		hunger = -20,
	},
	fish_Goldenmare = {
		id = 50,
		price = 10000,
		type = 'food',
		png = '17b348450ff.png',
		power = -60,
		hunger = -40,
	},
	fish_Frog = {
		id = 51,
		price = 15,
		type = 'food',
		png = '170c186188b.png',
		power = -1,
		hunger = -1,
		credits = '<CS>Klei Entertainment</CS>',
	},
	lemonade = {
		id = 52,
		price = 0,
		png = '17157d74289.png',
		type = 'food',
		credits = '<CS>Klei Entertainment</CS>',
	},
	lobsterBisque = {
		id = 53,
		price = 0,
		png = '17157feb8ea.png',
		type = 'food',
		credits = '<CS>Klei Entertainment</CS>',
	},
	bread = {
		id = 54,
		price = 0,
		png = '171577ce37b.png',
		type = 'food',
		credits = '<CS>Klei Entertainment</CS>',
	},
	bruschetta = {
		id = 55,
		price = 0,
		png = '17157829bde.png',
		type = 'food',
		credits = '<CS>Klei Entertainment</CS>',
	},
	waffles = {
		id = 56,
		price = 150,
		png = '171578aa546.png',
		type = 'food',
		npcShop = 'alicia',
		credits = '<CS>Klei Entertainment</CS>',
		canBeFoundIn = {'redPresent'},
	},
	egg = {
		id = 57,
		price = 10,
		png = '174acae0d21.png',
		type = 'food',
		power = 1,
		hunger = 1,
		canBeFoundIn = {'redPresent'},
	},
	honey = {
		id = 58,
		price = 50,
		png = '17dd9260b6e.png',
		type = 'food',
		power = 1,
		hunger = 3,
		canBeFoundIn = {'redPresent'},
	},
	grilledLobster = {
		id = 59,
		price = 0,
		png = '17157dd5e6a.png',
		type = 'food',
		credits = '<CS>Klei Entertainment</CS>',
		canBeFoundIn = {'redPresent'},
	},
	frogSandwich = {
		id = 60,
		price = 0,
		png = '17157f6d781.png',
		type = 'food',
		credits = '<CS>Klei Entertainment</CS>',
	},
	chocolateCake = {
		id = 61,
		price = 0,
		png = '1715a4b33a0.png',
		type = 'food',
	},
	wheatFlour = {
		id = 62,	
		price = 0,
		png = '172af5128f3.png',
		type = 'food',
		power = 1,
		hunger = 1,
	},
	salad = {
		id = 63,	
		price = 0,
		png = '1715a459466.png',
		type = 'food',
	},
	lettuce = {
		id = 64,	
		price = 20,
		png = '174acea1435.png',
		type = 'food',
		hunger = .1,
	},
	pierogies = {
		id = 65,	
		price = 20,
		png = '1715af36d28.png',
		type = 'food',
		credits = '<CS>Klei Entertainment</CS>',
	},
	potato = {
		id = 66,	
		price = 20,
		png = '1745f7c79bf.png',
		type = 'food',
		hunger = 0.7,
	},
	frenchFries = {
		id = 67,	
		price = 20,
		png = '1715aff214a.png',
		type = 'food',
	},
	pudding = {
		id = 68,	
		price = 20,
		png = '1715b4476e2.png',
		type = 'food',
		credits = 'Mescoleur#0000',
	},
	garlicBread = {
		id = 69,	
		price = 20,
		png = '1715f2f672e.png',
		type = 'food',
		credits = '<CS>Klei Entertainment</CS>',
	},
	garlic = {
		id = 70,	
		price = 20,
		png = '1745fc72f96.png',
		type = 'food',
		power = 4,
		hunger = 1,
		credits = '<CS>Klei Entertainment</CS>',
	},
	blueprint = {
		id = 71,
		price = 200,
		type = 'holdingItem',
		png = '17b348fccb3.png',
		blockUse = true,
	},
	crystal_yellow = {
		id = 72,
		type = 'crystal',
		png = '172373f61f1.png',
		jobStatID = 12,
		canBeFoundIn = {'redPresent'},
		blockUse = true,
	},
	crystal_blue = {
		id = 73,
		type = 'crystal',
		png = '172373eddec.png',
		jobStatID = 13,
		blockUse = true,
	},
	crystal_purple = {
		id = 74,
		type = 'crystal',
		png = '172373f2060.png',
		jobStatID = 14,
		canBeFoundIn = {'redPresent'},
		blockUse = true,
	},
	crystal_green = {
		id = 75,
		type = 'crystal',
		png = '172373f009d.png',
		jobStatID = 15,
		blockUse = true,
	},
	crystal_red = {
		id = 76,
		type = 'crystal',
		png = '172373f3f04.png',
		jobStatID = 16,
		canBeFoundIn = {'redPresent'},
		blockUse = true,
	},
	banana = {
		id = 77,
		type = 'food',
		png = '1739ecd37b8.png',
		power = 4,
		hunger = 4,
	},
	bananaSeed = {
		id = 78,
		png = '1739ed5e5fc.png',
	},
	moqueca = {
		id = 79,
		type = 'food',
		png = '1739f4c8a00.png',
		credits = '<CS>Klei Entertainment</CS>',
	},
	grilledCheese = {
		id = 80,
		type = 'food',
		png = '173f8126cf7.png',
		credits = '<CS>Klei Entertainment</CS>',
	},
	fishBurger = {
		id = 81,
		type = 'food',
		png = '173f814d309.png',
		credits = '<CS>Klei Entertainment</CS>',
		canBeFoundIn = {'redPresent'},
	},
	sushi = {
		id = 82,
		type = 'food',
		png = '173f81bb164.png',
		credits = '<CS>Klei Entertainment</CS>',
		canBeFoundIn = {'redPresent'},
	},
	bananaCake = {
		id = 83,
		type = 'food',
		png = '1740da36102.png',
	},
	croquettes = {
		id = 84,
		type = 'food',
		png = '1740db2a66d.png',
		credits = '<CS>Klei Entertainment</CS>',
	},
	meat = {
		id = 85,	
		price = 200,
		png = '17b348a503e.png',
		type = 'food',
		hunger = -10,
	},
	mushroom = {
		id = 86,
		png = '17b348bf20c.png',
		type = 'food',
		price = 200,
		energy = 9,
		hunger = 4,
	},
	cheeseburger = {
		id = 87,	
		png = '1745f8487c1.png',
		type = 'food',
		credits = '<CS>Klei Entertainment</CS>',
	},
	lasagna = {
		id = 88,	
		png = '1745f84a7f0.png',
		type = 'food',
		credits = '<CS>Klei Entertainment</CS>',
	},
	meatballs = {
		id = 89,	
		png = '1745f8ed295.png',
		type = 'food',
		credits = '<CS>Klei Entertainment</CS>',
		canBeFoundIn = {'redPresent'},
	},
	garlicMashedPotatoes = {
		id = 90,	
		png = '17479fb35b3.png',
		type = 'food',
		credits = '<CS>Klei Entertainment</CS>',
	},
	mushroomBurger = {
		id = 91,	
		png = '1745f96c2ba.png',
		type = 'food',
		credits = '<CS>Klei Entertainment</CS>',
		canBeFoundIn = {'redPresent'},
	},
	creamOfMushroom = {
		id = 92,	
		png = '1745f9a16e2.png',
		type = 'food',
		credits = '<CS>Klei Entertainment</CS>',
	},
	pumpkinPie = {
		id = 93,
		qpPrice = 10,
		png = '1747006faae.png',
		type = 'food',
		npcShop = 'alicia',
		credits = '<CS>Klei Entertainment</CS>',
		canBeFoundIn = {'redPresent'},
	},
	steakFrites = {
		id = 94,	
		png = '1747006cf6d.png',
		type = 'food',
		credits = '<CS>Klei Entertainment</CS>',
		canBeFoundIn = {'redPresent'},
	},
	breadedCutlet = {
		id = 95,	
		png = '1747006a7b5.png',
		type = 'food',
		credits = '<CS>Klei Entertainment</CS>',
	},
	fishAndChips = {
		id = 96,	
		png = '174700680f4.png',
		type = 'food',
		credits = '<CS>Klei Entertainment</CS>',
	},
	cyan_luckyFlowerSeed = {
		id = 97,
		png = '174acae6ae4.png',
	},
	orange_luckyFlowerSeed = {
		id = 98,
		png = '174acae99c5.png',
	},
	red_luckyFlowerSeed = {
		id = 99,
		png = '174acaee01b.png',
	},
	purple_luckyFlowerSeed = {
		id = 100,
		png = '174acaec8aa.png',
	},
	green_luckyFlowerSeed = {
		id = 101,
		png = '174acae8254.png',
	},
	black_luckyFlowerSeed = {
		id = 102,
		png = '174acae5371.png',
	},
	random_luckyFlowerSeed = {
		id = 103,
		png = '174accc594d.png',
		canBeFoundIn = {'redPresent'},
		lootBoxChance = 20,
		limitedTime = os_time{day=15, year=2021, month=1},
	},
	cyan_luckyFlower = {
		id = 104,
		png = '174acdb9149.png',
		hunger = 100,
		type = 'food',
		sellingPrice = 2000,
	},
	orange_luckyFlower = {
		id = 105,
		png = '174ace760db.png',
		power = 50,
		hunger = 50,
		type = 'food',
		sellingPrice = 2000,
	},
	red_luckyFlower = {
		id = 106,
		png = '174ace85a8d.png',
		hunger = 90,
		power = 10,
		type = 'food',
		sellingPrice = 2000,
	},
	purple_luckyFlower = {
		id = 107,
		png = '174acda2e71.png',
		hunger = 10,
		power = 90,
		type = 'food',
		sellingPrice = 2000,
	},
	green_luckyFlower = {
		id = 108,
		png = '174acda4d8c.png',
		power = -666,
		type = 'food',
		sellingPrice = 2000,
	},
	black_luckyFlower = {
		id = 109,
		png = '174ace61bcb.png',
		hunger = 100,
		power = 100,
		type = 'food',
		sellingPrice = 2000,
	},
	shovel = {
		id = 110,
		price = 250,
		png = '174b17580a1.png',
		type = 'holdingItem',
		npcShop = 'body',
		holdingImages = {'174b17580a1.png', '174b17580a1.png'}, -- left, right
		holdingAlign = {{-35, -20}, {-15, -20}}, -- left, right
		placementFunction = function(player)
			return HouseSystem.removeCrop(player)
		end,
	},
	strangePumpkin = {
		id = 111,
		png = '17529e727b2.png',
		type = 'food',
		power = 30,
		hunger = 20,
		limitedTime = os_time{day=16, year=2020, month=11},
	},
	strangePumpkinSeed = {
		id = 112,
		qpPrice = 10,
		png = '17529e77aa4.png',
		limitedTime = os_time{day=16, year=2020, month=11},
		npcShop = 'drekkemaus',
	},
	candyBucket = {
		id = 113,
		png = '17529e757c5.png',
		type = 'food',
		power = 30,
		hunger = 20,
		limitedTime = os_time{day=16, year=2020, month=11},
	},
	raspberry = {
		id = 114,
		png = '176887ebc7c.png',
		type = 'food',
		power = 6,
		hunger = 5,
		limitedTime = os_time{day=15, year=2021, month=1},
	},
	raspberrySeed = {
		id = 115,
		png = '1768883f48c.png',
		qpPrice = 30,
		limitedTime = os_time{day=15, year=2021, month=1},
		canBeFoundIn = {'redPresent'},
	},
	fish_Mudfish = {
		id = 116,
		price = 15,
		type = 'food',
		png = '17b349418fa.png',
		power = -10,
		hunger = -10,
	},
	fish_Frozice = {
		id = 117,
		price = 1200,
		type = 'food',
		png = '1768896896f.png',
		power = 20,
		hunger = 20,
		credits = '<CS>Klei Entertainment</CS>',
		limitedTime = os_time{day=16, year=2021, month=1},
	},
	fish_Sinkfish = {
		id = 118,
		price = 15,
		type = 'food',
		png = '1768899aa8f.png',
		power = -10,
		hunger = -10,
		credits = '<CS>Klei Entertainment</CS>',
	},
	fish_Bittyfish = {
		id = 119,
		price = 300,
		type = 'food',
		png = '176889e0f82.png',
		power = -10,
		hunger = -10,
		credits = '<CS>Klei Entertainment</CS>',
	},
	redPresent = {
		id = 120,
		type = 'holdingItem',
		png = '1768d396143.png',
		holdingImages = {'1768d396143.png', '1768d396143.png'}, -- left, right
		holdingAlign = {{-35, -20}, {-15, -20}}, -- left, right
		placementFunction = function(player)
			local gift = lootDrops.redPresent[random(#lootDrops.redPresent)]
			if bagItems[gift].lootBoxChance then
				local chance = random(100)
				if chance >= bagItems[gift].lootBoxChance then
					gift = 'cheese'
				end
			end

			addItem(gift, 1, player, nil, true)

			return true
		end,
		limitedTime = os_time{day=15, year=2021, month=1},
	},
	speedPotion = {
		id = 121,
		price = 50,
		png = '1770c7bfc1c.png',
		complement = 30,
		type = 'complementItem',
		func = function(i)
			local random = random(0, 100)
			local _timer
			local speed = 80

			showTextArea(989000000020+random, '', i, 400 - 84 * 0.5, 365, 84, 25, 0xe8ba00, 0xe8ba00, 0.5, true)

			_timer = addTimer(function(time)
				if not players[i].inRoom then 
					removeTimer(_timer)
				end

				if ROOM.playerList[i].movingLeft then
					movePlayer(i, 0, 0, false, -speed, 0, false)
				elseif ROOM.playerList[i].movingRight then
					movePlayer(i, 0, 0, false, speed, 0, false)
				end

				local width = 84 - floor(time/60 * 80)
				showTextArea(989000000020+random, '', i, 400 - 84 * 0.5, 365, width, 25, 0xe8ba00, 0xe8ba00, 0.5, true)
				if time == 60 then
					removeTextArea(989000000020+random, i)
				end
			end, 500, 60)
		end,
		npcShop = 'indy',
	},
	raspberryCake = {
		id = 122,	
		png = '178a768dab8.png',
		type = 'food',
	},
	goldenPresent = {
		id = 123,
		type = 'holdingItem',
		png = '17dd48d1819.png',
		holdingImages = {'17dd48d1819.png', '17dd48d1819.png'}, -- left, right
		holdingAlign = {{-35, -20}, {-15, -20}}, -- left, right
		placementFunction = function(player)
			local gift = lootDrops.goldenPresent[random(#lootDrops.goldenPresent)]
			if bagItems[gift].lootBoxChance then
				local chance = random(100)
				if chance >= bagItems[gift].lootBoxChance then
					gift = 'cheese'
				end
			end

			addItem(gift, 1, player, nil, true)

			return true
		end,
		limitedTime = os_time{day=14, year=2022, month=1},
	},
	bucket = {
		id = 124,	
		png = '17e11e0b332.png',
		type = 'holdingItem',
		holdingImages = {'17e11e0b332.png', '17e11e0b332.png'}, -- left, right
		holdingAlign = {{-19, -9}, {1, -9}}, -- left, right
		placementFunction = function(player, x, y)
			local biome = false
			for place, settings in next, room.fishing.biomes do 
				if math_range(settings.location, {x = x, y = y}) then 
					biome = place
					break
				end
			end

			if biome then
				addItem('water', 1, player, nil, true)
			end

			return biome
		end,
	},
    prop_A1 = {
        type = "prop",
        id = 125,
        png = "17e11dc3673.png",
		limitedTime = os_time{day=14, year=2022, month=1},
    },
    prop_A2 = {
        type = "prop",
        id = 126,
        png = "17e11dc9d5f.png",
		limitedTime = os_time{day=14, year=2022, month=1},
    },
    prop_A3 = {
        type = "prop",
        id = 127,
        png = "17e11dd22e4.png",
		limitedTime = os_time{day=14, year=2022, month=1},
    },
    prop_A4 = {
        type = "prop",
        id = 128,
        png = "17e11dd81ed.png",
		limitedTime = os_time{day=14, year=2022, month=1},
    },
    prop_A5 = {
        type = "prop",
        id = 129,
        png = "17e11dae425.png",
        canBeFoundIn = {'redPresent'},
		limitedTime = os_time{day=14, year=2022, month=1},
    },
    prop_A6 = {
        type = "prop",
        id = 130,
        png = "17e11db33c1.png",
		limitedTime = os_time{day=14, year=2022, month=1},
    },
    prop_A7 = {
        type = "prop",
        id = 131,
        png = "17e11db892f.png",
        canBeFoundIn = {'redPresent'},
        limitedTime = os_time{day=14, year=2022, month=1},
    },
    snowBucket = {
		id = 132,	
		png = '17e1abfa005.png',
		type = 'holdingItem',
		holdingImages = {'17e1abfa005.png', '17e1abfa005.png'}, -- left, right
		holdingAlign = {{-19, -9}, {1, -9}}, -- left, right
		fertilizingPower = 0.3,
		placementFunction = function(player, speed)
			local used = HouseSystem.fertilize(player, speed)
			
			if used then
				addItem('bucket', 1, player)
			end

			return used
		end,
	},
	snowman = {
		id = 133,	
		png = '17e1af58f3a.png',
		limitedTime = os_time{day=14, year=2022, month=1},
	},
}

for item, data in next, bagItems do
	if item:find('Seed') then
		if not data.holdingImages then
			data.type = 'holdingItem'
			data.holdingImages = {data.png, data.png}
			data.holdingAlign = {{-35, -20}, {-15, -20}}
		end
	end
	
	if data.canBeFoundIn then
		if table_find(data.canBeFoundIn, 'redPresent') then
			lootDrops.redPresent[#lootDrops.redPresent+1] = item
			lootDrops.goldenPresent[#lootDrops.goldenPresent+1] = item			
		end
	end

	bagIds[data.id] = {n = item, blockUse = data.blockUse, blockTrades = data.blockTrades}
end