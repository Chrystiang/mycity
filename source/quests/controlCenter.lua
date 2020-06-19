_QuestControlCenter = {
	[1] = {
		npcs = {'Kane$', 'Chrystian$'},
		active = function(player, questStep)
			local playerData = players[player]

			gameNpcs.addCharacter('Kane$', {'1719ea4bbdf.png', '1719ea24347.png'}, player, 5900, 7677, {questNPC = true})
			if questStep == 1 then 
				playerData.questLocalData.other['fish_'] = 5
			elseif questStep == 3 then 
				players[player].questLocalData.other['BUY_energyDrink_Ultra'] = 3 - (checkItemQuanty('energyDrink_Ultra', 1, player) and checkItemQuanty('energyDrink_Ultra', 1, player) or 0)
			elseif questStep == 4 then 
				removeBagItem('energyDrink_Ultra', 3, player)
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
		end, 
		reward = function(player)
			return
		end
	},
	[3] = {
		npcs = {'Sherlock$', 'Colt$', 'Indy$', 'Robber$'},
		active = function(player, questStep)
			local playerData = players[player]

			if questStep == 0 then 
				playerData.questLocalData.other['goToPolice'] = true
			elseif questStep == 1 then 
				gameNpcs.addCharacter('Sherlock$', {}, player, 0, 0, {questNPC = true})
			elseif questStep == 2 then 
				playerData.questLocalData.other['goToBank'] = true
			elseif questStep == 3 then 
				gameNpcs.addCharacter('Colt$', {}, player, 0, 0, {questNPC = true})
			elseif questStep == 4 then 
				playerData.questLocalData.other['goToPolice'] = true
			elseif questStep == 5 then 
				gameNpcs.addCharacter('Sherlock$', {}, player, 0, 0, {questNPC = true})
			elseif questStep == 6 then 
				playerData.questLocalData.other['goToBankRob'] = true
			elseif questStep == 7 then 
				addQuestAsset(player, '_cloth')
			elseif questStep == 8 then 
				playerData.questLocalData.other['goToPolice'] = true
			elseif questStep == 9 then 
				gameNpcs.addCharacter('Sherlock$', {}, player, 0, 0, {questNPC = true})
			elseif questStep == 10 then 
				gameNpcs.addCharacter('Indy$', {}, player, 0, 0, {questNPC = true})
			elseif questStep == 11 then 
				playerData.questLocalData.other['goToHospital'] = true
			elseif questStep == 12 then
				addQuestAsset(player, '_paper')
			elseif questStep == 13 then 
				playerData.questLocalData.other['goToMine'] = true
			elseif questStep == 14 then
				gameNpcs.addCharacter('Robber$', {'171a4cfc218.png'}, player, 1880, 8480, {questNPC = true})
				playerData.questLocalData.other['arrestRobber'] = true
			elseif questStep == 15 then 
				playerData.questLocalData.other['goToPolice'] = true
			elseif questStep == 16 then 
				gameNpcs.addCharacter('Sherlock$', {}, player, 0, 0, {questNPC = true})
			end
		end, 
		reward = function(player)
			return
		end
	},
	[4] = {
		npcs = {'Kariina$'},
		active = function(player, questStep)
			local playerData = players[player]

			gameNpcs.addCharacter('Kariina$', {'17193fda8a1.png', '171a8679a0c.png'}, player, 4360, 7677, {questNPC = true})
			if questStep == 1 then 
				playerData.questLocalData.other['goToIsland'] = true
			elseif questStep == 2 then 
				playerData.questLocalData.other['goToSeedStore'] = true
			elseif questStep == 3 then 
				playerData.questLocalData.other['BUY_seed'] = true
			elseif questStep == 4 then 
				playerData.questLocalData.other['goToHouse'] = true
			elseif questStep == 5 then 
				playerData.questLocalData.other['plant_seed'] = true
			elseif questStep == 6 then 
				playerData.questLocalData.other['harvestTomato'] = true
			elseif questStep == 7 then 
				playerData.questLocalData.other['goToSeedStore'] = true
			elseif questStep == 8 then 
				playerData.questLocalData.other['BUY_water'] = true
			elseif questStep == 9 then 
				playerData.questLocalData.other['goToMarket'] = true
			elseif questStep == 10 then 
				playerData.questLocalData.other['BUY_salt'] = true
			elseif questStep == 11 then 
				playerData.questLocalData.other['cookSauce'] = true				
			elseif questStep == 13 then 
				playerData.questLocalData.other['plant_seed'] = true
			elseif questStep == 14 then 
				playerData.questLocalData.other['harvestPepper'] = true
			elseif questStep == 15 then 
				playerData.questLocalData.other['cookHotSauce'] = true				
			elseif questStep == 17 then 
				playerData.questLocalData.other['plant_seed'] = true
			elseif questStep == 18 then 
				playerData.questLocalData.other['harvestWheat'] = true
			end
		end, 
		reward = function(player)
			return
		end
	},
	[5] = {
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
				playerData.questLocalData.other['ItemQuanty_lemon'] = 10 - (checkItemQuanty('lemon', 1, player) and checkItemQuanty('lemon', 1, player) or 0)
			elseif questStep == 11 then 
				playerData.questLocalData.other['ItemQuanty_tomato'] = 10 - (checkItemQuanty('tomato', 1, player) and checkItemQuanty('tomato', 1, player) or 0)
			elseif questStep == 13 then 
				gameNpcs.addCharacter('Indy$', {}, player, 0, 0, {questNPC = true})
			end
		end, 
		reward = function(player)
			return
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
		end, 
		reward = function(player)
			return
		end
	},
}