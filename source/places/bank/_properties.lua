room.bank  = {
	paperCurrentPlace = random(1, 13),
	paperImages = {},
	paperPlaces = {
		{x = 500, y = 240}, -- Jason's Workshop
		{x = 7150, y = 6085}, -- Police Station, next to sherlock
		{x = 7300, y = 5960}, -- Police Station, office
		{x = 8200, y = 6400}, -- Police Station, jail
		{x = 4980, y = 240}, -- Market
		{x = 14700, y = 240}, -- Pizzeria
		{x = 13130, y = 240}, -- Fish Shop
		{x = 17500, y = 1710}, -- Oliver's Farm, garden
		{x = 12120, y = 240}, -- Seed Store
		{x = 6480, y = 240}, -- Café
		{x = 10750, y = 240}, -- Potion Shop
		{x = 11000, y = 7770}, -- Island, next to bridge
		{x = 15970, y = 1705}, -- Remi's restaurant
		{x = 700, y = 8180}, -- Mine
		{x = 5800, y = 5235}, -- Bank
		{x = 4750, y = 3621}, -- Hospital (P)
	},
}

room.bankBeingRobbed     = false
room.bankRobbingTime     = 60
room.bankImages          = {}
room.bankTrashImages     = {}
room.bankRobStep         = nil
room.bankDoors           = {'', '', '', '', ''}
room.bankVaultPassword   = random(0,9) .. random(0,9) .. random(0,9) .. random(0,9)