bagItems = {
	energyDrink_Basic = {
		id = 1,
		price = 25,
		png = '172ced59c50.png',
		power = 10,
		type = 'food',
		npcShop = 'kariina',
	},
	energyDrink_Mega = {
		id = 2,
		price = 30,
		png = '172ced57ff3.png',
		power = 15,
		type = 'food',
		npcShop = 'kariina',
	},
	energyDrink_Ultra = {
		id = 3,
		price = 60,
		png = '172ced55dcc.png',
		power = 30,
		type = 'food',
		npcShop = 'kariina',
	},
	pickaxe = {
		id = 4,
		price = 20,
		png = '16bdd10faea.png',
		type = 'item',
		npcShop = '-',
		miningPower = 2,
	},
	clock = {
		id = 5,
		price = 5,
		png = '16c00f60557.png',
		type = 'item',
		func = function(i)
			TFM.chatMessage('<font color="#DAA520">'..updateHour(nil, true), i)
		end,
		npcShop = 'john',
	},
	milk = {
		id = 6,
		price = 5,
		png = '16c2cc5ea17.png',
		hunger = 1,
		type = 'food',
	},
	goldNugget = {
		id = 7,
		price = 115,
		png =  '16bc53d823f.png',
		limitedTime = os.time{day = 20, year = 2020, month = 4},
	},
	dynamite = {
		id = 8,
		price = 150,
		png = '16bfb79a95f.png',
		type = 'holdingItem',
		miningPower = 10,
		holdingImages = {'16b94a559d7.png', '16b94a57834.png'}, -- left, right
		holdingAlign = {{-19, -9}, {1, -9}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'dynamite'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
		placementFunction = function(player, x, y)
			local y = y-20
			if x > 5250 and x < 5310 and y > 5180 and y < 5250 then -- BANCO
				x = 5255
				y = 5200

				if room.gameDayStep ~= 'night' then
					players[player].place = 'police'
					addTimer(function(timer)
						if timer == 1 then
							ui.addTextArea(-32000, "<font color='#FF00000'><p align='center'>"..translate('hey', player), player, 5255, 5201-15, 100, nil, 1, 1, 0.5, false)
						elseif timer == 3 then
							ui.removeTextArea(-32000, player)
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
					for i = 1, #room.bankImages do
						removeImage(room.bankImages[i])
					end
					room.bankImages = {}
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
								if math.hypo(x, y, v.x, v.y) <= 100 then
									checkIfPlayerIsDriving(i)
									TFM.movePlayer(i, places['bank'].tp[1], places['bank'].tp[2], false)
									players[i].place = 'bank'
									showOptions(i)
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
			local random = math.random(0, 100)
			players[i].mouseSize = players[i].mouseSize - 0.7
			TFM.changePlayerSize(i, players[i].mouseSize)
			ui.addTextArea(989000000020+random, '', i, 400 - 84 * 0.5, 365, 84, 25, 0x19ba4d, 0x19ba4d, 0.5, true)
			local _timer
			_timer = addTimer(function(time)
				if not players[i].inRoom then removeTimer(_timer) end
				local width = 84 - math.floor(time/30 * 80)
				ui.addTextArea(989000000020+random, '', i, 400 - 84 * 0.5, 365, width, 25, 0x19ba4d, 0x19ba4d, 0.5, true)
				if players[i].place == 'bank' then
					if room.bankRobStep == 'robStarted' then
						room.bankRobStep = 'lazers'
					end
				end
				if time == 30 then
					players[i].mouseSize = players[i].mouseSize + 0.7
					TFM.changePlayerSize(i, players[i].mouseSize)
					ui.removeTextArea(989000000020+random, i)
				end
			end, 1000, 30)
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
			local random = math.random(0, 100)
			players[i].mouseSize = players[i].mouseSize + 2
			TFM.changePlayerSize(i, players[i].mouseSize)
			ui.addTextArea(989000000020+random, '', i, 400 - 84 * 0.5, 365, 84, 25, 0xf169ef, 0xf169ef, 0.5, true)
			local _timer
			_timer = addTimer(function(time)
				if not players[i].inRoom then removeTimer(_timer) end
				local width = 84 - math.floor(time/30 * 80)
				ui.addTextArea(989000000020+random, '', i, 400 - 84 * 0.5, 365, width, 25, 0xf169ef, 0xf169ef, 0.5, true)
				if time == 30 then
					TFM.changePlayerSize(i, 1)
					players[i].mouseSize = players[i].mouseSize - 2
					TFM.changePlayerSize(i, players[i].mouseSize)
					ui.removeTextArea(989000000020+random, i)
				end
			end, 1000, 30)
		end,
		npcShop = 'indy',
	},
	coffee = {
		id = 11,
		price = 100,
		power = 25,
		hunger = 1,
		png = '16c00e1f53b.png',
		type = 'food',
	},
	hotChocolate = {
		id = 12,
		price = 168,
		png = '17157e81a35.png',
		type = 'food',
	},
	milkShake = {
		id = 13,
		price = 260,
		png = '17157f95ae1.png',
		type = 'food',
		npcShop = 'kariina',
	},
	seed = {
		id = 14,
		price = 50,
		png = '16bf5c783fe.png',
		type = 'holdingItem',
		holdingImages = {'16bf622f30a.png', '16bf622a802.png'}, -- left, right
		holdingAlign = {{-20, 0}, {0, -5}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'seed'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
		placementFunction = function(player, x, y, seed)
			if not seed then
				local numeroRandom = math.random(1, 10000)
				local total = 0
				seed = 1
				for type, data in next, players[player].seeds do
					total = total + data.rarity
					if total >= numeroRandom then
						seed = tonumber(type)
						break
					end
				end
			end
			if string.find(players[player].place, 'house_') then
				local house_ = tonumber(players[player].place:sub(7))
				local owner = player
				if house_ == 12 then
					owner = 'Oliver'
					if players[player].job ~= 'farmer' then
						return
					end
				end
				if table.contains(players[owner].houseTerrain, 2) then
					local idx = tonumber(players[owner].houseData.houseid)
					local yy = 1500 + 90
					for i, v in next, players[owner].houseTerrain do
						if v == 2 then
							if math.hypo(((idx-1)%idx)*1500+737 + (i-1)*175, yy+170, x, y) <= 90 then
								if players[owner].houseTerrainAdd[i] > 1 then return end
								players[owner].houseTerrainAdd[i] = 2
								players[owner].houseTerrainPlants[i] = seed
								HouseSystem.new(owner):genHouseGrounds()
								room.gardens[#room.gardens+1] = {owner = owner, timer = os.time(), terrain = i, idx = idx, plant = seed}
								local sidequest = sideQuests[players[player].sideQuests[1]].type
								if string.find(sidequest, 'type:plant') then
									if string.find(sidequest, 'oliver') and owner == 'Oliver' then
										sideQuest_update(player, 1)
									elseif not string.find(sidequest, 'oliver') then
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
		func = function(player)
			players[player].holdingItem = 'fertilizer'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
		placementFunction = function(player, x, y)
			if string.find(players[player].place, 'house_') then
				local house_ = tonumber(players[player].place:sub(7))
				local owner = player
				if house_ == 12 then
					owner = 'Oliver'
					if players[player].job ~= 'farmer' then
						return
					end
				end
				if table.contains(players[owner].houseTerrain, 2) then
					local idx = tonumber(players[owner].houseData.houseid)
					local yy = 1500 + 90
					for i, v in next, players[owner].houseTerrain do
						if v == 2 then
							if math.hypo(((idx-1)%idx)*1500+737 + (i-1)*175, yy+170, x, y) <= 90 then
								if players[owner].houseTerrainAdd[i] > 1 then
									for ii, vv in next, room.gardens do
										if vv.owner == owner then
											if vv.terrain == i then
												vv.timer = vv.timer - 60*3*1000
												local sidequest = sideQuests[players[player].sideQuests[1]].type
												if string.find(sidequest, 'type:fertilize') then
													if string.find(sidequest, 'oliver') and owner == 'Oliver' then
														sideQuest_update(player, 1)
													elseif not string.find(sidequest, 'oliver') then
														sideQuest_update(player, 1)
													end
												end
												return true
											end
										end
									end
								end
							end
						end
					end
				end
			end
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
		func = function(player)
			players[player].holdingItem = 'water'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
		placementFunction = function(player, x, y)
			if string.find(players[player].place, 'house_') then
				local house_ = tonumber(players[player].place:sub(7))
				local owner = player
				if house_ == 12 then
					owner = 'Oliver'
					if players[player].job ~= 'farmer' then
						return
					end
				end
				--if not players[player].houseData.houseid == house_ and players[player].job ~= 'farmer' then return end
				if table.contains(players[owner].houseTerrain, 2) then
					local idx = tonumber(players[owner].houseData.houseid)
					local yy = 1500 + 90
					for i, v in next, players[owner].houseTerrain do
						if v == 2 then
							if math.hypo(((idx-1)%idx)*1500+737 + (i-1)*175, yy+170, x, y) <= 90 then
								if players[owner].houseTerrainAdd[i] > 1 then
									for ii, vv in next, room.gardens do
										if vv.owner == owner then
											if vv.terrain == i then
												vv.timer = vv.timer - 40*1000
												return true
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end,
		npcShop = 'body',
	},
	tomato = {
		id = 17,
		price = 2,
		png = '16f94cbed5e.png',
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
		price = 2,
		png = '16c00dafc00.png',
		type = 'holdingItem',
		holdingImages = {'16c00dafc00.png', '16c00dafc00.png'}, -- left, right
		holdingAlign = {{-15, 0}, {0, 0}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'tomatoSeed'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
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
		price = 2,
		type = 'holdingItem',
		png = '16c258cc26c.png',
		holdingImages = {'16c258cc26c.png', '16c258cc26c.png'}, -- left, right
		holdingAlign = {{-15, 0}, {0, 0}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'oreganoSeed'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
	},
	lemon = {
		id = 21,
		price = 2,
		png = '16f9568e434.png',
		power = 2,
		hunger = 3,
		type = 'food',
	},
	lemonSeed = {
		id = 22,
		price = 2,
		type = 'holdingItem',
		png = '16c00db153d.png',
		holdingImages = {'16c00db153d.png', '16c00db153d.png'}, -- left, right
		holdingAlign = {{-15, 0}, {0, 0}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'lemonSeed'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
	},
	salt = {
		id = 23,
		price = 2,
		type = 'food',
		png = '16c1bfca398.png',
		hunger = -15,
	},
	pepper = {
		id = 24,
		price = 2,
		power = 10,
		hunger = -15,
		type = 'food',
		png = '16c2595316f.png',
	},
	pepperSeed = {
		id = 25,
		price = 2,
		type = 'holdingItem',
		png = '1739ecf9ca7.png',
		holdingImages = {'1739ecf9ca7.png', '1739ecf9ca7.png'}, -- left, right
		holdingAlign = {{-50, -15}, {0, -15}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'pepperSeed'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
	},
	luckyFlower = {
		id = 26,
		price = 2,
		power = 100,
		type = 'food',
		png = '16c258971c0.png',
		func = function(i)
			setLifeStat(i, 1, 100)
		end
	},
	luckyFlowerSeed = {
		id = 27,
		price = 2,
		type = 'holdingItem',
		png = '16c259c7198.png',
		holdingImages = {'16c259c7198.png', '16c259c7198.png'}, -- left, right
		holdingAlign = {{-35, -20}, {-15, -20}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'luckyFlowerSeed'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
	},
	sauce = {
		id = 28,
		price = 30,
		type = 'food',
		png = '17157debbd9.png',
		npcShop = 'kariina',
	},
	hotsauce = {
		id = 29,
		price = 30,
		type = 'food',
		png = '17157e02ea4.png',
		npcShop = 'kariina',
	},
	dough = {
		id = 30,
		price = 70,
		type = 'food',
		png = '1715f1bd94a.png',
		limitedTime = os.time{day = 20, year = 2020, month = 4},
	},
	wheat = {
		id = 31,
		price = 20,
		type = 'food',
		png = '16f94cd95c0.png',
	},
	wheatSeed = {
		id = 32,
		price = 2,
		type = 'holdingItem',
		png = '16c2ae989c5.png',
		holdingImages = {'16c2ae989c5.png', '16c2ae989c5.png'}, -- left, right
		holdingAlign = {{-15, 0}, {0, 0}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'wheatSeed'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
	},
	pizza = {
		id = 33,
		price = 286,
		type = 'food',
		png = '171576bbb9e.png',
		power = 20,
		npcShop = 'kariina',
	},
	cornFlakes = {
		id = 34,
		price = 80,
		type = 'food',
		png = '16c35643411.png',
		power = 15,
		hunger = 10,
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
		type = 'holdingItem',
		png = '16db258644e.png',
		holdingImages = {'16db258644e.png', '16db258644e.png'}, -- left, right
		holdingAlign = {{-15, 0}, {0, 0}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'pumpkinSeed'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
	},
	superFertilizer = {
		id = 37,
		qpPrice = 8,
		png = '16dcab532fa.png',
		type = 'holdingItem',
		holdingImages = {'16dcab532fa.png', '16dcab532fa.png'}, -- left, right
		holdingAlign = {{-35, -15}, {-15, -15}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'superFertilizer'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
		placementFunction = function(player, x, y)
			if string.find(players[player].place, 'house_') then
				local house_ = tonumber(players[player].place:sub(7))
				local owner = player
				if house_ == 12 then
					owner = 'Oliver'
					if players[player].job ~= 'farmer' then
						return
					end
				end
				if table.contains(players[owner].houseTerrain, 2) then
					local idx = tonumber(players[owner].houseData.houseid)
					local yy = 1500 + 90
					for i, v in next, players[owner].houseTerrain do
						if v == 2 then
							if math.hypo(((idx-1)%idx)*1500+737 + (i-1)*175, yy+170, x, y) <= 90 then
								if players[owner].houseTerrainAdd[i] > 1 then
									for ii, vv in next, room.gardens do
										if vv.owner == owner then
											if vv.terrain == i then
												vv.timer = vv.timer - 60*6*1000
												local sidequest = sideQuests[players[player].sideQuests[1]].type
												if string.find(sidequest, 'type:fertilize') then
													if string.find(sidequest, 'oliver') and owner == 'Oliver' then
														sideQuest_update(player, 1)
													elseif not string.find(sidequest, 'oliver') then
														sideQuest_update(player, 1)
													end
												end
												return true
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end,
		npcShop = 'marcus',
	},
	cookies = {
		id = 38,
		price = 0,
		png = '17157d3d7b0.png',
		type = 'food',
	},
	sugar = {
		id = 39,
		price = 3,
		png = '16f0571d9f9.png',
		type = 'food',
	},
	chocolate = {
		id = 40,
		price = 30,
		png = '16f05a12ea3.png',
		type = 'food',
		power = 6,
		hunger = 2,
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
		price = 300,
		qpPrice = 4,
		png = '16f23b75123.png',
		holdingImages = {'16f23b75123.png', '16f23b75123.png'}, -- left, right
		holdingAlign = {{-35, -15}, {-15, -15}}, -- left, right
		type = 'holdingItem',
		type2 = 'limited-christmas2019',
		limitedTime = os.time{day=15, year=2020, month=1},
		func = function(player)
			players[player].holdingItem = 'blueberriesSeed'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
	},
	cheese = {
		id = 43,
		price = 100,
		type = 'item',
		png = '170b6b4db9c.png',
		func = function(i)
			local oldPositions = {ROOM.playerList[i].x, ROOM.playerList[i].y}
			TFM.giveCheese(i)
			TFM.giveCheese(i)
			TFM.giveCheese(i)
			TFM.playerVictory(i)
			TFM.respawnPlayer(i)
			if players[i].isBlind then setNightMode(i) end
			if players[i].isFrozen then freezePlayer(i, true) end
			TFM.movePlayer(i, oldPositions[1], oldPositions[2], false)
		end
	},
	fish_SmoltFry = {
		id = 44,
		price = 15,
		type = 'food',
		png = '170b7040298.png',
		power = -10,
		hunger = -10,
	},
	fish_Lionfish = {
		id = 45,
		price = 300,
		type = 'food',
		png = '170b733380f.png',
		power = -10,
		hunger = -10,
	},
	fish_Dogfish = {
		id = 46,
		price = 300,
		type = 'food',
		png = '170b778a98b.png',
		power = -10,
		hunger = -10,
	},
	fish_Catfish = {
		id = 47,
		price = 300,
		type = 'food',
		png = '170b77a4f6d.png',
		power = -10,
		hunger = -10,
	},
	fish_RuntyGuppy = {
		id = 48,
		price = 50,
		type = 'food',
		png = '170b77ca0c7.png',
		power = -10,
		hunger = -10,
	},
	fish_Lobster = {
		id = 49,
		price = 1000,
		type = 'food',
		png = '170b788a90d.png',
		power = -20,
		hunger = -20,
	},
	fish_Goldenmare = {
		id = 50,
		price = 10000,
		type = 'food',
		png = '170b7904d24.png',
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
	},
	lemonade = {
		id = 52,
		price = 0,
		png = '17157d74289.png',
		type = 'food',
	},
	lobsterBisque = {
		id = 53,
		price = 0,
		png = '17157feb8ea.png',
		type = 'food',
	},
	bread = {
		id = 54,
		price = 0,
		png = '171577ce37b.png',
		type = 'food',
	},
	bruschetta = {
		id = 55,
		price = 0,
		png = '17157829bde.png',
		type = 'food',
	},
	waffles = {
		id = 56,
		price = 0,
		png = '171578aa546.png',
		type = 'food',
	},
	egg = {
		id = 57,
		price = 10,
		png = '171984833f2.png',
		type = 'food',
		power = 1,
		hunger = 1,
	},
	honey = {
		id = 58,
		price = 50,
		png = '17157936a24.png',
		type = 'food',
		power = 1,
		hunger = 3,
	},
	grilledLobster = {
		id = 59,
		price = 0,
		png = '17157dd5e6a.png',
		type = 'food',
	},
	frogSandwich = {
		id = 60,
		price = 0,
		png = '17157f6d781.png',
		type = 'food',
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
		png = '17198461537.png',
		type = 'food',
		hunger = .1,
	},
	pierogies = {
		id = 65,	
		price = 20,
		png = '1715af36d28.png',
		type = 'food',
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
	},
	garlicBread = {
		id = 69,	
		price = 20,
		png = '1715f2f672e.png',
		type = 'food',
	},
	garlic = {
		id = 70,	
		price = 20,
		png = '1745fc72f96.png',
		type = 'food',
		power = 4,
		hunger = 1,
	},
	blueprint = {
		id = 71,
		price = 200,
		type = 'holdingItem',
		png = '171af19adb5.png',
	},
	crystal_yellow = {
		id = 72,
		type = 'crystal',
		png = '172373f61f1.png',
		jobStatID = 12,
	},
	crystal_blue = {
		id = 73,
		type = 'crystal',
		png = '172373eddec.png',
		jobStatID = 13,
	},
	crystal_purple = {
		id = 74,
		type = 'crystal',
		png = '172373f2060.png',
		jobStatID = 14,
	},
	crystal_green = {
		id = 75,
		type = 'crystal',
		png = '172373f009d.png',
		jobStatID = 15,
	},
	crystal_red = {
		id = 76,
		type = 'crystal',
		png = '172373f3f04.png',
		jobStatID = 16,
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
		price = 2,
		type = 'holdingItem',
		png = '1739ed5e5fc.png',
		holdingImages = {'1739ed5e5fc.png', '1739ed5e5fc.png'}, -- left, right
		holdingAlign = {{-50, -20}, {0, -20}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'bananaSeed'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
	},
	moqueca = {
		id = 79,
		type = 'food',
		png = '1739f4c8a00.png',
	},
	grilledCheese = {
		id = 80,
		type = 'food',
		png = '173f8126cf7.png',
	},
	fishBurger = {
		id = 81,
		type = 'food',
		png = '173f814d309.png',
	},
	sushi = {
		id = 82,
		type = 'food',
		png = '173f81bb164.png',
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
	},
	meat = {
		id = 85,	
		price = 200,
		png = '1745f80713e.png',
		type = 'food',
		hunger = -10,
	},
	mushroom = {
		id = 86,
		png = '1745f93d2df.png',
		type = 'food',
		price = 200,
		energy = 9,
		hunger = 4,
	},
	cheeseburger = {
		id = 87,	
		png = '1745f8487c1.png',
		type = 'food',
	},
	lasagna = {
		id = 88,	
		png = '1745f84a7f0.png',
		type = 'food',
	},
	meatballs = {
		id = 89,	
		png = '1745f8ed295.png',
		type = 'food',
	},
	garlicMashedPotatoes = {
		id = 90,	
		png = '17479fb35b3.png',
		type = 'food',
	},
	mushroomBurger = {
		id = 91,	
		png = '1745f96c2ba.png',
		type = 'food',
	},
	creamOfMushroom = {
		id = 92,	
		png = '1745f9a16e2.png',
		type = 'food',
	},
	pumpkinPie = {
		id = 93,	
		png = '1747006faae.png',
		type = 'food',
	},
	steakFrites = {
		id = 94,	
		png = '1747006cf6d.png',
		type = 'food',
	},
	breadedCutlet = {
		id = 95,	
		png = '1747006a7b5.png',
		type = 'food',
	},
	fishAndChips = {
		id = 96,	
		png = '174700680f4.png',
		type = 'food',
	},
}