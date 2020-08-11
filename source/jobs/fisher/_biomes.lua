room.fishing = {
	biomes = {
		sea = {
			canUseBoat = true,
			between = {'town', 'island'},
			location = {
				{x = 6400-70, y = 7775-70}, {x = 6400-70, y = 8000}, {x = 9160+70, y = 7775-70}, {x = 9160+70, y = 8000},
			},
			fishes = {
				normal      = {'fish_SmoltFry', 'cheese', 'wheatSeed', 'fish_RuntyGuppy'},
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
				normal      = {'fish_Frog', 'fish_RuntyGuppy'},
				rare        = {'fish_Dogfish', 'fish_Catfish', 'lemonSeed'},
				mythical    = {'fish_Lobster',},
				legendary   = {'fish_Goldenmare',},
			},
		},
		sewer = {
			canUseBoat = true,
			between = {'mine_labyrinth', 'mine_escavation'},
			location = {
				{x = 2837-70, y = 8662-70}, {x = 2837-70, y = 8800}, {x = 4325+70, y = 8662-70}, {x = 4325+70, y = 8800},
			},
			fishes = {
				normal      = {'fish_SmoltFry', 'cheese', 'wheatSeed', 'fish_RuntyGuppy'},
				rare        = {'fish_Lionfish', 'fish_Dogfish', 'fish_Catfish'},
				mythical    = {'fish_Lobster',},
				legendary   = {'fish_Goldenmare',},
			},
		},
	},
	fishes = {
		normal = {
			'fish_SmoltFry', 'cheese', 'wheatSeed', 'fish_RuntyGuppy', 'fish_Frog'
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