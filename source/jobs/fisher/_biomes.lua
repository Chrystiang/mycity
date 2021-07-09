room.fishing = {
	biomes = {
		sea = {
			canUseBoat = true,
			between = {'town', 'island'},
			location = {
				{x = 6400-70, y = 7775-70}, {x = 6400-70, y = 8000}, {x = 9160+70, y = 7775-70}, {x = 9160+70, y = 8000},
			},
			fishes = {
				normal      = {'fish_Smolty', 'cheese', 'wheatSeed', 'fish_Guppy'},
				rare        = {'fish_Lionfish', 'fish_Dogfish', 'fish_Catfish'},
				mythical    = {'fish_Lobster',},
				legendary   = {'fish_Goldenmare',},
			},
		},
		bridge = {
			location = {
				{x = 10760, y = 7775-70}, {x = 10915, y = 7775-70}, {x = 10915, y = 7828}, {x = 10760, y = 7828},
			},
			fishes = {
				normal      = {'fish_Frog', 'fish_Guppy', 'fish_Bittyfish'},
				rare        = {'fish_Dogfish'},
				mythical    = {'fish_Lobster',},
				legendary   = {'fish_Goldenmare',},
			},
		},
		sewer = {
			canUseBoat = true,
			between = {'mine', 'mine_excavation'},
			location = {
				{x = 2837-70, y = 8662-70}, {x = 2837-70, y = 8800}, {x = 4325+70, y = 8662-70}, {x = 4325+70, y = 8800},
			},
			fishes = {
				normal      = {'fish_Mudfish', 'cheese', 'wheatSeed', 'fish_Sinkfish'},
				rare        = {'fish_Lionfish', 'fish_Dogfish', 'fish_Catfish'},
				mythical    = {'fish_Lobster',},
				legendary   = {'fish_Goldenmare',},
			},
		},
	},
	fishes = {
		normal = {
			'fish_Smolty', 'cheese', 'wheatSeed', 'fish_Guppy', 'fish_Frog'
		},
		rare = {
			'fish_Lionfish', 'fish_Dogfish', 'fish_Catfish',
		},
		mythical = {
			'fish_Lobster',
		},
		legendary = {
			'fish_Goldenmare',
		},
	},
}