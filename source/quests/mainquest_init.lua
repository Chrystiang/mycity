local _QuestSteps = {
	[3] = {
		[ 0] = "goToPolice",
		[ 1] = nil,
		[ 2] = "goToBank",
		[ 3] = nil,
		[ 4] = "goToPolice",
		[ 5] = nil,
		[ 6] = "goToBankRob",
		[ 7] = nil,
		[ 8] = "goToPolice",
		[ 9] = nil,
		[10] = nil,
		[11] = "goToHospital",
		[12] = nil,
		[13] = "goToMine",
		[14] = nil,
		[15] = "goToPolice",
	},
	[4] = {
		[ 0] = nil,
	    [ 1] = "goToIsland",
	    [ 2] = "goToSeedStore",
	    [ 3] = "BUY_seed",
	    [ 4] = "goToHouse",
	    [ 5] = "plant_seed",
	    [ 6] = "harvestTomato",
	    [ 7] = "goToSeedStore",
	    [ 8] = "BUY_water",
	    [ 9] = "goToMarket",
	    [10] = "BUY_salt",
	    [11] = "cookSauce",
	    [12] = nil,
	    [13] = "plant_seed",
	    [14] = "harvestPepper",
	    [15] = "cookHotSauce",
	    [16] = nil,
	    [17] = "plant_seed",
	    [18] = "harvestWheat",
	},
	[5] = {
	    [ 0] = "goToIsland",
	    [ 1] = "goToRestaurant",
	    [ 2] = nil,
	    [ 3] = "cookBread",
	    [ 4] = "cookSalad",
	    [ 5] = "cookChocolateCake",
	    [ 6] = "cookfrogSandwich",
	    [ 7] = "cookfrenchFries",
	    [ 8] = "cookPudding",
	    [ 9] = "cookGarlicBread",
	    [10] = "cookMoqueca",
	    [11] = "cookGrilledCheese",
	    [12] = "cookfishBurger",
	    [13] = "cookBruschetta",
	    [14] = "cookLemonade",
	    [15] = "cookPierogies",
	    [16] = nil,
	},
}

_QuestControlCenter = {
	[1] = {
		npcs = {'Kane$', 'Chrystian$'},
		active = function(player, questStep)
			local playerData = players[player]

			gameNpcs.addCharacter('Kane$', {'1719ea4bbdf.png', '1719ea24347.png'}, player, 5900, 7677, {questNPC = true})
			if questStep == 1 then 
				playerData.questLocalData.other['fish_'] = 5
			elseif questStep == 3 then 
				players[player].questLocalData.other['BUY_energymax_blue'] = 3 - (checkItemAmount('energymax_blue', 1, player) and checkItemAmount('energymax_blue', 1, player) or 0)
			elseif questStep == 4 then 
				removeBagItem('energymax_blue', 3, player)
			elseif questStep >= 5 and questStep <= 7 then
				gameNpcs.addCharacter('Chrystian$', {'171a318e6ca.png', '171a310fffa.png'}, player, 2600, 7680, {questNPC = true})
				if questStep == 6 then 
					playerData.questLocalData.other['BUY_cornflakes'] = true
				end
			end
		end, 
		reward = function(player)
			local playerData = players[player]
			playerData.cars[#playerData.cars+1] = 5
		end
	},
	[2] = {
		npcs = {'Indy$'},
		active = function(player, questStep)
			local playerData = players[player]

			gameNpcs.addCharacter('Indy$', {'171945ff967.png', '171a3de6a6d.png'}, player, 9800, 7677, {questNPC = true})
			if questStep == 0 then 
				playerData.questLocalData.other['goToIsland'] = true
			elseif questStep == 2 or questStep == 5 then 
				players[player].questLocalData.other['goToMine'] = true
			elseif questStep == 3 then 
				addQuestAsset(player, '_key')
				players[player].questLocalData.other['findKeys'] = true
			elseif questStep == 6 then 
				addQuestAsset(player, '_key2')
				players[player].questLocalData.other['findKeys'] = true
			end
		end
	},
	[3] = {
		npcs = {'Sherlock$', 'Colt$', 'Indy$', 'Robber$'},
		active = function(player, questStep)
			local playerData = players[player]
			local localData = _QuestSteps[3]
			
			if questStep == 1 then 
				gameNpcs.addCharacter('Sherlock$', {}, player, 0, 0, {questNPC = true})
			elseif questStep == 3 then 
				gameNpcs.addCharacter('Colt$', {}, player, 0, 0, {questNPC = true})
			elseif questStep == 5 then 
				gameNpcs.addCharacter('Sherlock$', {}, player, 0, 0, {questNPC = true})
			elseif questStep == 7 then 
				addQuestAsset(player, '_cloth')
			elseif questStep == 9 then 
				gameNpcs.addCharacter('Sherlock$', {}, player, 0, 0, {questNPC = true})
			elseif questStep == 10 then 
				gameNpcs.addCharacter('Indy$', {}, player, 0, 0, {questNPC = true})
			elseif questStep == 12 then
				addQuestAsset(player, '_paper')
			elseif questStep == 14 then
				gameNpcs.addCharacter('Robber$', {'171a4cfc218.png'}, player, 1880, 8480, {questNPC = true})
				playerData.questLocalData.other['arrestRobber'] = true
			elseif questStep == 16 then 
				gameNpcs.addCharacter('Sherlock$', {}, player, 0, 0, {questNPC = true})
			elseif localData[questStep] then
			    playerData.questLocalData.other[localData[questStep]] = true
			end
		end
	},
	[4] = {
		npcs = {'Kariina$'},
		active = function(player, questStep)
			local playerData = players[player]
			local localData = _QuestSteps[4]

			gameNpcs.addCharacter('Kariina$', {'17193fda8a1.png', '171a8679a0c.png'}, player, 4360, 7677, {questNPC = true})

			if localData[questStep] then
			    playerData.questLocalData.other[localData[questStep]] = true
			end
		end
	},
	[5] = {
		npcs = {'Remi$'},
		active = function(player, questStep)
			local playerData = players[player]
			local localData = _QuestSteps[5]

			if questStep == 2 or questStep == 16 or questStep == 18 then 
				gameNpcs.addCharacter('Remi$', {}, player, 0, 0, {questNPC = true})
			elseif questStep == 17 then
				if not players[player].questStep[3] then
					players[player].questStep[3] = 20
				end
				players[player].questLocalData.other['deliverOrder'] = players[player].questStep[3]
			elseif localData[questStep] then
			    playerData.questLocalData.other[localData[questStep]] = true
			end
		end,
		reward = function(player)
			if not checkIfPlayerHasFurniture(player, 64) then
				players[player].houseData.furnitures.stored[64] = {quanty = 1, type = 64}
			end
		end
	},

	[99] = {
		npcs = {'Bill$', 'Oliver$'},
		active = function(player, questStep)
			local playerData = players[player]

			gameNpcs.addCharacter('Bill$', {'171b7b0d0a2.png', '171b81a2307.png'}, player, 13400, 7514, {questNPC = true})

			if questStep == 0 then
				playerData.questLocalData.other['goToIsland'] = true
			elseif questStep == 1 then 
				playerData.questLocalData.other['goToOliver'] = true
			elseif questStep == 2 then 
				gameNpcs.addCharacter('Oliver$', {}, player, 0, 0, {questNPC = true})
			elseif questStep == 4 then
				playerData.questLocalData.other['goToSeedStore'] = true
			elseif questStep == 5 then 
				playerData.questLocalData.other['BUY_seed'] = true
			elseif questStep == 6 then 
				playerData.questLocalData.other['goToHouse'] = true
			elseif questStep == 7 then 
				playerData.questLocalData.other['plant_lemonSeed'] = true
			elseif questStep == 8 then 
				playerData.questLocalData.other['harvestLemon'] = true
			elseif questStep == 9 then 
				playerData.questLocalData.other['ItemAmount_lemon'] = 10 - (checkItemAmount('lemon', 1, player) and checkItemAmount('lemon', 1, player) or 0)
			elseif questStep == 11 then 
				playerData.questLocalData.other['ItemAmount_tomato'] = 10 - (checkItemAmount('tomato', 1, player) and checkItemAmount('tomato', 1, player) or 0)
			elseif questStep == 13 then 
				gameNpcs.addCharacter('Indy$', {}, player, 0, 0, {questNPC = true})
			end
		end
	},

	[100] = {
		npcs = {'Ada$'},
		active = function(player, questStep)
			local playerData = players[player]

			gameNpcs.addCharacter('Ada$', {'171aea88c54.png', '171ae9be4af.png'}, player, 2070, 7677, {questNPC = true})
			if questStep == 1 then 
				playerData.questLocalData.other['BUY_water'] = 5
			elseif questStep == 3 then 
				playerData.questLocalData.other['BUY_cook_milkshake'] = true
			elseif questStep == 5 then 
				playerData.questLocalData.other['fish_blueprint'] = true
			end
		end
	},
}