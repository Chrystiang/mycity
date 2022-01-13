jobRewards = {
	[1] = { -- Arrest 500 times
		requires = 500,
		callback = function(player)
			giveBadge(player, 10)
		end
	},
	[2] = { -- Rob 500 times
		requires = 500,
		callback = function(player)
			giveBadge(player, 5)
		end
	},
	[3] = { -- Fish 500 times
		requires = 500,
		callback = function(player)
			giveBadge(player, 2)
		end
	},
	[4] = { -- Mine 1000 gold nuggets
		requires = 1000,
		callback = function(player)
			giveBadge(player, 3)
		end
	},
	[5] = { -- Harvest 500 times
		requires = 500,
		callback = function(player)
			giveBadge(player, 4)
		end
	},
	[6] = { -- Sell 500 seeds
		requires = 500,
		callback = function(player)
			giveBadge(player, 8)
		end
	},
	[9] = { -- Deliver 500 orders
		requires = 500,
		callback = function(player)
			giveBadge(player, 9)
		end
	},
	[10] = { -- Cook 500 dishes
		requires = 500,
		callback = function(player)
			giveBadge(player, 14)
		end
	},
	[11] = { -- Sell 500 fruits
		requires = 500,
		callback = function(player)
			giveBadge(player, 25)
		end
	},
	[12] = { -- Sold 300 yellow crystals
		requires = 300,
		callback = function(player)
			giveBadge(player, 15)
		end
	},
	[13] = { -- Sold 150 blue crystals
		requires = 150,
		callback = function(player)
			giveBadge(player, 16)
		end
	},
	[14] = { -- Sold 75 purple crystals
		requires = 75,
		callback = function(player)
			giveBadge(player, 17)
		end
	},
	[15] = { -- Sold 30 green crystals
		requires = 30,
		callback = function(player)
			giveBadge(player, 18)
		end
	},
	[16] = { -- Sold 10 red crystals
		requires = 10,
		callback = function(player)
			giveBadge(player, 19)
		end
	}
	--17: Halloween 2019 
	--24: Christmas 2020
	--26: Christmas 2021
}