sideQuests = {
	[1] = { -- Plant 5 seeds in oliver's house
		type = 'type:plant;oliver',
		quanty = 5,
		points = 6,
	},
	[2] = { -- Fertilize 5 plants in oliver's house
		type = 'type:fertilize;oliver',
		quanty = 5,
		points = 2,
	},
	[3] = { -- Get 5000 coins
		type = 'type:coins;get',
		quanty = 5000,
		points = 7,
	},
	[4] = { -- Arrest a thief 3 times
		type = 'type:arrest',
		quanty = 3,
		points = 3,
	},
	[5] = { -- Use 15 items
		type = 'type:items;use',
		quanty = 15,
		points = 2,
	},
	[6] = { -- Spend 2000 coins
		type = 'type:coins;use',
		quanty = 2000,
		points = 1,
	},
	[7] = { -- Fish 10 times
		type = 'type:fish',
		quanty = 10,
		points = 3,
	},
	[8] = { -- Get 5 Gold Nuggets
		type = 'type:goldNugget',
		quanty = 0,
		points = 4,
	},
	[9] = { -- Rob the bank without getting arrested
		type = 'type:bank',
		quanty = 1,
		points = 7,
	},
	[10] = { -- Rob 3 times
		type = 'type:rob',
		quanty = 3,
		points = 5,
	},
	[11] = { -- Cook 3 times
		type = 'type:cook',
		quanty = 3,
		points = 3,
	},
	[12] = { -- Earn 1000 xp
		type = 'type:getXP',
		quanty = 1000,
		points = 10,
	},
	[13] = { -- Fish 10 frogs
		type = 'type:fish;fish_Frog',
		quanty = 10,
		points = 3,
	},
	[14] = { -- Fish a Lionfish
		type = 'type:fish;fish_Lionfish',
		quanty = 1,
		points = 5,
	},
	[15] = { -- Deliver 5 orders
		type = 'type:deliver',
		quanty = 5,
		points = 10,
	},
	[16] = { -- Deliver 10 orders
		type = 'type:deliver',
		quanty = 10,
		points = 23,
	},
	[17] = { -- Cook a pizza
		type = 'type:cook;pizza',
		quanty = 1,
		points = 3,
	},
	[18] = { -- Cook a bruschetta
		type = 'type:cook;bruschetta',
		quanty = 1,
		points = 3,
	},
	[19] = { -- Make a lemonade
		type = 'type:cook;lemonade',
		quanty = 1,
		points = 2,
	},
	[20] = { -- Cook a frogwich
		type = 'type:cook;frogSandwich',
		quanty = 1,
		points = 2,
	},
	[21] = { -- Plant 2 seeds in oliver's house
		quanty = 2,
		points = 1,
		alias = 1,
	},
	[22] = { -- Plant 10 seeds in oliver's house
		quanty = 10,
		points = 10,
		alias = 1,
	},
	[23] = { -- Fertilize 3 plants in oliver's house
		quanty = 3,
		points = 2,
		alias = 2,
	},
	[24] = { -- Fertilize 10 plants in oliver's house
		quanty = 10,
		points = 6,
		alias = 2,
	},
	[25] = { -- Get 1000 coins
		quanty = 1000,
		points = 2,
		alias  = 3,
	},
	[26] = { -- Get 10000 coins
		quanty = 10000,
		points = 20,
		alias  = 3,
	},
	[27] = { -- Fish 3 times
		quanty = 3,
		points = 1,
		alias = 7,
	},
	[28] = { -- Arrest a thief 6 times
		quanty = 6,
		points = 6,
		alias = 4,
	},
}

for i, v in next, sideQuests do
	if v.alias then
		v.type = sideQuests[v.alias].type
	end
end