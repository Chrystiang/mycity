eventNewPlayer = function(player)
	ui.setMapName('Mycity')
	TFM.setPlayerScore(player, 0)
	ui.addTextArea(8500, '', player, 805, -200, 15000, 1000, 0x6a7595, 0x6a7595, 1, true)
	ui.addTextArea(8501, '', player, -15005, -200, 15000, 1000, 0x6a7595, 0x6a7595, 1, true)
	ui.addTextArea(8502, '', player, -100, -1000, 1000, 1000, 0x6a7595, 0x6a7595, 1, true)
	ui.addTextArea(8503, '', player, -100, 600, 1000, 1000, 0x6a7595, 0x6a7595, 1, true)
	local playerLanguage = ROOM.playerList[player] and lang[ROOM.playerList[player].community] and ROOM.playerList[player].community or 'en'
	if room.isInLobby then
		addImage("16d888d9074.jpg", "?1", 0, 0, player)
		addImage("16d88917a35.png", "!1", 0, 0, player)
		addImage("16d84d2ead7.png", "!1", 620, 315, player)
		players[player] = {
			lang = playerLanguage,
			settings = {mirroredMode = 0, language = playerLanguage},
		}
		TFM.respawnPlayer(player)
		return
	end

	ui.removeTextArea(0, player)
	TFM.changePlayerSize(player, 1)
	TFM.lowerSyncDelay(player)
	setPlayerData(player)
	
	for i = 1, #imgsToLoad do
		local pngLoad = addImage(imgsToLoad[i], "!0", 0, 0, player)
		removeImage(pngLoad)
	end
	if not table.contains(room.bannedPlayers, player) then
		TFM.respawnPlayer(player)
	end
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
		addImage("1708d053178.png", '?9', 2050, 1600+room.y, player)
	-- PLACE: Bank
		addImage("16b947781b3.png", "?10", 2700, 7487, player)
	-- Ranking 
		addImage("17118e74fb1.png", "?11", 3710, 7480, player)
		addImage('17118ee6159.jpg', '?12', 3807, 7535, player)
		addImage('17118f3c5fd.jpg', '?13', 3807, 7560, player)
		for i = 1, 7 do 
			addImage("1711921401a.png", "?14", 3669 + (i-1)*93, 7725, player)
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
		addImage("16f1b804909.png", '?108', 4000, 3400, player)
	-- PLACE: CAFÉ (INSIDE)
		addImage("16bdefba853.png", "?109", 6000, 33, player)
		addImage("16bdf046e52.png", "!103", 6000, 33, player)
	-- PLACE: POTION SHOP (INSIDE)
		addImage("1709756104e.png", '?110', 10500, 30, player)
	-- PLACE: BANK (INSIDE)
		addImage("16bb8f88e17.png", "?111", 5000, 4555, player)
		addImage("16baf00d3da.png", "?112", 5791, 4596, player)
		addImage("16bb495d6f9.png", "?113", 5275, 4973, player)
		for i = 1, 5 do
			addImage("16ba53983a1.jpg", "?114", (i-1)*55 + 5705, 5150, player)
			ui.addTextArea(-500+i, '<a href="event:enterCode">'..string.rep('\n', 10), player, (i-1)*55 + 5705, 5150, 50, 100, 1, 1, 0)
			addImage("16be83d875e.png", "_699", (i-1)*200 + 8800, 126+25, player)
			-- Trees
			addImage('170c16e6f4e.png', '?1', (i-1)*3300 - 100, -100, player)
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
	addImage("16d9986258c.png", '_81', 15550, 1625, player)
	addImage("16d99863ceb.png", '!82', 15495, 1622, player)
	addImage("16db23673c6.png", '_83', 15100, 1208, player)

	gameNpcs.addCharacter('Kapo', {'17193b948a7.png', '17185214c3c.png'}, player, 11750, 7677)
	gameNpcs.addCharacter('Santih', {'17193ec241f.png', '1718deb8f6f.png'}, player, 10630, 7677)
	gameNpcs.addCharacter('Louis', {'1719408559d.png', '1718e133635.png'}, player, 14150, 139, {type = '?'})
	gameNpcs.addCharacter('*Souris', {'1719408754d.png', '1718e2f4445.png'}, player, 14620, 139, {type = '?'})
	gameNpcs.addCharacter('Rupe', {'1719455ee6d.png', '17193000220.png'}, player, 780, 8509, {job = 'miner'})
	gameNpcs.addCharacter('Heinrich', {'1719454397f.png', '171930c5cda.png'}, player, 670, 8509, {job = 'miner', endEvent = function(name) job_invite('miner', name) end})
	gameNpcs.addCharacter('Paulo', {'1719452167a.png', '17193169110.png'}, player, 590, 8509, {job = 'miner'})
	gameNpcs.addCharacter('Goldie', {'17193b5b818.png', '172a0261c76.png'}, player, 540, 8092, {job = 'miner'})
	gameNpcs.addCharacter('Dave', {'17193cb4903.png'}, player, 11670, 7677, {job = 'farmer', callback = function(name) modernUI.new(name, 240, 220, translate('daveOffers', player)):build():tradeInterface() end})
	gameNpcs.addCharacter('Marcus', {'17193d8cabe.png'}, player, 15280, 1468, {job = 'farmer', sellingItems = true})
	gameNpcs.addCharacter('Body', {'17193e274cd.png'}, player, 11880, 153, {color = '20B2AA', sellingItems = true})
	gameNpcs.addCharacter('Kariina', {'17193fda8a1.png'}, player, 14850, 153, {color = '20B2AA', sellingItems = true})
	gameNpcs.addCharacter('Chrystian', {'171940da6ee.png'}, player, 16820, 153, {color = '20B2AA', sellingItems = true})
	gameNpcs.addCharacter('Patric', {'17194118fa0.png'}, player, 13050, 153, {job = 'fisher', jobConfirm = true})
	gameNpcs.addCharacter('Sherlock', {'171941d5222.png', '171a4910f9f.png'}, player, 7180, 5997, {job = 'police', jobConfirm = true})
	gameNpcs.addCharacter('Oliver', {'171945c8816.png', '171b7af8508.png'}, player, 15620, 1618, {job = 'farmer', jobConfirm = true})
	gameNpcs.addCharacter('Indy', {'171945ff967.png', '171a3de6a6d.png'}, player, 10820, 153, {color = '20B2AA', sellingItems = true})
	gameNpcs.addCharacter('Davi', {'171989750b8.png', '17198988913.png'}, player, 13070, 7513)
	gameNpcs.addCharacter('Pablo', {'17198a9903d.png', '1729ff740fd.png'}, player, 5090, 153, {job = 'thief', endEvent = function(name) job_invite('thief', name) end})
	gameNpcs.addCharacter('Derek', {'17198af24b4.png', '1729ff71a42.png'}, player, 5000, 153, {job = 'thief'})
	gameNpcs.addCharacter('Billy', {'17198b0df10.png', '1729ff6f7d2.png'}, player, 4955, 153, {job = 'thief'})
	gameNpcs.addCharacter('Lauren', {'17198c1b7b5.png', '17198c3bd45.png'}, player, 14337, 139, {type = '?', canRob = {cooldown = 100}})
	gameNpcs.addCharacter('Marie', {'17198c6b4ee.png', '17198c8206f.png'}, player, 14440, 139, {type = '?'})
	gameNpcs.addCharacter('Natasha', {'171995781e5.png', '171eb2e9c92.png'}, player, 3775, 125, {type = '_', canRob = {cooldown = 100}})
	gameNpcs.addCharacter('Cassy', {'171995ccbe9.png', '171eb2e7ae6.png'}, player, 3650, 125, {type = '_', canRob = {cooldown = 100}})
	gameNpcs.addCharacter('Julie', {'171995ecdee.png', '171eb2eb8df.png'}, player, 3900, 125, {type = '_', canRob = {cooldown = 100}})
	gameNpcs.addCharacter('Jason', {'17199cb7d8b.png', '1729ffd4116.png'}, player, 400, 153, {canRob = {cooldown = 100}})
	gameNpcs.addCharacter('Alicia', {'17199d3b9b2.png', '172a027ee8c.png'}, player, 6800, 153, {canRob = {cooldown = 130}})
	gameNpcs.addCharacter('Colt', {'1719dc3bce6.png', '171a4adc2e1.png'}, player, 5250, 5147, {job = 'police'})
	gameNpcs.addCharacter('Alexa', {'171ae65bf52.png', '171ae65d8a1.png'}, player, 7740, 5997, {job = 'police'})
	gameNpcs.addCharacter('Sebastian', {'171a497f4e2.png', '171a4adc2e1.png'}, player, 7195, 5852, {job = 'police'})
	gameNpcs.addCharacter('Paul', {'171ae7460aa.png', '171ae74916a.png'}, player, 7650, 5997, {job = 'police'})
	gameNpcs.addCharacter('John', {'1723790df64.png', '172379248f7.png'}, player, 4370, 8547, {job = 'miner', sellingItems = true})
	gameNpcs.addCharacter('Blank', {'17275e43fe4.png', '17275e2a2f4.png'}, player, 1140, 9314, {endEvent = 
		function(name) 
			if checkItemQuanty('luckyFlower', 1, name) and checkItemQuanty('fish_Goldenmare', 1, name) then 
				removeBagItem('luckyFlower', 1, name)
				removeBagItem('fish_Goldenmare', 1, name)
				room.boatShop2ndFloor = true 
				removeGround(7777777777) 
				for name in next, ROOM.playerList do 
					showBoatShop(name, 1) 
				end
			end
		end})
	gameNpcs.addCharacter('Remi', {'1727bfa1d1a.png', '1727bf9fc49.png'}, player, 14350, 1618, {job = 'chef', jobConfirm = true})
	gameNpcs.addCharacter('Lucas', {'1727c604ce6.png'}, player, 14560, 1618, {job = 'chef', sellingItems = true})
	gameNpcs.addCharacter('Weth', {'172a03553a1.png', '172a0351254.png'}, player, 13995, 1597, {type = '_', canRob = {cooldown = 100}})
	gameNpcs.addCharacter('Ana', {'172ab8366bb.png'}, player, 14170, 1597, {type = '_', blockClick = true})
	gameNpcs.addCharacter('Gui', {'172ab830075.png'}, player, 14100, 1597, {type = '_', blockClick = true})
	gameNpcs.addCharacter('Gabe', {'172ab834050.png'}, player, 14205, 1597, {type = '_', blockClick = true})
	gameNpcs.addCharacter('Luan', {'172ab8a9ff7.png'}, player, 13955, 1597, {type = '_', blockClick = true})
	gameNpcs.addCharacter('Bruna', {'172af626b89.png'}, player, 13890, 1597, {type = '_', blockClick = true})
	gameNpcs.addCharacter('Bill', {'171b7b0d0a2.png', '171b81a2307.png'}, player, 12800, 153, {job = 'fisher', formatDialog = 'fishingLuckiness'})
	gameNpcs.addCharacter('Mrsbritt87', {'172b9645b79.png', '172b98d0d52.png'}, player, 9400, 7645, {type = '_', donator = true})

	if room.dayCounter > 0 then 
		room.bank.paperImages[#room.bank.paperImages+1] = addImage('16bbf3aa649.png', '!1', room.bank.paperPlaces[room.bank.paperCurrentPlace].x, room.bank.paperPlaces[room.bank.paperCurrentPlace].y, player)
		ui.addTextArea(-3333, '<a href="event:getVaultPassword">'..string.rep('\n', 10), player, room.bank.paperPlaces[room.bank.paperCurrentPlace].x, room.bank.paperPlaces[room.bank.paperCurrentPlace].y, 20, 20, 0, 0, 0)
	end
	for _, key in next, {0, 1, 2, 3, 32, 70, 71} do 
		system.bindKeyboard(player, key, true) 
		system.bindKeyboard(player, key, false, true) 
	end
	for block, active in next, Mine.availableRocks do 
		if active then
			mine_reloadBlock(block, player)
		end 
	end
	if player:find('*') then
		ui.addTextArea(54215, '', player, -5, -10, 850, 500, 1, 1, 1, true)
	end
	ui.addTextArea(4444440, string.rep('\n', 5), player, 14455, 1668, 90, 45, 1, 1, 0, false, 
		function()
			eventTextAreaCallback(0, player, 'recipes', true)
		end)
	ui.addTextArea(20880, '', player, 0, 0, 800, 400, 0x152d30, 0x152d30, 0.7, true)
	sendMenu(99, player, '<p align="center"><font size="16"><vp>v'..table.concat(version, '.')..'</vp> - '.. translate('$VersionName', player) ..'</font>', 400 - 620 *0.5, 200 - 320*0.5, 600, 300, 1, false, 1, false, false, false, 15)

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