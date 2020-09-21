jobs = {
	fisher = {
		color   = '32CD32',
		coins   = '15 - $10.000</font>',
		working = {},
		players = 0,
		icon = '171d2134def.png',
	},
	police = {
		color   = '4169E1',
		coins   = 150,
		working = {},
		players = 10,
		icon = '171d1f8d911.png',
	},
	thief = {
		color   = 'CB546B',
		coins   = 250,
		bankRobCoins = 1100,
		working = {},
		players = 0,
		icon = '171d20cca72.png',
	},
	miner = {
		color   = 'B8860B',
		coins   = 0,
		working = {},
		players = 0,
		icon = '171d21cd12d.png',
	},
	farmer = {
		color   = '9ACD32',
		coins   = '10 - $10.000</font>',
		working = {},
		players = 0,
		icon = '171d1e559be.png',
		specialAssets = function(player)
			for i = 1, 4 do
				if players['Oliver'].houseTerrainAdd[i] >= #HouseSystem.plants[players['Oliver'].houseTerrainPlants[i]].stages then
					local y = 1500 + 90
					ui.addTextArea('-730'..(tonumber(i)..tonumber(players['Oliver'].houseData.houseid)*10), '<a href="event:harvest_'..tonumber(i)..'"><p align="center"><font size="15">'..translate('harvest', player)..'</font></p></a>', player, (11%12)*1500+738-(175/2)-2 + (tonumber(i)-1)*175, y+150, 175, 150, 0xff0000, 0xff0000, 0)
				end
			end
		end,
	},
	chef = {
		color   = '00CED1',
		coins   = '10 - $10.000</font>',
		working = {},
		players = 0,
		icon = '171d20548bd.png',
	},
	ghostbuster = {
		color   = 'FFE4B5',
		coins   = 300,
		players = 0,
	},
	ghost = {
		color   = 'A020F0',
		coins   = 100,
		players = 0,
	},
}