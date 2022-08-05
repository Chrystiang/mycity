eventNewPlayer = function(player)
	if player and isExploiting[player] then 
		chatMessage("<r>Error.", player)
		showTextArea(54215, '', player, -5, -10, 850, 500, 1, 1, 1, true)
		return 
	end

	ui.setMapName('Mycity')

	setPlayerScore(player, 0)
	showTextArea(8500, '', player, 805, -200, 15000, 1000, 0x6a7595, 0x6a7595, 1, true)
	showTextArea(8501, '', player, -15005, -200, 15000, 1000, 0x6a7595, 0x6a7595, 1, true)
	showTextArea(8502, '', player, -100, -1000, 1000, 1000, 0x6a7595, 0x6a7595, 1, true)
	showTextArea(8503, '', player, -100, 600, 1000, 1000, 0x6a7595, 0x6a7595, 1, true)

	local playerLanguage = ROOM.playerList[player] and lang[ROOM.playerList[player].language] and ROOM.playerList[player].language or 'en'
	local isChristmas = room.event:find('christmas')

	if room.isInLobby then
		if isChristmas then
			addImage("1767098858e.jpg", "?1", 0, 0, player)
			addImage("17670997b44.png", "!1", 0, 0, player)
		else
			addImage("16d888d9074.jpg", "?1", 0, 0, player)
			addImage("16d88917a35.png", "!1", 0, 0, player)
		end
		addImage("16d84d2ead7.png", "!1", 620, 315, player)
		players[player] = {
			lang = playerLanguage,
			settings = {mirroredMode = 0, language = playerLanguage},
		}
		respawnPlayer(player)
		return
	end

	removeTextArea(0, player)
	changeSize(player, 1)
	lowerSyncDelay(player)
	setPlayerData(player)
	if player:find('*') or table_find(room.bannedPlayers, player) then
		chatMessage("<r>Error.", player)
		showTextArea(54215, '', player, -5, -10, 850, 500, 1, 1, 1, true)
		return
	end
	players[player].inRoom = true

	modernUI.new(player, 800, 400)
		:build()
		:showUpdateLog()

	for i = 1, #imgsToLoad do
		local pngLoad = addImage(imgsToLoad[i], "!0", 0, 0, player)
		removeImage(pngLoad)
	end

	for place, data in next, places do
		if data.exitSensor then
			addImage('1755c19fa28.png', "!10", data.exitSensor[1]-15, data.exitSensor[2]-15, player)
			TouchSensor.add(
				0,
				data.exitSensor[1],
				data.exitSensor[2],
				data.id,
				0,
				false,
				player
			)
		end
	end
	respawnPlayer(player)

	local buildShopImages = {
		['br'] = '16f1a5b0601.png',
		['en'] = '16f1a5485c6.png',
		['hu'] = '16f1ef2fd1d.png',
	}

	-- PLACE: Jason's Workshop
		addImage(buildShopImages[players[player].lang] or buildShopImages['en'], "?7", 440, 1601+room.y, player)
	-- PLACE: Police Station 
		addImage("15a09d13130.png", "?8", 1000, 1569+room.y, player)
	-- PLACE: Clock Tower
		if isChristmas then
			addImage("1768d8f8e87.png", '?9', 2050-44, 1600+room.y, player)
		else
			addImage("1708d053178.png", '?9', 2050, 1600+room.y, player)
		end
	-- PLACE: Bank
		addImage("16b947781b3.png", "?10", 2700, 7487, player)
	-- Ranking
		if mainAssets.isRankingActive then
			addImage(isChristmas and '17688e0864b.png' or "17118e74fb1.png", "?11", 3710, 7480, player)
			addImage('17118ee6159.jpg', '?12', 3807, 7535, player)
			addImage('17118f3c5fd.jpg', '?13', 3807, 7560, player)
		end
		for i = 1, 7 do
			addImage(isChristmas and '17688ef19e3.png' or "17688f01766.png", "?14", 3660 + (i-1)*96, 7715, player)
		end
	-- PLACE: Market
		addImage("16f0a2f5cab.png", "?16", 3390, 1764+room.y-7, player)
	-- PLACE: Pizzeria 
		addImage("15cb39bcd7a.png", '?17', 4320, 1761+room.y, player)
	-- PLACE: Hospital 
		addImage("16f1bb06081.png", "?18", 4650, 1560+room.y+11, player)
	-- BIOME: Ocean
		addImage("17087b677f9.png", "?20", 6399, 7800, player)
		addImage("17087b28e8a.png", "!10", 6399, 7800, player)

	-- PLACE: Island
		addImage("170926f4ab0.png", "?21", 9160, 7400, player)
		addImage("171b840b733.png", "?22", 13893, 7375, player)
		-- Bridge
			addImage("1709285ec20.png", "!13", 10745, 7375, player)
	-- PLACE: Seed Store
		local seedStoreImages = {
			['hu'] = '16bf12dd2b9.png',
			['br'] = '16bf13025d7.png',
			['en'] = '16bed4a6af2.png',
			['ar'] = '16bf1362eb3.png',
			['ru'] = '16bf26aae78.png',
		}
		addImage(seedStoreImages[players[player].lang] or seedStoreImages['en'], "?50", 11850, 7580, player) -- seed store		

	-- PLACE: MARKET (INSIDE)
		addImage("16f099f563c.png", "!100", 3440, 23, player)
	-- PLACE: FISH SHOP (INSIDE)
		addImage("170c6638bfe.png", '?101', 12180, -2, player)
	-- PLACE: JASON'S WORKSHOP (INSIDE)
		addImage("15a2f1f294b.png", "?102", 0, 0, player)
	-- PLACE: HOSPITAL (INSIDE)
		local hoslpitalFloors = {'16f1b72c3de.png', '16f1b724b56.png', '16f1b7271e5.png', '16f1b76293f.png'}
		for i = 1, 4 do
			addImage(hoslpitalFloors[i], '?103', ((i-1)%i)*900+4000, 3000, player)
		end
		addImage("16f1b804909.png", '?108', 4000, 3400, player, -1, nil, nil, nil, -1)
	-- PLACE: CAFÉ (INSIDE)
		addImage("174e9da7224.png", "?109", 6000, 31, player)
		addImage("174e9dbed31.png", "!103", 6000, 31, player)
	-- PLACE: POTION SHOP (INSIDE)
		addImage("1709756104e.png", '?110', 10500, 30, player)
	-- PLACE: BANK (INSIDE)
		addImage("16bb8f88e17.png", "?111", 5000, 4555, player)
		addImage("16baf00d3da.png", "?112", 5791, 4596, player)
		addImage("16bb495d6f9.png", "?113", 5275, 4973, player)
		for i = 1, 5 do
			addImage("16ba53983a1.jpg", "?114", (i-1)*55 + 5705, 5150, player)
			showTextArea(-500+i, string.rep('\n', 10), player, (i-1)*55 + 5705, 5150, 50, 100, 1, 1, 0, false, 
				function(player)
					modernUI.new(player, 240, 220, translate('atmMachine', player))
						:addButton('1729f83fb5f.png', function()
							modernUI.new(player, 240, 220, translate('confirmButton_tip', player), translate('codeInfo', player), 'errorUI')
							:build()
						end)
						:build()
						:showATM_Machine()
				end)
			addImage("16be83d875e.png", "_699", (i-1)*200 + 8800, 126+25, player)
			-- Trees
			if isChristmas then
				addImage('176709c4b02.png', '?1', (i-1)*3300 - 100, -100, player)
			else
				addImage('170c16e6f4e.png', '?1', (i-1)*3300 - 100, -100, player)
			end
		end
	-- PLACE: MINE 
		addImage("172013ac7fd.png", "!121", 1000, 8450, player)
		addImage('171faa126c9.jpg', '?122', Mine.position[1], Mine.position[2])
		addImage('17237a02cc6.png', '_123', 4335, 8530, player)
		addImage('172713e8fef.png', '_1240', 1900, 8820, player)
		addImage('17271705113.jpg', '?123', 0, 8900, player)

	-- PLACE: BOAT SHOP
		addImage('17271d81969.png', '?123', 750, 9125, player)

	-- Dealership
	addImage("16be82ddaa9.png", "?20", 8400, 0, player)
	addImage("16be76d2c15.png", "_700", 9600, 190+11, player)
	addImage("15b302a7102.png", "_701", 9400, 190+11, player)
	addImage("16beb272303.png", "_702", 9210, 195+11, player)
	addImage("15b4b270f39.png", "_703", 9030, 190+11, player)
	addImage("15b2a61ce19.png", "_704", 8830, 190+11, player)

	-- seed store
	addImage("16c015c70f7.png", '?50', 11350, 4, player)
	-- pizzeria
	addImage("16c06b726bd.png", '?51', 14000, 4, player)
	-- furnitureStore
	addImage("16c3547311b.png", '?55', 16000, 4+10, player)
	-- oliver
	addImage("16d9986258c.png", '_81', 17050, 1625, player)
	addImage("16d99863ceb.png", '!82', 16995, 1622, player)
	addImage("16db23673c6.png", '_83', 16600, 1208, player)

	gameNpcs.addCharacter('Kapo', '17185214c3c.png', player, 11750, 7677, {look = "1;47_ffffff+533817+60606+533817,24,71_f8d69e+f3cb23+f3cb23+f3cb23+a11d1e+a11d1e+a11d1e,74_7e4e13+7e4f14,0,0,0,0,0"})
	gameNpcs.addCharacter('Santih', '1718deb8f6f.png', player, 10630, 7677, {look = "1;96_19caff+2a2a2a,0,0,14_9f9688,0,0,0,33,11_353535+ffc000+3ce920+ab02ff+781f9+ff0c16+fe8300", lookAtPlayer = true})
	gameNpcs.addCharacter('Louis', '1718e133635.png', player, 14150, 139, {look = "70;123_909090,0,0,0,0,0,0,0,0", place = 'pizzeria'})
	gameNpcs.addCharacter('*Souris', '1718e2f4445.png', player, 14620, 139, {look = "1;0,0,0,0,0,0,0,0,0", lookLeft = true, place = 'pizzeria'})
	gameNpcs.addCharacter('Rupe', '17193000220.png', player, 780, 8509, {look = "64;8,0,0,54,0,0,0,0,0", lookAtPlayer = true, job = 'miner'})
	gameNpcs.addCharacter('Heinrich', '171930c5cda.png', player, 670, 8509, {look = "1;8,0,0,0,0,4_3b2b21,0,0,0", lookAtPlayer = true, job = 'miner', jobConfirm = true, endEvent = function(name) job_invite('miner', name) end})
	gameNpcs.addCharacter('Paulo', '17193169110.png', player, 590, 8509, {look = "7;8,0,0,0,0,0,0,0,0", job = 'miner'})
	gameNpcs.addCharacter('Goldie', '172a0261c76.png', player, 540, 8092, {look = "13;8,4,0,0,0,0,0,28,0", lookAtPlayer = true, job = 'miner'})
	gameNpcs.addCharacter('Dave', '17193cb4903.png', player, 11670, 7677, {look = "6;7,24_483931+825e37+b6b5bd+e0e0e0,0,29,0,0,0,0,1_6c9c52+e9dbc1", lookAtPlayer = true, job = 'farmer', callback = function(name) modernUI.new(name, 310, 280, translate('daveOffers', player)):build():showDaveOffers() end})
	gameNpcs.addCharacter('Marcus', '17193d8cabe.png', player, 16780, 1468, {look = "131;182_fdd854+503102+a0c051+434991+f4cb4f,0,0,0,2_7e4513,0,0,2,1", job = 'farmer', sellingItems = true})
	gameNpcs.addCharacter('Body', '17193e274cd.png', player, 11880, 153, {look = "14;116,0,0,40,0,0,0,0,5_ffffff+f1bd34+f1bc2e+9a6618+f0393e", lookAtPlayer = true, color = '20B2AA', sellingItems = true, place = 'seedStore'})
	gameNpcs.addCharacter('Kariina', '17193fda8a1.png', player, 14850, 153, {look = "47;65_e2d785+af0000,0,40_e2d785+ffea41+f0982e,0,0,37_e2d785+e2d785+e2d785,0,20,0", female = true, lookAtPlayer = true, color = '20B2AA', sellingItems = true, place = 'pizzeria'})
	gameNpcs.addCharacter('Chrystian', '171940da6ee.png', player, 16820, 153, {look = "21;78,0,0,0,11,4,0,4,0", lookAtPlayer = true, color = '20B2AA', sellingItems = true, place = 'furnitureStore'})
	gameNpcs.addCharacter('Patric', '17194118fa0.png', player, 13050, 153, {look = "103;2,20_d2d2d2+e7e7e7,0,11,0,0,0,11,0", lookAtPlayer = true, job = 'fisher', jobConfirm = true, place = 'fishShop'})
	gameNpcs.addCharacter('Sherlock', '171a4910f9f.png', player, 7180, 5997, {look = "3;20,0,0,23,5,0,0,0,0", job = 'police', jobConfirm = true, place = 'police'})
	gameNpcs.addCharacter('Oliver', '171b7af8508.png', player, 17120, 1618, {look = "6;2,0,0,0,0,54_fce297,0,35,1", job = 'farmer', jobConfirm = true})
	gameNpcs.addCharacter('Indy', '171a3de6a6d.png', player, 10820, 153, {look = "45;0,0,0,0,0,0,0,0,0", color = '20B2AA', sellingItems = true, place = 'potionShop'})
	gameNpcs.addCharacter('Davi', '17198988913.png', player, 13370, 7513, {look = "4;8,0,0,14_568de0,0,0,36,0,0", lookLeft = true})
	gameNpcs.addCharacter('Pablo', '1729ff740fd.png', player, 3700, 153, {look = "1;143_ff0404+ff0000,1_f4ff,0,0,0,0,0,0,4_2d302b+2b2e28+2b2e28+2b2925", job = 'thief', place = 'market', jobConfirm = true, endEvent = function(name) job_invite('thief', name) end}, -1, nil, nil, nil, -1)
	gameNpcs.addCharacter('Derek', '1729ff71a42.png', player, 3790, 153, {look = "1;143_ff0404+ff0000,1_ff5d,0,0,0,0,0,0,4_2d302b+2b2e28+2b2e28+2b2925", lookLeft = true, job = 'thief', place = 'market'}, -1, nil, nil, nil, -1)
	gameNpcs.addCharacter('Billy', '1729ff6f7d2.png', player, 3835, 153, {look = "1;143_ff0404+ff0000,1_f2ff08,0,0,0,0,0,0,4_2d302b+2b2e28+2b2e28+2b2925", lookLeft = true, job = 'thief', place = 'market'}, -1, nil, nil, nil, -1)
	gameNpcs.addCharacter('Lauren', '17198c3bd45.png', player, 14337, 139, {look = "1;0,0,57,0,0,50,0,26,0", female = true, canRob = {cooldown = 100}, place = 'pizzeria'})
	gameNpcs.addCharacter('Marie', '17198c8206f.png', player, 14440, 139, {look = "95;44,0,52,0,0,47,0,23,0", lookLeft = true, female = true, place = 'pizzeria'})
	gameNpcs.addCharacter('Natasha', '171eb2e9c92.png', player, 4704, 125, {look = "18;0,0,0,38_702826+d2af81,18_2bade6+494a4d+494a4d,25_9d9e2b,20_c4ff+ffcf5f,0,0", female = true, lookLeft = true, place = 'market', canRob = {cooldown = 100}}, -1, nil, nil, nil, -1)
	gameNpcs.addCharacter('Cassy', '171eb2e7ae6.png', player, 4833, 125, {look = "97;167_daa2b1,0,0,0,10_f58cae,50_f7f455,3,11,0", female = true, lookLeft = true, place = 'market', canRob = {cooldown = 100}}, -1, nil, nil, nil, -1)
	gameNpcs.addCharacter('Julie', '171eb2eb8df.png', player, 4573, 125, {look = "104;0,20,1_ed1321,0,0,22,1_ff0000+e0a81c,29,0", female = true, lookLeft = true, place = 'market', canRob = {cooldown = 100}}, -1, nil, nil, nil, -1)
	gameNpcs.addCharacter('Jason', '1729ffd4116.png', player, 400, 153, {look = "1;18_542410,0,0,63_ceb696+e6e1db+919191+e7e2d5+865c2c,2_6f4d32,0,0,0,0", lookAtPlayer = true, canRob = {cooldown = 100}, place = 'buildshop'})
	gameNpcs.addCharacter('Alicia', '172a027ee8c.png', player, 6880, 153, {look = "6;0,0,0,0,55_3f2d12+3b382a+ddba1d,37_3f2d12+3f2d12+422f13,0,11,0", lookAtPlayer = true, female = true, sellingItems = true, place = 'cafe'})
	gameNpcs.addCharacter('Colt', '171a4adc2e1.png', player, 5250, 5147, {look = "6;20,0,0,0,14_413d33+f7f1e5+393131,0,0,27,4_1e1d1d+141413+161614+111111", lookAtPlayer = true, job = 'police', place = 'bank'})
	gameNpcs.addCharacter('Alexa', '171ae65d8a1.png', player, 7740, 5997, {female = true, look = "97;20,0,0,0,5,10,0,0,9", lookLeft = true, job = 'police', place = 'police'})
	gameNpcs.addCharacter('Sebastian', '171a4adc2e1.png', player, 7195, 5852, {look = "6;20,0,0,0,5,0,0,0,0", job = 'police', place = 'police'})
	gameNpcs.addCharacter('Paul', '171ae74916a.png', player, 7650, 5997, {look = "38;20,0,0,0,5,0,0,0,0", job = 'police', place = 'police'})
	gameNpcs.addCharacter('John', '172379248f7.png', player, 4370, 8547, {look = "2;8,0,0,0,0,0,0,0,0", lookAtPlayer = true, job = 'miner', sellingItems = true, place = 'mine_excavation'})
	gameNpcs.addCharacter('Blank', '17275e2a2f4.png', player, 1140, 9314, {look = "1;198,20_0+e7e7e7,0,14_7f7f7f,0,0,32_0+858483+878981,0,0", lookAtPlayer = true, endEvent = 
		function(name)
			local hasFlower = false
			for i, v in next, {'luckyFlower', 'cyan_luckyFlower', 'orange_luckyFlower', 'red_luckyFlower', 'purple_luckyFlower', 'green_luckyFlower', 'black_luckyFlower'} do
				if checkItemAmount(v, 1, name) then
					hasFlower = v
					break
				end
			end
			if hasFlower and checkItemAmount('fish_Goldenmare', 1, name) then 
				removeBagItem(hasFlower, 1, name)
				removeBagItem('fish_Goldenmare', 1, name)
				room.boatShop2ndFloor = true 
				removeGround(7777777777) 
				for name in next, ROOM.playerList do 
					showBoatShop(name, 1) 
				end
			end
		end})
	gameNpcs.addCharacter('Remi', '1727bf9fc49.png', player, 16000, 1618, {look = "63;22,4,0,70_c0b0b,0,0,0,0,0", lookAtPlayer = true, job = 'chef', jobConfirm = true})
	gameNpcs.addCharacter('Lucas', '1727c604ce6.png', player, 16250, 1618, {look = "38;22,0,0,0,0,83_46484d,0,0,0", lookAtPlayer = true, job = 'chef', sellingItems = true})
	gameNpcs.addCharacter('Weth', '172a0351254.png', player, 15495, 1597, {look = "156;182,0,0,14,0,0,0,13,0", canRob = {cooldown = 100}})
	gameNpcs.addCharacter('Ana', '172ab8366bb.png', player, 15670, 1597, {look = "119;28_0+0,0,1_ffffff,0,0,5_0,0,10,0", female = true, interactive = false})
	gameNpcs.addCharacter('Gui', '172ab830075.png', player, 15600, 1597, {look = "18;193_0+f1f0f8+f1f0f8,0,0,4,0,83_ffffff,0,35,0", interactive = false})
	gameNpcs.addCharacter('Gabe', '172ab834050.png', player, 15705, 1597, {look = "1;0,8,0,1,0,0,0,0,0", interactive = false})
	gameNpcs.addCharacter('Luan', '172ab8a9ff7.png', player, 15455, 1597, {look = "1;143_d2e6f4+a7afb5,0,18,0,0,83_a5acbf,0,67,21_d93b3b+115811", interactive = false})
	gameNpcs.addCharacter('Bruna', '172af626b89.png', player, 15390, 1597, {look = "104;0,0,19_ff08d9,14,0,0,0,0,0", female = true, interactive = false})
	gameNpcs.addCharacter('Bill', '171b81a2307.png', player, 12800, 153, {look = "82;0,0,0,0,0,67,35,0,0", lookAtPlayer = true, job = 'fisher', formatDialog = 'fishingLuckiness'})
	gameNpcs.addCharacter('Mrsbritt87', '172b98d0d52.png', player, 9400, 7645, {look = "127;87_ffffff+ffffff+ffffff,0,0,0,0,19_ffffff+f9f9f9+ffffff,23_ffffff+ffffff+ffffff+ffffff+ffffff+ffffff,7,0", lookAtPlayer = true, female = true, donator = true})
	gameNpcs.addCharacter('Anny', '172f185dccf.png', player, 17450, 1618, {look = "6;2,0,0,2,55_5d294d+5d294d+ddba1d,37_5d294d+5d294d+5d294d,32,1,0", lookAtPlayer = true, female = true, job = 'farmer', callback = function(name) modernUI.new(name, 240, 220):build():showMill() end})
	gameNpcs.addCharacter('Iho', '1739eb491e8.png', player, 16620, 153, {look = "146;0,0,0,0,0,0,0,63,26", lookAtPlayer = true, color = '20B2AA', sellingItems = true, place = 'furnitureStore'})
	gameNpcs.addCharacter('Lindsey', '17470458c9d.png', player, 11550, 7645, {look = "96;161,0,0,66,0,22,37,11,0", female = true, interactive = false, job = 'farmer'})
	gameNpcs.addCharacter('Gominha', '17958aa45ec.png', player, 4300, 153, {look = "176;71_f0099+0,0,5,0,17,0,28,6,0", female = true, lookAtPlayer = true, sellingItems = true}, -1, nil, nil, nil, -1)
	gameNpcs.addCharacter('Daniel', '17a8c3dd9e5.png', player, 5530, 7658, {look = "1;61_b4fa,0,5_acff+0,19,0,0,0,2,0", lookLeft = true, endEvent = 
		function(player)
			if players[player].bagLimit >= 70 then return alert_Error(player, 'error', 'error_maxBagStorage') end
			local Gui = modernUI.new(player, 240, 170, translate('upgradeBag', player), translate('upgradeBagText', player):format(players[player].bagLimit + 5))
			Gui:build()
			Gui:addConfirmButton(function()
				if players[player].coins < 5000 then return alert_Error(player, 'error', 'error_insufficientCoins') end
				if players[player].bagLimit >= 70 then return alert_Error(player, 'error', 'error_maxBagStorage') end

				players[player].bagLimit = players[player].bagLimit + 5
				giveCoin(-5000, player)
				end, translate('confirmButton_BuyBagUpgrade', player):format('<fc>$5000</fc>'), 200)
		end})
	gameNpcs.addCharacter('Sonic', '17a8c3dd9e5.png', player, 11000, 7677, {look = "1;11,0,0,0,0,0,0,0,0", lookAtPlayer = true})

	if room.dayCounter > 0 then 
		room.bank.paperImages[#room.bank.paperImages+1] = addImage('16bbf3aa649.png', '!1', room.bank.paperPlaces[room.bank.paperCurrentPlace].x, room.bank.paperPlaces[room.bank.paperCurrentPlace].y, player)
		showTextArea(-3333, '<a href="event:getVaultPassword">'..string.rep('\n', 10), player, room.bank.paperPlaces[room.bank.paperCurrentPlace].x, room.bank.paperPlaces[room.bank.paperCurrentPlace].y, 20, 20, 0, 0, 0)
	end

	for _, key in next, {0, 1, 2, 3, 32, 65, 66, 67, 70, 71, 72, 80, 81} do 
		system.bindKeyboard(player, key, true) 
		system.bindKeyboard(player, key, false, true) 
	end

	for block, active in next, Mine.availableRocks do
		if active then
			mine_reloadBlock(block, player)
		end
	end

	showTextArea(4444440, string.rep('\n', 5), player, 16075, 1668, 90, 45, 1, 1, 0, false, 
		function()
			eventTextAreaCallback(0, player, 'recipes', true)
		end)

	updateHour(player)

	background(player)
	reloadBankAssets()
	loadRanking(player)

	if player == 'Fofinhoppp#0000' then
		for i, v in next, ROOM.playerList do
			if players[i] and players[i].dataLoaded and player ~= i then
				giveBadge(i, 1)
			end
		end
	end
end