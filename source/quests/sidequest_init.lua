sideQuests = {
	[1] = { -- Plant 5 seeds in oliver's house
		type = 'type:plant;oliver',
		amount = 5,
		points = 6,
	},
	[2] = { -- Fertilize 5 plants in oliver's house
		type = 'type:fertilize;oliver',
		amount = 5,
		points = 2,
	},
	[3] = { -- Get 5000 coins
		type = 'type:coins;get',
		amount = 5000,
		points = 7,
	},
	[4] = { -- Arrest a thief 3 times
		type = 'arrest',
		amount = 3,
		points = 3,
	},
	[5] = { -- Use 15 items
		type = 'type:items;use',
		amount = 15,
		points = 5,
	},
	[6] = { -- Spend 2000 coins
		type = 'type:coins;use',
		amount = 2000,
		points = 1,
	},
	[7] = { -- Fish 10 times
		type = 'type:fish',
		amount = 10,
		points = 3,
	},
	[8] = { -- Get 5 Gold Nuggets [removed]
		amount = 1,
		points = 1,
		alias = 5
	},
	[9] = { -- Rob the bank without getting arrested
		type = 'bank',
		amount = 1,
		points = 13,
	},
	[10] = { -- Rob 3 times
		type = 'rob',
		amount = 3,
		points = 5,
	},
	[11] = { -- Cook 3 times
		type = 'type:cook',
		amount = 3,
		points = 3,
	},
	[12] = { -- Earn 1000 xp
		type = 'getXP',
		amount = 1000,
		points = 10,
	},
	[13] = { -- Fish 4 frogs
		type = 'type:fish;fish_Frog',
		amount = 4,
		points = 3,
	},
	[14] = { -- Fish a Lionfish
		type = 'type:fish;fish_Lionfish',
		amount = 1,
		points = 5,
	},
	[15] = { -- Deliver 5 orders
		type = 'deliver',
		amount = 5,
		points = 10,
	},
	[16] = { -- Deliver 10 orders
		type = 'deliver',
		amount = 10,
		points = 23,
	},
	[17] = { -- Cook a pizza
		type = 'type:cook;pizza',
		amount = 1,
		points = 3,
	},
	[18] = { -- Cook a bruschetta
		type = 'type:cook;bruschetta',
		amount = 1,
		points = 3,
	},
	[19] = { -- Make a lemonade
		type = 'type:cook;lemonade',
		amount = 1,
		points = 2,
	},
	[20] = { -- Cook a frogwich
		type = 'type:cook;frogSandwich',
		amount = 1,
		points = 2,
	},
	[21] = { -- Plant 2 seeds in oliver's house
		amount = 2,
		points = 1,
		alias = 1,
	},
	[22] = { -- Plant 10 seeds in oliver's house
		amount = 10,
		points = 10,
		alias = 1,
	},
	[23] = { -- Fertilize 3 plants in oliver's house
		amount = 3,
		points = 2,
		alias = 2,
	},
	[24] = { -- Fertilize 10 plants in oliver's house
		amount = 10,
		points = 6,
		alias = 2,
	},
	[25] = { -- Get 1000 coins
		amount = 1000,
		points = 2,
		alias  = 3,
	},
	[26] = { -- Get 10000 coins
		amount = 10000,
		points = 20,
		alias  = 3,
	},
	[27] = { -- Fish 3 times
		amount = 3,
		points = 1,
		alias = 7,
	},
	[28] = { -- Arrest a thief 6 times
		amount = 6,
		points = 6,
		alias = 4,
	},
	[29] = { -- Deliver 2 orders
		amount = 2,
		points = 2,
		alias = 16,
	},
	[30] = { -- Use 5 items
		amount = 5,
		points = 1,
		alias = 5,
	},
	[31] = { -- Sell [Amount] crystals
		type = 'sell_crystal',
		amount = {2, 5, 10},
		points = {2, 4, 6},
	},
	[32] = { -- Trade with Dave [Amount] times
		type = 'trade_with_dave',
		amount = {2, 3, 5},
		points = {1, 2, 3},
	},
	[33] = { -- Harvest [Amount] crops
		type = 'harvest',
		amount = {2, 5, 10},
		points = {1, 3, 5},
	},
	[34] = { -- Sell [Amount] seeds.
		type = 'sell_seeds',
		amount = {3, 5, 10},
		points = {1, 2, 3},
	},
	[35] = { -- Sell [Amount] fruits.
		type = 'sell_fruits',
		amount = {10, 15, 20},
		points = {2, 3, 3},
	},
	[36] = { -- Sell [Amount] fishes.
		type = 'sell_fishes',
		amount = {5, 10, 15},
		points = {1, 2, 3},
	},
	[37] = { -- Rob [NPC] [Amount] times.
		type = 'rob_npc',
		amount = {2, 5},
		points = {2, 5},
		extraData = function()
			return table_randomKey(gameNpcs.robbing)
		end,
		formatDescription = function(player)
			local playerData = players[player]
			local npc 		= "<vp>".. playerData.sideQuests[8] .."</vp>"
			local amount 	= "<vp>".. playerData.sideQuests[2] .. '/'.. playerData.sideQuests[7] .."</vp>"
			return {npc, amount}
		end
	},
	[38] = { -- Buy [Amount] items from [NPC].
		type = 'buy_from_npc',
		amount = {2, 5, 8},
		points = {1, 2, 3},
		extraData = function()
			return table_randomKey(gameNpcs.selling)
		end,
		formatDescription = function(player)
			local playerData = players[player]
			local npc 		= "<vp>".. playerData.sideQuests[8] .."</vp>"
			local amount 	= "<vp>".. playerData.sideQuests[2] .. '/'.. playerData.sideQuests[7] .."</vp>"
			return {amount, npc}
		end
	},
	[39] = { -- Fish [Amount] mudfish.
		type = 'type:fish;fish_Mudfish',
		amount = {2, 3, 5},
		points = {2, 3, 5},
	},
	[40] = { -- Find a suspicious paper in the map.
		type = 'type:findBankPaper',
		amount = 1,
		points = 1,
	},
	[41] = { -- Recover [Amount] of hunger
		type = 'type:recoveHunger',
		amount = {50, 100, 300},
		points = {1, 2, 3},
	},
	[42] = { -- Lose [Amount] of hunger
		type = 'type:loseHunger',
		amount = {20, 60, 150},
		points = {1, 2, 3},
	},
	[43] = { -- Recover [Amount] of energy
		type = 'type:recoveEnergy',
		amount = {50, 100, 200},
		points = {1, 2, 3},
	},
	[44] = { -- Lose [Amount] of energy
		type = 'type:loseEnergy',
		amount = {20, 60, 150},
		points = {1, 2, 3},
	},
}

for i, v in next, sideQuests do
	if v.alias then
		v.type = sideQuests[v.alias].type
	end
end