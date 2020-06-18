local TFM, ROOM = tfm.exec, tfm.get.room
local string, math, table, gsub, addGround, removeGround, addTextArea, move, addImage, removeImage = string, math, table, string.gsub, TFM.addPhysicObject, TFM.removePhysicObject, ui.addTextArea, TFM.movePlayer, TFM.addImage, TFM.removeImage
local bagIds, bagItems, recipes, modernUI, HouseSystem, _QuestControlCenter
local chatCommands = {}
TFM.setRoomMaxPlayers(15)
TFM.disableAutoShaman()
TFM.disableAfkDeath()
TFM.disableWatchCommand()
TFM.disableAutoNewGame()
TFM.disableMortCommand()
TFM.disableMinimalistMode()
TFM.disableDebugCommand()
TFM.disablePhysicalConsumables()
TFM.disableAutoScore()
system.disableChatCommandDisplay()

math.randomseed(os.time())
local players = {}
local room = { -- Assets that can change while the script runs
	dayCounter = 0,
	mathSeed = os.date("%j"),
	rankingImages = {},
	droppedItems = {},
	terrains = {},
	gardens = {},
	perban = {'Fontflex#0000', 'Luquinhas#6375', 'Luquinhas#9650', 'Mandinhamita#0000', 'Furoaazui#0000', 'Rainhadetudo#6235', 'Gohanffglkj#9524', 'Mycity#3262', 'Mavin2#0000', 'Giud#9046', 'Mavin3#8659', 'Euney#5983', 'C4ver4_ghost#1459'},
	unranked = {'Bodykudo#0000', 'Benaiazyux#0000', 'Fofinhoppp#0000', 'Ffmisael#0000', 'Mavin2#0000', 'Giud#9046', 'Mavin3#8659', 'Euney#5983', 'Ppp001#0000'},
	bannedPlayers = {},
	boatShop2ndFloor = false,
	isInLobby = true,
	requiredPlayers = 4,
	discordServerUrl = 'https://discord.gg/uvGwa2y',
	globalRanking = {},
	event = nil, -- released: halloween2019, christmas2019
	gameDayStep = 'day', -- default: day // halloween: halloween
	houseImgs = {},
	y		= 5815,
	currentGameHour = 0,
	groundsPosition = {250, 749+250, 50},
	specialFounds = {
		christmas2019 = {
			evening = '16ee11c6a13.jpg',
			dawn = '16ee11d3516.jpg',
			night = '16ee11b36c4.jpg',
			day = '16ee11b1f00.png',
			align = 1919,
		},
		halloween2019 = {
			evening = '16dd5d7c4e1.jpg',
			dawn = '16dd5d78f0d.jpg',
			night = '16dd5d7ad6f.jpg',
			day = '16dd5d7738e.jpg',
			align = 1919,
		},
	},
	started = false,
	hospital = {
		[1] = {
			[1] = {name = nil},
			[2] = {name = nil},
		},
		[2] = {
			[1] = {name = nil},
			[2] = {name = nil},
		},
		[3] = {
			[1] = {name = nil},
			[2] = {name = nil},
		},
		[4] = {
			[1] = {name = nil},
			[2] = {name = nil},
		},
		[6] = {
			[1] = {name = nil},
			[2] = {name = nil},
		},
		[7] = {
			[1] = {name = nil},
			[2] = {name = nil},
		},
		[8] = {
			[1] = {name = nil},
			[2] = {name = nil},
		},
		[9] = {
			[1] = {name = nil},
			[2] = {name = nil},
		},
	},
	bank = {
		paperCurrentPlace = math.random(1, 13),
		paperImages = {},
		paperPlaces = {
			{x = 500, y = 240}, -- Jason's Workshop
			{x = 7150, y = 6085}, -- Police Station, next to sherlock
			{x = 7300, y = 5960}, -- Police Station, office
			{x = 8200, y = 6400}, -- Police Station, jail
			{x = 4980, y = 240}, -- Market
			{x = 14700, y = 240}, -- Pizzeria
			{x = 13130, y = 240}, -- Fish Shop
			{x = 13350, y = 1555}, -- Oliver's Farm, next to marcus
			{x = 16000, y = 1710}, -- Oliver's Farm, garden
			{x = 12120, y = 240}, -- Seed Store
			{x = 6480, y = 240}, -- Café
			{x = 10750, y = 240}, -- Potion Shop
			{x = 11000, y = 7770}, -- Island, next to bridge

		},
	},
	bankBeingRobbed = false,
	bankRobbingTime = 60,
	bankImages = {},
	bankTrashImages = {},
	bankRobStep = nil,
	bankDoors = {'', '', '', '', ''},
	bankVaultPassword = math.random(0,9) .. math.random(0,9) .. math.random(0,9) .. math.random(0,9),
	robbing = {
		prisonTimer = 100,
		robbingTimer = 90,
		bankRobbingTimer = 60,
	},
	temporaryTimer = nil,
	fishing = {
		biomes = {
			sea = {
				canUseBoat = true,
				between = {'town', 'island'},
				location = {
					{x = 6400-70, y = 7775-70}, {x = 6400-70, y = 8000}, {x = 9160+70, y = 7775-70}, {x = 9160+70, y = 8000},
				},
				fishes = {
					normal = {'fish_SmoltFry', 'cheese', 'wheatSeed', 'fish_RuntyGuppy'},
					rare = {'fish_Lionfish', 'fish_Dogfish', 'fish_Catfish'},
					mythical = {'fish_Lobster',},
					legendary = {'fish_Goldenmare',},
				},
			},
			bridge = {
				location = {
					{x = 10760, y = 7775-70}, {x = 10915, y = 7775-70},  {x = 10915, y = 7828}, {x = 10760, y = 7828},
				},
				fishes = {
					normal = {'fish_Frog', 'fish_RuntyGuppy'},
					rare = {'fish_Dogfish', 'fish_Catfish', 'lemonSeed'},
					mythical = {'fish_Lobster',},
					legendary = {'fish_Goldenmare',},			
				},
			},
			sewer = {
				canUseBoat = true,
				between = {'mine_labyrinth', 'mine_escavation'},
				location = {
					{x = 2837-70, y = 8662-70}, {x = 2837-70, y = 8800}, {x = 4325+70, y = 8662-70}, {x = 4325+70, y = 8800},
				},
				fishes = {
					normal = {'fish_SmoltFry', 'cheese', 'wheatSeed', 'fish_RuntyGuppy'},
					rare = {'fish_Lionfish', 'fish_Dogfish', 'fish_Catfish'},
					mythical = {'fish_Lobster',},
					legendary = {'fish_Goldenmare',},
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
}
local syncData = {
    connected = false,
    quests = {
        newQuestDevelopmentStage = 0,
    },
    updating = {
        isUpdating = false,
        updateMessage = '',
    }
}
local mainAssets = { -- Assets that dont change while the script runs
	season = 1,
	supportedCommunity = {'en', 'br', 'es', 'ar', 'tr', 'hu', 'pl', 'ru', 'fr', 'e2', 'sk'},
	housePermissions = {
		[-1] = 'blocked',
		[0] = 'guest',
		[1] = 'roommate',
		[2] = 'coowner',
		[3] = 'owner',
	},
	__houses = {
		[1] = {
			properties = {
				price 	= 7000,
				png 	= '1729fd5cfd0.png',
			},
			inside = {
				image 	= '172566957cc.png',
			},
			outside = {
				icon 	= '1729fd367cb.png',
				axis 	= {8, 4},
			},
		},
		[2] = {
			properties = {
				price 	= 13000,
				png 	= '16c2524d88c.png',
			},
			inside = {
				image 	= '172566a7a66.png',
				grounds = function(terrainID)
					addGround(-6500+terrainID*20, 290 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + 65, {type = 12, friction = 0.3, restitution = 0.2, width = 480, height = 30})
					addGround(-6501+terrainID*20, 225 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + 200, {type = 12, friction = 0.3, restitution = 0.2, width = 350, height = 15})
					addGround(-6502+terrainID*20, 055 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + 160, {type = 12, friction = 0.3, restitution = 0.2, height = 190})
					addGround(-6503+terrainID*20, 525 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + 160, {type = 12, friction = 0.3, restitution = 0.2, height = 190})
					addGround(-6504+terrainID*20, 480 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + 310, {type = 12, friction = 0.3, restitution = 0.9, width = 105, height = 20})
				end
			},
			outside = {
				icon 	= '15909c0372a.png',
				axis 	= {0, 0},
			},
		},
		[3] = {
			properties = {
				price 	= 10000,
				png 	= '16c2525f7c5.png',
			},
			inside = {
				image 	= '172566a4e82.png',
				grounds = function(terrainID)
					addGround(-6500+terrainID*20, 345 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + 307, {type = 13, friction = 0.3, restitution = 1, width = 20})
					addGround(-6501+terrainID*20, 118 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + 307, {type = 13, friction = 0.3, restitution = 1, width = 20})
					addGround(-6502+terrainID*20, 188 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + 182, {type = 12, friction = 0.3, restitution = 0.2, width = 260})
					addGround(-6503+terrainID*20, 460 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + 170, {type = 12, friction = 0.3, restitution = 0.2, width = 180})		
				end
			},
			outside = {
				icon 	= '15ef7b94b7f.png',
				axis 	= {0, -50},
			},
		},
		[4] = {
			properties = {
				price = 13000,
				png = '16c795c65e8.png',
				limitedTime = os.time{day=1, year=2020, month=1},
			},
			inside = {
				image 	= '172566a23a6.png',
			},
			outside = {
				icon 	= '16c7957eefd.png',
				axis 	= {0, -31},
			},
		},
		[5] = { -- Halloween2019
			properties = {
				price 	= 20000,
				png 	= '16dd75fa5a1.png',
				limitedTime = os.time{day=11, year=2019, month=11},
			},
			inside = {
				image 	= '1725669f804.png',
				grounds = function(terrainID)
					addGround(-6500+terrainID*20, 201 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + 138, {type = 12, friction = 0.3, restitution = 0.2, width = 280, height = 20})
					addGround(-6501+terrainID*20, 463 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + 138, {type = 12, friction = 0.3, restitution = 0.2, width = 130, height = 20})
					addGround(-6502+terrainID*20, 290 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + 038, {type = 12, friction = 0.3, restitution = 0.2, width = 180, height = 20})
					addGround(-6503+terrainID*20, 373 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + 307, {type = 13, friction = 0.3, restitution = 1, width = 20})
					addGround(-6504+terrainID*20, 505 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + 114, {type = 13, friction = 0.3, restitution = 1, width = 20})	
				end
			},
			outside = {
				icon 	= '16dd74f0f44.png',
				axis 	= {0, -32},
			},
		},
		[6] = { -- Christmas2019
			properties = {
				price = 25000,
				png = '16ee526d8a3.png',
				limitedTime = os.time{day=15, year=2020, month=1},
			},
			inside = {
				image 	= '1725669cbbb.png',
				grounds = function(terrainID)
					addGround(-6500+terrainID*20, 230 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + 140, {type = 12, friction = 0.3, restitution = 0.2, width = 346, height = 20})
					addGround(-6501+terrainID*20, 315 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + -52, {type = 12, friction = 0.3, restitution = 0.2, width = 170, height = 20})
					addGround(-6502+terrainID*20, 458 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + 310, {type = 12, friction = 0.3, restitution = 1, width = 107, height = 30})
					addGround(-6503+terrainID*20, 195 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + 127, {type = 12, friction = 0.3, restitution = 1, width = 43, height = 30})
					addGround(-6504+terrainID*20, 420 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + -50, {type = 12, friction = 0.3, restitution = 0.2, width = 480, height = 30, angle = 58})
					addGround(-6505+terrainID*20, 155 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + -50, {type = 12, friction = 0.3, restitution = 0.2, width = 480, height = 30, angle = -58})
				end
			},
			outside = {
				icon 	= '16ee521a785.png',
				axis 	= {0, -49},
			},
		},
		[7] = { -- Treehouse
			properties = {
				price = 50000,
				png = '1714cb5c23b.png',
			},
			inside = {
				image 	= '172572b0a32.png',
				grounds = function(terrainID)
					addGround(-6500+terrainID*20, 235 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + 001, {type = 12, friction = 0.3, restitution = 0.2, width = 460, height = 20})
					addGround(-6501+terrainID*20, 440 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + 151, {type = 12, friction = 0.3, restitution = 0.2, width = 220, height = 20})
					addGround(-6502+terrainID*20, 345 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + 210, {type = 12, friction = 20, restitution = 0.2, width = 30, height = 130})
					addGround(-6503+terrainID*20, 445 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + 050, {type = 12, friction = 20, restitution = 0.2, width = 30, height = 90})
					addGround(-6504+terrainID*20, 399 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + -182, {type = 12, friction = 0.3, restitution = 0.2, width = 300, height = 20})
					addGround(-6505+terrainID*20, 091 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + -182, {type = 12, friction = 0.3, restitution = 0.2, width = 145, height = 20})
					addGround(-6506+terrainID*20, 149 + ((terrainID-1)%terrainID)*1500 + 60, 1397 + -110, {type = 12, friction = 20, restitution = 0.2, width = 30, height = 130})
				end
			},
			outside = {
				icon 	= '1714cb20371.png',
				axis 	= {0, -30},
			},
		},
		[8] = { -- Spongebob House
			properties = {
				price = 25000000,
				png = '171b4158ba5.png',
				limitedTime = os.time{day=25, year=2020, month=4},
			},
			inside = {
				image 	= '17256699f73.png',
			},
			outside = {
				icon 	= '171b40ef58c.png',
				axis 	= {0, -49},
			},
		},
		[9] = { -- Restaurant
			properties = {
				price = 25,
				png = '1727ba2f8dd.png',
				limitedTime = os.time{day=25, year=2020, month=4},
			},
			inside = {
				image 	= '1727b98abb7.png',
			},
			outside = {
				icon 	= '1727ba0e8b2.png',
				axis 	= {0, -50},
			},
		},
	},
	__terrainsPositions = {
		{0100, 1596+room.y-12},
		{0265, 1596+room.y-12},
		{0660, 1596+room.y-12},
		{0825, 1596+room.y-12},
		{2330, 1796+room.y-12},
		{2330+165, 1796+room.y-12},
		{2900, 1796+room.y-12},
		{3065, 1796+room.y-12},
		{3065+165, 1796+room.y-12},
		{113000, 1796+room.y-12}, -- REMI
		{113000, 1796+room.y-12}, -- OLIVER
		{12100, 1796+room.y-12},
		{12265, 1796+room.y-12},
		{12265+165, 1796+room.y-12},
		{12595, 1796+room.y-12},
	},
	__cars = {
		-- direita, esquerda
		[1] = {
			type 	= 'car',
			price  	= 2000,
			maxVel 	= 70,
			image  	= {'15b2a6174cc.png', '15b2a61ce19.png'},
			x	   	= -61,
			y	   	= -29,
			name   	= 'Classic XI',
			icon	= '16ab8193788.png',
		},
		[2] = {
			type	= 'car',
			price  	= 6000,
			maxVel 	= 90,
			image  	= {'15b4b26768c.png','15b4b270f39.png'},
			x	   	= -60,
			y	   	= -26,
			name   	= 'Mini Cooper',
			icon	= '16ab8194efa.png',
		},
		[3] = {
			type	= 'car',
			price	= 10000,
			maxVel	= 120,
			image	= {'16beb25759c.png', '16beb272303.png'},
			x	    = -85,
			y	    = -30,
			name    = 'BMW',
			icon	= '16ab819666d.png',
		},
		[4] = {
			type	= 'car',
			price	= 15000,
			maxVel	= 150,
			image	= {'15b302ac269.png', '15b302a7102.png'},
			x	    = -91,
			y	    = -21,
			name    = 'Ferrari 488',
			icon	= '16ab831a98a.png',
		},
		[5] = {
			type	= 'boat',
			price  	= 1000000,
			maxVel 	= 50,
			image  	= {'164d43b8055.png', '164d43ba0bd.png'},
			x	   	= -50,
			y	   	= -3,
			name   	= 'Boat',
			icon 	= '16ab82e10f6.png',
		},
		[6] = {
			type	= 'boat',
			price  	= 30000,
			maxVel 	= 100,
			image  	= {'16bc49d0cb5.png', '16bc4a93359.png'},
			x	   	= -250,
			y	   	= -170,
			name   	= 'tugShip',
			icon	= '16bc4afc305.png',
		},
		[7] = {
			type	= 'car',
			price	= 45000,
			maxVel	= 210,
			image	= {'16be76fd925.png', '16be76d2c15.png'},
			x	    = -90,
			y	    = -30,
			name    = 'Lamborghini',
			icon	= '16be7831a66.png',
		},
		[8] = {
			type	= 'boat',
			price  = 40000,
			maxVel = 130,
			image  = {'1716571c641.png', '171656f6573.png'},
			x	   = -100,
			y	   = -80,
			name   = 'motorboat',
			icon	= '1716566629c.png',
		},
		[9] = { -- Sleigh
			type	= 'car',
			price	= 20000,
			maxVel	= 90,
			image	= {'16f1a649b5e.png', '16f1a683125.png'},
			x	    = -60,
			y	    = -25,
			name    = 'Sleigh',
			icon	= '16f1fd0857f.png',
			effects = function(player)
						if math.random() < 0.5 then 
							TFM.movePlayer(player, 0, 0, true, 0, -50, false)
						end
					end,
		},
		[11] = {
			type	= 'boat',
			price  = 500000,
			maxVel = 200,
			image  = {'1716aa827f8.png', '1716a699fd4.png'},
			x	   = -400,
			y	   = -50,
			name   = 'yatch',
			icon	= '171658e5be2.png',
		},
		[12] = { -- Bugatti
			type 	= 'car',
			price	= 500000,
			maxVel	= 400,
			image	= {'16eccf772fe.png', '16eccf74fae.png'},
			x	    = -90,
			y	    = -27,
			name    = 'Bugatti',
			icon	= '16eccfc33a2.png',
			effects = function(player)
						local lights = {'16ecd112e05.png', '16ecd116c89.png', '16ecd118bc9.png', '16ecd125468.png', '16ecd125468.png', '16ecd13a260.png'}
						player_removeImages(players[player].carLeds)
						players[player].carLeds[#players[player].carLeds+1] = addImage(lights[math.random(#lights)], '$'..player, -130, -20)
					end,
		},
	},
	__farmOffers = {
		[1] = {
			item = {'lettuce', 5},
			requires = {'oregano', 10},
		},
		[2] = {
			item = {'lettuce', 5},
			requires = {'tomato', 10},
		},
		[3] = {
			item = {'egg', 2},
			requires = {'wheat', 15},
		},
		[4] = {
			item = {'honey', 2},
			requires = {'bread', 3},
		},
		[5] = {
			item = {'honey', 2},
			requires = {'lemon', 5},
		},
		[6] = {
			item = {'garlic', 3},
			requires = {'wheat', 15},
		},
		[7] = {
			item = {'potato', 5},
			requires = {'tomato', 10},
		},
		[8] = {
			item = {'pumpkin', 1},
			requires = {'chocolateCake', 2},
		},
		[9] = {
			item = {'egg', 1},
			requires = {'lemon', 2},
		},
		[10] = {
			item = {'wheatFlour', 5},
			requires = {'salad', 2},
		},
		[11] = {
			item = {'wheatFlour', 3},
			requires = {'lemonade', 1},
		},
	},
	__furnitures = {
		[0] = { -- oven
			image = '15bff698271.png',
			png = '16c1f82b594.png',
			price = 600,
			area = {48, 50},
			align = {x = -24, y = -32},
			name = 'oven',
			usable = function(player) 
				eventTextAreaCallback(0, player, 'recipes', true)
			end,
		},
		[1] = { -- kitchenCabinet 1
			image = '16c2fa4c400.png',
			png = '16c2fbb3b9f.png',
			price = 200,
			area = {53, 53},
			align = {x = -30, y = -35},
			name = 'kitchenCabinet',
		},
		[2] = { -- kitchenCabinet 2
			image = '16c2fa904b5.png',
			png = '17258765a23.png',
			price = 200,
			area = {53, 53},
			align = {x = -30, y = -37},
			name = 'kitchenCabinet',
		},
		[3] = { -- flower
			image = '16c599ab61c.png',
			png = '16c59a071aa.png',
			price = 80,
			area = {35, 60},
			align = {x = -20, y = -43},
			name = 'flowerVase',
			credits = 'Iho#5679',
		},
		[4] = { -- wall 200x140
			image = '16c3f03c618.png',
			png = '16c3f168f7c.png',
			price = 150,
			area = {35, 60}, 
			align = {x = -100, y = -123},
			name = 'wall_200x140',
			type = 'wall',
			npcShop = 'jason',
		},
		[5] = { -- painting1
			image = '16c53533293.png',
			png = '16c535c3ca7.png',
			price = 100,
			area = {50, 50},
			align = {x = -25, y = -80},
			name = 'painting',
			credits = 'Iho#5679',
		},
		[6] = { -- painting2
			image = '16c5353534e.png',
			png = '16c535c8e72.png',
			price = 100,
			area = {50, 50},
			align = {x = -25, y = -80},
			name = 'painting',
			credits = 'Iho#5679',
		},
		[7] = { -- roof 200x20
			image = '16c53db2ceb.png',
			png = '16c53de3fd2.png',
			price = 150,
			area = {35, 60},
			align = {x = -100, y = -140},
			name = 'roof_200x20',
			type = 'wall',
			npcShop = 'jason',
		},
		[8] = { -- sofa
			image = '16c59d2c222.png',
			png = '16c59b1b50f.png',
			price = 100,
			area = {150, 50},
			align = {x = -75, y = -40},
			name = 'sofa',
			credits = 'Iho#5679',
			grounds = function(x, y, id)
				addGround(id, 75+x, 47+5+y, {type = 14, height = 30, width = 140, friction = 0.3, restitution = 0.2})
			end,
			usable = function(player) 
				TFM.playEmote(player, 8)
			end,
		},
		[9] = { -- chest
			image = '16c72fcbf05.png',
			png = '16c72fe0a7b.png',
			price = 0,
			area = {43, 40},
			align = {x = -22, y = -24},
			name = 'chest',
			credits = 'Iho#5679',
			type = 'especial',
			qpPrice = 50,
			usable = function(player)
				modernUI.new(player, 520, 300, translate('furniture_chest', player))
				:build()
				:showPlayerItems(players[player].houseData.chests.storage[1], 1)
			end,
			npcShop = 'marcus',
			stockLimit = 1,
		},
		[10] = { -- tv
			image = '16c77ecde3d.png',
			png = '16c7917a3bd.png',
			price = 300,
			area = {45, 57},
			align = {x = -25, y = -90},
			name = 'tv',
			credits = 'Iho#5679',
		},
		[11] = { -- painting3
			image = '16d79e8a2b6.png',
			png = '16da866a844.png',
			price = 100,
			area = {50, 50},
			align = {x = -25, y = -80},
			name = 'painting',
			type = 'especial',
		},
		[12] = { -- hay
			image = '16d849a107d.png',
			png = '16dadb89f3e.png',
			price = 0,
			area = {100, 50},
			align = {x = -50, y = -30},
			name = 'hay',
			credits = 'Iho#5679',
			grounds = function(x, y, id)
				addGround(id, x+52, y+27, {type = 14, height = 40, width = 90, friction = 0.3, restitution = 0.2})
			end,
			qpPrice = 5,
			type = 'especial',
			foreground = true,
			npcShop = 'marcus',
		},
		[13] = { -- vaso de flor
			image = '16db239d1c0.png',
			png = '16db2410054.png',
			price = 0,
			area = {33, 47},
			align = {x = -15, y = -30},
			name = 'flowerVase',
			qpPrice = 3,
			type = 'especial',
			npcShop = 'marcus',
		},
		[14] = { -- shelf
			image = '16db2425fb9.png',
			png = '16db243f19d.png',
			price = 0,
			area = {150, 50},
			align = {x = -50, y = -30},
			name = 'shelf',
			qpPrice = 5,
			type = 'especial',
			npcShop = 'marcus',
		},
		[15] = { -- cauldron
			image = '16dd6ba8ca9.png',
			png = '16de570ade0.png',
			price = 100,
			area = {100, 100},
			align = {x = -55, y = -82},
			name = 'cauldron',
			credits = 'Iho#5679',
			usable = function(player) 
				eventTextAreaCallback(0, player, 'recipes', true)
			end,
			qpPrice = 5,
			type = 'limited-halloween2019',
			limitedTime = os.time{day=11, year=2019, month=11},
		},
		[16] = { -- cross
			image = '16de58103e8.png',
			png = '16de570cce8.png',
			price = 100,
			area = {70, 81},
			align = {x = -35, y = -60},
			name = 'cross',
			credits = 'Iho#5679',
			qpPrice = 2,
			type = 'limited-halloween2019',
			limitedTime = os.time{day=11, year=2019, month=11},
		},
		[17] = { -- rip
			image = '16de576af32.png',
			png = '16de574fae2.png',
			price = 100,
			area = {51, 55},
			align = {x = -25, y = -30},
			name = 'rip',
			credits = 'Iho#5679',
			qpPrice = 2,
			type = 'limited-halloween2019',
			limitedTime = os.time{day=11, year=2019, month=11},
		},
		[18] = { -- pumpkin
			image = '16de5799419.png',
			png = '16de57bfce3.png',
			price = 100,
			area = {38, 35},
			align = {x = -17, y = -19},
			name = 'pumpkin',
			qpPrice = 2,
			type = 'limited-halloween2019',
			limitedTime = os.time{day=11, year=2019, month=11},
		},
		[19] = { -- spiderweb
			image = '16de5881d9e.png',
			png = '16de58c9497.png',
			price = 100,
			area = {100, 100},
			align = {x = -45, y = -60},
			name = 'spiderweb',
			credits = 'Iho#5679',
			qpPrice = 2,
			type = 'limited-halloween2019',
			limitedTime = os.time{day=11, year=2019, month=11},
		},
		[20] = { -- candle-Left
			image = '16de590d1f5.png',
			png = '16de593a900.png',
			price = 100,
			area = {70, 70},
			align = {x = -40, y = -100},
			name = 'candle',
			qpPrice = 1,
			type = 'limited-halloween2019',
			limitedTime = os.time{day=11, year=2019, month=11},
		},
		[21] = { -- candle-Right
			image = '16de59085fd.png',
			png = '16de58e577d.png',
			price = 100,
			area = {70, 70},
			align = {x = -35, y = -100},
			name = 'candle',
			qpPrice = 1,
			type = 'limited-halloween2019',
			limitedTime = os.time{day=11, year=2019, month=11},
		},
		[22] = { -- christmasSocks
			image = '16eef7f6dcf.png',
			png = '16ef9dd8e4d.png',
			price = 100,
			area = {25, 52},
			align = {x = -10, y = -65},
			name = 'christmasSocks',
			qpPrice = 1,
			type = 'limited-christmas2019',
			limitedTime = os.time{day=15, year=2020, month=1},
		},
		[23] = { -- christmasWreath
			image = '16ef9fa5b73.png',
			png = '16efa0210d1.png',
			price = 100,
			area = {41, 40},
			align = {x = -20, y = -70},
			name = 'christmasWreath',
			qpPrice = 2,
			type = 'limited-christmas2019',
			limitedTime = os.time{day=15, year=2020, month=1},
		},
		[24] = { -- christmasGift
			image = '16eef7eb241.png',
			png = '16f1a0c1c4e.png',
			price = 100,
			area = {37, 36},
			align = {x = -20, y = -20},
			name = 'christmasGift',
			qpPrice = 2,
			type = 'limited-christmas2019',
			limitedTime = os.time{day=15, year=2020, month=1},
		},
		[25] = { -- christmasSnowman
			image = '16eef7f1007.png',
			png = '16f1a10d79f.png',
			price = 100,
			area = {75, 75},
			align = {x = -40, y = -57},
			name = 'christmasSnowman',
			qpPrice = 2,
			type = 'limited-christmas2019',
			limitedTime = os.time{day=15, year=2020, month=1},
		},
		[26] = { -- christmasFireplace
			image = '16f1a26cfb8.png',
			png = '16f1a29f857.png',
			price = 500,
			area = {123, 53},
			align = {x = -55, y = -40},
			name = 'christmasFireplace',
			credits = 'Fofinhoppp#0000',
			qpPrice = 5,
			type = 'limited-christmas2019',
			limitedTime = os.time{day=15, year=2020, month=1},
		},
		[27] = { -- christmasCandyBowl
			image = '16f23c7c3dd.png',
			png = '16f23bed04e.png',
			price = 500,
			area = {42, 60},
			align = {x = -20, y = -41},
			name = 'christmasCandyBowl',
			credits = 'Iho#5679',
			qpPrice = 2,
			type = 'limited-christmas2019',
			limitedTime = os.time{day=15, year=2020, month=1},
		},
		[28] = { -- christmasCarnivorousPlant
			image = '16f23c49466.png',
			png = '16f23bf897f.png',
			price = 500,
			area = {50, 60},
			align = {x = -20, y = -40},
			name = 'christmasCarnivorousPlant',
			credits = 'Iho#5679',
			qpPrice = 2,
			type = 'limited-christmas2019',
			limitedTime = os.time{day=15, year=2020, month=1},
		},
		[29] = { -- apiary
			image = '1704e32c2df.png',
			png = '1704e327d8a.png',
			price = 500,
			area = {56, 48},
			align = {x = -20, y = -31},
			name = 'apiary',
			credits = 'Iho#5679',
			qpPrice = 200000,
			type = 'locked-quest05',
			npcShop = '-',
		},
		[30] = { -- hayWagon
			image = '17257bee13d.png',
			png = '17257c6d698.png',
			price = 0,
			area = {89, 60},
			align = {x = -40, y = -45},
			name = 'hayWagon',
			qpPrice = 10,
			npcShop = 'marcus',
		},
		[31] = { -- scarecrow
			image = '17257b96953.png',
			png = '17257c6f891.png',
			price = 0,
			area = {74, 100},
			align = {x = -40, y = -80},
			name = 'scarecrow',
			qpPrice = 10,
			npcShop = 'marcus',
		},
		[32] = { -- derp
			image = '17257cb03da.png',
			png = '17257ceff0a.png',
			price = 150,
			area = {39, 30},
			align = {x = -20, y = -14},
			name = 'derp',
		},
		[33] = { -- testTubes
			image = '17257e3ad59.png',
			png = '17257e7ef02.png',
			price = 150,
			area = {70, 40},
			align = {x = -35, y = -20},
			name = 'testTubes',
		},
		[34] = { -- bookcase
			image = '172584f6afe.png',
			png = '172586d18fd.png',
			price = 300,
			area = {100, 100},
			align = {x = -50, y = -84},
			name = 'bookcase',
		},
		[35] = { -- bed1
			image = '17258599c04.png',
			png = '172586a69c2.png',
			price = 500,
			area = {109, 80},
			align = {x = -50, y = -65},
			name = 'bed',
			grounds = function(x, y, id)
				addGround(id, 55+x, 64+y, {type = 14, height = 30, width = 109, friction = 0.3, restitution = 0.4})
			end,
			usable = function(player) 
				TFM.playEmote(player, 6)
			end,
		},
		[36] = { -- bed2
			image = '172585ca7c0.png',
			png = '172586a99c7.png',
			price = 500,
			area = {113, 80},
			align = {x = -58, y = -64},
			name = 'bed',
			grounds = function(x, y, id)
				addGround(id, 57+x, 68+y, {type = 14, height = 30, width = 109, friction = 0.3, restitution = 0.4})
			end,
			usable = function(player) 
				TFM.playEmote(player, 6)
			end,
		},
		[37] = { -- bed3
			image = '172585e3f6b.png',
			png = '172586abe28.png',
			price = 500,
			area = {122, 75},
			align = {x = -60, y = -57},
			name = 'bed',
			grounds = function(x, y, id)
				addGround(id, 60+x, 61+y, {type = 14, height = 30, width = 115, friction = 0.3, restitution = 0.4})
			end,
			usable = function(player) 
				TFM.playEmote(player, 6)
			end,
		},
		[38] = { -- bed4
			image = '17258605b47.png',
			png = '172586adf72.png',
			price = 500,
			area = {122, 90},
			align = {x = -60, y = -70},
			name = 'bed',
			grounds = function(x, y, id)
				addGround(id, 60+x, 76+y, {type = 14, height = 30, width = 109, friction = 0.3, restitution = 0.4})
			end,
			usable = function(player) 
				TFM.playEmote(player, 6)
			end,
		},
		[39] = { -- oven
			image = '1727c2f76d0.png',
			png = '1727c532471.png',
			qpPrice = 30,
			area = {47, 50},
			align = {x = -24, y = -32},
			name = 'oven',
			usable = function(player) 
				eventTextAreaCallback(0, player, 'recipes', true)
			end,
			npcShop = 'lucas',
		},
		[40] = { -- shelf
			image = '1727c37313a.png',
			png = '1727c51929b.png',
			qpPrice = 5,
			area = {78, 40},
			align = {x = -40, y = -80},
			name = 'shelf',
			npcShop = 'lucas',
		},
		[41] = { -- shelf
			image = '1727c3b69e2.png',
			png = '1727c51ad48.png',
			qpPrice = 5,
			area = {83, 40},
			align = {x = -41, y = -80},
			name = 'shelf',
			npcShop = 'lucas',
		},
		[42] = { -- kitchenCabinet
			image = '1727c3f228a.png',
			png = '1727c55b85f.png',
			qpPrice = 7,
			area = {38, 45},
			align = {x = -20, y = -30},
			name = 'kitchenCabinet',
			npcShop = 'lucas',
		},
		[43] = { -- kitchenCabinet
			image = '1727c41f8b8.png',
			png = '1727c557c96.png',
			qpPrice = 7,
			area = {38, 45},
			align = {x = -20, y = -30},
			name = 'kitchenCabinet',
			npcShop = 'lucas',
		},
		[44] = { -- diningTable
			image = '1727c4dcf4d.png',
			png = '1727c56f612.png',
			qpPrice = 20,
			area = {100, 52},
			align = {x = -50, y = -36},
			name = 'diningTable',
			npcShop = 'lucas',
			grounds = function(x, y, id)
				addGround(id, 48+x, 39+y, {type = 14, height = 20, width = 95, friction = 0.3, restitution = 0.2})
			end,
			usable = function(player) 
				TFM.playEmote(player, 8)
			end,
		},
		[45] = { -- orders list
			image = '17280c6fc9c.png',
			png = '17280c6fc9c.png',
			qpPrice = 100,
			area = {100, 90},
			align = {x = -50, y = -140},
			name = 'ordersList',
			limitedTime = os.time{day=15, year=2020, month=1},
		},
		[46] = { -- fence
			image = '17280f28298.png',
			png = '17280f7c480.png',
			qpPrice = 5,
			area = {100, 60},
			align = {x = -50, y = -43},
			name = 'fence',
			npcShop = 'marcus',
		},
		[47] = { -- white fence
			image = '17281365ac1.png',
			png = '172814c4d8b.png',
			qpPrice = 7,
			area = {100, 60},
			align = {x = -50, y = -43},
			name = 'fence',
			npcShop = 'marcus',
		},
		[48] = { -- nightstand
			image = '172bdbcce08.png',
			png = '172bdeb85a5.png',
			price = 300,
			area = {113, 100},
			align = {x = -50, y = -84},
			name = 'nightstand',
		},
		[49] = { -- nightstand
			image = '172bdc069fd.png',
			png = '172bdeba88a.png',
			price = 170,
			area = {61, 100},
			align = {x = -30, y = -84},
			name = 'nightstand',
		},
		[50] = { -- armchair
			image = '172bdc787db.png',
			png = '172bdea7a74.png',
			price = 100,
			area = {86, 62},
			align = {x = -43, y = -46},
			name = 'armchair',
			grounds = function(x, y, id)
				addGround(id, 43+x, 53+y, {type = 14, height = 18, width = 82, friction = 0.3, restitution = 0.2})
			end,
			usable = function(player) 
				TFM.playEmote(player, 8)
			end,
		},
		[51] = { -- bush
			image = '172bde4589f.png',
			png = '172bdecc84c.png',
			qpPrice = 2,
			area = {85, 70},
			align = {x = -45, y = -53},
			name = 'bush',
			npcShop = 'marcus',
		},
	},
	levelIcons = {
		star = {},
		lvl = {
			{'1716449ea8f.png'},
			{'171644abf4d.png'},
			{'171644be6a2.png'},
			{'171644c49d4.png'},
			{'171644d91a3.png'},
			{'171644dc2b4.png'},
			{'171644e665e.png'},
			{'171644ead84.png'},
			{'171644efe60.png'},
			{'17162238351.png'},
		},
	},
	credits = {
		translations = {['Bodykudo#0000'] = 'ar', ['Chamelinct#0000'] = 'es', ['Zielony_olii#8526'] = 'pl', ['Melikefn#0000'] = 'tr', ['Danielthemouse#6206'] = 'il', ['Francio2582#3155'] = 'fr', ['Godzi#0941'] = 'pl', ['Noooooooorr#0000'] = 'ar', ['Tocutoeltuco#0000'] = 'es', ['Weth#9837'] = 'hu', ['Zigwin#0000'] = 'ru'},
		arts = {'Iho#5679', 'Kariina#0000', 'Mescouleur#0000'},
		creator = {'Fofinhoppp#0000'},
		help = {'Bolodefchoco#0000', 'Laagaadoo#0000', 'Lucasrslv#0000', 'Tocutoeltuco#0000'},
	},
}
local npcsStores = {
	items = {},
	shops = {
		marcus = {}, chrystian = {}, jason = {}, john = {}, indy = {}, kariina = {}, body = {}, lucas = {}, all = {},
	},
}
local community = {
    xx = "1651b327097.png",
    ar = "1651b32290a.png",
    bg = "1651b300203.png",
    br = "1651b3019c0.png",
    cn = "1651b3031bf.png",
    cz = "1651b304972.png",
    de = "1651b306152.png",
    ee = "1651b307973.png",
    en = "1651b30da90.png",
    es = "1651b309222.png",
    fi = "1651b30aa94.png",
    fr = "1651b30c284.png",
    gb = "1651b30da90.png",
    hr = "1651b30f25d.png",
    hu = "1651b310a3b.png",
    id = "1651b3121ec.png",
    il = "1651b3139ed.png",
    he = "1651b3139ed.png",
    it = "1651b3151ac.png",
    jp = "1651b31696a.png",
    lt = "1651b31811c.png",
    lv = "1651b319906.png",
    nl = "1651b31b0dc.png",
    ph = "1651b31c891.png",
    pl = "1651b31e0cf.png",
    ro = "1651b31f950.png",
    ru = "1651b321113.png",
    tr = "1651b3240e8.png",
    vk = "1651b3258b3.png"
}
local dialogs = {}
local npcDialogs = {
	normal = {},
	quests = {},
}
local houseTerrainsAdd = {
	plants = {
		[0] = { -- default
			name = '???',
			growingTime = 0,
			stages = {'16bf63634a0.png'},
			quantyOfSeeds = 0,
		},
		[1] = { -- tomato
			name = 'tomato',
			growingTime = 60*3,
			stages = {'16bf63634a0.png', '16bf63b93cf.png', '16bf64806c6.png', '16bf64b8df5.png', '16c2544e15f.png', '16c2546d829.png'},
			quantyOfSeeds = 5,
			pricePerSeed = 10,
		},
		[2] = { -- oregano
			name = 'oregano',
			growingTime = 60*4,
			stages = {'16bf63634a0.png', '16bf63b93cf.png', '16bf64806c6.png', "16c2ad0f76a.png", "16c2acd5534.png"},
			quantyOfSeeds = 5,
			pricePerSeed = 30,
		},
		[3] = { -- lemon
			name = 'lemon',
			growingTime = 60*6,
			stages = {'16bf63634a0.png', '16bf63b93cf.png', '16bf64806c6.png', "16bfca9b802.png", "16bfcaa09ed.png", '16bfca975e5.png'},
			quantyOfSeeds = 3,
			pricePerSeed = 120,
		},
		[4] = { -- pepper
			name = 'pepper',
			growingTime = 60*3,
			stages = {'16bf63634a0.png', '16bf63b93cf.png', '16bf64806c6.png', '16c25569bf0.png', '16c2556b669.png', '16c2556cfb9.png'},
			quantyOfSeeds = 5,
			pricePerSeed = 70,
		},
		[5] = { -- luckyFlower
			name = 'luckyFlower',
			growingTime = 60*15,
			stages = {'16bf63634a0.png', '16bf63b93cf.png', '16c2580e482.png', '16c258100b7.png', '16c25811d3b.png', '16c25813c4c.png', '16c258182a0.png'},
			quantyOfSeeds = 1,
			pricePerSeed = 10000,
		},
		[6] = { -- wheat
			name = 'wheat',
			growingTime = 60*7,
			stages = {'16bf63634a0.png', '16bf63b93cf.png', '16c2ad99a4a.png', "16c2adf9395.png", "16d9c73c301.png"},
			quantyOfSeeds = 5,
			pricePerSeed = 40,
		},
		[7] = { -- pumpkin
			name = 'pumpkin',
			growingTime = 60*5,
			stages = {'16bf63634a0.png', '16bf63b93cf.png', '16da90fd0ad.png', '16da90fe81f.png', "16da905bd71.png"},
			quantyOfSeeds = 1,
			pricePerSeed = 150,
		},
		[8] = { -- blueberries
			name = 'blueberries',
			growingTime = 60*7,
			stages = {'16bf63634a0.png', '16bf63b93cf.png', '16bf64806c6.png', '16f1e9f4d55.png', '16f1e9fc472.png', "16f1ea01892.png"},
			quantyOfSeeds = 2,
			pricePerSeed = 400,
		},
		[9] = { -- banana
			name = 'banana',
			growingTime = 60*12.5,
			stages = {'16bf63634a0.png', '16bf63b93cf.png', '17276940ecb.png', '1727693f16f.png', '1727693d907.png', "1727693bc5b.png"},
			quantyOfSeeds = 5,
			pricePerSeed = 0,
		},
	},
	--[[
	[0] = '16bf63634a0.png',
	[1] = '16bf63b93cf.png',
	[2] = '16bf64806c6.png',
	[3] = '16bf64b8df5.png',
	[4] = '16bf64beec7.png',
	[5] = '16bf64bbe99.png',]]--
}
local houseTerrains = {
	[0] = {
		name = 'grass',
		png = '16c0abef269.png',
		price = 100,
		add = function(owner, y, terrainID, plotID, guest)
			addGround(- 2000 - (terrainID-1)*30 - plotID, ((terrainID-1)%terrainID)*1500+737 + (plotID-1)*175, y+170, {type = 5, width = 175, height = 90, friction = 0.3})
			room.houseImgs[terrainID].expansions[#room.houseImgs[terrainID].expansions+1] = addImage('16bce83f116.jpg', '!1', ((terrainID-1)%terrainID)*1500+738-(175/2) + (plotID-1)*175, y+170-45, guest)
		end,
	},
	[1] = {
		name = 'pool',
		png = '16c0abf2610.png',
		price = 2000,
		add = function(owner, y, terrainID, plotID, guest)
			addGround(- 2000 - (terrainID-1)*30 - plotID, ((terrainID-1)%terrainID)*1500+737 + (plotID-1)*175, y+170, {type = 12, miceCollision = false, color = 0x00CED1, width = 175, height = 90})
			room.houseImgs[terrainID].expansions[#room.houseImgs[terrainID].expansions+1] = addImage('16bc4577c60.png', '!1', ((terrainID-1)%terrainID)*1500+737-(175/2) + (plotID-1)*175, y+170-30, guest)
		end,
	},
	[2] = {
		name = 'garden',
		png = '16c0abf41c9.png',
		price = 4000,
		add = function(owner, y, terrainID, plotID, guest)
			addGround(- 2000 - (terrainID-1)*30 - plotID, ((terrainID-1)%terrainID)*1500+737 + (plotID-1)*175, y+170, {type = 5, width = 175, height = 90, friction = 0.3})
			if players[owner].houseTerrainPlants[plotID] == 0 then players[owner].houseTerrainPlants[plotID] = 1 end
			local stage = houseTerrainsAdd.plants[players[owner].houseTerrainPlants[plotID]].stages[players[owner].houseTerrainAdd[plotID]]
			room.houseImgs[terrainID].expansions[#room.houseImgs[terrainID].expansions+1] = addImage('16bf5b9e800.jpg', '!1', ((terrainID-1)%terrainID)*1500+738-(175/2) + (plotID-1)*175, y+170-45, guest)
			room.houseImgs[terrainID].expansions[#room.houseImgs[terrainID].expansions+1] = addImage(stage, '!2', ((terrainID-1)%terrainID)*1500+738-(175/2) + (plotID-1)*175, y+170-45-280, guest)
			if owner == 'Oliver' then 
				room.houseImgs[terrainID].expansions[#room.houseImgs[terrainID].expansions+1] = addImage(stage, '?10', 11330 + (plotID-1)*65, 7470+30, guest)
			end
		end,
	},
}
local jobs = {
	fisher = {
		color 	= '32CD32',
		coins	= '15 - $10.000</font>',
		working = {},
		players	= 0,
		icon = '171d2134def.png', 
	}, 
	police = {
		color 	= '4169E1',
		coins	= 120,
		working = {},
		players	= 10,
		icon = '171d1f8d911.png',
	},
	thief = {
		color 	= 'CB546B',
		coins	= 250,
		bankRobCoins = 1100,
		working = {},
		players	= 0,
		icon = '171d20cca72.png',
	},
	miner = {
		color 	= 'B8860B',
		coins	= 0,
		working = {},
		players	= 0,
		icon = '171d21cd12d.png',
	},
	farmer = {
		color 	= '9ACD32',
		coins	= '10 - $10.000</font>',
		working = {},
		players	= 0,
		icon = '171d1e559be.png',
		specialAssets = function(player)
			for i = 1, 4 do
				if players['Oliver'].houseTerrainAdd[i] >= #houseTerrainsAdd.plants[players['Oliver'].houseTerrainPlants[i]].stages then
					local y = 1500 + 90
					ui.addTextArea('-730'..(tonumber(i)..tonumber(players['Oliver'].houseData.houseid)*10), '<a href="event:harvest_'..tonumber(i)..'"><p align="center"><font size="15">'..translate('harvest', player)..'</font></p></a>', player, ((tonumber(11)-1)%tonumber(11))*1500+738-(175/2)-2 + (tonumber(i)-1)*175, y+150, 175, 150, 0xff0000, 0xff0000, 0)
				end
			end
		end,
	},
	chef = {
		color 	= '00CED1',
		coins	= '10 - $10.000</font>',
		working = {},
		players	= 0,
		icon = '171d20548bd.png',
	},
	ghostbuster = {
		color 	= 'FFE4B5',
		coins	= 300,
		players	= 0,
	},
	ghost = {
		color 	= 'A020F0',
		coins	= 100,
		players	= 0,
	},
}
local badges = {
	[0] = { -- Halloween2019
		png = '16de63ec86f.png',
	},
	[1] = { -- meet Fofinhoppp
		png = '171e0f4e290.png',
	},
	[2] = { -- fish 500 times
		png = '171dba5770c.png',
	},
	[3] = { -- mine 1000 gold nuggets
		png = '171e1010745.png',
	},
	[4] = { -- harvested 500 plants
		png = '171e0f9de0e.png',
	},
	[5] = { -- Rob 500 times
		png = '16f1a7af2f0.png',
	},
	[6] = { -- Christmas2019
		png = '16f23df7a05.png',
	},
	[7] = { -- Buy the sleigh
		png = '16f1fe3812d.png',
	},
	[8] = { -- Sell 500 seeds
		png = '171db390cbe.png',
	},
	[9] = { --Fulfill 500 orders
		png = '171db534474.png',
	},
	[10] = { -- Arrest 500 players
		png = '171db99a9e3.png',
	},
}
local places = {
	market = {
		opened	= '08:00 21:00',
		tp		= {3600, 250},
		town_tp = {3473, 7770},
		saida	= {{3300, 3500}, {0, 300}},
		saidaF	= function(player)
			TFM.movePlayer(player, 3473, 7770, false)
			players[player].place = 'town'
			return true
		end
	},
	hospital = {
		opened = '-',
		tp		= {4600, 3650},
		saida	= {{4650, 4800}, {3400, 3700}},
		saidaF	= function(player)
			TFM.movePlayer(player, 4850, 7770, false)
			players[player].place = 'town'
			showOptions(player)
			return true
		end
	},
	police = {
		opened	= '-',
		tp		= {220+7100, 265+5950},
		saida	= {{7130, 7300}, {6116, 6230}},
		saidaF	= function(player)
			TFM.movePlayer(player, 1090, 7570, false)
			players[player].place = 'town'
			return true
		end
	},
	buildshop = {
		opened	= '08:00 19:00',
		tp		= {200, 250},
		town_tp = {495, 7570},
		saida	= {{0, 180}, {50, 300}},
		saidaF	= function(player)
			TFM.movePlayer(player, 495, 7570, false)
			players[player].place = 'town'
			return true
		end,
	},
	dealership = {
		opened	= '07:00 19:00',
		tp		= {8710, 240},
		town_tp = {5400, 7770},
		saida	= {{8000, 8680}, {0, 300}},
		saidaF	= function(player)
			TFM.movePlayer(player, 5000, 7770, false)
			players[player].place = 'town'
			return true
		end
	},
	bank = {
		opened	= '07:00 19:00',
		tp		= {5538, 5238},
		town_tp = {2775, 7770},
		clickDistance = {{5460, 5615}, {5100, 5250}},
		saida	= {{5273, 6012}, {5100, 5250}},
		saidaF 	= function(player)
			if ROOM.playerList[player].x > 5460 and ROOM.playerList[player].x < 5615 and ROOM.playerList[player].y > 5100 and ROOM.playerList[player].y < 5250 then
				ui.addTextArea(-5551, "<font color='#FFFFFF' size='40'><a href='event:getOut_bank'>• •", player, 5508, 5150, nil, nil, 1, 1, 0, false)
				return true
			else
				ui.removeTextArea(-5551, player)
				return
			end
		end
	},
	pizzeria = {
		opened	= '-',
		tp		= {14200, 250},
		town_tp = {4410, 7770},
		saida	= {{14000, 14150}, {50, 300}},
		saidaF	= function(player)
			TFM.movePlayer(player, 4410, 7770, false)
			players[player].place = 'town'
			return true
		end,
	},
	fishShop = {
		opened	= '-',
		tp		= {12700, 250},
		town_tp = {6030, 7770},
		saida	= {{12600, 12695}, {50, 300}},
		saidaF	= function(player)
			TFM.movePlayer(player, 6030, 7770, false)
			players[player].place = 'town'
			return true
		end,
	},
	furnitureStore = {
		opened = '08:00 19:00',
		tp		= {16150, 248},
		town_tp = {5770, 7770},
		saida	= {{16000, 16100}, {100, 250}},
		saidaF	= function(player)
			TFM.movePlayer(player, 5770, 7770, false)
			players[player].place = 'town'
			return true
		end,
	},
	town = {
		opened	= '-',
		saida	= {{0, 1649}, {7600, 7800}},
		saidaF	= function(player)
			players[player].place = 'mine'
			checkIfPlayerIsDriving(player)
			if players[player].questLocalData.other.goToMine then
				quest_updateStep(player)
			end
			return true
		end
	},
	mine = {
		opened	= '-',
		saida	= {{995, 6000}, {7600, 8670}},
		saidaF	= function(player)
			local x = ROOM.playerList[player].x
			local y = ROOM.playerList[player].y
			if x >= 1650 and x <= 6000 and y >= 7600 and y <= 7800 then 
				players[player].place = 'town'
				return true
			elseif x >= 995 and x <= 1100 and y >= 8490 and y <= 8670 then 
				TFM.movePlayer(player, 1220, 8670, false)
				players[player].place = 'mine_labyrinth'
				setNightMode(player)
				return true
			end
		end
	},
	mine_labyrinth = {
		opened	= '-',
		saida	= {{1100, 1200}, {8490, 8670}},
		saidaF	= function(player)
			players[player].place = 'mine'
			TFM.movePlayer(player, 990, 8632, false)
			showOptions(player)
			return true
		end
	},
	mine_escavation = {
		opened = '-',
		saida 	= {{5355, 5470}, {7830, 8200}},
		saidaF 	= function(player)
			players[player].place = 'town'
			TFM.movePlayer(player, 5415, 7770, false)
		end
	},
	--- island
	cafe = {
		opened	= '-',
		tp		= {6150, 250},
		saida	= {{6000, 6140}, {50, 300}},
		saidaF	= function(player)
			TFM.movePlayer(player, 10470, 7770, false)
			players[player].place = 'island'
			return true
		end,
	},
	potionShop = {
		opened = '11:00 19:00',
		tp		= {10620, 248},
		island_tp = {9895, 7770},
		saida	= {{10500, 10615}, {100, 250}},
		saidaF	= function(player)
			TFM.movePlayer(player, 9895, 7770, false)
			players[player].place = 'island'
			return true
		end,
	},
	seedStore = {
		opened = '10:00 19:00',
		tp		= {11500, 248},
		island_tp = {12000, 7770},
		saida	= {{11350, 11460}, {100, 250}},
		saidaF	= function(player)
			TFM.movePlayer(player, 12000, 7770, false)
			players[player].place = 'island'
			return true
		end,
	},
}
local Mine = {
	position = {4536, 8643},
	area = {10, 60},
	availableRocks = {},
	blocks = {},
	blockLength = 60,
	ores = {
		yellow = {
			img = '1722e1e84dc.png',
			rarity = 12,
		},
		blue = {
			img = '1722e1eccc0.png',
			rarity = 7,
		},
		purple = {
			img = '1722e1e56b7.png',
			rarity = 4,
		},
		green = {
			img = '1722e1eab1c.png',
			rarity = 3,
		},
		red = {
			img = '1722e1e3389.png',
			rarity = 2,
		},
	},
	stones = {
		{
			name = 'sand',
			health = 2,
			ground = 7,
			image = '171fa7a17c1.png',
		},
		{
			name = 'dirt',
			health = 5,
			ground = 5,
			image = '171fa80941f.jpg',
		},
		{
			name = 'coal',
			health = 20,
			ground = 4,
			image = '1721aa68210.png',
			ores = {'yellow', 'blue'},
		},
		{
			name = 'stone',
			health = 50,
			ground = 10,
			image = '171fa7cdbc2.png',
			ores = {'yellow', 'blue', 'purple'},
		},
		{
			name = 'lava',
			health = 200,
			ground = 3,
			image = '171fa832ec8.png',
			ores = {'yellow', 'blue', 'purple', 'green'},
		},
		{
			name = 'diamont',
			health = 500,
			ground = 1,
			image = '171fa8b16dd.jpg',
			ores = {'yellow', 'blue', 'purple', 'green', 'red'},
		},
		{
			name = 'tiplonium',
			health = 1000,
			ground = 11,
			image = '1722e396406.png',
			ores = {'yellow', 'blue', 'purple', 'green', 'red'},
		},
		{
			name = 'chernobyl',
			health = 2000,
			ground = 11,
			image = '1722e4b0bfb.png',
			ores = {'yellow', 'blue', 'purple', 'green', 'red'},
		},
		{
			name = 'chernobyl2',
			health = 5000,
			ground = 15,
			image = '1722e5fe753.png',
			ores = {'yellow', 'blue', 'purple', 'green', 'red'},
		},
	},
}
local grid = {}
local grid_width = Mine.area[1]
local grid_height = 1
local groundIDS = {}
local maxFurnitureStorage = 50
local maxFurnitureDepot = 60

local version = {3, 0, 0}
local versionLogs = {
	['v3.0.0'] = {
		releaseDate = '12/06/2020', -- dd/mm/yy
		maxPages = 1,
		images = {'172a97d8145.png'},
		BR = {
			name = 'A nova atualização chegou!',
			_1 = '<rose>Novo:</rose> Mapa redesenhado!\n\n<rose>Novos lugares:</rose> Restaurante, Loja de barcos e Loja de pesca!\n\n<rose>Novo trabalho:</rose> Cozinheiro!\nFale com Remi e comece a fazer pratos deliciosos!\n\n<rose>Nova mina:</rose> Novas áreas: labirinto, esgoto e zona de escavação!\nAdicionado um novo sistema de mineração.\n\nE muito mais!',
		},
		EN = {
			name = 'Our newest update is here!',
			_1 = '<rose>New:</rose> Map update!\n\n<rose>New places:</rose> Restaurant, Boat shop and Fish shop!\n\n<rose>New job:</rose> Chef!\nTalk with Remi and start cooking delicious dishes!\n\n<rose>New mine:</rose> New places: labyrinth, sewer, and excavation area!\nAdded a new mining system.\n\nAnd a lot more!'
		},
		HU = {
            name = 'Itt a legújabb frissítésünk!',
            _1 = '<rose>Új:</rose> Pálya frissítés!\n\n<rose>Új helyek:</rose> Étterem, Hajóbolt és Halbolt!\n\n<rose>Új munka:</rose> Séf!\nBeszélj Remi-vel és kezdj el finom ételeket főzni!\n\n<rose> Új helyek: labirintus, szennyvízcsatorna, és ásatási terület!\nHozzáadva egy új bányászati rendszer.\n\nÉs még sok más!'
        },
        FR = {
             name = 'Notre dernière mise à jour est arrivée!',
             _1 = '<rose>Nouveauté:</rose> Mise à jour de la carte!\n\n<rose>Nouveaux lieux:</rose> Restaurant, Boutique de bâteaux and Poissonnerie!\n\n<rose>Nouveau métier:</rose> Chef!\nParlez avec Remi et commencez à cuisiner de délicieux plats!\n\n<rose>Nouvelle mine:</rose> Nouveaux lieux: labyrinthe, égouts, et zone d\'excavation!\nAjout d\'un nouveau système de minage.\n\nEt bien plus!'
        },
        HE = {
            name = 'העדכון הכי חדש שלנו כאן!',
            _1 = '<rose>חדש:</rose> עדכון מפה!\n\n<rose>מקומות חדשים:</rose> מסעדה, חנות סירות וחנות דגים!\n\n<rose>עבודה חדשה:</rose> שף!\nדברו עם רמי והתחילו לבשל מאכלים טעימים!\n\n<rose>מכרה חדש:</rose> מקומות חדשים: לבירינת, ביוב, ואיזור חפירה!\nנוספה מערכת חציבה חדשה.\n\nועוד הרבה יותר!'
        },
        TR = {
            name = 'Yeni güncellememiz çıktı!',
            _1 = '<rose>Yeni:</rose> Harita güncellemesi!\n\n<rose>Yeni mekanlar:</rose> Restorant, Tekne dükkanı ve Balık dükkanı!\n\n<rose>Yeni meslek:</rose> Şef!\nRemi ile konuş ve şahane yiyecekler pişir!\n\n<rose>Yeni maden:</rose> Yeni mekanlar: labirent, lağım ve kazı alanı!\nYeni madencilik sistemi eklendi.\n\nVe çok daha fazlası!'
        },
        AR = {
		    name = '!آخر تحديث لدينا هنا',
		    _1 = '<rose>جديد:</rose>تحديث الخريطة!\n\n<rose>أماكن جديدة:</rose> مطعم ، متجر قوارب ومتجر أسماك!\n\n<rose>وظيفة جديدة:</rose> طاهٍ!\nتحدث مع ريمي وابدأ في طهي أطباق لذيذة!\n\n<rose>مَنجم جديد:</rose> المتاهة والصرف الصحي ومنطقة الحفر!\n.تمت إضافة نظام تعدين جديد\n\n!والكثير'
		},
	},
}

local imgsToLoad = {'1721ee7d5b9.png', '17184484e6b.png', '1718435fa5c.png', '171843a9f21.png', '171d2134def.png', '171d20cca72.png', '171d1f8d911.png', '171d21cd12d.png', '171d1e559be.png', '171d20548bd.png', '171d1933add.png', '1717aae387a.jpg', '1717a86b38f.png', '171d2a2e21a.png', '171d28150ea.png', '171d6f313c8.png',}
local lang = {}

local questsAvailable = 4
local sideQuests = {
	[1] = { -- Plant 5 seeds in oliver's house
		type = 'type:plant;oliver',
		quanty = 5,
		points = 2,
	},
	[2] = { -- Fertilize 3 plants in oliver's house
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
	[14] = { -- Fish 3 Lionfishes
		type = 'type:fish;fish_Lionfish',
		quanty = 3,
		points = 10,
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
}
local img = ''
local typeimg = '!100'
local imgAtual = '15ae9936899.png'
local pos = {x = 0, y = 0}

local codesIds = {
	[0] = {n = 'WELCOME'},
	[1] = {n = 'BOOM'},
	[2] = {n = 'OFFICIAL'},
	[3] = {n = 'GOLD'},
	[4] = {n = 'MYCITY'},
	[5] = {n = 'WINTER'},
	[6] = {n = 'XMAS'},
	[7] = {n = 'BLUEBERRY'},
	[8] = {n = 'COINS'},
	[9] = {n = 'GARDENING'},
	[10] = {n = 'XP'},
	[11] = {n = 'FLOUR'},
}
local codes = {
	['WELCOME'] = {
		id = 0,
		uses = 1,
		available = false,
	},
	['BOOM'] = {
		id = 1,
		uses = 1,
		available = false,
	},
	['OFFICIAL'] = {
		id = 2,
		uses = 1,
		available = false,
	},
	['GOLD'] = {
		id = 3,
		uses = 1,
		available = false,
	},
	['MYCITY'] = {
		id = 4,
		uses = 1,
		available = false,
	},
	['WINTER'] = {
		id = 5,
		uses = 1,
		available = false,
		level = 3,
	},
	['XMAS'] = {
		id = 6,
		uses = 1,
		available = false,
		level = 4,
	},
	['BLUEBERRY'] = {
		id = 7,
		uses = 1,
		available = false,
		level = 3,
	},
	['COINS'] = {
		id = 8,
		uses = 1,
		available = false,
		level = 2,
	},
	['GARDENING'] = {
		id = 9,
		uses = 1,
		available = false,
		level = 3,
	},
	['XP'] = {
		id = 10,
		uses = 1,
		available = true,
		reward = function(player)
			giveExperiencePoints(player, 500)
			alert_Error(player, 'atmMachine', 'codeReceived', translate('experiencePoints', player)..': 500')
		end,
	},
	['FLOUR'] = {
		id = 11,
		uses = 1,
		available = true,
		level = 3,
		reward = function(player)
			addItem('wheatFlour', 8, player)
			alert_Error(player, 'atmMachine', 'codeReceived', translate('item_wheatFlour', player)..': 8')
		end,
	},
}

local bagUpgrades = {
	[20] = '170fa52959e.png',
	[25] = '170fa52b3f4.png',
	[30] = '170fa52d22d.png',
	[35] = '170fa52ed70.png',
	[40] = '1710c4d7d09.png',
	[45] = '172af53daad.png',
}