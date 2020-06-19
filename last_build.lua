--[[ main.lua ]]--
local TFM 			= tfm.exec
local ROOM 			= tfm.get.room
local string 		= string
local math 			= math
local table 		= table 
local gsub 			= string.gsub

local addGround 	= TFM.addPhysicObject
local removeGround 	= TFM.removePhysicObjec
local addTextArea 	= ui.addTextArea
local move 			= TFM.movePlayer

local addImage 		= TFM.addImage
local removeImage 	= TFM.removeImage

local bagIds, bagItems, recipes, modernUI, HouseSystem, _QuestControlCenter

local chatCommands = {}

math.randomseed(os.time())

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

local players = {}
local room = { -- Assets that can change while the script runs
	maxPlayers = 15,
	gameLoadedTimes = 0,
	fileUpdated = false,
	dayCounter = 0,
	mathSeed = os.date("%j"),
	rankingImages = {},
	droppedItems = {},
	terrains = {},
	gardens = {},
	unranked = {'Bodykudo#0000', 'Benaiazyux#0000', 'Fofinhoppp#0000', 'Ffmisael#0000', 'Mavin2#0000', 'Giud#9046', 'Mavin3#8659', 'Euney#5983', 'Ppp001#0000'},
	bannedPlayers = {'Fontflex#0000', 'Luquinhas#6375', 'Luquinhas#9650', 'Mandinhamita#0000', 'Furoaazui#0000', 'Rainhadetudo#6235', 'Gohanffglkj#9524', 'Mycity#3262', 'Mavin2#0000', 'Giud#9046', 'Mavin3#8659', 'Euney#5983', 'C4ver4_ghost#1459'},
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
					addGround(-6500+terrainID*20, 290 + (terrainID-1)*1500 + 60, 1397 + 65, {type = 12, friction = 0.3, restitution = 0.2, width = 480, height = 30})
					addGround(-6501+terrainID*20, 225 + (terrainID-1)*1500 + 60, 1397 + 200, {type = 12, friction = 0.3, restitution = 0.2, width = 350, height = 15})
					addGround(-6502+terrainID*20, 055 + (terrainID-1)*1500 + 60, 1397 + 160, {type = 12, friction = 0.3, restitution = 0.2, height = 190})
					addGround(-6503+terrainID*20, 525 + (terrainID-1)*1500 + 60, 1397 + 160, {type = 12, friction = 0.3, restitution = 0.2, height = 190})
					addGround(-6504+terrainID*20, 480 + (terrainID-1)*1500 + 60, 1397 + 310, {type = 12, friction = 0.3, restitution = 0.9, width = 105, height = 20})
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
					addGround(-6500+terrainID*20, 345 + (terrainID-1)*1500 + 60, 1397 + 307, {type = 13, friction = 0.3, restitution = 1, width = 20})
					addGround(-6501+terrainID*20, 118 + (terrainID-1)*1500 + 60, 1397 + 307, {type = 13, friction = 0.3, restitution = 1, width = 20})
					addGround(-6502+terrainID*20, 188 + (terrainID-1)*1500 + 60, 1397 + 182, {type = 12, friction = 0.3, restitution = 0.2, width = 260})
					addGround(-6503+terrainID*20, 460 + (terrainID-1)*1500 + 60, 1397 + 170, {type = 12, friction = 0.3, restitution = 0.2, width = 180})		
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
					addGround(-6500+terrainID*20, 201 + (terrainID-1)*1500 + 60, 1397 + 138, {type = 12, friction = 0.3, restitution = 0.2, width = 280, height = 20})
					addGround(-6501+terrainID*20, 463 + (terrainID-1)*1500 + 60, 1397 + 138, {type = 12, friction = 0.3, restitution = 0.2, width = 130, height = 20})
					addGround(-6502+terrainID*20, 290 + (terrainID-1)*1500 + 60, 1397 + 038, {type = 12, friction = 0.3, restitution = 0.2, width = 180, height = 20})
					addGround(-6503+terrainID*20, 373 + (terrainID-1)*1500 + 60, 1397 + 307, {type = 13, friction = 0.3, restitution = 1, width = 20})
					addGround(-6504+terrainID*20, 505 + (terrainID-1)*1500 + 60, 1397 + 114, {type = 13, friction = 0.3, restitution = 1, width = 20})	
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
					addGround(-6500+terrainID*20, 230 + (terrainID-1)*1500 + 60, 1397 + 140, {type = 12, friction = 0.3, restitution = 0.2, width = 346, height = 20})
					addGround(-6501+terrainID*20, 315 + (terrainID-1)*1500 + 60, 1397 + -52, {type = 12, friction = 0.3, restitution = 0.2, width = 170, height = 20})
					addGround(-6502+terrainID*20, 458 + (terrainID-1)*1500 + 60, 1397 + 310, {type = 12, friction = 0.3, restitution = 1, width = 107, height = 30})
					addGround(-6503+terrainID*20, 195 + (terrainID-1)*1500 + 60, 1397 + 127, {type = 12, friction = 0.3, restitution = 1, width = 43, height = 30})
					addGround(-6504+terrainID*20, 420 + (terrainID-1)*1500 + 60, 1397 + -50, {type = 12, friction = 0.3, restitution = 0.2, width = 480, height = 30, angle = 58})
					addGround(-6505+terrainID*20, 155 + (terrainID-1)*1500 + 60, 1397 + -50, {type = 12, friction = 0.3, restitution = 0.2, width = 480, height = 30, angle = -58})
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
					addGround(-6500+terrainID*20, 235 + (terrainID-1)*1500 + 60, 1397 + 001, {type = 12, friction = 0.3, restitution = 0.2, width = 460, height = 20})
					addGround(-6501+terrainID*20, 440 + (terrainID-1)*1500 + 60, 1397 + 151, {type = 12, friction = 0.3, restitution = 0.2, width = 220, height = 20})
					addGround(-6502+terrainID*20, 345 + (terrainID-1)*1500 + 60, 1397 + 210, {type = 12, friction = 20, restitution = 0.2, width = 30, height = 130})
					addGround(-6503+terrainID*20, 445 + (terrainID-1)*1500 + 60, 1397 + 050, {type = 12, friction = 20, restitution = 0.2, width = 30, height = 90})
					addGround(-6504+terrainID*20, 399 + (terrainID-1)*1500 + 60, 1397 + -182, {type = 12, friction = 0.3, restitution = 0.2, width = 300, height = 20})
					addGround(-6505+terrainID*20, 091 + (terrainID-1)*1500 + 60, 1397 + -182, {type = 12, friction = 0.3, restitution = 0.2, width = 145, height = 20})
					addGround(-6506+terrainID*20, 149 + (terrainID-1)*1500 + 60, 1397 + -110, {type = 12, friction = 20, restitution = 0.2, width = 30, height = 130})
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
	roles = {
		admin = {'Fofinhoppp#0000', 'Lucasrslv#0000'},
		mod = {},
		helper = {'Weth#9837'},
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
			addGround(- 2000 - (terrainID-1)*30 - plotID, (terrainID-1)*1500+737 + (plotID-1)*175, y+170, {type = 5, width = 175, height = 90, friction = 0.3})
			room.houseImgs[terrainID].expansions[#room.houseImgs[terrainID].expansions+1] = addImage('16bce83f116.jpg', '!1', (terrainID-1)*1500+738-(175/2) + (plotID-1)*175, y+170-45, guest)
		end,
	},
	[1] = {
		name = 'pool',
		png = '16c0abf2610.png',
		price = 2000,
		add = function(owner, y, terrainID, plotID, guest)
			addGround(- 2000 - (terrainID-1)*30 - plotID, (terrainID-1)*1500+737 + (plotID-1)*175, y+170, {type = 12, miceCollision = false, color = 0x00CED1, width = 175, height = 90})
			room.houseImgs[terrainID].expansions[#room.houseImgs[terrainID].expansions+1] = addImage('16bc4577c60.png', '!1', (terrainID-1)*1500+737-(175/2) + (plotID-1)*175, y+170-30, guest)
		end,
	},
	[2] = {
		name = 'garden',
		png = '16c0abf41c9.png',
		price = 4000,
		add = function(owner, y, terrainID, plotID, guest)
			addGround(- 2000 - (terrainID-1)*30 - plotID, (terrainID-1)*1500+737 + (plotID-1)*175, y+170, {type = 5, width = 175, height = 90, friction = 0.3})
			if players[owner].houseTerrainPlants[plotID] == 0 then players[owner].houseTerrainPlants[plotID] = 1 end
			local stage = houseTerrainsAdd.plants[players[owner].houseTerrainPlants[plotID]].stages[players[owner].houseTerrainAdd[plotID]]
			room.houseImgs[terrainID].expansions[#room.houseImgs[terrainID].expansions+1] = addImage('16bf5b9e800.jpg', '!1', (terrainID-1)*1500+738-(175/2) + (plotID-1)*175, y+170-45, guest)
			room.houseImgs[terrainID].expansions[#room.houseImgs[terrainID].expansions+1] = addImage(stage, '!2', (terrainID-1)*1500+738-(175/2) + (plotID-1)*175, y+170-45-280, guest)
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

local version = {3, 0, 1}
local versionLogs = {
	['v3.0.1'] = {
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

--[[ api/table.lua ]]--
table.contains = function(table, val)
   for i = 1, #table do
      if table[i] == val then
         return true
      end
   end
   return false
end

table.copy = function(obj, seen)
	if type(obj) ~= 'table' then return obj end
	if seen and seen[obj] then return seen[obj] end
	local s = seen or {}
	local res = setmetatable({}, getmetatable(obj))
	s[obj] = res
	for k, v in next, obj do 
		res[table.copy(k, s)] = table.copy(v, s)
	end
	return res
end

table.concatFancy = function(tbl, sepMiddle, sepFinal, j)
	sepFinal = sepFinal or sepMiddle or ''
	j = j or #tbl
	return table.concat(tbl, sepMiddle, 1, j - 1) .. sepFinal .. tbl[j]
end

table.getLength = function(tbl)
	local length = 0
	for _ in next, tbl do 
		length = length + 1
	end
	return length
end

table.merge = function(this, src)
	for k, v in next, src do
		if this[k] then
			if type(v) == "table" then
				this[k] = string.toTable(this[k])
				table.merge(this[k], v)
			else
				this[k] = this[k] or v
			end
		else
			this[k] = v
		end
	end
end

table.randomKey = function(tbl)
    local key
    local counter = 0
    for k in next, tbl do
        counter = counter + 1
        if math.random() < (1 / counter) then
            key = k
        end
    end
    return key
end

--[[ api/string.lua ]]--
string.nick = function(name)
	if not name then return end
    local var = name:lower():gsub('%a', string.upper, 1)
	for i, v in next, ROOM.playerList do
		if i:find(var) then
			return i
		end
	end
end

string.replace = function(name, args)
	for i, v in next, args do 
		if i == '{1}' then 
			args[i] = '<font color="#7bbd40">'..v..'</font>'
		else 
			args[i] = translate(v, name)
		end
	end
	local str = translate('multiTextFormating', name)
	return (gsub(str, '{.-}', args, #str /3))
end

string.toTable = function(x)
	return (type(x) == "table" and x or {x})
end

--[[ api/math.lua ]]--
math.hypo = function(x1, y1, x2, y2)
	return ((x2-x1)^2 + (y2-y1)^2)^0.5
end
	
math.range = function(polygon, point)
    local oddNodes = false
    local j = #polygon
    for i = 1, #polygon do
        if (polygon[i].y < point.y and polygon[j].y >= point.y or polygon[j].y < point.y and polygon[i].y >= point.y) then
            if (polygon[i].x + ( point.y - polygon[i].y ) / (polygon[j].y - polygon[i].y) * (polygon[j].x - polygon[i].x) < point.x) then
                oddNodes = not oddNodes;
            end
        end
        j = i;
    end
    return oddNodes 
end

--[[ translations/_langIDS.lua ]]--
local lang = {}
local langIDS = {
	[0] = 'en',
	[1] = 'br',
	[2] = 'fr',
	[3] = 'es',
	[4] = 'hu',
	[5] = 'de',
	[6] = 'pl',
	[7] = 'ar',
	[8] = 'tr',
	[9] = 'ru',
	[10] = 'he',
}

--[[ translations/ar.lua ]]--
lang.ar = {
    item_crystal_green = "كريستال أخضر",
    item_fish_RuntyGuppy = "سمكة الجوبي",
    landVehicles = "البرية",
    item_pumpkinSeed = "بذرة يقطين",
    item_garlic = "ثوم",
    item_fish_Dogfish = "كلب البحر",
    boats = "القوارب",
    item_blueberries = "توت",
    furniture_christmasCandyBowl = "وعاء الحلوى",
    settings_creditsText2 = ".شكر خاص لـ<v>%s</v> للمساعدة في الموارد المهمة في النمط",
    houseSettings_placeFurniture = "وضع",
    item_lemon = "ليمون",
    _2ndquest = "مهمة جانبية",
    vehicle_11 = "يخت",
    itemDesc_pickaxe = "تكسر الصخور",
    item_cornFlakes = "رقائق الذرة",
    furnitures = "الأثاث",
    item_tomato = "طماطم",
    item_cheese = "جبنة",
    saveChanges = ".حفظ التغييرات",
    playerBannedFromRoom = "لقد تم حظر %s من هذه الغرفة",
    newLevel = "!مستوى جديد",
    houseSettings_reset = "إعادة تعيين",
    permissions_blocked = "محظور",
    item_coffee = "قهوة",
    goTo = "إذهب إلى",
    elevator = "المصعد",
    fishingError = ".أنت لم تعُد تصطاد بعد الآن",
    noMissions = ".لا يوجد مهمات متاحة",
    ranking_Season = "%s الموسم",
    job = "العمل",
    houseSettings_permissions = "الصلاحيات",
    item_fish_Lobster = "سرطان البحر",
    sell = "بيع",
    furniture_christmasSnowman = "رجل ثلجي",
    furniture_christmasSocks = "جوارب عيد الميلاد",
    runAwayCoinInfo = "سوف تحصل على %s بعد إنهاء هذه السرقة.",
    item_sauce = "صلصة",
    houseSettings_lockHouse = "قَفل المنزل",
    error_houseUnderEdit = "!يقوم بتعديل المنزل %s",
    settings_config_lang = "اللغة",
    item_wheat = "قمح",
    House4 = "إسطبل",
    remove = "نزع",
    itemDesc_clock = "ساعة بسيطة يمكن استعمالها مرة واحدة",
    rewardNotFound = "المكافأة غير موجودة.",
    badgeDesc_4 = "حصد 500 نبتة",
    cook = "طهو",
    furniture_bed = "سرير",
    seeItems = "مراجعة الأغراض",
    furniture_painting = "لوحة",
    furniture_christmasGift = "صندوق الهدايا",
    item_fish_Frog = "ضفدع",
    settingsText_availablePlaces = "الأماكن المتاحة: <vp>%s</vp>",
    yes = "نعم",
    houseDescription_5 = "!المنزل الحقيقي للأشباح. كُن حذرًا",
    permissions_guest = "زائر",
    newUpdate = "!تحديث جديد",
    expansion_pool = "حوض سباحة",
    itemAddedToChest = ".أضيف إلى الصندوق %s الغرض",
    fishWarning = "لا يُمكنك أن تصطاد هنا",
    furniture_derp = "حمامة",
    closed_bank = "البنك مغلق.عُد لاحقًا",
    profile_arrestedPlayers = "اللاعبين الذين تم القبض عليهم",
    item_lemonSeed = "بذرة ليمون",
    receiveQuestReward = "طالب بالمكافأة",
    settings_helpText2 = ":الأوامر المتوفرة",
    item_salt = "ملح",
    hungerInfo = "<v>%s</v> من الجوع",
    codeNotAvailable = "هذا الرمز غير متاح",
    item_frogSandwich = "سندويشة ضفادع",
    buy = "شراء",
    using = "بإستعمال",
    npcDialog_Alexa = "أهلًا. ما هو الجديد؟",
    robberyInProgress = "هنالك سرقة قيد التنفيذ",
    settingsText_grounds = "%s/509 :الأراضي المولدة",
    confirmButton_Buy2 = "%s شراء\n%s مقابل",
    itemDesc_shrinkPotion = "استعمل هذه الجرعة للإنكماش لمدة %s ثانية!",
    badgeDesc_9 = "تنفيذ 500 طلب",
    moneyError = ".ليس لديك المبلغ الكافي",
    bagError = ".المساحة في الحقيبة غير كافية",
    playerUnbannedFromRoom = "تم فك حظر %s.",
    npc_mine6msg = "يُمكن لهذا المكان أن ينهار في أي وقت، لكن لا أحد يستمع لي.",
    hunger = "الجوع",
    passwordError = ".رمز واحد على الأقل",
    House6 = "منزل الكريسمس",
    no = "لا",
    item_bruschetta = "بروشيتا",
    vehicle_6 = "قارب صيد",
    npcDialog_Santih = ".هناك الكثير من الناس الذين لا يزالون يجرؤون على الصيد في هذه البركة",
    item_water = "دلو مياه",
    houseDescription_1 = "منزل صغير",
    profile_purchasedCars = "العربات التي تم شراؤها",
    item_fish_Lionfish = "سمكة التنين",
    item_fertilizer = "سماد",
    furniture_spiderweb = "شبكة عنكبوت",
    houseDescription_2 = ".منزل كبير للعائلات الكبيرة مع مشاكل كبيرة",
    itemDesc_minerpack = "تحتوي على %s فؤوس.",
    sellFurnitureWarning = "هل تريد حقًا بيع هذا الأثاث؟\n<r>!لا يمكن التراجع عن هذا الإجراء</r>",
    npcDialog_Marie = "*-* أنا أحببببب الجبن",
    pickaxeError = ".يجب أن تشتري فأسًا",
    settings_creditsText = "<j>#Mycity</j> صنعت بواسطة: <v>%s</v>, باستخدام الرسومات من: <v>%s</v> و تُرجمت بواسطة:",
    house = "المنزل",
    closed_market = ".المحل مغلق. عٌد لاحقًا",
    pizzaMaker = "صانع البيتزا",
    use = "استعمال",
    confirmButton_Great = "!عظيم",
    npcDialog_Davi = ".أنا آسف ولكن لا يمكنني السماح لك بالذهاب من هذا الطريق",
    rewardText = "!لقد تلقيت مكافأة لا تصدق",
    furniture_christmasFireplace = "مدفأة",
    price = "السعر: %s",
    House2 = "منزل عائلي",
    permissions_owner = "مالك",
    permissions_coowner = "المالك المشارك",
    item_tomatoSeed = "بذرة طماطم",
    newBadge = "وسام جديد",
    speed = "السرعة: %s",
    furniture_chest = "صندوق",
    itemDesc_goldNugget = ".لامع وغالي",
    confirmButton_Sell = "%s بيع مقابل",
    sideQuests = {
        [1] = ".ازرع  %s Oliver نبته في حديقة",
        [2] = ".قُم بتسميد %s Oliver نبته في حديقة",
        [3] = ".احصل على %s من المال",
        [4] = ".إقبض على لص %s مرات",
        [5] = ".استخدم %s عناصر",
        [6] = ".أنفق %s من المال",
        [7] = ".قم بصيد السمك %s مرات",
        [8] = ".قم باستخراج %s قطعة خام من الذهب",
        [9] = ".قم بسرقة البنك بدون أن يُقبض عليك",
        [10] = ".أتمم %s سرقات",
        [11] = ".اطبخ %s مرات",
        [12] = ".احصل على %s نقاط خبرة",
        [13] = ".قم باصطياد %s ضفدع",
        [14] = ".قم باصطياد %s سمكة تنين",
        [15] = ".قم بتوصيل %s طلبات",
        [16] = ".قم بتوصيل %s طلبات",
        [17] = ".قم بعمل بيتزا",
        [18] = ".قُم بعمل بروشيتا",
        [19] = ".قُم بعمل عصير ليمون",
        [20] = ".قُم بعمل سندويشة ضفادع"
    },
    npcDialog_Paulo = "...هذا الصندوق ثقيل حقًا\nسيكون من الجيد إن كان لدينا رافعة شوكية هنا.",
    item_luckyFlowerSeed = "بذرة زهرة الحظ",
    item_seed = "بذرة",
    settingsText_hour = "الساعة الآن: <vp>%s</vp>",
    sellGold = "بيع %s قطعة ذهب مقابل <vp>%s</vp>",
    houseDescription_6 = ".سوف يجلب لك هذا المنزل المريح الراحة حتى في الأيام الباردة",
    itemInfo_Seed = "<vp>%sدقيقة</vp> :وقت النمو\n<vp>$%s</vp>:السعر للبذرة",
    levelUp = "!%s وصل إلى المستوى %s",
    sleep = "النوم",
    item_superFertilizer = "سماد خارق",
    newQuestSoon = " :/ المهمة الـ %s غير متوفرة حاليًا\n<font size=\"11\">%s%% :مرحلة التطوير",
    settings_help = "مساعدة",
    badgeDesc_1 = "#mycity قابل منشئ نمط",
    item_waffles = "فطائر",
    profile_jobs = "وظائف",
    placeDynamite = "وضع الديناميت",
    vehicle_5 = "قارب",
    quest = "المهمات",
    closed_furnitureStore = ".متجر الأثاث مغلق ، عُد لاحقًا",
    arrestedPlayer = "!<v>%s</v> لقد قبضتَ على",
    error = "خطأ",
    item_milkShake = "حليب مخفوق",
    confirmButton_Select = "اختيار",
    alert = "!إنذار",
    noEnergy = ".تحتاج الى المزيد من الطاقة للعمل مجددًا",
    closed_buildshop = ".متجر البناء مغلق، عُد لاحقًا",
    runAway = "أهرب في خلال %s ثواني",
    maxFurnitureDepot = ".مستودع الأثاث الخاص بك ممتلئ",
    npcDialog_Billy = "!لا استطيع الانتظار لسرقة البنك الليلة",
    vehicleError = ".لا يمكنك استخدام هذه المركبة في هذا المكان",
    item_oregano = "أوريجانو",
    npcDialog_Pablo = "...إذًا ، تريد أن تكون لصًا؟ لدي شعور أنك شرطي سري\n.أوه،أنت لست كذلك؟ حسنًا ، سأصدقك بعد ذلك\nأنت الآن لص ولديك القدرة على سرقة الشخصيات ذات الاسم الوردي بالضغط على زر المسطرة/المسافة. تذكر أن تبتعد عن رجال الشرطة",
    expansion_garden = "المزرعة",
    leisure = "الراحة",
    healing = "ستُشفى بعد %s ثواني",
    items = "الأغراض:",
    profile_completedQuests = "المهمات",
    House5 = "قصر مسكون",
    completedQuest = "المهمات المنتهية",
    profile_coins = "المال",
    furniture_rip = "قبر",
    houseSetting_storeFurnitures = "قم بتخزين جميع الأثاث في المستودع",
    mine5error = "المنجم انهار",
    goldAdded = "قطعة الذهب التي حصلت عليها تم اضافتها إلى حقيبتك.",
    furniture_shelf = "رف",
    password = "كلمة المرور",
    emergencyMode_able = "<r>أَخرى #mycity بدء إغلاق الطوارئ ، لا يسمح للاعبين بالدخول يرجى الإنتقال إلى غرفة",
    itemDesc_dynamite = "!بووم",
    item_lobsterBisque = "حساء سرطان البحر",
    item_hotChocolate = "شيكولاتة ساخنة",
    hey = "!مهلًا! توقف",
    atmMachine = "ATM",
    harvest = "حصاد",
    bag = "الحقيبة",
    npcDialog_Weth = "*-* بودينق",
    minerpack = "حزمة منقب %s",
    badgeDesc_2 = "صيد 500 سمكة",
    settings_credits = "ائتمانات",
    item_wheatFlour = "دقيق القمح",
    houseSettings_changeExpansion = "تغيير الأرض",
    percentageFormat = "%s%%",
    shop = "المتجر",
    questCompleted = ":جائزتك هي ! %s\n لقد أكملت مهمة",
    furniture_hayWagon = "عربة القش",
    closed_dealership = "متجر السيارات مغلق،عُد لاحقًا.",
    codeReceived = "جائزتك هي: %s.",
    profile_badges = "الأوسمة",
    item_pudding = "بودينغ",
    furniture_candle = "شمعة",
    bankRobAlert = "!تتم سرقة البنك. قم بحمايته",
    item_shrinkPotion = "جرعة الانكماش",
    item_bread = "رغيف من الخبز",
    closed_potionShop = "متجر الجرعات مغلق. عُد لاحقًا",
    npcDialog_Cassy = "!أتمنى لك يومًا جيدًا",
    vehicle_12 = "بوغاتي",
    speed_knots = "عُقَدْ",
    item_milk = "زجاجة حليب",
    itemDesc_fertilizer = "!اجعل البذور تنموا أسرع",
    houseDescription_7 = ".منزل للذين يحبون الاستيقاظ في أحضان الطبيعة",
    incorrect = "غير صحيح",
    npcDialog_Lauren = ".هي تحب الجبن",
    drop = "إسقاط",
    npcDialog_Louis = "...قلت لها ألا تضع الزيتون",
    soon = "!قريبا",
    furniture_bookcase = "مكتبة",
    item_energyDrink_Ultra = "كوكا-كولا",
    profile_completedSideQuests = "المهمات الجانبية",
    item_pierogies = "بَيْرُوغَات",
    frozenLake = ".البحيرة متجمدة ، إنتظر لينتهي الشتاء لتستخدم القارب",
    confirmButton_tip = "تلميح",
    furniture_flowerVase = "مزهرية",
    error_boatInIsland = "لا يمكنك استعمال القارب بعيدًا عن البحر",
    House3 = "منزل مسكون",
    item_crystal_yellow = "كريستال أصفر",
    item_pepper = "فلفل",
    item_luckyFlower = "زهرة الحظ",
    item_garlicBread = "خبز بالثوم",
    createdBy = "%s صُنعت بواسطة",
    item_pepperSeed = "بذرة الفلفل",
    emergencyMode_pause = "<r>لقد وصل النمط إلى الحد الحساس و سيتم إيقافه مؤقتًا<cep><b>[تحذير]</b>",
    vehicles = "المركبات",
    profile_purchasedHouses = "المنازل التي تم شراؤها",
    houseSettings = "إعدادات المنزل",
    profile_capturedGhosts = "أشباح تم القبض عليها",
    experiencePoints = "نقاط الخبرة",
    item_hotsauce = "صلصة حارة",
    item_dough = "عجينة",
    item_wheatSeed = "بذرة قمح",
    confirmButton_Work = "!إعمل",
    item_pizza = "بيتزا",
    copError = "يجب أن تنتظر 10 ثواني للقبض على شخصٍ ما مجددًا.",
    item_potato = "بطاطا",
    maxFurnitureStorage = ".أثاث في منزلك %s يمكنك فقط الحصول على",
    waitUntilUpdate = "<rose>انتظر رجاءً</rose>",
    permissions_roommate = "شريك السكن",
    itemDesc_water = "!يجعل البذور تنموا أسرع",
    furniture_scarecrow = "فزاعة",
    syncingGame = "<r>.مزامنة بيانات اللعبة. ستتوقف اللعبة لبضع ثوانٍ",
    furniture_sofa = "أريكة",
    itemAmount = "%s :الأغراض",
    item_energyDrink_Basic = "سبرايت",
    setPermission = "قم بجعله %s",
    closed_seedStore = ".متجر البذور مغلق. عد لاحقًا",
    furniture_tv = "تلفاز",
    error_blockedFromHouse = ".%s لقد تم منعك من دخول منزل",
    npcDialog_Kapo = ".آتي دائمًا إلى هنا للتحقق من عروض ديف اليومية \n!في بعض الأحيان أحصل على عناصر نادرة يمتلكها هو فقط",
    furnitureRewarded = "%s : تم فتح الأثاث",
    timeOut = "هذا المكان غير متاح.",
    badgeDesc_3 = "إستخرج 1000 قطعة من الذهب الخام ",
    reward = "جائزة",
    profile_fulfilledOrders = "طلبات ",
    furniture = "أثاث المنزل",
    houseSettings_buildMode = "وضع البناء",
    item_salad = "سلطة",
    itemDesc_superFertilizer = ".إنه أكثر فاعلية بمرتين من السماد العادي",
    item_dynamite = "ديناميت",
    seedSold = ".%s مقابل %s لقد تلقيت",
    settings_settings = "الإعدادات",
    profile_basicStats = "البيانات العامة",
    item_growthPotion = "جرعة التكبير",
    badgeDesc_7 = "اشترى مزلقة",
    energyInfo = "<v>%s</v> من الطاقة",
    waitingForPlayers = "...في انتظار اللاعبين",
    profile_spentCoins = "العملات المصروقة",
    item_egg = "بيضة",
    copAlerted = ".تم تحذير الشرطة",
    item_oreganoSeed = "بذرة أوريجانو",
    code = ".إكتب رمز",
    sidequestCompleted = "لقد أتممت مهمة جانبية\n جائزتك:",
    profile_robbery = "السرقات",
    pickaxes = "الفؤوس",
    House1 = "كلاسيكي",
    npcDialog_Natasha = "!مرحبًا",
    furniture_cauldron = "مرجل",
    npcDialog_Goldie = ".هل تريد بيع الكريستال؟ أسقطه بجانبي حتى أتمكن من تقدير سعره",
    profile_seedsPlanted = "المحاصيل",
    profile_seedsSold = "مبيعات",
    badgeDesc_6 = "عيد الميلاد المجيد 2019",
    furniture_hay = "قش",
    item_grilledLobster = "كركند مشوي",
    chef = "طباخ",
    codeAlreadyReceived = ".تم استعمال هذا الرمز بالفعل",
    daysLeft = "يوم%s تبقى",
    eatItem = "أكل",
    daysLeft2 = "%sيوم",
    close = "إغلاق",
    updateWarning = "<font size=\"10\"><rose><p align=\"center\">تحذير!</p></rose>\nيوجد تحديث جديد خلال %s دقيقة و %s ثانية",
    npcDialog_Julie = ".كن حذرا. هذا السوبر ماركت خطير للغاية",
    furniture_christmasWreath = "اكليل عيد الميلاد",
    item_honey = "عسل",
    item_bag = "حقيبة",
    npcDialog_Jason = ".مرحبًا... متجري لا يعمل للمبيعات حتى الآن\n!أرجوك عد قريبًا",
    ghostbuster = "مطارد الأشباح",
    furniture_cross = "صليب",
    houseDescription_4 = ".هل تعبت من العيش في مدينة؟ بحوزتنا ما تحتاج",
    tip_vehicle = ".انقر على النجمة بجوار أيقونة مركبتك لجعلها مركبتك المفضلة\nبلوحة المفاتيح F أو G اضغط\n.لاستخدام سيارتك أو قاربك المفضل بشكل مباشر",
    event_halloween2019 = "هالوين 2019",
    codeInfo = "أدخل رمزًا صالحًا واضغط موافق لتحصل على جائزتك.\nيُمكنك الحصول على أكواد جديدة بالانضمام لمخدمنا على ديسكورد.\n<a href=\"event:getDiscordLink\"><v>(اضغط هنا للحصول على رابط الدعوة)</v></a>",
    limitedItemBlock = "يجب عليك الإنتظار %s\n.ثانية لتستخدم هذا الغرض مرة أُخرى",
    settingsText_createdAt = ".دقيقة <vp>%s</vp> تم إنشاء الغرفة قبل",
    police = "شرطي",
    furniture_diningTable = "طاولة طعام",
    recipes = "وصفات",
    alreadyLand = ".لقد امتلك لاعب على هذه الأرض بالفعل",
    unlockedBadge = "!لقد فتحت وسام جديد",
    badgeDesc_0 = "هالوين 2019",
    ranking_coins = "العملات المتحصل عيلها",
    itemDesc_seed = "بذرة عشوائية.",
    questsName = "المهمات",
    collectorItem = "أغراض الجامع",
    furniture_oven = "الفرن",
    locked_quest = "%s مهمة",
    energy = "الطاقة",
    itemDesc_bag = "+ %s مساحة الحقيبة",
    emergencyMode_resume = "<r>.تم استئناف النمط",
    item_blueberriesSeed = "بزرة توت",
    item_lemonade = "عصير ليمون",
    houses = "المنازل",
    vehicle_9 = "مزلقة",
    House7 = "بيت الشجرة",
    level = "%s المستوى",
    expansion = "التوسعات",
    furniture_christmasCarnivorousPlant = "نبات آكل للحوم",
    furniture_testTubes = "أنابيب إختبار",
    newLevelMessage = "!تهانينا! لقد وصلت إلى مستوى أعلى",
    settings_helpText = "!<j>#Mycity</j> مرحبًا بك في\n :إذا كنت تريد معرفة كيفية اللعب ، فاضغط على الزر أدناه",
    itemDesc_growthPotion = "استعمل هذه الجرعة للتكبير لمدة %s ثانية!",
    expansion_grass = "العشب",
    itemDesc_cheese = "!استعمل هذا الغرض لكي تحصل على جبنة في متجر ترانسفورمايس",
    item_fish_SmoltFry = "سمكة سلمون صغيرة",
    item_chocolateCake = "كعكة الشوكولاتة",
    item_fish_Catfish = "سمك السلور",
    settingsText_currentRuntime = " 60ms <r>%s</r>/ مدة العرض:",
    settingsText_placeWithMorePlayers = "الأماكن التي تحتاج لمزيد من اللاعبين: <vp>%s</vp> <r>(%s)</r>",
    thief = "سارق",
    profile_questCoins = "نقاط المهمات",
    settings_gamePlaces = "الأماكن",
    looseMgs = "سيتم إطلاق سراحك بعد %s ثواني.",
    npcDialog_Blank = "هل تريد شيء مني؟",
    item_crystal_red = "كريستال أحمر",
    badgeDesc_5 = "أكمل 500 سرقة",
    cancel = "إلغاء",
    itemInfo_miningPower = "%s :إلحاق الضرر بالصخور",
    transferedItem = "تم نقله إلى حقيبتك %s الغرض",
    captured = "<g>!تم القبض عليه <v>%s</v> السارق",
    item_crystal_blue = "كريستال أزرق",
    open = "مفتوح",
    miner = "عامل منجم",
    ghost = "شبح",
    farmer = "مُزارع",
    settings_donateText = ".<j>#Mycity</j> مشروع بدأ في <b><cep>2014</cep></b>, لكن بطريقة لعب أخرى: <v>بناء مدينة</v>! لكن هذا المشروع لم يمضِ قدمًا وتم إلغاؤه بعد أشهر\n في <b><cep>2017</cep></b>, قررت إعادته بهدف جديد: <v>العيش في مدينة</v>!\n\n<v>طويلة و متعبه</v> معظم الوظائف المتاحة قمت بها لفترة\n\n !إذا استطعت وأنت قادر على مساعدتي ، قم بالتبرع. فهذا يشجعني على تقديم تحديثات جديدة",
    closed_police = "مقر الشرطة مغلق. تعال مجددًا لاحقًا.",
    codeLevelError = "لكي تتمكن من استعمال هذا الرمز%s عليك أن تصبح في المستوى",
    chestIsFull = ".الصندوق ممتلئ",
    profile_fishes = "صيد",
    furniture_apiary = "صندوق النحل",
    item_pickaxe = "فأس",
    item_crystal_purple = "كريستال بنفسجي",
    passToBag = "نُقل إلى الحقيبة",
    item_goldNugget = "قطعة ذهب",
    orderCompleted = "لقد قمت بتسليم طلب %s و تلقيت %s!",
    furniture_fence = "سور",
    profile_cookedDishes = "الأطباق المطبوخة",
    submit = "موافق",
    sellFurniture = "بيع الأثاث",
    quests = {
        [2] = {
            [0] = {
                _add = ".اذهب إلى الجزيرة"
            },
            [7] = {
                dialog = ".أخيرًا! يجب أن تولي المزيد من الاهتمام ، كان بإمكاني مشاهدة فيلم بينما كنت أنتظرك\n!هل ما زلت تريد الذهاب إلى المتجر؟ أنا ذاهب إلى هناك",
                _add = "Indyأحضر المفتاح لـ"
            },
            [1] = {
                dialog = "...مهلا! من أنت؟ لم أرك من قبل\n.اسمي إندي! أنا أعيش في هذه الجزيرة منذ فترة طويلة. هناك أماكن رائعة لزيارتها هنا\n!أنا صاحب متجر الجرع. يمكنني دعوتك لدخول إلى متجر ، ولكن لدي مشكلة واحدة كبيرة: لقد فقدت مفاتيح متجري\nلا بد أنني فقدتهم في المنجم بينما كنت استخرج المعادن. هل بإمكانك مساعدتي؟",
                _add = "Indy تَحدث مع"
            },
            [2] = {
                _add = ".إذهب إلى المنجم"
            },
            [4] = {
                dialog = "!شكرا لك! الآن يمكنني العودة إلى العمل\n...انتظر ثانية\nمفتاح واحد مفقود: مفتاح المتجر! هل بحثت بشكل جيد؟",
                _add = "Indyأحضر المفاتيح لـ."
            },
            [5] = {
                _add = ".قُم بالعودة إلى المنجم"
            },
            name = "المهمة 02: المفاتيح المفقودة",
            [3] = {
                _add = ".ابحث عن مفاتيح إندي"
            },
            [6] = {
                _add = ".ابحث عن المفتاح الأخير"
            }
        },
        [3] = {
            [0] = {
                _add = ".اذهب إلى مركز الشرطة"
            },
            [2] = {
                _add = ".إذهب إلى البنك"
            },
            [4] = {
                _add = ".عُد إلى مركز الشرطة"
            },
            [8] = {
                _add = ".اذهب إلى مركز الشرطة"
            },
            [16] = {
                dialog = ".أحسنت! أنت جيد حقًا في ذلك\n!أعرف مكانًا رائعًا لاستعادة طاقاتك بعد هذا المشوار الطويل: المقهى",
                _add = ".Sherlock تحدث مع"
            },
            [9] = {
                dialog = ".ممتاز! يمكن أن يساعدنا هذا القماش في العثور على المشتبه فيه\n.تحدث مع إندي. سيساعدنا",
                _add = ".Sherlock تحدث مع"
            },
            [5] = {
                dialog = "...كنت أعلم أنه لن يريد مساعدتنا\n.سيتعين علينا البحث عن أدلة بدونه\nنحن بحاجة للذهاب إلى البنك عندما يرحل كولت ، يمكنك فعل ذلك ، أليس كذلك؟",
                _add = ".Sherlock تحدث مع"
            },
            [10] = {
                dialog = "لذا ... ستحتاج مساعدتي في هذا التحقيق؟\n...همم ... دعني أرى هذا القماش\n!لقد رأيت هذا القماش في مكان ما. يتم استخدامه في المستشفى! قم بإلقاء نظره هناك",
                _add = ".Indy تَحدث مع"
            },
            [11] = {
                _add = ".إذهب إلى المستشفى"
            },
            [3] = {
                dialog = ".ماذا؟ أرسلك شيرلوك إلى هنا؟ أخبرته أنني سأهتم بهذه القضية\n.أخبره أنني لست بحاجة إلى المساعدة. يمكنني التعامل معها بنفسي",
                _add = ".Colt تكلم مع"
            },
            [6] = {
                _add = ".أدخل إلى البنك في أثناء سرقته"
            },
            [12] = {
                _add = ".ابحث عن شيء مريب في المستشفى"
            },
            [13] = {
                _add = ".إذهب إلى المنجم"
            },
            name = "المهمة 03: السرقة",
            [14] = {
                _add = ".ابحث عن المشتبه به واقبض عليه"
            },
            [1] = {
                dialog = ".مرحبًا. نحن نفتقر إلى ضباط الشرطة في مدينتنا وأنا بحاجة لمساعدتك ، ولكن لا شيء صعب للغاية\n... كان هناك سرقة غامضة في البنك ، حتى الآن لم يتم العثور على أي مشتبه فيه\n.أعتقد أن هناك بعض الأدلة في البنك\n.كولت يجب أن يعلم كيف حدث ذلك،قم بالتحدث معه",
                _add = ".Sherlock تحدث مع"
            },
            [7] = {
                _add = ".ابحث عن بعض الأدلة في البنك"
            },
            [15] = {
                _add = ".إذهب إلى مركز الشرطة"
            }
        },
        [1] = {
            [0] = {
                dialog = "أهلا! كيف حالك؟ اكتشف بعض الأشخاص مؤخرًا جزيرة صغيرة بعد البحر.يوجد هناك العديد من الأشجار وبعض المباني أيضًا\n.كما تعلم ، لا يوجد مطار في المدينة. الطريقة الوحيدة للوصول إلى هناك في الوقت الحالي هي من خلال قارب\n.يمكنني بناء واحد لك ، لكني سأحتاج إلى بعض المساعدة أولاً\n.في مغامرتي التالية ، أود أن أعرف ما يوجد في الجانب الآخر من المنجم. لدي بعض النظريات وأحتاج إلى تأكيدها\n.أعتقد أنها ستكون رحلة طويلة ، لذا سأحتاج إلى الكثير من الطعام\nهل يمكنك صيد 5 أسماك لي؟",
                _add = ".Kane تحدث مع"
            },
            [7] = {
                dialog = "!شكرا لمساعدتي! هذعه هي الألواح الخشبية التي طلبتها مني. قم بالاستفادة منها بشكل جيد",
                _add = ".Chrystian تحدث مع"
            },
            [1] = {
                _add = ".قُم بصيد %s سمكة"
            },
            [2] = {
                dialog = ".رائع! شكرا لك على هذه الأسماك! لا استطيع الانتظار لآكلهم في بعثتي\n.الآن ، عليك إحضار 3 كوكا كولا إلي. يمكنك شرائها في المتجر",
                _add = ".Kane تحدث مع"
            },
            [4] = {
                dialog = ".شكرا لجلب لي المواد الغذائية! الآن ، حان دوري لإردَّ الجميل\n.ولكن من أجل القيام بذلك ، سأحتاج إلى بعض الألواح الخشبية حتى أتمكن من بناء قارب\n.يقطع الأشجار ويجمع الخشب. اسأله إذا كان يمكنه أن يمنحك بعض الألواح الخشبية Chrystian رأيت مؤخرًا",
                _add = ".Kane تحدث مع"
            },
            [8] = {
                dialog = "... لقد استغرقت وقتًا طويلاً ... اعتقدت أنك نسيت الحصول على الألواح الخشبية\n... بالمناسبة ، الآن يمكنني بناء قاربك\n!ها هو القارب الخاص بك! استمتع في الجزيرة الجديدة ولا تنس أن تكون حذرًا",
                _add = ".Kane تحدث مع"
            },
            [5] = {
                dialog = ".هل تريد ألواح خشبية؟ يمكنني أن أعطيك بعضًا ، لكنك ستحتاج إلى إحضار لي رقائق الذرة\nهل يمكنك فعل هذا؟",
                _add = ".Chrystian تحدث مع"
            },
            name = "المهمة 01: بناء قارب",
            [3] = {
                _add = "كوكا-كولا %s اشتري"
            },
            [6] = {
                _add = "قم بشراء رقائق الذرة"
            }
        },
        [4] = {
            [0] = {
                dialog = "مرحبًا! هل تريد بعض البيتزا؟\n.حسنًا...لدي بعض الأخبار السيئة لك\n.اليوم في وقت سابق بدأت في صنع بعض البيتزا ، لكنني لاحظت أن جميع الصلصة قد اختفت\n.حاولت شراء بعض الطماطم في السوق ولكن يبدو أنهم لا يبيعونها\n.بدأت العيش في هذه البلدة منذ أسابيع قليلة ، ولا أعرف أي شخص يمكنه مساعدتي\n.لذا أرجوك ، هل يمكنك مساعدتي؟ أنا فقط بحاجة إلى الصلصة لفتح مطعم البيتزا الخاص بي",
                _add = ".Kariina تحدث مع"
            },
            [2] = {
                _add = ".اذهب إلى متجر البذور"
            },
            [4] = {
                _add = ".اذهب إلى منزلك"
            },
            [8] = {
                _add = ".اشتري دلو مياه"
            },
            [16] = {
                dialog = "!يا الهي! أنت فعلت ذلك! شكرا لك\nأثناء ذهابك ، أدركت أنني بحاجة إلى مزيد من القمح لصنع المزيد من العجين ... فهل يمكنك إحضار بعض القمح؟",
                _add = ".Kariinaاعطي الصلصة الحارة لـ"
            },
            [17] = {
                _add = ".ازرع بذرة في منزلك"
            },
            [9] = {
                _add = ".اذهب إلى المتجر"
            },
            [18] = {
                _add = ".قم بحصد القمح"
            },
            [5] = {
                _add = "(!ازرع بذرة في منزلك. (ستحتاج إلى استخدام حديقة"
            },
            [10] = {
                _add = ".اشتري بعض الملح"
            },
            [11] = {
                _add = "(اطبخ صلصة. (ستحتاج إلى استخدام فرن"
            },
            [3] = {
                _add = ".قم ببيع بذرة"
            },
            [6] = {
                _add = ".احصد نبات الطماطم"
            },
            [12] = {
                dialog = "رائع! شكرا لك! الآن أنا فقط بحاجة إلى صلصة حارة. هل يمكنك صنع واحدة؟",
                _add = ".Kariinaأعطِ الصلصة لـ"
            },
            [13] = {
                _add = ".ازرع بذرة في منزلك"
            },
            name = "!المهمة 04: اختفت الصلصة",
            [14] = {
                _add = "قم بحصاد نبات الفلفل"
            },
            [1] = {
                _add = ".اذهب إلى الجزيرة"
            },
            [7] = {
                _add = ".اذهب إلى متجر البذور"
            },
            [15] = {
                _add = ".اطبخ صلصة حارة"
            },
            [19] = {
                dialog = ".رائع! شكرا لك! يمكنك العمل معي عندما أحتاج إلى موظف جديد\n!شكرا لمساعدتي. الآن يمكنني إنهاء تلك البيتزا",
                _add = ".Kariinaأعطِ العجينة لـ"
            }
        },
        [5] = {
            name = "المهمة 03: السرقة",
            [0] = {
                _add = ".اذهب إلى مركز الشرطة"
            }
        }
    },
    error_houseClosed = ".هذا المنزل %s أغلق",
    item_pumpkin = "يقطين",
    vehicle_8 = "سفينة دورية",
    sale = "للبيع",
    npcDialog_Rupe = ".بالتأكيد الفأس المصنوع من الحجر ليس خيارًا جيدًا لكسر الحجارة",
    ranking_spentCoins = "العملات المصروفة",
    houseSettings_unlockHouse = "إلغاء قفل المنزل",
    item_frenchFries = "بطاطا مقلية",
    houseDescription_3 = "!فقط أكثر الشجعان يمكنهم العيش في هذا المنزل.أووو",
    wordSeparator = " و ",
    furniture_kitchenCabinet = "خزانة مطبخ",
    houseSettings_finish = "!إنهاء",
    badgeDesc_10 = "القبض على 500 سارق",
    chooseExpansion = "اختر توسعًا",
    confirmButton_Buy = "%s شراء مقابل",
    owned = "ممتلكة",
    npcDialog_Sebastian = ".أهلا يا صاح\n...\n.Colt أنا لست",
    npcDialog_Heinrich = ".هاه ... إذن تريد أن تكون عامل منجم؟ إذا كان الأمر كذلك ، يجب أن تكون حذرا. عندما كنت فأرًا صغيرًا ، كنت أضيع في هذه المتاهة",
    item_chocolate = "شوكولا",
    enterQuestPlace = "افتح هذا المكان بعد انهاء <vp>%s</vp>.",
    mouseSizeError = ".أنت أصغر من أن تفعل هذا",
    settings = "الإعدادات",
    chooseOption = "اختر خيارًا",
    closed_fishShop = "!متجر الأسماك مغلق. عُد لاحقًا",
    item_energyDrink_Mega = "فانتا",
    npcDialog_Derek = ".. بسست.. سنقوم بإحراز شيء كبير الليلة: سنقوم بسرقة البنك\n.إذا كنت ترغب في الانضمام إلينا ، فمن الأفضل التحدث إلى رئيسنا بابلو",
    furniture_pumpkin = "يقطين",
    hospital = "المستشفى",
    item_clock = "ساعة",
    item_sugar = "سكر",
    settings_config_mirror = "عكس النص",
    waterVehicles = "البحرية",
    error_maxStorage = ".تم شراء أقصى حد ممكن",
    fisher = "صائد سمك",
    multiTextFormating = "{1}: {0}",
    item_cookies = "بسكويت",
    item_lettuce = "خس",
    speed_km = "كم/س",
    item_fish_Goldenmare = "سمكة ذهبية",
    settings_donate = "تَبرع",
    command_profile = "<g>!profile</g> <v>[اسم اللاعب]</v>\n.<i>لاسم اللاعب</i> يُظهر الملف الشخصي ",
    profile_gold = "الذهب المجمع",
    settings_gameHour = "الساعة في اللعبة",
    settings_donateText2 = '.سيحصل المتبرعون على جائزة وضع فأرهم بالنمط على شرف التبرع. تذكر أن ترسل اسم المستخدم الخاص بك في ترانسفورمايس حتى أتمكن من الحصول على ملابسك الحالية',
    npcDialog_Bill = 'مرحبًا! هل تريد التحقق من حظ الصيد الحالي الخاص بك؟\n...هممم... دعني أرى\nلديك %s فرصة الحصول على سمكة عاديةو %s للأسماك النادرة و %s للأسماك الخرافية\n...!و أيضا لديك %s للحصول على سمكة أسطورية ',
    furniture_nightstand = 'منضدة سرير',
    furniture_bush = 'شجيرة',
    furniture_armchair = 'أريكة',
}

--[[ translations/br.lua ]]--
lang.br = {
	police = 'Policial',
	sale = 'À venda',
	close = 'Fechar',
	soon = 'Em breve!',
	house = 'Casa',
	yes = 'Sim',
	no = 'Não',
	thief = 'Ladrão',
	House1 = 'Casa clássica',
	House2 = 'Casa de Família',
	House3 = 'Casa Mal Assombrada',
	goTo = 'Entrar\n',
	fisher = 'Pescador',
	furniture = 'Móveis',
	hospital = 'Hospital',
	open = 'Abrir',
	use = 'Usar',
	using = 'Usando',
	error = 'Erro',
	submit = 'Validar',
	cancel = 'Cancelar',
	fishWarning = 'Você não pode pescar aqui.',
	fishingError = 'Você não está mais pescando.',
	closed_market = 'O mercado está fechado. Volte depois!',
	closed_police = 'A delegacia está fechada. Volte depois!',
	timeOut = 'Local indisponível.',
	password = 'Senha',
	passwordError = 'Mínimo de 1 letra',
	incorrect = 'Incorreto',
	buy = 'Comprar',
	alreadyLand = 'Algum jogador já adquiriu este terreno.',
	moneyError = 'Você não tem dinheiro suficiente.',
	copAlerted = 'Os policiais foram alertados.',
	looseMgs = 'Você será solto em %s segundos.',
	runAway = 'Fuja por %s segundos.',
	alert = 'Alerta!',
	copError = 'Você deve esperar 10 segundos para prender novamente.',
	closed_dealership = 'A concessionária está fechada. Volte depois!',
	miner = 'Mineiro',
	pickaxeError = 'Você deve comprar uma picareta.',
	pickaxes = 'Picaretas',
	closed_buildshop = 'A oficina do Jason está fechada. Volte depois!',
	energy = 'Energia',
	sleep = 'Sono',
	leisure = 'Lazer',
	hunger = 'Fome',
	elevator = 'Elevador',
	healing = 'Você será curado em %s segundos.',
	pizzaMaker = 'Pizzaiolo',
	noEnergy = 'Você precisa de mais energia para trabalhar novamente.',
	use = 'Usar',
	remove = 'Remover',
	items = 'Itens:',
	bagError = 'Espaço insuficiente na mochila.',
	item_pickaxe = 'Picareta',
	item_surfboard = 'Prancha de Surf',
	item_energyDrink_Basic = 'Sprite',
	item_energyDrink_Mega = 'Fanta',
	item_energyDrink_Ultra = 'Coca-Cola',
	item_clock = 'Relógio',
	boats = 'Barcos',
	vehicles = 'Veículos',
	error_boatInIsland = 'Você não pode usar um barco longe do mar.',
	item_milk = 'Garrafa de Leite',
	mine5error = 'A mina desabou.',
	vehicle_5 = 'Bote',
	noMissions = 'Não há missões disponíveis.',
	questsName = 'Missões',
	completedQuest = 'Missão finalizada',
	receiveQuestReward = 'Receber recompensa',
	rewardNotFound = 'Recompensa não encontrada',
	npc_mine6msg = 'Isso pode desabar a qualquer momento, mas ninguém me escuta...',
	item_goldNugget = 'Ouro',
	goldAdded = 'O ouro que você coletou foi colocado na sua mochila.',
	sellGold = 'Vender %s ouro(s) por <vp>%s</vp>',
	settings_gameHour = 'Horário',
	settings_gamePlaces = 'Lugares',
	settingsText_availablePlaces = 'Lugares disponíveis: <vp>%s</vp>',
	settingsText_placeWithMorePlayers = 'Lugar com mais jogadores: <vp>%s</vp> <r>(%s)</r>',
	settingsText_hour = 'Hora atual: <vp>%s</vp>',
	item_dynamite = 'Dinamite',
	placeDynamite = 'Plantar dinamite',
	energyInfo = '<v>%s</v> de energia',
	hungerInfo = '<v>%s</v> de comida',
	itemDesc_clock = 'Um relógio simples que pode ser utilizado uma única vez.',
	itemDesc_dynamite = 'Boom!',
	itemDesc_pickaxe = 'Quebre pedras com maior facilidade!',
	hey = 'Ei! Parado!',
	robberyInProgress = 'Roubo em andamento',
	closed_bank = 'O banco está fechado. Volte novamente mais tarde.',
	bankRobAlert = 'O banco está sendo assaltado. Defenda-o!',
	runAwayCoinInfo = 'Você receberá %s após completar o roubo.',
	atmMachine = 'Caixa eletrônico',
	codeInfo = 'Digite um código válido e clique em validar para resgatar sua recompensa.\nVocê pode obter novos códigos através do nosso servidor no Discord.\n<a href="event:getDiscordLink"><v>(Clique aqui para receber o link de convite)</v></a>',
	item_shrinkPotion = 'Poção do encolhimento',
	itemDesc_shrinkPotion = 'Use essa poção para diminuir o seu tamanho por %s segundos!',
	mouseSizeError = 'Você está muito pequeno para realizar essa ação.',
	enterQuestPlace = 'Desbloqueie este lugar ao completar <vp>%s</vp>.',
	closed_potionShop = 'A loja de poções está fechada. Volte novamente mais tarde.',
	bag = 'Mochila',
	ranking_coins = 'Moedas Acumuladas',
	ranking_spentCoins = 'Moedas Gastas',
	item_growthPotion = 'Poção do crescimento',
	itemDesc_growthPotion = 'Use essa poção para aumentar o seu tamanho por %s segundos!',
	codeAlreadyReceived = 'Código já utilizado.',
	codeReceived = 'Você resgatou: %s.',
	codeNotAvailable = 'Código indisponível.',
	quest = 'Missão',
	job = 'Trabalho',
	chooseOption = 'Escolha uma opção',
	newUpdate = 'Nova atualização!',
	itemDesc_goldNugget = 'Brilhante e valioso.',
	shop = 'Loja',
	item_coffee = 'Café',
	item_hotChocolate = 'Chocolate Quente',
	item_milkShake = 'Milkshake',
	speed = 'Velocidade: %s',
	price = 'Preço: %s',
	owned = 'Adquirido',
	updateWarning = '<font size="10"><rose><p align="center">Atenção!</p></rose>\nAtualização em %smin %ss.',
	waitUntilUpdate = '<rose>Por favor aguarde.</rose>',
	playerBannedFromRoom = '%s foi banido desta sala.',
	playerUnbannedFromRoom = '%s foi desbanido.',
	harvest = 'Colher',
	item_bag = 'Mochila',
	itemDesc_bag = '+ %s de armazenamento da mochila.',
	item_seed = 'Semente',
	itemDesc_seed = 'Uma semente aleatória.',
	item_tomato = 'Tomate',
	item_fertilizer = 'Fertilizante',
	itemDesc_fertilizer = 'Faz as plantas crescerem mais rápido!',
	error_maxStorage = 'Limite excedido.',
	drop = 'Largar',
	item_lemon = 'Limão',
	item_lemonSeed = 'Semente de limão',
	item_tomatoSeed = 'Semente de tomate',
	item_oregano = 'Orégano',
	item_oreganoSeed = 'Semente de orégano',
	item_water = 'Balde d\'água',
	itemDesc_water = 'Faz as plantas crescerem mais rápido!',
	houses = 'Casas',
	expansion = 'Expansões',
	furnitures = 'Móveis',
	settings = 'Configurações',
	furniture_oven = 'Fogão',
	expansion_pool = 'Piscina',
	expansion_garden = 'Plantação',
	expansion_grass = 'Grama',
	chooseExpansion = 'Escolha uma expansão',
	item_pepper = 'Pimenta',
	item_luckyFlower = 'Flor-da-sorte',
	item_pepperSeed = 'Semente de pimenta',
	item_luckyFlowerSeed = 'Semente de Flor-da-sorte',
	closed_seedStore = 'A loja de sementes está fechada. Volte novamente mais tarde.',
	item_salt = 'Sal',
	item_sauce = 'Molho de Tomate',
	item_hotsauce = 'Molho Apimentado',
	item_dough = 'Massa',
	item_wheat = 'Trigo',
	item_wheatSeed = 'Semente de trigo',
	item_pizza = 'Pizza',
	recipes = 'Receitas',
	cook = 'Cozinhar',
	closed_furnitureStore = 'A loja de móveis está fechada. Volte novamente mais tarde.',
	maxFurnitureStorage = 'Você só pode colocar %s móveis em sua casa.',
	furniture_kitchenCabinet = 'Armário de cozinha',
	sell = 'Vender',
	item_cornFlakes = 'Flocos de milho',
	furniture_flowerVase = 'Vaso de flor',
	createdBy = 'Criado por %s',
	furniture_painting = 'Pintura',
	furniture_sofa = 'Sofá',
	furniture_chest = 'Baú',
	furniture_tv = 'Tv',
	transferedItem = 'O item %s foi transferido para sua mochila.',
	passToBag = 'Pôr na mochila',
	seeItems = 'Ver Itens',
	furnitureRewarded = 'Móvel Desbloqueado: %s',
	itemAddedToChest = 'O item %s foi inserido no baú.',
	farmer = 'Fazendeiro',
	seedSold = 'Você vendeu %s por %s.',
	item_pumpkin = 'Abóbora',
	item_pumpkinSeed = 'Semente de abóbora',
	waitingForPlayers = 'Aguardando jogadores...',
	_2ndquest = 'Missão secundária',
	sideQuests = {
		[1] = 'Plante %s sementes no jardim do Oliver.',
		[2] = 'Fertilize %s plantas no jardim do Oliver.',
		[3] = 'Consiga %s moedas.',
		[4] = 'Prenda um ladrão %s vezes.',
		[5] = 'Use %s itens.',
		[6] = 'Gaste %s moedas.',
		[7] = 'Pesque %s vezes.',
		[8] = 'Minere %s pedras de ouro.',
		[9] = 'Roube o banco sem ser preso.',
		[10] = 'Complete %s roubos.',
		[11] = 'Cozinhe %s itens.',
		[12] = 'Ganhe %s xp.',
		[13] = 'Pesque %s sapos.',
		[14] = 'Pesque %s peixes-leão.',
		[15] = 'Entregue %s pedidos.',
		[16] = 'Entregue %s pedidos.',
		[17] = 'Prepare uma pizza.',
		[18] = 'Prepare uma brusqueta.',
		[19] = 'Prepare uma limonada.',
		[20] = 'Prepare um sanduíche de sapo.',
	},
	profile_coins = 'Moedas',
	profile_spentCoins = 'Moedas gastas',
	profile_completedQuests = 'Missões feitas',
	profile_completedSideQuests = 'Missões secundárias feitas',
	profile_purchasedHouses = 'Casas adquiridas',
	profile_purchasedCars = 'Veículos adquiridos',
	profile_basicStats = 'Dados Gerais',
	profile_questCoins = 'Pontos de missão',
	profile_jobs = 'Trabalhos',
	profile_arrestedPlayers = 'Prendeu',
	profile_robbery = 'Roubos',
	profile_fishes = 'Pescou',
	profile_gold = 'Ouro coletado',
	profile_seedsPlanted = 'Colheitas',
	profile_seedsSold = 'Vendas',
	levelUp = '%s passou para o nível %s!',
	sidequestCompleted = 'Você completou uma missão secundária!\nVocê recebeu:',
	chestIsFull = 'O baú está cheio.',
	code = 'digite um código',
	level = 'Nível %s',
	furniture_hay = 'Feno',
	furniture_shelf = 'Prateleira',
	item_superFertilizer = 'Super Fertilizante',
	itemDesc_superFertilizer = 'Possui o dobro da eficácia de um fertilizante comum.',
	profile_badges = 'Medalhas',
	daysLeft = '%sd restantes.',-- d: abbreviation of days
	daysLeft2 = '%sd', -- d: abbreviation of days
	collectorItem = 'Item de colecionador.',
	House4 = 'Celeiro',
	House5 = 'Mansão Assombrada',
	houseSetting_storeFurnitures = 'Guardar todos os móveis no inventário',
	ghostbuster = 'Caça-Fantasmas',
	furniture_rip = 'Lápide',
	furniture_cross = 'Cruz',
	furniture_pumpkin = 'Abóbora do Halloween',
	furniture_spiderweb = 'Teia de aranha',
	furniture_candle = 'Vela',
	furniture_cauldron = 'Caldeirão',
	event_halloween2019 = 'Halloween 2019',
	ghost = 'Fantasma',
	maxFurnitureDepot = 'Seu depósito de móveis está cheio.',
	unlockedBadge = 'Você desbloqueou uma nova medalha!',
	reward = 'Recompensa',
	badgeDesc_0 = 'Halloween 2019',
	badgeDesc_1 = 'Encontrou o criador do jogo',
	badgeDesc_3 = 'Mineirou 1000 ouros',
	badgeDesc_2 = 'Pescou 500 peixes',
	badgeDesc_4 = 'Colheu 500 plantas',
	item_sugar = 'Açúcar',
	item_chocolate = 'Chocolate',
	item_cookies = 'Cookies',
	furniture_christmasWreath = 'Guirlanda',
	furniture_christmasSocks = 'Meia de Natal',
	House6 = 'Casa Natalina',
	item_blueberries = 'Mirtilos',
	item_blueberriesSeed = 'Semente de mirtilo',
	furniture_christmasFireplace = 'Lareira',
	furniture_christmasSnowman = 'Boneco de Neve',
	furniture_christmasGift = 'Caixa de Presente',
	vehicle_9 = 'Trenó',
	badgeDesc_5 = '500 roubos completados',
	badgeDesc_6 = 'Natal 2019',
	badgeDesc_7 = 'Comprou o trenó',
	frozenLake = 'O lago está congelado. Aguarde o fim do inverno para poder usar um barco.',
	codeLevelError = 'Você precisa alcançar o nível %s para poder resgatar este código.',
	furniture_christmasCarnivorousPlant = 'Planta Carnívora',
	furniture_christmasCandyBowl = 'Pote de Doces',
	settingsText_grounds = 'Pisos gerados: %s/509',
	locked_quest = 'Missão %s',
	furniture_apiary = 'Caixa de abelhas',
	item_cheese = 'Queijo',
	itemDesc_cheese = 'Use este item e receba +1 queijo na loja do Transformice!',
	item_fish_SmoltFry = 'Salmão',
	item_fish_Lionfish = 'Peixe-Leão',
	item_fish_Dogfish = 'Peixe-Cão',
	item_fish_Catfish = 'Peixe-Gato',
	item_fish_RuntyGuppy = 'Barrigudinho',
	item_fish_Lobster = 'Lagosta',
	item_fish_Goldenmare = 'Goldenmare',
	item_fish_Frog = 'Sapo',
	emergencyMode_pause = '<cep><b>[Alerta!]</b> <r>O modo de emergência foi ativado. Para evitar que a sala caia, alguns dados demorarão mais tempo para serem processados.',
	emergencyMode_resume = '<r>O modo de emergência foi desativado. O jogo voltará ao normal em alguns instantes.',
	emergencyMode_able = "<r>A sala crashou :(. Por favor vá para outra sala #mycity.",
	settingsText_currentRuntime = 'Runtime: <r>%s</r>/60ms',
	settingsText_createdAt = 'Sala criada há <vp>%s</vp> minutos.',
	limitedItemBlock = 'Você deve aguardar %s segundos para usar este item.',
	eatItem = 'Comer',
	ranking_Season = 'Temporada %s',
	settings_help = 'Ajuda',
	settings_settings = 'Configurações',
	settings_credits = 'Créditos',
	settings_donate = 'Doar',
	settings_creditsText = '<j>#Mycity</j> foi criado por <v>%s</v>, com as artes de <v>%s</v> e com as traduções de:',
	settings_creditsText2 = 'Agradecimentos especiais para <v>%s</v> por ajudarem com recursos importantes no minigame.',
	settings_donateText = 'O <j>#Mycity</j> é um projeto iniciado em <b><cep>2014</cep></b>, mas com outra proposta: <v>construir uma cidade</v>! No entanto, esse projeto não deu certo e foi cancelado meses depois.\n Em <b><cep>2017</cep></b> eu decidi refazê-lo em uma nova proposta: <v>viver em uma cidade</v>!\n\n A maioria das funções disponíveis foram feitas apenas por mim em um trabalho <v>longo e cansativo</v>.\n\n Se você puder e tiver condições de me ajudar, faça uma doação. Isso me incentiva a trazer novas atualizações!',
	wordSeparator = ' e ',
	settings_config_lang = 'Idioma',
	settings_config_mirror = 'Espelhar Texto',
	settings_helpText = 'Bem vindo ao <j>#Mycity</j>!\n Se você tiver interesse em aprender sobre o jogo, clique no botão abaixo:',
	settings_helpText2 = 'Comandos disponíveis:',
	command_profile = '<g>!perfil</g> <v>[jogador]</v>\n 	Abre o perfil de outro jogador que esteja na sala.',
	saveChanges = 'Salvar Alterações',
	House7 = 'Casa na Árvore',
	item_lemonade = 'Limonada',
	item_lobsterBisque = 'Bisque de Lagosta',
	item_bread = 'Pão de Forma',
	item_bruschetta = 'Brusqueta',
	item_waffles = 'Waffles',
	item_egg = 'Ovo',
	item_honey = 'Mel',
	item_grilledLobster = 'Lagosta Grelhada',
	item_frogSandwich = 'Sapoíche',
	item_chocolateCake = 'Torta de Chocolate',
	item_wheatFlour = 'Farinha de Trigo',
	item_salad = 'Salada',
	item_lettuce = 'Alface',
	item_pierogies = 'Pierogies',
	item_potato = 'Batata',
	item_frenchFries = 'Batata Frita',
	item_pudding = 'Pudim',
	item_garlicBread = 'Pão de Alho',
	item_garlic = 'Alho',
	vehicle_11 = 'Iate',
	vehicle_6 = 'Barco de Pesca',
	vehicle_8 = 'Barco de Patrulha',
	npcDialog_Kapo = 'Eu venho sempre aqui para conferir as ofertas diárias do Dave.\nÀs vezes eu consigo itens raros e que apenas ele tem!',
	npcDialog_Santih = 'Tem muita gente que ainda se atreve a pescar nesse laguinho.',
	npcDialog_Louis = 'Eu falei para ela não colocar azeitonas...',
	npcDialog_Heinrich = 'Hmmm... Então você quer ser um mineiro? Se sim, tenho que avisá-lo para ser cuidadoso. Quando eu era um ratinho pequeno, eu me perdia bastante naquele labirinto.',
	npcDialog_Davi = 'Me desculpe, mas não posso deixar você passar por aqui.',
	npcDialog_Alexa = 'Olá! Qual a nova?',
	npcDialog_Sebastian = 'E aí.\n...\nEu não sou o Colt.',
	captured = '<v>%s</v> <g>foi preso!',
	arrestedPlayer = 'Você prendeu <v>%s</v>!',
	confirmButton_Work = 'Trabalhar!',
	chef = 'Cozinheiro',
	rewardText = 'Você recebeu uma recompensa incrível!',
	confirmButton_Great = 'Ótimo!',
	questCompleted = 'Você completou a missão %s!\nVocê recebeu:',
	newLevelMessage = 'Parabéns! Você subiu de nível!',
	newLevel = 'Novo nível!',
	experiencePoints = 'Pontos de experiência',
	newQuestSoon = 'A missão %s ainda não está pronta :/\n<font size="11">Estágio de desenvolvimento: %s%%',
	badgeDesc_9 = 'Completou 500 pedidos',
	badgeDesc_10 = 'Prendeu 500 ladrões',
	multiTextFormating = '{0}: {1}', -- EX: "{0}: {1}" will return "Coins: 10" while "{1} : {0}" will return "10 : Coins"
	profile_fulfilledOrders = 'Pedidos entregues',
	profile_cookedDishes = 'Pratos feitos',
	profile_capturedGhosts = 'Fantasmas capturados',
	npcDialog_Marie = 'Eu aaaaaaaaamo queijo *-*',
	npcDialog_Rupe = 'Definitivamente uma picareta feita de pedra não é uma boa escolha para quebrar pedras.',
	npcDialog_Paulo = 'Essa caixa está muito pesada...\nSeria tão bom se tivéssemos uma empilhadeira por aqui.',
	npcDialog_Lauren = 'Ela adora queijo.',
	npcDialog_Julie = 'Tenha cuidado, o mercado é muito perigoso.',
	npcDialog_Cassy = 'BOMDIACPFNANOTA?',
	npcDialog_Natasha = 'Olá!',
	itemInfo_Seed = 'Tempo de crescimento: <vp>%smin</vp>\nPreço por semente: <vp>$%s</vp>',
	confirmButton_Select = 'Selecionar',
	confirmButton_Buy = 'Compre por %s',
	confirmButton_Buy2 = 'Compre %s\npor %s',
	newBadge = 'Nova medalha',
	landVehicles = 'Terrestres',
	waterVehicles = 'Aquáticos',
	houseDescription_1 = 'Uma casinha pequena típica da arquitetura de mycity!',
	houseDescription_2 = 'Uma casa grande para grandes famílias com grandes problemas.',
	houseDescription_3 = 'Somente os mais corajosos podem viver nessa casa. Oooo!',
	houseDescription_4 = 'Cansou da vida na cidade? Temos o que você precisa.',
	houseDescription_5 = 'O verdadeiro lar dos fantasmas. Tome cuidado!',
	houseDescription_6 = 'Essa casa aconchegante lhe trará conforto nos dias mais frios!',
	houseDescription_7 = 'Uma casa para quem gosta de acordar ao lado da natureza!',
	houseSettings = 'Configurar Casa',
	houseSettings_permissions = 'Permissões', 
	houseSettings_buildMode = 'Modo de Construção',
	houseSettings_finish = 'Terminar!', 
	error_houseUnderEdit = '%s está editando a casa.',
	sellFurniture = 'Vender móvel',
	sellFurnitureWarning = 'Você tem certeza que deseja vender esse móvel?\n<r>Essa ação não pode ser desfeita!</r>',
	confirmButton_Sell = 'Vender por %s',
	houseSettings_placeFurniture = 'Posicionar',
	speed_knots = 'Nós',
	npcDialog_Blank = 'Você tem algo aí?',
	orderCompleted = 'Você realizou o pedido de %s e recebeu %s!',
	houseSettings_changeExpansion = 'Alterar Expansão',
	furniture_derp = 'Pombo',
	furniture_testTubes = 'Tubos de Ensaio',
	furniture_bed = 'Cama',
	furniture_scarecrow = 'Espantalho',
	furniture_fence = 'Cerca',
	furniture_hayWagon = 'Hay Wagon',
	furniture_diningTable = 'Mesa de Restaurante',
	furniture_bookcase = 'Estante',
	syncingGame = '<r>Sincronizando dados com o servidor. O jogo pode ficar lento por alguns segundos.', 
	item_crystal_yellow = 'Cristal Amarelo',
	item_crystal_blue = 'Cristal Azul',
	item_crystal_purple = 'Cristal Roxo',
	item_crystal_green = 'Cristal Verde',
	item_crystal_red = 'Cristal Vermelho',
	closed_fishShop = 'A loja de pesca está fechada. Volte depois!',
	npcDialog_Jason = 'Opa... a minha loja ainda não está pronta.\nPor favor, volte em breve!',
	houseSettings_lockHouse = 'Fechar casa',
	houseSettings_unlockHouse = 'Abrir casa',
	houseSettings_reset = 'Resetar',
	error_blockedFromHouse = 'Você foi banido da casa de %s.',
	permissions_blocked = 'Bloqueado',
	permissions_guest = 'Convidado',
	permissions_roommate = 'Colega de Quarto',
	permissions_coowner = 'Co-dono',
	permissions_owner = 'Dono',
	setPermission = 'Tornar %s',
	error_houseClosed = '%s fechou esta casa.',
	itemAmount = 'Itens: %s',
	vehicleError = 'Você não pode usar este veículo neste local.',
	confirmButton_tip = 'Dica',
	tip_vehicle = 'Clique na estrela próxima à imagem de um veículo para favoritá-lo. Você poderá ativar um veículo favoritado ao apertar a tecla F (para carros) ou G (para barcos)!',
	npcDialog_Billy = 'Mal posso esperar para roubar o banco hoje à noite!',
	npcDialog_Derek = 'Shhh.. Estamos planejando algo grande para esta noite: Vamos roubar o banco.\nSe você quiser participar é melhor falar com o meu chefe Pablo.',
	npcDialog_Pablo = 'Então você deseja se tornar um ladrão? Eu tô achando que você é um policial disfarçado.\nAh, você não é? Eu acredito em você então.\nVocê agora é um ladrão e tem a habilidade de roubar qualquer personagem que tenham o nome rosa.\nLembre-se de usar a tecla ESPAÇO para assaltar. Também não se esqueça de fugir de policiais. Boa sorte!',
	npcDialog_Goldie = 'Você deseja vender algum cristal? Largue ele próximo a mim para eu avaliá-lo.',
	npcDialog_Weth = 'Pudim *-*',
	itemInfo_miningPower = 'Dano em pedras: %s',
	quests = {
		[1] = {
			name = 'Missão 01: Construindo um barco',
			[0] = {
				dialog = 'Olá! Como você está? Recentemente, algumas pessoas descobriram uma pequena ilha depois do mar. Lá tem algumas árvores e cosntruções também.\nComo você sabe, não temos um aeroporto na cidade. Por enquanto, o único modo de chegar lá é com um barco.\nEu posso construir um para você, mas vou precisar de ajuda primeiro.\nNa minha próxima aventura, quero descobrir o que tem do outro lado da mina. Eu tenho algumas teorias e preciso confirmá-las.\nEu acho que vai ser uma expedição longa, então vou precisar de muita comida.\nVocê pode pescar 5 peixes para mim?',
				_add = ' Fale com Kane',
			},
			[1] = {
				_add = 'Pesque %s peixes',
			},
			[2] = {
				dialog = 'Wow! Obrigado por esses peixes! Eu não posso esperar para comê-los na minha expedição.\nAgora, você terá que me trazer 3 Coca-Cola. Você pode comprá-las no mercado.',
				_add = ' Fale com Kane',
			},
			[3] = {
				_add = 'Compre %s Coca-Cola',
			},
			[4] = {
				dialog = 'Obrigado por me trazer comida! Agora é minha vez de retribuir o favor.\nMas para fazer isso vou precisar de algumas tábuas, para que eu possa construir o bote.\nRecentemente, eu vi o Chrystian cortando árvores e coletando madeira. Pergunte a ele se ele pode lhe dar algumas.',
				_add = ' Fale com Kane',
			},
			[5] = {
				dialog = 'Então você quer tábuas? Eu posso te dar algumas, mas você terá de me trazer flocos de milho.\nVocê pode fazer isso?',
				_add = ' Fale com Chrystian',
			},
			[6] = {
				_add = 'Compre floco de milho.',
			},
			[7] = {
				dialog = 'Obrigado por me ajudar! Aqui está as tábuas que você me pediu. Faça um bom uso delas!',
				_add = ' Fale com Chrystian',
			},
			[8] = {
				dialog = 'Você demorou muito... Achei que você tivesse esquecido de pegar as tábuas...\nDe qualquer forma, agora posso construir seu barco...\nAqui está o seu barco! Divirta-se na nova ilha e tenha cuidado!',
				_add = ' Fale com Kane',
			},
		},
		[2] = {
			name = 'Missão 02: As chaves perdidas',
			[0] = {
				_add = 'Vá para a ilha.',
			},
			[1] = {
				dialog = 'Olá! Quem é você? Nunca te vi antes...\nMeu nome é Indy! Eu vivo nessa ilha a muito tempo. Tem muitos lugares legais aqui.\nEu sou dona da loja de poções. Eu poderia te chamar para conhecer a loja, mas eu tenho um grande problema: Eu perdi as chaves da loja!\nEu devo ter deixado cair na mina. Você pode me ajudar?',
				_add = ' Fale com Indy',
			},
			[2] = {
				_add = 'Vá para a mina.',
			},
			[3] = {
				_add = 'Encontre as chaves de Indy',
			},
			[4] = {
				dialog = 'Obrigada! Agora eu posso voltar ao trabalho!\nEspere um segundo...\nEstá faltando uma: a chave da loja! Você procurou direito?',
				_add = 'Leve as chaves para Indy.',
			},
			[5] = {
				_add = 'Volte para a mina.',
			},
			[6] = {
				_add = 'Encontre a ultima chave.',
			},
			[7] = {
				dialog = 'Finalmente! Você deveria prestar mais atenção, eu poderia ter assistido um filme enquanto você as procurava.\nVocê ainda quer ver a loja? Estou indo para lá!',
				_add = 'Leve a chave para Indy.',
			},
		},	
		[3] = {
			name = 'Missão 03: O roubo',
			[0] = {
				_add = 'Vá para a delegacia.',
			},
			[1] = {
				dialog = 'Oi. Estão faltando policias na cidade e eu preciso da sua ajuda, nada muito difícil.\nTivemos um misterioso roubo ao banco, tanto que nenhuma suspeita foi encontrada...\nSuponho que haja alguma pista no banco.\nColt deve saber o que pode ter acontecido. Fale com ele.',
				_add = ' Fale com Sherlock',
			},
			[2] = {
				_add = 'Vá para o banco.',
			},
			[3] = {
				dialog = 'QUÊ? Sherlock pediu que viesse aqui? Eu disse a ele que estou cuidando desse caso.\nDiga a ele que eu não preciso de ajuda. Eu consigo sozinho.',
				_add = ' Fale com Colt.',
			},
			[4] = {
				_add = 'Vá para a delegacia.',
			},
			[5] = {
				dialog = 'Eu sabia que ele não ajudaria...\nVamos ter que procurar pistas sem ele.\nIremos ao banco quando ele não estiver lá, você pode fazer isso, certo?',
				_add = ' Fale com Sherlock.',
			},
			[6] = {
				_add = 'Entre no banco enquanto está sendo roubado',
			},
			[7] = {
				_add = 'Procure por pistas no banco.',
			},
			[8] = {
				_add = 'Vá para a delegacia.',
			},

			[9] = {
				dialog = 'Muito bem! Este tecido vai nos ajudar a encontrar um suspeito.\nFale com Indy. Ele vai nos ajudar.',
				_add = 'Fale com Sherlock.',
			},
			[10] = {
				dialog = 'Então... Você precisa de ajuda nessa investigação?\nHmm... Deixe me ver esse tecido...\nJá o vi em algum lugar. É usado no hospital! Dê uma olhada por lá!',
				_add = 'Fale com Indy.',
			},
			[11] = {
				_add = 'Vá para o hospital.',
			},
			[12] = {
				_add = 'Procure por algo suspeito no hospital.',
			},
			[13] = {
				_add = 'Vá para a mina.',
			},
			[14] = {
				_add = 'Encontre o suspeito e prenda-o.',
			},
			[15] = {
				_add = 'Volte para a delegacia.',
			},
			[16] = {
				dialog = 'Muito bem! Você é realmente muito bom nisso.\nEu conheço um bom lugar para repôr as energias depois de uma longa investigação: a cafeteria!',
				_add = 'Talk with Sherlock.',
			},
		},
		[4] = {
		    name = 'Missão 04: O molho acabou!',
		    [0] = {
				dialog = 'Olá! Você quer comer uma pizza?\nBom... trago más notícias.\nOntem mais cedo comecei a fazer algumas pizzas, mas notei que todo molho que eu tinha acabou.\nTentei comprar tomates no mercado, mas aparentemente eles não vendem.\nEu comecei a morar aqui algumas semanas atrás e eu não conheço ninguém que possa me ajudar.\nEntão você pode me ajudar? Só preciso de molho para abrir a pizzaria.',
				_add = 'Fale com Kariina.',
		    },
		    [1] = {
		        _add = 'Vá para a ilha.',
		    },
		    [2] = {
		        _add = 'Vá para a loja de sementes.',
		    },
		    [3] = {
		        _add = 'Compre uma semente.',
		    },
		    [4] = {
		        _add = 'Vá para sua casa.',
		    },
		    [5] = {
		        _add = 'Plante a semente na sua casa. (Você precisa ter um jardim!)',
		    },
		    [6] = {
		        _add = 'Recolha os tomates.',
		    },
		    [7] = {
		        _add = 'Vá para a loja de sementes.',
		    },
		    [8] = {
		        _add = 'Compre um balde de água.',
		    },
		    [9] = {
		        _add = 'Vá para o mercado.',
		    },
		    [10] = {
		        _add = 'Compre sal.',
		    },
		    [11] = {
		        _add = 'Cozinhe um molho. (Você precisa ter um fogão!)',
		    },
		    [12] = {
		        dialog = 'Wow! Obrigada! Agora eu preciso de molho picante. Você pode me fazer um?',
		        _add = 'Entregue o molho para Kariina.',
		    },
		    [13] = {
		        _add = 'Plante uma semente na sua casa.',
		    },
		    [14] = {
		        _add = 'Reolha as pimentas',
		    },
		    [15] = {
		        _add = 'Cozinhe um molho picante.',
		    },
		    [16] = {
		        dialog = '!!! Você fez isso! Obrigada!\nEnquanto você não estava, percebi que preciso de mais trigo para fazer a massa... Você pode me fazer trigo?',
		        _add = 'Entregue o molho picante para Kariina.',
		    },
		    [17] = {
		        _add = 'Plante uma semente na sua casa.',
		    },
		    [18] = {
		        _add = 'Recolha o trigo.',
		    },
		    [19] = {
				dialog = 'Wow! Obrigado! Você pode trabalhar comigo quando eu precisar de empregados.\nObrigada por me ajudar. Agora eu posso terminar essas pizzas!',
		        _add = 'Entregue trigo para Kariina.',
		    },
		},
	},
	daveOffers = 'Ofertas de hoje',
	placedFurnitures = 'Móveis colocados: %s',
	settings_donateText2 = 'Doadores ganharão um NPC exclusivo no mapa como agradecimento. Lembre-se de enviar o seu nome do Transformice para que eu possa adicionar um NPC do seu ratinho.',
	npcDialog_Bill = 'Olá! Você gostaria que eu avaliasse a sua sorte em pescar?\nHmmm... Deixa eu conferir...\nVocê tem %s de chance de pescar um peixe comum, %s de pescar um peixe raro e %s de pescar um peixe mítico.\nVocê também tem %s de chance de pescar um peixe lendário!',
	furniture_nightstand = 'Mesa de Cabeceira',
	furniture_bush = 'Arbusto',
	furniture_armchair = 'Poltrona',
}

--[[ translations/de.lua ]]--
lang.de = {
	police = 'Polizei',
	sale = 'Zu Verkaufen',
	close = 'Zu machen',
	soon = 'In kurzer Zeit',
	house = 'Haus',
	yes = 'Ja',
	no = 'Nein',
	thief = 'Dieb',
	House1 = 'Klassisches Haus',
	House2 = 'Familien Haus',
	goTo = 'Reingehen',
	fisher = 'Fischer',
	furniture = 'Möbel',
	hospital = 'Krankenhaus',
	open = 'Öffnen',
}

--[[ translations/en.lua ]]--
lang.en = {
	police = 'Cop',
	sale = 'For sale',
	close = 'Close',
	soon = 'Soon!',
	house = 'House',
	yes = 'Yes',
	no = 'No',
	thief = 'Thief',
	House1 = 'Classic House',
	House2 = 'Family House',
	House3 = 'Haunted House',
	goTo = 'Enter\n',
	fisher = 'Fisher',
	furniture = 'Furniture',
	hospital = 'Hospital',
	open = 'Open',
	use = 'Use',
	using = 'Using',
	error = 'Error',
	submit = 'Submit',
	cancel = 'Cancel',
	fishWarning = "You can't fish here.",
	fishingError = 'You aren\'t fishing anymore.',
	closed_market = 'The supermarket is closed. Come back later!',
	closed_police = 'The police station is closed. Come back later!',
	timeOut = 'Unavailable place.',
	password = 'Password',
	passwordError = 'Min. 1 Letter',
	incorrect = 'Incorrect',
	buy = 'Buy',
	alreadyLand = 'Some player has already acquired this land.',
	moneyError = 'You don\'t have enough money.',
	copAlerted = 'The cops have been alerted.',
	looseMgs = 'You\'ll be loose in %s seconds.',
	runAway = 'Run away in %s seconds.',
	alert = 'Alert!',
	copError = 'You must wait 10 seconds to hold again.',
	closed_dealership = 'The dealership is closed. Come back later!',
	miner = 'Miner',
	pickaxeError = 'You have to buy a pickaxe.',
	pickaxes = 'Pickaxes',
	closed_buildshop = 'The build shop is closed. Come back later!',
	energy = 'Energy',
	sleep = 'Sleep',
	leisure = 'Leisure',
	hunger = 'Hunger',
	elevator = 'Elevator',
	healing = 'You\'ll be healed in %s seconds',
	pizzaMaker = 'Pizza Maker',
	noEnergy = 'You need more energy to work again.',
	use = 'Use',
	remove = 'Remove',
	items = 'Items:',
	bagError = 'Insufficient space in the bag.',
	item_pickaxe = 'Pickaxe',
	item_energyDrink_Basic = 'Sprite',
	item_energyDrink_Mega = 'Fanta',
	item_energyDrink_Ultra = 'Coca-Cola',
	item_clock = 'Clock',
	boats = 'Boats',
	vehicles = 'Vehicles',
	error_boatInIsland = 'You can\'t use a boat far from the sea.',
	item_milk = 'Milk bottle',
	mine5error = 'The mine collapsed.',
	vehicle_5 = 'Boat',
	quests = {
		[1] = {
			name = 'Quest 01: Building a boat',
			[0] = {
				dialog = 'Hey! How are you? Recently, some people discovered a small island after the sea. There are many trees and some buildings too.\nAs you know, there isn\'t an airport in the city. The only way to get there at the moment is through a boat.\nI can build one for you, but I\'ll need some help first.\nOn my next adventure, I\'d like to find out what\'s at the other side of the mine. I have some theories and I need to confirm them.\nI think it\'ll be a long expedition, so I\'m going to need a lot of food.\nCan you fish 5 fishes for me?',
				_add = 'Talk with Kane',
			},
			[1] = {
				_add = 'Fish %s fishes',
			},
			[2] = {
				dialog = 'Wow! Thank you for these fishes! I can\'t wait to eat them in my expedition.\nNow, you\'ll have to bring to me 3 Coca-Cola. You can buy them in the market.',
				_add = 'Talk with Kane',
			},
			[3] = {
				_add = 'Buy %s Coca-Cola',
			},
			[4] = {
				dialog = 'Thank you for bringing me the foodstuff! Now, it\'s my turn to return the favor.\nBut in order to do that I\'ll need some wooden planks so I can build you a boat.\nRecently I\'ve seen Chrystian chopping trees and gathering wood. Ask him if he can give you some wooden planks.',
				_add = 'Talk with Kane',
			},
			[5] = {
				dialog = 'So you want wooden planks? I can give you some, but you\'ll need to bring to me a corn flake.\nCould you do this?',
				_add = 'Talk with Chrystian',
			},
			[6] = {
				_add = 'Buy a corn flake',
			},
			[7] = {
				dialog = 'Thank you for helping me! Here is the wooden planks you have asked me. Make good use of them!',
				_add = 'Talk with Chrystian',
			},
			[8] = {
				dialog = 'You took too long... I thought you had forgotten to get the wooden planks...\nBy the way, now I can build your boat...\nHere\'s your boat! Have fun on the new island and don\'t forget to be careful!',
				_add = 'Talk with Kane',
			},
		},
		[2] = {
			name = 'Quest 02: The lost keys',
			[0] = {
				_add = 'Go to the island.',
			},
			[1] = {
				dialog = 'Hey! Who\'re you? I\'ve never seen you before...\nMy name is Indy! I live in this island for a long time. There\'re great places to meet here.\nI\'m the owner of the potions store. I could call you to meet a store, but I have one big problem: I lost my store keys!\nI must have lost them in the mine while I was mining. Can you help me?',
				_add = 'Talk with Indy',
			},
			[2] = {
				_add = 'Go to the mine.',
			},
			[3] = {
				_add = 'Find Indy\'s keys.',
			},
			[4] = {
				dialog = 'Thank you! Now I can get back to business!\nWait a second...\n1 key is missing: the key of the store! Did you look hard?',
				_add = 'Bring the keys to Indy.',
			},
			[5] = {
				_add = 'Go back to the mine.',
			},
			[6] = {
				_add = 'Find the last key.',
			},
			[7] = {
				dialog = 'Finally! You should pay more attention, I could have watched a movie while I was waiting for you.\nDo you still want to meet the store? I\'m going there!',
				_add = 'Bring the key to Indy.',
			},
		},	
		[3] = {
			name = 'Quest 03: Theft',
			[0] = {
				_add = 'Go to the police station.',
			},
			[1] = {
				dialog = 'Hi. We lack police officers in our city and I need your help, but nothing too hard.\nThere was a mysterious robbery in the bank, so far no suspect has been found...\nI suppose there\'s some clue in the bank.\nColt should know more about how this happened. Talk to him.',
				_add = 'Talk with Sherlock',
			},
			[2] = {
				_add = 'Go to the bank.',
			},
			[3] = {
				dialog = 'WHAT? Sherlock sent you here? I told him I\'m taking care of this case.\nTell him I don\'t need help. I can handle it myself.',
				_add = 'Talk with Colt.',
			},
			[4] = {
				_add = 'Go back to the police station.',
			},
			[5] = {
				dialog = 'I knew he wouldn\'t want to help us...\nWe\'ll have to look for clues without him.\nWe need to go to the bank when Colt is gone, you can do this, right?',
				_add = 'Talk with Sherlock.',
			},
			[6] = {
				_add = 'Enter in the bank while it\'s being robbed.',
			},
			[7] = {
				_add = 'Look for some clue in the bank.',
			},
			[8] = {
				_add = 'Go to the police station.',
			},

			[9] = {
				dialog = 'Very well! This cloth can help us to find the suspect.\nTalk with Indy. He will help us.',
				_add = 'Talk with Sherlock.',
			},
			[10] = {
				dialog = 'So... You\'ll need my help in this investigation?\nHmm... Let me see this cloth...\nI\'ve seen this cloth somewhere. It\'s used in the hospital! Take a look there!',
				_add = 'Talk with Indy.',
			},
			[11] = {
				_add = 'Go to the hospital.',
			},
			[12] = {
				_add = 'Search for something suspicious in the hospital.',
			},
			[13] = {
				_add = 'Go to the mine.',
			},
			[14] = {
				_add = 'Find the suspect and arrest him.',
			},
			[15] = {
				_add = 'Go to the police station.',
			},
			[16] = {
				dialog = 'Well done! You are really good on it.\nI know a great place to recover your energies after this long investigation: the coffee shop!',
				_add = 'Talk with Sherlock.',
			},
		},
		[4] = {
		    name = 'Quest 04: The sauce is gone!',
		    [0] = {
				dialog = 'Hi! Do you want to eat some pizza?\nWell... I have bad news for you.\nToday earlier I\'ve started making some pizzas, but I noticed that all the sauce had gone.\nI tried to buy some tomatoes in the market but aparently they don\'t sell it.\nI started to live in this town a few weeks ago, and I don\'t know anyone that can help me.\nSo please, can you help me? I just need the sauce to open my pizzeria.',
				_add = 'Talk with Kariina.',
		    },
		    [1] = {
		        _add = 'Go to the island.',
		    },
		    [2] = {
		        _add = 'Go to the seed store.',
		    },
		    [3] = {
		        _add = 'Buy a seed.',
		    },
		    [4] = {
		        _add = 'Go to your house.',
		    },
		    [5] = {
		        _add = 'Plant a seed in your house. (You\'ll need to use a garden!)',
		    },
		    [6] = {
		        _add = 'Harvest a tomato plant.',
		    },
		    [7] = {
		        _add = 'Go to the seed store.',
		    },
		    [8] = {
		        _add = 'Buy a water bucket.',
		    },
		    [9] = {
		        _add = 'Go to the market.',
		    },
		    [10] = {
		        _add = 'Buy some salt.',
		    },
		    [11] = {
		        _add = 'Cook a sauce. (You\'ll need to use an oven!)',
		    },
		    [12] = {
		        dialog = 'Wow! Thank you! Now I just need a spicy sauce. Could you make one?',
		        _add = 'Give the sauce to Kariina.',
		    },
		    [13] = {
		        _add = 'Plant a seed in your house.',
		    },
		    [14] = {
		        _add = 'Harvest a pepper plant',
		    },
		    [15] = {
		        _add = 'Cook a spicy sauce.',
		    },
		    [16] = {
		        dialog = 'OMG! You did it! Thank you!\nWhile you were gone, I realized that I need more wheat to make more dough... Could you bring me some wheat?',
		        _add = 'Give the spicy sauce to Kariina.',
		    },
		    [17] = {
		        _add = 'Plant a seed in your house.',
		    },
		    [18] = {
		        _add = 'Harvest wheat.',
		    },
		    [19] = {
				dialog = 'Wow! Thank you! You could work with me when I need a new employee.\nThank you for helping me. Now I can finish those pizzas!',
		        _add = 'Give the wheat to Kariina.',
		    },
		},
		[5] = {
			name = 'Quest 05: ????',
			[0] = {},
		},
	},
	noMissions = 'There are no missions available.',
	questsName = 'Quests',
	completedQuest = 'Quest Finished',
	receiveQuestReward = 'Claim Reward',
	rewardNotFound = 'Reward not found.',
	npc_mine6msg = 'This can collapse at any moment, but no one listens to me.',
	item_goldNugget = 'Gold',
	goldAdded = 'The gold nugget that you have collected was added to your bag.',
	sellGold = 'Sell %s Gold Nugget(s) for <vp>%s</vp>',
	settings_gameHour = 'Game Hour',
	settings_gamePlaces = 'Places',
	settingsText_availablePlaces = 'Available places: <vp>%s</vp>',
	settingsText_placeWithMorePlayers = 'Place with more players: <vp>%s</vp> <r>(%s)</r>',
	settingsText_hour = 'Current Time: <vp>%s</vp>',
	item_dynamite = 'Dynamite',
	placeDynamite = 'Place dynamite',
	energyInfo = '<v>%s</v> of energy',
	hungerInfo = '<v>%s</v> of food',
	itemDesc_clock = 'A simple clock that can be used once',
	itemDesc_dynamite = 'Boom!',
	minerpack = 'Miner Pack %s',
	itemDesc_minerpack = 'Containing %s pickaxe(s).',
	itemDesc_pickaxe = 'Break rocks',
	hey = 'Hey! Stop!',
	robberyInProgress = 'Robbery in progress',
	closed_bank = 'The bank is closed. Come back later!',
	bankRobAlert = 'The bank is being robbed. Defend it!',
	runAwayCoinInfo = 'You\'ll receive %s after completing the robbery.',
	atmMachine = 'ATM',
	codeInfo = 'Insert a valid code and click in submit to get your reward.\nYou can get new codes by joining in our Discord server.\n<a href="event:getDiscordLink"><v>(Click here to receive a invitation link)</v></a>',
	item_shrinkPotion = 'Shrink Potion',
	itemDesc_shrinkPotion = 'Use this potion to shrink for %s seconds!',
	mouseSizeError = 'You are too small to do this.',
	enterQuestPlace = 'Unlock this place after finishing <vp>%s</vp>.',
	closed_potionShop = 'The potion shop is closed. Come back later!',
	bag = 'Bag',
	ranking_coins = 'Accumulated Coins',
	ranking_spentCoins = 'Spent Coins',
	item_growthPotion = 'Growth Potion',
	itemDesc_growthPotion = 'Use this potion to growth for %s seconds!',
	codeAlreadyReceived = 'Code already used.',
	codeReceived = 'Your reward: %s.',
	codeNotAvailable = 'Code Unavailable',
	quest = 'Quest',
	job = 'Job',
	chooseOption = 'Choose an option',
	newUpdate = 'New update!',
	itemDesc_goldNugget = 'Shiny and expensive.',
	shop = 'Shop',
	item_coffee = 'Coffee',
	item_hotChocolate = 'Hot Chocolate',
	item_milkShake = 'Milkshake',
	speed = 'Speed: %s',
	price = 'Price: %s',
	owned = 'Owned',
	updateWarning = '<font size="10"><rose><p align="center">Warning!</p></rose>\nNew update in %smin %ss',
	waitUntilUpdate = '<rose>Please wait.</rose>',
	playerBannedFromRoom = '%s has been banned from this room.',
	playerUnbannedFromRoom = '%s has been unbanned.',
	harvest = 'Harvest',
	item_bag = 'Bag',
	itemDesc_bag = '+ %s bag capacity',
	item_seed = 'Seed',
	itemDesc_seed = 'A random seed.',
	item_tomato = 'Tomato',
	item_fertilizer = 'Fertilizer',
	itemDesc_fertilizer = 'Make seeds grow faster!',
	error_maxStorage = 'Maximum amount purchased.',
	drop = 'Drop',
	item_lemon = 'Lemon',
	item_lemonSeed = 'Lemon seed',
	item_tomatoSeed = 'Tomato seed',
	item_oregano = 'Oregano',
	item_oreganoSeed = 'Oregano seed',
	item_water = 'Water bucket',
	itemDesc_water = 'Make seeds grow faster!',
	houses = 'Houses',
	expansion = 'Expansions',
	furnitures = 'Furnitures',
	settings = 'Settings',
	furniture_oven = 'Oven',
	expansion_pool = 'Pool',
	expansion_garden = 'Garden',
	expansion_grass = 'Grass',
	chooseExpansion = 'Select an expansion',
	item_pepper = 'Pepper',
	item_luckyFlower = 'Lucky Flower',
	item_pepperSeed = 'Pepper seed',
	item_luckyFlowerSeed = 'Lucky Flower seed',
	closed_seedStore = 'The seed store is closed. Come back later!',
	item_salt = 'Salt',
	item_sauce = 'Tomato Sauce',
	item_hotsauce = 'Hot Sauce',
	item_dough = 'Dough',
	item_wheat = 'Wheat',
	item_wheatSeed = 'Wheat seed',
	item_pizza = 'Pizza',
	recipes = 'Recipes',
	cook = 'Cook',
	closed_furnitureStore = 'The furniture store is closed. Come back later!',
	maxFurnitureStorage = 'You can only have %s furnitures in your home.',
	furniture_kitchenCabinet = 'Kitchen Cabinet',
	sell = 'Sell',
	item_cornFlakes = 'Corn Flakes',
	furniture_flowerVase = 'Flower Vase',
	createdBy = 'Created by %s',
	furniture_painting = 'Painting',
	furniture_sofa = 'Sofa',
	furniture_chest = 'Chest',
	furniture_tv = 'Tv',
	transferedItem = 'The item %s was transfered to your bag.',
	passToBag = 'Transfer to bag',
	seeItems = 'Check Items',
	furnitureRewarded = 'Furniture Unlocked: %s',
	itemAddedToChest = 'The item %s was added in the chest.',
	farmer = 'Farmer',
	seedSold = 'You sold %s for %s.',
	item_pumpkin = 'Pumpkin',
	item_pumpkinSeed = 'Pumpkin seed',
	waitingForPlayers = 'Waiting for players...',
	_2ndquest = 'Side quest',
	sideQuests = {
		[1] = 'Plant %s seeds in Oliver\'s garden.',
		[2] = 'Fertilize %s plants in Oliver\'s garden.',
		[3] = 'Get %s coins.',
		[4] = 'Arrest a thief %s times.',
		[5] = 'Use %s items.',
		[6] = 'Spend %s coins.',
		[7] = 'Fish %s times.',
		[8] = 'Mine %s gold nuggets.',
		[9] = 'Rob the bank.',
		[10] = 'Complete %s robberies.',
		[11] = 'Cook %s times.',
		[12] = 'Get %s xp.',
		[13] = 'Fish %s frogs.',
		[14] = 'Fish %s lion fishes.',
		[15] = 'Deliver %s orders.',
		[16] = 'Deliver %s orders.', -- it's a different quest
		[17] = 'Make a pizza.',
		[18] = 'Make a bruschetta.',
		[19] = 'Make a lemonade.',
		[20] = 'Make a frogwich.',
	},
	profile_coins = 'Coins',
	profile_spentCoins = 'Spent Coins',
	profile_completedQuests = 'Quests',
	profile_completedSideQuests = 'Side Quests',
	profile_purchasedHouses = 'Purchased Houses',
	profile_purchasedCars = 'Purchased Vehicles',
	profile_basicStats = 'General Data',
	profile_questCoins = 'Quest points',
	levelUp = '%s reached level %s!',
	sidequestCompleted = 'You have completed a side quest!\nYour reward:',
	chestIsFull = 'The chest is full.',
	code = 'type a code',
	profile_jobs = 'Jobs',
	profile_arrestedPlayers = 'Arrested Players',
	profile_robbery = 'Robberies',
	profile_fishes = 'Fished',
	profile_gold = 'Collected Gold',
	profile_seedsPlanted = 'Crops',
	profile_seedsSold = 'Sales',
	level = 'Level %s',
	furniture_hay = 'Hay',
	furniture_shelf = 'Shelf',
	item_superFertilizer = 'Super Fertilizer',
	itemDesc_superFertilizer = 'It is 2x more effective than a fertilizer.',
	profile_badges = 'Badges',
	daysLeft = '%sd left.', -- d: abbreviation of days
	daysLeft2 = '%sd', -- d: abbreviation of days
	collectorItem = 'Collector\'s item',
	House4 = 'Barn',
	House5 = 'Haunted Mansion',
	houseSetting_storeFurnitures = 'Store all furnitures in the inventory',
	ghostbuster = 'Ghostbuster',
	furniture_rip = 'RIP',
	furniture_cross = 'Cross',
	furniture_pumpkin = 'Pumpkin',
	furniture_spiderweb = 'Spider Web',
	furniture_candle = 'Candle',
	furniture_cauldron = 'Cauldron',
	event_halloween2019 = 'Halloween 2019',
	ghost = 'Ghost',
	maxFurnitureDepot = 'Your furniture depot is full.',
	unlockedBadge = 'You have unlocked a new badge!',
	reward = 'Reward',
	badgeDesc_0 = 'Halloween 2019',
	badgeDesc_1 = 'Meet #mycity\'s creator',
	badgeDesc_3 = 'Mined 1000 gold nuggets',
	badgeDesc_2 = 'Fished 500 fishes',
	badgeDesc_4 = 'Harvested 500 plants',
	item_sugar = 'Sugar',
	item_chocolate = 'Chocolate',
	item_cookies = 'Cookies',
	furniture_christmasWreath = 'Christmas Wreath',
	furniture_christmasSocks = 'Christmas Sock',
	House6 = 'Christmas House',
	item_blueberries = 'Blueberries',
	item_blueberriesSeed = 'Blueberry seed',
	furniture_christmasFireplace = 'Fireplace',
	furniture_christmasSnowman = 'Snowman',
	furniture_christmasGift = 'Gift Box',
	vehicle_9 = 'Sleigh',
	badgeDesc_5 = 'Completed 500 thefts',
	badgeDesc_6 = 'Christmas 2019',
	badgeDesc_7 = 'Bought the sleigh',
	frozenLake = 'The lake is frozen. Wait for the end of winter to use a boat.',
	codeLevelError = 'You must reach the level %s to redeem this code.',
	furniture_christmasCarnivorousPlant = 'Carnivorous Plant',
	furniture_christmasCandyBowl = 'Candy Bowl',
	settingsText_grounds = 'Generated grounds: %s/509',
	locked_quest = 'Quest %s',
	furniture_apiary = 'Bee Box',
	item_cheese = 'Cheese',
	itemDesc_cheese = 'Use this item to get +1 cheese in Transformice shop!',
	item_fish_SmoltFry = 'Smolt Fry',
	item_fish_Lionfish = 'Lion Fish',
	item_fish_Dogfish = 'Dog Fish',
	item_fish_Catfish = 'Cat Fish',
	item_fish_RuntyGuppy = 'Runty Guppy',
	item_fish_Lobster = 'Lobster',
	item_fish_Goldenmare = 'Goldenmare',
	item_fish_Frog = 'Frog',
	emergencyMode_pause = '<cep><b>[Warning!]</b> <r>The module has reached it\'s critical limit and is being paused.',
	emergencyMode_resume = '<r>The module has been resumed.',
	emergencyMode_able = "<r>Initiating emergency shutdown, no new players allowed. Please go to another #mycity room.",
	settingsText_currentRuntime = 'Runtime: <r>%s</r>/60ms',
	settingsText_createdAt = 'Room created <vp>%s</vp> minutes ago.',
	limitedItemBlock = 'You must wait %s seconds to use this item.',
	eatItem = 'Eat',
	ranking_Season = 'Season %s',
	settings_help = 'Help',
	settings_settings = 'Settings',
	settings_credits = 'Credits',
	settings_donate = 'Donate',
	settings_creditsText = '<j>#Mycity</j> was created by <v>%s</v>, using arts from <v>%s</v> and translated by:',
	settings_creditsText2 = 'Special thanks to <v>%s</v> for helping with important resources for the module.',
	settings_donateText = '<j>#Mycity</j> is a project started in <b><cep>2014</cep></b>, but with another gameplay: <v>build a city</v>! However, this project did not go forward and it was canceled months later.\n In <b><cep>2017</cep></b>, I decided to redo it with a new objective: <v>live in a city</v>!\n\n The most part of the available functions were made by me for a <v>long and tiring</v> time.\n\n If you could and you are able to help me, make a donation. This encourages me to bring new updates!',
	wordSeparator = ' and ', -- a text separator. example: {1, 2, 3, AND 4}, {'apple, banana AND lemon'} 
	settings_config_lang = 'Language',
	settings_config_mirror = 'Mirrored Text',
	settings_helpText = 'Welcome to <j>#Mycity</j>!\n If you want to know how to play, press the button below:',
	settings_helpText2 = 'Available Commands:',
	command_profile = '<g>!profile</g> <v>[playerName]</v>\n 	Shows <i>playerName\'s</i> profile.',
	saveChanges = 'Save Changes',
	House7 = 'Treehouse',
	item_lemonade = 'Lemonade',
	item_lobsterBisque = 'Lobster Bisque',
	item_bread = 'Loaf of Bread',
	item_bruschetta = 'Bruschetta',
	item_waffles = 'Waffles',
	item_egg = 'Egg',
	item_honey = 'Honey',
	item_grilledLobster = 'Grilled Lobster',
	item_frogSandwich = 'Frogwich',
	item_chocolateCake = 'Chocolate Cake',
	item_wheatFlour = 'Wheat Flour',
	item_salad = 'Salad',
	item_lettuce = 'Lettuce',
	item_pierogies = 'Pierogies',
	item_potato = 'Potato',
	item_frenchFries = 'Fries',
	item_pudding = 'Pudding',
	item_garlicBread = 'Garlic Bread',
	item_garlic = 'Garlic',
	vehicle_11 = 'Yacht',
	vehicle_6 = 'Fishing Boat',
	vehicle_8 = 'Patrol Boat',
	npcDialog_Kapo = 'I always come here to check Dave\'s daily offers.\nSometimes I get rare items that only him owns!',
	npcDialog_Santih = 'There are a lot of people that still dare to fish in this pond.',
	npcDialog_Louis = 'I told her to not put olives...',
	npcDialog_Heinrich = 'Huh... So you want to be a miner? If so, you must be careful. When I was a little mouse, I used to get lost in this labyrinth.', 
	npcDialog_Davi = 'I\'m sorry but I can\'t let you go that way.',
	npcDialog_Alexa = 'Hey. What\'s new?',
	npcDialog_Sebastian = 'Hey dude.\n...\nI\'m not Colt.',
	captured = '<g>The thief <v>%s</v> was arrested!',
	arrestedPlayer = 'You arrested <v>%s</v>!',
	confirmButton_Work = 'Work!',
	chef = 'Chef',
	percentageFormat = '%s%%',
	rewardText = 'You have received an incredible reward!',
	confirmButton_Great = 'Great!',
	questCompleted = 'You have completed the quest %s!\nYour reward:',
	newLevelMessage = 'Congratulations! You have leveled up!',
	newLevel = 'New level!',
	experiencePoints = 'Experience points',
	newQuestSoon = 'The %sth quest is not available yet :/\n<font size="11">Development stage: %s%%',
	badgeDesc_9 = 'Fulfilled 500 orders',
	badgeDesc_10 = 'Arrested 500 thieves',
	multiTextFormating = '{0}: {1}', -- EX: "{0}: {1}" will return "Coins: 10" while "{1} : {0}" will return "10 : Coins"
	profile_fulfilledOrders = 'Fulfilled orders',
	profile_cookedDishes = 'Cooked dishes',
	profile_capturedGhosts = 'Captured ghosts',
	npcDialog_Marie = 'I looooooove cheese *-*',
	npcDialog_Rupe = 'Definitely a pickaxe made of stone is not a good choice for breaking stones.',
	npcDialog_Paulo = 'This box is really heavy...\nIt would be so nice if we had a forklift around here.',
	npcDialog_Lauren = 'She loves cheese.',
	npcDialog_Julie = 'Be careful. This supermarket is very dangerous.',
	npcDialog_Cassy = 'Have a good day!',
	npcDialog_Natasha = 'Hi!',
	itemInfo_Seed = 'Growing time: <vp>%smin</vp>\nPrice per seed: <vp>$%s</vp>',
	confirmButton_Select = 'Select',
	confirmButton_Buy = 'Buy for %s',
	confirmButton_Buy2 = 'Buy %s\nfor %s',
	newBadge = 'New badge',
	landVehicles = 'Land',
	waterVehicles = 'Water',
	houseDescription_1 = 'A small house.',
	houseDescription_2 = 'A big house for big families with big problems.',
	houseDescription_3 = 'Only the most braves can live in this house. Ooooo!',
	houseDescription_4 = 'Tired of living in a city? We have what you need.',
	houseDescription_5 = 'The real home of ghosts. Be careful!',
	houseDescription_6 = 'This cozy house will bring you comfort even in the coldest days.',
	houseDescription_7 = 'A house for those who love waking up closer to nature!',
	houseSettings = 'House Settings',
	houseSettings_permissions = 'Permissions', 
	houseSettings_buildMode = 'Build Mode',
	houseSettings_finish = 'Finish!',
	error_houseUnderEdit = '%s is editing the house.',
	sellFurniture = 'Sell Furniture',
	sellFurnitureWarning = 'Do you really want to sell this furniture?\n<r>This action can not be undone!</r>',
	confirmButton_Sell = 'Sell for %s',
	houseSettings_placeFurniture = 'Place',
	speed_knots = 'Knots',
	speed_km = 'Km/h',
	npcDialog_Blank = 'Do you need something from me?',
	vehicle_12 = 'Bugatti',
	orderCompleted = 'You have delivered the order of %s and received %s!',
	houseSettings_changeExpansion = 'Change Expansion',
	furniture_derp = 'Pigeon',
	furniture_testTubes = 'Test Tubes',
	furniture_bed = 'Bed',
	furniture_scarecrow = 'Scarecrow',
	furniture_fence = 'Fence',
	furniture_hayWagon = 'Hay Wagon',
	furniture_diningTable = 'Dining Table',
	furniture_bookcase = 'Bookcase',
	syncingGame = '<r>Syncing game data. The game will stop for a few seconds.',
	item_crystal_yellow = 'Yellow Crystal',
	item_crystal_blue = 'Blue Crystal',
	item_crystal_purple = 'Purple Crystal',
	item_crystal_green = 'Green Crystal',
	item_crystal_red = 'Red Crystal',
	closed_fishShop = 'The fish shop is closed. Come back later!',
	npcDialog_Jason = 'Hey... My store is not working for sales yet.\nPlease, come back soon!',
	houseSettings_lockHouse = 'Lock House',
	houseSettings_unlockHouse = 'Unlock House',
	houseSettings_reset = 'Reset',
	error_blockedFromHouse = 'You have been blocked from entering %s\'s house.',
	permissions_blocked = 'Blocked',
	permissions_guest = 'Guest',
	permissions_roommate = 'Roommate',
	permissions_coowner = 'Co-owner',
	permissions_owner = 'Owner',
	setPermission = 'Make %s',
	error_houseClosed = '%s closed this house.',
	itemAmount = 'Items: %s',
	vehicleError = 'You can\'t use this vehicle in this place.',
	confirmButton_tip = 'Tip',
	tip_vehicle = 'Click on the star next to your vehicle icon to make it your preferred vehicle. Press F or G on your keyboard to use your preferred car or boat respectively.',
	npcDialog_Billy = 'I can\'t wait to rob the bank tonight!',
	npcDialog_Derek = 'Psst.. We\'re going to score something big tonight: We\'ll rob the bank.\nIf you want to join us then you better talk to our boss Pablo.',
	npcDialog_Pablo = 'So, you want to be a thief? I have a feeling that you\'re an undercover cop...\nOh, you\'re not? Fine, I\'ll believe you then.\nYou\'re now a thief and have the ability to rob characters with a pink name by pressing SPACE. Remember to stay away from the cops!',
	npcDialog_Goldie = 'Do you want to sell a crystal? Drop it next to me so I can estimate its price.',
	npcDialog_Weth = 'Pudding *-*',
	itemInfo_miningPower = 'Rock damage: %s',
	daveOffers = 'Today\'s offers',
	placedFurnitures = 'Placed furnitures: %s',
	settings_donateText2 = 'Donators will get an exclusive NPC in honor for donating. Remember to send your Transformice nickname so I will be able to get your current outfit.',
	npcDialog_Bill = 'Heyo! Do you want to check your current fishing lucky?\nHmmm... Lemme see...\nYou have %s chance for getting a common fish, %s for a rare fish and %s for a mythical fish.\nYou also have %s chance for getting a legendary fish!',
	furniture_nightstand = 'Nightstand',
	furniture_bush = 'Bush',
	furniture_armchair = 'Armchair',
}

--[[ translations/es.lua ]]--
lang.es = {
	police = 'Policía',
	sale = 'En venta',
	close = 'Cerrar',
	soon = '¡Pronto!',
	house = 'Casa',
	yes = 'Sí',
	no = 'No',
	thief = 'Ladrón',
	House1 = 'Clasico',
	House2 = 'Casa Familiar',
	House3 = 'Casa Embrujada',
	goTo = 'Ir a',
	fisher = 'Pescador',
	furniture = 'Mueble',
	hospital = 'Hospital',
	open = 'Abrir',
	use = 'Usar',
	using = 'Usando',
	error = 'Error',
	submit = 'Enviar',
	cancel = 'Cancelar',
	fishWarning = "No puedes pescar aquí.",
	fishingError = 'Ya no estás pescando.',
	closed_market = 'El mercado está cerrado. Vuelva al amanecer.',
	closed_police = 'La estación de policías está cerrada. Vuelva al amanecer.',
	timeOut = 'Lugar no disponible.',
	password = 'Contraseña',
	passwordError = 'Min. 1 letrar',
	incorrect = 'Incorrecto',
	buy = 'Comprar',
	alreadyLand = 'Algúnn jugador ya ha adquirido este terreno.',
	moneyError = 'No tienes suficiente dinero.',
	copAlerted = 'Los policías han sido alertados.',
	looseMgs = 'Perderás en %s segundos.',
	runAway = 'Escapa en %s segundos.',
	alert = '¡Alerta!',
	copError = 'Tienes que esperar 10 segundos para capturar de nuevo.',
	closed_dealership = 'La agencia está cerrada. Vuelva al amanecer.',
	miner = 'Minero',
	pickaxeError = 'Tienes que comprar un pico.',
	pickaxes = 'Picos',
	closed_buildshop = 'La tienda de construcción está cerrada. Vuelva al amanecer.',
	energy = 'Energía',
	sleep = 'Dormir',
	leisure = 'Tiempo libre',
	hunger = 'Hambre',
	elevator = 'Elevador',
	healing = 'Serás curado en %s segundos',
	pizzaMaker = 'Pizzero',
	noEnergy = 'Necesitas más energía para trabajar de nuevo.',
	use = 'Usar',
	remove = 'Quitar',
	items = 'Objetos:',
	bagError = 'Espacio insuficiente en la mochila.',
	item_pickaxe = 'Pico',
	item_energyDrink_Basic = 'Sprite',
	item_energyDrink_Mega = 'Fanta',
	item_energyDrink_Ultra = 'Coca-Cola',
	item_clock = 'Reloj',
	boats = 'Botes',
	vehicles = 'Vehículos',
	error_boatInIsland = 'No podés usar un bote lejos del océano.',
	item_milk = 'Leche',
	mine5error = 'La mina colapsó.',
	vehicle_5 = 'Bote',
	noMissions = 'No hay misiones disponibles.',
	questsName = 'Misiones',
	completedQuest = 'Misiones Completadas',
	receiveQuestReward = 'Reclamar Premio',
	rewardNotFound = 'Premio no encontrado.',
	npc_mine6msg = 'Esto podría colapsar en cualquier momento, pero nadie me escucha.',
	item_goldNugget = 'Oro',
	goldAdded = 'La pepita de oro que conseguiste fue añadida a tu mochila.',
	sellGold = 'Vender %s Pepita(s) de Oro por <vp>%s</vp>',
	settings_gameHour = 'Hora de Juego',
	settings_gamePlaces = 'Lugares',
	settingsText_availablePlaces = 'Lugares disponibles: <vp>%s</vp>',
	settingsText_placeWithMorePlayers = 'Lugares con más jugadores: <vp>%s</vp> <r>(%s)</r>',
	settingsText_hour = 'Tiempo Actual: <vp>%s</vp>',
	item_dynamite = 'Dinamita',
	placeDynamite = 'Colocar dinamita',
	energyInfo = '<v>%s</v> de energía',
	hungerInfo = '<v>%s</v> de comida',
	itemDesc_clock = 'Un simple reloj de un solo uso.',
	itemDesc_dynamite = '¡Boom!',
	minerpack = 'Pack de Minero %s',
	itemDesc_minerpack = 'Contiene %s pico(s).',
	itemDesc_pickaxe = 'Rompe rocas',
	hey = '¡Hey! ¡Para!',
	robberyInProgress = 'Robo en progreso',
	closed_bank = 'El banco está cerrado. Vuelve más evening.',
	bankRobAlert = 'El banco está siendo robado. ¡Defiéndelo!',
	runAwayCoinInfo = 'Recibirás %s después de completar el robo.',
	atmMachine = 'Cajero automático',
	codeInfo = 'Inserta un códiglo válido y clickea en <b>submit</b> para obtener tu premio.\nPodés obtener nuevos códigos entrando a nuestro servidor de Discord.\n<a href="event:getDiscordLink"><v>(Click acá para obtener una invitación)</v></a>',
	item_shrinkPotion = 'Poción de Encogimiento',
	itemDesc_shrinkPotion = '¡Usa esta poción para encogerte por %s segundos!',
	mouseSizeError = 'Sos muy pequeño para hacer esto.',
	enterQuestPlace = 'Desbloquea este lugar después de completar <vp>%s</vp>.',
	closed_potionShop = 'La tienda de pociones está cerrada. Vuelve luego.',
	bag = 'Mochila',
	ranking_coins = 'Monedas Acumuladas',
	ranking_spentCoins = 'Monedas Usadas',
	item_growthPotion = 'Poción de Crecimiento',
	itemDesc_growthPotion = '¡Usa esta poción para ser grande por %s segundos!',
	codeAlreadyReceived = 'Código ya usado.',
	codeReceived = 'Tu premio: %s.',
	codeNotAvailable = 'Codigo Indisponible',
	quest = 'Misión',
	job = 'Trabajo',
	chooseOption = 'Selecciona una opción',
	newUpdate = '¡Nueva actualización!',
	itemDesc_goldNugget = 'Brillante y caro.',
	shop = 'Tienda',
	item_coffee = 'Café',
	item_hotChocolate = 'Chocolate Caliente',
	item_milkShake = 'Malteada',
	speed = 'Velocidad: %s',
	price = 'Precio: %s',
	owned = 'Obtenido',
	updateWarning = '<font size="10"><rose><p align="center">¡Advertencia!</p></rose>\nNueva actualización en %smin %ss',
	waitUntilUpdate = '<rose>Por favor espera.</rose>',
	playerBannedFromRoom = '%s fue baneado de esta sala.',
	playerUnbannedFromRoom = '%s fue desbaneado.',
	harvest = 'Cosechar',
	item_bag = 'Mochila',
	itemDesc_bag = '+ %s capacidad de mochila',
	item_seed = 'Semilla',
	itemDesc_seed = 'Una semilla aleatoria.',
	item_tomato = 'Tomate',
	item_fertilizer = 'Fertilizante',
	itemDesc_fertilizer = '¡Hace que las semillas crezcan más rápido!',
	error_maxStorage = 'Cantidad máxima comprada.',
	drop = 'Tirar',
	item_lemon = 'Limón',
	item_lemonSeed = 'Semilla de limón',
	item_tomatoSeed = 'Semilla de tomate',
	item_oregano = 'Orégano',
	item_oreganoSeed = 'Semilla de orégano',
	item_water = 'Balde de agua',
	itemDesc_water = '¡Hace que las semillas crezcan más rápido!',
	houses = 'Casas',
	expansion = 'Expansiones',
	furnitures = 'Muebles',
	settings = 'Ajustes',
	furniture_oven = 'Horno',
	expansion_pool = 'Piscina',
	expansion_garden = 'Jardín',
	expansion_grass = 'Pasto',
	chooseExpansion = 'Seleccioná una expansión',
	item_pepper = 'Pimienta',
	item_luckyFlower = 'Flor de la suerte',
	item_pepperSeed = 'Semilla de pimiento',
	item_luckyFlowerSeed = 'Semilla de la flor de la suerte',
	closed_seedStore = 'La tienda de semillas está cerrada. Volvé más evening.',
	item_salt = 'Sal',
	item_sauce = 'Salsa',
	item_hotsauce = 'Salsa picante',
	item_dough = 'Masa',
	item_wheat = 'Trigo',
	item_wheatSeed = 'Semilla de trigo',
	item_pizza = 'Pizza',
	recipes = 'Recetas',
	cook = 'Cocinar',
	closed_furnitureStore = 'La tienda de muebles está cerrada. Volvé mas evening.',
	maxFurnitureStorage = 'Solo podés tener %s muebles en tu casa.',
	furniture_kitchenCabinet = 'Gabinete de Cocina',
	sell = 'Vender',
	item_cornFlakes = 'Copos de Maíz',
	furniture_flowerVase = 'Florero',
	createdBy = 'Creado por %s',
	furniture_painting = 'Pintura',
	furniture_sofa = 'Sofá',
	furniture_chest = 'Cofre',
	furniture_tv = 'TV',
	transferedItem = 'El item %s fue transferido a tu mochila.',
	passToBag = 'Transferir a la mochila',
	seeItems = 'Ver Objetos',
	furnitureRewarded = 'Mueble desbloqueado: %s',
	itemAddedToChest = 'El item %s fue añadido al cofre.',
	farmer = 'Granjero',
	seedSold = 'Vendiste %s por %s.',
	item_pumpkin = 'Calabaza',
	item_pumpkinSeed = 'Semilla de Calabaza',
	waitingForPlayers = 'Esperando jugadores...',
	_2ndquest = 'Misión secundaria',
	sideQuests = {
		[1] = 'Planta %s semillas en el jardín de Oliver.',
		[2] = 'Fertiliza %s plantas en el jardín de Oliver.',
		[3] = 'Obtén %s monedas.',
		[4] = 'Arresta a un ladrón %s veces.',
		[5] = 'Usa %s objetos.',
		[6] = 'Usa %s monedas.',
		[7] = 'Pescar %s veces',
		[8] = 'Minar %s pepitas de oro',
	},
	profile_coins = 'Monedas',
	profile_spentCoins = 'Monedas Usadas',
	profile_completedQuests = 'Misiones',
	profile_completedSideQuests = 'Misiones Secundarias',
	profile_purchasedHouses = 'Casas Compradas',
	profile_purchasedCars = 'Vehículos Comprados',
	profile_basicStats = 'Datos Generales',
	profile_questCoins = 'Puntos de misión',
	levelUp = '¡%s alcanzó el nivel %s!',
	sidequestCompleted = '¡Completaste una misión secundaria!\nTu recompensa:',
	chestIsFull = 'El cofre está lleno.',
	code = 'escribe un código',
	profile_jobs = 'Trabajos',
	profile_arrestedPlayers = 'Jugadores Arrestados',
	profile_robbery = 'Robos',
	profile_fishes = 'Pescados',
	profile_gold = 'Oro Minado',
	profile_seedsPlanted = 'Cultivos',
	profile_seedsSold = 'Ventas',
	level = 'Nivel %s',
	furniture_hay = 'Heno',
}

--[[ translations/fr.lua ]]--
lang.fr = {
    item_crystal_green = "Cristal Vert",
    item_fish_RuntyGuppy = "Runty Guppy",
    landVehicles = "Terre",
    item_pumpkinSeed = "Graine de citrouille",
    item_garlic = "Ail",
    item_fish_Dogfish = "Aiguillat Commun",
    boats = "Bateaux",
    orderCompleted = "Vous avez livré la commande de %s et reçu %s!",
    furniture_christmasCandyBowl = "Bol de bonbons ",
    arrestedPlayer = "Vous avez arrêté <v>%s</v>!",
    houseSettings_placeFurniture = "Placer",
    item_lemon = "Citron",
    _2ndquest = "Quête annexe",
    vehicle_11 = "Yacht",
    itemDesc_pickaxe = "Briser des rochers",
    item_cornFlakes = "Céréales",
    furnitures = "Meubles",
    item_tomato = "Tomate",
    item_cheese = "Fromage",
    sellFurniture = "Vendre un Meuble",
    playerBannedFromRoom = "%s a été banni de ce salon",
    newLevel = "Nouveau niveaul!",
    houseSettings_reset = "Réinitialiser",
    permissions_blocked = "Bloquées",
    item_coffee = "Café",
    goTo = "Entrer",
    elevator = "Ascenseur",
    fishingError = "Vous n'avez pas péché de poissons.",
    noMissions = "Il n'y a pas de missions disponibles.",
    ranking_Season = "Saison %s",
    maxFurnitureStorage = "Vous ne pouvez qu'avoir %s meubles dans votre maison.",
    houseSettings_permissions = "Autorisations",
    item_fish_Lobster = "Homard",
    sell = "Vendre",
    furniture_christmasSnowman = "Bonhomme de Neige",
    furniture_christmasSocks = "Chausettes de Noël",
    runAwayCoinInfo = "Vous recevrez %s après avoir terminé le braquage.",
    item_sauce = "Sauce Tomate",
    houseSettings_lockHouse = "Maison Éclusière",
    houseDescription_3 = "Seuls les plus courageux peuvent vivre dans cette maison. Oouuh!",
    settings_config_lang = "Langue",
    item_wheat = "Blé",
    House4 = "Grange",
    remove = "Retirer",
    itemDesc_clock = "Une simple horloge qui ne peut être utilisée qu'une fois",
    rewardNotFound = "Récompense non trouvée.",
    badgeDesc_4 = "500 plantes récoltées",
    cook = "Cuisiner",
    furniture_bed = "Lit",
    seeItems = "Vérifier les Objets",
    furniture_painting = "Tableaux",
    furniture_christmasGift = "Boite Cadeau",
    item_fish_Frog = "Grenouille",
    settingsText_availablePlaces = "Places disponibles: <vp>%s</vp>",
    questCompleted = "Vous avez complété la quête %s!\nVotre récompense:",
    houseDescription_5 = "La vraie maison des fantômes. Faites attention!",
    permissions_guest = "Invité",
    newUpdate = "Nouvelle mise à jour!",
    expansion_pool = "Bassin",
    houseSettings_changeExpansion = "Modifier l'Extension",
    houseDescription_4 = "Fatigué de vivre dans une ville? Nous avons ce dont vous avez besoin.",
    furniture_derp = "Pigeon",
    closed_bank = "La banque est fermée. Revenez plus tard!",
    profile_arrestedPlayers = "Joueurs Arrêtés",
    item_lemonSeed = "Graine de citron",
    waterVehicles = "Eau",
    settings_helpText2 = "Commandes Disponibles:",
    item_salt = "Sel",
    hungerInfo = "<v>%s</v> de nourriture",
    codeNotAvailable = "Code Non-disponible",
    item_frogSandwich = "Gren-wich",
    buy = "Acheter",
    using = "en utilisant",
    npcDialog_Alexa = "Hey. Quoi de neuf?",
    robberyInProgress = "Braquage en cours",
    settingsText_grounds = "Terrains générés: %s/509",
    confirmButton_Buy2 = "Achetez %s\npour %s",
    itemDesc_shrinkPotion = "Utilisez cette potion pour rétrécir pendant %s secondes!",
    badgeDesc_9 = "500 commandes accomplies",
    moneyError = "Vous n'avez pas assez d'argent.",
    bagError = "Espace insuffisant dans le sac.",
    playerUnbannedFromRoom = "%s a été débanni.",
    npc_mine6msg = "Ça peut s'effondrer à n'importe quel moment, mais personne ne m'écoute.",
    hunger = "Faim",
    multiTextFormating = "{0}: {1}",
    House6 = "Maison de Noël",
    no = "Non",
    item_bruschetta = "Bruschetta",
    vehicle_6 = "Bateau de pêche",
    npcDialog_Santih = "Il y a beaucoup de gens qui osent encore pêcher dans cet étang.",
    item_water = "Seau d'eau",
    houseDescription_1 = "Une petite maison.",
    profile_purchasedCars = "Véhicules Achetés",
    item_fish_Lionfish = "Rascasse Volante",
    item_fertilizer = "Engrais",
    furniture_spiderweb = "Toile d'araignée",
    houseDescription_2 = "Une grande maison pour les grande famille avec de grands problèmes.",
    itemDesc_minerpack = "Contiens %s pioche(s).",
    sellFurnitureWarning = "Voulez-vous vraiment vendre ce meuble ?\n<r>Cette action est irréversible!</r>",
    npcDialog_Marie = "J'adooooooore le fromage *-*",
    pickaxeError = "Vous devez acheter une pioche.",
    profile_coins = "Argent",
    leisure = "Loisir",
    closed_market = "Le magasin est fermé. Revenez à l'aube.",
    pizzaMaker = "Pizzaiolo",
    use = "Utilise",
    confirmButton_Great = "Génial !",
    item_clock = "Horloge",
    rewardText = "Vous avez reçu une incroyable récompense!",
    furniture_christmasFireplace = "Cheminée",
    price = "Prix: %s",
    item_fish_SmoltFry = "Saumoneau",
    settings_donate = "Faire un don",
    permissions_coowner = "Copropriétaire",
    item_tomatoSeed = "Graine de Tomate",
    newBadge = "Nouveau badge",
    speed = "Vitesse: %s",
    furniture_chest = "Coffre",
    itemDesc_goldNugget = "Brillant et coûteu.",
    confirmButton_Sell = "Vendre pour %s",
    sideQuests = {
        [1] = "Plantez %s graines dans le jardin d'Oliver.",
        [2] = "Fertilisez %s plantes dans le jardin d'Oliver.",
        [4] = "Arrêtez un voleur %s fois.",
        [8] = "Minez %s pépites d'or.",
        [16] = "Livrez %s commandes.",
        [17] = "Préparez  une pizza.",
        [9] = "Braquez la banque.",
        [18] = "Préparez une bruschetta.",
        [5] = "Utilisez %s objets.",
        [10] = "Complétez %s vols.",
        [20] = "Préparez un grenwich.",
        [11] = "Cuisinez %s fois.",
        [3] = "Obtenez %s d'argent.",
        [6] = "Dépensez %s d'argent.",
        [12] = "Obtenez %s d'expérience.",
        [13] = "Pêchez %s grenouilles.",
        [7] = "Pêchez %s fois.",
        [14] = "Pêchez %s rascasses volantes.",
        [15] = "Livrez %s commandes.",
        [19] = "Préparez une limonade."
    },
    npcDialog_Paulo = "Cette boite est vraiment lourde...\nCe serait tellement bien si nous avions un chariot élévateur ici.",
    item_luckyFlowerSeed = "Graine de la Fleur de la Chance",
    item_seed = "Graine",
    settingsText_hour = "Heure Actuelle: <vp>%s</vp>",
    sellGold = "Vendre %s Pépite(s) d'Or pour <vp>%s</vp>",
    houseDescription_6 = "Cette maison confortable vous apportera du confort même par temps froid.",
    itemInfo_Seed = "Temps de pousse: <vp>%smin</vp>\nPrix par graine: <vp>$%s</vp>",
    levelUp = "%s a atteint le niveau %s!",
    sleep = "Dormir",
    item_superFertilizer = "Super Engrais",
    newQuestSoon = "La %sème quête n'est pas disponible pour le moment :/\n<font size=\"11\">Étape de développement: %s%%",
    settings_help = "Aide",
    badgeDesc_1 = "Rencontrer le créateur de #mycity",
    ranking_spentCoins = "Pièces Dépensées",
    profile_jobs = "Métiers",
    placeDynamite = "Placer de la dynamite",
    vehicle_5 = "Bateau",
    quest = "Quête",
    closed_furnitureStore = "Le magasin de meubles est fermé. Revenez plus tard!",
    error = "Erreur",
    item_milkShake = "Milkshake",
    confirmButton_Select = "Sélectionner",
    House1 = "Mison Classique",
    noEnergy = "Vous avez besoin de plus d'énergie plus retravailler.",
    furniture_hay = "Foins",
    questsName = "Quêtes",
    maxFurnitureDepot = "Votre dépôt de meubles est plein.",
    npcDialog_Billy = "J'ai hâte de braquer la banque ce soir!",
    vehicleError = "Vous ne pouvez pas utiliser ce véhicule à cet endroit.",
    item_oregano = "Origan",
    npcDialog_Pablo = "Alors, tu voudrais être un voleur? J'ai le sentiment que tu es un flic infiltré...\nOh, tu ne l'es pas? Très bien, je te croirai alors.\nTu es maintenant un voleur et as la possibilité de voler des personnages avec un nom rose en appuyant sur ESPACE. N'oublie pas de rester loin des flics!",
    expansion_garden = "Jardin",
    furniture_christmasWreath = "Couronne de Noël",
    timeOut = "Lieu non disponible.",
    house = "Maison",
    badgeDesc_7 = "Traîneau acheté",
    House5 = "Manoir Hanté",
    bag = "Sac",
    settings_config_mirror = "Text en Miroir",
    furniture_rip = "RIP",
    houseSetting_storeFurnitures = "Stockez tous les meubles dans l'inventaire",
    alreadyLand = "Un joueur a déjà acquis ce terrain.",
    soon = "Bientôt Disponible!",
    furniture_shelf = "Étagère",
    settings = "Réglages",
    emergencyMode_able = "<r>Démarrage de l'arrêt d'urgence, aucun nouveau joueur autorisé. Veuillez vous rendre dans un autre salon #mycity.",
    runAway = "Fuyez la police pendant %s secondes",
    item_lobsterBisque = "Bisque de Homard",
    item_hotChocolate = "Chocolat Chaud",
    incorrect = "Incorrecte",
    fishWarning = "Vous ne pouvez pas pécher ici.",
    alert = "Alerte!",
    item_sugar = "Sucre",
    npcDialog_Weth = "Pudding *-*",
    minerpack = "Pack Mineur %s",
    badgeDesc_2 = "500 poissons pêchés",
    settings_credits = "Crédits",
    item_wheatFlour = "Farine de Blé",
    confirmButton_Buy = "Acheter pour %s",
    percentageFormat = "%s%%",
    open = "Ouvrir",
    pickaxes = "Pioches",
    badgeDesc_3 = "1000 pépites d'or minées",
    closed_dealership = "Le concessionnaire est fermé. Revenez à l'aube.",
    hospital = "Hôpital",
    profile_badges = "Badges",
    item_pudding = "Pudding",
    yes = "Oui",
    bankRobAlert = "La banque se fait braquer. Défendez-la!",
    item_shrinkPotion = "Potion de Rétrécissement",
    item_bread = "Miche de Pain",
    item_dough = "Pâte",
    vehicle_9 = "Traîneau",
    vehicle_12 = "Bugatti",
    speed_knots = "Nœud",
    item_milk = "Bouteille de lait",
    badgeDesc_6 = "Noël 2019",
    password = "Mot de passe",
    furniture_tv = "Tv",
    frozenLake = "Le lac est glacé. Attend la fin de l'hiver pour utiliser un bateau.",
    codeLevelError = "Vous devez atteindre le niveau %s pour utiliser ce code.",
    profile_spentCoins = "Argent Dépensé",
    profile_seedsSold = "Ventes",
    furniture_bookcase = "Bibliothèque",
    item_energyDrink_Ultra = "Coca-Cola",
    profile_completedSideQuests = "Quêtes Annexes",
    expansion_grass = "Herbe",
    item_blueberriesSeed = "Graine de Myrtille",
    confirmButton_tip = "Astuce",
    closed_police = "Le commissariat de police est fermé. Revenez à l'aube.",
    error_boatInIsland = "Vous ne pouvez pas utiliser un bateau loin de la mer.",
    House3 = "Maison Hantée",
    houseDescription_7 = "Une maison pour ceux qui aiment se réveiller au plus près de la nature!",
    item_blueberries = "Myrtilles",
    passwordError = "Minimum 1 Lettre",
    confirmButton_Work = "Travail!",
    createdBy = "Créé par %s",
    cancel = "Annuler",
    emergencyMode_pause = "<cep><b>[Attention!]</b> <r>Le module a atteint sa limite critique et est en pause.",
    itemDesc_dynamite = "Boum!",
    profile_purchasedHouses = "Maisons Achetées",
    chestIsFull = "Le coffre est plein.",
    profile_capturedGhosts = "Fantômes Capturés",
    experiencePoints = "Points d'expériences",
    furniture_christmasCarnivorousPlant = "Plante Carnivore",
    looseMgs = "Vous serez libre dans %s secondes",
    House2 = "Maison familiale",
    badgeDesc_5 = "500 vols complétés",
    expansion = "Extensions",
    copError = "Vous devez attendre 10 secondes pour attraper un autre bandit.",
    closed_buildshop = "Le magasin de construction est fermé. Revenez plus tard!",
    furnitureRewarded = "Meubles Déverrouillés: %s",
    waitUntilUpdate = "<rose>Veuillez attendre.</rose>",
    permissions_roommate = "Colocataire",
    item_hotsauce = "Sauce Piquante",
    furniture_candle = "Bougie",
    atmMachine = "Distributeur",
    permissions_owner = "Propriétaire",
    itemAmount = "Objets: %s",
    item_energyDrink_Basic = "Sprite",
    setPermission = "Faire %s",
    closed_seedStore = "Le magasin de graines est fermé. Revenez plus tard!",
    limitedItemBlock = "Vous devez attendre %s secondes pour utiliser cet objet.",
    error_blockedFromHouse = "Vous ne pouvez pas rentrer dans la maison de %s.",
    farmer = "Fermier",
    error_maxStorage = "Montant maximum acheté.",
    profile_completedQuests = "Quêtes",
    item_fish_Goldenmare = "Goldenmare",
    reward = "Récompense",
    profile_fulfilledOrders = "Commandes Livrées",
    furniture = "Fournitures",
    houseSettings_buildMode = "Mode Construction",
    item_salad = "Salade",
    itemDesc_superFertilizer = "Il est 2x plus efficace qu'un engrais.",
    item_dynamite = "Dynamite",
    closed_fishShop = "La poissonnerie est fermée. Revenez plus tard!",
    settings_settings = "Options",
    furniture_pumpkin = "Citrouille",
    npcDialog_Cassy = "Bonne journée!",
    healing = "Vous serez guéri dans %s secondes",
    energyInfo = "<v>%s</v> d'énergie",
    error_houseUnderEdit = "%s modifie la maison.",
    item_garlicBread = "Pain à l'Ail",
    miner = "Mineur",
    copAlerted = "Les policiers ont été alerté.",
    item_oreganoSeed = "Graine d'origan",
    furniture_fence = "Clôture",
    itemAddedToChest = "L'objet %s a été ajouté dans votre coffre.",
    itemDesc_water = "Faites pousser les graines plus rapidement!",
    receiveQuestReward = "Récupérer la Récompense",
    goldAdded = "La pépite d'or que vous avez récupérée a été ajoutée dans votre sac.",
    npcDialog_Natasha = "Salut!",
    furniture_cauldron = "Chaudron",
    furniture_sofa = "Canapé",
    item_frenchFries = "Frites",
    npcDialog_Louis = "Je lui ai dit de ne pas mettre d'olives ...",
    houseSettings_finish = "Terminé!",
    npcDialog_Kapo = "Je viens tous les jours ici pour voir les nouvelles offres de Dave.\nParfois, j'arrive à avoir des objets rares que seul lui possède!",
    item_grilledLobster = "Homard Grillé",
    transferedItem = "L'objet %s a été transféré dans votre sac.",
    npcDialog_Lauren = "Elle aime le fromage.",
    houseSettings = "Paramètres de la Maison",
    eatItem = "Manger",
    recipes = "Recettes",
    close = "Fermer",
    updateWarning = "<font size=\"10\"><rose><p align=\"center\">Attention!</p></rose>\nNouvelle mise à jour dans %smin %ss",
    npcDialog_Julie = "Soyez prudents. Ce supermarché est très dangereux.",
    npcDialog_Rupe = "Définitivement une pioche en pierre n'est pas un bon choix pour casser des pierres.",
    locked_quest = "Quête %s",
    item_bag = "Sac",
    npcDialog_Jason = "Hey... Mon magasin ne vend rien pour le moment.\nRepasse bientôt, s'il te plaît!",
    code = "taper un code",
    item_egg = "Œuf",
    seedSold = "Vous avez vendu %s pour %s.",
    tip_vehicle = "Cliquez sur l'étoile à côté de l'icône de votre véhicule pour en faire votre véhicule préféré. Appuyez sur F ou G sur votre clavier pour utiliser votre voiture ou bateau préféré respectivement.",
    profile_cookedDishes = "Plats cuisinés",
    codeInfo = "Insérez un code valide et cliquez sur soumettre pour obtenir votre récompense.\nVous pouvez obtenir de nouveaux codes en joignant à notre serveur Discord.\n<a href=\"event:getDiscordLink\"><v>(Cliquez ici pour recevoir un lien d'invitation)</v></a>",
    furniture_hayWagon = "Meule de Foin",
    enterQuestPlace = "Déverrouillez cet endroit après avoir terminé <vp>%s</vp>.",
    police = "Policier",
    npcDialog_Goldie = "Voulez-vous vendre un cristal? Déposez-le à côté de moi pour que je puisse estimer son prix.",
    npcDialog_Davi = "Je suis désolé mais je ne peux pas te laisser partir par là.",
    item_luckyFlower = "Fleur de la Chance",
    furniture_cross = "Croix",
    furniture_diningTable = "Table à Manger",
    ranking_coins = "Argent Accumulé",
    furniture_oven = "Four",
    settings_creditsText = "<j>#Mycity</j> a été créé par <v>%s</v>, avec les talents d'art de <v>%s</v> et traduit par:",
    furniture_apiary = "Ruche",
    item_pepper = "Piment",
    event_halloween2019 = "Halloween 2019",
    energy = "Energie",
    item_lettuce = "Salade",
    emergencyMode_resume = "<r>Le module a repris.",
    quests = {
        [2] = {
            [0] = {
                _add = "Allez sur l'île."
            },
            [7] = {
                dialog = "Enfin! Vous devriez faire plus attention, J'aurais pu carrément regarder un film pendant que je t'attendais.\nVoulez-vous toujours voir le magasin? Je vais là-bas!",
                _add = "Apportez la clé à Indy."
            },
            [1] = {
                dialog = "Hey! Qui es-tu? Je ne t'ai jamais vu auparavant...\nJe m'appelle Indy! Je vie sur cette île depuis un long moment. Il y a de grands endroits pour se rencontrer ici.\nJe suis propriétaire du magasin de potions. Je pourrais t'y emmener, mais j'ai un gros problème: J'ai perdu mes clés de magasin!\nJ'ai du les avoir perdues dans la mine pendant que je minais. Pourrais-tu m'aider?",
                _add = "Parlez à Indy"
            },
            [2] = {
                _add = "Allez à la mine."
            },
            [4] = {
                dialog = "Merci! Maintenant je peux reprendre les affaires!\nAttends une seconde...\n1 clé est manquante: la clé du magasin! As-tu bien cherché?",
                _add = "Apportez les clés à Indy."
            },
            [5] = {
                _add = "Retournez à la mine."
            },
            name = "Quête 02: Les clés perdues",
            [3] = {
                _add = "Trouvez les clés d'Indy."
            },
            [6] = {
                _add = "Trouvez la dernière clé."
            }
        },
        [3] = {
            [0] = {
                _add = "Allez au commissariat."
            },
            [2] = {
                _add = "Allez à la banque."
            },
            [4] = {
                _add = "Retournez au commissariat."
            },
            [8] = {
                _add = "Allez au commissariat."
            },
            [16] = {
                dialog = "Bien joué! Tu es vraiment fort.\nJe connais un endroit idéal pour récupérer tes forces après cette longue enquête: le café!",
                _add = "Parlez à Sherlock."
            },
            [9] = {
                dialog = "Très bien! Ce tissu peut nous aider à retrouver le suspect.\nVa parler à Indy. Il nous aidera.",
                _add = "Parlez à Sherlock."
            },
            [5] = {
                dialog = "Je savais qu'il ne voudrait pas nous aider...\nNous devrons chercher des indices sans lui.\nNous devrons aller à la banque lorsque Colt sera parti, tu pourras le faire, non?",
                _add = "Parlez à Sherlock."
            },
            [10] = {
                dialog = "Alors ... vous avez besoin de mon aide dans cette enquête?\nHmm ... Laisse-moi voir ce tissu...\nJ'ai déjà vu ce tissu quelque part. Il est utilisé à l'hôpital! Jète un œil là-bas!",
                _add = "Parlez à Indy."
            },
            [11] = {
                _add = "Allez à l'hôpital."
            },
            [3] = {
                dialog = "QUOI? Sherlock t'as envoyé ici? Je lui ai dit que je m'occupais de cette affaire.\nDis-lui que je n'ai pas besoin d'aide. Je peux la gérer moi-même.",
                _add = "Parlez à Colt."
            },
            [6] = {
                _add = "Entrez dans la banque pendant qu'elle se fait braquer."
            },
            [12] = {
                _add = "Recherchez quelque chose de suspect à l'hôpital."
            },
            [13] = {
                _add = "Allez à la mine."
            },
            name = "Quête 03: Braquage",
            [14] = {
                _add = "Trouvez le suspect et arrêtez-le."
            },
            [1] = {
                dialog = "Salut. Nous manquons de policiers dans notre ville et j'ai besoin de ton aide, mais rien de trop difficile.\nIl y a eu un mystérieux vol dans la banque, jusqu'à présent aucun suspect n'a été trouvé...\nJe suppose qu'il y a des indices dans la banque.\nColt devrait en savoir plus sur la façon dont cela s'est produit. Va lui parler lui.",
                _add = "Parlez à Sherlock"
            },
            [7] = {
                _add = "Cherchez un indice dans la banque."
            },
            [15] = {
                _add = "Allez au commissariat."
            }
        },
        [1] = {
            [0] = {
                dialog = "Hey! Comment ça va? Récemment, certaines personnes ont découvert une petite île après la mer. Là-bas, Il y a beaucoup d'arbres et quelques bâtiments aussi.\nComme tu le sais, il n'y a pas d'aéroport dans la ville. La seule façon de s'y rendre en ce moment est de prendre un bateau.\nJe peux t'en construire un, mais j'aurai d'abord besoin d'aide.\nOLors de ma prochaine aventure, j'aimerais savoir ce qu'il y a de l'autre côté de la mine. J'ai quelques théories et j'aimerai les confirmer.\nJe pense que ça va être une longue expédition, je vais donc avoir besoin de beaucoup de nourriture.\nPeux-tu pêcher 5 poissons pour moi?",
                _add = "Parlez à Kane"
            },
            [7] = {
                dialog = "Merci de m'avoir aidé! Voici les planches en bois que tu m'as demandées. Fais-en bon usage!",
                _add = "Parlez à Chrystian"
            },
            [1] = {
                _add = "Pêchez %s poissons"
            },
            [2] = {
                dialog = "Wow! Merci pour ces poissons! J'ai hâte de les manger durant mon expédition.\nMaintenant, tu va devoir m'apporter 3 Coca-Cola. Tu peux les acheter au supermarché.",
                _add = "Parlez à Kane"
            },
            [4] = {
                dialog = "Merci de m'apporter la nourriture! Maintenant, c'est mon tour de retourner la faveur.\nMais pour ce faire, j'aurai besoin de planches en bois pour pouvoir te construire un bateau.\nRécemment, j'ai vu Chrystian couper des arbres et ramasser du bois. Demande-lui s'il peut te donner quelques planches en bois.",
                _add = "Parlez à Kane"
            },
            [8] = {
                dialog = "Tu as pris tellement de temps ... Je pensais que tu avais oublié de prendre les planches en bois ...\nAu fait, maintenant je peux construire ton bateau...\nVoici ton bateau! Amuse-toi sur la nouvelle île et n'oublie pas de faire attention!",
                _add = "Parlez à Kane"
            },
            [5] = {
                dialog = "Tu veux donc des planches en bois? Je peux t'en donner quelques unes, mais tu devras m'apporter des céréales.\nPourrais-tu faire cela?",
                _add = "Parlez à Chrystian"
            },
            name = "Quête 01: Construire un bateau",
            [3] = {
                _add = "Achetez %s Coca-Cola"
            },
            [6] = {
                _add = "Achetez une boite de céréales"
            }
        },
        [4] = {
            [0] = {
                dialog = "Salut! Veux-tu manger de la pizza?\nEh bien ... j'ai de mauvaises nouvelles pour toi.\nTôt aujourd'hui, j'ai commencé à faire des pizzas, mais j'ai remarqué qu'il n'y avait plus de sauce.\nJ'ai voulu acheter des tomates sur le marché mais apparemment ils n'en vendent pas.\nJ'ai commencé à vivre ici il y a quelques semaines et je ne connais personne qui puisse m'aider.\nAlors s'il te plaît, peux-tu m'aider? J'ai juste besoin de sauce pour ouvrir ma pizzeria.",
                _add = "Parlez à Kariina."
            },
            [2] = {
                _add = "Allez au magasin de graines."
            },
            [4] = {
                _add = "Allez dans votre maison."
            },
            [8] = {
                _add = "Achetez un seau d'eau."
            },
            [16] = {
                dialog = "OMD! Tu l'as fait! Je te remercie!\nWPendant ton absence, j'ai réalisé que j'avais besoin de plus de blé pour faire plus de pâte ... Pourrais-tu m'apporter du blé?",
                _add = "Donnez la sauce épicée à Kariina."
            },
            [17] = {
                _add = "Plantez une graine dans votre maison."
            },
            [9] = {
                _add = "Allez au marché."
            },
            [18] = {
                _add = "Récoltez du blé."
            },
            [5] = {
                _add = "Plantez une graine dans votre maison. (Vous devrez utiliser un jardin!)"
            },
            [10] = {
                _add = "Achetez du sel."
            },
            [11] = {
                _add = "Préparez une sauce. (Vous devrez utiliser un four!)"
            },
            [3] = {
                _add = "Achetez une graine."
            },
            [6] = {
                _add = "Récoltez un plant de tomate."
            },
            [12] = {
                dialog = "Wow! Je te remercie! Maintenant, j'ai juste besoin d'une sauce épicée. Pourrais-tu m'en faire une?",
                _add = "Donnez la sauce à Kariina."
            },
            [13] = {
                _add = "Plantez une graine dans votre maison."
            },
            name = "Quête 04: Il n'y a plus de sauce!",
            [14] = {
                _add = "Récoltez du piment."
            },
            [1] = {
                _add = "Allez sur l'île."
            },
            [7] = {
                _add = "Allez au magasin de graines."
            },
            [15] = {
                _add = "Cuire une sauce épicée."
            },
            [19] = {
                dialog = "Wow! Je te remercie! Tu pourras travailler avec moi lorsque j'aurais besoin d'un nouvel employé.\nMerci de m'avoir aidée. Maintenant je peux finir ces pizzas!",
                _add = "Donnez la pâte à Kariina."
            }
        },
        [5] = {
            name = "Quête 03: Braquage",
            [0] = {
                _add = "Allez au commissariat."
            }
        }
    },
    item_lemonade = "Limonade",
    houses = "Maisons",
    badgeDesc_0 = "Halloween 2019",
    House7 = "Cabane dans un Arbre",
    item_crystal_yellow = "Cristal Jaune",
    item_honey = "Miel",
    daysLeft2 = "%sd",
    furniture_testTubes = "Tubes à Essai",
    newLevelMessage = "Félicitatin! Vous êtes monté d'un niveau!",
    drop = "Lâcher",
    itemDesc_growthPotion = "Utilisez cette potion pour grandir pendant %s secondes!",
    item_waffles = "Gaufres",
    settings_gamePlaces = "Places",
    item_crystal_blue = "Cristal Bleu",
    item_chocolateCake = "Gâteau au Chocolat",
    itemDesc_cheese = "Utilisez cet objet pour obtenir +1 fromage dans le magasin de Transformice!",
    itemInfo_miningPower = "Dommages causés par à la roche: %s",
    saveChanges = "Sauvegarder les Modifications",
    settingsText_placeWithMorePlayers = "Places avec plus de joueurs: <vp>%s</vp> <r>(%s)</r>",
    thief = "Voleur",
    settings_creditsText2 = "Un grand remerciement à <v>%s</v> pour l'aide apporté sur d'importantes ressources du module.",
    profile_questCoins = "Points de quête",
    settings_donateText = "<j>#Mycity</j> est un projet démarré en <b><cep>2014</cep></b>, mais avec un autre gameplay: <v>construire une ville</v>! Cependant, ce projet n'a pas progressé et a été annulé des mois plus tard.\n En <b><cep>2017</cep></b>, J'ai décidé de le refaire avec un tout nouvel objectif: <v>vivre dans une ville</v>!\n\n La plus part des fonctions disponibles avaient été faites par moi depuis un <v>long et fatiguant</v> moment.\n\n Si vous voulez et pouvez de m'aider, faites un don. Cela m'encouragera à apporter de nouvelles mises à jour!",
    npcDialog_Blank = "As-tu besoin de quelque chose?",
    item_crystal_red = "Cristal Rouge",
    settingsText_createdAt = "Salon créé il y a <vp>%s</vp> minutes.",
    settingsText_currentRuntime = "Durée: <r>%s</r>/60ms",
    codeAlreadyReceived = "Code déjà utilisé.",
    item_potato = "Patates",
    captured = "<g>Le voleur <v>%s</v> a été arrêté!",
    syncingGame = "<r>Synchronisation des données de jeu. Le jeu s'arrêtera pendant quelques secondes.",
    itemDesc_bag = "+ %s places dans le sac",
    settings_helpText = "Bienvenue dans <j>#Mycity</j>!\n Si vous voulez savoir comment bien y jouer, appuyez sur le bouton ci-dessous:",
    ghost = "Fantôme",
    itemDesc_seed = "Une graine aléatoire.",
    sidequestCompleted = "Vous avez complété une quête annexe!\nVotre récompense:",
    item_fish_Catfish = "Poisson Chat",
    unlockedBadge = "Vous avez débloqué un nouveau badge!",
    profile_robbery = "Braquages",
    profile_fishes = "Pêchés",
    item_wheatSeed = "Graine de blé",
    item_pickaxe = "Pioche",
    item_crystal_purple = "Cristal Violet",
    passToBag = "Transfer dans le sac",
    item_goldNugget = "Or",
    ghostbuster = "Chasseur de fantômes",
    wordSeparator = " et ",
    daysLeft = "%sd restant(s).",
    submit = "Soumettre",
    level = "Niveau %s",
    command_profile = "<g>!profile</g> <v>[NomJoueur]</v>\n   Montre le profil du <i>Joueur</i>.",
    error_houseClosed = "%s a fermé cette maison.",
    item_pumpkin = "Citrouille",
    vehicle_8 = "Patrouilleur",
    sale = "A vendre",
    waitingForPlayers = "En attente de joueurs...",
    chef = "Chef",
    houseSettings_unlockHouse = "Déverrouiller la Maison",
    item_pierogies = "Pierogis",
    item_growthPotion = "Potion de Croissance",
    item_pizza = "Pizza",
    furniture_kitchenCabinet = "Armoires de Cuisine",
    furniture_flowerVase = "Vase à Fleurs",
    badgeDesc_10 = "Arrêter 500 voleurs",
    chooseExpansion = "Sélectionnez une extension",
    itemDesc_fertilizer = "Faites pousser les graines plus vite!!",
    owned = "Possédé",
    npcDialog_Sebastian = "Salut mec.\n...\nJe suis pas Colt.",
    npcDialog_Heinrich = "Huh... Alors tu voudrais être mineur? Si c'est le cas, tu devras être prudent. Quand je n'étais qu'une petite souris, j'avais l'habitude de me perdre dans ce labyrinthe.",
    item_chocolate = "Chocolat",
    profile_basicStats = "Données Générales",
    mouseSizeError = "Vous êtes trop petit pour faire cela.",
    codeReceived = "Votre récompense: %s.",
    chooseOption = "Choisissez une option",
    item_pepperSeed = "Graine de piment",
    item_energyDrink_Mega = "Fanta",
    npcDialog_Derek = "Psst.. Nous allons faire quelque chose de gros ce soir: Nous allons braquer la banque.\nSi tu veux nous rejoindre, tu ferais mieux de parler à notre patron Pablo.",
    harvest = "Récoltes",
    furniture_scarecrow = "Épouvantail",
    profile_seedsPlanted = "Cultures",
    collectorItem = "Objet collector",
    closed_potionShop = "Le magasin de potions est fermé. Reviens plus tard!",
    job = "Métier",
    mine5error = "La mine s'est effondrée.",
    fisher = "Pécheur",
    shop = "Magasin",
    item_cookies = "Cookies",
    vehicles = "Véhicules",
    speed_km = "Km/h",
    hey = "Hey! Arrêtez!",
    completedQuest = "Quête finie",
    items = "Objets:",
    profile_gold = "Or Collecté",
    settings_gameHour = "Heure du Jeu",
	police = 'Policier',
	sale = 'A vendre',
	close = 'Fermer',
	soon = 'Bientôt Disponible!',
	house = 'Maison',
	yes = 'Oui',
	no = 'Non',
	thief = 'Voleur',
	House1 = 'Mison Classique',
	House2 = 'Maison familiale',
	goTo = 'Entrer',
	fisher = 'Pécheur',
	furniture = 'Fournitures',
	hospital = 'Hôpital',
	open = 'Ouvrir',
	use = 'Utilise',
	using = 'en utilisant',
	error = 'Erreur',
	submit = 'Soumettre',
	cancel = 'Annuler',
	fishWarning = "Vous ne pouvez pas pécher ici.",
	fishingError = 'Vous n\'avez pas péché de poissons.',
	closed_market = 'Le magasin est fermé. Revenez à l\'aube.',
	closed_police = 'Le commissariat de police est fermé. Revenez à l\'aube.',
	timeOut = 'Lieu non disponible.',
	password = 'Mot de passe',
	passwordError = 'Minimum 1 Lettre',
	incorrect = 'Incorrecte',
	buy = 'Acheter',
	alreadyLand = 'Un joueur a déjà acquis ce terrain.',
	moneyError = 'Vous n\'avez pas assez d\'argent.',
	copAlerted = 'Les policiers ont été alerté.',
	looseMgs = 'Vous serez libre dans %s secondes',
	runAway = 'Fuyez la police pendant %s secondes',
	alert = 'Alerte!',
	copError = 'Vous devez attendre 10 secondes pour attraper un autre bandit.',
	closed_dealership = 'Le concessionnaire est fermé. Revenez à l\'aube.',
	item_sugar = 'Sucre',
    item_chocolate = 'Chocolat',
    item_cookies = 'Cookies',
    furniture_christmasWreath = 'Couronne de Noël',
    furniture_christmasSocks = 'Chausettes de Noël',
    House6 = 'Maison de Noël',
    item_blueberries = 'Myrtilles',
    item_blueberriesSeed = 'Graine de Myrtille',
    furniture_christmasFireplace = 'Cheminée',
    furniture_christmasSnowman = 'Bonhomme de Neige',
    furniture_christmasGift = 'Boite Cadeau',
    vehicle_9 = 'Traîneau',
    badgeDesc_5 = '500 vols complétés',
    badgeDesc_6 = 'Noël 2019',
    badgeDesc_7 = 'Traîneau acheté',
    frozenLake = 'Le lac est glacé. Attend la fin de l\'hiver pour utiliser un bateau.',
    codeLevelError = 'Vous devez atteindre le niveau %s pour utiliser ce code.',
    furniture_christmasCarnivorousPlant = 'Plante Carnivore',
    furniture_christmasCandyBowl = 'Bol de bonbons ',
    daveOffers = 'Offres du jour',
    placedFurnitures = 'Meubles placés: %s',
    settings_donateText2 = 'Les donateurs recevront un PNJ exclusif en l\'honneur de leur don. N\'oubliez pas d\'envoyer votre pseudo Transformice pour que je puisse récupérer votre tenue actuelle.',
    npcDialog_Bill = 'Heyo! Veux-tu voir tes chances de pêche actuelles?\nHmmm... Laisse moi voir...\nTu as %s de chance d\'avoir un poisson commun, %s d\'attraper un poisson rare  et %s de pêcher un poisson mythique.\n... Tu as aussi %s de chance de trouver un poisson légendaire!',  
    furniture_nightstand = 'Table de Nuit',
	furniture_bush = 'Buisson',
	furniture_armchair = 'Fauteuil',
}

--[[ translations/he.lua ]]--
lang.he = {
	police = 'שוטר',
	sale = 'למכירה',
	close = 'סגור',
	soon = 'בקרוב!',
	house = 'בית',
	yes = 'כן',
	no = 'לא',
	thief = 'גנב',
	House1 = 'בית קלאסי',
	House2 = 'בית משפחתי',
	House3 = 'בית רדוף',
	goTo = 'לך ל-',
	fisher = 'דייג',
	furniture = 'ריהוט',
	hospital = 'בית חולים',
	open = 'פתח',
	use = 'השתמש',
	using = 'משתמש',
	error = 'שגיאה',
	submit = 'הגש',
	cancel = 'בטל',
	fishWarning = "אתה לא יכול לדוג כאן.",
	fishingError = 'אתה לא דג יותר.',
	closed_market = 'החנות סגורה. בוא שוב מאוחר יותר.',
	closed_police = 'תחנת המשטרה סגורה. בוא שוב מאוחר יותר.',
	timeOut = 'מקום לא זמין.',
	password = 'סיסמה',
	passwordError = 'לפחות אות אחת',
	incorrect = 'לא נכון',
	buy = 'קנה',
	alreadyLand = 'שחקן אחר כבר השיג את השטח הזה.',
	moneyError = 'אין לך מספיק כסף.',
	copAlerted = 'השוטרים הוזעקו.',
	looseMgs = 'תשוחרר בעוד %s שניות.',
	runAway = 'ברח בעוד %s שניות.',
	alert = 'אזעקה!',
	copError = 'עליך לחכות 10 שניות כדי להחזיק שוב.',
	closed_dealership = 'הסוכנות סגורה. בוא שוב מאוחר יותר.',
	miner = 'כורה',
	pickaxeError = 'עליך לקנות מכוש.',
	pickaxes = 'מכושים',
	closed_buildshop = 'חנות הבניות סגורה. בוא שוב מאוחר יותר.',
	energy = 'אנרגיה',
	sleep = 'שינה',
	leisure = 'פנאי',
	hunger = 'רעב',
	elevator = 'מעלית',
	healing = 'אתה תתרפא בעוד %s שניות',
	pizzaMaker = 'יצרן פיצה',
	noEnergy = 'אתה צריך עוד אנרגיה בשביל לעבוד שוב.',
	use = 'השתמש',
	remove = 'הסר',
	items = 'פריטים:',
	bagError = 'חוסר מקום מתיק.',
	item_pickaxe = 'מכוש',
	item_energyDrink_Basic = 'ספרייט',
	item_energyDrink_Mega = 'פנטה',
	item_energyDrink_Ultra = 'קוקה-קולה',
	item_clock = 'שעון',
	boats = 'סירות',
	vehicles = 'מכוניות',
	error_boatInIsland = 'אתה לא יכול להשתמש בסירה רחוק מהים.',
	item_milk = 'בקבוק חלב',
	mine5error = 'המכרה התמוטט.',
	vehicle_5 = 'סירה',
	noMissions = 'אין משימות זמינות.',
	questsName = 'משימות',
	completedQuest = 'המשימה נגמרה',
	receiveQuestReward = 'קח את הפרס',
	rewardNotFound = 'הפרס לא נמצא.',
	npc_mine6msg = 'זה יכול להתמוטט בכל רגע, אבל אף אחד לא מקשיב לי.',
	item_goldNugget = 'זהב',
	goldAdded = 'גוש הזהב שאספת נוסף לתיקך.',
	sellGold = 'מכור %s גושי זהב ל- <vp>%s</vp>',
	settings_gameHour = 'שעת משחק',
	settings_gamePlaces = 'מקומות',
	settingsText_availablePlaces = 'מקומות זמינים: <vp>%s</vp>',
	settingsText_placeWithMorePlayers = 'מקום עם יותר שחקנים: <vp>%s</vp> <r>(%s)</r>',
	settingsText_hour = 'זמן נוכחי: <vp>%s</vp>',
	item_dynamite = 'דינמיט',
	placeDynamite = 'מקם דינמיט',
	energyInfo = '<v>%s</v> אנרגיה',
	hungerInfo = '<v>%s</v> אוכל',
	itemDesc_clock = 'שעון פשוט וחד שימושי',
	itemDesc_dynamite = 'בום!',
	minerpack = 'חבילת כורה %s',
	itemDesc_minerpack = 'מכיל %s מכושים.',
	itemDesc_pickaxe = 'שבור אבנים',
	hey = 'היי! עצור!',
	robberyInProgress = 'שוד בעיצומו',
	closed_bank = 'הבנק סגור. בוא שוב מאוחר יותר.',
	bankRobAlert = 'הבנק בתהליך שדידה. הגן עליו!',
	runAwayCoinInfo = 'אתה תקבל %s אחרי שתסיים את השוד.',
	atmMachine = 'כספומט',
	codeInfo = 'הכנס קוד נכון והגש בשביל לקבל את הפרס שלך.\nתוכל לקבל קודים חדשים על ידי הצטרפות לשרת הדיסקורד שלנו.\n<a href="event:getDiscordLink"><v>(לחץ כאן כדי לקבל קישור הזמנה)</v></a>',
	item_shrinkPotion = 'שיקוי כיווץ',
	itemDesc_shrinkPotion = 'השתמש בשיקוי הזה כדי להתכווץ ל- %s שניות!',
	mouseSizeError = 'אתה קטן מדי מכדי לעשות זאת.',
	enterQuestPlace = 'פתח את המקום הזה אחרי שתסיים את <vp>%s</vp>.',
	closed_potionShop = 'חנות השיקויים סגורה. בוא שוב מאוחר יותר.',
	bag = 'תיק',
	ranking_coins = 'מטבעות שנצברו',
	ranking_spentCoins = 'מטבעות שבוזבזו',
	item_growthPotion = 'שיקוי גדילה',
	itemDesc_growthPotion = 'השתמש בשיקוי הזה בשביל לגדול ל- %s שניות!',
	codeAlreadyReceived = 'הקוד שומש כבר.',
	codeReceived = 'הפרס שלך: %s.',
	codeNotAvailable = 'הקוד לא זמין',
	quest = 'משימה',
	job = 'עבודה',
	chooseOption = 'בחר אפשרות',
	newUpdate = 'עדכון חדש!',
	itemDesc_goldNugget = 'יקר ומבריק.',
	shop = 'חנות',
	item_coffee = 'קפה',
	item_hotChocolate = 'שוקולד חם',
	item_milkShake = 'מילק שייק',
	speed = 'מהירות: %s',
	price = 'מחיר: %s',
	owned = 'בבעלות',
	updateWarning = '<font size="10"><rose><p align="center">אזהרה!</p></rose>\nעדכון חדש בתוך %sדקות %sשניות',
	waitUntilUpdate = '<rose>חכה בבקשה.</rose>',
	playerBannedFromRoom = '%s הורחק מהחדר הזה.',
	playerUnbannedFromRoom = 'ההרחקה של %s נגמרה.',
	harvest = 'קצור',
	item_bag = 'תיק',
	itemDesc_bag = '+ %s מקום בתיק',
	item_seed = 'זרע',
	itemDesc_seed = 'זרע אקרעי.',
	item_tomato = 'עגבנייה',
	item_fertilizer = 'דשן',
	itemDesc_fertilizer = 'גרום לזרעים לצמוח מהר יותר!',
	error_maxStorage = 'כמות מקסימלית נרכשה.',
	drop = 'זרוק',
	item_lemon = 'לימון',
	item_lemonSeed = 'זרע לימון',
	item_tomatoSeed = 'זרע עגבנייה',
	item_oregano = 'אורגנו',
	item_oreganoSeed = 'זרע אורגנו',
	item_water = 'דלי מים',
	itemDesc_water = 'גרום לזרעים לצמוח מהר יותר!',
	houses = 'בתים',
	expansion = 'הרחבות',
	furnitures = 'ריהוט',
	settings = 'הגדרות',
	furniture_oven = 'תנור',
	expansion_pool = 'בריכה',
	expansion_garden = 'גינה',
	expansion_grass = 'דשא',
	chooseExpansion = 'בחר הרחבה',
	item_pepper = 'פלפל',
	item_luckyFlower = 'פרח מזל',
	item_pepperSeed = 'זרע פלפל',
	item_luckyFlowerSeed = 'זרע פרח מזל',
	closed_seedStore = 'חנות הזרעים סגורה. בוא שוב מאוחר יותר.',
	itemDesc_pepperSeed = '',
	itemDesc_tomatoSeed = '',
	itemDesc_lemonSeed = '',
	itemDesc_oreganoSeed = '',
	itemDesc_luckyFlowerSeed = '',
	itemDesc_wheatSeed = '',
	itemDesc_pumpkinSeed = '',
	itemDesc_blueberriesSeed = '',
	item_salt = 'מלח',
	item_sauce = 'רוטב',
	item_hotsauce = 'רוטב חם',
	item_dough = 'קמח',
	item_wheat = 'חיטה',
	item_wheatSeed = 'זרע חיטה',
	item_pizza = 'פיצה',
	recipes = 'מתכונים',
	cook = 'בשל',
	closed_furnitureStore = 'חנות הרהיטים סגורה. בוא שום אחר כך.',
	maxFurnitureStorage = 'יכולים להיות לך רק %s רהיטים בבית שלך.',
	furniture_kitchenCabinet = 'ארון מטבח',
	sell = 'מכור',
	item_cornFlakes = 'קורנפלקס',
	furniture_flowerVase = 'אגרטל',
	createdBy = 'נוצר על ידי %s',
	furniture_painting = 'ציור',
	furniture_sofa = 'ספה',
	furniture_chest = 'תיבה',
	furniture_tv = 'טלוויזיה',
	transferedItem = 'הפריט %s הועבר לתיקך.',
	passToBag = 'העבר אל התיק',
	seeItems = 'בחר פריטים',
	furnitureRewarded = 'ריהוט נפתח: %s',
	itemAddedToChest = 'הפריט %s נוסף לתיבה.',
	farmer = 'חוואי',
	seedSold = 'מכרת %s בשביל %s.',
	item_pumpkin = 'דלעת',
	item_pumpkinSeed = 'זרע דלעת',
	waitingForPlayers = 'מחכה לשחקנים...',
	_2ndquest = 'משימה צדדית',
	sideQuests = {
		[1] = 'זרע %s זרעים בגינה של אוליבר.',
		[2] = 'דשן %s צמחים בגינה של אוליבר.',
		[3] = 'השג %s מטבעות.',
		[4] = 'עצור גנב %s פעמים.',
		[5] = 'השתמש ב- %s פריטים.',
		[6] = 'בזבז %s מטבעות.',
		[7] = 'דוג %s פעמים.',
		[8] = 'כרה %s גושי זהב.',
		[9] = 'שדוד את הבנק בלי להיעצר.',
	},
	profile_coins = 'מטבעות',
	profile_spentCoins = 'מטבעות שבוזבזו',
	profile_completedQuests = 'משימות',
	profile_completedSideQuests = 'משימות צדדיות',
	profile_purchasedHouses = 'בתים שנרכשו',
	profile_purchasedCars = 'מכוניות שנרכשו',
	profile_basicStats = 'נתונים כלליים',
	profile_questCoins = 'נקודות משימה',
	levelUp = '%s הגיע לרמה %s!',
	sidequestCompleted = 'סיימת משימה צדדית!\nהפרס שלך:',
	chestIsFull = 'התיבה מלאה.',
	code = 'הכנס קוד',
	profile_jobs = 'עבודות',
	profile_arrestedPlayers = 'שחקנים שנעצרו',
	profile_robbery = 'שודים',
	profile_fishes = 'דגים',
	profile_gold = 'זהב שנאסף',
	profile_seedsPlanted = 'יבולים',
	profile_seedsSold = 'מכירות',
	level = 'רמה %s',
	furniture_hay = 'חציר',
	furniture_shelf = 'מדף',
	item_superFertilizer = 'סופר דשן',
	itemDesc_superFertilizer = 'זה כפול שתיים יותר אפקטיבי מדשן רגיל.',
	profile_badges = 'תגים',
	daysLeft = 'נותרו %s ימים.', -- d: abbreviation of days
	daysLeft2 = '%s ימים', -- d: abbreviation of days
	collectorItem = 'פריט אספנים',
	House4 = 'אסם',
	House5 = 'אחוזה רדופה',
	houseSetting_storeFurnitures = 'שמור את כל הרהיטים בתיק',
	ghostbuster = 'מכסח רוחות',
	furniture_rip = 'זל',
	furniture_cross = 'צלב',
	furniture_pumpkin = 'דלעת',
	furniture_spiderweb = 'קורי עכביש',
	furniture_candle = 'נר',
	furniture_cauldron = 'קדרה',
	event_halloween2019 = 'ליל כל הקדושים 2019',
	ghost = 'רוח רפאים',
	maxFurnitureDepot = 'מחסן הריהוט שלך מלא.',
	unlockedBadge = 'השגת תג חדש!',
	reward = 'פרס',
	badgeDesc_0 = 'ליל כל הקדושים 2019',
	badgeDesc_1 = 'פגוש את היוצר של #mycity',
	badgeDesc_3 = 'כרה 1000 גושי זהב',
	badgeDesc_2 = 'דג 500 דגים',
	badgeDesc_4 = 'קצר 500 צמחים',
	item_sugar = 'סוכר',
	item_chocolate = 'שוקולד',
	item_cookies = 'עוגיות',
	furniture_christmasWreath = 'זר חג המולד',
	furniture_christmasSocks = 'גרבי חג המולד',
	House6 = 'בית חג המולד',
	item_blueberries = 'אוכמניות',
	item_blueberriesSeed = 'זרע אוכמנייה',
	furniture_christmasFireplace = 'אח',
	furniture_christmasSnowman = 'איש שלג',
	furniture_christmasGift = 'קופסת מתנה',
	vehicle_9 = 'מזחלת',
	badgeDesc_5 = '500 גניבות שנגמרו',
	badgeDesc_6 = 'חג המולד 2019',
	badgeDesc_7 = 'קנה את המזחלת',
	frozenLake = 'האגם קפוא. חכה לסוף החורף כדי להשתמש בסירה.',
	codeLevelError = 'עליך להגיע לשלב %s כדי להשתמש בקוד זה.',
	furniture_christmasCarnivorousPlant = 'צמח טורף',
	furniture_christmasCandyBowl = 'קערת ממתקים',
	settingsText_grounds = 'אדמות שנוצרו: %s/509',
    locked_quest = 'משימה %s',
    furniture_apiary = 'קופסת דבורים',
    item_cheese = 'גבינה',
    itemDesc_cheese = 'השתמש בפריט זה על מנת לקבל גבינה בחנות המשחק!',
    item_fish_SmoltFry = 'טגן סמולט',
    item_fish_Lionfish = 'זהרון',
    item_fish_Dogfish = 'קוצן',
    item_fish_Catfish = 'שפמנון',
    item_fish_RuntyGuppy = 'ראנטי גאפי',
    item_fish_Lobster = 'לובסטר',
    item_fish_Goldenmare = 'Goldenmare',
    item_fish_Frog = 'צפרדע',
    emergencyMode_pause = '<cep><b>[Warning!]</b> <r>המודול הגיע להגבלה הקריטית שלו והושהה.',
    emergencyMode_resume = '<r>המודול הומשך.',
    emergencyMode_able = "<r>מפעיל כיבוי חירום, שחקנים חדשים לא מורשים. אנא לך לחדר #mycity אחר.",
    settingsText_currentRuntime = 'זמן ריצה: <r>%s</r>/60ms',
    settingsText_createdAt = 'חדר נוצר לפני <vp>%s</vp> דקות.',
    limitedItemBlock = 'עליך לחכות %s שניות על מנת להשתמש בפריט זה.',
    daveOffers = 'הצעות היום',
    placedFurnitures = 'ריהוטים ממוקמים: %s',
}

--[[ translations/hu.lua ]]--
lang.hu = {
	daveOffers = 'Mai ajánlatok',
    placedFurnitures = 'Lehelyezett bútorok: %s',
    item_crystal_green = "Zöld Kristály",
    item_fish_RuntyGuppy = "Runty Guppy",
    landVehicles = "Szárazföldi",
    item_pumpkinSeed = "Tökmag",
    item_garlic = "Fokhagyma",
    item_fish_Dogfish = "Kutyahal",
    boats = "Hajók",
    item_blueberries = "Áfonyák",
    furniture_christmasCandyBowl = "Cukros Tál",
    enterQuestPlace = "Ez a hely a <vp>%s</vp> teljesítése után lesz elérhető.",
    houseSettings_placeFurniture = "Lehelyez",
    item_lemon = "Citrom",
    _2ndquest = "Mellékküldetés",
    vehicle_11 = "Jacht",
    itemDesc_pickaxe = "Törj sziklákat",
    item_cornFlakes = "Kukoricapehely",
    furnitures = "Bútorok",
    item_tomato = "Paradicsom",
    item_cheese = "Sajt",
    hospital = "Kórház",
    playerBannedFromRoom = "%s ki lett tiltva ebből a szobából.",
    newLevel = "Új szint!",
    houseSettings_reset = "Visszaállít",
    permissions_blocked = "Zárolt",
    item_coffee = "Kávé",
    goTo = "Belépés",
    elevator = "Lift",
    fishingError = "Most már nem horgászol.",
    noMissions = "Nincsenek elérhető küldetések.",
    ranking_Season = "Évad %s",
    job = "Munka",
    houseSettings_permissions = "Jogosultságok",
    item_fish_Lobster = "Homár",
    sell = "Eladás",
    furniture_christmasSnowman = "Hóember",
    furniture_christmasSocks = "Karácsonyi Zokni",
    runAwayCoinInfo = "A rablás befejezése után %s-t kapsz.",
    item_sauce = "Szósz",
    houseSettings_lockHouse = "Ház bezárása",
    houseDescription_3 = "Csak a legbátrabbak élhetnek ebben a házban. Ooooo!",
    settings_config_lang = "Nyelv",
    item_wheat = "Búza",
    House4 = "Istálló",
    remove = "Eltávolítás",
    itemDesc_clock = "Egyszerű óra, mely egyszer használható",
    rewardNotFound = "A jutalom nem található.",
    badgeDesc_4 = "Takaríts be 500 növényt",
    cook = "Főzés",
    furniture_bed = "Ágy",
    seeItems = "Tárgyak mutatása",
    furniture_painting = "Festmény",
    furniture_christmasGift = "Ajándékdoboz",
    item_fish_Frog = "Béka",
    settingsText_availablePlaces = "Elérhető helyek: <vp>%s</vp>",
    yes = "Igen",
    houseDescription_5 = "A szellemek valódi otthona. Légy óvatos!",
    permissions_guest = "Vendég",
    newUpdate = "Új frissítés!",
    expansion_pool = "Medence",
    itemAddedToChest = "A(z) %s hozzáadva a ládához.",
    fishWarning = "Itt nem tudsz horgászni.",
    furniture_derp = "Galamb",
    closed_bank = "A Bank zárva van.\nGyere vissza 07:00-kor!",
    profile_arrestedPlayers = "Letartóztatott játékosok",
    item_lemonSeed = "Citrommag",
    receiveQuestReward = "Jutalom begyűjtése",
    settings_helpText2 = "Meglévő parancsok:",
    item_salt = "Só",
    hungerInfo = "<v>%s</v> étel",
    codeNotAvailable = "A kód nem érhető el.",
    item_frogSandwich = "Béka szendvics",
    buy = "Vásárlás",
    using = "Használatban",
    npcDialog_Alexa = "Helló. Mi újság?",
    robberyInProgress = "Rablás folyamatban",
    settingsText_grounds = "Generált területek: %s/509",
    confirmButton_Buy = "Vásárlás %s",
    itemDesc_shrinkPotion = "Használd ezt a bájitalt, hogy összezsugorodj %s másodpercre!",
    badgeDesc_9 = "Teljesítettél 500 megrendelést",
    moneyError = "Nincs elég pénzed.",
    bagError = "Nincs elég hely a táskádban!",
    playerUnbannedFromRoom = "El lett távolítva %s kitiltása, így újra játszhat.",
    npc_mine6msg = "Ez bármikor beomolhat, de senki sem hallgat rám.",
    hunger = "Éhség",
    passwordError = "Min. 1 karakter",
    House6 = "Karácsonyi Ház",
    no = "Nem",
    item_bruschetta = "Bruschetta",
    vehicle_6 = "Halászhajó",
    npcDialog_Santih = "Sok ember még mindig mer horgászni ebben a tóban.",
    item_water = "Vizesvödör",
    houseDescription_1 = "Egy kis ház.",
    profile_purchasedCars = "Vásárolt járművek",
    item_fish_Lionfish = "Oroszlán hal",
    item_fertilizer = "Trágya",
    furniture_spiderweb = "Pókháló",
    item_fish_Goldenmare = "Aranyhal",
    itemDesc_minerpack = "%s csákányt tartalmaz.",
    sellFurnitureWarning = "Biztosan eladod ezt a bútort?\n<r>A művelet nem visszavonható!</r>",
    profile_completedQuests = "Küldetések",
    pickaxeError = "Csákányra lesz szükséged!",
    profile_coins = "Érmék",
    house = "Ház",
    closed_market = "A Bolt zárva van.\nGyere vissza 08:00-kor!",
    pizzaMaker = "Pizzakészítő",
    use = "Használ",
    item_sugar = "Cukor",
    item_clock = "Óra",
    rewardText = "Hihetetlen jutalmakat kaptál!",
    furniture_christmasFireplace = "Kandalló",
    price = "Ár: %s",
    House2 = "Családi Ház",
    settings_donate = "Adományozás",
    furniture_candle = "Gyertya",
    item_tomatoSeed = "Paradicsommag",
    newBadge = "Új jelvény",
    speed = "Sebesség: %s",
    furniture_chest = "Láda",
    itemDesc_goldNugget = "Fényes és drága.",
    confirmButton_Sell = "Eladás %s -ért",
    sideQuests = {
        [1] = "Ültess %s magot Oliver kertjébe.",
        [2] = "Trágyázd be a %s növényeket Oliver kertjében.",
        [3] = "Gyűjts %s érmét.",
        [4] = "Tartóztass le egy tolvajt %s alkalommal.",
        [5] = "Használj %s tárgyat.",
        [6] = "Költs el %s érmét.",
        [7] = "Horgássz %s alkalommal.",
        [8] = "Bányássz %s Aranyrögöt.",
        [9] = "Rabold ki a bankot anélkül, hogy letartóztatnának.",
        [10] = "Teljesíts %s rablást.",
        [11] = "Főzz %s alkalommal.",
        [12] = "Szerezz %s xp-t.",
        [13] = "Fogj ki %s békát.",
        [14] = "Fogj ki %s oroszlánhalat.",
        [15] = "Szállíts ki %s megrendelést.",
        [16] = "Szállíts ki %s megrendelést.",
        [17] = "Készíts egy pizzát.",
        [18] = "Készíts egy bruschettat.",
        [19] = "Készíts egy limonádét.",
        [20] = "Készíts egy béka szendvicset."
    },
    npcDialog_Paulo = "Ez a doboz igazán nehéz...\nJó lenne, ha itt volna egy targonca.",
    item_luckyFlowerSeed = "Szerencsevirág mag",
    item_seed = "Mag",
    settingsText_hour = "Aktuális idő: <vp>%s</vp>",
    sellGold = "%s aranyrög eladása <vp>%s</vp>-ért",
    houseDescription_6 = "Ez az otthonos ház még a hideg napokban is kényelmet nyújt számodra.",
    itemInfo_Seed = "Növekedési idő: <vp>%s perc</vp>\nMagonkénti ár: <vp>$%s</vp>",
    levelUp = "%s elérte a(z) %s. szintet!",
    sleep = "Alvás",
    item_superFertilizer = "Szupertrágya",
    newQuestSoon = "A Küldetés %s még nem érhető el:/\n<font size=\"11\">Fejlesztési stádium: %s%%",
    settings_help = "Segítség",
    badgeDesc_1 = "Találkozz a #mycity alkotójával",
    ranking_spentCoins = "Elköltött érme",
    profile_jobs = "Munkák",
    placeDynamite = "Dinamit elhelyezése",
    npcDialog_Natasha = "Szia!",
    vehicle_5 = "Csónak",
    quest = "Küldetés",
    closed_furnitureStore = "A Bútorbolt zárva van.\nGyere vissza később!",
    furniture_hayWagon = "Szénás Kocsi",
    experiencePoints = "Tapasztalati pont",
    permissions_owner = "Tulajdonos",
    item_milkShake = "Tejturmix",
    confirmButton_Select = "Kiválaszt",
    command_profile = "<g>!profile</g> <v>[játékosNév]</v>\n   Megmutatja <i>játékosNév</i> profilját.",
    noEnergy = "Több energiára lesz szükséged, hogy újra munkába állj.",
    item_pierogies = "Pierogies",
    runAway = "Menekülj %s másodpercig.",
    maxFurnitureDepot = "A bútorraktár megtelt.",
    npcDialog_Billy = "Alig várom, hogy ma este kiraboljam a bankot!",
    vehicleError = "Ezen a helyen nem használhatod ezt a járművet.",
    item_oregano = "Oregánó",
    npcDialog_Pablo = "Szóval, rabló akarsz lenni? Úgy érzem, titkos zsaru vagy...\nOh, nem vagy? Rendben, akkor hiszek neked.\nMost már rabló vagy. Rabolj a rózsaszín névvel ellátott karakterektől a SPACE gombot lenyomva. Ne felejts el távol maradni a zsaruktól!",    expansion_garden = "Kert",
    syncingGame = "<r>A játék adatainak szinkronizálása. A játék néhány másodpercre leáll.",
    settings_creditsText2 = "Különleges köszönet <v>%s</v>-nek a modul fontos erőforrásainak segítéséért.",
    permissions_coowner = "Társtulajdonos",
    furniture_apiary = "Méh doboz",
    House5 = "Kísértet Kastély",
    saveChanges = "Változtatások Mentése",
    item_honey = "Méz",
    furniture_rip = "RIP",
    houseSetting_storeFurnitures = "Az összes bútor áthelyezése a bútorraktárba",
    quests = {
        [2] = {
            [0] = {
                _add = "Menj a szigetre."
            },
            [7] = {
                dialog = "Végre! Jobban kell figyelned, mert akár egy filmet is nézhettem volna, amíg vártam rád.\nMég mindig akarsz találkozni az üzletnél? Megyek oda!",
                _add = "Vidd el neki a kulcsot: Indy."
            },
            [1] = {
                dialog = "Hé! Te meg ki vagy? Még soha sem láttalak ez előtt...\nA nevem Indy! Hosszú ideje ezen a szigeten élek. Nagyszerű helyekkel találkozhatsz itt.\nA Bájitalbolt tulajdonosa vagyok. Meghívnálak, hogy találkozz az ütlettel, de van egy nagy problémám: Elvesztettem az üzletem kulcsait!!\nTalán a bányászatom során veszítettem el. Tudsz nekem segíteni?",
                _add = "Bezsélj vele: Indy"
            },
            [2] = {
                _add = "Menj a Bányába."
            },
            [4] = {
                dialog = "Köszönöm! Most már visszamehetek az üzletbe!\nVárjunk csak...\n1 kulcs hiányzik: az üzlet kulcsa! Nehéznek tűnik?",
                _add = "Vidd el neki a kulcsot: Indy."
            },
            [5] = {
                _add = "Menj vissza a Bányába."
            },
            name = "Küldetés 02: Az elveszett kulcsok",
            [3] = {
                _add = "Keresd meg Indy kulcsait."
            },
            [6] = {
                _add = "Keresd meg Indy kulcsait."
            }
        },
        [3] = {
            [0] = {
                _add = "Menj a Rendőrségre."
            },
            [2] = {
                _add = "Menj a Bankba."
            },
            [4] = {
                _add = "Menj vissza a Rendőrségre."
            },
            [8] = {
                _add = "Menj a Rendőrségre."
            },
            [16] = {
                dialog = "Szép munka! Igazán ügyes vagy.\nTudok egy nagyszerű helyet az energiád feltöltésére a hosszú nyomozás után: a Kávézó!",
                _add = "Beszélj vele: Sherlock."
            },
            [9] = {
                dialog = "Nagyon jó! Ez a ruha segíthet megtalálni a gyanusítottat.\nBeszélj Indy-vel. Ő segíteni fog nekünk.",
                _add = "Beszélj vele: Sherlock."
            },
            [5] = {
                dialog = "Tudtam, hogy nem akar segíteni nekünk...\nNélküle kell nyomokat keresnünk.\nA Bankba kell mennünk, amikor Colt nincs ott. Meg tudod csinálni, igaz?",
                _add = "Beszélj vele: Sherlock."
            },
            [10] = {
                dialog = "Szóval... Szükséged van a segítségemre ebben a nyomozásban?\nHmm... Hadd lássam azt a ruhát...\nLáttam már ezt valahol. A Kórházban használják! Menj, nézd meg!",
                _add = "Beszélj vele: Indy."
            },
            [11] = {
                _add = "Menj a Kórházba."
            },
            [3] = {
                dialog = "MICSODA? Sherlock küldött ide? Mondtam neki, hogy gondoskodom az ügyről.\nMondd meg neki, hogy nincs szükségem segítségre. Boldogulok egyedül.",
                _add = "Beszélj vele: Colt."
            },
            [6] = {
                _add = "Lépj be a Bankba, amikor kirabolják."
            },
            [12] = {
                _add = "Keress valami gyanúsat a Kórházban."
            },
            [13] = {
                _add = "Menj a Bányába."
            },
            name = "Küldetés 03: A rablás",
            [14] = {
                _add = "Keresd meg a gyanusítottat és tartóztasd le."
            },
            [1] = {
                dialog = "Szia. Nincsenek rendőröktisztek a városban, ezért a te segítségedre van szükségem, de nem túl nehéz a feladat.\nEgy titokzatos rablás volt a Bankban, de eddig nem találtak gyanusítottat...\nAzt hiszem, van néhány nyom a Bankban.\nColt-nak többet kell tudnia a történtekről. Beszélj vele.",
                _add = "Beszélj vele: Sherlock"
            },
            [7] = {
                _add = "Keress néhány nyomot a Bankban."
            },
            [15] = {
                _add = "Menj a Rendőrségre."
            }
        },
        [1] = {
            [0] = {
                dialog = "Hé! Hogy vagy? Nemrég valaki felfedezett egy kis szigetet a tenger után. Sok fa van ott néhány épülettel.\nAhogyan te is tudod, nincs repülőtér a városban. Jelen pillanatban csak egy csónakkal lehet oda eljutni.\nÉpíthetek neked egyet, de először egy kis segítségre lesz szükségem.\nA következő kalandom során meg szeretném tudni, mi található a Bánya másik oldalán. Van néhány elméletem, és ezekről kell meggyőződnöm.\nAzt hiszem hosszú felfedezés lesz, szóval sok ételre lesz szükségem.\nTudsz nekem fogni 5 halat?",
                _add = "Beszélj vele: Kane"
            },
            [7] = {
                dialog = "Köszönöm, hogy segítettél! Itt vannak a fa deszkák, amiket kértél. Vedd jó hasznukat!",
                _add = "Beszélj vele: Chrystian"
            },
            [1] = {
                _add = "Fogj %s halat"
            },
            [2] = {
                dialog = "Hűha! Köszönöm a halakat! Alig várom, hogy megehessem őket a felfedezésemen.\nMost hozz nekem 3 darab Coca-cola-t. Megvásárolhatod a Boltban.",
                _add = "Beszélj vele: Kane"
            },
            [4] = {
                dialog = "Köszönöm, hogy hoztál nekem néhány ennivalót! Most rajtam a sor, hogy viszonozzam a szivességed.\nDe először szükségem lesz néhány fa deszkára a csónakod megépítéséhez.\nNemrég láttam, hogy Chrystian fákat vág ki. Kérdezd meg, hogy adna-e néhány deszkát.",
                _add = "Beszélj vele: Kane"
            },
            [8] = {
                dialog = "Túl sokáig tartott... Már azt hittem, hogy elfelejtetted beszerezni a deszkákat...\nEgybébként, most már megépíthetem a csónakod...\nItt a csónakod! Érezd jól magad az új szigeten, és ne felejts el óvatos maradni!",
                _add = "Beszélj vele: Kane"
            },
            [5] = {
                dialog = "Szóval deszkákat akarsz? Tudok adni néhányat, de hoznod kell nekem egy gabonapelyhet.\nMegtennéd?",
                _add = "Beszélj vele: Chrystian"
            },
            name = "Küldetés 01: Építs egy csónakot",
            [3] = {
                _add = "Vásárolj %s Coca-Cola-t"
            },
            [6] = {
                _add = "Vásárolj egy gabonapelyhet"
            }
        },
        [4] = {
            [0] = {
                dialog = "Helló! Szeretnél valamilyen pizzát enni?\nNos... Rossz hírem van a számodra.\nKorábban elkezdtem készíteni néhány pizzát, majd észrevettem, hogy az összes szósz eltűnt!\nMegpróbáltam vásárolni néhány paradicsomot a Boltban, de nyilván nem árulnak.\nNéhány héttel ez előtt költöztem ebbe a városba, és nem ismerek itt senkit, aki segíteni tudna.\nSzóval kérlek, tudsz nekem segíteni? Csak szószra van szükségem, hogy megnyithassam a Pizzériám.",
                _add = "Beszélj vele: Kariina."
            },
            [2] = {
                _add = "Menj a Magboltba."
            },
            [4] = {
                _add = "Menj a házadba."
            },
            [8] = {
                _add = "Vegyél egy Vizesvödröt."
            },
            [16] = {
                dialog = "ÚR ISTEN! Megcsináltad! Köszönöm!\nAmíg távol voltál, rájöttem, hogy több búzára van szükségem, hogy több tésztát tudjak készíteni... Hoznál nekem néhány búzát?",
                _add = "Add oda a csípős szószt neki: Kariina."
            },
            [17] = {
                _add = "Ültess egy magot a házadba."
            },
            [9] = {
                _add = "Menj a Boltba."
            },
            [18] = {
                _add = "Takarítsd be a búzát."
            },
            [5] = {
                _add = "Ültess egy magot a házadba. (Szükséged lesz egy kertre!)"
            },
            [10] = {
                _add = "Várásolj néhány sót."
            },
            [11] = {
                _add = "Főzz egy szószt. (Szükséged lesz egy sütőre!)"
            },
            [3] = {
                _add = "Vásárolj egy magot."
            },
            [6] = {
                _add = "Takarítsd be a paradicsomot."
            },
            [12] = {
                dialog = "Azta! Köszönöm! Most már csak egy csípős szószra lesz szükségem. Készítenél egyet?",
                _add = "Add oda a szószt neki: Kariina."
            },
            [13] = {
                _add = "Ültess egy magot a házadba."
            },
            name = "Küldetés 04: Az elveszett szósz!",
            [14] = {
                _add = "Takarítsd be a paprikát."
            },
            [1] = {
                _add = "Menj a szigetre."
            },
            [7] = {
                _add = "Menj a Magboltba."
            },
            [15] = {
                _add = "Főzz egy csípős szószt."
            },
            [19] = {
                dialog = "Ismét köszönöm! Dolgozhatnál velem, ha új alkalmazottra lesz szükségem.\nKöszönöm a segítséget. Most megyek és befejezem a pizzákat!",
                _add = "Add oda a tésztát neki: Kariina."
            }
        },
        [5] = {
            name = "Küldetés 03: A rablás",
            [0] = {
                _add = "Menj a Rendőrségre."
            }
        }
    },
    bag = "Táska",
    furniture_shelf = "Polc",
    item_potato = "Krumpli",
    emergencyMode_able = "<r>Vészleállás kezdeményezése, új játékosok nem engedélyezettek. Kérjük, menj egy másik #mycity szobába.",
    arrestedPlayer = "Letartóztattad <v>%s</v> -t!",
    item_lobsterBisque = "Homár Krémleves",
    item_hotChocolate = "Forró csokoládé",
    confirmButton_Work = "Munkára fel!",
    chef = "Séf",
    item_waffles = "Gofri",
    item_frenchFries = "Sültkrumpli",
    npcDialog_Weth = "Puding *-*",
    minerpack = "Bányászcsomag %s",
    badgeDesc_2 = "Fogj 500 halat",
    settings_credits = "Kreditek",
    timeOut = "Nem elérhető hely.",
    error_maxStorage = "Maximum mennyiség megvásárolva.",
    percentageFormat = "%s%%",
    furniture_diningTable = "Ebédlő Asztal",
    badgeDesc_10 = "Letartóztattál 500 rablót",
    badgeDesc_3 = "Bányásztál 1000 aranyrögöt",
    closed_dealership = "Az Autókereskedés zárva van.\nGyere vissza 08:00-kor!",
    houseSettings_finish = "Befejez!",
    profile_badges = "Jelvények",
    item_pudding = "Puding",
    eatItem = "Megesz",
    bankRobAlert = "A Bankot kirabolták. Védd meg!",
    item_shrinkPotion = "Zsugorító bájital",
    item_bread = "Kenyér",
    item_crystal_yellow = "Citromsárga Kristály",
    npcDialog_Julie = "Légy óvatos. Ez a szupermarket nagyon veszélyes.",
    vehicle_12 = "Bugatti",
    profile_basicStats = "Általános adatok",
    item_milk = "Üveg tej",
    unlockedBadge = "Egy új Jelvényt szereztél!",
    item_wheatSeed = "Búzamag",
    incorrect = "Helytelen",
    profile_seedsPlanted = "Learatott",
    recipes = "Receptek",
    npcDialog_Goldie = "Akarsz eladni egy kristályt? Dobd le mellém, hogy megbecsülhessem az árát.",
    soon = "Hamarosan!",
    furniture_bookcase = "Könyvespolc",
    item_energyDrink_Ultra = "Coca-Cola",
    profile_completedSideQuests = "Mellékküldetések",
    expansion_grass = "Fű",
    item_hotsauce = "Csípős szósz",
    badgeDesc_7 = "Vásárold meg a Szánt.",
    houseSettings = "Házbeállítások",
    error_boatInIsland = "Nem használhatsz csónakot messze a tengertől.",
    House3 = "Kísértetház",
    itemDesc_fertilizer = "Felgyorsítja a növények növekedési idejét!",
    error_houseUnderEdit = "%s szerkeszti a házat.",
    furnitureRewarded = "Feloldott bútor: %s",
    item_garlicBread = "Fokhagymás Kenyér",
    createdBy = "Készítette %s",
    healing = "Az életszinted %s másodpercen belül fel lesz töltve.",
    emergencyMode_pause = "<cep><b>[Figyelem!]</b> <r>A modul elérte a kritikus határát, így szüneteltetés alatt áll.",
    vehicles = "Járművek",
    profile_purchasedHouses = "Vásárolt házak",
    chestIsFull = "A láda megtelt.",
    profile_capturedGhosts = "Elfogott szellemek",
    codeLevelError = "Ha kód használatához el kell érned a(z) %s szintet.",
    settings_donateText = "<j>#Mycity</j> egy <b><cep>2014</cep></b>-ben indult projekt, de egy másik játékmenettel: <v>építs egy várost</v>! Azonban ez a projekt nem haladt előre, és hónapokkal később törölve lett.\n <b><cep>2017</cep></b>-ben úgy döntöttem, hogy helyrehozom egy új céllal: <v>élj egy városban</v>!\n\n A rendelkezésre álló funkciók nagy részét én készítettem <v>hosszú és fárasztó</v> időn keresztül.\n\n Ha képes vagy nekem segíteni, adományozz! Ez nagyban ösztönöz az új frissítések elkészítésében!",
    npcDialog_Davi = "Sajnálom, de nem engedhetem, hogy itt tovább menj.",
    confirmButton_Great = "Nagyszerű!",
    captured = "<g>A rabló (<v>%s</v>) le lett tartóztatva!",
    copError = "10 másodpercet várnod kell, hogy újra elkaphass valakit.",
    itemInfo_miningPower = "Kő sebzés: %s",
    item_crystal_red = "Piros Kristály",
    waitUntilUpdate = "<rose>Kérlek várj.</rose>",
    permissions_roommate = "Szobatárs",
    collectorItem = "Gyűjtő tárgy",
    settings_creditsText = "A <j>#Mycity</j>-t <v>%s</v> készítette, a rajzokban <v>%s</v> segített, és ők fordították:",
    npcDialog_Marie = "Imáááááááádom a sajtot *-*",
    houseDescription_2 = "Nagy ház, nagy családoknak, nagy problémákkal.",
    closed_police = "A Rendőrség zárva van.\nGyere vissza 08:00-kor!",
    item_energyDrink_Basic = "Sprite",
    setPermission = "Jog: %s",
    closed_seedStore = "A Magbolt zárva van.\nGyere vissza később.",
    settings_helpText = "Üdvözöl a <j>#Mycity</j>!\n Ha tudni akarod, hogyan kell játszani, akkor kattints az alábbi gombra:",
    error_blockedFromHouse = "Ki vagy zárva %s házából.",
    farmer = "Farmer",
    daysLeft2 = "%s nap",
    item_blueberriesSeed = "Áfonya mag",
    furniture_christmasCarnivorousPlant = "Húsevő Növény",
    reward = "Jutalom",
    pickaxes = "Csákányok",
    furniture = "Bútor",
    houseSettings_buildMode = "Építési Mód",
    item_salad = "Saláta",
    itemDesc_superFertilizer = "Ez 2x hatékonyabb, mint a rendes trágya.",
    item_dynamite = "Dinamit",
    item_lettuce = "Saláta",
    settings_settings = "Beállítások",
    multiTextFormating = "{0}: {1}",
    npcDialog_Rupe = "Egyértelmű, hogy a kőből készült csákány nem jó választás a kövek törésére.",
    npcDialog_Jason = "Hé... Az üzletemben még nincsenek eladó dolgok.\nKérlek, gyere vissza később!",
    energyInfo = "<v>%s</v> energia",
    houseDescription_7 = "Egy ház azoknak, akik szeretnek a természethez közelebb ébredni!",
    npcDialog_Kapo = "Mindig idejövök, hogy ellenőrizzem Dave napi ajánlatát.\nNéha olyan tárgyakat kapok, amik csak az ő tulajdonában vannak!",
    miner = "Bányász",
    copAlerted = "A zsaruk riasztva lettek.",
    item_oreganoSeed = "Oregánó mag",
    waterVehicles = "Vízi",
    settings_config_mirror = "Tükrözött Szöveg",
    item_egg = "Tojás",
    houseDescription_4 = "Unalmas a városban élni? Mi tudjuk, mire van szükséged.",
    House1 = "Klasszikus Ház",
    open = "Nyit",
    furniture_cauldron = "Üst",
    houseSettings_changeExpansion = "Bővítés Módosítása",
    closed_fishShop = "A Halbolt zárva van.\nGyere vissza később!",
    questCompleted = "Teljesítetted a következő küldetést:\n%s!\nA jutalmad:",
    furniture_scarecrow = "Madárijesztő",
    profile_fulfilledOrders = "Teljesített megrendelések",
    item_grilledLobster = "Grillezett Homár",
    transferedItem = "A(z) %s áthelyezve a táskádba.",
    npcDialog_Cassy = "Szép napot!",
    itemAmount = "Tárgyak: %s",
    cancel = "Mégse",
    npcDialog_Lauren = "Imádja a sajtot.",
    close = "Bezárás",
    updateWarning = "<font size=\"10\"><rose><p align=\"center\">Figyelem!</p></rose>\nÚj frissítés:\n%s:%s perc múlva",
    badgeDesc_5 = "500 teljesített lopás",
    confirmButton_Buy = "Vásárlás %s -ért",
    looseMgs = "Megmenekülsz %s másodpercen belül.",
    item_bag = "Táska",
    settings_gamePlaces = "Helyek",
    npcDialog_Louis = "Mondtam neki, hogy ne rakjon olajbogyót...",
    wordSeparator = " és ",
    confirmButton_tip = "Tipp",
    tip_vehicle = "Kattints a jármű melletti csillag ikonra, hogy a kedvenceid közé tedd! A kedvenc jármű meghívásához nyomd meg az F(szárazföldi) vagy G(vízi) gombot.",
    speed_knots = "nmi",
    codeInfo = "Írj be egy érvényes kódot, majd kattints az Elfogadra, hogy megkapd a jutalmad.\nÚj kódokat kaphatsz, ha csatlakozol a Discord szerverünkhöz!\n<a href=\"event:getDiscordLink\"><v>(Kattints ide a meghívó linkért)</v></a>",
    sellFurniture = "Bútor Eladása",
    profile_cookedDishes = "Főtt ételek",
    police = "Rendőr",
    profile_questCoins = "Küldetéspontok",
    item_wheatFlour = "Búzaliszt",
    alreadyLand = "Valaki már megszerezte ezt a területet.",
    furniture_fence = "Kerítés",
    orderCompleted = "Kiszállítottad %s rendelését és %s-t kaptál!",
    ranking_coins = "Összegyűjtött érme",
    limitedItemBlock = "Várnod kell %s másodpercet, hogy használhasd ezt a tárgyat .",
    settingsText_createdAt = "A szoba <vp>%s</vp> perccel ezelőtt lett létrehozva.",
    settingsText_currentRuntime = "Futási idő: <r>%s</r>/60ms",
    furniture_oven = "Sütő",
    item_fish_SmoltFry = "Ponty",
    energy = "Energia",
    item_fish_Catfish = "Macskahal",
    emergencyMode_resume = "<r>A modul folytatódik.",
    itemDesc_cheese = "Használd ezt a tárgyat, hogy sajtot kapj a Transformice boltban!",
    item_lemonade = "Limonádé",
    houses = "Házak",
    locked_quest = "Küldetés %s",
    House7 = "Faház",
    expansion = "Bővítések",
    profile_seedsSold = "Eladott",
    vehicle_9 = "Szán",
    furniture_testTubes = "Kémcsövek",
    newLevelMessage = "Gratulálunk!\nSzintet léptél!",
    itemDesc_bag = "+%s kapacitás a táskában",
    itemDesc_growthPotion = "Használd ezt a bájitalt, hogy megnövekedj %s másodpercre!",
    questsName = "Küldetések",
    itemDesc_seed = "Egy rejtélyes mag.",
    badgeDesc_0 = "Halloween 2019",
    item_chocolateCake = "Csokoládé Torta",
    profile_robbery = "Rablások",
    event_halloween2019 = "Halloween 2019",
    settingsText_placeWithMorePlayers = "Több játékossal való hely: <vp>%s</vp> <r>(%s)</r>",
    thief = "Rabló",
    furniture_pumpkin = "Tök",
    furniture_cross = "Kereszt",
    ghostbuster = "Szellemírtó",
    npcDialog_Blank = "Szükséged van valamire?",
    furniture_christmasWreath = "Karácsonyi Koszorú",
    daysLeft = "Még %s napig.",
    furniture_hay = "Széna",
    codeAlreadyReceived = "Használt kód.",
    level = "Szint %s",
    badgeDesc_6 = "Karácsony 2019",
    item_crystal_blue = "Kék Kristály",
    profile_gold = "Gyűjtött Arany",
   	seedSold = "%s eladva ennyiért: %s.",
    ghost = "Szellem",
    code = "írd be a kódot",
    sidequestCompleted = "Teljesítetted a Mellékküldetést!\nA jutalmad:",
    profile_spentCoins = "Elköltött érmék",
    waitingForPlayers = "Várakozás játékosokra...",
    item_pizza = "Pizza",
    profile_fishes = "Horgászások",
    item_growthPotion = "Növekedési bájital",
    item_pickaxe = "Csákány",
    item_crystal_purple = "Lila Kristály",
    passToBag = "Táskába helyezés",
    item_goldNugget = "Aranyrög",
    furniture_tv = "Televízió",
    furniture_sofa = "Kanapé",
    settings = "Beállítások",
    submit = "Elfogad",
    itemDesc_water = "A magok gyorsabban nőnek!",
    maxFurnitureStorage = "Csak %s bútor lehet a házadban.",
    error_houseClosed = "%s bezárta ezt a házat.",
    item_pumpkin = "Tök",
    vehicle_8 = "Járőrhajó",
    sale = "Eladó",
    item_dough = "Tészta",
    houseSettings_unlockHouse = "Ház kinyitása",
    item_pepperSeed = "Paprika mag",
    item_luckyFlower = "Szerencsevirág",
    item_pepper = "Paprika",
    furniture_kitchenCabinet = "Konyhaszekrény",
    furniture_flowerVase = "Virágcserép",
    frozenLake = "A tó befagyott. Várnod kell tél végéig, hogy újra használhass hajót.",
    chooseExpansion = "Válassz ki egy bővítést",
    drop = "Kidobás",
    owned = "Birtokolva",
    npcDialog_Sebastian = "Hé haver.\n...\nNem Colt vagyok.",
    npcDialog_Heinrich = "Huh... Szóval Bányász akarsz lenni? Ha igen, akkor légy óvatos. Amikor kisegér voltam, eltévedtem ebben a labirintusban.",
    item_chocolate = "Csokoládé",
    closed_potionShop = "A Bájitalbolt zárva van.\nGyere vissza később!",
    mouseSizeError = "Túl kicsi vagy ahhoz, hogy ezt tedd.",
    codeReceived = "A jutalmad: %s.",
    chooseOption = "Válassz egy lehetőséget",
    shop = "Bolt",
    item_energyDrink_Mega = "Fanta",
    npcDialog_Derek = "Psszt.. Ma este valami nagy eredményt szerzünk: kiraboljuk a Bankot.\nHa csatlakozni akarsz hozzánk, jobb, ha beszélsz a főnökünkkel, Pablo-val.",
    harvest = "Betakarítás",
    atmMachine = "ATM",
    hey = "Hé! Állj!",
    itemDesc_dynamite = "Bumm!",
    password = "Jelszó",
    goldAdded = "A bányászott aranyrög hozzáadva a táskádhoz.",
    mine5error = "A Bánya beomlott.",
    fisher = "Horgász",
    completedQuest = "Küldetés befejezve",
    item_cookies = "Sütemény",
    items = "Tárgyak:",
    speed_km = "Km/h",
    leisure = "Szórakozás",
    closed_buildshop = "Az Építészeti Bolt zárva van.\nGyere vissza 08:00-kor!",
    alert = "RIADÓ!",
    error = "Hiba",
    settings_gameHour = "Játékóra",
    settings_donateText2 = 'Az adományozók exkluzív NPC-ket kapnak az adományozásért. Ne felejtsd el elküldeni a Transformice felhasználóneved, így fogom tudni megszerezni az aktuális kinézeted.',
    npcDialog_Bill = 'Heyyo! Szeretnéd ellenőrizni az aktuális horgászszerencséd?\nHmmm... Lássuk csak..\n%s esélyed van egy közönséges hal megszerzésére, %s esélyed egy ritka hal megszerzésére és %s esélyed egy mitikus hal megszerzésére.\n... És %s esélyed van egy legendás hal megszerzésére!',
    furniture_nightstand = 'Éjjeli szekrény',
    furniture_bush = 'Bokor',
    furniture_armchair = 'Fotel',
}

--[[ translations/pl.lua ]]--
lang.pl = {
    item_crystal_green = "Zielony krysztal",
    item_fish_RuntyGuppy = "Guppy",
    landVehicles = "pojazdy ziemne",
    item_pumpkinSeed = "nasiono dyni",
    item_garlic = "Czosnek",
    item_fish_Dogfish = "Psia ryba",
    boats = "Łódki",
    item_blueberries = "Jagody",
    furniture_christmasCandyBowl = "Miska na cukierki",
    enterQuestPlace = "Odblokuj to miejsce po ukończeniu misji <vp>%s</vp>.",
    houseSettings_placeFurniture = "Poloz",
    item_lemon = "Cytryna",
    _2ndquest = "Misje poboczne",
    vehicle_11 = "Jacht",
    itemDesc_pickaxe = "Rozbij kamienie",
    item_cornFlakes = "Platki kukurydziane",
    furnitures = "meble",
    profile_cookedDishes = "Gotowane potrawy",
    item_cheese = "Ser",
    hospital = "Szpital",
    playerBannedFromRoom = "%s zostal zbanowany z pokoju.",
    newLevel = "Nowy level!",
    houseSettings_reset = "Zresetuj ustawienia",
    permissions_blocked = "Zablokuj dom",
    item_coffee = "Kawa",
    goTo = "Idź do",
    npcDialog_Rupe = "Zdecydowanie kilof wykonany z kamienia nie jest dobrym wyborem do lamania kamieni.",
    fishingError = "Skończyły ci się połowy.",
    noMissions = "Brak dostępnych misji.",
    item_potato = "Ziemniak",
    job = "Praca",
    houseSettings_permissions = "zezwolenie",
    item_fish_Lobster = "Homar",
    sell = "Sprzedaj",
    furniture_christmasSnowman = "Balwan",
    furniture_christmasSocks = "Swiateczne skarpety",
    runAwayCoinInfo = "Dostaniesz %s po kradzierzy.",
    item_sauce = "Sos pomidorowy",
    houseSettings_lockHouse = "Zablokowany dom",
    houseDescription_3 = "Tylko najbardziej odwa¿ni moga mieszkac w tym domu. Ooooo!",
    settings_config_lang = "Jezyk",
    item_wheat = "Zboze",
    House4 = "Stodola",
    hey = "Hej! Stać!",
    itemDesc_clock = "Prosty zegarek, którego można użyć tylko raz",
    rewardNotFound = "Nie znaleziono nagrody.",
    confirmButton_Buy = "Kup za %s",
    cook = "Gotowac",
    furniture_bed = "Lozko",
    npcDialog_Cassy = "Milego dnia!",
    furniture_painting = "Obraz",
    furniture_christmasGift = "Gift Box",
    item_fish_Frog = "Zaba",
    furniture_scarecrow = "Strach na wroble",
    closed_buildshop = "Sklep z narządziami jest zamknięty. Wróć ponownie po świcie.",
    houseDescription_5 = "Prawdziwy dom duchow. Uwazajcie!",
    permissions_guest = "Gosc",
    newUpdate = "Nowy update!",
    expansion_pool = "Basen",
    houseSettings_changeExpansion = "Zmien rozszerzenie",
    fishWarning = "Nie możesz tu łowić.",
    furniture_derp = "Golabb",
    closed_bank = "Bank zamknięty. Przyjdź później.",
    profile_arrestedPlayers = "Aresztowani gracze",
    item_lemonSeed = "Nasiona cytryny",
    waterVehicles = "Woda",
    settings_helpText2 = "Dostepne komendy:",
    item_salt = "Sól",
    hungerInfo = "<v>%s</v> głodu",
    codeNotAvailable = "Kod niedostępny",
    item_frogSandwich = "Frogwich",
    buy = "Kup",
    using = "Używasz",
    npcDialog_Alexa = "Hej. co nowego?",
    robberyInProgress = "Kradzie w toku",
    settingsText_grounds = "Wygenerowane podstawy: %s/509",
    confirmButton_Buy2 = "Kup %s\nZa %s",
    itemDesc_shrinkPotion = "Użyj tej mikstury, by się zmniejszyć na %s sekund!",
    badgeDesc_9 = "Zrealizowano 500 zamowien",
    moneyError = "Nie masz wystarczająco monet.",
    bagError = "Twój plecak jest pełen.",
    playerUnbannedFromRoom = "%s Zostal zbanowany.",
    npc_mine6msg = "To się zaraz zawali, ale nikt mnie nie slucha.",
    hunger = "Głód",
    passwordError = "Odczekaj minutę.",
    House6 = "Domek swiateczny",
    no = "Nie",
    item_bruschetta = "Bruschetta",
    vehicle_6 = "Lodz rybacka",
    npcDialog_Santih = "Jest wiele osob, które wciaz smieja lowic ryby w tym stawie.",
    item_water = "Wiadro z woda",
    houseDescription_1 = "Maly dom.",
    profile_purchasedCars = "Kupione pojazdy.",
    item_fish_Lionfish = "Lwia ryba",
    item_fertilizer = "Nawoz",
    furniture_spiderweb = "Pajecza siec",
    houseDescription_2 = "Duzy dom dla duzych rodzin z duzymi problemami.",
    profile_robbery = "Rozboje",
    sellFurnitureWarning = "Czy naprawde chcesz sprzedac te meble?\n<r>Tej czynnosci nie mozna cofnac!</r>",
    profile_completedQuests = "Wykonane zadania",
    pickaxeError = "Musisz najpierw kupić kilof.",
    profile_coins = "Pieniadze",
    password = "Hasło",
    closed_market = "Sklep jest zakmnięty. Wróć o świcie.",
    pizzaMaker = "Pizzeria",
    use = "Użyj",
    item_sugar = "Cukier",
    npcDialog_Davi = "Przykro mi, ale nie moge pozwolic, zebys poszedl ta droga.",
    rewardText = "Otrzymales niesamowita nagrode!",
    furniture_christmasFireplace = "Komniek",
    price = "Cena: %s",
    completedQuest = "Misja ukończona",
    settings_donate = "Podaruj",
    furniture_candle = "Swieca",
    item_tomatoSeed = "Nasiono pomidora",
    newBadge = "Nowa odznaka",
    speed = "Predkosc: %s",
    furniture_chest = "Skrzynia",
    itemDesc_goldNugget = "Blyszczacy i drogi.",
    confirmButton_Sell = "Sprzedaj za %s",
    sideQuests = {
        [1] = "Posadz %s nasion w ogrodzie Oliviera.",
        [2] = "Nawiez %s roœlin w ogrodzie Oliviera.",
        [4] = "Aresztuj zlodzieja %s razy.",
        [8] = "WydobadŸ %s brylek zlota.",
        [16] = "Dostarcz %s zamowien.",
        [17] = "Zrob pizze.",
        [9] = "Obrabuj bank.",
        [18] = "Zrob bruschetta.",
        [5] = "Uzyj %s przedmiotow.",
        [10] = "Wykonaj %s napadow.",
        [20] = "Zrob frogwich.",
        [11] = "Gotuj %s razy.",
        [3] = "Zdobadz %s monet.",
        [6] = "Wydaj %s monet.",
        [12] = "Zdobadz %s punktow doswiadczenia.",
        [13] = "Zlów %s zab.",
        [7] = "Low %s razy.",
        [14] = "Zlow %s lwich ryb.",
        [15] = "Dostarcz %s zamowien.",
        [19] = "Zrob lemoniade."
    },
    npcDialog_Paulo = "To pudelko jest naprawde ciezkie ... \n Byloby tak fajnie, gdybysmy mieli tutaj wozek widlowy",
    item_luckyFlowerSeed = "Szczesliwe nasiono kwiatowe",
    item_seed = "Nasiono",
    settingsText_hour = "Czas: <vp>%s</vp>",
    sellGold = "Sell %s Złota za <vp>%s</vp>",
    houseDescription_6 = "Ten przytulny dom zapewni ci komfort nawet w najzimniejsze dni..",
    itemInfo_Seed = "Czas rosniecia: <vp>%smin</vp>\nCena za nasiono: <vp>$%s</vp>",
    levelUp = "%s osiagnal poziom %s!",
    sleep = "Zmęczenie",
    item_superFertilizer = "Super nawoz",
    newQuestSoon = "Zadanie %sth nie jest jeszcze dostepne :/\n<font size=\"11\">Etap rozwoju: %s%%",
    settings_help = "Wsparcie",
    badgeDesc_1 = "Poznaj tworce #mycity",
    ranking_spentCoins = "Wydane pieniądze",
    profile_jobs = "Praca",
    placeDynamite = "Podłóż dynamit",
    vehicle_5 = "Łódź",
    quest = "Misja",
    closed_furnitureStore = "Sklep z meblami jest zamnkiety. Wroc pozniej!",
    item_blueberriesSeed = "Nasiona jagod",
    profile_gold = "Zebranego zlota",
    item_milkShake = "Napoj mleczy",
    confirmButton_Select = "Wybierz",
    collectorItem = "Przedmiot kolekcjonerski",
    noEnergy = "Potrzebujesz więcej energii, aby móc pracować.",
    farmer = "Farmer",
    runAway = "Uciekaj za %s sekund.",
    maxFurnitureDepot = "Twoj magazyn mebli jest pelny.",
    npcDialog_Billy = "Nie moge sie doczekac, aby okrasc bank dzis wieczorem!",
    vehicleError = "Nie mozesz uzywac pojazdu w tym miejscu.",
    item_oregano = "Oregano",
    npcDialog_Pablo = "Wiec, chcesz byc zlodziejem? Mam wrazenie, ze jestes tajnym glina... Nie jestes? Dobrze, wiec ci uwierze. Jestes teraz zlodziejem i masz mozliwosc okradania postaci o rozowej nazwie, naciskajac SPACJE. Pamietaj, aby trzymac sie z dala od gliniarzy!",
    expansion_garden = "Ogrod",
    item_frenchFries = "Frytki",
    itemDesc_minerpack = "Zawierający %s kilof(ów).",
    item_pierogies = "Pierogi",
    waitingForPlayers = "Czekam na graczy...",
    House5 = "Nawiedzona posiadlosc",
    furniture_hayWagon = "Wagon siana",
    confirmButton_Work = "Pracuj!",
    furniture_rip = "RIP",
    houseSetting_storeFurnitures = "Wszystkie meble przechowuj w ekwipunku",
    error_maxStorage = "Zakupiono maksymalna kwote.",
    itemDesc_water = "Spraw, by nasiona rosly szybciej!",
    furniture_shelf = "Polka",
    transferedItem = "Przedmiot %s zostal przeniesiony do twojej torby.",
    emergencyMode_able = "<r>Initiating emergency shutdown, no new players allowed. Please go to another #mycity room.",
    furniture_fence = "Plot",
    item_lobsterBisque = "Lobster Bisque",
    item_hotChocolate = "Goraca czekolada",
    orderCompleted = "Dostarczyles zamowienie %s i otrzymales %s!",
    quests = {
        [2] = {
            [0] = {
                _add = "Idz na wyspe."
            },
            [7] = {
                dialog = "Wreszcie! Powinieneœ zwrocic wieksza uwage, moglem obejrzec film, gdy na ciebie czekalem.\nCzy nadal chcesz odwiedzic sklep? Ide tam!",
                _add = "Przynies klucz do Indy."
            },
            [1] = {
                dialog = "Hej! Kim jestes? Nigdy cie nie widzialem ... \n Nazywam sie Indy! Mieszkam na tej wyspie od dawna. Sa tutaj swietne miejsca na spotkanie. \\Jestem wlascicielem sklepu z miksturami. Moge do ciebie zadzwonic, zeby spotkac sie ze sklepem, ale mam jeden duzy problem: zgubilem klucze od sklepu!\n Musialem je zgubic w kopalni kiedy kopalem. Mozesz mi pomoc ?",
                _add = "Porozmawiaj z Indy"
            },
            [2] = {
                _add = "Idz do kopalni."
            },
            [4] = {
                dialog = "Dziekuje Ci! Teraz moge wrocic do biznesu! \n Poczekaj sekunde ... \n1 brakuje klucza: klucz sklepu! Ciezko szukales?",
                _add = "Przynies klucze do Indy."
            },
            [5] = {
                _add = "Wroc do kopalni."
            },
            name = "Zadanie 02: Zagubione klucze",
            [3] = {
                _add = "Znajdz klucze Indy."
            },
            [6] = {
                _add = "Znajdz ostatni klucz."
            }
        },
        [3] = {
            [0] = {
                _add = "Idz na posterunek policji."
            },
            [2] = {
                _add = "Idz do banku."
            },
            [4] = {
                _add = "Wroc na posterunek policji."
            },
            [8] = {
                _add = "Idz na posterunek policji."
            },
            [16] = {
                dialog = "Dobra robota! Jestes w tym naprawde dobry. \n Znam œwietne miejsce na odzyskanie energii po tym dlugim dochodzeniu: kawiarnie!",
                _add = "Porozmawiaj z Sherlock."
            },
            [9] = {
                dialog = "Bardzo dobrze! Ta sciereczka pomo¿e nam znalezc podejrzanego. \n Porozmawiaj z Indy. On nam pomoze.",
                _add = "Porozmawiaj z Sherlock."
            },
            [5] = {
                dialog = "Wiedzialem, ze nie chcialby nam pomóc ... \n Bedziemy musieli szukac wskazowek bez niego. \n Musimy isc do banku, kiedy Colta nie bedzie, mozesz to zrobic prawda?",
                _add = "Porozmawiaj z Sherlock."
            },
            [10] = {
                dialog = "Wiec ... Bedziesz potrzebowac mojej pomocy w tym dochodzeniu? \nmm ... Pokaze ci ten material ... \n Widzialem gdzies ten material. Uzywa sie go w szpitalu! Spojrz tam!",
                _add = "Porozmawiaj z Indy."
            },
            [11] = {
                _add = "Idz do szpitala."
            },
            [3] = {
                dialog = "CO? Sherlock cie tu przyslal? Powiedzialem mu, ze zajmuje sie ta sprawa. \nPowiedz mu, ze nie potrzebuje pomocy. Poradze sobie sam.",
                _add = "Porozmawiaj z Colt."
            },
            [6] = {
                _add = "Wejdz do banku podczas rabowania."
            },
            [12] = {
                _add = "Szukaj czegos podejrzanego w szpitalu."
            },
            [13] = {
                _add = "Idz do kopalni."
            },
            name = "Misja 03: Kradziez",
            [14] = {
                _add = "Znajdz podejrzanego i aresztuj go."
            },
            [1] = {
                dialog = "Czesc. Brakuje policjantow w naszym miescie i potrzebuje twojej pomocy, ale nie jest to zbyt trudne. \nByl tajemniczy napad w banku, do tej pory podejrzany nie zostal znaleziony ... \nMysle, ze w banku jest jakas wskazowka. \nColt powinien wiedziec wiecej o tym, jak to sie stalo. Porozmawiaj z nim.",
                _add = "Porozmawiaj z Sherlock"
            },
            [7] = {
                _add = "Poszukaj wskazowek w banku."
            },
            [15] = {
                _add = "Idz na posterunek policji."
            }
        },
        [1] = {
            [0] = {
                dialog = "Hej! Jak sie masz? Niedawno niektorzy ludzie odkryli mala wyspe na morzu. Jest tez wiele drzew i budynkow. \n Jak wiesz w miescie nie ma lotniska. Jedynym sposobem, aby sie tam dostac, jest lodka. \n Moge zbudowac ja dla ciebie, ale najpierw potrzebuje pomocy. \nNa moja nastepna przygode, chcialbym dowiedziec sie, co jest po drugiej stronie kopalni. Mam kilka teorii i musze je potwierdzic. Mysle, ze to bedzie dluga wyprawa,wiec potrzebuje duzo jedzenia. Czy mozesz dla mnie zlowic 5 ryb?",
                _add = "Porozmawiaj z Kane"
            },
            [7] = {
                dialog = "Dziekuje za pomoc! Oto drewniane deski, o ktore mnie prosiles. Zrob z nich dobry uzytek!",
                _add = "Porozmawiaj z Chrystian"
            },
            [1] = {
                _add = "Zlow %s ryb"
            },
            [2] = {
                dialog = "Wow! Dziekuje za te ryby! Nie moge sie doczekac, aby zjesc je w mojej wyprawie. \n Teraz musisz przyniesc mi 3 napoje Coca-Cola. Mozesz je   kupic w sklepie.",
                _add = "Porozmawiaj z Kane"
            },
            [4] = {
                dialog = "Dziekuje za przyniesienie mi jedzenia! Teraz moja kolej, by zwrocic przysluge. \nAle zeby to zrobic, potrzebuje drewnianych desek, aby zbudowac ci lodz. \nOstatnio widzialem, jak Chrystian rabal drzewa i zbieral drewno. Zapytaj go, czy moze dac ci drewniane deski",
                _add = "Porozmawiaj z Kane"
            },
            [8] = {
                dialog = "Za dlugo to trwalo ... Myslalem, ze zapomniales zdobyc drewniane deski ... Nawiasem mowiac, teraz moge zbudowac twoja lodz ... \nOto twoja lodz! Baw sie dobrze na nowej wyspie i nie zapomnij uwazac!",
                _add = "Porozmawiaj z Kane"
            },
            [5] = {
                dialog = "Wiec chcesz drewniane deski? Moge ci dac, ale musisz przyniesc mi platki kukurydziane. \nMozesz to zrobic?",
                _add = "Porozmawiaj z Chrystian"
            },
            name = "Quest 01: Budowanie lodzi",
            [3] = {
                _add = "Kup %s Coca-Cola"
            },
            [6] = {
                _add = "Kup platki kukurydziane"
            }
        },
        [4] = {
            [0] = {
                dialog = "Czesc! Chcesz zjesc pizze? \nCoz ... Mam dla ciebie zle wiesci. \nDzis wczesniej zaczalem robic pizze, ale zauwazylem, ze wszystkiesosy zniknely. \n Probowalem kupic pomidory na rynku, ale najwyrazniej ich nie sprzedaja. \n Zaczalem mieszkac w tym miescie kilka tygodni temu i nie znam kogos, kto moze mi pomoc. \n Wiec prosze, mozesz mi pomoc? Potrzebuje tylko sosu, zeby otworzyc pizzerie.",
                _add = "Porozmawiaj z Kariina."
            },
            [2] = {
                _add = "Idz do sklepu z nasionami."
            },
            [4] = {
                _add = "Idz do swojego domu."
            },
            [8] = {
                _add = "Kup wiaderko z woda."
            },
            [16] = {
                dialog = "O MOJ BOZE! Zrobiles to! Dziekuje! \n Gdy cie nie bylo, zdalem sobie sprawe, ze potrzebuje wiecej pszenicy, aby zrobic wiecej ciasta ... Czy mozesz mi przyniesc troche pszenicy?",
                _add = "Daj ostry sos Kariina."
            },
            [17] = {
                _add = "Zasiej ziarno w swoim domu."
            },
            [9] = {
                _add = "Idz do marketu."
            },
            [18] = {
                _add = "Zbierz pszenice z ogrodu."
            },
            [5] = {
                _add = "Zasiej ziarno w swoim domu. (Musisz uzyc ogrodu!)"
            },
            [10] = {
                _add = "Kup troche soli."
            },
            [11] = {
                _add = "Ugotuj sos. (Potrzebujesz piekarnika!)"
            },
            [3] = {
                _add = "Kup nasiona."
            },
            [6] = {
                _add = "Zbierz pomidory z ogrodu."
            },
            [12] = {
                dialog = "Wow! Dziekuje Ci! Teraz potrzebuje tylko ostrego sosu. Czy mo¿esz to zrobic??",
                _add = "Daj sos Kariina."
            },
            [13] = {
                _add = "Zasiej ziarno w swoim domu."
            },
            name = "Quest 04: Sos zniknal!",
            [14] = {
                _add = "Zbierz papryke z ogrodu"
            },
            [1] = {
                _add = "Idz na wyspe."
            },
            [7] = {
                _add = "Idz do sklepu z nasionami."
            },
            [15] = {
                _add = "Ugotuj ostry sos."
            },
            [19] = {
                dialog = "Wow! Dziekuje Ci! Mozesz ze mne wspolpracowac, gdy potrzebuje nowego pracownika. \nDziekuje za pomoc. Teraz moge skonczyc te pizze!",
                _add = "Daj ciasto Kariina."
            }
        },
        [5] = {
            name = "Quest 03: Kradziez",
            [0] = {
                _add = "Idz na posterunek policji."
            }
        }
    },
    harvest = "Zbierz",
    item_waffles = "Gofry",
    npcDialog_Weth = "Pudding *-*",
    minerpack = "Zestaw górnika %s",
    badgeDesc_2 = "Wylowiono 500 ryb",
    settings_credits = "Credits",
    timeOut = "Miejsce niedostępne.",
    code = "Wpisz kod",
    percentageFormat = "%s%%",
    profile_questCoins = "Punkty za misje",
    seedSold = "Sprzedales %s za %s.",
    badgeDesc_3 = "Wydobyto 1000 barylek zlota",
    closed_dealership = "Sklep z samochodami jest zamknięty. Wróć ponownie po świcie.",
    settings = "Ustawienia",
    profile_badges = "Odznaki",
    item_pudding = "Pudding",
    badgeDesc_4 = "Zbierz 500 roslin",
    bankRobAlert = "Bank jest rabowany, brońcie go!",
    badgeDesc_0 = "Halloween 2019",
    item_bread = "Bochen chleba",
    furniture_hay = "Siano",
    item_hotsauce = "Ostry sos",
    vehicle_12 = "Bugatti",
    profile_basicStats = "Ogolne dane",
    item_milk = "Butelka mleka",
    houseDescription_4 = "Masz dosc ¿ycia w miescie? Mamy to, czego potrzebujesz.",
    remove = "Usuń",
    incorrect = "Błąd",
    questCompleted = "Ukonczyles misje %s!\nTwoja nagroda:",
    profile_seedsPlanted = "Uprawy",
    goldAdded = "Złoto, które zebrałeś zostało dodane do twojej torby.",
    closed_potionShop = "Sklep mikstur jest zamknięty. Przyjdź później.",
    furniture_bookcase = "Polka na ksiazki",
    item_energyDrink_Ultra = "Coca-Cola",
    profile_completedSideQuests = "Wykonane misje poboczne",
    expansion_grass = "Trawa",
    frozenLake = "Jezioro jest zamarzniete. Poczekaj na koniec zimy, aby skorzystac z lodzi.",
    badgeDesc_7 = "Kupiono sanie",
    furniture_flowerVase = "Wazon",
    error_boatInIsland = "Nie możesz użyć łódki za daleko od morza",
    House3 = "Nawiedzony dom",
    yes = "Tak",
    unlockedBadge = "Odblokowales nowa odznake!",
    daysLeft2 = "zostalo dni:%sd",
    item_garlicBread = "Chleb czosnkowy",
    createdBy = "Stworzone przez %s",
    itemDesc_seed = "Losowe ziarno.",
    emergencyMode_pause = "<cep><b>[Warning!]</b> <r>Modul osiagnal limit krytyczny i jest wstrzymywany.",
    itemDesc_dynamite = "Boom!",
    profile_purchasedHouses = "Kupione domy",
    chestIsFull = "Skrzynia jest pelna.",
    profile_capturedGhosts = "Schwytane duchy",
    codeLevelError = "Musisz osiagnac poziom %s aby wykorzystac ten kod.",
    elevator = "Winda",
    expansion = "Rozszerzenia",
    furniture_christmasCarnivorousPlant = "Roslina miesozerna",
    item_crystal_red = "Czerwony krysztal",
    maxFurnitureStorage = "Mozesz tylko posiadac %s mebli w swoim domu.",
    copError = "Musisz czekać 10 sekund, aby móc ponownie przetrzymać złodzieja.",
    settingsText_createdAt = "Pokoj utworzony <vp>%s</vp> minut temu.",
    items = "Przedmioty:",
    waitUntilUpdate = "<rose>Prosze czekac.</rose>",
    permissions_roommate = "Wspollokator",
    captured = "<g> Zlodziej <v>%s</v> zostal aresztowany!",
    item_crystal_blue = "Niebieski krysztal",
    settings_creditsText2 = "Specjalne podziekowania dla <v>%s</v> Za pomoc z waznymi rzeczami dla tego modulu.",
    settings_donateText = "<j>#Mycity</j> jest projektem zaczetym w <b><cep>2014</cep></b>, ale z inna rozgrywka: <v>zbuduj miasto</v>! Jednak ten projekt nie posunal sie naprzod i zostal anulowany kilka miesiecy pozniej.\n w <b><cep>2017</cep></b>, Postanowilem powtorzyc to z nowym celem: <v>Mieszkanie w miescie </v>!\n\n Wiekszosc dostepnych funkcji zostala stworzona przeze mnie przez <v>dlugi i meczacy</v> czas.\n\n Jesli chcesz i mozesz mi pomoc, przekaz darowizne. To zacheca mnie do wprowadzenia nowych aktualizacji!",
    closed_police = "Posterunek policji jest zamknięty. Wróć o świcie.",
    item_energyDrink_Basic = "Sprite",
    setPermission = "Zrob %s",
    closed_seedStore = "Sklep z nasionami jest zamkniety. Wroc pozniej!",
    wordSeparator = " i ",
    error_blockedFromHouse = "Masz zablokowany dostep do domu %s's .",
    npcDialog_Kapo = "Zawsze przychodze tutaj, aby sprawdzac codzienne oferty Dave'a. \nCzasami dostaje rzadkie przedmioty, ktore tylko on posiada!",
    item_crystal_yellow = "Zolty krysztal",
    vehicle_9 = "Sanie",
    furniture_tv = "Tv",
    reward = "Nagroda",
    pickaxes = "Kilofy",
    furniture = "Meble",
    houseSettings_buildMode = "Tryb budowania",
    item_salad = "Salatka",
    itemDesc_superFertilizer = "Jest 2x bardziej skuteczny niz nawoz.",
    item_dynamite = "Dynamit",
    profile_seedsSold = "Sprzedane",
    settings_settings = "Ustawienia",
    item_wheatSeed = "Nasiona pszenicy",
    furniture_apiary = "Pudlo z pszczolami",
    item_pizza = "Pizza",
    energyInfo = "<v>%s</v> brak energii",
    locked_quest = "Misja %s",
    saveChanges = "Zapisz zmiany",
    miner = "Górnik",
    copAlerted = "Policja została zaalarmowana.",
    item_oreganoSeed = "Nasiona oregano",
    item_tomato = "Pomidor",
    recipes = "Przepisy",
    speed_knots = "Seki",
    item_dough = "Ciasto",
    House1 = "Klasyczny",
    open = "Otwórz",
    furniture_cauldron = "Kociolek",
    badgeDesc_5 = "Ukoncz 500 kradziezy",
    command_profile = "<g>!profile</g> <v>[nazwagracza]</v>\n   pokazuje <i>nazwagracza</i> profile.",
    item_honey = "Miod",
    npcDialog_Jason = "Hej... moj sklep nie dziala jeszcze do sprzedazy.\nProsze, wroc wkrotce!",
    ranking_Season = "Sezon %s",
    item_grilledLobster = "Grillowany homar",
    chef = "Szef",
    itemInfo_miningPower = "Uszkodzenie skalne: %s",
    settings_creditsText = "<j>#Mycity</j> zostalo stworzone przez <v>%s</v>, za pomoca sztuki z <v>%s</v> i przetlumaczone przez:",
    cancel = "Anuluj",
    limitedItemBlock = "Musisz poczekac %s sekund zeby uzyc tego przedmiotu.",
    close = "Zamknij",
    updateWarning = "<font size=\"10\"><rose><p align=\"center\">Ostrzezenie!</p></rose>\nNowa aktualizacja %smin %ss",
    npcDialog_Julie = "Badz ostro¿ny. Ten supermarket jest bardzo niebezpieczny.",
    item_pepperSeed = "Nasiona papryki",
    looseMgs = "Zostaniesz wolny za %s sekund.",
    item_bag = "Plecak",
    settings_gamePlaces = "Miejsca",
    item_fish_Goldenmare = "Zloty klacz",
    settingsText_currentRuntime = "Srodowisko wykonawcze: <r>%s</r>/60ms",
    houseSettings = "Ustawienia domu",
    tip_vehicle = "Kliknij w gwiazdke obok ikony pojazdu, aby ustawic go jako preferowany pojazd. Nacisnij F lub G na klawiaturze, aby uzyc odpowiednio preferowanego samochodu lub lodzi.",
    experiencePoints = "Punkty doswiadczenia",
    codeInfo = "Podaj kod, aby dostać nagrodę.\nMożesz otrzymać kody poprzez dołączanie do naszego serwera.\n<a href=\"event:getDiscordLink\"><v>(Kliknij by otrzymać link)</v></a>",
    itemDesc_bag = "+ %s pojemnosci torby",
    npcDialog_Louis = "Powiedzialem jej, zeby nie wkladala oliwek...",
    police = "Policjant",
    furniture_diningTable = "Stol obiadowy",
    npcDialog_Lauren = "Ona kocha ser.",
    alreadyLand = "Inny gracz już nabył tą ziemię.",
    item_lettuce = "Lettuce",
    npcDialog_Goldie = "Chcesz sprzedac krysztal? Upusc go obok mnie, abym mogl oszacowac jego cene.",
    ranking_coins = "Pieniądze",
    settings_helpText = "Witamy w <j>#Mycity</j>!\n Jesli chcesz wiedziec, jak grac, nacisnij przycisk ponizej:",
    receiveQuestReward = "Nagroda",
    healing = "Zostaniesz uleczony za %s sekund.",
    item_pepper = "Papryka",
    event_halloween2019 = "Halloween 2019",
    energy = "Energia",
    itemAddedToChest = "Przedmiot %s zostal dodany do skrzyni.",
    emergencyMode_resume = "<r>Modul zostal wznowiony.",
    furniture_oven = "Piekarnik",
    item_lemonade = "Lemoniada",
    houses = "Domy",
    daysLeft = "%sd left.",
    House7 = "Domek na drzewie",
    seeItems = "Sprawdz przedmioty",
    furniture_cross = "Krzyz",
    ghostbuster = "Pogromca duchow",
    furniture_testTubes = "Probowki",
    newLevelMessage = "Gratulacje! Awansowales na wyzszy poziom!",
    drop = "Upusc",
    itemDesc_growthPotion = "Użyj tej mikstury by być większym na %s sekund!",
    error_houseUnderEdit = "%s edytuje dom.",
    profile_spentCoins = "Wydane pieniadze",
    house = "Dom",
    item_chocolateCake = "Ciasto czekoladowe",
    closed_fishShop = "Sklep rybny jest zamkniety. Wroc pozniej!",
    confirmButton_tip = "Wskazówka",
    settingsText_placeWithMorePlayers = "Miejsce z większą ilością graczy: <vp>%s</vp> <r>(%s)</r>",
    thief = "Złodziej",
    confirmButton_Great = "Swietnie!",
    npcDialog_Marie = "kooooooocham ser *-*",
    item_luckyFlower = "Szczesliwy kwiat",
    npcDialog_Blank = "Potrzebujesz czegos ode mnie?",
    furniture_christmasWreath = "Wieniec swiateczny",
    itemAmount = "Przedmiotów: %s",
    permissions_owner = "Wlasciciel",
    codeAlreadyReceived = "Kod został już użyty.",
    permissions_coowner = "Wspolwlasciciel",
    badgeDesc_6 = "Œwieta 2019",
    syncingGame = "<r>Synchronizowanie danych gry. Gra zatrzyma sie na kilka sekund.",
    eatItem = "Zjedz",
    npcDialog_Natasha = "Czesc!",
    ghost = "Duch",
    item_egg = "Jajko",
    sidequestCompleted = "Ukonczyles misje poboczna!\nTwoja nagroda:",
    profile_fulfilledOrders = "Zrealizowane zamowienia",
    itemDesc_fertilizer = "Spraw by nasiona rosly szybciej!",
    furniture_sofa = "Sofa",
    profile_fishes = "Zlowione",
    item_growthPotion = "Growth Potion",
    item_pickaxe = "Kilof",
    item_crystal_purple = "Fioletowy krysztal",
    passToBag = "Przenies do torby",
    item_goldNugget = "Złoto",
    item_wheatFlour = "Maka pszenna",
    arrestedPlayer = "Gracz <v>%s</v> zostal aresztowany!",
    sellFurniture = "Sprzedaj meble",
    submit = "Potwierdź",
    item_shrinkPotion = "Shrink Potion",
    soon = "Wkrótce!",
    error_houseClosed = "%s zamknal ten dom.",
    item_pumpkin = "Dynia",
    vehicle_8 = "Lodz patrolowa",
    sale = "Na sprzedaż",
    bag = "Torba",
    vehicles = "Pojazdy",
    houseSettings_unlockHouse = "Odblokuj dom",
    shop = "Sklep",
    itemDesc_cheese = "Uzyj tego przedmiotu ¿eby otrzymac serki w sklepie Transformice!",
    questsName = "Misje",
    furniture_kitchenCabinet = "Szafka kuchenna",
    houseSettings_finish = "Koniec!",
    badgeDesc_10 = "Aresztuj 500 zlodzieji",
    chooseExpansion = "Wybierz rozszerzenie",
    settingsText_availablePlaces = "Dostępne miejsca: <vp>%s</vp>",
    owned = "Posiadane",
    npcDialog_Sebastian = "Hej koles.\n...\nNie jestem Colt.",
    npcDialog_Heinrich = "Huh ... Wiec chcesz zostac gornikiem? Jesli tak, musisz byc ostrozny. Kiedy bylem mala myszka, zgubilem sie w tym labiryncie.",
    item_chocolate = "Czekolada",
    furnitureRewarded = "Odblokowane meble: %s",
    mouseSizeError = "Jesteś za mały, żeby to zrobić.",
    codeReceived = "Twoja nagroda: %s.",
    chooseOption = "Wybierz opcje",
    settings_config_mirror = "tekst lustrzany",
    item_energyDrink_Mega = "Fanta",
    npcDialog_Derek = "Psst .. Dzis wieczorem zdobedziemy cos wielkiego: obrabujemy bank. \nJesli chcesz do nas dolaczyc, lepiej porozmawiaj z naszym szefem Pablo.",
    furniture_pumpkin = "Dynia",
    item_fish_Catfish = "Kocia ryba",
    houseDescription_7 = "Dom dla tych, którzy lubia budzic sie blizej natury!",
    atmMachine = "Bankomat",
    alert = "Alarm!",
    level = "Poziom %s",
    mine5error = "Kopalnia się zawaliła.",
    fisher = "Rybak",
    multiTextFormating = "{0}: {1}",
    item_cookies = "Ciastka",
    leisure = "Wypoczynek",
    speed_km = "Km/h",
    item_clock = "Zegar",
    House2 = "Dom rodzinny",
    item_fish_SmoltFry = "Smolt Fry",
    error = "Błąd",
    settings_gameHour = "Godzina gry",
    settings_donateText2 = 'Darczyncy otrzymaja ekskluzywnego NPC na czesc za darowizne. Pamietaj, aby wysać swoją nazwe z Transformice, dzieki czemu bede mogl uzyskac twoj obecny stroj.',
    npcDialog_Bill = 'Heyo! Czy chcesz sprawdzic, czy masz szczescie na obecnym lowisku? \nHmmm ... Pozwol mi zobaczyc ... \nMasz% s szans na zdobycie zwyklej ryby,% s na rzadka rybe i% s na mityczna rybe. \nMasz rowniez % s na zdobycie legendarnej ryby!',
}

--[[ translations/ru.lua ]]--
lang.ru = {
	police = 'Полиция',
	sale = 'Продается',
	close = 'Закрыть',
	soon = 'Скоро!',
	house = 'Дом',
	yes = 'Да',
	no = 'Но',
	thief = 'Вор',
	House1 = 'Классический дом',
	House2 = 'Семейный дом',
	House3 = 'Дом с привидениями',
	goTo = 'Зайти', -- ?
	fisher = 'Рыбак',
	furniture = 'Мебель',
	hospital = 'Госпиаль',
	open = 'Открыть',
	use = 'Использовать',
	using = 'Используется',
	error = 'Ошибка',
	submit = 'Принять', -- ?
	cancel = 'Отмена',
	fishWarning = "Вы не можете ловить рыбу здесь.",
	fishingError = 'Вы больше не ловите рыбу.',
	closed_market = 'Магазин закрыт. Возвращайтесь позже.',
	closed_police = 'Полицейская станция закрыта. Возвращайтесь позже.',
	timeOut = 'Место не доступно.',
	password = 'Пароль',
	passwordError = 'Мин. 1 Символ',
	incorrect = 'Неверный',
	buy = 'Купить',
	alreadyLand = 'Кто-то уже приобрел этот участок.',
	moneyError = 'У вас нет достаточно денег.',
	copAlerted = 'Полиция была предупреждена.',
	looseMgs = 'Вас освободят через %s секунд.',
	runAway = 'Сбегите за %s секунд.',
	alert = 'Тревога!',
	copError = 'Подождите 10 секунд для того чтобы задержать.',
	closed_dealership = 'Дилерская закрыта. Возвращайтесь позже.',
	miner = 'Шахтер',
	pickaxeError = 'Вы должны купить кирку.',
	pickaxes = 'Кирки',
	closed_buildshop = 'Строймагазин закрыт. Возвращайтесь позже.',
	energy = 'Энергия',
	sleep = 'Спать',
	leisure = 'Свободное время',
	hunger = 'Голод',
	elevator = 'Лифт',
	healing = 'Вы будете исцелены через %s секунд',
	pizzaMaker = 'Готовщик Пиццы',
	noEnergy = 'Вам нужно больше энергии чтобы работать снова.',
	use = 'Использовать',
	remove = 'Удалить',
	items = 'Предметы:',
	bagError = 'Не достаточно места в сумке.',
	newUpdate = 'Доступно обновление. Пожалуйста перезайдите в комнату.',
	week = 'Неделя %s',
	week1 = '<p align="center">Загадка шахты\n\nтекст',
	item_pickaxe = 'Кирка',
	item_surfboard = 'Доска для серфинга',
	item_energyDrink_Basic = 'Sprite',
	item_energyDrink_Mega = 'Fanta',
	item_energyDrink_Ultra = 'Coca-Cola',
	item_clock = 'Часы',
	boats = 'Лодки',
	vehicles = 'Транспортные средства',
	error_boatInIsland = 'Вы не можете использовать лодку далеко от моря.',
	item_milk = 'Бутылка молока',
	mine5error = 'Шахта обрушилась.',
	vehicle_5 = 'Лодка',
	noMissions = 'Нет доступных миссий.',
	questsName = 'Квесты',
	completedQuest = 'Квест завершен',
	receiveQuestReward = 'Забрать награду',
	rewardNotFound = 'Вознаграждение не найдено.',
	npc_mine6msg = 'Это может разрушиться в любой момент, но меня никто не слушает.',
	item_goldNugget = 'Золото',
	goldAdded = 'Золотой самородок, который ты собрал, добавлен в сумку.',
	sellGold = 'Продать %s Золото(а) за <vp>%s</vp>',
	settings_gameHour = 'Час игры', -- ?
	settings_gamePlaces = 'Места', -- ?
	settingsText_availablePlaces = 'Доступные места: <vp>%s</vp>',
	settingsText_placeWithMorePlayers = 'Места с большим количеством игроков: <vp>%s</vp> <r>(%s)</r>',
	settingsText_hour = 'Текущее время: <vp>%s</vp>',
	item_dynamite = 'Динамит',
	placeDynamite = 'Поставить динамит',
	energyInfo = '<v>%s</v> к энергии',
	hungerInfo = '<v>%s</v> к сытости',
	itemDesc_clock = 'Простые часы, могут быть использованы один раз.',
	itemDesc_dynamite = 'Boom!',
	minerpack = 'Набор шахтера %s',
	itemDesc_minerpack = 'Содержит %s кирку(и).',
	itemDesc_pickaxe = 'Ломает камни.',
	hey = 'Эй! Остановись!',
	robberyInProgress = 'Ограбление в процессе',
	closed_bank = 'Банк закрыт. Возвращайтесь позже.',
	bankRobAlert = 'Банк грабят. Защищай его!',
	runAwayCoinInfo = 'Вы получите %s после завершения кражи.',
	atmMachine = 'Банкомат',
	codeInfo = 'Введите действительный код и нажмите Принять.\nВы можете получить коды, если присоединитесь к Discord серверу.\n<a href="event:getDiscordLink"><v>(Нажмите чтобы получить приглашение)</v></a>',
	item_shrinkPotion = 'Зелье Уменьшения',
	itemDesc_shrinkPotion = 'Используйте это зелье чтобы уменьшиться на %s секунд!',
	mouseSizeError = 'Вы слишком малы чтобы сделать это.',
	enterQuestPlace = 'Открыть место после завершения <vp>%s</vp>.',
	closed_potionShop = 'Магазин Зелий закрыт. Возвращайтесь позже.',
	bag = 'Сумка',
	ranking_coins = 'Накоплено',
	ranking_spentCoins = 'Потрачено',
	item_growthPotion = 'Зелье Роста',
	itemDesc_growthPotion = 'Используйте это зелье чтобы увеличиться на %s секунд!',
	codeAlreadyReceived = 'Код уже использован.',
	codeReceived = 'Ваша награда: %s.',
	codeNotAvailable = 'Код не доступен',
	quest = 'Квест',
	job = 'Работа',
	chooseOption = 'Выберите вариант', -- ?
	newUpdate = 'Новое обновление!',
	itemDesc_goldNugget = 'Сверкающее и дорогое.',
	shop = 'Магазин',

	-- ~~~~~~~~~
	item_coffee = 'Кофе',
	item_hotChocolate = 'Горячий шоколад',
	item_milkShake = 'Молочный коктейль',
	updateWarning = '<font size="10"><rose><p align="center">Внимание!</p></rose>\nНовое обновление через %s мин. %s с.',
	waitUntilUpdate = '<rose>Пожалуйса подождите.</rose>',

	-- ~~~~~~~~~ New Items 2.3
	item_bag = 'Сумка',
	itemDesc_bag = '+ %s к вместимости сумки',
	item_seed = 'Семечко',
	itemDesc_seed = 'Случайное семечко.',
	item_tomato = 'Томат',
	item_fertilizer = 'Удобрение',
	itemDesc_fertilizer = 'Ускоряет рост семян!',
	item_lemon = 'Лимон',
	item_lemonSeed = 'Семена Лимона',
	item_tomatoSeed = 'Семена Томата',
	item_oregano = 'Орегано',
	item_oreganoSeed = 'Семена Орегано',

	-- ~~~~~~~~~ New Text 2.3
	error_maxStorage = 'Куплено максимальное количество',
	drop = 'Скинуть',
	playerBannedFromRoom = 'Игрока %s забанили в этой комнате.',
	playerUnbannedFromRoom = 'Игрока %s разбанили.',
	harvest = 'Собрать',

	-- ~~~~~~~~~ Garden Update
	item_water = 'Ведро с водой',
	itemDesc_water = 'Ускоряет рост семян!',
	houses = 'Дома',
	expansion = 'Расширения',
	furnitures = 'Мебель',
	settings = 'Настройки',
	furniture_oven = 'Печь',
	expansion_pool = 'Бассейн',
	expansion_garden = 'Сад',
	expansion_grass = 'Трава',
	chooseExpansion = 'Выберите расширение',
	item_pepper = 'Перец',
	item_luckyFlower = 'Цветок Удачи',
	item_pepperSeed = 'Семена Перца',
	item_luckyFlowerSeed = 'Семена Цветка Удачи',
	closed_SeedStore = 'Магазин семян закрыт. Возвращайтесь позже.',

	--
	sideQuests = {
        [1] = 'Посади %s семян в огороде Oliver.',
        [2] = 'Используй удобрение на %s растениях в огороде Oliver.',
        [3] = 'Получи %s монет.',
        [4] = 'Арестуй преступника %s раз.',
        [5] = 'Используй %s предметов.',
        [6] = 'Потрать %s монет.',
        [7] = 'Поймай %s рыб.',
        [8] = 'Добудь %s золотых самородков.',
        [9] = "Ограбьте банк.",
        [10] = "Совершите %s ограблений.",
        [11] = "Приготовьте %s раз.",
        [12] = "Получите %s опыта.",
        [13] = "Поймайте %s лягушек.",
        [14] = "Поймайте %s Крылаток.",
        [15] = "Доставьте %s заказов.",
        [16] = "Доставьте %s заказов.",
        [17] = "Приготовьте пиццу.",
        [18] = "Приготовье Брускетту.",
        [19] = "Сделайте лимонад.",
        [20] = "Приготовьте Фрогвич.",
    },

    --
    item_sugar = 'Сахар',
    item_chocolate = 'Шоколад',
    item_cookies = 'Печенья',
    furniture_christmasWreath = 'Рождественский Венок',
    furniture_christmasSocks = 'Рождественские Носки',
    House6 = 'Рождественский Дом',
    item_blueberries = 'Черника',
    item_blueberriesSeed = 'Семена Черники',
    furniture_christmasFireplace = 'Камин',
    furniture_christmasSnowman = 'Снеговик',
    furniture_christmasGift = 'Подарок',
    vehicle_9 = 'Сани',
    badgeDesc_5 = '500 краж',
    badgeDesc_6 = 'Рождество 2019',
    badgeDesc_7 = 'Куплены сани',
    frozenLake = 'Река заморожена. Ждите окончания зимы для использования лодки.',
    codeLevelError = 'Вы должны достигнуть %s уровня, чтобы использовать этот код.',
    furniture_christmasCarnivorousPlant = 'Плотоядное Растение',
    furniture_christmasCandyBowl = 'Тарелка конфет',
	furniture_apiary = "Коробка Пчел",
	furniture_bed = "Кровать",
	furniture_bookcase = "Книжная полка",
	furniture_candle = "Свечка",
	furniture_cauldron = "Котёл",
	furniture_chest = "Сундук",
	furniture_cross = "Крест",
	furniture_derp = "Голубь",
	furniture_diningTable = "Обеденный стол",
	furniture_fence = "Забор",
	furniture_flowerVase = "Цветочная ваза",
	furniture_hay = "Сено",
	furniture_hayWagon = "Вагон с сеном",
	furniture_kitchenCabinet = "Кухонный шкаф",
	furniture_painting = "Картина",
	furniture_pumpkin = "Тыква",
	furniture_rip = "RIP",
	furniture_scarecrow = "Пугало",
	furniture_shelf = "Полка",
	furniture_sofa = "Диван",
	furniture_spiderweb = "Паутина",
	furniture_testTubes = "Пробирки",
	furniture_tv = "Телевизор",
	furnitureRewarded = "Мебели открыто: %s",
	ghost = "Призрак",
	ghostbuster = "Охотник за привидениями",
	House4 = "Амбар",
	House5 = "Особняк с привидениями",
	House7 = "Дом на дереве",
	npcDialog_Billy = "Не могу дождаться ограбить банк этой ночью!",
	npcDialog_Blank = "Тебе что-то от меня надо?",
	npcDialog_Cassy = "Хорошего дня!",
	npcDialog_Davi = "Извиняюсь, но я не могу позволить тебе пройти.",
	npcDialog_Derek = "Псс.. Мы собираемся совершить что-то большое сегодня: ограбить банк.\nЕсли хочешь присоединиться, тогда поговори с нашим боссом Pablo.",
	npcDialog_Goldie = "Хочешь продать кристал? Скинь его возле меня, чтобы я мог определить его стоимость.",
	npcDialog_Heinrich = "Хмм... Ты захотел стать шахтером? Если так, то ты должен быть осторожен. Раньше я терялся в этом лабиринте, когда был маленькой мышкой.",
	npcDialog_Jason = "Привет... Мой магазин еще не работает.\nПожалуйста приходите позже!",
	npcDialog_Julie = "Будь осторожен. Этот супермаркет очень опасен.",
	npcDialog_Kapo = "Я всегда прихожу сюда, чтобы посмотреть ежедневные предложения от Dave.\nИногда я получаю редкие вещи, которые есть только у него!",
	npcDialog_Lauren = "Она любит сыр.",
	npcDialog_Louis = "Я говорил ей не класть оливок...",
	npcDialog_Marie = "Я люблюююююю сыр *-*",
	npcDialog_Natasha = "Привет!",
	npcDialog_Pablo = "Так, ты собираешься стать вором? У меня такое чувство, что ты коп под прикрытием...\nА, ты не коп? Ладно, я тебе верю.\\Ты теперь вор и можешь грабить персонажей с розовым именем нажатием ПРОБЕЛ. Помни что надо держаться подальше от копов!",
	npcDialog_Paulo = "Эта коробка очень тяжёлая...\nБыло бы хорошо, если недалеко есть грузоподъемник..",
	npcDialog_Rupe = "Каменная кирка точно не лучший выбор для добычи камня.",
	npcDialog_Santih = "Тут все ещё ",
	npcDialog_Sebastian = "Эй чел.\n...\nЯ не Colt.",
	npcDialog_Weth = "Пуддинг *-*",
    _2ndquest = "Побочный квест",
    arrestedPlayer = "Вы арестовали <v>%s</v>!",
    badgeDesc_0 = "Хэллоуин 2019",
    badgeDesc_1 = "Встретиться с создателем #mycity's",
    badgeDesc_10 = "Арестовать 500 воров",
    badgeDesc_2 = "Поймать 500 рыб",
    badgeDesc_3 = "Добавть 1000 золотых самородков",
    badgeDesc_4 = "Собрать урожай 500 раз",
    badgeDesc_9 = "Выполнить 500 заказов",
    captured = "<g>Вор <v>%s</v> был пойман!",
    chef = "Шеф",
    chestIsFull = "Сундук полон.",
    closed_fishShop = "Рыбный магазин закрыт. Приходие позже!",
    closed_furnitureStore = "Мебельный магазин закрыт. Приходие позже!",
    closed_SeedStore = "Магазин семян закрыт. Возвращайтесь позже.",
    closed_seedStore = "Магазин семян закрыт. Приходие позже!",
    code = " введите код",
    collectorItem = "Предмет Коллекционера",
    command_profile = "<g>!profile</g> <v>[имяИгрока]</v>\n   Открыть профиль <i>игрока</i>.",
    confirmButton_Buy = "Купить за %s",
    confirmButton_Buy2 = "Купить %s\nза %s",
    confirmButton_Great = "Хорошо!",
    confirmButton_Select = "Выбрать",
    confirmButton_Sell = "Продать за %s",
    confirmButton_tip = "Подсказка",
    confirmButton_Work = "Работать!",
    cook = "Готовить",
    createdBy = "Создано %s",
    daysLeft = "%sд. осталось.",
    daysLeft2 = "%sд.",
    eatItem = "Съесть",
    emergencyMode_able = "<r>Подготовка аварийного отключения, новым игрокам вход закрыт. Пожалуйста зайдите в другую комнату #mycity.",
    emergencyMode_pause = "<cep><b>[Внимание!]</b> <r>Модуль достиг критического лимита и будет приостановлен.",
    emergencyMode_resume = "<r>Модуль возобновлен.",
    error_blockedFromHouse = "Вход в дом игрока %s был заблокирован.",
    error_houseClosed = "%s закрыл дом.",
    error_houseUnderEdit = "%s редактирует дом.",
    event_halloween2019 = "Хэллоуин 2019",
    experiencePoints = "Очки опыта",
    farmer = "Фермер",
    houseDescription_1 = "Маленький дом.",
    houseDescription_2 = "Большой дом для больших семей с большими проблемами.",
    houseDescription_3 = "Только самые храбрые могут жить в этом доме. Ууууу!",
    houseDescription_4 = "Устали от жизни в городе? У нас есть то, что тебе нужно.",
    houseDescription_5 = "Настоящий дом привидений. Будь осторожен!",
    houseDescription_6 = "Этот уютный дом принесет комфорт даже в самые холодные дни.",
    houseDescription_7 = "Дом для тех, кто любит просыпаться ближе к природе!",
    houseSettings = "Настройки дома",
    houseSettings_buildMode = "Режим строительства",
    houseSettings_changeExpansion = "Изменить расширение",
    houseSettings_finish = "Завершить!",
    houseSettings_lockHouse = "Закрыть дом",
    houseSettings_permissions = "Права",
    houseSettings_placeFurniture = "Поставить",
    houseSettings_reset = "Сбросить",
    houseSettings_unlockHouse = "Открыть",
    item_bread = "Ломоть хлеба",
    item_bruschetta = "Брускетта",
    item_cheese = "Сыр",
    item_chocolateCake = "Шоколадный торт",
    item_cornFlakes = "Кукурузные хлопья",
    item_crystal_blue = "Синий Кристал",
    item_crystal_green = "Зелёный Кристал",
    item_crystal_purple = "Фиолетовый Кристал",
    item_crystal_red = "Красный Кристал",
    item_crystal_yellow = "Жёлтый Кристал",
    item_dough = "Тесто",
    item_egg = "Яйцо",
    item_fish_Catfish = "Сом",
    item_fish_Dogfish = "Морская собака",
    item_fish_Frog = "Лягушка",
    item_fish_Goldenmare = "Goldenmare", -- ?
    item_fish_Lionfish = "Крылатки",
    item_fish_Lobster = "Лобстер",
    item_fish_RuntyGuppy = "Низкорослый Гуппи",
    item_fish_SmoltFry = "Маленькая рыбёшка",
    item_frenchFries = "Картофель фри", 
    item_frogSandwich = "Фрогвич", -- ?
    item_garlic = "Чеснок",
    item_garlicBread = "Хлеб с чесноком",
    item_grilledLobster = "Жареный лобстер",
    item_honey = "Мёд",
    item_hotsauce = "Острый соус",
    item_lemonade = "Лимонад",
    item_lettuce = "Лист салата",
    item_lobsterBisque = "Суп из лобстера",
    item_pierogies = "Пироги",
    item_pizza = "Пицца",
    item_potato = "Картофель",
    item_pudding = "Пуддинг",
    item_pumpkin = "Тыква",
    item_pumpkinSeed = "Тыквенные семена",
    item_salad = "Салат",
    item_salt = "Соль",
    item_sauce = "Томатный соус",
    item_superFertilizer = "Супер удобрение",
    item_surfboard = "Доска для серфинга",
    item_waffles = "Вафли",
    item_wheat = "Пшеница",
    item_wheatFlour = "Пшеничная мука",
    item_wheatSeed = "Семена пшеницы",
    itemAddedToChest = "Предмет %s был добавлен в сундук.",
    itemAmount = "Предметы: %s",
    itemDesc_cheese = "Используйте этот предмет чтобы получить сыр в магазин Transformice!",
    itemDesc_superFertilizer = "В 2 раза эффективнее обычного удобрения.",
    itemInfo_miningPower = "Повреждение камня: %s",
    itemInfo_Seed = "Время роста: <vp>%smin</vp>\nЦена за семя: <vp>$%s</vp>",
    landVehicles = "Наземный",
    level = "Уровень %s",
    levelUp = "%s достиг %s уровня!",
    limitedItemBlock = "Вы должны подождать %s секунд чтобы использовать этот предмет.",
    locked_quest = "Квест %s",
    maxFurnitureDepot = "Мебельный склад заполнен.",
    maxFurnitureStorage = "Вы можете иметь только %s мебели в вашем доме.",
    multiTextFormating = "{0}: {1}",
    newBadge = "Новый значёк",
    newLevel = "Новый уровень!",
    newLevelMessage = "Поздравляем! Вы достигли нового уровня!",
    newQuestSoon = "Квест %s еще не доступен :/\n<font size=\"11\">Стадия разработки: %s%%",
    npcDialog_Alexa = "Привет. Что нового?",
    orderCompleted = "Вы доставили заказ %s и получили %s!",
    ouseSetting_storeFurnitures = "Переместить всю мебель и инвернтарь.",
    owned = "Приобретено",
    passToBag = "Переместить в рюкзак",
    percentageFormat = "%s%%",
    permissions_blocked = "Заблокировано",
    permissions_coowner = "Совладелец",
    permissions_guest = "Гость",
    permissions_owner = "Владелец",
    permissions_roommate = "Сосед",
    price = "Цена: %s",
    profile_arrestedPlayers = "Пойманные игроки",
    profile_badges = "Значки",
    profile_basicStats = "Главные данные",
    profile_capturedGhosts = "Пойманные призраки",
    profile_coins = "Монеты",
    profile_completedQuests = "Квесты",
    profile_completedSideQuests = "Побочные квесты",
    profile_cookedDishes = "Приготовленные блюда",
    profile_fishes = "Поймано",
    profile_fulfilledOrders = "Выполнено заказов",
    profile_gold = "Собрано золота",
    profile_jobs = "Работы",
    profile_purchasedCars = "Куплено машин",
    profile_purchasedHouses = "Куплено домов",
    profile_questCoins = "Очки квестов",
    profile_robbery = "Ограблений",
    profile_seedsPlanted = "Посажено",
    profile_seedsSold = "Продаж",
    profile_spentCoins = "Потрачено монет",
    questCompleted = "Вы выполнили квест %s!\nВаша награда:",
    ranking_Season = "Сезон %s",
    recipes = "Рецепты",
    reward = "Награда",
    rewardText = "Вы получили невероятную награду!",
    saveChanges = "Сохранить изменения",
    seedSold = "Вы продали %s за %s.",
    seeItems = "Посмотреть предметы",
    sell = "Продать",
    sellFurniture = "Продать мебель",
    sellFurnitureWarning = "Вы действительно хотите продать эту мебель?\n<r>Это действие не может быть отменено!</r>",
    setPermission = "Сделать %s",
    settings_config_lang = "Язык",
    settings_config_mirror = "Отразить текст",
    settings_credits = "Авторы",
    settings_creditsText = "<j>#Mycity</j> была создана <v>%s</v>, с использованием рисунков <v>%s</v> и переведена :",
    settings_creditsText2 = "Отдельная благодарность <v>%s</v> за помощь с важными ресурсами для модуля.",
    settings_donate = "Пожертовавать",
    settings_donateText = "<j>#Mycity</j> - это проект, начатый в <b><cep>2014</cep></b>, но с другим игровым процессом: <v>построение города</v>! Все же, этот проект не продвинулся и был отменен спустя месяцы.\n В <b><cep>2017</cep></b>, я решил переделать его с другой целью: <v>жизнь в городе</v>!\n\n Большая часть доступных функций были сделаный мной за <v>длительное и утомительное</v> время.\n\n Если вы можете помочь мне, сделайте пожертвование. Это воодушевляет меня создавать новые обновления!",
    settings_help = "Помощь",
    settings_helpText = "Добро пожаловать в <j>#Mycity</j>!\n Если хочешь узнать, как играть в эту игру, нажми на кнопку ниже:",
    settings_helpText2 = "Доступные команды:",
    settings_settings = "Настройки",
    settingsText_createdAt = "Комната создана <vp>%s</vp> минут назад.",
    settingsText_currentRuntime = "Время выполнения: <r>%s</r>/60мс",
    settingsText_grounds = "Сгенерировано поверхностей: %s/509",
    sidequestCompleted = "Вы выполнили побочный квест!\nВаша награда:",
    speed = "Скорость: %s",
    speed_km = "км/ч",
    speed_knots = "узлов",
    syncingGame = "<r>Синхронизация игровых данных. Игра остановится на несколько секунд.",
    tip_vehicle = "Нажмите на звезду возле иконки вашего транспорта, чтобы сделать его предпочтительным. Нажмите F или G на клавиатуре, чтобы использовать выбранную машину или лодку.",
    transferedItem = "Предмет %s был перемещён в сумку.",
    unlockedBadge = "Вы открыли новый значёк!",
    vehicle_11 = "Яхта",
    vehicle_12 = "Bugatti",
    vehicle_6 = "Рыболовная лодка",
    vehicle_8 = "Патрульный катер",
    vehicleError = "Вы не можете использовать здесь транспорт.",
    waitingForPlayers = "Ожидание игроков...",
    waterVehicles = "Водный",
    week = "Неделя %s",
    week1 = "<p align=\"center\">Загадка шахты\n\nтекст",
    wordSeparator = " и ",

    quests = {
        [1] = {
            name = "Квест 01: Создание лодки",
            [0] = {
                _add = "Поговори с Kane",
                dialog = "Привет! Как дела? Недавно кто-то открыл остров за морем. Там много деревьев и пару зданий.\nКак ты знаешь, в городе нет аэропорта. Единственный способ попасть туда - с помощью лодки.\nЯ могу построить одну для тебя, но сначала ты помоги мне.\nВ моем следующем приключении, я бы хотел узнать, что находится по другую сторону шахты. У меня есть пара теорий, требующих подтверждений.\nДумаю эта экспедиция будет долгой, и мне потребудется много еды.\nМожешь поймать 5 рыб для меня?"
            },
            [1] = {
                _add = "Вылови %s рыб"
            },
            [2] = {
                _add = "Поговори с Kane",
                dialog = "Вау! Спасибо тебе за рыбу! Не могу дождаться съесть её.\nПринесешь мне еще 3 Coca-Cola? Ты можешь купить её в магазине."
            },
            [3] = {
                _add = "Купи %s Coca-Cola"
            },
            [4] = {
                _add = "Поговори с Kane",
                dialog = "Спасибо, что принес мне еды! Теперь моя очередь отплатить.\nНо сначала мне понадобятся доски, чтобы построить тебе лодку.\nНедавно, я видел Chrystian за рубкой деревьев. Спроси его, не может ли он поделиться досками с тобой."
            },
            [5] = {
                _add = "Поговори с Chrystian",
                dialog = "Так тебе нужны доски? Я могу дать тебе их, если принесешь мне курузные хлопья.\nНе мог бы ты это сделать?"
            },
            [6] = {
                _add = "Купи курузные хлопья"
            },
            [7] = {
                _add = "Поговори с Chrystian",
                dialog = "Спасибо за помощь! Вот деревянные доски которые ты просил. Найди им хорошее применение!"
            },
            [8] = {
                _add = "Поговори с Kane",
                dialog = "Это заняло больше времени чем я думал... Я думал ты уже забыл о досках...\nНо теперь, я могу тебе соорудить лодку...\nВот твоя лодка! Хорошо провести время на острове и будь осторожен!"
            },
        },
        [2] = {
            name = "Квест 02: Потерянные ключи",
            [0] = {
                _add = "Отправляйся на остров."
            },
            [1] = {
                _add = "Поговори с Indy",
                dialog = "Эй! Ты кто? Я никогда тебя не встречал...\nЯ Indy! Я живу на этом острове уже давно. Тут много отличных мест которые можно посетить.\nЯ владелец магазина зелий. Я бы мог тебя пригласить в магазин, но у меня есть большая проблема: я потерял ключи от него!\nДолжно быть, я потерял ключи во время своих раскопок в шахте. Можешь помочь мне?"
            },
            [2] = {
                _add = "Отправляйся в шахту."
            },
            [3] = {
                _add = "Найди ключи Indy."
            },
            [4] = {
                _add = "Принесите Indy ключи.",
                dialog = "Спасибо! Теперь пора возвращаться к работе!\nПодожди...\nОдного ключа не хватает: ключа магазина! Ты хорошо искал?"
            },
            [5] = {
                _add = "Отправляйся обратно в шахту."
            },
            [6] = {
                _add = "Найди последний ключ."
            },
            [7] = {
                _add = "Принесите Indy ключи.",
                dialog = "Наконец-то! Тебе стоить быть внимательнее, я бы успел фильм посмотреть, пока тебя ждал.\nЕще хочешь посмотреть на магазин? Я уже иду!"
            },
        },
        [3] = {
            name = "Квест 03: Кража",
            [0] = {
                _add = "Отправляйся на полицейский участок."
            },
            [1] = {
                _add = "Поговори с Sherlock.",
                dialog = "Привет. У нас недостаток офицеров полиции и нам нужна твоя помощь, ничего сложного не пригодится.\nВ банке было совержено загадочное преступление, пока что подозреваемый не был найдем...\nЯ думаю в банке должны быть зацепки.\nColt должен знать больше о том, как это произошло. Поговори с ним."
            },
            [2] = {
                _add = "Иди в банк"
            },
            [3] = {
                _add = "Поговори с Colt.",
                dialog = "ЧТО? Sherlock отправил тебя сюда? Я ему говорил, что этим делом занят я\nПередай ему что мне не нужна помощь. Я спавлюсь с этим сам."
            },
            [4] = {
                _add = "Отправляйся обратно на полицейский участок."
            },
            [5] = {
                _add = "Поговори с Sherlock..",
                dialog = "Я знал, что он не захочет принимать нашу помощь...\nБудем искать зацепки без него.\nМы должны зайдти в банк когда Colt не будет рядом, ты можешь сделать это, так ведь?"
            },
            [6] = {
                _add = "Зайди в банк, во время его ограбления."
            },
            [7] = {
                _add = "Поищи зацепки в банке."
            },
            [8] = {
                _add = "Отправляйся в полицейский участок."
            },
            [9] = {
                _add = "Поговори с Sherlock..",
                dialog = "Очень хорошо! Эта одежда поможет нам найти подозреваемого.\nПоговори с Indy. Он нам поможет."
            },
            [10] = {
                _add = "Поговори с Indy.",
                dialog = "Так... Тебе понадобится помощь в этом расследовании?\nХмм... Дай мне посмотреть на эту одежду...\nЯ её где-то видел. Её использовали в госпитале! Посмотри сюда!"
            },
            [11] = {
                _add = "Направляйся в госпиталь."
            },
            [12] = {
                _add = "Ищи что-то подозрительное в госпитале."
            },
            [13] = {
                _add = "Отправляйся в шахту."
            },
            [14] = {
                _add = "Найди подозреваемого в одной из шахт."
            },
            [15] = {
                _add = "Отправляйся в полицейский участок."
            },
            [16] = {
                _add = "Поговори с Sherlock..",
                dialog = "Хорошая работа! Ты на самом деле хорошо справляешься.\nЯ знаю отличное место для восстановления сил после долгого расследования: кофейня!"
            },
        },
        [4] = {
        	name = "Квест 04: Соуc закончился!",
            [0] = {
                _add = "Поговори с Kariina.",
                dialog = "Привет, %s! Не хочешь отведать пиццы?\nЧто ж, у меня плохие новости для тебя.\nСегодняшем днем, я начала готовить пиццу, но заметила что весь соус закончился.\nЯ пыталась купить томатов в магазине, но, оказывается, они их не продают.\nЯ начала жить в этом городке пару недель назад, и не знаю, кто может мне помочь\nПоэтому, пожалуйста, поможешь мне? Мне всего лишь нужен соус для открытия пиццерии."
            },
            [1] = {
                _add = "Плыви на остров."
            },
            [2] = {
                _add = "Отправляйся в магазин семян."
            },
            [3] = {
                _add = "Купи семена."
            },
            [4] = {
                _add = "Зайди в свой дом."
            },
            [5] = {
                _add = "Посади семечко у себя дома. (Тебе понадобится грядка!)"
            },
            [6] = {
                _add = "Собери томат."
            },
            [7] = {
                _add = "Отправляйся в магазин семян."
            },
            [8] = {
                _add = "Купи ведро воды."
            },
            [9] = {
                _add = "Отправляйся в магазин."
            },
            [10] = {
                _add = "Купи соли."
            },
            [11] = {
                _add = "Приготовь соус. (Ипользуй печь!)"
            },
            [12] = {
                _add = "Принеси соус к Kariina.",
                dialog = "Вау! Спасибо! Теперь остался только острый соус. Приготовишь немного?"
            },
            [13] = {
                _add = "Посади семечко у себя дома."
            },
            [14] = {
                _add = "Собери перец"
            },
            [15] = {
                _add = "Приготовь острый соус."
            },
            [16] = {
                _add = "Принеси острый соус Kariina.",
                dialog = "ОМГ! Ты сделал это! Спасибо!\nПока тебя не было, я поняла что мне хватает теста. Не сделаешь мне его?"
            },
            [17] = {
                _add = "Посади семечко у себя дома."
            },
            [18] = {
                _add = "Собери пшеницу."
            },
            [19] = {
                _add = "Принеси тесто Kariina.",
                dialog = "Вау! Спасибо, ты мог бы работать со мной, когда мне понадобится новый работник.\nСпасибо за помощь. Теперь я могу готовить пиццу!"
            },
        },
    },
}

--[[ translations/tr.lua ]]--
lang.tr = {
    item_crystal_green = "Yeşil Kristal",
    item_fish_RuntyGuppy = "Minik Lepistes",
    landVehicles = "Kara",
    item_pumpkinSeed = "Balkabağı Tohumu",
    item_garlic = "Sarımsak",
    item_fish_Dogfish = "Köpekbalığı",
    boats = "Botlar",
    orderCompleted = "%s görevini tamamladın ve %s kazandın!",
    furniture_christmasCandyBowl = "Şekerlik",
    enterQuestPlace = "<vp>%s</vp> tamamladıktan sonra bu mekan açılır.",
    houseSettings_placeFurniture = "Yerleştir",
    item_lemon = "Limon",
    _2ndquest = "Yan Görev",
    vehicle_11 = "Yat",
    itemDesc_pickaxe = "Kayaları kırar",
    item_cornFlakes = "Mısır Gevreği",
    furnitures = "Mobilyalar",
    item_tomato = "Domates",
    item_cheese = "Peynir",
    hospital = "Hastane",
    playerBannedFromRoom = "%s bu odadan yasaklandı.",
    newLevel = "Yeni seviye!",
    houseSettings_reset = "Sıfırla",
    permissions_blocked = "Engellendi",
    item_coffee = "Kahve",
    goTo = "Git",
    npcDialog_Rupe = "Kuşkusuz ki taştan yapılmış bir kazma taş kırmak için elverişli değildir.",
    fishingError = "Artık balık tutmuyorsunuz.",
    noMissions = "Mevcut bir görev yok.",
    ranking_Season = "Sezon %s",
    maxFurnitureStorage = "Evinde sadece %s adet mobilyaya sahip olabilirsin.",
    houseSettings_permissions = "İzinler",
    item_fish_Lobster = "Istakoz",
    sell = "Sat",
    furniture_christmasSnowman = "Kardan adam",
    furniture_christmasSocks = "Yılbaşı çorabı",
    runAwayCoinInfo = "Soygunu tamamladığında %s kazanacaksın.",
    item_sauce = "Domates Sosu",
    houseSettings_lockHouse = "Evi kilitle",
    error_houseUnderEdit = "%s evini düzenliyor.",
    settings_config_lang = "Dil",
    item_wheat = "Buğday",
    House4 = "Ahır",
    shop = "Market",
    itemDesc_clock = "Sadece bir defa kullanabileceğin basit bir saat",
    rewardNotFound = "Ödül bulunamadı.",
    badgeDesc_4 = "500 bitki hasat edildi",
    npcDialog_Lauren = "O peyniri sever.",
    furniture_bed = "Yatak",
    npcDialog_Cassy = "İyi günler!",
    furniture_painting = "Tablo",
    furniture_christmasGift = "Hediye kutusu",
    item_fish_Frog = "Kurbağa",
    settingsText_availablePlaces = "Mevcut mekanlar: <vp>%s</vp>",
    questCompleted = "%s görevini tamamladın!\nÖdülün:",
    houseDescription_5 = "Hayaletlerin gerçek evi. Dikkatli ol!",
    permissions_guest = "Konuk",
    newUpdate = "Bir güncelleme mevcut. Lütfen odaya tekrar girin.",
    expansion_pool = "Havuz",
    houseSettings_changeExpansion = "Genişletmeyi Seç",
    houseDescription_4 = "Şehirde yaşamaktan bıktın mı? İhtiyacın olan bizde.",
    furniture_derp = "Güvercin",
    closed_bank = "Banka kapandı. Sonra yine gel!",
    profile_arrestedPlayers = "Tutuklanan oyuncular",
    item_lemonSeed = "Limon Tohumu",
    waterVehicles = "Su",
    settings_helpText2 = "Mevcut komutlar:",
    item_salt = "Tuz",
    hungerInfo = "<v>%s</v> açlık",
    codeNotAvailable = "Kod Kullanılamaz",
    item_frogSandwich = "Kurbağa Sandviçi",
    buy = "Satın al",
    using = "Kullanılıyor",
    npcDialog_Alexa = "Hey. Ne var ne yok?",
    robberyInProgress = "Soygun devam ediyor",
    settingsText_grounds = "Oluşturulan alanlar: %s/509",
    confirmButton_Buy2 = "%s satın al\n%s için",
    itemDesc_shrinkPotion = "%s saniye küçülmek için bu iksiri kullan!",
    badgeDesc_9 = "500 sipariş tamamlandı",
    moneyError = "Yeterli paran yok.",
    bagError = "Çantada yetersiz alan.",
    playerUnbannedFromRoom = "%s yasağı kaldırıldı.",
    npc_mine6msg = "Bu her an çökebilir, ama kimse beni dinlemiyor.",
    hunger = "Aç",
    multiTextFormating = "{0}: {1}",
    House6 = "Yılbaşı evi",
    no = "Hayır",
    item_bruschetta = "Bruschetta",
    vehicle_6 = "Balıkçı Teknesi",
    npcDialog_Santih = "Hala bu gölette balık tutmaya cesaret edebilen birçok insan var.",
    item_water = "Su Kovası",
    houseDescription_1 = "Küçük bir ev.",
    profile_purchasedCars = "Alınan Arabalar",
    item_fish_Lionfish = "Aslan Balığı",
    item_fertilizer = "Gübre",
    furniture_spiderweb = "Örümcek Ağı",
    houseDescription_2 = "Büyük sorunları olan büyük aileler için büyük bir ev.",
    itemDesc_minerpack = "%s kazma(lar) içerir.",
    sellFurnitureWarning = "Bu eşyayı satmak istediğine emin misin?\n<r>Bu eylem geri alınamaz!</r>",
    profile_completedQuests = "Görevler",
    atmMachine = "ATM",
    profile_coins = "Para",
    house = "Ev",
    closed_market = "Market kapandı. Şafak vakti geri gel.",
    pizzaMaker = "Pizzacı",
    use = "Kullan",
    item_sugar = "Şeker",
    npcDialog_Davi = "Üzgünüm ama burdan gitmene izin veremem.",
    rewardText = "İnanılmaz bir ödül kazandın!",
    furniture_christmasFireplace = "Şömine",
    price = "Fiyat: %s",
    item_fish_SmoltFry = "Somon",
    settings_donate = "Bağış",
    command_profile = "<g>!profile</g> <v>[oyuncu adı]</v>\n   <i>oyuncu adı'nın</i> profilini gösterir.",
    item_tomatoSeed = "Tomates Tohumu",
    newBadge = "Yeni rozet",
    speed = "Hız: %s",
    furniture_chest = "Sandık",
    itemDesc_goldNugget = "Parlak ve değerli.",
    confirmButton_Sell = "%s için sat",
    sideQuests = {
        [1] = "Oliver'in bahçesine %s tohumları ek.",
        [2] = "Oliver'in bahçesinde %s için  gübre kullan.",
        [3] = "Get %s coins.",
        [4] = " %s kere hırsız yakala.",
        [5] = " %s eşyaları kullan.",
        [6] = " %s para harca.",
        [7] = " %s kere balık tut",
        [8] = "Altın külçelerim %s ",
        [9] = "Bankayı soy.",
        [10] = "%s soygun tamamla.",
        [11] = "%s kere yemek yap.",
        [12] = "%s xp kazan.",
        [13] = "%s kurbağa yakala.",
        [14] = "%s aslan balığı yakala.",
        [15] = "%s sipariş teslim et.",
        [16] = "%s sipariş teslim et.",
        [18] = "Bruschetta yap.",
        [19] = "Limonata yap.",
        [20] = "Kurbağa sandviçi yap.",
        [17] = "Pizza yap."
    },
    npcDialog_Paulo = "Bu kutu cidden çok ağır...\nBuralarda bir forklift olsa ne de güzel olurdu be.",
    item_luckyFlowerSeed = "Şanslı Çiçek Tohumu",
    item_blueberriesSeed = "Yaban mersini tohumu",
    settingsText_hour = "Güncel saat: <vp>%s</vp>",
    sellGold = "%s Altın Parçasını(larını) <vp>%s</vp> için sat",
    houseDescription_6 = "Bu rahat ev size en zor gecelerde bile komfor sağlayacak.",
    itemInfo_Seed = "Yetişme vakti: <vp>%smin</vp>\nTohum başına fiyat: <vp>$%s</vp>",
    levelUp = "%s şu seviyeye ulaştı %s!",
    sleep = "Uyku",
    item_superFertilizer = "Süper Gübre",
    newQuestSoon = "%snci görev mevcut değil :/\n<font size=\"11\">Geliştirme süreci: %s%%",
    settings_help = "Yardım",
    badgeDesc_1 = "#mycity'nin yapımcısıyla tanış",
    ranking_spentCoins = "Para harca",
    profile_jobs = "Meslekler",
    furnitureRewarded = "Mobilya açıldı: %s",
    error = "Hata",
    vehicle_5 = "Bot",
    item_hotsauce = "Acı sos",
    closed_furnitureStore = "Mobilyacı kapandı. Daha sonra yeniden gel!",
    profile_gold = "Toplanan altın",
    hey = "Hey! Dur!",
    itemAddedToChest = "%s eşyası sandığına eklendi.",
    item_milkShake = "Milkshake",
    confirmButton_Select = "Seç",
    profile_seedsPlanted = "Ekinler",
    noEnergy = "Çalışmak için daha fazla enerjiye ihtiyacın var.",
    password = "Şifre",
    runAway = "%s saniye içinde kaç.",
    maxFurnitureDepot = "Mobilya depon dolu.",
    npcDialog_Billy = "Bu geceki banka soygunu için sabırsızlanıyorumm!",
    vehicleError = "Bu aracı burada kullanamazsın.",
    item_oregano = "Kekik",
    npcDialog_Pablo = "Yani hırsız mı olmak istiyorsun? Polisin gizli ajanı olduğuna dair şüphelerim var...\nAh, değil misin? İyi, Sana inanıyorum o zaman.\nArtık hırsızsın ve pembe isimli karakterleri SPACE tuşuna basarak soyabilirsin. Polisten kaçmayı unutma!",
    expansion_garden = "Bahçe",
    closed_potionShop = "İksir dükkanı kapandı. Daha sonra tekrar gel!",
    receiveQuestReward = "Ödülü Al",
    houseDescription_3 = "Sadece en cesurlar burada yaşayabilir. Ooooo!",
    furniture_scarecrow = "Korkuluk",
    House5 = "Perili Köşk",
    error_maxStorage = "Maksimum miktar alındı.",
    itemDesc_fertilizer = "Tohumlar daha çabuk büyür!",
    furniture_rip = "RIP",
    houseSetting_storeFurnitures = "Bütün mobilyaları envantere koy",
    itemDesc_water = "Tohumlar daha çabuk büyür!",
    npcDialog_Louis = "Ona zeytin koymamasını söylemiştim...",
    furniture_shelf = "Raf",
    houseSettings = "Ev Ayarları",
    emergencyMode_able = "<r>Acil kapatma işlemi başlatılıyor, yeni oyunculara izin verilmiyor. Lütfen başka bir #mycity odasına gidin.",
    item_dough = "Hamur",
    item_lobsterBisque = "Istakoz Bisque",
    item_hotChocolate = "Sıcak Çikolata",
    harvest = "Hasat et",
    item_wheatFlour = "Buğday Unu",
    speed_knots = "knot",
    badgeDesc_0 = "2019 Cadılar Bayramı",
    npcDialog_Weth = "Puding *-*",
    minerpack = "Madenci Paketi %s",
    badgeDesc_2 = "500 balık yakalandı",
    settings_credits = "Credits",
    timeOut = "Kullanılamaz yer.",
    healing = "%s içinde canlandırılacaksınız",
    percentageFormat = "%s%%",
    codeReceived = "Ödülün: %s.",
    furniture_christmasCarnivorousPlant = "Etçil Bitki",
    furniture_hayWagon = "Saman Vagonu",
    closed_dealership = "Satıcı kapalı. Şafak vakti geri gel.",
    item_growthPotion = "Büyüme İksiri",
    profile_badges = "Rozetler",
    item_pudding = "Puding",
    badgeDesc_3 = "1000 altın parçası bulundu",
    bankRobAlert = "Banka soyuluyor. Bankası savun!",
    item_shrinkPotion = "Küçülme İksiri",
    item_bread = "Somun Ekmek",
    House3 = "Perili ev",
    badgeDesc_7 = "Kızak alındı",
    vehicle_12 = "Bugatti",
    profile_basicStats = "Genel Veri",
    item_milk = "Şişe süt",
    elevator = "Asansör",
    settings_gamePlaces = "Mekanlar",
    furniture_tv = "Tv",
    incorrect = "Yanlış",
    badgeDesc_10 = "500 hırsız tutuklandı",
    furniture_flowerVase = "Çiçek Vazosu",
    soon = "Yakında!",
    furniture_bookcase = "Kitaplık",
    item_energyDrink_Ultra = "Coca-Cola",
    profile_completedSideQuests = "Yan Görevler",
    item_pierogies = "Piruhi",
    items = "Eşyalar:",
    confirmButton_tip = "İpucu",
    level = "Seviye %s",
    error_boatInIsland = "Denizden uzakta bot kullanamazsın.",
    ghostbuster = "Hayalet avcısı",
    npcDialog_Goldie = "Kristal mı satmak istiyorsun? Yanıma bırak ki değerini hesaplıyayım.",
    furniture_hay = "Saman",
    profile_seedsSold = "Satış",
    confirmButton_Work = "Çalış!",
    createdBy = "%s tarafından yapılmıştır",
    profile_questCoins = "Görev Puanı",
    emergencyMode_pause = "<cep><b>[Uyarı!]</b> <r>Modül kritik limitine ulaştı ve durduruldu.",
    vehicles = "Araçlar",
    profile_purchasedHouses = "Alınan Evler",
    chestIsFull = "Sandık dolu.",
    profile_capturedGhosts = "Yakalanan hayaletler",
    codeLevelError = "Kodu %s seviyeye ulaşınca kullanabilirsin.",
    profile_fulfilledOrders = "Tamamlanan siparişler",
    item_pepperSeed = "Biber Tohumu",
    week1 = "<p align=\"center\">Madenin gizemi\n\nmetni",
    completedQuest = "Görev Tamamlandı",
    quest = "Görev",
    copError = "Tekrar tutmak için 10 saniye beklemelisiniz.",
    item_egg = "Yumurta",
    profile_robbery = "Soygunlar",
    waitUntilUpdate = "<rose>Lütfen bekle.</rose>",
    permissions_roommate = "Oda arkadaşı",
    unlockedBadge = "Yeni bir rozet kazandın!",
    item_fish_Catfish = "Kedi Balığı",
    itemDesc_seed = "Rastgele bir tohum.",
    daysLeft2 = "%sd",
    closed_police = "Polis merkezi kapalı. Şafak vakti geri gel.",
    item_energyDrink_Basic = "Sprite",
    setPermission = "%s yap",
    closed_seedStore = "Tohum dükkanı kapandı. Daha sonra tekrar gel!",
    settings_helpText = "<j>#Mycity</j> ye hoşgeldiniz!\n Nasıl oynandığını merak ediyorsanız, aşağıdaki butona tıklayın:",
    error_blockedFromHouse = "%s'nin evine girmen engellendi.",
    farmer = "Çiftçi",
    goldAdded = "Topladığın altın parçası çantana eklendi.",
    npcDialog_Natasha = "Selam!",
    npcDialog_Marie = "Peynire bayılıyorummmmmmmm *-*",
    reward = "Ödül",
    pickaxes = "Kazmalar",
    furniture = "Fırın",
    houseSettings_buildMode = "İnşa Modu",
    item_salad = "Salata",
    itemDesc_superFertilizer = "Gübreden 2 kat daha etkili.",
    item_dynamite = "Dinamit",
    settingsText_currentRuntime = "Runtime: <r>%s</r>/60ms",
    settings_settings = "Ayarlar",
    item_wheatSeed = "Buğday Tohumu",
    fishWarning = "Burada balık tutamazsın.",
    settings_creditsText = "<j>#Mycity</j> <v>%s</v> tarafından yapıldı, görseller <v>%s</v> tarafından yapıldı ve şunlar tarafından çevrildi:",
    energyInfo = "<v>%s</v> enerji",
    settings_creditsText2 = "Ayrıca <v>%s</v> ya modüldeki önemli şeylerde yardım ettiği için teşekkürler.",
    settings_donateText = "<j>#Mycity</j> projesi, <b><cep>2014</cep></b> ile başladı ama başka bir oynanışla: <v>şehir yap</v>! Ancak, bu proje başarılı olamadı ve aylar sonra iptal edildi.\n <b><cep>2017</cep></b> de, Yeni bir amaçla tekrar yapmaya karar verdim: <v>şehirde yaşa</v>!\n\n Mevcut fonksiyonların çoğu benim tarafımdan  <v>uzun ve yorucu</v> bir sürede yapıldı.\n\n Eğer imkanınız varsa, bağış yapın. Bu beni yeni güncellemeler getirmek için motive ediyor!",
    miner = "Madenci",
    copAlerted = "Polisler uyarıldı.",
    item_oreganoSeed = "Kekik Tohumu",
    sidequestCompleted = "Bir yan görev tamamladın!\nÖdülün:",
    wordSeparator = " ve ",
    chef = "Şef",
    itemInfo_miningPower = "Taş hasarı: %s",
    House1 = "Klasik ev",
    open = "Aç",
    furniture_cauldron = "Kazan",
    saveChanges = "Değişiklikleri Kaydet",
    syncingGame = "<r>Oyun verisi senkronize ediliyor . Oyun birkaç saniyeliğine duracak.",
    captured = "<g>Hırsız <v>%s</v> tutuklandı!",
    locked_quest = "Görev %s",
    profile_spentCoins = "Harcanan Para",
    item_grilledLobster = "Izgara Istakoz",
    transferedItem = "%s eşyası çantana transfer edildi.",
    itemDesc_cheese = "Bu eşyayı Transformice mağazasında bir peynir almak için kullan!",
    settings_config_mirror = "Yansıtılmış Metin",
    cancel = "İptal et",
    item_crystal_red = "Kırmızı Kristal",
    close = "Kapat",
    updateWarning = "<font size=\"10\"><rose><p align=\"center\">Uyarı!</p></rose>\nYeni güncelleme %smin %ss içinde",
    badgeDesc_5 = "500 tamamlanmış hırsızlık",
    seedSold = "%s'i %s için sattın.",
    looseMgs = "%s içinde öldürüleceksin.",
    item_bag = "Çanta",
    npcDialog_Jason = "Hey... Dükkanım henüz satış yapmıyor.\nLütfen daha sonra tekrar gel!",
    confirmButton_Buy = "%s ile satın al",
    eatItem = "Ye",
    item_waffles = "Wafflelar",
    tip_vehicle = "Tercih edilen araç yapmak için aracının yanında bulunan yıldıza tıkla. F veya G ye basarak tercih edilen aracını kullanabilirsin.",
    furniture_fence = "Çit",
    codeInfo = "Geçerli bir kod gir ve onaylaya tıklayarak ödülünü al.\nDiscord sunucumuza katılarak yeni kodları alabilirsin.\n<a href=\"event:getDiscordLink\"><v>(Davet bağlantısı için buraya tıkla)</v></a>",
    npcDialog_Kapo = "Buraya Dave'in günlük teklifleri için daima gelirim.\nBazen sadece onda olan nadir eşyalar bulurum!",
    settingsText_createdAt = "Oda <vp>%s</vp> dakika önce kuruldu.",
    police = "Polis",
    item_lettuce = "Marul",
    item_fish_Goldenmare = "Goldenmare",
    alreadyLand = "Bazı oyuncular bu bölgeyi çoktan satın aldı..",
    seeItems = "Eşyaları kontrol et",
    profile_cookedDishes = "Pişirilen yemekler",
    ranking_coins = "Biriken Para",
    expansion = "Genişletmeler",
    itemDesc_bag = "+ %s çanta kapasitesi",
    furniture_oven = "Fırın",
    item_pepper = "Biber",
    limitedItemBlock = "Bu eşyayı kullanabilmek için %s saniye beklemelisin.",
    energy = "Enerji",
    event_halloween2019 = "2019 Cadılar Bayramı",
    emergencyMode_resume = "<r>Modül devam ediyor.",
    bag = "Çanta",
    item_lemonade = "Limonata",
    houses = "Evler",
    arrestedPlayer = "<v>%s</v> yı tutukladın!",
    House7 = "Ağaç evi",
    item_potato = "Patates",
    job = "Meslek",
    item_garlicBread = "Sarımsaklı Ekmek",
    furniture_testTubes = "Deney Tüpleri",
    newLevelMessage = "Tebrikler! Seviye atladın!",
    drop = "Bırak",
    itemDesc_growthPotion = "%s saniye büyümek için bu iksiri kullan!",
    furniture_cross = "Haç",
    cook = "Pişir",
    daysLeft = "%sd kaldı.",
    item_chocolateCake = "Çikolatalı Pasta",
    item_frenchFries = "Patates Kızartması",
    item_luckyFlower = "Şanslı Çiçek",
    settingsText_placeWithMorePlayers = "Daha fazla oyuncu içeren yer: <vp>%s</vp> <r>(%s)</r>",
    thief = "Hırsız",
    furniture_diningTable = "Yemek Masası",
    itemDesc_dynamite = "Booooom!",
    sellFurniture = "Mobilyayı sat",
    npcDialog_Blank = "Benden bir isteğin var mı?",
    furniture_christmasWreath = "Yılbaşı çelengi",
    closed_fishShop = "Balık dükkanı kapandı. Daha sonra tekrar gel!",
    code = "Kod gir",
    codeAlreadyReceived = "Kod zaten kullanıldı.",
    recipes = "Tarifler",
    badgeDesc_6 = "Yılbaşı 2019",
    item_crystal_blue = "Mavi Kristal",
    item_honey = "Bal",
    npcDialog_Julie = "Dikkatli ol. Bu süpermarket çok tehlikeli.",
    ghost = "Hayalet",
    remove = "Sil",
    item_crystal_yellow = "Sarı Kristal",
    expansion_grass = "Çimen",
    collectorItem = "Koleksiyoncu eşyası",
    quests = {
        [2] = {
            [0] = {
                _add = "Adaya git."
            },
            [7] = {
                dialog = "Sonunda! Daha dikkatli olmalısın, Seni beklerken film izleyebilirdim.\nHala dükkanı görmek istiyor musun? Oraya gidiyorum!",
                _add = "Indy'e anahtarlarını götür."
            },
            [1] = {
                dialog = "Hey! Kimsin sen? Seni daha önce hiç görmemiştim...\nAdım Indy! Uzun süredir bu adada yaşıyorum. Burada görecek çok yer var.\nİksir dükkanının sahibiyim.Sana dükkanı göstermeyi isterdim, lakin büyük bir sorunumuz var: Dükkanımın anahtarlarını kaybettim!\nSanırım madende çalışırken orada düşürdüm. Bana yardım eder misin?",
                _add = "Indy ile konuş"
            },
            [2] = {
                _add = "Madene git."
            },
            [4] = {
                dialog = "Teşekkürler! Şimdi işime dönebilirim!\nBir dakika...\n1 anahtar eksik: dükkanın anahtarı! Dikkatli baktın mı?",
                _add = "Anahtarları Indy'e götür."
            },
            [5] = {
                _add = "Madene git."
            },
            name = "Görev 02: Kayıp Anahtarlar",
            [3] = {
                _add = "Indy'nin anahtarlarını bul."
            },
            [6] = {
                _add = "Son anahtarı bul."
            }
        },
        [3] = {
            [0] = {
                _add = "Karakola git."
            },
            [2] = {
                _add = "Bankaya git."
            },
            [4] = {
                _add = "Karakola dön."
            },
            [8] = {
                _add = "Karakola git."
            },
            [16] = {
                dialog = "Aferin! Bunda cidden iyisin.\nYoğun bir soruşturmadan sonra enerjini toplayabileceğin bir yer biliyorum: kahve dükkanı!",
                _add = "Sherlock ile konuş."
            },
            [9] = {
                dialog = "Şahane! Bu kumaş suçluyu bulmamızda yardımcı olacak.\nIndy'le konuş. Bize yardım edecektir.",
                _add = "Sherlock ile konuş."
            },
            [5] = {
                dialog = "Bize yardım etmeyeceğini bilmeliydim...\nOnsuz ipucu aramalıyız.\nColt gittiğinde bankaya girmeliyiz, bunu yapabilirsin, değil mi?",
                _add = "Sherlock ile konuş."
            },
            [10] = {
                dialog = "Yani... Soruşturmada yardımıma mı ihtiyacınız var?\nHmm... Şu kumaşa bir bakayım...\nBunu bir yerde görmüştüm. Hastanede kullanılıyor! Oraya bi bak!",
                _add = "Indy ile konuş."
            },
            [11] = {
                _add = "Hastaneye git."
            },
            [3] = {
                dialog = "NE? Sherlock seni buraya mı yolladı? Ona bu olayla ilgilendiğimi söylemiştim.\nOna yardıma ihtiyacım olmadığını söyle. Tek başıma hallederim.",
                _add = "Colt ile konuş."
            },
            [6] = {
                _add = "Soygun esnasında bankaya gir."
            },
            [12] = {
                _add = "Hastanede şüpheli bir şeyler ara."
            },
            [13] = {
                _add = "Madene git."
            },
            name = "Görev 03: Hırsızlık",
            [14] = {
                _add = "Suçluyu bul ve tutukla."
            },
            [1] = {
                dialog = "Selam. Şehirde polis memurlarımızda eksiklik var ve yardımın gerek, ama hiçbir şey zor değildir.\nBankada gizemli bir soygun oldu, Yakınlarda hiç şüpheli bulunmadı...\nBence bankada ipuçları var.\nColt olaylarla ilgili bir şeyler biliyordur. Onunla konuş.",
                _add = "Sherlock ile konuş"
            },
            [7] = {
                _add = "Bankada ipucu ara."
            },
            [15] = {
                _add = "Karakola git."
            }
        },
        [1] = {
            [0] = {
                dialog = "Hey! Naber? Son zamanlarda, bazıları denizin ilerisinde küçük bir ada buldu. Baya ağaç ve yapı var.\nBildiğin gibi, şehirde hiç havaalanı yok. Oraya gitmenin tek yolu tekne ile gitmek.\nSenin için bir tane yapabilirim, ancak biraz yardımın gerek.\nSıradaki maceramda, Madenin diğer tarafında ne olduğunu merak ediyorum. Teorilerim var ama doğrulamam gerek.\nBence uzun bir keşif olacak, Bu yüzden biraz yiyeceğe ihtiyacım var.\nBenim için 5 balık yakalar mısın?",
                _add = "Kane ile konuş"
            },
            [7] = {
                dialog = "Yardımın için teşekkürler! İstediğin ahşap plakalar burada. Onları iyi kullan!",
                _add = "Chrystian ile konuş"
            },
            [1] = {
                _add = "%s balık yakala"
            },
            [2] = {
                dialog = "Vay! Balıklar için teşekkürler! Keşif sırasında onları yemek için sabırsızlanıyorum.\nŞimdi de bana 3 Coca-Cola getirmen gerekiyor. Marketten alabilirsin.",
                _add = "Kane ile konuş"
            },
            [4] = {
                dialog = "Besinlerimi getirdiğin için minettarım! Şimdi iyiliğinin karşılığını verme vakti geldi.\nAma bunun için ahşap plakalara ihtiyacım var ki tekne yapabileyim.\nSon zamanlarda Chrystian'ı ağaç keserken ve odun toplarken gördüm. Ondan ahşap plaka iste.",
                _add = "Kane ile konuş"
            },
            [8] = {
                dialog = "Uzun sürdü... Ahşap plakaları almayı unuttuğunu sandım...\nNeyse, şimdi tekneni yapabilirim...\nİşte teknen! Yeni adada iyi eğlenceler ama dikkatli olmayı da unutma!",
                _add = "Kane ile konuş"
            },
            [5] = {
                dialog = "Ahşap plaka mı istiyorsun? Sana biraz verebilirim, ama bana mısır gevreği getirmen gerek.\nBunu yapabilir misin?",
                _add = "Chrystian ile konuş"
            },
            name = "Görev 01: Tekne yapmak",
            [3] = {
                _add = "%s Coca-Cola al"
            },
            [6] = {
                _add = "Mısır gevreği al"
            }
        },
        [4] = {
            [0] = {
                dialog = "Merhaba! Pizza yemek ister misin?\nAslında... Kötü haberlerim var.\nBugün erkenden pizza yapmaya başladım, ama bütün sosun bittiğini fark ettim.\nMarketten domates almaya çalıştım ama ne yazık ki satmıyorlarmış.\nBu şehirde birkaç hafta önce yaşamaya başladım, ve bana yardım edecek kimseyi tanımıyorum.\nBu yüzden bana yardım eder misin? Pizzacımı açmak için sosa ihtiyacım var.",
                _add = "Kariina ile konuş."
            },
            [2] = {
                _add = "Tohum dükkanına git."
            },
            [4] = {
                _add = "Evine git."
            },
            [8] = {
                _add = "Su kovası satın al."
            },
            [16] = {
                dialog = "Aman Tanrım! Yapmışsın! Çok teşekkürler!\nSen yokken, Hamur yapmak için daha çok buğdaya ihtiyacım olduğunu fark ettim... Biraz buğday getirir misin?",
                _add = "Kariina'ya acı sosu ver."
            },
            [17] = {
                _add = "Evine bir tohum ek."
            },
            [9] = {
                _add = "Markete git."
            },
            [18] = {
                _add = "Buğday hasat et."
            },
            [5] = {
                _add = "Evine bir tohum ek. (Bahçeni kullanman gerekiyor!)"
            },
            [10] = {
                _add = "Tuz satın al."
            },
            [11] = {
                _add = "Sos yap. (Fırını kullanman gerekiyor!)"
            },
            [3] = {
                _add = "Bir tohum satın al."
            },
            [6] = {
                _add = "Domates hasat et."
            },
            [12] = {
                dialog = "Vay! Teşekkürler! Şimdi de sadece acı sosa ihtiyacım var. Bir tane yapar mısın?",
                _add = "Kariina'ya sosu ver."
            },
            [13] = {
                _add = "Evine bir tohum ek."
            },
            name = "Görev 04: Sos bitmiş!",
            [14] = {
                _add = "Biber hasat et"
            },
            [1] = {
                _add = "Adaya git."
            },
            [7] = {
                _add = "Tohum dükkanına git."
            },
            [15] = {
                _add = "Acı sos yap."
            },
            [19] = {
                dialog = "Vay! Teşekkürler! Yeni bir elemana ihtiyacım olduğunda benimle çalışabilirsin.\nYardımın için teşekkürler. Artık şu pizzaları yapabilirim!",
                _add = "Kariina'ya hamuru ver."
            }
        },
        [5] = {
            name = "Görev 03: Hırsızlık",
            [0] = {
                _add = "Karakola git."
            }
        }
    },
    profile_fishes = "Avlanan balık",
    furniture_apiary = "Arı Kovanı",
    item_pickaxe = "Kazma",
    item_crystal_purple = "Mor Kristal",
    passToBag = "Çantaya transfer et",
    item_goldNugget = "Altın",
    permissions_owner = "Sahip",
    permissions_coowner = "İkincil Sahip",
    houseDescription_7 = "Doğanın yakınında uyanmayı sevenler için bir ev!",
    submit = "Gönder",
    furniture_candle = "Mum",
    placeDynamite = "Dinamiti yerleştir",
    error_houseClosed = "%s bu evi kapattı.",
    item_pumpkin = "Balkabağı",
    vehicle_8 = "Devriye Teknesi",
    sale = "Satılık",
    week = "Hafta %s",
    vehicle_9 = "Kızak",
    houseSettings_unlockHouse = "Evi aç",
    itemAmount = "Eşyalar: %s",
    item_pizza = "Pizza",
    item_blueberries = "Yaban mersini",
    furniture_kitchenCabinet = "Mutfak Dolabı",
    houseSettings_finish = "Bitir!",
    frozenLake = "Göl donmuş. Botu kullanabilmek için kışın bitmesini bekle.",
    chooseExpansion = "Bir genişletme seç.",
    experiencePoints = "Deneyim puanları",
    owned = "Sahipli",
    npcDialog_Sebastian = "Hey kanka.\n...\nBen Colt değilim.",
    npcDialog_Heinrich = "Huh... yani madenci mi olmak istiyorsun? Öyleyse çok dikkatli olmalısın. Ben daha küçücük bir fareyken, Bu labirentte kaybolurdum.",
    item_chocolate = "Çikolata",
    furniture_sofa = "Koltuk",
    mouseSizeError = "Bunu yapmak için çok küçüksün.",
    settings = "Ayarlar",
    chooseOption = "Bir seçenek seç",
    closed_buildshop = "İnşaat dükkanı kapalı. Şafak vakti geri gel.",
    item_energyDrink_Mega = "Fanta",
    npcDialog_Derek = "Psst.. Bu gece turnayı gözünden vuruyoruz: Bankayı soyacağız.\nSende katılmak istiyorsan patronumuz Pablo ile konuşmalısın.",
    furniture_pumpkin = "Balkabağı",
    leisure = "Boş",
    item_seed = "Tohum",
    yes = "Evet",
    questsName = "Görevler",
    passwordError = "Minimum 1 harf",
    mine5error = "Maden çöktü.",
    fisher = "Balıkçı",
    waitingForPlayers = "Oyuncular bekleniyor...",
    item_cookies = "Kurabiyeler",
    pickaxeError = "Kazma almak zorundasın.",
    speed_km = "Km/sa",
    confirmButton_Great = "Harika!",
    item_clock = "Saat",
    House2 = "Aile evi",
    alert = "Uyarı!",
    settings_gameHour = "Oyun Saati",
    daveOffers = 'Bugünün teklifleri',
    placedFurnitures = 'Yerleştirilen mobilyalar: %s',
    settings_donateText2 = 'Bağışçılar, bağışlarının onuruna özel NPC\'ye sahip olacaklar. Ama unutma bak, bana Transformice adını yolla ki senin güncel görünüşüne erişebileyim.',
    npcDialog_Bill = 'Hey bak hele! Güncel balıkçılık şansını görmek ister misin?\nHmmm... Bi bakalımm...\n%s şansla sıradan bir balık, %s şansla nadir bir balık ve %s şansla efsanevi bir balık tutabilirsin.\n... Ha ayrıca bir de %s şansla efsanevi balık tutabilirsin!', 
    furniture_nightstand = 'Komodin',
    furniture_bush = 'Çalı',
    furniture_armchair = 'İskemle',
}

--[[ translations/_merge.lua ]]--
for k, v in next, lang do
	if k ~= "en" then
		table.merge(v, lang.en)
	end
end

--[[ translations/_translationSystem.lua ]]--
translate = function(message, name)
	if not players[name] then return '?' end
    local cmm = players[name].lang or 'en'
	if message:sub(1, 3) == 'req' then
		local quest = tonumber(message:sub(5))
		return lang[cmm].quests[quest].name
	end
	if message == '$VersionText' then
		local playerVersion = 'v'..table.concat(version, '.')
		return versionLogs[playerVersion][cmm] and versionLogs[playerVersion][cmm]['_'..players[name].joinMenuPage] or (versionLogs[playerVersion].EN['_'..players[name].joinMenuPage] or message)
	elseif message == '$VersionName' then
		local playerVersion = 'v'..table.concat(version, '.')
		return versionLogs[playerVersion][cmm] and versionLogs[playerVersion][cmm].name or (versionLogs[playerVersion].EN.name or message)
	end
    return lang[cmm][message] and lang[cmm][message] or '$txt_'..message
end

translatedMessage = function(msg, ...)
    for name in next, ROOM.playerList do
        TFM.chatMessage(string.format(translate(msg, name), ...), name)
    end
end

--[[ classes/DataHandler.lua ]]--
-- DataHandler, made by Laagaadoo#0000
local DataHandler = {}
do
	DataHandler.VERSION = '1.5'
	DataHandler.__index = DataHandler

	function DataHandler.new(moduleID, skeleton, otherOptions)
		local self = setmetatable({}, DataHandler)
		assert(moduleID, 'Invalid module ID (nil)')
		assert(moduleID ~= '', 'Invalid module ID (empty text)')
		assert(skeleton, 'Invalid skeleton (nil)')

		for k, v in next, skeleton do
			v.type = v.type or type(v.default())
		end

		self.players = {}
		self.moduleID = moduleID
		self.moduleSkeleton = skeleton
		self.moduleIndexes = {}
		self.otherOptions = otherOptions
		self.otherData = {}
		self.originalStuff = {}

		for k, v in next, skeleton do
			self.moduleIndexes[v.index] = k
		end

		if self.otherOptions then
			self.otherModuleIndexes = {}
			for k, v in next, self.otherOptions do
				self.otherModuleIndexes[k] = {}
				for k2, v2 in next, v do
					v2.type = v2.type or type(v2.default())
					self.otherModuleIndexes[k][v2.index] = k2
				end
			end
		end

		return self
	end

	function DataHandler.newPlayer(self, name, dataString)
		assert(name, 'Invalid player name (nil)')
		assert(name ~= '', 'Invalid player name (empty text)')

		self.players[name] = {}
		self.otherData[name] = {}

		dataString = dataString or ''

		-- turns a simple table into a string
		local function turnStringToTable(str)
			local output = {}
			for data in gsub(str, '%b{}', function(b) return b:gsub(',', '\0') end):gmatch('[^,]+') do
				data = data:gsub('%z', ',')

				if string.match(data, '^{.-}$') then
					output[#output+1] = turnStringToTable(string.match(data, '^{(.-)}$'))
				else
					output[#output+1] = tonumber(data) or data
				end
			end
			return output
		end

		-- get the field index
		local function getDataIndexName(skeleton, index)
			for k, v in next, skeleton do
				if v.index == index then
					return k
				end
			end
			return 0
		end

		-- gets the higher index
		local function getHigherIndex(skeleton)
			local higher = 0
			for k, v in next, skeleton do
				if v.index > higher then
					higher = v.index
				end
			end
			return higher
		end

		-- creates the fields in the player's table
		-- loads the other modules' data too
		local function handleModuleData(moduleID, skeleton, moduleData, makeTable)
			local dataIndex = 1
			local higherIndex = getHigherIndex(skeleton)

			moduleID = "__" .. moduleID
			if makeTable then
				self.players[name][moduleID] = {}
			end

			local function setPlayerData(data, dataType, dataName, dataDefault)
				local value
				if dataType == "number" then
					value = tonumber(data) or dataDefault
				elseif dataType == "string" then
					-- unescape double quotes
					value = string.match(data and data:gsub('\\"', '"') or '', "^\"(.-)\"$") or dataDefault
				elseif dataType == "table" then
					value = string.match(data or '', "^{(.-)}$")
					value = value and turnStringToTable(value) or dataDefault
				elseif dataType == "boolean" then
					if data then
						value = data == '1'
					else
						value = dataDefault
					end
				end

				if makeTable then
					self.players[name][moduleID][dataName] = value
				else
					self.players[name][dataName] = value
				end
			end

			if #moduleData > 0 then
				for data in gsub(moduleData, '%b{}', function(b) return b:gsub(',', '\0') end):gmatch('[^,]+') do
				-- for data in gsub(moduleData, '({.*()})', function(b) return b:gsub(',', '\0') end):gmatch('[^,]+') do
					data = data:gsub('%z', ','):gsub('\9', ',')

					-- pega info a respeito do esqueleto
					local dataName = getDataIndexName(skeleton, dataIndex)
					local dataType = skeleton[dataName].type
					local dataDefault = skeleton[dataName].default()

					setPlayerData(data, dataType, dataName, dataDefault)

					dataIndex = dataIndex + 1
				end
			end

			-- fields are missing, will set them to default
			if dataIndex <= higherIndex then
				for i = dataIndex, higherIndex do
					local dataName = getDataIndexName(skeleton, i)
					local dataType = skeleton[dataName].type
					local dataDefault = skeleton[dataName].default()

					setPlayerData(nil, dataType, dataName, dataDefault)
				end
			end
		end

		local modules, originalStuff = self:getModuleData(dataString)
		-- keeps other unrelated stuff
		self.originalStuff[name] = originalStuff

		if not modules[self.moduleID] then
			modules[self.moduleID] = '{}'
		end

		handleModuleData(self.moduleID, self.moduleSkeleton, modules[self.moduleID]:sub(2,-2), false)

		if self.otherOptions then
			-- if the player does not have the other modules' data and we need them
			-- then creates the data using the default values provided
			for moduleID, skeleton in next, self.otherOptions do
				if not modules[moduleID] then
					local strBuilder = {}
					for k, v in next, skeleton do
						local dataType = v.type or type(v.default())
						if dataType == 'string' then
							strBuilder[v.index] = '"'..tostring(v.default():gsub('"', '\\"'))..'"'
						elseif dataType == 'table' then
							strBuilder[v.index] = '{}'
						elseif dataType == 'number' then
							strBuilder[v.index] = v.default()
						elseif dataType == 'boolean' then
							strBuilder[v.index] = v.default() and '1' or '0'
						end
					end
					modules[moduleID] = '{'..table.concat(strBuilder, ',')..'}'
				end
			end
		end

		-- loads the player's data from other modules
		for moduleID, moduleData in next, modules do
			if moduleID ~= self.moduleID then
				if self.otherOptions and self.otherOptions[moduleID] then
					handleModuleData(moduleID, self.otherOptions[moduleID], moduleData:sub(2,-2), true)
				else
					self.otherData[name][moduleID] = moduleData
				end
			end
		end
	end

	function DataHandler.dumpPlayer(self, name)
		-- dumps player data to string
		local output = {}

		-- turns a simple table into a string
		local function turnTableToString(tbl)
			local output = {}
			for k, v in next, tbl do
				local valueType = type(v)
				if valueType == 'table' then
					output[#output+1] = '{'
					output[#output+1] = turnTableToString(v)

					if output[#output]:sub(-1) == ',' then
						output[#output] = output[#output]:sub(1, -2)
					end
					output[#output+1] = '}'
					output[#output+1] = ','
				else
					if valueType == 'string' then
						output[#output+1] = '"'
						output[#output+1] = v:gsub('"', '\\"')
						output[#output+1] = '"'
					elseif valueType == 'boolean' then
						output[#output+1] = v and '1' or '0'
					else
						output[#output+1] = v
					end
					output[#output+1] = ','
				end
			end
			if output[#output] == ',' then
				output[#output] = ''
			end
			return table.concat(output)
		end

		-- returns a module's data in string
		local function getPlayerDataFrom(name, moduleID)
			local output = {moduleID, '=', '{'}
			local player = self.players[name]
			local moduleIndexes = self.moduleIndexes
			local moduleSkeleton = self.moduleSkeleton

			if self.moduleID ~= moduleID then
				moduleIndexes = self.otherModuleIndexes[moduleID]
				moduleSkeleton = self.otherOptions[moduleID]
				moduleID = '__'..moduleID
				player = self.players[name][moduleID]
			end

			if not player then
				return ''
			end

			for i = 1, #moduleIndexes do
				local dataName = moduleIndexes[i]
				local dataType = moduleSkeleton[dataName].type
				if dataType == 'string' then
					-- inserts "string" with escaped double quotes
					output[#output+1] = '"'
					output[#output+1] = player[dataName]:gsub('"', '\\"')
					output[#output+1] = '"'

				elseif dataType == 'number' then
					-- inserts number
					output[#output+1] = player[dataName]

				elseif dataType == 'boolean' then
					output[#output+1] = player[dataName] and '1' or '0'

				elseif dataType == 'table' then
					-- inserts table
					output[#output+1] = '{'
					output[#output+1] = turnTableToString(player[dataName])
					output[#output+1] = '}'
				end

				output[#output+1] = ','
			end

			if output[#output] == ',' then
				output[#output] = '}'
			else
				output[#output+1] = '}'
			end

			return table.concat(output)
		end

		output[#output+1] = getPlayerDataFrom(name, self.moduleID)

		-- builds the output
		if self.otherOptions then
			for k, v in next, self.otherOptions do
				local moduleData = getPlayerDataFrom(name, k)
				if moduleData ~= '' then
					output[#output+1] = ','
					output[#output+1] = moduleData
				end
			end
		end

		for k, v in next, self.otherData[name] do
			output[#output+1] = ','
			output[#output+1] = k
			output[#output+1] = '='
			output[#output+1] = v
		end

		return table.concat(output)..self.originalStuff[name]
	end

	function DataHandler.get(self, name, dataName, moduleName)
		-- returns some player data
		if not moduleName then
			return self.players[name][dataName]
		else
			assert(self.players[name]['__'..moduleName], 'Module data not available ('..moduleName..')')
			return self.players[name]['__'..moduleName][dataName]
		end
	end

	function DataHandler.set(self, name, dataName, value, moduleName)
		-- sets some player data

		if moduleName then
			self.players[name]['__'..moduleName][dataName] = value
		else
			self.players[name][dataName] = value
		end

		return self
	end

	function DataHandler.save(self, name)
		system.savePlayerData(name, self:dumpPlayer(name))
	end

	-- gets the module data and stores it
	function DataHandler.getModuleData(self, str)
		local output = {}

		for moduleID, moduleData in string.gmatch(str, '([0-9A-Za-z_]+)=(%b{})') do
			local texts = self:getTextBetweenQuotes(moduleData:sub(2,-2))
			for i = 1, #texts do
				texts[i] = texts[i]:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")
				moduleData = moduleData:gsub(texts[i], texts[i]:gsub(',', '\9'))
			end
			output[moduleID] = moduleData
		end

		for k, v in next, output do
			str = str:gsub(k..'='..v:gsub('\9', ','):gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")..',?', '')
		end
		return output, str
	end

	-- get the text between double quotes
	function DataHandler.getTextBetweenQuotes(self, str)
		local output = {}
		local startIndex = 1
		local symbols = 0

		local ignore = false
		for i = 1, #str do
			local char = str:sub(i, i)

			if char == '"' then
				if str:sub(i-1,i-1) ~= '\\' then
					if symbols == 0 then
						startIndex = i
						symbols = symbols + 1
					else
						symbols = symbols - 1
						if symbols == 0 then
							output[#output+1] = str:sub(startIndex, i)
						end
					end
				end
			end
		end
		return output
	end
end

--[[ classes/EventHandler.lua ]]--
-- EventHandler, made by Tocutoeltuco#0000
local runtime = 0
local onEvent
do
	local os_time = os.time
	local math_floor = math.floor
	local runtime_check = 0
	local events = {}
	local scheduled = {_count = 0, _pointer = 1}
	local paused = false
	local runtime_threshold = 40
	local _paused = false
	local lastErrorLog = ''

	local function runScheduledEvents()
		local count, pointer = scheduled._count, scheduled._pointer

		local data
		while pointer <= count do
			data = scheduled[pointer]
			-- An event can have up to 5 arguments. In this case, this is faster than table.unpack.
			data[1](data[2], data[3], data[4], data[5], data[6])
			pointer = pointer + 1

			if runtime >= runtime_threshold then
				scheduled._count = count
				scheduled._pointer = pointer
				return false
			end
		end
		scheduled._pointer = pointer
		return true
	end

	local function emergencyShutdown(limit_players)
		if limit_players then
			translatedMessage("emergencyMode_able")
			TFM.setRoomMaxPlayers(1)
		end
		room.requiredPlayers = 1000
		genLobby()

		for _, event in next, events do
			event._count = 0
		end
	end

	function onEvent(name, callback)
		local evt
		if events[name] then
			evt = events[name]
		else
			evt = {_count = 0}
			events[name] = evt

			-- An event can have up to 5 arguments. In this case, this is faster than `...`
			local function caller(when, a, b, c, d, e)
				for index = 1, evt._count do
					evt[index](a, b, c, d, e)

					if os_time() >= when then
						break
					end
				end
			end
			local allowedSchedules = {'PlayerDataLoaded', 'PlayerRespawn', 'PlayerLeft'}
			local schedule = table.contains(allowedSchedules, name)
			local done, result
			local event_fnc
			event_fnc = function(a, b, c, d, e)
				local start = os_time()
				local this_check = math_floor(start / 4000)
				if runtime_check < this_check then
					runtime_check = this_check
					runtime = 0
					paused = false

					if not runScheduledEvents() then
						runtime_check = this_check + 1
						paused = true
						return
					end

					if _paused then
						message = translatedMessage("emergencyMode_resume")
						_paused = false
						TFM.setRoomMaxPlayers(room.maxPlayers)
						for player in next, ROOM.playerList do
							freezePlayer(player, false)
						end
					end
				elseif paused then
					if schedule then
						scheduled._count = scheduled._count + 1
						scheduled[scheduled._count] = {event_fnc, a, b, c, d, e}
					end
					return
				end

				done, result = pcall(caller, start + runtime_threshold - runtime, a, b, c, d, e)
				if not done and lastErrorLog ~= result then
					TFM.chatMessage(result)
					lastErrorLog = result
					--return emergencyShutdown(true)
				end

				runtime = runtime + (os_time() - start)

				if runtime >= runtime_threshold then
					if not _paused then
						if room.dayCounter > 0 then
							translatedMessage("emergencyMode_pause")
						else
							translatedMessage("syncingGame")
						end
						TFM.setRoomMaxPlayers(1)
						for player in next, ROOM.playerList do
							freezePlayer(player, true)
						end
					end

					runtime_check = this_check + 1
					paused = true
					_paused = true
					scheduled._count = 0
					scheduled._pointer = 1
				end
			end

			_G["event" .. name] = event_fnc
		end

		evt._count = evt._count + 1
		evt[evt._count] = callback
	end
end

--[[ classes/Timers.lua ]]--
-- Timers, made by Laagaadoo#0000
local List = {}
local timerList = {}
local timersPool
do
	function List.new ()
		return {first = 0, last = -1}
	end
	timersPool = List.new()
	function List.pushleft (list, value)
		local first = list.first - 1
		list.first = first
		list[first] = value
	end

	function List.pushright (list, value)
		local last = list.last + 1
		list.last = last
		list[last] = value
	end

	function List.popleft (list)
		local first = list.first
		if first > list.last then
			return nil
		end
		local value = list[first]
		list[first] = nil        -- to allow garbage collection
		list.first = first + 1
		return value
	end

	function List.popright (list)
		local last = list.last
		if list.first > last then
			return nil
		end
		local value = list[last]
		list[last] = nil         -- to allow garbage collection
		list.last = last - 1
		return value
	end
	function addTimer(callback, ms, loops, label, ...)
		local id = List.popleft(timersPool)
		if id then
			local timer = timerList[id]
			timer.callback = callback
			timer.label = label
			timer.arguments = {...}
			timer.time = ms
			timer.currentTime = 0
			timer.currentLoop = 0
			timer.loops = loops or 1
			timer.isComplete = false
			timer.isPaused = false
			timer.isEnabled = true
		else
			id = #timerList+1
			timerList[id] = {
				callback = callback,
				label = label,
				arguments = {...},
				time = ms,
				currentTime = 0,
				currentLoop = 0,
				loops = loops or 1,
				isComplete = false,
				isPaused = false,
				isEnabled = true,
			}
		end
		return id
	end

	function getTimerId(label)
		local found
		for id = 1, #timerList do
			local timer = timerList[id]
			if timer.label == label then
				found = id
				break
			end
		end
		return found
	end

	function pauseTimer(id)
		if type(id) == 'string' then
			id = getTimerId(id)
		end

		if timerList[id] and timerList[id].isEnabled then
			timerList[id].isPaused = true
			return true
		end
		return false
	end

	function resumeTimer(id)
		if type(id) == 'string' then
			id = getTimerId(id)
		end

		if timerList[id] and timerList[id].isPaused then
			timerList[id].isPaused = false
			return true
		end
		return false
	end

	function removeTimer(id)
		if type(id) == 'string' then
			id = getTimerId(id)
		end

		if timerList[id] and timerList[id].isEnabled then
			timerList[id].isEnabled = false
			List.pushright(timersPool, id)
			return true
		end
		return false
	end
	function clearTimers()
		local timer
		repeat
			timer = List.popleft(timersPool)
			if timer then
				table.remove(timerList, timer)
			end
		until timer == nil
	end
	function timersLoop()
		for id = 1, #timerList do
			local timer = timerList[id]
			if timer.isEnabled and timer.isPaused == false then
				if not timer.isComplete then
					timer.currentTime = timer.currentTime + 500
					if timer.currentTime >= timer.time then
						timer.currentTime = 0
						timer.currentLoop = timer.currentLoop + 1
						if timer.loops > 0 then
							if timer.currentLoop >= timer.loops then
								timer.isComplete = true
								removeTimer(id)
							end
						end
						if timer.callback ~= nil then
							timer.callback(timer.currentLoop, table.unpack(timer.arguments))
						end
					end
				end
			end
		end
	end
end

--[[ classes/SystemLooping.lua ]]--
-- system.looping, made by Bolodefchoco#0000
system.looping = function(f, ticks, ...)
    local timers, index = { }, 0
    local addTimer = function(_, ...)
        index = index + 1
        timers[index] = system.newTimer(f, 1000, true, ...)
    end

    local seconds = 1000 / ticks
    for timer = 0, 1000 - seconds, seconds do
        system.newTimer(addTimer, 1000 + timer, false, ...)
    end

    return timers
end

--[[ checkTimers.lua ]]--
local workingTimerState = {
    stop = -1,
    start = 0,
    tryLimit = 2,
    setBroken = 3,
    setVerified = 4,
    broken = 5
}
local workingTimer = workingTimerState.start
do
	checkWorkingTimer = function()
	    if workingTimer == workingTimerState.broken then
	        updateDialogs(10) -- Function used in timers is now used in eventLoop
	    elseif workingTimer > workingTimerState.tryLimit then
	        if workingTimer == workingTimerState.setBroken then
	            workingTimer = workingTimerState.broken
	            print('<rose>[Warning]</rose> Timers are not working.')
	            TFM.chatMessage('<rose>[Warning]</rose> Timers are not working.', 'Fofinhoppp#0000')
	        elseif workingTimer == workingTimerState.setVerified then
	            workingTimer = workingTimerState.stop
	        end
	        -- Chunk below executes once, verification finished
	    elseif workingTimer > workingTimerState.stop then
	        if workingTimer < workingTimerState.tryLimit then
	            workingTimer = workingTimer + 0.5
	            if workingTimer == workingTimerState.tryLimit then
	                workingTimer = workingTimerState.setBroken
	            end
	        end
	    end
	end
	system.newTimer(function()
	    workingTimer = workingTimerState.setVerified
	end, 1000, false)
end

--[[ houseSystem/_new.lua ]]--
HouseSystem = { }
HouseSystem.__index = HouseSystem

HouseSystem.new = function(player)
	local self = {
		y = 1590,
		houseOwner = player,
	}
	return setmetatable(self, HouseSystem)
end

--[[ houseSystem/genHouseFace.lua ]]--
HouseSystem.genHouseFace = function(self, guest)
	local ownerData = players[self.houseOwner]
	local terrainID = ownerData.houseData.houseid
	local houseType = ownerData.houseData.currentHouse
	local complement = self.houseOwner:match('#0000') and self.houseOwner:gmatch('(.-)#[0-9]+$')() or self.houseOwner:gsub('#', '<font size="7"><g>#')

	local y = self.y
	if not guest then
		player_removeImages(room.houseImgs[terrainID].img)
	end
	room.houseImgs[terrainID].img[#room.houseImgs[terrainID].img+1] = addImage(mainAssets.__houses[houseType].outside.icon, "?100"..terrainID, mainAssets.__terrainsPositions[terrainID][1] + mainAssets.__houses[houseType].outside.axis[1], mainAssets.__terrainsPositions[terrainID][2]+60 + mainAssets.__houses[houseType].outside.axis[2], guest)
	room.houseImgs[terrainID].img[#room.houseImgs[terrainID].img+1] = addImage('17272033fc9.png', "_600"..terrainID, mainAssets.__terrainsPositions[terrainID][1], mainAssets.__terrainsPositions[terrainID][2]+176, guest)

	ui.addTextArea(44 + terrainID, '<p align="center"><font size="12"><a href="event:joinHouse_'..terrainID..'">'..complement..'\n', guest, mainAssets.__terrainsPositions[terrainID][1], mainAssets.__terrainsPositions[terrainID][2]+176+23, 150, nil, 0x1, 0x1, 0)
	ui.addTextArea(terrainID, '<p align="center">' .. terrainID, guest, mainAssets.__terrainsPositions[terrainID][1], mainAssets.__terrainsPositions[terrainID][2]+176+11, 150, nil, 0, 0)
	room.houseImgs[terrainID].img[#room.houseImgs[terrainID].img+1] = addImage(mainAssets.__houses[houseType].inside.image, "?100", (terrainID-1)*1500 + 60, 847, guest)
	room.houseImgs[terrainID].img[#room.houseImgs[terrainID].img+1] = addImage('17256286356.jpg', '?901', (terrainID-1)*1500 + 317, 1616, guest) -- door
	room.houseImgs[terrainID].img[#room.houseImgs[terrainID].img+1] = addImage('1725d43cb08.png', '_9020', (terrainID-1)*1500 + 317, 1616, guest) -- handle

	for i, v in next, ownerData.houseData.furnitures.placed do 
		local x = v.x + (terrainID-1)*1500
		local y = v.y + 1000
		room.houseImgs[terrainID].furnitures[#room.houseImgs[terrainID].furnitures+1] = addImage(mainAssets.__furnitures[v.type].image, '?1000'..i, x, y, guest)
		local furniture = mainAssets.__furnitures[v.type]
		if furniture.grounds then
			furniture.grounds(x,  y, - 7000 - (terrainID-1)*200 - i)
		end
		if furniture.usable then
			if not guest then
				ui.addTextArea(- 85000 - (terrainID*200 + i), "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', mainAssets.__furnitures[v.type].area[2]/8), self.houseOwner, x, y, mainAssets.__furnitures[v.type].area[1], mainAssets.__furnitures[v.type].area[2], 1, 0xfff000, 0, false, 
					function(player)
						furniture.usable(player)
					end)
				if furniture.name == 'chest' then 
					players[self.houseOwner].houseData.chests.position[1] = {x = x, y = y}
				end
			end
		end
	end
	for i, v in next, ownerData.houseTerrain do
		if v == 2 then
			if ownerData.houseTerrainAdd[i] > 1 then
				room.gardens[#room.gardens+1] = {owner = self.houseOwner, timer = os.time(), terrain = i, idx = terrainID, plant = ownerData.houseTerrainPlants[i]}
			end
		end
	end

	if mainAssets.__houses[houseType].inside.grounds then 
		mainAssets.__houses[houseType].inside.grounds(terrainID)
	end
	return setmetatable(self, HouseSystem)
end

--[[ houseSystem/genHouseGrounds.lua ]]--
HouseSystem.genHouseGrounds = function(self, guest)
	local ownerData = players[self.houseOwner]
	local houseType = ownerData.houseData.currentHouse
	local terrainID = ownerData.houseData.houseid
	local y = self.y
	if not guest then 
		player_removeImages(room.houseImgs[terrainID].expansions)
	end
	for i = 1, 4 do
		houseTerrains[ownerData.houseTerrain[i]].add(self.houseOwner, 1590, terrainID, i, guest)
	end
	return setmetatable(self, HouseSystem)
end

--[[ houseSystem/loadTerrains.lua ]]--
HouseSystem.loadTerrains = function(self)
	local name = self.houseOwner
	local nameData = players[name]
	if room.terrains[1] then
		for i = 1, #mainAssets.__terrainsPositions do
			if not room.terrains[i].bought then
				room.houseImgs[i].img[#room.houseImgs[i].img+1] = addImage('1708781ad73.png', "?"..i+100, mainAssets.__terrainsPositions[i][1], mainAssets.__terrainsPositions[i][2], name)
				ui.addTextArea(44 +  i, '<a href="event:buyhouse_'..i..'"><font color="#fffffff">' .. translate('sale', name), name, mainAssets.__terrainsPositions[i][1]+40, mainAssets.__terrainsPositions[i][2]+114, nil, nil, 0xFF0000, 0xFF0000, 0)
			else
				self.houseOwner = room.terrains[i].owner
				room.terrains[i].groundsLoadedTo[name] = false
				HouseSystem.genHouseFace(self, name)
			end
		end
	end
	return setmetatable(self, HouseSystem)
end

--[[ houseSystem/removeHouse.lua ]]--
HouseSystem.removeHouse = function(self)
	local ownerData = players[self.houseOwner]
	if ownerData.houseData.houseid > 0 then
		local terrainID = ownerData.houseData.houseid
		for i = 1, 4 do
			ui.removeTextArea('-730'..i..(ownerData.houseData.houseid*10))
			removeGround(- 2000 - (terrainID-1)*30 - i)
		end
		ownerData.houseData.houseid = -10
		ownerData.houseData.currentHouse = nil
		player_removeImages(room.houseImgs[terrainID].expansions)
		player_removeImages(room.houseImgs[terrainID].furnitures)
		player_removeImages(room.houseImgs[terrainID].img)
		for i = 0, 15 do
			removeGround(-6500+terrainID*20-i)
		end
		for i, v in next, ownerData.houseData.furnitures.placed do 
			local furniture = mainAssets.__furnitures[v.type]
			if furniture.grounds then
				TFM.removePhysicObject(- 7000 - (terrainID-1)*200 - i)
			end
		end
		room.houseImgs[terrainID].img[#room.houseImgs[terrainID].img+1] = addImage('1708781ad73.png', "?" .. terrainID + 100, mainAssets.__terrainsPositions[terrainID][1], mainAssets.__terrainsPositions[terrainID][2])
		for name in next, ROOM.playerList do
			ui.addTextArea(terrainID + 44, "<a href='event:buyhouse_" .. terrainID .. "'><font color='#ffffff'>" .. translate("sale", name), name, mainAssets.__terrainsPositions[terrainID][1]+40, mainAssets.__terrainsPositions[terrainID][2]+114, nil, nil, 0xFF0000, 0xFF0000, 0)
		end
		for guest in next, room.terrains[terrainID].guests do
			if room.terrains[terrainID].guests[guest] then 
				getOutHouse(guest, terrainID)
			end
		end
		ui.removeTextArea(terrainID)
		room.terrains[terrainID] = {img = {}, bought = false, owner = nil, settings = {}, groundsLoadedTo = {}, guests = {}}
	end
	return setmetatable(self, HouseSystem)
end

--[[ houseSystem/gardening.lua ]]--
gardening = function()
	for i, v in ipairs(room.gardens) do
		if players[v.owner].houseTerrainAdd[v.terrain] < #houseTerrainsAdd.plants[players[v.owner].houseTerrainPlants[v.terrain]].stages then
			if os.time() - v.timer >= houseTerrainsAdd.plants[players[v.owner].houseTerrainPlants[v.terrain]].growingTime*1000 then
				players[v.owner].houseTerrainAdd[v.terrain] = players[v.owner].houseTerrainAdd[v.terrain]+1
				v.timer = os.time()
				HouseSystem.new(v.owner):genHouseGrounds()
				savedata(v.owner)
			end
		else
			local y = 1500 + 90
			if v.owner ~= 'Oliver' then
				ui.addTextArea('-730'..(tonumber(v.terrain)..tonumber(players[v.owner].houseData.houseid)*10), '<a href="event:harvest_'..tonumber(v.terrain)..'"><p align="center"><font size="15">'..translate('harvest', v.owner)..'</font></p></a>', v.owner, ((tonumber(v.idx)-1)%tonumber(v.idx))*1500+738-(175/2)-2 + (tonumber(v.terrain)-1)*175, y+150, 175, 150, 0xff0000, 0xff0000, 0)
			else
				for ii, vv in next, ROOM.playerList do
					if players[ii].job == 'farmer' then
						ui.addTextArea('-730'..(tonumber(v.terrain)..tonumber(players[v.owner].houseData.houseid)*10), '<a href="event:harvest_'..tonumber(v.terrain)..'"><p align="center"><font size="15">'..translate('harvest', ii)..'</font></p></a>', ii, ((tonumber(v.idx)-1)%tonumber(v.idx))*1500+738-(175/2)-2 + (tonumber(v.terrain)-1)*175, y+150, 175, 150, 0xff0000, 0xff0000, 0)
					end
				end
			end
			savedata(v.owner)
			table.remove(room.gardens, i)
		end
	end
end

--[[ interfaces/modernUI/modernUI.lua ]]--
modernUI = {}
modernUI.__index = modernUI

do
  	modernUI.new = function(player, width, height, title, text, errorUI)
  		local playerData = players[player]
  		if not playerData then return end
 		local self = {
	    	id = 10 + playerData._modernUIOpenedTabs,
	    	player = player,
			width = width and width or 200, 
	      	height = height and height or 150,
	      	buttons = {},
	      	title = title, 
	      	text = text,
	      	errorUI = errorUI and errorUI or '',
	    }
	    if type(errorUI) == 'boolean' then return end
	    local id = self.id
	    local images = playerData._modernUIImages
	    if images[id] then 
			for i = 1, #images[id] do 
				removeImage(images[id][i])
			end
	   	end
		players[player]._modernUIHistory[id] = {}
		players[player]._modernUIImages[id] = {}
		players[player]._modernUIOpenedTabs = playerData._modernUIOpenedTabs + 1
	    return setmetatable(self, modernUI)
  	end
  	modernUI.addButton = function(self, image, toggleEvent, ...)
  		local player = self.player
  		self.buttons[#self.buttons+1] = {image = image}
  		players[player]._modernUIHistory[self.id][#self.buttons] = {toggleEvent = toggleEvent, args = ..., warningUI = true}
  		return setmetatable(self, modernUI)
  	end
  	modernUI.build = function(self)
  		local id = self.id
  		local player = self.player
		local width = self.width 
		local height = self.height
		local x = (400 - width/2) - 10
		local y = (200 - height/2)

		local totalButtons = #self.buttons
		local buttonAlign = totalButtons > 0 and totalButtons*25 - 10 or 0
		
		local backgrounds = {
			[200] = {
				[200] = '1729faa10a0.png',
			},
			[240] = {
				[120] = '171d2a2e21a.png',
				[170] = '1729fb0cb0f.png',
				[180] = '1729fae409e.png',
				[220] = '171d28150ea.png',
			},
			[310] = {
				[280] = '171d6f313c8.png',
			},
			[380] = {
				[280] = '17290d6d18e.png',
			},
			[520] = {
				[300] = '171dbed9f91.png',
			},
		}
		local _UI = backgrounds[width][height]
		local backgroundImage = _UI and _UI or error('Invalid modernUI size.')
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(backgroundImage, ":10", x+10, y, player)

		ui.addTextArea(id..'876', '', player, 5 - width/2, 0, 400, 400, 0x152d30, 0x152d30, 0, true) ui.addTextArea(id..'877', '', player, 395 + width/2, 0, 400, 400, 0x152d30, 0x152d30, 0, true) ui.addTextArea(id..'878', '', player, 0, 6 - height/2, 800, 200, 0x152d30, 0x152d30, 0, true) ui.addTextArea(id..'879', '', player, 0, 194 + height/2, 800, 200, 0x152d30, 0x152d30, 0, true)

		local function createButton(id)
			local button = self.buttons[id]
			players[player]._modernUIImages[self.id][#players[player]._modernUIImages[self.id]+1] = addImage(button.image, ":"..(100+id), (x+width)-23 - id*24, y+10, player)
			ui.addTextArea(self.id..(896+id), "<textformat leftmargin='1' rightmargin='1'><a href='event:modernUI_ButtonAction_"..self.id.."_"..id.."'>\n\n", player, (x+width)-23 - id*24 , y+10, 25, 25, 0xff0000, 0xff0000, 0, true)
		end
		if self.title then 
			ui.addTextArea(id..'880', '', player, x+26, y+16, width-55 + (totalButtons * -25), 30, 0x152d30, 0x152d30, 1, true)
			ui.addTextArea(id..'881', '<p align="center"><font color="#caed87" size="15"><b>'..self.title, player, x+25, y+13, width-30, 30, 0x152d30, 0x152d3, 0, true)
		end
		if self.text then
			ui.addTextArea(id..'882', '<font color="#ebddc3" size="13">'..self.text, player, x+25, y+47, width-30, height-65, 0x152d30, 0x152d30, 1, true)
		end
		ui.addTextArea(id..'896', "<textformat leftmargin='1' rightmargin='1'><a href='event:modernUI_Close_"..id.."_"..self.errorUI.."'>\n\n", player, (x+width)-23, y+10, 25, 25, 0xff0000, 0xff0000, 0, true)

		for i = 1, totalButtons do 
			createButton(i)
		end
		return setmetatable(self, modernUI)
	end
	modernUI.addConfirmButton = function(self, toggleEvent, buttonText, ...)
		local id = self.id
  		local player = self.player
  		local width = ... and (type(...) == 'number' and ... or 100) or 100
		local height = 15
		local x = (400 - width/2)
		local y = (200 - height/2) + self.height/2 - 30

		ui.addTextArea(id..'930', '', player, x-1, y-1, width, height, 0x95d44d, 0x95d44d, 1, true)
		ui.addTextArea(id..'931', '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
		ui.addTextArea(id..'932', '', player, x, y, width, height, 0x44662c, 0x44662c, 1, true)
		ui.addTextArea(id..'933', '<p align="center"><font color="#cef1c3" size="13"><a href="event:modernUI_ButtonAction_'..self.id..'_'..(#self.buttons+1)..'">'..buttonText..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true)

  		players[player]._modernUIHistory[id][#self.buttons+1] = {toggleEvent = toggleEvent, args = ...}
  		return setmetatable(self, modernUI)
  	end
end

--[[ interfaces/modernUI/interfaces.lua ]]--
modernUI.shopInterface = function(self, itemList)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) - 12
	local y = (200 - height/2)

	for i = 1, #itemList do 
		local item = bagItems[itemList[i]]
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage("1717eaef706.png", ":20", 288, y+65 + (i-1)*45, player) -- Background
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(item.png, ":21", 310, y+60 + (i-1)*45, player) -- Item Image
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage("1717ed9210a.png", ":22", 353, y+90 + (i-1)*45, player) -- Hunger Icon
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage("1717edcf98f.png", ":23", 353, y+80 + (i-1)*45, player) -- Energy Icon
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage("1717ee908e4.png", ":24", 430, y+85 + (i-1)*45, player) -- Coins Bar

		ui.addTextArea(id..(900+(i-1)*5), string.format(translate('item_'..itemList[i], player).."\n<textformat leading='-2'><font size='10'><v>&nbsp;&nbsp;&nbsp;%s\n&nbsp;&nbsp;&nbsp;%s", item.power and item.power or 0, item.hunger and item.hunger or 0), player, 352, y+65 + (i-1)*45, nil, nil, 0xff0000, 0xff0000, 0, true)
		ui.addTextArea(id..(901+(i-1)*5), '<b><p align="center"><font color="#54391e">$'..item.price, player, 430, y+86 + (i-1)*45, 50, nil, 0xff0000, 0xff0000, 0, true)

	end
	return setmetatable(self, modernUI)
end
modernUI.tradeInterface = function(self)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) - 12
	local y = (200 - height/2)

	for i = 1, 3 do 
		math.randomseed(room.mathSeed * i^2)
		local offerID = math.random(1, #mainAssets.__farmOffers)
		local offer = mainAssets.__farmOffers[offerID]

		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage("1717eaef706.png", ":20", 288, y+65 + (i-1)*45, player) -- Background

		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('1717f0a6947.png', ":21",	315, y+66 + (i-1)*45, player) -- Item background1
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(bagItems[offer.requires[1]].png, ":22",	310, y+60 + (i-1)*45, player) -- Required Item Image

		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171830fd281.png', ":25",	377, y+70 + (i-1)*45, player) -- Arrow

		ui.addTextArea(id..(900+(i-1)*3), '<p align="right"><b><font size="9"><j>x<font size="12"><vp>'..offer.item[2], player, 447, y+86 + (i-1)*45, 30, nil, 0xff0000, 0xff0000, 0, true)

		if checkItemQuanty(offer.requires[1], offer.requires[2], player) then
			ui.addTextArea(id..(901+(i-1)*3), '<p align="right"><b><font size="9"><j>x<font size="12"><vp>'..offer.requires[2], player, 322, y+86 + (i-1)*45, 30, nil, 0xff0000, 0xff0000, 0, true)
			ui.addTextArea(id..(902+(i-1)*3), "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', 5), player, 320, y+65 + (i-1)*45, 155, 40, 0xff0000, 0xff0000, 0, true,
				function()
					if not checkItemQuanty(offer.requires[1], offer.requires[2], player) then return end
					removeBagItem(offer.requires[1], offer.requires[2], player)
					addItem(offer.item[1], offer.item[2], player)
					TFM.chatMessage('<j>'..translate('transferedItem', player):format('<vp>'..translate('item_'..offer.item[1], player)..' <fc>('..offer.item[2]..')</fc></vp>'), player)
					eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
				end)
		else
			ui.addTextArea(id..(901+(i-1)*3), '<p align="right"><b><font size="9"><j>x<font size="12"><r>'..offer.requires[2], player, 322, y+86 + (i-1)*45, 30, nil, 0xff0000, 0xff0000, 0, true)
			players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage("1717eaef706.png", ":30", 288, y+65 + (i-1)*45, player)
		end
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('1717f0a6947.png', ":23",	440, y+66 + (i-1)*45, player) -- Item background1
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(bagItems[offer.item[1]].png, ":24",	435, y+60 + (i-1)*45, player) -- Final Item Image
	end
	return setmetatable(self, modernUI)
end
modernUI.jobInterface = function(self, job)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - 161/2)
	local y = (200 - 161/2) + 40
	local color = '#'..jobs[job].color
	ui.addTextArea(id..'884', '<p align="center"><b><font color="#f4e0c5" size="14">'..translate(job, player), player, x+38, y-10, 110, 30, 0xff0000, 0xff0000, 0, true)

	local jobImage = jobs[job].icon
	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171d2f983ba.png', ":26", x+30, y-19, player)
	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(jobImage, ":27", x, y-20, player)

	return setmetatable(self, modernUI)
end
modernUI.questInterface = function(self)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - 270/2)
	local y = (200 - 90/2) - 30

	local images = {'171d71ed2cf.png', '171d724975e.png'} -- available, unavailaible

	local playerData = players[player]
	local getLang = playerData.lang

	for i = 1, 2 do
		local icon = 1
		local title, min, max, goal = '', 0, 100, '<p align="center"><font color="#999999">'..translate('newQuestSoon', player):format(questsAvailable+1, '<CE>'..syncData.quests.newQuestDevelopmentStage)
		if i == 1 then 
			if playerData.questStep[1] > questsAvailable then
				icon = 2
			else
				title = lang[getLang].quests[playerData.questStep[1]].name
				min = playerData.questStep[2]
				max = #lang['en'].quests[playerData.questStep[1]]
				goal = string.format(lang[getLang].quests[playerData.questStep[1]][playerData.questStep[2]]._add, quest_formatText(player, playerData.questStep[1], playerData.questStep[2]))
			end
		else 
			title = '['..translate('_2ndquest', player)..']'
			min = playerData.sideQuests[2] 
			max = sideQuests[playerData.sideQuests[1]].quanty
			goal = lang[getLang].sideQuests[playerData.sideQuests[1]]:format(playerData.sideQuests[2] .. '/' .. sideQuests[playerData.sideQuests[1]].quanty)
		end
		local progress = math.floor(min / max * 100)
		local progress2 = math.floor(min / max * 250/11.5)
		ui.addTextArea(id..(890+i), '<font color="#caed87" size="15"><b>'..title, player, x+10, y+5 + (i-1)*100, 250, nil, 0, 0x24474, 0, true)
		ui.addTextArea(id..(892+i), '<font color="#ebddc3" size="13">'..goal, player, x+10, y+30 + (i-1)*100, 250, 40, 0x1, 0x1, 0, true)

		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(images[icon], ":26", x, y + (i-1)*100, player)
		for ii = 1, progress2 do 
			players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171d74086d8.png', ":25", x+17 + (ii-1)*11, y+77 + (i-1)*100, player)
		end
		ui.addTextArea(id..(900+i), '<p align="center"><font color="#000000" size="14"><b>'..translate('percentageFormat', player):format(progress), player, x+11, y+73 + (i-1)*100, 250, nil, 0, 0x24474, 0, true)
		ui.addTextArea(id..(902+i), '<p align="center"><font color="#c6bb8c" size="14"><b>'..translate('percentageFormat', player):format(progress), player, x+10, y+72 + (i-1)*100, 250, nil, 0, 0x24474, 0, true)

		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171d736325c.png', ":27", x+10, y+70 + (i-1)*100, player)
	end 

	return setmetatable(self, modernUI)
end
modernUI.rewardInterface = function(self, rewards, title, text)
	local player = self.player
	if not title then title = translate('reward', player) end 
	if not text then text = translate('rewardText', player) end
	text = text..'\n'
	for i, v in next, rewards do 
		text = text..'\n<font size="11"><n>'..v.text..' ('..v.format..v.quanty..')'
	end
	self.title = title 
	self.text = text
	return setmetatable(self, modernUI)
end
modernUI.badgeInterface = function(self, badge)
	local id = self.id
	local player = self.player
	local x = (400 - 220/2)
	local y = (200 - 90/2) - 30

	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(badges[badge] and badges[badge].png, "&70", 385, 180, player)
	ui.addTextArea(id..'890', '<p align="center"><i><v>"'..translate('badgeDesc_'..badge, player)..'"', player, x+10, y+100, 200, nil, 0, 0x24474, 0, true)

	return setmetatable(self, modernUI)
end
modernUI.profileInterface = function(self, target)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2)
	local y = (200 - height/2)

    players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171dc2950de.png', ":26", x+170, y+80, player)
    players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171dc2950de.png', ":27", x+340, y+80, player)

    local targetData = players[target]
    local level = targetData.level[1]
    local minXP = targetData.level[2]
    local maxXP = (targetData.level[1] * 2000) + 500
   	local progress = math.floor(minXP/maxXP * 490/23.5)
    for i = 1, progress do
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171dc34c3f0.png', ":28", 155 + (i-1)*23.5, y+68, player)
	end
   	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171dc59da98.png', ":28", 150, y+48, player)

   	ui.addTextArea(id..'900', '<p align="center"><font color="#c6bb8c" size="20"><b>'..level, player, 380, y+54, 40, 40, 0, 0x24474, 0, true)
   	ui.addTextArea(id..'901', '<p align="center"><font color="#c6bb8c" size="12"><b>'..minXP..'/'..maxXP..'xp', player, 315, y+80, 170, nil, 0, 0x24474, 0, true)

   	for i, v in next, {translate('profile_basicStats', player), translate('profile_jobs', player), translate('profile_badges', player)} do 
   		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171dc5fbaf6.png', ":28", 150 + (i-1)*170, y+103, player)
   		ui.addTextArea(id..(902+i), '<p align="center"><font color="#c6bb8c" size="12"><b>'..v, player, 145 + (i-1)*170, y+105, 170, nil, 0, 0x24474, 0, true)
   	end
   	local text_General = 
   		string.replace(player, {["{0}"] = 'profile_coins', ["{1}"] = '$'..targetData.coins}) ..'\n' ..
   		string.replace(player, {["{0}"] = 'profile_spentCoins', ["{1}"] = '$'..targetData.spentCoins}) ..'\n' ..
   		string.replace(player, {["{0}"] = 'profile_purchasedHouses', ["{1}"] = #targetData.casas..'/'..#mainAssets.__houses-3}) ..'\n' ..
   		string.replace(player, {["{0}"] = 'profile_purchasedCars', ["{1}"] = #targetData.cars..'/'..#mainAssets.__cars-1}) ..'\n' ..
   		string.replace(player, {["{0}"] = 'profile_completedQuests', ["{1}"] = (targetData.questStep[1]-1)..'/'..questsAvailable}) ..'\n' ..
   		string.replace(player, {["{0}"] = 'profile_completedSideQuests', ["{1}"] = targetData.sideQuests[3]}) ..'\n' ..
   		string.replace(player, {["{0}"] = 'profile_questCoins', ["{1}"] = 'QP$'..targetData.sideQuests[4]}) ..'\n'

	local text_Jobs = {
		police 	= 	string.replace(player, {["{0}"] = 'profile_arrestedPlayers', ["{1}"] = targetData.jobs[1]}),
		thief 	= 	string.replace(player, {["{0}"] = 'profile_robbery', ["{1}"] = targetData.jobs[2]}),
		fisher 	= 	string.replace(player, {["{0}"] = 'profile_fishes', ["{1}"] = targetData.jobs[3]}),
		miner 	= 	string.replace(player, {["{0}"] = 'profile_gold', ["{1}"] = targetData.jobs[4]}),
		farmer 	= 	string.replace(player, {["{0}"] = 'profile_seedsPlanted', ["{1}"] = targetData.jobs[5]}) ..'\n' ..
					string.replace(player, {["{0}"] = 'profile_seedsSold', ["{1}"] = targetData.jobs[6]}),
		chef 	= 	string.replace(player, {["{0}"] = 'profile_cookedDishes', ["{1}"] = targetData.jobs[10]}) ..'\n' ..
					string.replace(player, {["{0}"] = 'profile_fulfilledOrders', ["{1}"] = targetData.jobs[9]}),
		ghostbuster = string.replace(player, {["{0}"] = 'profile_capturedGhosts', ["{1}"] = targetData.jobs[7]}),
   	}	
	ui.addTextArea(id..'910', '<font size="10" color="#ebddc3">'..text_General, player, 155, y+133, 150, 150, 0x152d30, 0x152d30, 1, true)
	local job = {'police', 'thief', 'fisher', 'miner', 'farmer', 'chef', 'ghostbuster'}
	if targetData.jobs[7] == 0 then job[7] = nil end 
	for i, v in next, job do 
		ui.addTextArea(id..(911+i), '<p align="left"><font size="11" color="#'..jobs[v].color..'">'..translate(v, player), player, 323, y+133 + (i-1)*17, 150, nil, 0x152d30, 0x152d3, 0, true)
		ui.addTextArea(id..(921+i), '<p align="left"><font size="11" color="#caed87">→', player, 460, y+133 + (i-1)*17, nil, nil, 0x152d30, 0x152d3, 0, true, 
			function(player, args) 
				ui.addTextArea(args.id..'930', '<font size="14" color="#'..jobs[args.title].color..'"><p align="center">'..translate(args.title, player)..'</p></font>\n'..args.data, 
					player, 480, 180 + args.y*17, 150, nil, 0x432c04, 0x7a5817, 1, true) 
				ui.addTextArea(args.id..'931', '<textformat leftmargin="1" rightmargin="1">'..string.rep('\n', 10), 
					player, 480, 180 + args.y*17, 150, nil, 0x432c04, 0x7a5817, 0, true, 
						function(player, args) 
							ui.removeTextArea(args.id..'930')
							ui.removeTextArea(args.id..'931')
						end, {id = id}) 
			end, {title = v, id = id, data = text_Jobs[v], y = i-1})
	end
	--ui.addTextArea(id..'912', text_Badges, player, 493, y+130, 150, 153, 0x152d30, 0x152d30, 1, true)

	for i, v in next, players[target].badges do
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(badges[v].png, ":33", x+352+((i-1)%5)*31, y+140+math.floor((i-1)/5)*31, player)
	end

	return setmetatable(self, modernUI)
end
modernUI.showPlayerItems = function(self, items, chest)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) + 20
	local y = (200 - height/2) + 65
	local currentPage = 1
	if not items then return alert_error(player, 'error', 'emptyBag') end
	local maxPages = math.ceil(#items/15)
	local usedSomething = false
	local storageLimits = {chest and players[player].totalOfStoredItems.chest[chest] or players[player].totalOfStoredItems.bag, chest and 50 or players[player].bagLimit}
	local storageAmount = storageLimits[1]..'/'..storageLimits[2]

	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('172763e41e1.jpg', ":27", x+337, y-14, player)
	ui.addTextArea(id..'895', '<font color="#95d44d">'..translate('itemAmount', player):format('<cs>'..storageAmount..'</cs>'), player, x, y -20, 312, nil, 0xff0000, 0xff0000, 0, true)
	local function showItems()
		local minn = 15 * (currentPage-1) + 1
		local maxx = currentPage * 15
		local i = 0
		for _ = 1, #items do 
			i = i + 1
			local v = items[_]
			if i >= minn and i <= maxx then
				local i = i - 15 * (currentPage-1)
				local image = bagItems[v.name].png or '16bc368f352.png'
				players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage('1722d2d8234.jpg', ":26", x + ((i-1)%5)*63, y + math.floor((i-1)/5)*65, player)
				players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage(image, ":26", x + 5 + ((i-1)%5)*63, y + 5 + math.floor((i-1)/5)*65, player)
				ui.addTextArea(id..(895+i*2), '<p align="right"><font color="#95d44d" size="13"><b>x'..v.qt, player, x + 5 + ((i-1)%5)*63, y + 42 + math.floor((i-1)/5)*65, 55, nil, 0xff0000, 0xff0000, 0, true)
				ui.addTextArea(id..(896+i*2), '\n\n\n\n', player, x + 3 + ((i-1)%5)*63, y + 3 + math.floor((i-1)/5)*65, 55, 55, 0xff0000, 0xff0000, 0, true,
					function(player)
						local itemName = v.name 
						local quanty = v.qt 
						local itemData = bagItems[v.name]
						local itemType = itemData.type
						local power = itemData.power or 0
						local hunger = itemData.hunger or 0
						local blockUse = not itemData.func
						if itemType == 'food' then blockUse = false end
						local selectedQuanty = 1
						player_removeImages(players[player]._modernUISelectedItemImages[1])
						for i = 0, 3 do 
							ui.removeTextArea(id..(930+i), player)
						end
						local description = item_getDescription(itemName, player)
						ui.addTextArea(id..'890', '<p align="center"><font size="13"><fc>'..translate('item_'..itemName, player), player, x+340, y-15, 135, 215, 0x24474D, 0x314e57, 0, true)
						ui.addTextArea(id..'891', '<font size="9"><bl>'..description, player, x+340, y+50, 135, nil, 0x24474D, 0x314e5, 0, true)
						ui.addTextArea(id..'892', '<font color="#cef1c3">'..translate('confirmButton_Select', player), player, x+337, y+121 + (blockUse and 30 or 0), nil, nil, 0x24474D, 0x314e5, 0, true)
						ui.addTextArea(id..'893', '<font color="#cef1c3">01', player, x+425, y+121 + (blockUse and 30 or 0), nil, nil, 0x24474D, 0x314e5, 0, true)

						players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(image, "&26", 542, 125, player)
						players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage('1722d33f76a.png', ":26", x + ((i-1)%5)*63-3, y + math.floor((i-1)/5)*65-3, player)

						local function button(i, text, callback, x, y, width, height)
							ui.addTextArea(id..(930+i*5), '', player, x-1, y-1, width, height, 0x95d44d, 0x95d44d, 1, true)
							ui.addTextArea(id..(931+i*5), '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
							ui.addTextArea(id..(932+i*5), '', player, x, y, width, height, 0x44662c, 0x44662c, 1, true)
							ui.addTextArea(id..(933+i*5), '<p align="center"><font color="#cef1c3" size="13">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, callback)
						end
						if not blockUse then
							button(0, translate(itemType == 'food' and 'eatItem' or 'use', player), 
							function(player) 
								if usedSomething then return end
								if quanty > 0 then
									if itemName == 'cheese' then 
										if players[player].whenJoined > os.time() then 
											return alert_Error(player, 'error', 'limitedItemBlock', '120')
										else 
											players[player].whenJoined = os.time() + 120*10000
										end
									end
									eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
									local condition = itemData.func and -1 or -selectedQuanty
									if not chest then 
										removeBagItem(v.name, condition, player)
									else 
										item_removeFromChest(v.name, condition, player, chest)
									end
									if itemType == 'food' then 
										setLifeStat(player, 1, power * selectedQuanty)
										setLifeStat(player, 2, hunger * selectedQuanty)
									else
										itemData.func(player)
									end
									local sidequest = sideQuests[players[player].sideQuests[1]].type
									if string.find(sidequest, 'type:items') then
										if string.find(sidequest, 'use') then
											sideQuest_update(player, 1)
									 	end
									end
									usedSomething = true
									savedata(player)
									return
								end
							end, 507, 265, 120, 13)
						end
						button(1, translate(chest and 'passToBag' or 'drop', player), 
							function(player)
								eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
								if usedSomething then return end
								if quanty > 0 then
									if not chest then
										removeBagItem(v.name, -selectedQuanty, player)
										item_drop(v.name, player, selectedQuanty)
									else
										item_removeFromChest(v.name, selectedQuanty, player, chest)
										addItem(v.name, selectedQuanty, player)
									end
									usedSomething = true
									savedata(player)
								end
							end, 507, 295, 120, 13)

						for i = 1, 2 do 
							button(1+i, i == 1 and '-' or '+', 
								function(player) 
									local calc = i == 1 and -1 or 1
									if (selectedQuanty + calc) > quanty or (selectedQuanty + calc) < 1 then return end
									selectedQuanty = selectedQuanty + calc
									ui.updateTextArea(id..'893', '<font color="#cef1c3">'..string.format("%.2d", selectedQuanty), player)
								end, 565 + (i-1)*50, 240 + (blockUse and 30 or 0), 10, 10)
						end
					end)
			end
		end
	end
	local function updateScrollbar()
		local function updatePage(count)
			if currentPage + count > maxPages or currentPage + count < 1 then return end 
			currentPage = currentPage + count
			player_removeImages(players[player]._modernUISelectedItemImages[1])
			player_removeImages(players[player]._modernUISelectedItemImages[3])
			for i = 897, 929 do 
				ui.removeTextArea(id..i, player)
			end
			updateScrollbar()
			showItems()
		end
		ui.addTextArea(id..'888', string.rep('\n', 10), player, x+2, y+200, 155, 10, 0x24474D, 0xff0000, 0, true, 
			function()
				updatePage(-1)
			end)
		ui.addTextArea(id..'889', string.rep('\n', 10), player, x+157, y+200, 155, 10, 0x24474D, 0xff0000, 0, true, 
			function()
				updatePage(1)
			end)

		player_removeImages(players[player]._modernUISelectedItemImages[2])
		players[player]._modernUISelectedItemImages[2][#players[player]._modernUISelectedItemImages[2]+1] = addImage('1729eacaeb5.jpg', ":26", x+2, y+205, player)
		for i = 1, (10 - math.min(8, maxPages)+1) do 
			players[player]._modernUISelectedItemImages[2][#players[player]._modernUISelectedItemImages[2]+1] = addImage('1729ebf25cc.jpg', ":27", x+2 + (i-1)*31 + (currentPage-1)*31, y+205, player)
		end
	end
	if maxPages > 1 then 
		updateScrollbar()
	end
	showItems(currentPage)
	return setmetatable(self, modernUI)
end
modernUI.showPlayerVehicles = function(self)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) + 45
	local y = (200 - height/2) + 70
	local currentPage = 1
	local filter = {'car', 'boat'}
	local pages = {'land', 'water', 'air'}
	local favorites = players[player].favoriteCars
	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('17238027fa4.jpg', ":26", x, y-16, player)

	local function showItems()
		ui.addTextArea(id..'890', '<font color="#ebddc3" size="13"><b><p align="center">'..translate(pages[currentPage]..'Vehicles', player), player, 350, y-25, 100, nil, 0x152d30, 0x152d30, 0, true)
		local i = 1
		for _ = 1, #players[player].cars do 
			local v = mainAssets.__cars[players[player].cars[_]]
			if v.type == filter[currentPage] then 
				players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage('17237e4b350.jpg', ":26", x + ((i-1)%4)*107, y + math.floor((i-1)/4)*65, player)
				players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage(v.icon, ":26", x + ((i-1)%4)*107, y + math.floor((i-1)/4)*65, player)
				local isFavorite = favorites[currentPage] == players[player].cars[_] and '17238fea420.png' or '17238fe6532.png'
				players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(isFavorite, ":27", x+82 + ((i-1)%4)*107, y +42 + math.floor((i-1)/4)*65, player)

				local vehicleName = lang.en['vehicle_'..players[player].cars[_]] and translate('vehicle_'..players[player].cars[_], player) or v.name
				ui.addTextArea(id..(895+i*3), '<p align="center"><font color="#95d44d" size="10">'..vehicleName, player, x + ((i-1)%4)*107, y-2 + math.floor((i-1)/4)*65, 104, nil, 0xff0000, 0xff0000, 0, true)
				ui.addTextArea(id..(896+i*3), '\n\n\n\n', player, x + 3 + ((i-1)%4)*107, y + 3 + math.floor((i-1)/4)*65, 104, 62, 0xff0000, 0xff0000, 0, true,
					function(player)
						local car = players[player].cars[_]
						if currentPage ~= 2 and (ROOM.playerList[player].y < 7000 or ROOM.playerList[player].y > 7800 or players[player].place ~= 'town' and players[player].place ~= 'island') and not players[player].canDrive then return alert_Error(player, 'error', 'vehicleError') end
						drive(player, car)
						eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
					end)
				ui.addTextArea(id..(897+i*3), "<textformat leftmargin='1' rightmargin='1'>\n\n\n\n", player, x + 82 + ((i-1)%4)*107, y + 42 + math.floor((i-1)/4)*65, 20, 20, 0xff0000, 0xff0000, 0, true,
					function(player)
						favorites[currentPage] = players[player].cars[_]
						players[player].favoriteCars[currentPage] = players[player].cars[_]
						showItems()
						savedata(player)
					end)
				i = i + 1
			end
		end
	end
	local function updateScrollbar()
		local function updatePage(count)
			if currentPage + count > 2 or currentPage + count < 1 then return end 
			currentPage = currentPage + count
			player_removeImages(players[player]._modernUISelectedItemImages[1])
			player_removeImages(players[player]._modernUISelectedItemImages[3])
			for i = 899, 929 do 
				ui.removeTextArea(id..i, player)
			end
			updateScrollbar()
			showItems()
		end
		ui.addTextArea(id..'888', string.rep('\n', 10), player, x, y+202, 212, 10, 0x24474D, 0xff0000, 0, true, 
			function()
				updatePage(-1)
			end)
		ui.addTextArea(id..'889', string.rep('\n', 10), player, x+213, y+202, 212, 10, 0x24474D, 0xff0000, 0, true, 
			function()
				updatePage(1)
			end)

		player_removeImages(players[player]._modernUISelectedItemImages[2])
		players[player]._modernUISelectedItemImages[2][#players[player]._modernUISelectedItemImages[2]+1] = addImage('172380798d8.jpg', ":26", x, y+205, player)
		for i = 1, 4 do 
			players[player]._modernUISelectedItemImages[2][#players[player]._modernUISelectedItemImages[2]+1] = addImage('172383aa660.jpg', ":27", x + (i-1)*85 + (currentPage-1)*85, y+205, player)
		end
	end

	updateScrollbar()
	showItems()
	return setmetatable(self, modernUI)
end
modernUI.showHouses = function(self, selectedTerrain)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) + 20
	local y = (200 - height/2) + 65
	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('172763e41e1.jpg', ":27", x+337, y-14, player)
	local i = 0
	for _ = 1, #mainAssets.__houses do
		local v = mainAssets.__houses[_]
		local isLimitedTime = v.properties.limitedTime
		local isOutOfSale = isLimitedTime and formatDaysRemaining(isLimitedTime, true)
		local showItem = true
		if isLimitedTime and (isOutOfSale and not table.contains(players[player].casas, _)) then
			showItem = false
		end
		if showItem then
			i = i + 1
			local image = v.properties.png or '16c25233487.png'
			players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage('1722d2d8234.jpg', ":26", x + ((i-1)%5)*63, y + math.floor((i-1)/5)*65, player)
			players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage(image, ":26", x + 5 + ((i-1)%5)*63, y + 5 + math.floor((i-1)/5)*65, player)
			if isLimitedTime and not isOutOfSale then 
				ui.addTextArea(id..(895+i*2), '<p align="center"><font size="9"><r>'..translate('daysLeft2', player):format(formatDaysRemaining(isLimitedTime)), player, x + 3 + ((i-1)%5)*63, y + 49 + math.floor((i-1)/5)*65, 55, nil, 0xff0000, 0xff0000, 0, true)
			end
			ui.addTextArea(id..(896+i*2), '\n\n\n\n', player, x + 3 + ((i-1)%5)*63, y + 3 + math.floor((i-1)/5)*65, 55, 55, 0xff0000, 0xff0000, 0, true,
				function(player, i)
					local itemName = translate('House'.._, player)
					player_removeImages(players[player]._modernUISelectedItemImages[1])
					ui.addTextArea(id..'890', '<p align="center"><font size="13"><fc>'..itemName, player, x+340, y-15, 135, 215, 0x24474D, 0x314e57, 0, true)
					local description = '<p align="center"><i>"'..translate('houseDescription_'.._, player)..'"</i>\n\n<p align="left">'
					if isLimitedTime and table.contains(players[player].casas, _) then 
						description = description..'<r>'..translate('collectorItem', player)
					end
					ui.addTextArea(id..'891', '<font size="9"><bl>'..description, player, x+340, y+80, 135, nil, 0x24474D, 0x314e5, 0, true)
					ui.addTextArea(id..'894', '', player, x + 3 + ((i-1)%5)*63, y + 3 + math.floor((i-1)/5)*65, 55, 55, 0xff0000, 0xff0000, 0, true)

					players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(image, "&26", 542, 125, player)
					players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage('1722d33f76a.png', ":26", x + ((i-1)%5)*63-3, y + math.floor((i-1)/5)*65-3, player)
					local function button(i, text, callback, x, y, width, height, blockClick)
						local colorPallete = {
							button_confirmBg = 0x95d44d,
							button_confirmFront = 0x44662c
						}
						if blockClick then 
							colorPallete.button_confirmBg = 0xbdbdbd
							colorPallete.button_confirmFront = 0x5b5b5b
						end
						ui.addTextArea(id..(930+i*5), '', player, x-1, y-1, width, height, colorPallete.button_confirmBg, colorPallete.button_confirmBg, 1, true)
						ui.addTextArea(id..(931+i*5), '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
						ui.addTextArea(id..(932+i*5), '', player, x, y, width, height, colorPallete.button_confirmFront, colorPallete.button_confirmFront, 1, true)
						ui.addTextArea(id..(933+i*5), '<p align="center"><font color="#cef1c3" size="13">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, not blockClick and callback or nil)
					end
				
					local buttonType = nil 
					local blockClick = false
					local buttonAction = nil
				    if table.contains(players[player].casas, _) then
			    		buttonType =  translate('use', player)
			    		buttonAction = 'use'
					elseif players[player].coins >= v.properties.price then
			    		buttonType = '<font size="11">'..translate('confirmButton_Buy', player):format('<b><fc>$'..v.properties.price)
			    		buttonAction = 'buy'
					else
						blockClick = true
			    		buttonType = '<r>$'..v.properties.price
					end

					button(1, buttonType, 
						function(player)
							if buttonAction == 'use' then 
								eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
								equipHouse(player, _, selectedTerrain)
							elseif buttonAction == 'buy' then 
								if room.terrains[selectedTerrain].owner then return alert_Error(player, 'error', 'alreadyLand') end
								if table.contains(players[player].casas, _) then return end

								eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
								players[player].casas[#players[player].casas+1] = _
								giveCoin(-v.properties.price, player)
								sendMenu(99, player, '', 400 - 120 * 0.5, (300 * 0.5), 100, 100, 1, true)
								ui.removeTextArea(24 + selectedTerrain)
								ui.removeTextArea(44 + selectedTerrain)
								ui.removeTextArea(selectedTerrain)

								players[player].images[#players[player].images+1] = addImage(v.properties.png, "&70", 400 - 50 * 0.5, 180, player)

								equipHouse(player, _, selectedTerrain)
							end
						end, 507, 295, 120, 13, blockClick)
				end, i)
		end
	end
	return setmetatable(self, modernUI)
end
modernUI.showHouseSettings = function(self)
	local id = self.id
	local player = self.player
	local height = self.height
	local x = (400 - 180/2)
	local y = (200 - height/2) + 50

	local function button(i, text, callback, x, y, width, height)
		local width = width or 180
		local height = height or 15
		ui.addTextArea(id..(930+i*5), '', player, x-1, y-1, width, height, 0x95d44d, 0x95d44d, 1, true)
		ui.addTextArea(id..(931+i*5), '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
		ui.addTextArea(id..(932+i*5), '', player, x, y, width, height, 0x44662c, 0x44662c, 1, true)
		ui.addTextArea(id..(933+i*5), '<p align="center"><font color="#cef1c3" size="13">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, callback)
	end
	local images = {bg = {}, icons = {}, pages = {}, expansions = {}}
	local terrainID = players[player].houseData.houseid
	local showFurnitures, updateScrollbar, updatePage
	local buildModeImages = {currentFurniture = nil, furnitures = {}}
	local playerFurnitures = table.copy(players[player].houseData.furnitures.stored)
	local playerFurnitures_length = table.getLength(playerFurnitures)
	local playerPlacedFurnitures = table.copy(players[player].houseData.furnitures.placed)
	local totalOfPlacedFurnitures = table.getLength(players[player].houseData.furnitures.placed)

	local function removeFurniture(index)
		if not players[player].editingHouse then return end
		local data = playerPlacedFurnitures[index]
		if not data then return end
		playerPlacedFurnitures[index] = false
		removeImage(data.image)
		ui.removeTextArea(- 85000 - (terrainID*200 + index), player)
		if mainAssets.__furnitures[data.type].grounds then
			TFM.removePhysicObject(- 7000 - (terrainID-1)*200 - index)
		end
		totalOfPlacedFurnitures = totalOfPlacedFurnitures - 1
		if not playerFurnitures[data.type] then 
			playerFurnitures[data.type] = {quanty = 1, type = data.type}
		else 
			playerFurnitures[data.type].quanty = playerFurnitures[data.type].quanty + 1
		end
		ui.updateTextArea(id..'891', '<font size="12"><cs>'..translate('placedFurnitures', player):format('<fc><b>'..totalOfPlacedFurnitures..'/'..maxFurnitureStorage..'</b></fc>'), player)
		updatePage(0)
	end
	local function placeFurniture(index)
		if not players[player].editingHouse then return end
		if totalOfPlacedFurnitures >= maxFurnitureStorage then return alert_Error(player, 'error', 'maxFurnitureStorage', maxFurnitureStorage) end
		if buildModeImages.currentFurniture then 
			removeImage(buildModeImages.currentFurniture)
			buildModeImages.currentFurniture = nil
		end
		local data = playerFurnitures[index]
		if not data then return alert_Error(player, 'error', 'unknownFurniture') end
		local furniture = mainAssets.__furnitures[data.type]
		buildModeImages.currentFurniture = addImage(furniture.image, '%'..player, furniture.align.x, furniture.align.y, player)
		images.icons[#images.icons+1] = addImage('172469fea71.jpg', ':25', 350, 317, player)
		ui.addTextArea(id..'892', '<p align="center"><b><fc><font size="14">'..translate('houseSettings_placeFurniture', player)..'\n', player, 350, 321, 100, 25, 0x24474D, 0x00ff00, 0, true, 
			function()
				ui.removeTextArea(id..'892', player)
				if not playerFurnitures[index] then return end
				if playerFurnitures[index].quanty <= 0 then return end
				local x, y = ROOM.playerList[player].x, ROOM.playerList[player].y
				if y < 1000 or y > 2000 then return end
				if x > terrainID*1500 or x < (terrainID-1)*1500+100 then return end

				playerFurnitures[index].quanty = playerFurnitures[index].quanty - 1
				totalOfPlacedFurnitures = totalOfPlacedFurnitures + 1
				ui.updateTextArea(id..'891', '<font size="12"><cs>'..translate('placedFurnitures', player):format('<fc><b>'..totalOfPlacedFurnitures..'/'..maxFurnitureStorage..'</b></fc>'), player)

				local id = terrainID

				TFM.killPlayer(player)
				TFM.respawnPlayer(player)
				TFM.movePlayer(player, x, y, false)

				local furniture_X = x + furniture.align.x 
				local furniture_Y = y + furniture.align.y
				local idd = #playerPlacedFurnitures+1
				playerPlacedFurnitures[idd] = {type = data.type, x = furniture_X - (id-1)*1500, y = furniture_Y - 1000, image = addImage(furniture.image, '?1000', furniture_X, furniture_Y, player)}
				ui.addTextArea(- 85000 - (id*200 + idd), "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', furniture.area[2]/8), player, furniture_X, furniture_Y, furniture.area[1], furniture.area[2], 1, 0xfff000, 0, false, 
					function()
						removeFurniture(idd)
					end)

				if furniture.grounds then
					furniture.grounds(furniture_X,  furniture_Y, - 7000 - (id-1)*200 - idd)
					TFM.movePlayer(player, 0, - 50, true)
				end

				if playerFurnitures[index].quanty <= 0 then 
					playerFurnitures[index] = false
				end
				updatePage(0)
			end)

	end
	local function sellFurniture(index)
		if not players[player].editingHouse then return end
		local data = playerFurnitures[index]
		if not data then return alert_Error(player, 'error', 'unknownFurniture') end
		local furniture = mainAssets.__furnitures[data.type]
		if playerFurnitures[index].quanty <= 0 then return end
		playerFurnitures[index].quanty = playerFurnitures[index].quanty - 1
		if playerFurnitures[index].quanty <= 0 then 
			playerFurnitures[index] = nil
		end
		if buildModeImages.currentFurniture then
			local x, y = ROOM.playerList[player].x, ROOM.playerList[player].y
			TFM.killPlayer(player)
			TFM.respawnPlayer(player)
			TFM.movePlayer(player, x, y, false)
			buildModeImages.currentFurniture = nil
			ui.removeTextArea(id..'892', player)
		end
		players[player].houseData.furnitures.stored = {}
		for i, v in next, playerFurnitures do
			if v then
				players[player].houseData.furnitures.stored[i] = v
			end
		end
		players[player].houseData.furnitures.placed = {}
		for i, v in next, playerPlacedFurnitures do 
			if v then
				players[player].houseData.furnitures.placed[i] = v
				removeImage(v.image)
				ui.removeTextArea(- 85000 - (terrainID*200 + i), player)
			end
		end
		giveCoin(furniture.price and furniture.price/2 or 0, player)
		updatePage(0)
	end
	local function closeExpansionMenu()
		player_removeImages(images.expansions)
		ui.removeTextArea(id..'889', player)
		ui.removeTextArea(id..'890', player)
		updatePage(0)
	end
	button(0, translate('houseSettings_permissions', player), function() 
		eventTextAreaCallback(0, player, 'modernUI_Close_'..id, 'errorUI')
		modernUI.new(player, 380, 280, translate('houseSettings_permissions', player))
		:build()
		:showHousePermissions()
	end, x, y)

	button(1, translate('houseSettings_buildMode', player), function() 
		if players[player].editingHouse then return end
		players[player].editingHouse = true
		for i = 0, 4 do 
			ui.removeTextArea(98900000000+i, player)
			ui.removeTextArea(999990+i, player)
		end

		player_removeImages(room.houseImgs[terrainID].furnitures)
		for i, furniture in next, playerPlacedFurnitures do
			local data = mainAssets.__furnitures[furniture.type]
			local x = furniture.x + ((terrainID-1)%terrainID)*1500
			local y = furniture.y + 1000
			furniture.image = addImage(data.image, '?1000', x, y, player)
			ui.addTextArea(- 85000 - (terrainID*200 + i), "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', data.area[2]/8), player, x, y, data.area[1], data.area[2], 1, 0xfff000, 0, false, 
				function()
					removeFurniture(i)
				end)
		end
		for guest in next, room.terrains[terrainID].guests do
			if room.terrains[terrainID].guests[guest] then 
				getOutHouse(guest, terrainID)
				alert_Error(guest, 'error', 'error_houseUnderEdit', player)
			end
		end
		room.terrains[terrainID].guests = {}

		eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
		for i = 0, 3 do
			if players[player].houseTerrainAdd[i+1] == 1 then
				ui.addTextArea(id..(885+i), '<p align="center"><fc>'..translate('houseSettings_changeExpansion', player)..'\n', player, (terrainID-1)*1500 + 650 + i*175, 1740, 175, nil, 0x24474D, 0xff0000, 0, false,
					function()
						if images.expansions[1] then return end
						ui.addTextArea(id..'889', '', player, 0, 0, 800, 400, 0x24474D, 0xff0000, 0, true)
						local counter = 0
						for _ = 0, 3 do
							if _ ~= i then 
								images.expansions[#images.expansions+1] = addImage('17285e3d8e1.png', "!1000", (terrainID-1)*1500 + 650 + _*175, 1715, player)
							end
						end
						images.expansions[#images.expansions+1] = addImage('171d2a2e21a.png', ":25", 280, 140, player)
						ui.addTextArea(id..'890', string.rep('\n', 4), player, 487, 150, 25, 25, 0xff0000, 0xff0000, 0, true, function() closeExpansionMenu() end)
						for expansionID, v in next, houseTerrains do
							if players[player].houseTerrain[i+1] ~= expansionID then
								images.expansions[#images.expansions+1] = addImage(v.png, ":26", counter*109 + 324, 150, player)
								button(counter, translate('confirmButton_Buy2', player):format('<fc>'..translate('expansion_'..v.name, player)..'</fc>','<fc>$'..v.price..'</fc>'), 
									function()
										if players[player].coins < v.price or players[player].houseTerrain[i+1] == expansionID then return end
										players[player].houseTerrain[i+1] = expansionID
										players[player].houseTerrainAdd[i+1] = 1
										players[player].houseTerrainPlants[i+1] = 0
										HouseSystem.new(player):genHouseGrounds()
										giveCoin(-v.price, player)
										closeExpansionMenu()
									end, counter*109 + 299, 210, 95, 30)
								counter = counter + 1
							end
						end
					end)
			end
		end
		local currentPage = 1
		local maxPages = math.ceil(playerFurnitures_length/14)
		images.bg[#images.bg+1] = addImage('1723ed04fb4.jpg', ':25', 5, 340, player)
		images.bg[#images.bg+1] = addImage('172469fea71.jpg', ':25', 695, 317, player)

		ui.addTextArea(id..'891', '<font size="12"><cs>'..translate('placedFurnitures', player):format('<fc><b>'..totalOfPlacedFurnitures..'/'..maxFurnitureStorage..'</b></fc>'), player, 0, 321, nil, nil, 0x24474D, 0xff0000, 0, true)
		ui.addTextArea(id..'893', '', player, 0, 340, 800, 60, 0x24474D, 0xff0000, 0, true)
		ui.addTextArea(id..'894', '<p align="center"><b><font color="#95d44d" size="14">'..translate('houseSettings_finish', player)..'\n', player, 695, 321, 100, nil, 0x24474D, 0xff0000, 0, true, 
			function()
				if not players[player].editingHouse then return end
				local x, y = ROOM.playerList[player].x, ROOM.playerList[player].y
				TFM.killPlayer(player)
				TFM.respawnPlayer(player)
				TFM.movePlayer(player, x, y, false)

				players[player].houseData.furnitures.stored = {}
				for i, v in next, playerFurnitures do
					if v then
						players[player].houseData.furnitures.stored[i] = v
					end
				end
				players[player].houseData.furnitures.placed = {}
				for i, v in next, playerPlacedFurnitures do 
					if v then
						players[player].houseData.furnitures.placed[i] = v
						removeImage(v.image)
						ui.removeTextArea(- 85000 - (terrainID*200 + i), player)
					end
				end
				players[player].houseData.chests.position = {}
				players[player].editingHouse = false
				savedata(player)
				HouseSystem.new(player):genHouseFace()
				for i = 1, 2 do 
					showLifeStats(player, i)
				end
				showOptions(player)
				player_removeImages(images.icons)
				player_removeImages(images.pages)
				player_removeImages(images.bg)
				eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
			end)
		showFurnitures = function()
			local minn = 14 * (currentPage-1) + 1
			local maxx = currentPage * 14
			local i = 0
			for index, v in next, playerFurnitures do
				if v then
					i = i + 1
					if i >= minn and i <= maxx then
						local i = i - 14 * (currentPage-1)
						local furnitureData = mainAssets.__furnitures[v.type]
						images.icons[#images.icons+1] = addImage('1723ed07002.png', ':26', 37 + (i-1) * 52, 350, player)
						images.icons[#images.icons+1] = addImage(furnitureData.png, ':27', 39 + (i-1) * 52, 350, player)
						images.icons[#images.icons+1] = addImage('172559203c1.png', ':28', 37 + (i-1) * 52, 350, player)

						ui.addTextArea(id..(895+i*3), '<p align="right"><font color="#95d44d" size="13"><b>x'..v.quanty, player, 35 + (i-1)*52, 383, 54, nil, 0xff0000, 0xff0000, 0, true)
						ui.addTextArea(id..(896+i*3), '\n\n\n\n', player, 35 + (i-1)*52, 347, 55, 55, 0xff0000, 0xff0000, 0, true,
							function()
								placeFurniture(index)
							end)
						ui.addTextArea(id..(897+i*3), "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', 3), player, 37 + (i-1)*52, 350, 10, 10, 0xff0000, 0xff0000, 0, true,
							function()
								modernUI.new(player, 240, 220, translate('sellFurniture', player), translate('sellFurnitureWarning', player))
								:build()
								:addConfirmButton(function()
									sellFurniture(index)
								end, translate('confirmButton_Sell', player):format('<b><fc>$'..(furnitureData.price and furnitureData.price/2 or 0)..'</fc></b>'), 200)
							end)

					end
				end
			end
		end
		updatePage = function(count)
			if currentPage + count > maxPages or currentPage + count < 1 then return end 
			currentPage = currentPage + count
			player_removeImages(images.icons)
			player_removeImages(images.pages)
			for i = 895, 995 do
				ui.removeTextArea(id..i, player)
			end
			updateScrollbar()
			showFurnitures()
		end
		updateScrollbar = function()
			if currentPage > 1 then
				images.pages[#images.pages+1] = addImage('1723f16c0ba.jpg', ':25', 5, 340, player)
				ui.addTextArea(id..'895', string.rep('\n', 10), player, 12, 345, 20, 60, 0x24474D, 0xff0000, 0, true, 
					function()
						updatePage(-1)
					end)
			end
			if currentPage < maxPages then
				images.pages[#images.pages+1] = addImage('1723f16e3ba.jpg', ':25', 761, 340, player)
				ui.addTextArea(id..'896', string.rep('\n', 10), player, 767, 345, 20, 60, 0x24474D, 0xff0000, 0, true, 
					function()
						updatePage(1)
					end)
			end
		end
		if maxPages > 1 then 
			updateScrollbar()
		end
		showFurnitures()
	end, x, y+30)

	return setmetatable(self, modernUI)
end
modernUI.showHousePermissions = function(self)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) + 20
	local y = (200 - height/2) + 70
	local playerList = {}
	local i = 1
	local terrainID = players[player].houseData.houseid
	local function button(i, text, callback, x, y)
		local width = 150
		local height = 15
		ui.addTextArea(id..(930+i*5), '', player, x-1, y-1, width, height, 0x95d44d, 0x95d44d, 1, true)
		ui.addTextArea(id..(931+i*5), '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
		ui.addTextArea(id..(932+i*5), '', player, x, y, width, height, 0x44662c, 0x44662c, 1, true)
		ui.addTextArea(id..(933+i*5), '<p align="center"><font color="#cef1c3" size="13">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, callback)
	end
	for user in next, ROOM.playerList do
		if user ~= player and players[user] then
			ui.addTextArea(id..(896+i), user, player, x+4 + (i-1)%2*173, y + math.floor((i-1)/2)*15, nil, nil, -1, 0xff0000, 0, true, 
				function(player, i)
					if not room.terrains[terrainID].settings.permissions[user] then room.terrains[terrainID].settings.permissions[user] = 0 end
					local userPermission = room.terrains[terrainID].settings.permissions[user]
					ui.addTextArea(id..'930', '<p align="center"><ce>'..user..'</ce>\n<v><font size="10">«'..translate("permissions_"..mainAssets.housePermissions[userPermission], player)..'»</font></v>', player, x+4 + (i-1)%2*173, y + math.floor((i-1)/2)*15, 150, 70, 0x432c04, 0x7a5817, 1, true)
					local counter = 0
					for _ = -1, 1 do
						if _ ~= room.terrains[terrainID].settings.permissions[user] then
							ui.addTextArea(id..(931+counter), translate('setPermission', player):format(translate('permissions_'..mainAssets.housePermissions[_], player)), player, x+4 + (i-1)%2*173, y + 25 + math.floor((i-1)/2)*15 + counter*15, nil, nil, 0x432c04, 0x7a5817, 0, true,
								function()
									if room.terrains[terrainID].settings.permissions[user] == _ then return end
									room.terrains[terrainID].settings.permissions[user] = _
									for i = 930, 934 do
										ui.removeTextArea(id..i, player)
									end
									if _ == -1 then
										if room.terrains[terrainID].guests[user] then 
											getOutHouse(user, terrainID)
											alert_Error(user, 'error', 'error_blockedFromHouse', player)
										end
									end
								end)
							counter = counter + 1
						end
					end
				end, i)
			i = i + 1
		end
	end
	local function buttonAction(option)
		if option == 1 then
			if not room.terrains[terrainID].settings.isClosed then
				for guest in next, room.terrains[terrainID].guests do
					if room.terrains[terrainID].guests[guest] then 
						if not room.terrains[terrainID].settings.permissions[guest] then room.terrains[terrainID].settings.permissions[guest] = 0 end
						if room.terrains[terrainID].settings.permissions[guest] < 1 then
							getOutHouse(guest, terrainID)
							alert_Error(guest, 'error', 'error_houseClosed', player)
						end
					end
				end
			end
			room.terrains[terrainID].settings.isClosed = not room.terrains[terrainID].settings.isClosed
		elseif option == 2 then 
			room.terrains[terrainID].settings.permissions = {[player] = 4}
		end
		eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
	end
	for i, v in next, {room.terrains[terrainID].settings.isClosed and translate('houseSettings_unlockHouse', player) or translate('houseSettings_lockHouse', player), translate('houseSettings_reset', player)} do
		button(i, v, function() 
			buttonAction(i)
		end, x + 12 + (i-1)*166, y + 175)
	end
	return setmetatable(self, modernUI)
end
modernUI.showNPCShop = function(self, items)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) + 20
	local y = (200 - height/2) + 65
	local currentPage = 1
	local maxPages = math.ceil(#items/15)
	local boughtSomething = false -- for prevent players from duplicating rare items
	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('172763e41e1.jpg', ":27", x+337, y-14, player)

	local function showItems()
		local minn = 15 * (currentPage-1) + 1
		local maxx = currentPage * 15
		local i = 0
		for _ = minn, maxx do 
			local data = items[_]
			if not data then break end
			local selectedQuanty = 1
			local v = mainAssets.__furnitures[data[1]] or bagItems[data[2]]
			players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage('1722d2d8234.jpg', ":26", x + (i%5)*63, y + math.floor(i/5)*65, player)
			players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage(v.png, ":26", x + 5 + (i%5)*63, y + 5 + math.floor(i/5)*65, player)
			if v.stockLimit and checkIfPlayerHasFurniture(player, data[1]) then
				ui.addTextArea(id..(900+i), '<p align="center"><font size="9"><r>'..translate('error_maxStorage', player), player, x + (i%5)*63, y + 3 + math.floor(i/5)*65, 58, 55, 0xff0000, 0xff0000, 0, true)
				players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage('1725d179b2f.png', ":26", x + (i%5)*63, y + math.floor(i/5)*65, player)
			else
				ui.addTextArea(id..(900+i), '\n\n\n\n', player, x + 3 + (i%5)*63, y + 3 + math.floor(i/5)*65, 55, 55, 0xff0000, 0xff0000, 0, true,
				function(player, i)
					local name = mainAssets.__furnitures[data[1]] and translate('furniture_'..v.name, player) or translate('item_'..data[2], player)
					player_removeImages(players[player]._modernUISelectedItemImages[1])

					ui.addTextArea(id..'890', '<p align="center"><font size="13"><fc>'..name, player, x+340, y-15, 135, 215, 0x24474D, 0x314e57, 0, true)
					local description = item_getDescription(mainAssets.__furnitures[data[1]] and data[1] or data[2], player, mainAssets.__furnitures[data[1]])
					ui.addTextArea(id..'891', '<font size="9"><bl>'..description, player, x+340, y+50, 135, nil, 0x24474D, 0x314e5, 0, true)
					ui.addTextArea(id..'892', '<font color="#cef1c3">'..translate('confirmButton_Select', player), player, x+337, y+151, nil, nil, 0x24474D, 0x314e5, 0, true)
					ui.addTextArea(id..'894', '', player, x + 3 + (i%5)*63, y + 3 + math.floor(i/5)*65, 55, 55, 0xff0000, 0xff0000, 0, true)

					players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(v.png, "&26", 542, 125, player)
					players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage('1722d33f76a.png', ":26", x + (i%5)*63-3, y + math.floor(i/5)*65-3, player)
					local function button(i, text, callback, x, y, width, height, blockClick)
						local colorPallete = {
							button_confirmBg = 0x95d44d,
							button_confirmFront = 0x44662c
						}
						if blockClick then 
							colorPallete.button_confirmBg = 0xbdbdbd
							colorPallete.button_confirmFront = 0x5b5b5b
						end
						ui.addTextArea(id..(930+i*5), '', player, x-1, y-1, width, height, colorPallete.button_confirmBg, colorPallete.button_confirmBg, 1, true)
						ui.addTextArea(id..(931+i*5), '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
						ui.addTextArea(id..(932+i*5), '', player, x, y, width, height, colorPallete.button_confirmFront, colorPallete.button_confirmFront, 1, true)
						ui.addTextArea(id..(933+i*5), '<p align="center"><font color="#cef1c3" size="13">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, not blockClick and callback or nil)
					end
					local currency = v.qpPrice and {players[player].sideQuests[4], v.qpPrice*selectedQuanty} or {players[player].coins, v.price*selectedQuanty}
					local buttonTxt = nil 
					local blockClick = false
				    if currency[1] >= currency[2] then
			    		buttonTxt = '<font size="11">'..translate('confirmButton_Buy', player):format('<b><fc>'..(v.qpPrice and 'QP$'..(v.qpPrice*selectedQuanty) or '$'..(v.price*selectedQuanty)))
					else
						blockClick = true
			    		buttonTxt = '<r>'..(v.qpPrice and 'QP$'..v.qpPrice or '$'..v.price)
					end
					local function buyItem()
						if boughtSomething then return end
						if currency[1] < currency[2] then return alert_Error(player, 'error', 'error') end
						if mainAssets.__furnitures[data[1]] then 
							local total_of_storedFurnitures = 0
							for _, v in next, players[player].houseData.furnitures.stored do 
								total_of_storedFurnitures = total_of_storedFurnitures + v.quanty
							end
							if (total_of_storedFurnitures + selectedQuanty) > maxFurnitureDepot then return alert_Error(player, 'error', 'maxFurnitureDepot', maxFurnitureDepot) end
							if not players[player].houseData.furnitures.stored[data[1]] then 
								players[player].houseData.furnitures.stored[data[1]] = {quanty = selectedQuanty, type = data[1]}
							else 
								players[player].houseData.furnitures.stored[data[1]].quanty = players[player].houseData.furnitures.stored[data[1]].quanty + selectedQuanty
							end
						else
							if (players[player].totalOfStoredItems.bag + selectedQuanty) > players[player].bagLimit then return alert_Error(player, 'error', 'bagError') end
							local item = data[2]
							addItem(item, selectedQuanty, player) 
							for id, properties in next, players[player].questLocalData.other do 
								if id:find('BUY_') then
									if id:lower():find(item:lower()) then 
										if type(properties) == 'boolean' then 
											quest_updateStep(player)
										else 
											players[player].questLocalData.other[id] = properties - selectedQuanty
											if players[player].questLocalData.other[id] <= 0 then 
												quest_updateStep(player)
											end
										end
										break
									end
								end
							end
						end
						if v.qpPrice then
							players[player].sideQuests[4] = players[player].sideQuests[4] - currency[2]
						else
							giveCoin(-currency[2], player)
						end

						boughtSomething = true
						savedata(player)
						eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
					end
					local function addBuyButton(buttonTxt)
						button(0, buttonTxt, 
							function()
								buyItem()
							end, 507, 295, 120, 13, blockClick)
					end
					if not blockClick and not v.stockLimit then
						ui.addTextArea(id..'893', '<font color="#cef1c3">01', player, x+425, y+151, nil, nil, 0x24474D, 0x314e5, 0, true)
						for i = 1, 2 do 
							button(i, i == 1 and '-' or '+', 
								function(player) 
									local calc = i == 1 and -1 or 1
									if (selectedQuanty + calc) > 50 or (selectedQuanty + calc) < 1 then return end
									selectedQuanty = selectedQuanty + calc
									currency = v.qpPrice and {players[player].sideQuests[4], v.qpPrice*selectedQuanty} or {players[player].coins, v.price*selectedQuanty}
									ui.updateTextArea(id..'893', '<font color="#cef1c3">'..string.format("%.2d", selectedQuanty), player)
									buttonTxt = '<font size="11">'..translate('confirmButton_Buy', player):format('<b><fc>'..(v.qpPrice and 'QP$'..(v.qpPrice*selectedQuanty) or '$'..(v.price*selectedQuanty))..'</fc></b>')
									addBuyButton(buttonTxt)
								end, 565 + (i-1)*50, 270, 10, 10)
						end
					end
					addBuyButton(buttonTxt)
				end, i)	
			end
			i = i + 1
		end
	end
	local function updateScrollbar()
		local function updatePage(count)
			if currentPage + count > maxPages or currentPage + count < 1 then return end 
			currentPage = currentPage + count
			player_removeImages(players[player]._modernUISelectedItemImages[1])
			player_removeImages(players[player]._modernUISelectedItemImages[3])
			for i = 897, 929 do 
				ui.removeTextArea(id..i, player)
			end
			updateScrollbar()
			showItems()
		end
		ui.addTextArea(id..'888', string.rep('\n', 10), player, x+2, y+200, 155, 10, 0x24474D, 0xff0000, 0, true, 
			function()
				updatePage(-1)
			end)
		ui.addTextArea(id..'889', string.rep('\n', 10), player, x+157, y+200, 155, 10, 0x24474D, 0xff0000, 0, true, 
			function()
				updatePage(1)
			end)

		player_removeImages(players[player]._modernUISelectedItemImages[2])
		players[player]._modernUISelectedItemImages[2][#players[player]._modernUISelectedItemImages[2]+1] = addImage('1729eacaeb5.jpg', ":26", x+2, y+205, player)
		for i = 1, (10 - math.min(8, maxPages)+1) do 
			players[player]._modernUISelectedItemImages[2][#players[player]._modernUISelectedItemImages[2]+1] = addImage('1729ebf25cc.jpg', ":27", x+2 + (i-1)*31 + (currentPage-1)*31, y+205, player)
		end
	end
	if maxPages > 1 then 
		updateScrollbar()
	end
	showItems()
	return setmetatable(self, modernUI)
end
modernUI.showSettingsMenu = function(self)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) + 20
	local y = (200 - height/2) + 65
	local selectedWindow = 1

	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('17281987ff2.jpg', ":26", x-3, y-23, player)
	local function button(i, text, callback, x, y, width, height)
		local width = width or 110
		local height = height or 15
		ui.addTextArea(id..(930+i*5), '', player, x-1, y-1, width, height, 0x95d44d, 0x95d44d, 1, true)
		ui.addTextArea(id..(931+i*5), '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
		ui.addTextArea(id..(932+i*5), '', player, x, y, width, height, 0x44662c, 0x44662c, 1, true)
		ui.addTextArea(id..(933+i*5), '<p align="center"><font color="#cef1c3" size="13">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, callback)
	end
	local buttons = {}
	local function addToggleButton(setting, name, state, _id)
		if not state then state = players[player].settings[setting] == 1 and true or false end
		buttonType = buttons[_id] and _id or #buttons+1
		buttons[buttonType] = {state = state}
		local buttonID = buttonType
		local x = x + 15
		local y = y + 5 + (#buttons-1)*20
		ui.addTextArea(id..(900+(buttonID-1)*6), "", player, x-1, y-1, 2, 2, 1, 1, 1, true)
		ui.addTextArea(id..(901+(buttonID-1)*6), "", player, x, y, 2, 2, 0x3A5A66, 0x3A5A66, 1, true)
		ui.addTextArea(id..(902+(buttonID-1)*6), "", player, x, y, 1, 1, 0x233238, 0x233238, 1, true)
		ui.addTextArea(id..(903+(buttonID-1)*6), state and '<font size="17">•' or '', player, x-6, y-13, nil, nil, 1, 1, 0, true)
		ui.addTextArea(id..(904+(buttonID-1)*6), '\n', player, x-5, y-5, 10, 10, 1, 0xffffff, 0, true, function(player, buttonID)
			buttons[buttonID].state = not buttons[buttonID].state
			players[player].settings[setting] = buttons[buttonID].state and 1 or 0
			addToggleButton(setting, name, buttons[buttonID].state, buttonID)
		end, buttonID)
		ui.addTextArea(id..(905+(buttonID-1)*6), '<cs>'..name, player, x+10, y-7, nil, nil, 1, 1, 0, true)
	end
	local selectedLang = players[player].lang:upper()
	local function addLangSwitch()
		for i = 0, 20 do 
			ui.removeTextArea(id..(910+i), player)
		end 
		player_removeImages(players[player]._modernUISelectedItemImages[1])
		local x = x + 15
		local y = y + 50
		ui.addTextArea(id..'910', '', player, x-1, y-1, 70, 15, 1, 1, 1, true)
		players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(community[selectedLang:lower()], "&26", x+5, y+3, player)
		ui.addTextArea(id..'911', '<n2>'..selectedLang..'\t↓', player, x+22, y-1, nil, nil, 1, 1, 0, true,
			function()
				local toChoose = {}
				for i, v in next, langIDS do
					if v:upper() ~= selectedLang then 
						toChoose[#toChoose+1] = v:upper()
					end 
				end
				local txt = '\n'..table.concat(toChoose, '\n')
				ui.addTextArea(id..'910', '<font color="#000000">'..txt, player, x-1, y-1, 70, nil, 1, 1, 1, true)
				ui.addTextArea(id..'911', '<n2>'..selectedLang..'\t↑', player, x+22, y-1, nil, nil, 1, 1, 0, true, function()
						addLangSwitch()
					end)
				for i, v in next, toChoose do
					players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(community[v:lower()], "&26", x+5, y+17 + (i-1)*14, player)
					ui.addTextArea(id..(911+i), v, player, x+22, y+14 + (i-1)*14, nil, nil, 1, 1, 0, true, function()
						selectedLang = v
						players[player].lang = lang[v:lower()] and v:lower() or 'en'
						addLangSwitch()
					end)
				end
			end)
	end
	local function showOptions(window)
		selectedWindow = window
		if selectedWindow == 1 then
			ui.addTextArea(id..900, '<font color="#ebddc3" size="13"> '
				..translate('settings_helpText', player)
				..'\n\n\n\n<font size="15">'
				..translate('settings_helpText2', player)
				..'</font>\n'
				..translate('command_profile', player), player, x, y -23, 485, 200, 0xff0000, 0xff0000, 0, true)
			button(5, 'Mycity Wiki', function(player) TFM.chatMessage('<rose>https://transformice.fandom.com/wiki/Mycity', player) end, x+22, y+30, 435, 12)
		elseif selectedWindow == 2 then
			buttons = {}
			ui.addTextArea(id..931, '<font color="#ebddc3" size="13">\n\n\n'..translate('settings_config_lang', player), player, x, y -23, 485, nil, 0xff0000, 0xff0000, 0, true)
			addToggleButton('mirroredMode', translate('settings_config_mirror', player))
			addLangSwitch()
		elseif selectedWindow == 3 then
			players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage('17281d1a0f9.png', ":26", 505, y+10, player)
			local credit = mainAssets.credits 
			local counter = 0

			for i, v in next, credit.translations do 
				players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(community[v], "&70", x+32, y + 7 + counter*13, player)
				ui.addTextArea(id..902+counter, '<g>'..i, player, x+50, y + 4 + counter*13, nil, nil, 0xff0000, 0xff0000, 0, true)
				counter = counter + 1
			end
			ui.addTextArea(id..900, '<font color="#ebddc3"> '..
				translate('settings_creditsText', player)
				:format(table.concat(credit.creator),
					table.concatFancy(credit.arts, ", ", translate('wordSeparator', player)))
				, player, x, y -23, 485, 200, 0xff0000, 0xff0000, 0, true)
			ui.addTextArea(id..901, '<font color="#ebddc3"> '..
				translate('settings_creditsText2', player)
				:format(table.concatFancy(credit.help, ", ", translate('wordSeparator', player)))
				, player, x, y + 145, 485, nil, 0xff0000, 0xff0000, 0, true)

		elseif selectedWindow == 4 then
			players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage('17136fe68cc.png', ":26", 520, y - 20, player)
			ui.addTextArea(id..900, '<font color="#ebddc3" size="10"> '..translate('settings_donateText', player), player, x, y -23, 365, 200, 0xff0000, 0xff0000, 0, true)
			--ui.addTextArea(id..901, '<font size="10"><rose>'..translate('settings_donateText2', player), player, x, y +112, 485, nil, 0xff0000, 0xff0000, 0, true)

			button(5, translate('settings_donate', player), function(player) TFM.chatMessage('<rose>https://a801-luadev.github.io/?redirect=mycity', player) end, x+50, y+150, 250)
		end
		ui.addTextArea(id..899, '', player, x + (window-1)*123.5, y + 197, 110, 15, 0xbdbdbd, 0xbdbdbd, 0.5, true)
	end
	for i, v in next, {translate('settings_help', player), translate('settings_settings', player), translate('settings_credits', player), translate('settings_donate', player)} do 
		button(i, v, function()
			if i == selectedWindow then return end
			player_removeImages(players[player]._modernUISelectedItemImages[1])
			for i = 0, 3 do 
				ui.removeTextArea(id..(955+i), player)
			end
			for i = 899, 931 do 
				ui.removeTextArea(id..i, player)
			end
			showOptions(i)
		end, x + (i-1)*123.5, y + 197)
	end
	showOptions(1)
	return setmetatable(self, modernUI)
end

--[[ interfaces/toRewrite/oldInterface.lua ]]--
ui.addTextArea = function(id, text, player, x, y, width, height, color1, color2, alpha, followPlayer, callback, args)
		if players[player] and players[player].settings.mirroredMode == 1 then
			if not text:find('align="center"') and not text:find('align="left"') and not text:find('align="right"') then 
				text = '<p align="right">'..text
			elseif text:find('align="right"') or text:find("align='right'") then 
				text = text:gsub('right', 'left')
			end
		end
		if callback and players[player] then 
			players[player]._modernUIOtherCallbacks[#players[player]._modernUIOtherCallbacks+1] = {event = callback, callbacks = args}
			text = '<a href="event:modernUI_CallbackEvent_'..#players[player]._modernUIOtherCallbacks..'">'..text
		end
		return addTextArea(id, text, player, x, y, width, height, color1, color2, alpha, followPlayer)
end
removeImages = function(player)
    if not players[player] then return end
    if not players[player].images then 
    	players[player].images = {}
    end
    for i = 1, #players[player].images do
        removeImage(players[player].images[i])
    end
end
addButton = function(id, text, player, x, y, width, height, blocked, ...)
	ui.addTextArea(id+1, '', player, x-1, y-1, width, height, 0x97a6aa, 0x97a6aa, 1, true)
	ui.addTextArea(id+2, '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
	if blocked then
		ui.addTextArea(id+3, '', player, x, y, width, height, 0x22363c, 0x22363c, 1, true)
		ui.addTextArea(id+4, '<p align="center"><font color="#999999">'..text, player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true)
	else
		ui.addTextArea(id+3, '', player, x, y, width, height, 0x314e57, 0x314e57, 1, true)
		ui.addTextArea(id+4, '<p align="center">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, ...)
	end
end
showPopup = function(id, player, title, text, x, y, width, height, button, type, arg, ativado)
	eventTextAreaCallback(0, player, 'closebag', true)
	local txt = text
	local x = x - 12
	ui.addTextArea(id..'879', '', player, -5, -5, 820, 420, 1, 1, 0.5, true)
	ui.addTextArea(id..'880', '', player, x+-2, y+18, width+24, height+14, 0x2E221B, 0x2E221B, 1, true)
    ui.addTextArea(id..'881', '', player, x-1, y+19, width+22, height+12, 0x78462b, 0x78462b, 1, true)

    ui.addTextArea(id..'886', '', player, x+2, y+22, width+16, height+6, 0x171311, 0x171311, 1, true)
    ui.addTextArea(id..'887', '', player, x+3, y+23, width+14, height+4, 0x0C191C, 0x0C191C, 1, true)

	if title then 
		ui.addTextArea(id..'888', '\n'..txt, player, x+4, y+28, width+12, height+-2, 0x152d30, 0x152d30, 1, true)
   		ui.addTextArea(id..'889', '', player, x-2, y+10, width+24, 23, 0x110a08, 0x110a08, 1, true)
    	ui.addTextArea(id..'890', '<p align="center"><font size="10" color="#ffd991">'..title, player, x-1, y+11, width+22, 20, 0x38251a, 0x38251a, 1, true)
    else 
    	ui.addTextArea(id..'888', txt, player, x+4, y+24, width+12, height+2, 0x152d30, 0x152d30, 1, true)
    	players[player].callbackImages[#players[player].callbackImages+1] = addImage("155cbe99c72.png", "&1", x-8, y+12, player)
    	players[player].callbackImages[#players[player].callbackImages+1] = addImage("155cbea943a.png", "&1", (x+width)+1, y+12, player)
    end 

    players[player].callbackImages[#players[player].callbackImages+1] = addImage("155cbe97a3f.png", "&1", x-8, (y+height)+10, player)
    players[player].callbackImages[#players[player].callbackImages+1] = addImage("155cbe9bc9b.png", "&1", (x+width)+1, (y+height)+10, player)

	if not button then
    	ui.addTextArea(id..'891', '', player, x+14, y+height-20+25, width-10, 15, 0x97a6aa, 0x97a6aa, 1, true)
		ui.addTextArea(id..'892', '', player, x+16, y+height-20+27, width-10, 15, 0x1, 0x1, 1, true)
    	ui.addTextArea(id..'893', '<p align="center"><a href="event:close3_'..id..'"><N>'.. translate('close', player) ..'</a>', player, x+15, y+height-20+26, width-10, nil, 0x314e57, 0x314e57, 1, true)
	end
	if type == 6 then
    	ui.addTextArea(id..'891', '', player, x+8, y+height-20+25, width -5 -width/2, 15, 0x97a6aa, 0x97a6aa, 1, true)
		ui.addTextArea(id..'892', '', player, x+10, y+height-20+27, width -5 -width/2, 15, 0x1, 0x1, 1, true)
    	ui.addTextArea(id..'893', '<p align="center"><a href="event:verify_'..arg..'"><N>'..translate('submit', player) ..'</a>', player, x+9, y+height-20+26, width -5 -width/2, 15, 0x314e57, 0x314e57, 1, true)
    	ui.addTextArea(id..'894', '', player, x +width/1.7 - 10, y+height-20+25, width -5 -width/2, 15, 0x97a6aa, 0x97a6aa, 1, true)
		ui.addTextArea(id..'895', '', player, x +width/1.7 + 2 - 10, y+height-20+27, width -5 -width/2, 15, 0x1, 0x1, 1, true)
    	ui.addTextArea(id..'896', '<p align="center"><a href="event:close3_'..id..'"><N>'..translate('cancel', player)..'</a>', player, x +width/1.7 +1 - 10, y+height-20+26, width -5 -width/2, 15, 0x314e57, 0x314e57, 1, true)
	elseif tostring(type):sub(1, 1) == '9' then ----------------- RESPONSÁVEL POR CARREGAR AS LOJAS DE ITENS
		local whatToSell = tonumber(type:sub(3))
		if type:sub(3, 3) == '-' then
			whatToSell = 0
		end
		
		players[player].shopMenuType = type:sub(3)
		players[player].shopMenuHeight = height
		local list = {
			[0] = {type:sub(4)}, -- IF IS A SINGLE ITEM
			[1] = {'energyDrink_Basic', 'energyDrink_Mega', 'energyDrink_Ultra'}, -- MARKET
			[5] = {'coffee', 'hotChocolate', 'milkShake'}, -- CAFÉ
			[6] = {'bag'}, -- BAG
		}

		for i, v in next, list[whatToSell] do
			if bagItems[v].type == 'food' then
				ui.addTextArea(id..(894+(i-1)*3), '<textformat leftmargin="-5"><g><font size="9">'.. string.format(translate('energyInfo', player) ..'\n'.. translate('hungerInfo', player), bagItems[v].power and bagItems[v].power or 0, bagItems[v].hunger and bagItems[v].hunger or 0), player, x+15, y+73 + (i-1)*68, width-10, 28, 0x314e57, 0x314e57, 0.5, true)
			elseif bagItems[v].type == 'complementItem' then
				ui.addTextArea(id..(894+(i-1)*3), '<textformat leftmargin="-5"><p align="center"><g><font size="9">"'.. translate('itemDesc_'..v, player):format(bagItems[v].complement) .. '"', player, x+15, y+73 + (i-1)*68, width-10, 28, 0x314e57, 0x314e57, 0.5, true)
			elseif bagItems[v].type == 'bag' then
				if players[player].bagLimit < 45 then
					ui.addTextArea(id..(894+(i-1)*3), '<textformat leftmargin="-5"><g><font size="9">'.. translate('itemDesc_bag', player):format(bagItems[v].capacity), player, x+15, y+73 + (i-1)*68, width-10, 28, 0x314e57, 0x314e57, 0.5, true)
				else
					ui.addTextArea(id..(894+(i-1)*3), '<textformat leftmargin="-5"><r><font size="9">'.. translate('error_maxStorage', player), player, x+15, y+73 + (i-1)*68, width-10, 28, 0x314e57, 0x314e57, 0.5, true)
				end
			else
				ui.addTextArea(id..(894+(i-1)*3), '<textformat leftmargin="-5"><p align="center"><g><font size="9">"'.. translate('itemDesc_'..v, player) .. '"', player, x+15, y+73 + (i-1)*68, width-10, 28, 0x314e57, 0x314e57, 0.5, true)
			end
			if players[player].coins >= bagItems[v].price then
    			ui.addTextArea(id..(895+(i-1)*3), translate('item_'..v, player), player, x+15, y+50 + (i-1)*68, width-10, 20, 0x314e57, 0x314e57, 1, true)
				if bagItems[v].type == 'bag' and players[player].bagLimit >= 45 then
					ui.addTextArea(id..(896+(i-1)*3), '', player, x+15, y+50 + (i-1)*68, width-10, 20, 0x314e57, 0x314e, 0, true)
				else
					ui.addTextArea(id..(896+(i-1)*3), '<p align="right"><a href="event:buyBagItem_'.. v ..'"><vp>$'.. bagItems[v].price ..'</p>', player, x+15, y+50 + (i-1)*68, width-10, 20, 0x314e57, 0x314e, 0, true)
				end
			else
				ui.addTextArea(id..(895+(i-1)*3), '<font color="#999999">'.. translate('item_'..v, player), player, x+15, y+50 + (i-1)*68, width-10, 20, 0x22363c, 0x22363c, 1, true)
				ui.addTextArea(id..(896+(i-1)*3), '<p align="right"><r>$'.. bagItems[v].price ..'</p>', player, x+15, y+50 + (i-1)*68, width-10, 20, 0x314e57, 0x314e, 0, true)
			end
		end
	elseif type == 10 then
		ui.addTextArea(id..'891', '', player, x+8, y+height-20+25, width -5 -width/2, 15, 0x97a6aa, 0x97a6aa, 1, true)
		ui.addTextArea(id..'892', '', player, x+10, y+height-20+27, width -5 -width/2, 15, 0x1, 0x1, 1, true)
		ui.addTextArea(id..'893', '<p align="center"><a href="event:getCode"><N>'..translate('submit', player) ..'</a>', player, x+9, y+height-20+26, width -5 -width/2, 15, 0x314e57, 0x314e57, 1, true)
		ui.addTextArea(id..'894', '', player, x +width/1.7 - 10, y+height-20+25, width -5 -width/2, 15, 0x97a6aa, 0x97a6aa, 1, true)
		ui.addTextArea(id..'895', '', player, x +width/1.7 + 2 - 10, y+height-20+27, width -5 -width/2, 15, 0x1, 0x1, 1, true)
		ui.addTextArea(id..'896', '<p align="center"><a href="event:close3_'..id..'"><N>'..translate('cancel', player)..'</a>', player, x +width/1.7 +1 - 10, y+height-20+26, width -5 -width/2, 15, 0x314e57, 0x314e57, 1, true)

		local keys = {'QWERTYUIOP', 'ASDFGHJKL', 'ZXCVBNM'}
		local x = 400 - 243 * 0.5
		local y = 180
		for i = 1, #keys[1] do
			local letter = keys[1]:sub(i, i)
			ui.addTextArea(id..(900+i), "<a href='event:keyboard_"..letter.."'><p align='center'>"..letter.."</p></a>", player, x + (i-1)*24 + 6, y+56, 15, 17, 0x122528, 0x183337, alpha, true)
		end
		for i = 1, #keys[2] do
			local letter = keys[2]:sub(i, i)
			ui.addTextArea(id..(913+i), "<a href='event:keyboard_"..letter.."'><p align='center'>"..letter.."</p></a>", player, x + (i-1)*24 + 17, y+81, 15, 17, 0x122528, 0x183337, alpha, true)
		end
		for i = 1, #keys[3] do
			local letter = keys[3]:sub(i, i)
			ui.addTextArea(id..(925+i), "<a href='event:keyboard_"..letter.."'><p align='center'>"..letter.."</p></a>", player, x + (i-1)*24 + 42, y+106, 15, 17, 0x122528, 0x183337, alpha, true)
		end
	elseif type == 18 then -- VAULT PASSWORD
		if not players[player].place == 'bank' then return end
		ui.addTextArea(id..'891', '', player, x+14, y+height-20+25, width-10, 15, 0x97a6aa, 0x97a6aa, 1, true)
		ui.addTextArea(id..'892', '', player, x+16, y+height-20+27, width-10, 15, 0x1, 0x1, 1, true)
    	ui.addTextArea(id..'893', '<p align="center"><a href="event:closeVaultPassword"><N>'.. translate('close', player) ..'</a>', player, x+15, y+height-20+26, width-10, 15, 0x314e57, 0x314e57, 1, true)

		for i = 1, 9 do
			ui.addTextArea(id..(889+(i-1)*14), '<vp><p align="center">'..i, player, x+25 + math.floor((i-1)%3)*26, y+26+50 + math.floor((i-1)/3)*26, 15, 15, 0x314e57, 0x314e57, 0.5, true)
			ui.addTextArea(id..(890+(i-1)*14), '<a href="event:insertVaultPassword_'..i..'">'..string.rep('\n', 5), player, x+22 + math.floor((i-1)%3)*26, y+23+50 + math.floor((i-1)/3)*26, 20, 20, 0xff0000, 0xff0000, 0, true)
		end
		local teclas = {'*', '0', '#'}
		for i = 1, 3 do
			ui.addTextArea(id..(889+(8+i)*14), '<vp><p align="center">'..teclas[i], player, x+25 + (i-1)*26, y+26+50 + math.floor((9+i-1)/3)*26, 15, 15, 0x314e57, 0x314e57, 0.5, true)
			ui.addTextArea(id..(890+(8+i)*14), '<a href="event:insertVaultPassword_'..teclas[i]..'">'..string.rep('\n', 5), player, x+22 + (i-1)*26, y+23+50 + math.floor((9+i-1)/3)*26, 20, 20, 0xff0000, 0xff0000, 0, true)
		end
		local password = ''
		if players[player].bankPassword then
			for i = 1, #players[player].bankPassword do
				password = password .. players[player].bankPassword:sub(i, i).. ' '
			end
			if #players[player].bankPassword < 4 then
				password = password .. string.rep('_ ', 4 - #players[player].bankPassword)
			else
				if players[player].bankPassword == room.bankVaultPassword then
					password = '<vp>'.. password
					addTimer(function()
						room.bankRobStep = 'vault'
						ui.removeTextArea(-510, nil)
						removeImage(room.bankDoors[1])
						removeGround(9999)
						for players in next, ROOM.playerList do
							eventTextAreaCallback(0, players, 'closeVaultPassword', true)
						end
					end, 1000, 1)
				else
					password = '<r>'.. password
					ui.addTextArea(id..(890+(8+5)*14), '', player, x+20, y+20, width, height, 0xff0000, 0xff0000, 0, true)

					addTimer(function()
						password = '_ _ _ _'
						ui.removeTextArea(id..(890+(8+5)*14), player)
						ui.addTextArea(id..(890+(8+4)*14), '<p align="center"><font color="#ffffff" size="15">'..password, player, x+10 , y+25, width, 40, 0xff0000, 0xff0000, 0, true)
					end, 1000, 1)
				end
				players[player].bankPassword = nil
			end
		else
			password = '_ _ _ _'
		end
		ui.addTextArea(id..(890+(8+4)*14), '<p align="center"><font color="#ffffff" size="15">'..password, player, x+10 , y+25, width, 40, 0xff0000, 0xff0000, 0, true)
	end
	if type == 6 or type == 5 then
		local keys = {'QWERTYUIOP', 'ASDFGHJKL', 'ZXCVBNM'}
		local x = 400 - 243 * 0.5
		local y = 120
		for i = 1, #keys[1] do
			local letter = keys[1]:sub(i, i)
			ui.addTextArea(id..(900+i), "<a href='event:keyboard_"..letter.."'><p align='center'>"..letter.."</p></a>", player, x + (i-1)*24 + 6, y+56, 15, 17, 0x122528, 0x183337, alpha, true)
		end
		for i = 1, #keys[2] do
			local letter = keys[2]:sub(i, i)
			ui.addTextArea(id..(913+i), "<a href='event:keyboard_"..letter.."'><p align='center'>"..letter.."</p></a>", player, x + (i-1)*24 + 17, y+81, 15, 17, 0x122528, 0x183337, alpha, true)
		end
		for i = 1, #keys[3] do
			local letter = keys[3]:sub(i, i)
			ui.addTextArea(id..(925+i), "<a href='event:keyboard_"..letter.."'><p align='center'>"..letter.."</p></a>", player, x + (i-1)*24 + 42, y+106, 15, 17, 0x122528, 0x183337, alpha, true)
		end
	end
end
sendMenu = function(id, player, text, x, y, width, height, alpha, close, arg, prof, interface, tela, type, coin, showCoin)
	local playerData = players[player]
	if type and type ~= 16 and type ~= -10 then
		ui.addTextArea(9901327, '', player, -5, -5, 820, 420, 1, 1, 0.5, true)
	end
    ui.addTextArea(id..'0', '', player, x+-2, y+18, width+24, height+14, 0x2E221B, 0x2E221B, alpha, true)
    ui.addTextArea(id..'00', '', player, x+-1, y+19, width+22, height+12, 0x78462b, 0x78462b, alpha, true)
    ui.addTextArea(id..'000', '', player, x, y+20, width+20, height+10, 0x171311, 0x171311, alpha, true)
    ui.addTextArea(id..'0000', '', player, x+3, y+23, width+14, height+4, 0x0C191C, 0x0C191C, alpha, true)
    ui.addTextArea(id..'00000', '', player, x+4, y+24, width+12, height+2, 0x24474D, 0x24474D, alpha, true)
    ui.addTextArea(id..'000000', '', player, x+5, y+25, width+10, height+0, 0x183337, 0x183337, alpha, true)
    ui.addTextArea(id..'0000000', text, player, x+6, y+26, width+8, height+-2, 0x122528, 0x122528, alpha, true)

	if close then
    	ui.addTextArea(id..'00000000', '', player, x+15, y+height-20+25, width-10, 15, 0x97a6aa, 0x97a6aa, alpha, true)
		ui.addTextArea(id..'000000000', '', player, x+15, y+height-20+27, width-10, 15, 0x1, 0x1, alpha, true)
	  	ui.addTextArea(id..'0000000000', '<p align="center"><a href="event:fechar@'..id..'"><N>'.. translate('close', player) ..'</a>', player, x+15, y+height-20+26, width-10, nil, 0x314e57, 0x314e57, alpha, true)
	end
	if tela then
		ui.addTextArea(id..'00000000', '', player, x+15, y+height-20+10, width-10, 15, 0x5D7D90, 0x5D7D90, alpha, true)
    	ui.addTextArea(id..'000000000', '', player, x+15, y+height-20+12, width-10, 15, 0x11171C, 0x11171C, alpha, true)
    	ui.addTextArea(id..'0000000000', '<p align="center"><a href="event:fechar@'..id..'"><N>'.. translate('close', player) ..'</a>', player, x+15, y+height-20+11, width-10, 15, 0x3C5064, 0x3C5064, alpha, true)
	end
	if type == 5 then
		ui.addTextArea(id..'000', '', player, x+-2, y+18, width+24, height+14, 0x2E221B, 0x2E221B, alpha, true)
        ui.addTextArea(id..'001', '', player, x+-1, y+19, width+22, height+12, 0x986742, 0x986742, alpha, true)
        -- bordas
        ui.addTextArea(id..'002', '', player, x + width - 9, y+19, 30, height/4, 0x78462b, 0x78462b, alpha, true)
		ui.addTextArea(id..'003', '', player, x - 1, y+19, 30, height/4, 0x78462b, 0x78462b, alpha, true)
		ui.addTextArea(id..'004', '', player, x - 1, ((y + height) - height/4) + 31.5, width/4, height/4, 0x78462b, 0x78462b, alpha, true)
		ui.addTextArea(id..'005', '', player, x + width - 54, ((y + height) - height/4) + 31.5, width/4, height/4, 0x78462b, 0x78462b, alpha, true)
		  -----
        ui.addTextArea(id..'006', '', player, x+2, y+22, width+16, height+6, 0x171311, 0x171311, alpha, true)
        ui.addTextArea(id..'007', '', player, x+3, y+23, width+14, height+4, 0x0C191C, 0x0C191C, alpha, true)
		ui.addTextArea(id..'008', '', player, x+4, y+28, width+12, height+-2, 0x152d30, 0x152d30, alpha, true)

        ui.addTextArea(id..'011', '', player, x-2, y+10, width+24, 17, 0x110a08, 0x110a08, alpha, true)
        ui.addTextArea(id..'012', '<p align="center"><font size="10" color="#ffd991">'..text, player, x-1, y+11, width+22, 15, 0x38251a, 0x38251a, alpha, true)

        ui.addTextArea(id..'013', '', player, x+14, y+height-20+25, width-10, 15, 0x97a6aa, 0x97a6aa, alpha, true)
    	ui.addTextArea(id..'014', '', player, x+16, y+height-20+27, width-10, 15, 0x1, 0x1, alpha, true)
        ui.addTextArea(id..'015', '<p align="center"><a href="event:close2"><N>'.. translate('close', player) ..'</a>', player, x+15, y+height-20+26, width-10, 15, 0x314e57, 0x314e57, alpha, true)
	elseif type == 11 then
		local names = {[1] = {}, [2] = {},}
		for i = 1, 4 do
			for v = 1, 2 do
				if room.hospital[i][v].name then
					names[v][#names[v]+1] = '<cs>'..room.hospital[i][v].name
				else
					names[v][#names[v]+1] = '<n>---'
				end
			end
		end
	    table.sort(names[1], function(a, b) return a > b end)
	    table.sort(names[2], function(a, b) return a > b end)

		ui.addTextArea(id..'001', '<p align="right"><textformat leading="9">'..table.concat(names[1], '<br>'), player, 400 - 200 * 0.5, 225, 85, 120, 0xffff, 0xffff, 0, true)
		ui.addTextArea(id..'002', '<textformat leading="9">'..table.concat(names[2], '<br>'), player, 515 - 200 * 0.5, 225, 85, 120, 0xffff, 0xffff, 0, true)
		ui.addTextArea(1020, '<p align="center"><font size="15" color="#ff0000"><a href="event:closeInfo_33"><b>X', player, 470, 180, 60, 50, 0x122528, 0x122528, 0, true)		
	elseif type == 15 then
		if playerData.joinMenuPage > 1 then
			addButton(id..'081', '<a href="event:joiningMessage_back">«', player, 550, 325, 10, 10)
		else
			addButton(id..'081', '«', player, 550, 325, 10, 10, true)
		end
		if playerData.joinMenuPage == versionLogs[playerData.gameVersion].maxPages then
			addButton(id..'091', '<a href="event:joiningMessage_close">'..translate('close', player), player, 550, 350, 150, 10)
			addButton(id..'086', '»', player, 690, 325, 10, 10, true)
		else
			addButton(id..'091', translate('close', player), player, 550, 350, 150, 10, true)
			addButton(id..'086', '<a href="event:joiningMessage_next">»', player, 690, 325, 10, 10)
		end
		ui.addTextArea(id..'080', '<p align="left">'..translate('$VersionText', player), player, x+6, y+70, 430, height+-2, 0x122528, 0xff0000, 0, true)
		addButton(id..'097', playerData.joinMenuPage..'/'..versionLogs[playerData.gameVersion].maxPages, player, 575, 325, 100, 10, true)
		playerData.joinMenuImages[#playerData.joinMenuImages+1] = addImage(versionLogs[playerData.gameVersion].images[playerData.joinMenuPage], '&1', 550, 100, player)
	elseif type == 18 then -- RECIPES
		if playerData.callbackImages[1] then
			for i, v in next, playerData.callbackImages do
				removeImage(playerData.callbackImages[i])
			end
			playerData.callbackImages = {}
		end
		local txt1 = ''
		local txt2 = ''
		local minn = (9 * playerData.callbackPages.recipes - 9) + 1
		local maxx = playerData.callbackPages.recipes * 9
		local i = 0
		local ii = 0
		x = x + 10
		y = y + 30
		for item, v in next, recipes do
			i = i + 1
			ii = ii + 1
			if ii >= minn and ii <= maxx then 
				if i > 9 then
					i = i - (9 * playerData.callbackPages.recipes - 9)
				end
				sendMenu(id+i, player, '', ((i-1)%3)*105+x-1, y+26 + math.floor((i-1)/3)*85, 70, 60, 1)
				addButton(id..'0'..(10+(i-1)*5), '<a href="event:showRecipe_'..item..'">+', player, x+7 + 63 +((i-1)%3)*105, y+98+ math.floor((i-1)/3)*85, 10, 10)
				playerData.callbackImages[#playerData.callbackImages+1] = addImage(bagItems[item].png and bagItems[item].png or '16bc368f352.png', "&70", x+17+((i-1)%3)*105, y+math.floor((i-1)/3)*85+48, player)
			end
		end
		local totalPages = math.ceil(ii/9)
		if playerData.callbackPages.recipes == 1 then
			addButton(id..'081', '«', player, 500, 315, 10, 10, true)
		else
			addButton(id..'081', '<a href="event:changePage_recipes_back_'..totalPages..'">«', player, 500, 315, 10, 10)
		end
		if playerData.callbackPages.recipes == totalPages then
			addButton(id..'086', '»', player, 600, 315, 10, 10, true)
		else
			addButton(id..'086', '<a href="event:changePage_recipes_next_'..totalPages..'">»', player, 600, 315, 10, 10)
		end
		addButton(id..'091', playerData.callbackPages.recipes..'/'..totalPages, player, 525, 315, 60, 10, true)
	end
end
showVehiclesButton = function(player, expandedInterface)
	local x = 445
	if expandedInterface then 
		x = 546
	end
	ui.addTextArea(98900000002, string.rep('\n', 4), player, x, 360, 50, 50, 1, 1, 0, true,
		function(player)
			modernUI.new(player, 520, 300, translate('vehicles', player))
			:addButton('1729f83fb5f.png', function() 
				modernUI.new(player, 240, 180, translate('confirmButton_tip', player), translate('tip_vehicle', player), 'errorUI')
				:build()
			end)
			:build()
			:showPlayerVehicles()
		end)
end
showOptions = function(player)
	local playerInfo = players[player]
	if playerInfo.blockScreen or playerInfo.holdingItem or playerInfo.hospital.hospitalized or playerInfo.editingHouse then return end
	if not playerInfo.robbery.robbing and not playerInfo.robbery.arrested then
		local images = playerInfo.interfaceImg
		if images[1] then 
			for i = 1, #images do
				removeImage(images[i])
			end
			players[player].interfaceImg = {}
			images = players[player].interfaceImg
		end
		for i = 1, 4 do 
			ui.removeTextArea(98900000000+i, player)
		end
		local function showBag()
			players[player].interfaceImg[#images+1] = addImage("170fa5dddd8.png", ":2", 298, 353, player)
			players[player].interfaceImg[#images+1] = addImage(bagUpgrades[playerInfo.bagLimit], ":3", 307, 362, player)

			ui.addTextArea(98900000001, string.rep('\n', 4), player, 300, 360, 50, 50, 1, 1, 0, true,
				function(player)
					modernUI.new(player, 520, 300, translate('bag', player))
					:build()
					:showPlayerItems(playerInfo.bag)
				end)
		end 
		local function showCar()
			players[player].interfaceImg[#images+1] = addImage("170fa60a8a4.png", ":3", 440, 353, player)
			players[player].interfaceImg[#images+1] = addImage("15b318c5f77.png", ":4", 452, 366, player)
			showVehiclesButton(player)
		end
		local function showHouse()
			players[player].interfaceImg[#images+1] = addImage("170fa60a8a4.png", ":3", 440, 353, player)
			players[player].interfaceImg[#images+1] = addImage("15a197246f0.png", ":5", 451, 357, player)
			ui.addTextArea(98900000002, string.rep('\n', 4), player, 445, 360, 50, 50, 1, 1, 0, true,
				function(player)
					modernUI.new(player, 240, 120, translate('houseSettings', player))
					:build()
					:showHouseSettings()
				end)
		end
		local allowedVehiclesPlaces = {'town', 'island', 'mine', 'mine_labyrinth', 'mine_escavation'}
		if table.contains(allowedVehiclesPlaces, playerInfo.place) then
			showCar()
		elseif playerInfo.place:find('house') and checkLocation_isInHouse(player) then
			showHouse()
		end
		showBag()

		local size = playerInfo.coins < 999999 and 16 or 13
		ui.addTextArea(98900000000, '<b><font size="'..size..'" color="#371616"><p align="center">$'..playerInfo.coins, player, 350, size == 16 and 366 or 368, 100, 50, 1, 1, 0, true)
	end
end
closeInterface = function(player, found, coin, placingItem, radioactiveMine, item, expandInterface)
	local playerInfo = players[player]
	if playerInfo.holdingItem and not placingItem then return end
	local images = playerInfo.interfaceImg
	if images[1] then 
		for i = 1, #images do
			removeImage(images[i])
		end
		players[player].interfaceImg = {}
		images = players[player].interfaceImg
	end
    for i = 1, 4 do 
		ui.removeTextArea(98900000000+i, player)
	end

    if placingItem then
    	ui.addTextArea(9901327, '', player, -5, -5, 820, 420, 1, 1, 0.5, true)
		ui.addTextArea(98900000019, '<p align="center"><b><font color="#00FF00" size="20"><a href="event:confirmPosition">✓', player, 350, 330, 100, nil, 1, 1, 0, true)
		if playerInfo.mouseSize == 1 then
			local image = ROOM.playerList[player].isFacingRight and bagItems[playerInfo.holdingItem].holdingImages[2] or bagItems[playerInfo.holdingItem].holdingImages[1]
			local x = ROOM.playerList[player].isFacingRight and bagItems[playerInfo.holdingItem].holdingAlign[2][1] or bagItems[playerInfo.holdingItem].holdingAlign[1][1]
			local y = ROOM.playerList[player].isFacingRight and bagItems[playerInfo.holdingItem].holdingAlign[2][2] or bagItems[playerInfo.holdingItem].holdingAlign[1][2]
			if playerInfo.holdingImage then
				removeImage(playerInfo.holdingImage)
				playerInfo.holdingImage = nil
			end
			playerInfo.holdingImage = addImage(image, '$'..player, x, y)
		end
    end
	if expandInterface then
		players[player].interfaceImg[#images+1] = addImage("170fa9bd6a6.png", ":1", 248, 355, player)
		if not playerInfo.robbery.arrested and not playerInfo.hospital.hospitalized then
			players[player].interfaceImg[#images+1] = addImage("170fa60a8a4.png", ":3", 541, 353, player)
			players[player].interfaceImg[#images+1] = addImage("15b318c5f77.png", ":3", 553, 366, player)
			showVehiclesButton(player, true)
		end
	end
end
closeMenu = function(id, player)
    for x = 13,0,-1 do
        id = id..'0'
        ui.removeTextArea(id, player)
    end
	ui.removeTextArea(9901327, player)
    removeImages(player)
    removeImage(players[player].bannerLogin)
end

--[[ interfaces/errorAlert.lua ]]--
alert_Error = function(player, title, text, args)
	if not args then args = '?' end
	local title = lang.en[title] and translate(title, player) or title
	local text = lang.en[text] and translate(text, player) or text
	modernUI.new(player, 240, 120, title, text:format(args), 'errorUI')
	:build()
end

--[[ npcs/npcDialogs.lua ]]--
for commu, v in next, lang do
	for id, message in next, v do 
		if id:find('npcDialog_') then 
			if not npcDialogs.normal[commu] then npcDialogs.normal[commu] = {} end
			local npc = id:sub(11)
			local message = message
			local dialog = {}
			for text in message:gmatch('[^\n]+') do 
				dialog[#dialog+1] = text
			end
			npcDialogs.normal[commu][npc] = dialog
		end
	end
	for questID, properties in next, v.quests do
		for questStep, stepData in next, properties do
			if tonumber(questStep) then 
				if not npcDialogs.quests[commu] then npcDialogs.quests[commu] = {} end
				if not npcDialogs.quests[commu][questID] then npcDialogs.quests[commu][questID] = {} end
				if not npcDialogs.quests[commu][questID][questStep] then npcDialogs.quests[commu][questID][questStep] = {} end
				local message = {}
				if stepData.dialog then
					for msg in stepData.dialog:gmatch('[^\n]+') do 
						message[#message+1] = msg
					end
				end
				npcDialogs.quests[commu][questID][questStep] = message
			end
		end
	end
end

--[[ npcs/gameNpcs/_main.lua ]]--
local gameNpcs = {characters = {}, robbing = {}, orders = {canOrder = {}, orderList = {}, activeOrders = {}, trashImages = {}}}

system.looping(function()
	updateDialogs(4)
end, 10)

--[[ npcs/gameNpcs/addCharacter.lua ]]--
gameNpcs.addCharacter = function(name, image, player, x, y, properties)
	if not properties then properties = {} end
	local playerData = players[player]
	if properties.questNPC and playerData._npcsCallbacks.questNPCS[name] then return end
		local type = properties.type and properties.type or '!'
		local canClick = true 
		local canOrder = true 
		local imageFixAlign = {0, 0}
		if not image[2] then 
			image[2] = image[1]
			imageFixAlign = {0, -23}
		end
		local npcID = playerData._npcsAdded

	local color = '6c99d6'
	if properties.job then
		color = jobs[properties.job].color 
		if properties.jobConfirm then 
			properties.callback = function(player) job_invite(properties.job, player) end 
		end
	elseif properties.color then
		color = properties.color
	elseif properties.canRob then 
		color = 'FF69B4'
		canOrder = false
	elseif properties.questNPC then
		color = 'b69efd'
		canOrder = false
		playerData._npcsCallbacks.questNPCS[name] = {id = npcID}
		local newName = name:gsub('%$', '')
		canClick = quest_checkIfCanTalk(playerData.questStep[1], playerData.questStep[2], newName)
		if gameNpcs.characters[newName] and not image[1] then
			local v = gameNpcs.characters[newName]
			x = v.x 
			y = v.y 
			image[1] = '171a497f4e2.png'
			image[2] = v.image2
			imageFixAlign = {0, 0}
			for id, obj in next, playerData._npcsCallbacks.starting do 
				if obj.name == newName then
					playerData._npcsCallbacks.ending[npcID] = {callback = playerData._npcsCallbacks.starting[id].callback, name = name}
					break
				end
			end
		end
	end
	if properties.formatDialog then
		playerData._npcsCallbacks.formatDialog[name] = properties.formatDialog
	end

	local callback = 'npcDialog_talkWith_'..npcID..'_'..name..'_'..image[2]
	if properties.callback then 
		callback = 'npcDialog_talkWith_'..npcID..'_otherCallback'
		playerData._npcsCallbacks.starting[npcID] = {callback = properties.callback, name = name}
	elseif properties.endEvent then 
		playerData._npcsCallbacks.ending[npcID] = {callback = properties.endEvent, name = name}
	elseif properties.sellingItems then 
		callback = 'npcDialog_talkWith_'..npcID..'_otherCallback'
		playerData._npcsCallbacks.starting[npcID] = {callback = function(player) showNPCShop(player, name) end, name = name}
	elseif properties.questNPC then 
		callback = callback .. '_questDialog'
	end

		if not gameNpcs.characters[name] then 
			if canOrder then gameNpcs.orders.canOrder[name] = true end

			gameNpcs.characters[name] = {visible = true, x = x, y = y, type = type, players = {}, runningImages = nil, image = image[1], image2 = image[2], callback = callback, color = color, fixAlign = imageFixAlign}
			if properties.canRob then 
				gameNpcs.robbing[name] = {x = x+50, y = y+80, cooldown = properties.canRob.cooldown} 				
			end
			imgsToLoad[#imgsToLoad+1] = image[1]
			imgsToLoad[#imgsToLoad+1] = image[2]
		end 

	playerData._npcsCallbacks.clickArea[npcID] = {x + 50, y + 80, name}

	gameNpcs.characters[name].players[player] = {id = npcID}
	if gameNpcs.characters[name].visible and players[player] then 
		gameNpcs.characters[name].players[player] = {id = npcID, image = addImage(image[1], type.."1000", x, y, player)} 

		local id = -89000+(npcID*6)
		gameNpcs.setNPCName(id, name:gsub('%$', ''), callback, player, x, y, color, canClick)
	end 
	players[player]._npcsAdded = npcID + 1
end

--[[ npcs/gameNpcs/reAddNPC.lua ]]--
gameNpcs.reAddNPC = function(npcName)
	local npc = gameNpcs.characters[npcName]
	if npc.visible then return end
	local image = npc.image
	local type = npc.type
	local x = npc.x
	local y = npc.y
	local callback = npc.callback
	local color = npc.color
	npc.visible = true
	for player, v in next, npc.players do 
		local id = -89000+(v.id*6)
		gameNpcs.setNPCName(id, npcName, callback, player, x, y, color, true)
		v.image = addImage(image, type.."1000", x, y, player)
	end
end

--[[ npcs/gameNpcs/removeNPC.lua ]]--
gameNpcs.removeNPC = function(npcName, target)
	local npc = gameNpcs.characters[npcName]
	if not target then 
		for player, v in next, npc.players do
			if v.image then  
				removeImage(v.image)
				gameNpcs.removeTextAreas(v.id, player)
				v.image = nil
			end
		end
		npc.visible = false 
	else
		local v = npc.players[target]
		if v.image then 
			removeImage(v.image)
			v.image = nil
			gameNpcs.removeTextAreas(v.id, target)
		end
	end
end

--[[ npcs/gameNpcs/removeTextAreas.lua ]]--
gameNpcs.removeTextAreas = function(id, player)
	local ID = -89000+(id*6)
	for i = 0, 5 do 
		ui.removeTextArea(ID+i, player)
	end
end

--[[ npcs/gameNpcs/setNPCName.lua ]]--
gameNpcs.setNPCName = function(id, name, callback, player, x, y, color, canClick)
	ui.addTextArea(id+0, "<font color='#000000'><p align='center'>"..name, player, x-1, y+41, 100, nil, 1, 1, 0)
	ui.addTextArea(id+1, "<font color='#000000'><p align='center'>"..name, player, x-1, y+39, 100, nil, 1, 1, 0)
	ui.addTextArea(id+2, "<font color='#000000'><p align='center'>"..name, player, x+1, y+41, 100, nil, 1, 1, 0)
	ui.addTextArea(id+3, "<font color='#000000'><p align='center'>"..name, player, x+1, y+39, 100, nil, 1, 1, 0)
	ui.addTextArea(id+4, "<font color='#"..color.."' size='11'><p align='center'>"..name, player, x, y+40, 100, nil, 1, 1, 0)
	if canClick then 
		ui.addTextArea(id+5, "<textformat leftmargin='1' rightmargin='1'><a href='event:"..callback.."'>" .. string.rep('\n', 4), player, x+25, y+55, 50, 45, 1, 1, 0)
	end
end

--[[ npcs/gameNpcs/setOrder.lua ]]--
gameNpcs.setOrder = function(npcName)
	local npc = gameNpcs.characters[npcName]
	local image = npc.image
	local type = npc.type
	local x = npc.x
	local y = npc.y
	local character = gameNpcs.orders
	local order = table.randomKey(recipes)
	--TFM.chatMessage('O escolhido é: '..npcName)
	character.orderList[npcName] = {order = order, fulfilled = {}}
	character.canOrder[npcName] = nil
	do
		local counter = 0
		local orderPaperList = '' -- orders to show in the restaurant
		player_removeImages(character.trashImages)
		for i, v in next, character.orderList do
			orderPaperList = orderPaperList .. i..'\n\n'
			character.trashImages[#character.trashImages+1] = addImage(bagItems[v.order].png, "_1000", 14455, 1560+counter*28)
			counter = counter + 1
		end
		ui.addTextArea(4444441, '<font size="10">'..orderPaperList, nil, 14495, 1580, nil, nil, 1, 1, 0)
	end
	local images = character.orderList[npcName].fulfilled
	for _, player in next, jobs['chef'].working do
		images[player] = {
			icons = {
				addImage('171c7ac4232.png', type.."1000", x, y-20, player), 
				addImage(bagItems[order].png, type.."1000", x+25, y-20, player),
			},
			completed = false,
		}
	end
	local orderTime = math.random(60*2.5, 60*3)
	addTimer(function(time)
		if time == orderTime then
			local images = character.orderList[npcName].fulfilled
			for player, k in next, images do 
				if not k.completed then
					player_removeImages(k.icons)
				end
			end
			character.orderList[npcName] = nil
			gameNpcs.setOrder(table.randomKey(character.canOrder))
			character.canOrder[npcName] = true
		end
	end, 1000, orderTime)
end

--[[ npcs/gameNpcs/talk.lua ]]--
gameNpcs.talk = function(npc, player)
	local playerData = players[player]
	local lang = playerData.lang
	local npcText = npcDialogs.normal[lang][npc.name] and npcDialogs.normal[lang][npc.name] or (npc.name:find('Souris') and {' '} or npcDialogs.normal[lang]['Natasha'])
	if npc.questDialog then 
		npcText = npcDialogs
			.quests
			  [lang]
			    [playerData.questStep[1]]
			      [playerData.questStep[2]]
	end
	local dialog = npc.text or npcText
	dialog = table.copy(dialog)
	local formatText = playerData._npcsCallbacks.formatDialog[npc.name]

	if formatText == 'fishingLuckiness' then
		local lucky = playerData.lucky[1]
		dialog[3] = dialog[3]:format(lucky.normal..'%', lucky.rare..'%', lucky.mythical..'%')
		dialog[4] = dialog[4]:format(lucky.legendary..'%')
	end

	dialogs[player] = {name = npc.name, text = dialog, length = 0, currentPage = 1, running = true, npcID = npc.npcID, isQuest = npc.questDialog}
    local tbl = players[player]._npcDialogImages

    local alignFix = gameNpcs.characters[npc.name].fixAlign
    if not npcDialogs.normal[lang][npc.name] and npc.image ~= gameNpcs.characters[npc.name].image2 then
    	alignFix = {0, -23}
    end
    tbl[#tbl+1] = addImage('17184484e6b.png', ":0", 0, 0, player)
    tbl[#tbl+1] = addImage('1718435fa5c.png', ":1", 300, 250, player)
    tbl[#tbl+1] = addImage(npc.image, ":2", 270+alignFix[1], 260+alignFix[2], player) 
    tbl[#tbl+1] = addImage('171843a9f21.png', ":3", 270, 330, player)
    npc.name = npc.name:gsub('$', '')
    local font = 15
    if #npc.name > 8 then 
    	font = 12
    elseif #npc.name > 13 then
    	font = 10
    end
	ui.addTextArea(-88000, '<p align="center"><font size="'..font..'" color="#ffffea"><b>'..npc.name, player, 275, 335 + (15-font), 90, 30, 1, 1, 0, true)
	ui.addTextArea(-88001, '', player, 380, 260, 210, 75, 1, 1, 0, true)
	ui.addTextArea(-88002, "<textformat leftmargin='1' rightmargin='1'><a href='event:npcDialog_skipAnimation'>" .. string.rep('\n', 10), player, 300, 250, 300, 100, nil, 1, 0, true)
end

--[[ npcs/gameNpcs/updateDialogBox.lua ]]--
gameNpcs.updateDialogBox = function(id)
	local index = dialogs[id]
	if not index.text[index.currentPage] then return end
	local t = string.sub(index.text[index.currentPage], 1, index.length)
	local text = index.text
	ui.updateTextArea(-88001, '<font color="#f4e0c5">'..t, id)
	ui.updateTextArea(-88002, "<textformat leftmargin='1' rightmargin='1'><a href='event:npcDialog_skipAnimation'>" .. string.rep('\n', 10), id)
	if #t >= #text[index.currentPage] then 
		index.running = false
		index.currentPage = index.currentPage + 1
		index.length = 0
		isQuest = index.isQuest and index.isQuest or 'not'
		ui.updateTextArea(-88002, "<textformat leftmargin='1' rightmargin='1'><a href='event:npcDialog_nextPage_"..index.name.."_"..index.npcID.."_"..isQuest.."_"..index.currentPage.."'>" .. string.rep('\n', 10), id)
	end
end

--[[ npcs/gameNpcs/updateDialogs.lua ]]--
updateDialogs = function(counter)
	for npc, v in next, dialogs do
		if v.running then 
			v.length = v.length + counter
			gameNpcs.updateDialogBox(npc)
		end
	end
end

--[[ npcs/shops/loadShop.lua ]]--
showNPCShop = function(player, npc)
	npc = npc:lower()
	if not npcsStores.shops[npc] then return alert_Error(player, 'error', 'nonexistentShop') end
	modernUI.new(player, 520, 300)
	:build()
	:showNPCShop(npcsStores.shops[npc])
end

buildNpcsShopItems = function()
	for npc in next, npcsStores.shops do
		local newFormat = {}
		for i, k in next, npcsStores.items do 
			local v = type(k) == 'table' and k or bagItems[k]
			if not v.limitedTime then 
				if npc ~= 'chrystian' then 
					if v.npcShop and v.npcShop:find(npc) then 
						newFormat[#newFormat+1] = {i, k}
					end
				else 
					if not v.npcShop and not v.qpPrice and mainAssets.__furnitures[i] then 
						newFormat[#newFormat+1] = {i, k}
					end
				end
			end
			if npc == 'all' then
				newFormat[#newFormat+1] = {i, k}
			end
		end
		npcsStores.shops[npc] = newFormat
	end
end

checkIfPlayerHasFurniture = function(player, furniture)
	for _, v in next, players[player].houseData.furnitures.placed do
		if v.type == furniture then 
			return true 
		end
	end
	for _, v in next, players[player].houseData.furnitures.stored do
		if v.type == furniture then 
			return true 
		end
	end
	return false
end

mergeItemsWithFurnitures = function(t1, t2) -- Merge bag items with furnitures 
	local newTbl = table.copy(t1)
    for i, v in next, t2 do
        newTbl[i+1000] = v.n
    end
    return newTbl
end

--[[ playerData/_dataStructure.lua ]]--
local playerData = DataHandler.new('myc', {
	coins = {
		index = 1,
		type = 'number',
		default = function()
			return 0
		end
	},
	lifeStats = {
		index = 2,
		type = 'table',
		default = function()
			return {100, 100}
		end
	},
	houses = {
		index = 3,
		type = 'table',
		default = function()
			return {}
		end
	},
	cars = {
		index = 4,
		type = 'table',
		default = function()
			return {}
		end
	},
	quests = {
		index = 5,
		type = 'table',
		default = function()
			return {1, 0}
		end
	},
	bagItem = {
		index = 6,
		type = 'table',
		default = function()
			return {}
		end
	},
	bagQuant = {
		index = 7,
		type = 'table',
		default = function()
			return {}
		end
	},
	spentCoins = {
		index = 8,
		type = 'number',
		default = function()
			return 0
		end
	},
	codes = {
		index = 9,
		type = 'table',
		default = function()
			return {}
		end
	},
	housesTerrains = {
		index = 10,
		type = 'table',
		default = function()
			return {0,0,0,0}
		end
	},
	housesTerrainsAdd = {
		index = 11,
		type = 'table',
		default = function()
			return {1,1,1,1}
		end
	},
	housesTerrainsPlants = {
		index = 12,
		type = 'table',
		default = function()
			return {0,0,0,0}
		end
	},
	bagStorage = {
		index = 13,
		type = 'number',
		default = function()
			return 20
		end
	},
	houseObjects = {
		index = 14,
		type = 'table',
		default = function()
			return {}
		end
	},
	storedFurnitures = {
		index = 15,
		type = 'table',
		default = function()
			return {}
		end
	},
	chestStorage = {
		index = 16,
		type = 'table',
		default = function()
			return {{}, {}}
		end
	},
	chestStorageQuanty = {
		index = 17,
		type = 'table',
		default = function()
			return {{}, {}}
		end
	},
	sideQuests = {
		index = 18,
		type = 'table',
		default = function()
			return {1, 0, 0, 0}
		end
	},
	level = {
		index = 19,
		type = 'table',
		default = function()
			return {1, 0}
		end
	},
	jobStats = {
		index = 20,
		type = 'table',
		default = function()
			return {}
		end
	},
	badges = {
		index = 21,
		type = 'table',
		default = function()
			return {}
		end
	},
	luckiness = {
		index = 22,
		type = 'table',
		default = function()
			return {{100, 0, 0, 0}, {}}
		end
	},
	playerLog = {
		index = 23,
		type = 'table',
		default = function()
			return {{mainAssets.season, 0}, {0, lang[ROOM.community] and langIDS[ROOM.community] or '0', 0, 0, 0, 0, 0}, {0, 0, 0}, {0, 0, 0}} -- Season Data| Player Settings| Current Version| Favorite Vehicles
		end
	},
})

local sharpieData = DataHandler.new('sync', {
    questDevelopmentStage = {
        index = 1,
        type = 'number',
        default = function()
            return 0
        end
    },
    canUpdate = {
        index = 2,
        type = 'string',
        default = function()
            return ''
        end
    },
})

--[[ playerData/_localDataStructure.lua ]]--
setPlayerData = function(player)
	local playerLanguage = ROOM.playerList[player] and lang[ROOM.playerList[player].community] and ROOM.playerList[player].community or 'en'
	players[player] = {
		coins		= 0,
		spentCoins	= 0,
		mouseSize	= 1,
		isFrozen	= false,
		isBlind 	= false,
		level		= {1, 0},
		badges		= {},
		jobs		= {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		--------- HOUSE ---------
		editingHouse= false,
		houseData	= {
			houseid = 0,
			currentHouse = nil,
			furnitures = {
				stored = {},
				placed = {},
				placedCounter = 0,
			},
			chests = {
				storage = {{}, {}},
				position= {},
			},
		},
		codigo    	= {},
		casas		= {},
		houseTerrain = {0, 0, 0, 0},
		houseTerrainAdd = {1, 1, 1, 1},
		houseTerrainPlants = {0, 0, 0, 0},
		seeds = {
				[1] = {rarity = 2995}, -- tomato
			    [2] = {rarity = 2000}, -- oregano
				[3] = {rarity = 1000}, -- lemon
				[4] = {rarity = 2500}, -- pepper
				[5] = {rarity = 5}, -- luckyFlower
				[6] = {rarity = 1500}, -- wheat
		},
		--------- CARS ---------
		cars		= {},
		carLeds 	= {},
		favoriteCars= {0, 0},
		currentCar = {direction = nil},
		selectedCar	= nil,
		driving		= false,
		canDrive	= false,
		carImages	= {},
		--------------------
		job			= nil,
		images		= {},
		interfaceImg= {},
		robbery		= {
			whenWasArrested = 0,
			arrested = false,
			robbing	= false,
			escaped = false,
			usingShield = false,
		},
		timer		= {},
		bannerLogin	= '',
		time		= os.time(),
		pos			= {x = 0, y = 0},
		-------------------
		fishing 	= {false, {}, {}},
		--------------------
		dayImgs		= {},
		--------------------
		lucky 		= {
						-- Fishing
						{normal = 100, rare = 0, mythical = 0, legendary = 0},
					},
		---------- LIFESTATS -------
		hospital 	= {hospitalized = false, currentFloor = -1, diseases = {}},
		lifeStats	= {100, 100}, -- energy, hunger
		lifeStatsImages = {{showing = false, images = {}}, {showing = false, images = {}}},
		-------------------
		place = 'town',
		-------------------
		background	= {},
		-------------------
		bag			= {},
		totalOfStoredItems = {
			bag = 0,
			chest = {0, 0},
		},
		selectedItem = {name = nil, image = nil, images = {}},
		bagLimit	= 20,
		holdingItem = false,
		holdingImage = nil,
		holdingDirection = nil,
		-------------------
		questLocalData = {images = {}, other = {}, step = 1},
		questStep	= {1, 0},
		sideQuests	= {1, 0, 0, 0},
		-------------------
		callbackImages 	= {},
		callbackPages 	= {recipes = 1},
		shopMenuType 	= 0,
		shopMenuHeight 	= 0,
		blockScreen 	= false,
		bankPassword 	= nil,
		receivedCodes 	= {},
		playerLinkedImage = nil,
		questScreenIcon = nil,
		-------------------
		seasonStats		= {{mainAssets.season, 0}},
		-------------------
		_modernUIImages = {},
		_modernUIHistory = {},
		_modernUIOpenedTabs = 0,
		_modernUIOtherCallbacks = {},
		_modernUISelectedItemImages = {{}, {}, {}, {}},
		-------------------
		_npcDialogImages= {},
		_npcsCallbacks 	= {starting = {}, ending = {}, clickArea = {}, questNPCS = {}, formatDialog = {}},
		_npcsAdded		= 0,
		-------------------
		playerNameIcons = {level = {}},
		temporaryImages = {jobDisplay = {}},
		-------------------
		joinMenuPage 	= 1,
		gameVersion 	= 'v'..table.concat(version, '.'),
		joinMenuImages 	= {},
		rankingImages 	= {},
		dataLoaded 		= false,
		roomLog 		= false,
		lastCallback 	= {when = os.time(), callback = nil},
		lang			= playerLanguage,
		whenJoined 		= os.time(),
		settings 		= {mirroredMode = 0, language = playerLanguage},
	}

	if player == 'Oliver' then
		players[player].lastCallback.when = 0
		players[player].houseTerrain = {2, 2, 2, 2}
		players[player].houseTerrainAdd = {math.random(2,5), math.random(2,5), math.random(2,5), math.random(2,5)}
		players[player].houseTerrainPlants = {6, 6, 6, 6}
		players[player].houseData.furnitures.placed = {[1] = {y = 656,x = 958,type = 46},[2] = {y = 656,x = 1036,type = 46},[3] = {y = 656,x = 1114,type = 46},[4] = {y = 656,x = 1192,type = 46},[5] = {y = 656,x = 1270,type = 46},[6] = {y = 656,x = 1348,type = 46},[7] = {y = 656,x = 1426,type = 46},[8] = {y = 670,x = 34,type = 12},[9] = {y = 670,x = 120,type = 12},[10] = {y = 632,x = 96,type = 12},[11] = {y = 676,x = 218,type = 9},[12] = {y = 609,x = 127,type = 32},[13] = {y = 657,x = 1334,type = 3},[14] = {y = 654,x = 1140,type = 30},[15] = {y = 655,x = 1456,type = 30},[16] = {y = 574,x = 971,type = 31},[17] = {y = 656,x = 802,type = 46},[18] = {y = 657,x = 880,type = 46},[19] = {y = 657,x = 724,type = 46},[20] = {y = 656,x = 646,type = 46},[21] = {y = 657,x = 568,type = 46}}
		equipHouse(player, 4, 11)
	elseif player == 'Remi' then
		players[player].lastCallback.when = 0
		players[player].houseData.furnitures.placed = {[1] = {y = 664,x = 423,type = 44},[2] = {y = 664,x = 527,type = 44},[3] = {y = 664,x = 632,type = 44},[4] = {y = 663,x = 738,type = 44},[5] = {y = 670,x = 916,type = 42},[6] = {y = 667,x = 954,type = 39},[7] = {y = 667,x = 1000,type = 39},[8] = {y = 670,x = 1047,type = 42},[9] = {y = 670,x = 1081,type = 42},[10] = {y = 620,x = 878,type = 40},[11] = {y = 670,x = 880,type = 43},[12] = {y = 620,x = 1043,type = 41},[13] = {y = 559,x = 952,type = 45}}
		equipHouse(player, 9, 10)
	end
end

--[[ playerData/_dataToSave.lua ]]--
savedata = function(name)
	local playerInfos = players[name]
	if not playerInfos.dataLoaded then return end
	if ROOM.name ~= '*#fofinho' and ROOM.name ~= '*#fofinho1' then
		if string.find(ROOM.name:sub(1,1), '*') then
			TFM.chatMessage('<R>Stats are not saved in rooms with "*".', name)
			return
		elseif ROOM.uniquePlayers < room.requiredPlayers then
			TFM.chatMessage('<R>Stats are not saved if the room have less than 6 players.', name)
			return
		elseif ROOM.passwordProtected then
			TFM.chatMessage('<R>Stats are not saved if the room is protected with a password.', name)
			return
		elseif not table.contains(mainAssets.supportedCommunity, ROOM.community) then
			TFM.chatMessage('<R>Data save is not available in this community.', name)
			return
		end
	else
		--return TFM.chatMessage('ops! failed to save your data.', name)
	end
	playerData:set(name, 'coins', playerInfos.coins)
	playerData:set(name, 'spentCoins', playerInfos.spentCoins)
	playerData:set(name, 'bagStorage', playerInfos.bagLimit)
	local lifeStats = {}

	for i = 1, 2 do
		lifeStats[#lifeStats+1] = playerInfos.lifeStats[i]
 	end
 	playerData:set(name, 'lifeStats', lifeStats)

	local houses = playerData:get(name, 'houses')
	for i, v in next, playerInfos.casas do
		houses[i] = v
	end

	local housesTerrains = playerData:get(name, 'housesTerrains')
	for i, v in next, playerInfos.houseTerrain do
		housesTerrains[i] = v
	end

	local housesTerrainsAdd = playerData:get(name, 'housesTerrainsAdd')
	for i, v in next, playerInfos.houseTerrainAdd do
		housesTerrainsAdd[i] = v
	end

	local housesTerrainsPlants = playerData:get(name, 'housesTerrainsPlants')
	for i, v in next, playerInfos.houseTerrainPlants do
		housesTerrainsPlants[i] = v
	end

	local vehicles = playerData:get(name, 'cars')
	for i, v in next, playerInfos.cars do
		vehicles[i] = v
	end

	local quest = playerData:get(name, 'quests')
	for i, v in next, playerInfos.questStep do
		quest[i] = v
	end

	local item = {}
	local quanty = {}
	local amount = 0
	for i, v in next, playerInfos.bag do
		if amount > playerInfos.bagLimit then break end
		if v.qt > 0 then
			amount = amount + v.qt
			item[#item+1] = bagItems[v.name].id
			quanty[#quanty+1] = v.qt
		end
	end
	playerData:set(name, 'bagItem', item)
	playerData:set(name, 'bagQuant', quanty)

	local chestStorage = {{}, {}}
	local chestStorageQuanty = {{}, {}}
	for counter = 1, 2 do
		for i, v in next, playerInfos.houseData.chests.storage[counter] do
			chestStorage[counter][i] = bagItems[v.name].id
			chestStorageQuanty[counter][i] = v.qt
		end
	end
	playerData:set(name, 'chestStorage', chestStorage)
	playerData:set(name, 'chestStorageQuanty', chestStorageQuanty)

	----------------------------- FURNITURES -----------------------------
	local furnitures, furnitureCounter, storedFurnitures = {}, 0, {}
	do 
		for _, v in next, playerInfos.houseData.furnitures.placed do
			furnitureCounter = furnitureCounter + 1
			if furnitureCounter > maxFurnitureStorage then break end
			furnitures[#furnitures+1] = {v.type, v.x, v.y}
		end
		playerData:set(name, 'houseObjects', furnitures)

		for _, v in next, playerInfos.houseData.furnitures.stored do
			for i = 1, v.quanty do 
				storedFurnitures[#storedFurnitures+1] = v.type
			end
		end
		playerData:set(name, 'storedFurnitures', storedFurnitures)
	end
	----------------------------------------------------------------------

	local code = playerData:get(name, 'codes')
	for i, v in next, playerInfos.receivedCodes do
		code[i] = v
	end
	local sidequest = playerData:get(name, 'sideQuests')
	for i, v in next, playerInfos.sideQuests do
		sidequest[i] = v
	end
	local levelStats = playerData:get(name, 'level')
	for i, v in next, playerInfos.level do
		levelStats[i] = v
	end
	local jobStats = playerData:get(name, 'jobStats')
	for i, v in next, playerInfos.jobs do
		jobStats[i] = v
	end
	local bdg = playerData:get(name, 'badges')
	for i, v in next, playerInfos.badges do
		bdg[i] = v
	end
	local newLuckiness = {{}, {}}
	local fishingRarity = {'normal', 'rare', 'mythical', 'legendary'}
	for i = 1, 4 do
		newLuckiness[1][#newLuckiness[1]+1] = playerInfos.lucky[1][fishingRarity[i]] 
	end

	playerData:set(name, 'luckiness', newLuckiness)

	local playerLogs = {{mainAssets.season, playerInfos.seasonStats[1][2]}, {}, version, playerInfos.favoriteCars}

	playerLogs[2][1] = playerInfos.settings.mirroredMode
	for id, v in next, langIDS do 
		if v == playerInfos.lang then
			playerLogs[2][2] = id
			break
		end 
	end
	playerData:set(name, 'playerLog', playerLogs)

	table.concat(playerData:get(name, 'badges'), '.')
	playerData:save(name)
end

--[[ playerData/player.lua ]]--
giveCoin = function(coin, name, work)
	if room.isInLobby then return end
	local playerData = players[name]
	if not playerData then return end
	players[name].coins = playerData.coins + coin
	if players[name].coins < 0 then
		players[name].coins = 0
	end
	if work then
		setLifeStat(name, 1, playerData.job == 'farmer' and -2 or -15)
	end
	if coin < 0 then
		players[name].spentCoins = playerData.spentCoins - coin
	end
	local sidequest = sideQuests[playerData.sideQuests[1]].type
	if string.find(sidequest, 'type:coins') then
		if string.find(sidequest, 'get') and coin > 0 then
			sideQuest_update(name, coin)
		elseif string.find(sidequest, 'use') and coin < 0 then
			sideQuest_update(name, -coin)
		end
	end
	showOptions(name)
	savedata(name)
end

giveBadge = function(player, id)
	for i, v in next, players[player].badges do
		if v == id then
			return
		end
	end
	if players[player].callbackImages[1] then
		for i, v in next, players[player].callbackImages do
			removeImage(players[player].callbackImages[i])
		end
		players[player].callbackImages = {}
	end
	players[player].badges[#players[player].badges+1] = id

	modernUI.new(player, 240, 220, translate('newBadge', player), translate('unlockedBadge', player))
	:build()
	:badgeInterface(id)
	:addConfirmButton(function() end, translate('confirmButton_Great', player))

	if id == 0 then
		removeImage(players[player].questScreenIcon)
		players[player].questScreenIcon = nil
		ui.removeTextArea(8541584, player)
	end
	savedata(player)
end

giveExperiencePoints = function(player, xp)
	local playerData = players[player]
	players[player].level[2] = tonumber(playerData.level[2]) + xp

	local currentXP = tonumber(players[player].level[2])
	local currentLEVEL = tonumber(players[player].level[1])

	local sidequest = sideQuests[playerData.sideQuests[1]].type
	if string.find(sidequest, 'type:getXP') then
		sideQuest_update(player, xp)
	end
	setSeasonStats(player, 2, xp)

	if currentXP >= ((currentLEVEL * 2000) + 500) then
		players[player].level[1] = currentLEVEL + 1
		players[player].level[2] = currentXP - ((currentLEVEL * 2000) + 500)
		modernUI.new(player, 240, 220, translate('newLevel', player), translate('newLevelMessage', player)..'\n\n<p align="center"><font size="40"><CE>'..players[player].level[1])
			:build()
			:addConfirmButton(function() end, translate('confirmButton_Great', player))
		local currentXP = tonumber(players[player].level[2])
		local currentLEVEL = tonumber(players[player].level[1])
		if currentXP >= ((currentLEVEL * 2000) + 500) then 
			return giveExperiencePoints(player, 0)
		end

		for ii, vv in next, ROOM.playerList do
			TFM.chatMessage('<j>'..translate('levelUp', ii):format('<vp>'..player..'</vp>', '<vp>'..players[player].level[1]..'</vp>'), ii)
			generateLevelImage(player, players[player].level[1], ii)
		end
	end
	savedata(player)
end

setSeasonStats = function(player, stat, quanty)
	if not quanty then quanty = 0 end
	local playerData = players[player].seasonStats[1]
	if not playerData then return end
	if playerData[1] == mainAssets.season then 
		players[player].seasonStats[1][stat] = players[player].seasonStats[1][stat] + quanty
	end
	savedata(player)
end

openProfile = function(player, target)
	if not target then target = player end
	modernUI.new(player, 520, 300, '<font size="20">'..target)
	:build()
	:profileInterface(target)
end

player_removeImages = function(tbl)
	if not tbl then return end
	for i = 1, #tbl do 
		removeImage(tbl[i])
		tbl[i] = nil
	end
end

--[[ commands/!ban.lua ]]--
chatCommands.ban = {
	permissions = {'admin', 'mod'},
	event = function(player, args)
		local target = string.nick(args[1])
		if not players[target] then return TFM.chatMessage('<g>[•] $playerName not found.', player) end
		room.bannedPlayers[#room.bannedPlayers+1] = target
		TFM.killPlayer(target)
		translatedMessage('playerBannedFromRoom', target)
		room.fileUpdated = true
	end
}

--[[ commands/!unban.lua ]]--
chatCommands.unban = {
	permissions = {'admin', 'mod'},
	event = function(player, args)
		local target = string.nick(args[1])
		if not players[target] then return TFM.chatMessage('<g>[•] $playerName not found.', player) end
		if not table.contains(room.bannedPlayers, target) then return end
		for i, v in next, room.bannedPlayers do
			if v == target then
				table.remove(room.bannedPlayers, i)
				break
			end
		end
		TFM.respawnPlayer(target)
		translatedMessage('playerUnbannedFromRoom', target)
		room.fileUpdated = true
	end
}

--[[ commands/!coin.lua ]]--
chatCommands.coin = {
	permissions = {'admin'},
	event = function(player, args)
		giveCoin(50000, player)
	end
}

--[[ commands/!insert.lua ]]--
chatCommands.insert = {
	permissions = {'admin'},
	event = function(player, args)
		local item = args[1]
		local amount = tonumber(args[2]) or 1
		if not bagItems[item] then return end
		addItem(item, amount, player)
	end
}

--[[ commands/!place.lua ]]--
chatCommands.place = {
	permissions = {'admin', 'mod', 'helper'},
	event = function(player, args)
		if places[args[1]] then
			places[args[1]].saidaF(player)
		end
	end
}

--[[ commands/!profile.lua ]]--
chatCommands.profile = {
	event = function(player, args)
		local target = string.nick(args[1])
		openProfile(player, target)
	end
}
chatCommands.perfil = table.copy(chatCommands.profile)
chatCommands.profil = table.copy(chatCommands.profile)

--[[ commands/!shop.lua ]]--
chatCommands.shop = {
	permissions = {'admin'},
	event = function(player, args)
		showNPCShop(player, args[1])
	end
}

--[[ commands/!spawn.lua ]]--
chatCommands.spawn = {
	permissions = {'admin', 'mod', 'helper'},
	event = function(player, args)
		local target = string.nick(args[1])
		if not players[target] then return TFM.chatMessage('<g>[•] $playerName not found.', player) end
		TFM.chatMessage('<g>[•] moving '..target..' to spawn...', player)
		players[target].place = 'town'
		TFM.killPlayer(target)
	end
}

--[[ commands/!punish.lua ]]--
chatCommands.punish = {
	permissions = {'admin', 'mod', 'helper'},
	event = function(player, args)
		local target = string.nick(args[1])
		if not players[target] then return TFM.chatMessage('<g>[•] $playerName not found.', player) end
		TFM.chatMessage('[•] removing $100 from '..target..'...', player)
		giveCoin(-100, target)
	end
}

--[[ commands/!jail.lua ]]--
chatCommands.jail = {
	permissions = {'admin', 'mod', 'helper'},
	event = function(player, args)
		local target = string.nick(args[1])
		if not players[target] then return TFM.chatMessage('<g>[•] $playerName not found.', player) end
		TFM.chatMessage('<g>[•] arresting '..target..'...', player)
		arrestPlayer(target, 'Colt')
	end
}

--[[ commands/!roomlog.lua ]]--
chatCommands.roomlog = {
	permissions = {'admin', 'mod', 'helper'},
	event = function(player)
		players[player].roomLog = not players[player].roomLog
		TFM.chatMessage('<g>[•] roomLog status: '..tostring(players[player].roomLog), player)
	end
}

--[[ commands/!moveto.lua ]]--
chatCommands.moveto = {
	permissions = {'admin', 'mod', 'helper'},
	event = function(player, args)
		if not args[1] then return end
		local target = string.nick(args[1])
		if players[target] then
			TFM.chatMessage('[•] teleporting to ['..target .. '] ('..players[target].place..')...', player)
			TFM.movePlayer(player, ROOM.playerList[target].x, ROOM.playerList[target].y, false)
			players[player].place = players[target].place
		elseif gameNpcs.characters[args[1]] then
			TFM.chatMessage('[•] teleporting to <v>[NPC]</v> '..args[1]..'...', player)
			TFM.movePlayer(player, gameNpcs.characters[args[1]].x+50, gameNpcs.characters[args[1]].y+50, false)
		else
			TFM.chatMessage('<g>[•] $playerName not found.', player)
		end
	end
}

--[[ commands/!job.lua ]]--
chatCommands.job = {
	permissions = {'admin', 'mod', 'helper'},
	event = function(player, args)
		local job = args[1]
		local target = string.nick(args[2])
		if not players[target] then target = player end
		if not jobs[job] then return end
		job_invite(job, target)
	end
}

--[[ commands/!image.lua ]]--
local commandImages = {}
chatCommands.image = {
	permissions = {'admin'},
	event = function(player, args)
		local image = args[1] or ''
		local imgType = args[2] or '!10'
		local x = args[3] or -100
		local y = args[4] or -100

		commandImages[#commandImages+1] = addImage(image, imgType, x, y)
		TFM.chatMessage('<FC>Adding image... ID: <rose>'..#commandImages..'</rose>\n<t>' .. 
			' Ξ url: '..image..'\n' .. 
			' Ξ type: '..imgType..'\n' ..
			' Ξ x: '..x..'\n' ..
			' Ξ y: '..y
		, player)
	end
}
chatCommands.removeimage = {
	permissions = {'admin'},
	event = function(player, args)
		local id = tonumber(args[1])
		if commandImages[id] then
			removeImage(commandImages[id])
			commandImages[id] = nil
			TFM.chatMessage('<g>image removed!', player)
		end
	end
}

--[[ commands/!hour.lua ]]--
chatCommands.hour = {
	permissions = {'admin'},
	event = function(player, args)
		room.currentGameHour = args[1] or 0
		TFM.chatMessage('<rose>' ..updateHour(player, true))
	end
}

--[[ commands/!lootbox.lua ]]--
chatCommands.lootbox = {
	permissions = {'admin'},
	event = function(player)
		local x = math.random(0, 12000)
		addLootDrop(x, 7200, 20)
		for i, v in next, ROOM.playerList do 
			TFM.movePlayer(i, x, 7600, false)
		end
	end
}

--[[ commands/!quest.lua ]]--
chatCommands.quest = {
	permissions = {'admin'},
	event = function(player, args)
		local quest = tonumber(args[1])
		if not lang['en'].quests[quest] then return TFM.chatMessage('<g>[•] invalid quest ID.', player) end
		local questStep = tonumber(args[2]) or 0
		local target = string.nick(args[3])
		if not players[target] then target = player end

		_QuestControlCenter[players[target].questStep[1]].reward(target)

		players[target].questStep[1] = quest
		players[target].questStep[2] = questStep
		players[target].questLocalData.step = 0
		savedata(target)

		_QuestControlCenter[quest].active(target, 0)

		TFM.chatMessage('<g>[•] quest '..quest..':'..questStep..' set to '..target..'.', player)
	end
}
		
	

--[[ commands/!sidequest.lua ]]--
chatCommands.sidequest = {
	permissions = {'admin'},
	event = function(player, args)
		local nextQuest = tonumber(args[1])
		if not sideQuests[nextQuest] then return TFM.chatMessage('<g>[•] invalid sidequest ID.', player) end
		local target = string.nick(args[2])
		if not players[target] then target = player end

		players[target].sideQuests[1] = nextQuest
		players[target].sideQuests[2] = 0
		savedata(target)
	end
}

--[[ commands/!update.lua ]]--
chatCommands.update = {
	permissions = {'admin'},
	event = function(player, args)
		if not syncData.connected then return TFM.chatMessage('<fc>[•] Failed to update. Reason: Data not synced.') end
		local msg = args[1] and table.concat(args, ' ') or ''
		syncData.updating.updateMessage = msg
		saveGameData('Sharpiebot#0000')
		TFM.chatMessage('<fc>[•] Update requested. Message: '..msg)
	end
}

--[[ quests/controlCenter.lua ]]--
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

--[[ quests/mainquest.lua ]]--
addQuestAsset = function(player, npc)
	if players[player].questLocalData.images[1] then
		for i, v in next, players[player].questLocalData.images do
			removeImage(players[player].questLocalData.images[i])
		end
	end
	players[player].questLocalData.images = {}
	for i = -50, -40 do
		ui.removeTextArea(i, player)
	end
	if npc:find('_key') then
		players[player].questLocalData.images[#players[player].questLocalData.images+1] = addImage("16bbd9655ca.png", "!30", 1400, 8753, player)
		ui.addTextArea(-46, "<textformat leftmargin='1' rightmargin='1'><a href='event:Quest_02_key'>" .. string.rep('\n', 4), player, 1390, 8743, 25, 25, 1, 1, 0, false)
	end
	if npc:find('_key2') then
		players[player].questLocalData.images[#players[player].questLocalData.images+1] = addImage("16bbd9655ca.png", "!30", 1630, 8815, player)
		ui.addTextArea(-46, "<textformat leftmargin='1' rightmargin='1'><a href='event:Quest_02_key'>" .. string.rep('\n', 4), player, 1620, 8805, 25, 25, 1, 1, 0, false)
	end
	if npc:find('_cloth') then
		players[player].questLocalData.images[#players[player].questLocalData.images+1] = addImage("16bca0b1f2e.png", "!30", 5700, 4990, player)
		ui.addTextArea(-46, "<textformat leftmargin='1' rightmargin='1'><a href='event:Quest_03_cloth'>" .. string.rep('\n', 4), player, 5700, 4990, 25, 25, 1, 1, 0, false)
	end
	if npc:find('_paper') then
		players[player].questLocalData.images[#players[player].questLocalData.images+1] = addImage("16bbf3aa649.png", "!30", 6250, 3250, player)
		ui.addTextArea(-46, "<textformat leftmargin='1' rightmargin='1'><a href='event:Quest_03_paper'>" .. string.rep('\n', 4), player, 6250, 3250, 25, 25, 1, 1, 0, false)
	end
end

quest_formatText = function(player, quest, step)
	local formats = {
		[1] = {
			[1] = players[player].questLocalData.other.fish_ and (5 - players[player].questLocalData.other.fish_) .. '/5',
			[3] = players[player].questLocalData.other.BUY_energyDrink_Ultra and (3 - players[player].questLocalData.other.BUY_energyDrink_Ultra) .. '/3',
		},
		[5] = {
			[9] = players[player].questLocalData.other.ItemQuanty_lemon and (10 - players[player].questLocalData.other.ItemQuanty_lemon) .. '/10',
			[11] = players[player].questLocalData.other.ItemQuanty_tomato and (10 - players[player].questLocalData.other.ItemQuanty_tomato) .. '/10',
		},
	}
	if formats[quest] then
		if formats[quest][step] then
			return formats[quest][step]
		end
	end
	return '-'
end

quest_setNewQuest = function(player, syncRewards)
	if not syncRewards then
		_QuestControlCenter[players[player].questStep[1]].reward(player)
		players[player].questStep[1] = players[player].questStep[1] + 1
		players[player].questStep[2] = 0
		players[player].questLocalData.step = 0
		loadMap(player)
		syncRewards = players[player].questStep[1]-1
	end
	players[player].sideQuests[4] = players[player].sideQuests[4] + 20
	giveExperiencePoints(player, 3000)
	modernUI.new(player, 240, 220)
		:rewardInterface({
			{text = translate('experiencePoints', player), quanty = 3000, format = '+'},
			{text = 'QP$', quanty = 20, format = '+'},
		}, nil, translate('questCompleted', player):format('<CE><i>'..lang[players[player].lang].quests[syncRewards].name..'</i></CE>'))
		:build()
		:addConfirmButton(function() end, translate('confirmButton_Great', player))
end

quest_updateStep = function(player)
	local playerData = players[player]

	local currentQuest = playerData.questStep[1]
	local currentStep = playerData.questStep[2]

	for i, character in next, _QuestControlCenter[currentQuest].npcs do 
		if playerData._npcsCallbacks.questNPCS[character] then
			gameNpcs.removeNPC(character, player)
			players[player]._npcsCallbacks.questNPCS[character] = nil
		end 
	end 
	if playerData.questLocalData.images[1] then
		for i, v in next, playerData.questLocalData.images do
			removeImage(playerData.questLocalData.images[i])
		end
	end
	players[player].questLocalData.images = {}
	for i = -50, -40 do
		ui.removeTextArea(i, player)
	end

	players[player].questLocalData.other = {}
	players[player].questStep[2] = currentStep + 1
	players[player].questLocalData.step = 1

	--TFM.chatMessage('<CS>[DEBUG]</CS> '..player..' completed a new quest step! Current step: <v>'..playerData.questStep[2])
	if players[player].questStep[2] == #lang['en'].quests[currentQuest]+1 then			
		quest_setNewQuest(player)
		if players[player].questStep[1] > questsAvailable then
			return 'no more quests'
		end
	end
	_QuestControlCenter[players[player].questStep[1]].active(player, players[player].questStep[2])
	savedata(player)
end

quest_checkIfCanTalk = function(questID, questStep, npc)
	if lang['en'].quests[questID][questStep]._add:find(npc) then 
		return true
	end
	return false
end

--[[ quests/sidequest.lua ]]--
sideQuest_update = function(player, quanty)
	players[player].sideQuests[2] = players[player].sideQuests[2] + quanty
	if players[player].sideQuests[2] >= sideQuests[players[player].sideQuests[1]].quanty then
		sideQuest_reward(player)
	end
end

sideQuest_reward = function(player)
	eventTextAreaCallback(1, player, 'close2', true)
	players[player].sideQuests[4] = players[player].sideQuests[4] + sideQuests[players[player].sideQuests[1]].points
	local newxp = sideQuests[players[player].sideQuests[1]].points * 100
	modernUI.new(player, 240, 220)
		:rewardInterface({
			{text = translate('experiencePoints', player), quanty = newxp, format = '+'},
			{text = 'QP$', quanty = sideQuests[players[player].sideQuests[1]].points, format = '+'},
		}, nil, translate('sidequestCompleted', player))
		:build()
		:addConfirmButton(function() end, translate('confirmButton_Great', player))
	math.randomseed(os.time())
	repeat
			nextQuest = math.random(#sideQuests)
	until nextQuest ~= players[player].sideQuests[1] and nextQuest ~= 8
	players[player].sideQuests[1] = nextQuest
	players[player].sideQuests[2] = 0
	players[player].sideQuests[3] = players[player].sideQuests[3] + 1
	giveExperiencePoints(player, newxp)
	savedata(player)
end

--[[ syncGame.lua ]]--
syncVersion = function(player, vs)
	if not vs then vs = {0} end
	local playerVersion = tonumber(table.concat(vs))
	local gameVersion = tonumber(table.concat(version))
	if playerVersion == 0 then 
		for i = 1, players[player].questStep[1]-1 do 
			quest_setNewQuest(player, i)
		end
	end
	if playerVersion <= 300 then
		if players[player].questStep[1] < 5 then
			if not lang['en'].quests[players[player].questStep[1]][players[player].questStep[2]] then
				quest_setNewQuest(player)
			end
		else
			players[player].questStep[1] = 5
			players[player].questStep[2] = 0
		end
	end
	local chest_Item = playerData:get(player, 'chestStorage')
	local chest_Quanty = playerData:get(player, 'chestStorageQuanty')
	if playerVersion < 300 then
		for i, v in next, chest_Item do
			item_addToChest(bagIds[v].n, chest_Quanty[i], player, 1)
		end
	else
		for counter = 1, 2 do
			for i, v in next, chest_Item[counter] do
				item_addToChest(bagIds[v].n, chest_Quanty[counter][i], player, counter)
			end
		end
	end
	players[player].gameVersion = 'v'..table.concat(version, '.')
end

syncFiles = function()
    local bannedPlayers = {}
    local unrankedPlayers = {}

    for _, player in next, room.bannedPlayers do
        bannedPlayers[#bannedPlayers+1] = player..',0'
    end
    for _, player in next, room.unranked do
        unrankedPlayers[#unrankedPlayers+1] = player..',0'
    end

    system.saveFile(table.concat(bannedPlayers, ';')..'|'..table.concat(unrankedPlayers, ';'), 1)
end

saveGameData = function(bot)
	sharpieData:set(bot, 'canUpdate', syncData.updating.updateMessage)
	sharpieData:save(bot)
end

syncGameData = function(data, bot)
    sharpieData:newPlayer(bot, data)
    syncData.quests.newQuestDevelopmentStage = sharpieData:get(bot, 'questDevelopmentStage')
    local updatingData = sharpieData:get(bot, 'updating')
    syncData.updating.updateMessage = sharpieData:get(bot, 'canUpdate')

    syncData.connected = true
    if sharpieData:get(bot, 'canUpdate') ~= '' and not syncData.updating.isUpdating then 
        nextUpdateAnimation()
        syncData.updating.isUpdating = true 
    end
end

nextUpdateAnimation = function()
    local width = 800
    local height = 400
    local x = -2
    local y = -2
    local stage = 0
    local speed = 20
    
    local a = system.looping(function()
        if stage == 0 then 
            width = width - speed
            height = height - speed/2
            x = x + speed/2
            y = y + speed/4
            if width == 60 then stage = 1 end
        elseif stage == 1 then 
            y = y - speed/4
            if y == 28 then stage = 2 end 
        elseif stage == 2 then 
            x = x - speed/2
            width = width + speed
            if width == 200 then stage = 3 end
        elseif stage == 3 then 
            height = height + speed 
            if height == 70 then stage = 4 end
        elseif stage == 4 then 
            stage = 5
            local maxTime = 300
            ui.addTextArea(-888888888889, '<p align="center"><font size="15" color="#95d44d">Updating...</p><ce>'..syncData.updating.updateMessage..'</ce>\n<font size="20" color="#c6bb8c">'..string.format("%.2d:%.2d", maxTime/60%60, maxTime%60)..'</font>', nil, x, y, width, height, 0x432c04, 0xc6bb8c, 1, true)
            addTimer(function(j)
                local time = maxTime - j 
                time = string.format("%.2d:%.2d", time/60%60, time%60)
                ui.addTextArea(-888888888889, '<p align="center"><font size="15" color="#95d44d">Updating...</p><ce>'..syncData.updating.updateMessage..'</ce>\n<font size="20" color="#c6bb8c">'..time..'</font>', nil, x, y, width, height, 0x432c04, 0xc6bb8c, 1, true)
                if j == maxTime then 
                    syncData.updating.updateMessage = ''
                    saveGameData('Sharpiebot#0000')
                end
            end, 1000, maxTime)
        end
        if stage < 4 then 
            ui.addTextArea(-888888888888, '', nil, x, y, width, height, 0x432c04, 0x432c04, 1, true)
        end
    end, 15)
end

--[[ ranking/load.lua ]]--
loadRanking = function(player)
	local minn = 1
	local maxx = 10

	local playerList = {}
    local playerLevel = {{}, {}}
    local playerExperience = {{}, {}}

	local color = ''
	local xAlign = 3710
	local yAlign = 7480

	for i = minn, maxx do
		if not room.globalRanking[i] then break end
		local name = room.globalRanking[i].name
		local level = room.globalRanking[i].level
		local experience = room.globalRanking[i].experience 
		local commu = room.globalRanking[i].commu
		if not room.globalRanking[i].commu then
			room.globalRanking[i].commu = 'xx'
		end
		if i == 1 then
			color = '#FFD700'
		elseif i == 2 then
			color = '#c9c9c9'
		elseif i == 3 then
			color = '#A0522D'
		else
			color = '#BEBEBE'
		end

		playerList[#playerList+1] = '<font size="10" color="'..color..'">'..i..'. <font color="#000000">' .. name
		playerLevel[2][#playerLevel[2]+1] = '<p align="right"><font size="10"><cs>'.. level
		playerLevel[1][#playerLevel[1]+1] = '<p align="right"><font size="10" color="#000000">'.. level

		playerExperience[2][#playerExperience[2]+1] = '<p align="right"><font size="10"><vp>'.. experience ..'xp'
		playerExperience[1][#playerExperience[1]+1] = '<p align="right"><font size="10" color="#2F692F">'.. experience ..'xp'

		room.rankingImages[#room.rankingImages+1] = addImage('1711870c79c.jpg', '?1000', 95 + xAlign, (i-1)*12+102 + yAlign, player)
		room.rankingImages[#room.rankingImages+1] = addImage((community[commu] and community[commu] or community['xx']), '?1001', 109 + xAlign, (i-1)*12+102 + yAlign, player)

	end
	if not room.globalRanking[1] then
		playerList[#playerList+1] = '\n\nLoading...'
	end

	ui.addTextArea(5432, table.concat(playerList, '\n'), player, 128 + xAlign, 100 + yAlign, 180, 130, 0x324650, 0x0, 0)
	ui.addTextArea(5433, table.concat(playerLevel[1], '\n'), player, 276+10+ xAlign, 101 + yAlign, 40, 130, 0x324650, 0x0, 0)
	ui.addTextArea(5434, table.concat(playerLevel[2], '\n'), player, 275+10+ xAlign, 100 + yAlign, 40, 130, 0x324650, 0x0, 0)

	ui.addTextArea(5435, table.concat(playerExperience[1], '\n'), player, 276+65+ xAlign, 101 + yAlign, 70, 130, 0x324650, 0x0, 0)
	ui.addTextArea(5436, table.concat(playerExperience[2], '\n'), player, 275+65+ xAlign, 100 + yAlign, 70, 130, 0x324650, 0x0, 0)

	if player then 
		ui.addTextArea(5440, '<p align="center"><font size="20" color="#000000">'..translate('ranking_Season', player):format(mainAssets.season), player, 94+ xAlign, 55+ yAlign, 400, nil, 0x324650, 0x0, 0)
		ui.addTextArea(5441, '<p align="center"><font size="20"><cs>'..translate('ranking_Season', player):format(mainAssets.season), player, 93+ xAlign, 54+ yAlign, 400, nil, 0x324650, 0x0, 0)

		ui.addTextArea(5442, '<p align="center"><font size="14"><r>'..translate('daysLeft', player):format(formatDaysRemaining(os.time{day=11, year=2020, month=7})), player, 93+ xAlign, 84+ yAlign, 400, nil, 0x324650, 0x0, 0)
	end
end

--[[ ranking/save.lua ]]--
saveRanking = function()
	if ROOM.name:sub(1,2) == "*" then
		return
	elseif ROOM.uniquePlayers < room.requiredPlayers then
		return
	end
	local newRanking = {}
	local localRanking = table.copy(room.globalRanking)

	for i = #localRanking, 1, -1 do
        if ROOM.playerList[localRanking[i].name] then
            table.remove(localRanking, i)
        end
    end
	for name in next, ROOM.playerList do
		local player = players[name]
        if player then
			if player.seasonStats[1][1] == mainAssets.season then 
				if not table.contains(room.unranked, name) then
					localRanking[#localRanking+1] = {name = name, level = player.level[1], experience = player.seasonStats[1][2], commu = ROOM.playerList[name].community, id = ROOM.playerList[name].id}
				end
			end
        end
    end
	table.sort(localRanking, function(a, b) return tonumber(a.experience) > tonumber(b.experience) end)

	if #localRanking > 10 then
        local len = #localRanking
        for i = len, 11, -1 do
            table.remove(localRanking, i)
        end
    end

	for _, player in next, localRanking do
        newRanking[#newRanking+1] = string.format('%s,%i,%i,%s,%i', player.name, player.level, player.experience, player.commu, player.id)
    end

	-------------------------------------------
	system.saveFile(table.concat(newRanking, ';'), 5)
end

--[[ jobs/jobState.lua ]]--
job_fire = function(i)
	if not players[i] then return end
	if not ROOM.playerList[i] then return end
	removeImages(i)
	TFM.setNameColor(i, 0)

	local job = players[i].job
	if not job then return end
	jobs[job].working[i] = nil
	for index, player in next, jobs[job].working do
		if player == i then 
			table.remove(jobs[job].working, index)
			break
		end
	end
	players[i].job = nil
	local images = players[i].temporaryImages.jobDisplay
	if images[1] then 
		for i = 1, #images do 
			removeImage(images[i])
		end 
		players[i].temporaryImages.jobDisplay = {}
		ui.removeTextArea(1012, i)
	end
	if job == 'farmer' then 
		for i = 1, 4 do
			ui.removeTextArea('-730'..(i..tonumber(players['Oliver'].houseData.houseid)*10), i)
		end
	end
end

job_invite = function(job, player)
	local playerData = players[player]
	if not jobs[job] or not playerData then return end
	if playerData.job == job then return end 
	modernUI.new(player, 240, 220)
	:build()
	:jobInterface(job)
	:addConfirmButton(function(player, job) job_hire(job, player) end, translate('confirmButton_Work', player), job)
end

job_hire = function(job, player)
	local playerData = players[player]
	if not playerData or playerData.robbery.robbing then return end
	
	if playerData.job then 
		job_fire(player)
	end
	players[player].temporaryImages.jobDisplay[#players[player].temporaryImages.jobDisplay+1] = addImage("171d301df6c.png", ":1", 0, 22, player)
	players[player].temporaryImages.jobDisplay[#players[player].temporaryImages.jobDisplay+1] = addImage(jobs[job].icon, ":2", 107, 22, player)
	ui.addTextArea(1012, '<p align="center"><b><font size="14" color="#371616">'..translate(job, player), player, 0, 29, 110, 30, 0x1, 0x1, 0, true)

	if job ~= 'thief' then
		TFM.setNameColor(player, '0x'..jobs[job].color)
		if jobs[job].specialAssets then 
			jobs[job].specialAssets(player)
		end
	else 
		TFM.setNameColor(player, 0)
	end
		
	local image = playerData.callbackImages
	if image[1] then
		for i = 1, #image do
			removeImage(image[i])
		end
		players[player].callbackImages = {}
	end

	players[player].job = job
	jobs[job].working[#jobs[job].working+1] = player
end

job_updatePlayerStats = function(player, type, quant)
	if not quant then quant = 1 end
	local playerData = players[player]
	players[player].jobs[type] = playerData.jobs[type] + quant

	if playerData.jobs[4] >= 1000 then
		giveBadge(player, 3)
	end
	if playerData.jobs[3] >= 500 then
		giveBadge(player, 2)
	end
	if playerData.jobs[5] >= 500 then
		giveBadge(player, 4)
	end
	if playerData.jobs[6] >= 500 then
		giveBadge(player, 8)
	end
	if playerData.jobs[2] >= 500 then -- THIEF
		giveBadge(player, 5)
	end
	if playerData.jobs[1] >= 500 then -- COP
		giveBadge(player, 10)
	end
	if playerData.jobs[9] >= 500 then -- CHEF
		giveBadge(player, 9)
	end
	savedata(player)
end

--[[ jobs/cop/arrest.lua ]]--
arrestPlayer = function(thief, cop, command)
	local i = thief
	local player = cop
	local thiefData = players[thief]
	local copData = players[cop]
	if not copData then
		eventNewPlayer(cop)
		return arrestPlayer(thief, cop, command)
	elseif not thiefData then
		eventNewPlayer(thief)
		return arrestPlayer(thief, cop, command)
	end

	checkIfPlayerIsDriving(thief)
	removeImages(thief)
	ui.removeTextArea(1012, thief)
	ui.removeTextArea(5001, thief)
	closeMenu(920, thief)
	removeTimer(thiefData.timer)
	job_fire(thief)
	eventTextAreaCallback(1, thief, 'closeVaultPassword', true) 

	players[thief].place = 'police'
	players[thief].blockScreen = true
	players[thief].robbery.arrested = true
	players[thief].robbery.robbing = false
	players[thief].robbery.usingShield = false
	players[thief].robbery.whenWasArrested = os.time()
	players[thief].robbery.escaped = false
	players[thief].timer = {}
	players[thief].bankPassword = nil

	if thief ~= 'Robber' then 
		closeInterface(thief, nil, nil, nil, nil, nil, true)
		players[thief].timer = addTimer(function(j)
			local time = room.robbing.prisonTimer - j
			local thiefPosition = ROOM.playerList[thief]

			ui.addTextArea(98900000000, string.format("<b><font color='#371616'><p align='center'>"..translate('looseMgs', thief), time), thief, 253, 368, 290, nil, 1, 1, 0, true)
			if j == room.robbing.prisonTimer then
				removeTimer(thiefData.timer)
				players[thief].robbery.arrested = false
				players[thief].blockScreen = false
				players[thief].timer = {}
				TFM.movePlayer(thief, 8020, 6400, false)
				showOptions(thief)
			end

			if thiefPosition.x > 8040 and thiefPosition.y > 6260 and thiefPosition.x < 8500 and thiefPosition.y < 6420 then return end
	 		TFM.movePlayer(thief, math.random(8055, 8330), 6400, false)
		end, 1000, command and 30 or room.robbing.prisonTimer)
	end
	giveExperiencePoints(thief, 10)
	giveExperiencePoints(cop, 30)
	local complement = i:gmatch('(.-)#[0-9]+$')()
	if not i:match('#0000') then
		complement = i:gsub('#', '<g>#')
	end
	for name in next, ROOM.playerList do
		if name ~= cop then 
    		TFM.chatMessage(string.format(translate('captured', name), complement), name)
    	end
	end
	TFM.chatMessage(string.format(translate('arrestedPlayer', cop), complement), cop)

	local sidequest = sideQuests[copData.sideQuests[1]].type
	if string.find(sidequest, 'type:arrest') then
		sideQuest_update(cop, 1)
	end

	giveCoin(jobs['police'].coins, cop, true)
	job_updatePlayerStats(cop, 1)
	players[cop].time = os.time() + 10000
end

--[[ jobs/thief/rob.lua ]]--
startRobbery = function(player, character)
	local npcTimer = gameNpcs.robbing[character].cooldown
	addTimer(function(j)
		gameNpcs.removeNPC(character)
		if j == npcTimer then
			gameNpcs.reAddNPC(character)
		end
	end, 1000, npcTimer)

	local shield = addImage('1566af4f852.png', '$'..player, -45, -45)
	players[player].robbery.usingShield = true
	players[player].robbery.robbing = true
	players[player].timer = addTimer(function(j)
		local time = room.robbing.robbingTimer - j
		ui.addTextArea(98900000000, "<b><font color='#371616'><p align='center'>"..translate('runAway', player):format(time)..'\n<vp><font size="10">'..translate('runAwayCoinInfo', player):format('$'..jobs['thief'].coins), player, 253, 364, 290, nil, 1, 1, 0, true)
		if j == 10 then
			removeImage(shield)
			players[player].robbery.usingShield = false
		elseif j == room.robbing.robbingTimer then 
			local sidequest = sideQuests[players[player].sideQuests[1]].type
			if string.find(sidequest, 'type:rob') then
				sideQuest_update(player, 1)
			end
			players[player].robbery.robbing = false
			ui.removeTextArea(98900000000, player)
			showOptions(player)
			giveExperiencePoints(player, 100)
			job_updatePlayerStats(player, 2)
			giveCoin(jobs['thief'].coins, player, true)
			TFM.setNameColor(player, 0)
		end
	end, 1000, room.robbing.robbingTimer)
	closeInterface(player, nil, nil, nil, nil, nil, true)

	TFM.chatMessage('<j>'..translate('copAlerted', player), player)
	TFM.setNameColor(player, 0xFF0000)

	for _, cop in next, jobs['police'].working do
		TFM.chatMessage('<vp>['..translate('alert', cop)..'] <v>'.. player, cop)
	end
end

--[[ jobs/fisher/fish.lua ]]--
playerFishing = function(name, x, y, biome)
	local player = players[name]
	local playerStatus = ROOM.playerList[name]

	math.randomseed(os.time())
	local chances = math.random(1, 10000)
	local counter = 0
	local rarityFished = 'normal'

	for rarity, percentage in next, player.lucky[1] do
		counter = counter + (percentage * 100)
		if (percentage * 100) >= chances then 
			rarityFished = rarity
			break
		end
	end

	player.fishing[1] = true 
	TFM.playEmote(name, 26)
	player.fishing[3][#player.fishing[3]+1] = addImage(playerStatus.isFacingRight and '170b1daa3ed.png' or '170b1daccfb.png', '$'..name, playerStatus.isFacingRight and 0 or -40, -42)

	player.fishing[2] = addTimer(function(j)
		if j == 2 then 
			playerStatus = ROOM.playerList[name]
			if not players[name].canDrive and biome == 'sea' then
				checkIfPlayerIsDriving(name)
				TFM.movePlayer(name, playerStatus.x, playerStatus.y, false)
				addGround(77777 + playerStatus.id, playerStatus.x + (playerStatus.isFacingRight and 40 or -40), playerStatus.y - 40, {type = 14, miceCollision = false, groundCollision = false})
				addGround(77777 + playerStatus.id+1, playerStatus.x + (playerStatus.isFacingRight and 70 or -70), playerStatus.y - 30, {type = 14, dynamic = true, miceCollision = false})

				TFM.addJoint(77777 + playerStatus.id, 77777 + playerStatus.id, 77777 + playerStatus.id+1, {type = 0, color = 0xc1c1c1, line = 1, frequency = 0.2})
				for i = 1, #player.fishing[3] do 
					removeImage(player.fishing[3][i])
				end
				player.fishing[3] = {}
				player.fishing[3][#player.fishing[3]+1] = addImage(playerStatus.isFacingRight and '170b1daa3ed.png' or '170b1daccfb.png', '$'..name, playerStatus.isFacingRight and 0 or -40, -42)

			else
				player.fishing[3][#player.fishing[3]+1] = addImage('170b66954aa.png', '$'..name, playerStatus.isFacingRight and 35 or -40, -35)
			end
			
		elseif j == 28 then 
			player.fishing[1] = false
			TFM.playEmote(name, 9)
			job_updatePlayerStats(name, 3)

			local align = playerStatus.isFacingRight and 20 or -90
			for particles = 1, 10 do
				TFM.displayParticle(14, particles * 3 + x + align, y + 50,  math.random(-5, 5), math.random(-2, 0.5), math.random(-0.7, 0.1))
			end

			math.randomseed(os.time())
			local willFish = room.fishing.biomes[biome].fishes[rarityFished][math.random(#room.fishing.biomes[biome].fishes[rarityFished])]
			local willFishInfo = bagItems[willFish]

			if rarityFished == 'normal' then 
				players[name].lucky[1]['normal'] = player.lucky[1]['normal'] - .5
				players[name].lucky[1]['rare'] = player.lucky[1]['rare'] + .5
				giveExperiencePoints(name, 10)
			elseif rarityFished == 'rare' then 
				players[name].lucky[1]['rare'] = player.lucky[1]['rare'] - .25
				players[name].lucky[1]['mythical'] = player.lucky[1]['mythical'] + .25	
				giveExperiencePoints(name, 100)
			elseif rarityFished == 'mythical' then 
				players[name].lucky[1]['normal'] = player.lucky[1]['normal'] + player.lucky[1]['mythical']/2
				players[name].lucky[1]['legendary'] = player.lucky[1]['legendary'] + player.lucky[1]['mythical']/2
				players[name].lucky[1]['mythical'] = 0
				giveExperiencePoints(name, 500)
			else
				players[name].lucky[1] = {normal = 100, rare = 0, mythical = 0, legendary = 0}	
				giveExperiencePoints(name, 2000)		
			end

			sendMenu(99, name, '', 400 - 120 * 0.5, (300 * 0.5), 100, 100, 1, true)
			addItem(willFish, 1, name)
			player.images[#player.images+1] = addImage(willFishInfo.png and willFishInfo.png or '16bc368f352.png', "&70", 400 - 50 * 0.5, 180, name)
	

			local sidequest = sideQuests[player.sideQuests[1]].type
			if sidequest == 'type:fish' or string.find(sidequest, willFish) then
				sideQuest_update(name, 1)
			end
			for id, properties in next, player.questLocalData.other do 
				if id:find('fish_') then
					if type(properties) == 'boolean' then 
						quest_updateStep(name)
					else 
						player.questLocalData.other[id] = properties - 1
						if player.questLocalData.other[id] == 0 then 
							quest_updateStep(name)
						end
					end
					break
				end
			end
			for i = 1, #player.fishing[3] do 
				removeImage(player.fishing[3][i])
			end
			players[name].fishing[3] = {}
			for i = 77777 + playerStatus.id, 77777 + playerStatus.id+2 do 
				removeGround(i)
			end
			setLifeStat(name, 1, math.random(-11, -8))
		end
	end, 1000, 28)
end

stopFishing = function(player)
	local playerStatus = ROOM.playerList[player]
	if not playerStatus then return end
	players[player].fishing[1] = false
	removeTimer(players[player].fishing[2])
	TFM.chatMessage('<r>'..translate('fishingError', player), player)
	for i = 1, #players[player].fishing[3] do 
		removeImage(players[player].fishing[3][i])
	end
	players[player].fishing[3] = {}
	for i = 77777 + playerStatus.id, 77777 + playerStatus.id+2 do 
		removeGround(i)
	end
end

--[[ items/itemList/bagIds.lua ]]--
bagIds = {
	[1] = {n = 'energyDrink_Basic'},
	[2] = {n = 'energyDrink_Mega'},
	[3] = {n = 'energyDrink_Ultra'},
	[4] = {n = 'pickaxe', blockUse = true},
	[5] = {n = 'clock'},
	[6] = {n = 'milk'},
	[7] = {n = 'goldNugget', blockUse = true},
	[8] = {n = 'dynamite'},
	[9] = {n = 'shrinkPotion'},
	[10] = {n = 'growthPotion'},
	[11] = {n = 'coffee'},
	[12] = {n = 'hotChocolate'},
	[13] = {n = 'milkShake'},
	[14] = {n = 'seed'},
	[15] = {n = 'fertilizer'},
	[16] = {n = 'water'},
	[17] = {n = 'tomato'},
	[18] = {n = 'tomatoSeed'},
	[19] = {n = 'oregano'},
	[20] = {n = 'oreganoSeed'},
	[21] = {n = 'lemon'},
	[22] = {n = 'lemonSeed'},
	[23] = {n = 'salt'},
	[24] = {n = 'pepper'},
	[25] = {n = 'pepperSeed'},
	[26] = {n = 'luckyFlower'},
	[27] = {n = 'luckyFlowerSeed'},
	[28] = {n = 'sauce'},
	[29] = {n = 'hotsauce'},
	[30] = {n = 'dough'},
	[31] = {n = 'wheat'},
	[32] = {n = 'wheatSeed'},
	[33] = {n = 'pizza'},
	[34] = {n = 'cornFlakes'},
	[35] = {n = 'pumpkin'},
	[36] = {n = 'pumpkinSeed'},
	[37] = {n = 'superFertilizer'},
	[38] = {n = 'cookies'},
	[39] = {n = 'sugar'},
	[40] = {n = 'chocolate'},
	[41] = {n = 'blueberries'},
	[42] = {n = 'blueberriesSeed'},
	[43] = {n = 'cheese'},
	[44] = {n = 'fish_SmoltFry'},
	[45] = {n = 'fish_Lionfish'},
	[46] = {n = 'fish_Dogfish'},
	[47] = {n = 'fish_Catfish'},
	[48] = {n = 'fish_RuntyGuppy'},
	[49] = {n = 'fish_Lobster'},
	[50] = {n = 'fish_Goldenmare'},
	[51] = {n = 'fish_Frog'},
	[52] = {n = 'lemonade'},
	[53] = {n = 'lobsterBisque'},
	[54] = {n = 'bread'},
	[55] = {n = 'bruschetta'},
	[56] = {n = 'waffles'},
	[57] = {n = 'egg'},
	[58] = {n = 'honey'},
	[59] = {n = 'grilledLobster'},
	[60] = {n = 'frogSandwich'},
	[61] = {n = 'chocolateCake'},
	[62] = {n = 'wheatFlour'},
	[63] = {n = 'salad'},
	[64] = {n = 'lettuce'},
	[65] = {n = 'pierogies'},
	[66] = {n = 'potato'},
	[67] = {n = 'frenchFries'},
	[68] = {n = 'pudding'},
	[69] = {n = 'garlicBread'},
	[70] = {n = 'garlic'},
	[71] = {n = 'blueprint', blockUse = true},
	[72] = {n = 'crystal_yellow', blockUse = true},
	[73] = {n = 'crystal_blue', blockUse = true},
	[74] = {n = 'crystal_purple', blockUse = true},
	[75] = {n = 'crystal_green', blockUse = true},
	[76] = {n = 'crystal_red', blockUse = true},
}

--[[ items/itemList/bagItems.lua ]]--
bagItems = {
	energyDrink_Basic = {
		id = 1,
		price = 25,
		png = '16bdd1b979c.png',
		power = 10,
		type = 'food',
		npcShop = 'kariina',
	},
	energyDrink_Mega = {
		id = 2,
		price = 30,
		png = '16bdd1bc69b.png',
		power = 15,
		type = 'food',
		npcShop = 'kariina',
	},
	energyDrink_Ultra = {
		id = 3,
		price = 60,
		png = '16bdd1b5d3c.png',
		power = 30,
		type = 'food',
		npcShop = 'kariina',
	},
	pickaxe = {
		id = 4,
		price = 20,
		png = '16bdd10faea.png',
		type = 'item',
		npcShop = '-',
		miningPower = 2,
	},
	clock = {
		id = 5,
		price = 5,
		png = '16c00f60557.png',
		type = 'item',
		func = function(i)
			TFM.chatMessage('<font color="#DAA520">'..updateHour(nil, true), i)
		end,
		npcShop = 'john',
	},
	milk = {
		id = 6,
		price = 5,
		png = '16c2cc5ea17.png',
		hunger = 1,
		type = 'food',
	},
	goldNugget = {
		id = 7,
		price = 115,
		png =  '16bc53d823f.png',
		limitedTime = os.time{day = 20, year = 2020, month = 4},
	},
	dynamite = {
		id = 8,
		price = 150,
		png = '16bfb79a95f.png',
		type = 'holdingItem',
		miningPower = 10,
		holdingImages = {'16b94a559d7.png', '16b94a57834.png'}, -- left, right
		holdingAlign = {{-19, -9}, {1, -9}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'dynamite'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
		placementFunction = function(player, x, y)
			local y = y-20
			if x > 5250 and x < 5310 and y > 5180 and y < 5250 then -- BANCO
				x = 5255
				y = 5200

				if room.gameDayStep ~= 'night' then
					players[player].place = 'police'
					addTimer(function(timer)
						if timer == 1 then
							ui.addTextArea(-32000, "<font color='#FF00000'><p align='center'>"..translate('hey', player), player, 5255, 5201-15, 100, nil, 1, 1, 0.5, false)
						elseif timer == 3 then
							ui.removeTextArea(-32000, player)
							arrestPlayer(player, 'Colt')
						end
					end, 1000, 3)
					return
				end
			elseif x > 2715 and x < 2830 and y > 1890+room.y then -- ENTRADA DO BANCO
				if room.gameDayStep == 'night' then
					x = 2771
					y = 1923 + room.y
				end
			end

			local imgToRemove = addImage('16b94de70fd.png', '!99999', x, y)


			addTimer(function()
				removeImage(imgToRemove)
				TFM.explosion(x, y, 50, 100, false)
				TFM.displayParticle(10, x, y)
				if x == 5255 and y == 5200 then -- BANCO
					if room.bankBeingRobbed then return end
					room.bankRobStep = 'robStarted'
					removeTimer('bankDoorsBroken')
					for i = 1, #room.bankImages do
						removeImage(room.bankImages[i])
					end
					room.bankImages = {}
					addBankRobbingAssets()
					reloadBankAssets()

				elseif x == 2771 and y == 1923 + room.y then -- ENTRADA DO BANCO
					if room.bankBeingRobbed then return end
					if room.bankRobStep then return end
					room.bankImages[#room.bankImages+1] = addImage("16ba618ef7d.png", "?99999", 2700, 1674+room.y)
					room.bankRobStep = 'doorsBroken'
					addTimer(function(timer)
						for i, v in next, ROOM.playerList do
							if players[i].job ~= 'police' then 
								if math.hypo(x, y, v.x, v.y) <= 100 then
									checkIfPlayerIsDriving(i)
									TFM.movePlayer(i, places['bank'].tp[1], places['bank'].tp[2], false)
									players[i].place = 'bank'
									showOptions(i)
								end
							end
						end
					end, 1000, 10, 'bankDoorsBroken')
				end
			end, 5000, 1)
			return true
		end,
		npcShop = 'john',
	},
	shrinkPotion = {
		id = 9,
		price = 40,
		png = '16bc54ccf7a.png',
		complement = 30,
		type = 'complementItem',
		func = function(i)
			local random = math.random(0, 100)
			players[i].mouseSize = players[i].mouseSize - 0.7
			TFM.changePlayerSize(i, players[i].mouseSize)
			ui.addTextArea(989000000020+random, '', i, 400 - 84 * 0.5, 365, 84, 25, 0x19ba4d, 0x19ba4d, 0.5, true)
			addTimer(function(time)
				local width = 84 - math.floor(time/30 * 80)
				ui.addTextArea(989000000020+random, '', i, 400 - 84 * 0.5, 365, width, 25, 0x19ba4d, 0x19ba4d, 0.5, true)
				if players[i].place == 'bank' then
					if room.bankRobStep == 'robStarted' then
						room.bankRobStep = 'lazers'
					end
				end
				if time == 30 then
					players[i].mouseSize = players[i].mouseSize + 0.7
					TFM.changePlayerSize(i, players[i].mouseSize)
					ui.removeTextArea(989000000020+random, i)
				end
			end, 1000, 30)
		end,
		npcShop = 'indy',
	},
	growthPotion = {
		id = 10,
		price = 40,
		png = '16bc54cf1cd.png',
		complement = 30,
		type = 'complementItem',
		func = function(i)
			local random = math.random(0, 100)
			players[i].mouseSize = players[i].mouseSize + 2
			TFM.changePlayerSize(i, players[i].mouseSize)
			ui.addTextArea(989000000020+random, '', i, 400 - 84 * 0.5, 365, 84, 25, 0xf169ef, 0xf169ef, 0.5, true)
			addTimer(function(time)
				local width = 84 - math.floor(time/30 * 80)
				ui.addTextArea(989000000020+random, '', i, 400 - 84 * 0.5, 365, width, 25, 0xf169ef, 0xf169ef, 0.5, true)
				if time == 30 then
					TFM.changePlayerSize(i, 1)
					players[i].mouseSize = players[i].mouseSize - 2
					TFM.changePlayerSize(i, players[i].mouseSize)
					ui.removeTextArea(989000000020+random, i)
				end
			end, 1000, 30)
		end,
		npcShop = 'indy',
	},
	coffee = {
		id = 11,
		price = 90,
		power = 25,
		hunger = 1,
		png = '16c00e1f53b.png',
		type = 'food',
	},
	hotChocolate = {
		id = 12,
		price = 100,
		png = '17157e81a35.png',
		type = 'food',
	},
	milkShake = {
		id = 13,
		price = 110,
		png = '17157f95ae1.png',
		type = 'food',
		npcShop = 'kariina',
	},
	seed = {
		id = 14,
		price = 50,
		png = '16bf5c783fe.png',
		type = 'holdingItem',
		holdingImages = {'16bf622f30a.png', '16bf622a802.png'}, -- left, right
		holdingAlign = {{-15, 0}, {0, 0}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'seed'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
		placementFunction = function(player, x, y, seed)
			if not seed then
				local numeroRandom = math.random(1, 10000)
				local total = 0
				seed = 1
				for type, data in next, players[player].seeds do
					total = total + data.rarity
					if total >= numeroRandom then
						seed = tonumber(type)
						break
					end
				end
			end
			if string.find(players[player].place, 'house_') then
				local house_ = tonumber(players[player].place:sub(7))
				local owner = player
				if house_ == 11 then
					owner = 'Oliver'
					if players[player].job ~= 'farmer' then
						return
					end
				end
				if table.contains(players[owner].houseTerrain, 2) then
					local idx = tonumber(players[owner].houseData.houseid)
					local yy = 1500 + 90
					for i, v in next, players[owner].houseTerrain do
						if v == 2 then
							if math.hypo(((idx-1)%idx)*1500+737 + (i-1)*175, yy+170, x, y) <= 90 then
								if players[owner].houseTerrainAdd[i] > 1 then return end
								players[owner].houseTerrainAdd[i] = 2
								players[owner].houseTerrainPlants[i] = seed
								HouseSystem.new(owner):genHouseGrounds()
								room.gardens[#room.gardens+1] = {owner = owner, timer = os.time(), terrain = i, idx = idx, plant = seed}
								local sidequest = sideQuests[players[player].sideQuests[1]].type
								if string.find(sidequest, 'type:plant') then
									if string.find(sidequest, 'oliver') and owner == 'Oliver' then
										sideQuest_update(player, 1)
									elseif not string.find(sidequest, 'oliver') then
										sideQuest_update(player, 1)
									end
								end
								return true
							end
						end
					end
				end
			end
		end,
		npcShop = 'body',
	},
	fertilizer = {
		id = 15,
		price = 200,
		png = '16bf5e01ec9.png',
		type = 'holdingItem',
		holdingImages = {'16bf5e01ec9.png', '16bf5e01ec9.png'}, -- left, right
		holdingAlign = {{-19, -9}, {1, -9}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'fertilizer'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
		placementFunction = function(player, x, y)
			if string.find(players[player].place, 'house_') then
				local house_ = tonumber(players[player].place:sub(7))
				local owner = player
				if house_ == 11 then
					owner = 'Oliver'
					if players[player].job ~= 'farmer' then
						return
					end
				end
				if table.contains(players[owner].houseTerrain, 2) then
					local idx = tonumber(players[owner].houseData.houseid)
					local yy = 1500 + 90
					for i, v in next, players[owner].houseTerrain do
						if v == 2 then
							if math.hypo(((idx-1)%idx)*1500+737 + (i-1)*175, yy+170, x, y) <= 90 then
								if players[owner].houseTerrainAdd[i] > 1 then
									for ii, vv in next, room.gardens do
										if vv.owner == owner then
											if vv.terrain == i then
												vv.timer = vv.timer - 60*3*1000
												local sidequest = sideQuests[players[player].sideQuests[1]].type
												if string.find(sidequest, 'type:fertilize') then
													if string.find(sidequest, 'oliver') and owner == 'Oliver' then
														sideQuest_update(player, 1)
													elseif not string.find(sidequest, 'oliver') then
														sideQuest_update(player, 1)
													end
												end
												return true
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end,
		npcShop = 'body',
	},
	water = {
		id = 16,
		price = 80,
		png = '1715a31e135.png',
		type = 'holdingItem',
		holdingImages = {'16bf5e003db.png', '16bf5e003db.png'}, -- left, right
		holdingAlign = {{-19, -9}, {1, -9}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'water'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
		placementFunction = function(player, x, y)
			if string.find(players[player].place, 'house_') then
				local house_ = tonumber(players[player].place:sub(7))
				local owner = player
				if house_ == 11 then
					owner = 'Oliver'
					if players[player].job ~= 'farmer' then
						return
					end
				end
				--if not players[player].houseData.houseid == house_ and players[player].job ~= 'farmer' then return end
				if table.contains(players[owner].houseTerrain, 2) then
					local idx = tonumber(players[owner].houseData.houseid)
					local yy = 1500 + 90
					for i, v in next, players[owner].houseTerrain do
						if v == 2 then
							if math.hypo(((idx-1)%idx)*1500+737 + (i-1)*175, yy+170, x, y) <= 90 then
								if players[owner].houseTerrainAdd[i] > 1 then
									for ii, vv in next, room.gardens do
										if vv.owner == owner then
											if vv.terrain == i then
												vv.timer = vv.timer - 40*1000
												return true
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end,
		npcShop = 'body',
	},
	tomato = {
		id = 17,
		price = 2,
		png = '16f94cbed5e.png',
		hunger = .5,
		type = 'food',
	},
	bag = {
		id = 18,
		price = 3000,
		capacity = 5,
		type = 'bag',
	},
	tomatoSeed = {
		id = 18,
		price = 2,
		png = '16c00dafc00.png',
		type = 'holdingItem',
		holdingImages = {'16c00dafc00.png', '16c00dafc00.png'}, -- left, right
		holdingAlign = {{-15, 0}, {0, 0}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'tomatoSeed'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
	},
	oregano = {
		id = 19,
		price = 2,
		png = '16bfcb07a36.png',
		hunger = .1,
		type = 'food',
	},
	oreganoSeed = {
		id = 20,
		price = 2,
		type = 'holdingItem',
		png = '16c258cc26c.png',
		holdingImages = {'16bf622f30a.png', '16bf622a802.png'}, -- left, right
		holdingAlign = {{-15, 0}, {0, 0}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'oreganoSeed'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
	},
	lemon = {
		id = 21,
		price = 2,
		png = '16f9568e434.png',
		power = 2,
		hunger = 3,
		type = 'food',
	},
	lemonSeed = {
		id = 22,
		price = 2,
		type = 'holdingItem',
		png = '16c00db153d.png',
		holdingImages = {'16c00db153d.png', '16c00db153d.png'}, -- left, right
		holdingAlign = {{-15, 0}, {0, 0}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'lemonSeed'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
	},
	salt = {
		id = 23,
		price = 2,
		type = 'food',
		png = '16c1bfca398.png',
		hunger = -15,
	},
	pepper = {
		id = 24,
		price = 2,
		power = 10,
		hunger = -15,
		type = 'food',
		png = '16c2595316f.png',
	},
	pepperSeed = {
		id = 25,
		price = 2,
		type = 'holdingItem',
		png = '16c25a8b729.png',
		holdingImages = {'16c00db153d.png', '16c00db153d.png'}, -- left, right
		holdingAlign = {{-15, 0}, {0, 0}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'pepperSeed'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
	},
	luckyFlower = {
		id = 26,
		price = 2,
		power = 100,
		type = 'food',
		png = '16c258971c0.png',
		func = function(i)
			setLifeStat(i, 1, 100)
		end
	},
	luckyFlowerSeed = {
		id = 27,
		price = 2,
		type = 'holdingItem',
		png = '16c259c7198.png',
		holdingImages = {'16c259c7198.png', '16c259c7198.png'}, -- left, right
		holdingAlign = {{-35, -20}, {-15, -20}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'luckyFlowerSeed'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
	},
	sauce = {
		id = 28,
		price = 20,
		type = 'food',
		png = '17157debbd9.png',
		npcShop = 'kariina',
	},
	hotsauce = {
		id = 29,
		price = 20,
		type = 'food',
		png = '17157e02ea4.png',
		npcShop = 'kariina',
	},
	dough = {
		id = 30,
		price = 70,
		type = 'food',
		png = '1715f1bd94a.png',
		limitedTime = os.time{day = 20, year = 2020, month = 4},
	},
	wheat = {
		id = 31,
		price = 20,
		type = 'food',
		png = '16f94cd95c0.png',
	},
	wheatSeed = {
		id = 32,
		price = 2,
		type = 'holdingItem',
		png = '16c2ae989c5.png',
		holdingImages = {'16c2ae989c5.png', '16c2ae989c5.png'}, -- left, right
		holdingAlign = {{-15, 0}, {0, 0}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'wheatSeed'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
	},
	pizza = {
		id = 33,
		price = 350,
		type = 'food',
		png = '171576bbb9e.png',
		power = 20,
		npcShop = 'kariina',
	},
	cornFlakes = {
		id = 34,
		price = 80,
		type = 'food',
		png = '16c35643411.png',
		power = 15,
		hunger = 10,
	},
	pumpkin = {
		id = 35,
		price = 1000,
		png = '16de6657786.png',
		type = 'food',
		power = 30,
		hunger = 20,
	},
	pumpkinSeed = {
		id = 36,
		price = 1000,
		type = 'holdingItem',
		png = '16db258644e.png',
		holdingImages = {'16db258644e.png', '16db258644e.png'}, -- left, right
		holdingAlign = {{-15, 0}, {0, 0}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'pumpkinSeed'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
	},
	superFertilizer = {
		id = 37,
		qpPrice = 8,
		png = '16dcab532fa.png',
		type = 'holdingItem',
		holdingImages = {'16dcab532fa.png', '16dcab532fa.png'}, -- left, right
		holdingAlign = {{-35, -15}, {-15, -15}}, -- left, right
		func = function(player)
			players[player].holdingItem = 'superFertilizer'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
		placementFunction = function(player, x, y)
			if string.find(players[player].place, 'house_') then
				local house_ = tonumber(players[player].place:sub(7))
				local owner = player
				if house_ == 11 then
					owner = 'Oliver'
					if players[player].job ~= 'farmer' then
						return
					end
				end
				if table.contains(players[owner].houseTerrain, 2) then
					local idx = tonumber(players[owner].houseData.houseid)
					local yy = 1500 + 90
					for i, v in next, players[owner].houseTerrain do
						if v == 2 then
							if math.hypo(((idx-1)%idx)*1500+737 + (i-1)*175, yy+170, x, y) <= 90 then
								if players[owner].houseTerrainAdd[i] > 1 then
									for ii, vv in next, room.gardens do
										if vv.owner == owner then
											if vv.terrain == i then
												vv.timer = vv.timer - 60*6*1000
												local sidequest = sideQuests[players[player].sideQuests[1]].type
												if string.find(sidequest, 'type:fertilize') then
													if string.find(sidequest, 'oliver') and owner == 'Oliver' then
														sideQuest_update(player, 1)
													elseif not string.find(sidequest, 'oliver') then
														sideQuest_update(player, 1)
													end
												end
												return true
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end,
		npcShop = 'marcus',
	},
	cookies = {
		id = 38,
		price = 0,
		png = '17157d3d7b0.png',
		type = 'food',
	},
	sugar = {
		id = 39,
		price = 3,
		png = '16f0571d9f9.png',
		type = 'food',
	},
	chocolate = {
		id = 40,
		price = 30,
		png = '16f05a12ea3.png',
		type = 'food',
		power = 6,
		hunger = 2,
	},
	blueberries = {
		id = 41,
		price = 100,
		type = 'food',
		png = '17097199d00.png',
		power = 10,
		hunger = 5,
	},
	blueberriesSeed = {
		id = 42,
		price = 300,
		qpPrice = 4,
		png = '16f23b75123.png',
		holdingImages = {'16f23b75123.png', '16f23b75123.png'}, -- left, right
		holdingAlign = {{-35, -15}, {-15, -15}}, -- left, right
		type = 'holdingItem',
		type2 = 'limited-christmas2019',
		limitedTime = os.time{day=15, year=2020, month=1},
		func = function(player)
			players[player].holdingItem = 'blueberriesSeed'
			players[player].holdingDirection = (ROOM.playerList[player].isFacingRight and 'right' or 'left')
			closeInterface(player, false, false, true)
		end,
	},
	cheese = {
		id = 43,
		price = 100,
		type = 'item',
		png = '170b6b4db9c.png',
		func = function(i)
			local oldPositions = {ROOM.playerList[i].x, ROOM.playerList[i].y}
			TFM.giveCheese(i)
			TFM.giveCheese(i)
			TFM.giveCheese(i)
			TFM.playerVictory(i)
			TFM.respawnPlayer(i)
			if players[i].isBlind then setNightMode(i) end
			if players[i].isFrozen then freezePlayer(i, true) end
			TFM.movePlayer(i, oldPositions[1], oldPositions[2], false)
		end
	},
	fish_SmoltFry = {
		id = 44,
		price = 15,
		type = 'food',
		png = '170b7040298.png',
		power = -10,
		hunger = -10,
	},
	fish_Lionfish = {
		id = 45,
		price = 300,
		type = 'food',
		png = '170b733380f.png',
		power = -10,
		hunger = -10,
	},
	fish_Dogfish = {
		id = 46,
		price = 300,
		type = 'food',
		png = '170b778a98b.png',
		power = -10,
		hunger = -10,
	},
	fish_Catfish = {
		id = 47,
		price = 300,
		type = 'food',
		png = '170b77a4f6d.png',
		power = -10,
		hunger = -10,
	},
	fish_RuntyGuppy = {
		id = 48,
		price = 50,
		type = 'food',
		png = '170b77ca0c7.png',
		power = -10,
		hunger = -10,
	},
	fish_Lobster = {
		id = 49,
		price = 1000,
		type = 'food',
		png = '170b788a90d.png',
		power = -20,
		hunger = -20,
	},
	fish_Goldenmare = {
		id = 50,
		price = 10000,
		type = 'food',
		png = '170b7904d24.png',
		power = -20,
		hunger = -20,
	},
	fish_Frog = {
		id = 51,
		price = 15,
		type = 'food',
		png = '170c186188b.png',
		power = -20,
		hunger = -40,
	},
	lemonade = {
		id = 52,
		price = 0,
		png = '17157d74289.png',
		type = 'food',
	},
	lobsterBisque = {
		id = 53,
		price = 0,
		png = '17157feb8ea.png',
		type = 'food',
	},
	bread = {
		id = 54,
		price = 0,
		png = '171577ce37b.png',
		type = 'food',
	},
	bruschetta = {
		id = 55,
		price = 0,
		png = '17157829bde.png',
		type = 'food',
	},
	waffles = {
		id = 56,
		price = 0,
		png = '171578aa546.png',
		type = 'food',
	},
	egg = {
		id = 57,
		price = 10,
		png = '171984833f2.png',
		type = 'food',
		power = 1,
		hunger = 1,
	},
	honey = {
		id = 58,
		price = 50,
		png = '17157936a24.png',
		type = 'food',
		power = 1,
		hunger = 3,
	},
	grilledLobster = {
		id = 59,
		price = 0,
		png = '17157dd5e6a.png',
		type = 'food',
	},
	frogSandwich = {
		id = 60,
		price = 0,
		png = '17157f6d781.png',
		type = 'food',
	},
	chocolateCake = {
		id = 61,
		price = 0,
		png = '1715a4b33a0.png',
		type = 'food',
	},
	wheatFlour = {
		id = 62,	
		price = 0,
		png = '172af5128f3.png',
		type = 'food',
		power = 1,
		hunger = 1,
	},
	salad = {
		id = 63,	
		price = 0,
		png = '1715a459466.png',
		type = 'food',
	},
	lettuce = {
		id = 64,	
		price = 20,
		png = '17198461537.png',
		type = 'food',
		hunger = .1,
	},
	pierogies = {
		id = 65,	
		price = 20,
		png = '1715af36d28.png',
		type = 'food',
	},
	potato = {
		id = 66,	
		price = 20,
		png = '1715af76cee.png',
		type = 'food',
		hunger = 0.7,
	},
	frenchFries = {
		id = 67,	
		price = 20,
		png = '1715aff214a.png',
		type = 'food',
	},
	pudding = {
		id = 68,	
		price = 20,
		png = '1715b4476e2.png',
		type = 'food',
	},
	garlicBread = {
		id = 69,	
		price = 20,
		png = '1715f2f672e.png',
		type = 'food',
	},
	garlic = {
		id = 70,	
		price = 20,
		png = '1715f38e713.png',
		type = 'food',
		power = 4,
		hunger = 1,
	},
	blueprint = {
		id = 71,
		price = 200,
		type = 'holdingItem',
		png = '171af19adb5.png',
	},
	crystal_yellow = {
		id = 72,
		type = 'crystal',
		png = '172373f61f1.png',
	},
	crystal_blue = {
		id = 73,
		type = 'crystal',
		png = '172373eddec.png',
	},
	crystal_purple = {
		id = 74,
		type = 'crystal',
		png = '172373f2060.png',
	},
	crystal_green = {
		id = 75,
		type = 'crystal',
		png = '172373f009d.png',
	},
	crystal_red = {
		id = 76,
		type = 'crystal',
		png = '172373f3f04.png',
	},
}

--[[ items/itemList/recipes.lua ]]--
recipes = {
    sauce = {
        require = {
            tomato = 3,
            water = 1,
            salt = 1,
        },
    },
	hotsauce = {
        require = {
            tomato = 3,
			pepper = 2,
            water = 1,
            salt = 1,
        },
    },
	pizza = {
		require = {
			wheatFlour = 1,
            tomato = 2,
			sauce = 1,
			oregano = 2,
			milk = 2,
			cheese = 1,
        },
	},
	cookies = {
		require = {
			wheatFlour = 1,
			milk = 1,
			sugar = 1,
			chocolate = 1,
        },
	},
	hotChocolate = {
		require = {
			milk = 1,
			chocolate = 2,
        },
	},
	milkShake = {
		require = {
			blueberries = 1,
			milk = 1,
			sugar = 1,
        },
	},
	lemonade = {
		require = {
			lemon = 2,
			water = 1,
			sugar = 1,
		},
	},
	lobsterBisque = {
		require = {
			fish_Lobster = 1,
			milk = 1,
			salt = 1,
		},
	},
	bread = {
		require = {
			water = 1,
			wheatFlour = 1,
			salt = 1,
			sugar = 1,
		},
	},
	bruschetta = {
		require = {
			bread = 1,
			tomato = 1,
			oregano = 1,
		},
	},
	waffles = {
		require = {
			sugar = 1,
			salt = 1,
			egg = 1,
			wheatFlour = 3,
			milk = 1,
			honey = 1,
		},
	},
	grilledLobster = {
		require = {
			fish_Lobster = 1,
			salt = 2,
			lemon = 3,
		},
	},
	frogSandwich = {
		require = {
			fish_Frog = 1,
			bread = 1,
			tomato = 1,
		},
	},
	chocolateCake = {
		require = {
			chocolate = 2,
			milk = 1,
			egg = 3,
			sugar = 1,
			wheatFlour = 3,
		},
	},
	salad = {
		require = {
			tomato = 2,
			egg = 1,
			cheese = 1,
			lettuce = 2,
		},
	},
	pierogies = {
		require = {
			cheese = 1,
			wheatFlour = 2,
			egg = 2,
			salt = 1,
			potato = 2,
		},
	},
	frenchFries = {
		require = {
			potato = 2,
			salt = 1,
		},
	},
	pudding = {
		require = {
			milk = 2,
			sugar = 1,
			egg = 3
		},
	},
	garlicBread = {
		require = {
			bread = 1,
			garlic = 1,
			cheese = 1,
			oregano = 1,
			salt = 1,
		},
	},
}

--[[ items/bag.lua ]]--
addItem = function(item, amount, player, coin)
	local id = bagItems[item].id
	if not coin then coin = 0 end
	if players[player].coins < coin then return end

	for id, properties in next, players[player].questLocalData.other do 
		if id:find('ItemQuanty_') then
			if id:lower():find(item:lower()) then 
				if type(properties) == 'boolean' then 
					quest_updateStep(player)
				else 
					players[player].questLocalData.other[id] = properties - 1
					if players[player].questLocalData.other[id] <= 0 then 
						quest_updateStep(player)
					end
				end
				break
			end
		end
	end
	local canAdd = false
	players[player].totalOfStoredItems.bag = 0
	for i, v in next, players[player].bag do 
		players[player].totalOfStoredItems.bag = players[player].totalOfStoredItems.bag + v.qt
		if v.name == item then
			canAdd = i
		end
	end

	if players[player].totalOfStoredItems.bag + amount > players[player].bagLimit then
		return alert_Error(player, 'error', 'bagError')
	else
		players[player].totalOfStoredItems.bag = players[player].totalOfStoredItems.bag + amount
	end
	if canAdd then 
		players[player].bag[canAdd].qt = players[player].bag[canAdd].qt + amount
		giveCoin(-coin, player)
		return
	end

	players[player].bag[#players[player].bag+1] = {name = item, qt = amount}
	giveCoin(-coin, player)
end

removeBagItem = function(item, amount, player)
	amount = math.abs(amount)
	for i, v in next, players[player].bag do
		if v.name == item then
			v.qt = v.qt - amount
			if v.qt <= 0 then
				table.remove(players[player].bag, i)
			end
			break
		end
	end
	players[player].totalOfStoredItems.bag = players[player].totalOfStoredItems.bag - amount
	savedata(player)
end

--[[ items/checkAmount.lua ]]--
checkItemQuanty = function(item, quant, player)
	if not players[player].bag then return end
	if #players[player].bag == 0 then return false end
	for i, v in next, players[player].bag do
		if v.name == item then
			if v.qt >= quant then
				return v.qt
			end
		end
	end
	return false
end

--[[ items/chest.lua ]]--
item_addToChest = function(item, amount, player, chest)
	if not chest then chest = 1 end
	players[player].totalOfStoredItems.chest[chest] = players[player].totalOfStoredItems.chest[chest] + amount
	for i, v in next, players[player].houseData.chests.storage[chest] do
		if v.name == item then
			v.qt = v.qt + amount
			savedata(player)
			return
		end
	end
	players[player].houseData.chests.storage[chest][#players[player].houseData.chests.storage[chest]+1] = {name = item, qt = amount}
	savedata(player)
end

item_removeFromChest = function(item, amount, player, chest)
	amount = math.abs(amount)
	for i, v in next, players[player].houseData.chests.storage[chest] do
		if v.name == item then
			v.qt = v.qt - amount
			if v.qt <= 0 then
				table.remove(players[player].houseData.chests.storage[chest], i)
			end
			break
		end
	end
	players[player].totalOfStoredItems.chest[chest] = players[player].totalOfStoredItems.chest[chest] - amount
	savedata(player)
end

--[[ items/drop.lua ]]--
item_drop = function(item, player, amount)
	local x, y
	amount = amount or 1
	if type(player) == 'string' then 
		x = ROOM.playerList[player].x
		y = ROOM.playerList[player].y-10
	else -- or a table, with x and y values
		x = player.x 
		y = player.y-10
		player = 'Oliver'
	end
	room.droppedItems[#room.droppedItems+1] = {owner = player, amount = amount, x = x, y = y, item = item, id = bagItems[item].id, collected = false, image = addImage(bagItems[item].png and bagItems[item].png or '16bc368f352.png', '_700', x, y)}
	ui.addTextArea(-40000-#room.droppedItems, "<textformat leftmargin='1' rightmargin='1'><a href='event:collectDroppedItem_"..#room.droppedItems.."'>"..string.rep('\n', 5), nil, x, y, 50, 50, 1, 1, 0, false)
	item_droppedEvent(#room.droppedItems, player)
end

item_collect = function(item, target, amount)
	if room.droppedItems[item].amount <= 0 then return end
	if not amount then amount = 1 end

	local xx = target and ROOM.playerList[target].x or room.droppedItems[item].x
	local yy = target and ROOM.playerList[target].y or room.droppedItems[item].y
	if math.hypo(room.droppedItems[item].x, room.droppedItems[item].y, xx, yy) > 60 then return end

	if target then 
		local data = room.droppedItems[item]
		addItem(data.item, amount, target)
	end
	room.droppedItems[item].amount = room.droppedItems[item].amount - amount

	if room.droppedItems[item].amount <= 0 then 
		removeImage(room.droppedItems[item].image)
		ui.removeTextArea(-40000-item)
		room.droppedItems[item].collected = true
	end
end

item_droppedEvent = function(id, player)
	local canRemove = false
	local item = room.droppedItems[id].item
	local amount = room.droppedItems[id].amount
	if amount <= 0 then return end
	if checkLocation_isInHouse(player) then
		local terrainID = players[player].houseData.houseid
		for chestID, v in next, players[player].houseData.chests.position do
			if math.hypo(ROOM.playerList[player].x, ROOM.playerList[player].y, v.x+20, v.y+20) <= 50 then
				if players[player].totalOfStoredItems.chest[chestID] + amount > 50 then return TFM.chatMessage('<r>'.. translate('chestIsFull', player), player) end
				item_addToChest(item, amount, player, chestID)
				TFM.chatMessage('<j>'.. translate('itemAddedToChest', player):format('<vp>'.. translate('item_'..item, player) ..'</vp> <CE>('..amount..')</CE>'), player)
				canRemove = true
			end
		end
	elseif players[player].job == 'farmer' and tonumber(players[player].place:sub(7)) == 11 and string.find(item, 'Seed') then
		for i, v in next, houseTerrainsAdd.plants do
			if string.find(item, v.name) then
				canRemove = true
				giveCoin(v.pricePerSeed * amount, player, true)
				TFM.chatMessage('<j>'..translate('seedSold', player):format('<vp>'..translate('item_'..v.name..'Seed', player)..'</vp>', '<fc>$'..v.pricePerSeed..'</fc> <CE>('..amount..')</CE>'), player)
				job_updatePlayerStats(player, 6, amount)
				giveExperiencePoints(player, 2 * amount)
				break
			end
		end
	elseif players[player].job == 'fisher' and players[player].place == 'fishShop' and string.find(item, 'fish_') then
		canRemove = true
		giveCoin(bagItems[item].price * amount, player)
		TFM.chatMessage('<j>'..translate('seedSold', player):format('<vp>'..translate('item_'..item, player)..'</vp>', '<fc>$'..bagItems[item].price..'</fc> <CE>('..amount..')</CE>'), player)
	elseif players[player].job == 'miner' and players[player].place == 'mine' then
		if item:find('crystal_') or item:find('goldNugget') then
			if ROOM.playerList[player].x > 475 and ROOM.playerList[player].x < 745 and ROOM.playerList[player].y > 8070 and ROOM.playerList[player].y < 8230 then
				canRemove = true
				giveCoin(bagItems[item].price * amount, player)
				giveExperiencePoints(player, 40 * amount)
				TFM.chatMessage('<j>'..translate('seedSold', player):format('<vp>'..translate('item_'..item, player)..'</vp>', '<fc>$'..bagItems[item].price..'</fc> <CE>('..amount..')</CE>'), player)
			end
		end
	end
	if canRemove then 
		item_collect(id, nil, amount)
	end
end

--[[ items/itemInfo.lua ]]--
item_getDescription = function(item, player, isFurniture)
	local itemData = isFurniture and mainAssets.__furnitures[item] or bagItems[item]
	local description = lang.en['itemDesc_'..item] and '<p align="center"><i>"'..translate('itemDesc_'..item, player)..'"</i><v><p align="left">\n' or ''
	if not isFurniture then
		local itemType = itemData.type
		local power = itemData.power or 0
		local hunger = itemData.hunger or 0	
		if itemType == 'complementItem' then
			description = '<p align="center"><i>"'..translate('itemDesc_'..item, player):format(itemData.complement)..'"</i><v><p align="left">\n'
		end
		if itemType == 'food' then 
			description = description .. '<font size="10"><v>'..string.format(translate('energyInfo', player) ..'\n'.. translate('hungerInfo', player), '<vp>'..power..'</vp>', '<vp>'..hunger..'</vp>')
		elseif itemData.miningPower then 
			description = description .. translate('itemInfo_miningPower', player):format('<vp>0</vp>')
		elseif item:find('Seed') and not isFurniture then 
			local txt = translate('itemInfo_Seed', player)
			for i, v in next, houseTerrainsAdd.plants do 
				if item:lower():find(v.name:lower()) then 
					txt = txt:format((v.growingTime * (#v.stages-2)/60), v.pricePerSeed)..'\n'
					break
				end
			end
			description = description .. txt
		end
	end
	if itemData.credits then
		description = description ..translate('createdBy', player):format('<v>'..itemData.credits)..'\n'
	end
	return description
end

loadExtraItemInfo = function(v, player)
	if players[player].selectedItem.images[1] then
		for i, v in next, players[player].selectedItem.images do
			removeImage(players[player].selectedItem.images[i])
		end
		players[player].selectedItem.images = {}
	end
	if v.limitedTime then
		if not formatDaysRemaining(v.limitedTime, true) then
			ui.addTextArea(99079, '<font size="9"><r>'..translate('daysLeft', player):format(formatDaysRemaining(v.limitedTime)), player, 525, 200, nil, nil, 0xff0000, 0xff0000, 0, true)
			players[player].selectedItem.images[#players[player].selectedItem.images+1] = addImage('16ddbab9690.png', "&70",	510, 198, player)
		else
			ui.addTextArea(99079, '<font size="9"><r><p align="center">'..translate('collectorItem', player), player, 500, 200, 110, nil, 0xff0000, 0xff0000, 0, true)
		end
	end
end

--[[ events/NewPlayer.lua ]]--
eventNewPlayer = function(player)
	ui.setMapName('Mycity')
	TFM.setPlayerScore(player, 0)
	ui.addTextArea(8500, '', player, 805, -200, 15000, 1000, 0x6a7595, 0x6a7595, 1, true)
	ui.addTextArea(8501, '', player, -15005, -200, 15000, 1000, 0x6a7595, 0x6a7595, 1, true)
	ui.addTextArea(8502, '', player, -100, -1000, 1000, 1000, 0x6a7595, 0x6a7595, 1, true)
	ui.addTextArea(8503, '', player, -100, 600, 1000, 1000, 0x6a7595, 0x6a7595, 1, true)
	local playerLanguage = ROOM.playerList[player] and lang[ROOM.playerList[player].community] and ROOM.playerList[player].community or 'en'
	if room.isInLobby then
		addImage("16d888d9074.jpg", "?1", 0, 0, player)
		addImage("16d88917a35.png", "!1", 0, 0, player)
		addImage("16d84d2ead7.png", "!1", 620, 315, player)
		players[player] = {
			lang = playerLanguage,
			settings = {mirroredMode = 0, language = playerLanguage},
		}
		TFM.respawnPlayer(player)
		return
	end

	ui.removeTextArea(0, player)
	TFM.changePlayerSize(player, 1)
	TFM.lowerSyncDelay(player)
	setPlayerData(player)
	
	for i = 1, #imgsToLoad do
		local pngLoad = addImage(imgsToLoad[i], "!0", 0, 0, player)
		removeImage(pngLoad)
	end
	if not table.contains(room.bannedPlayers, player) then
		TFM.respawnPlayer(player)
	end
	local buildShopImages = {
		['br'] = '16f1a5b0601.png',
		['en'] = '16f1a5485c6.png',
		['hu'] = '16f1ef2fd1d.png',
	}

	-- PLACE: Jason's Workshop
		addImage(buildShopImages[players[player].lang] or buildShopImages['en'], "?7", 440, 1601+room.y, player)
	-- PLACE: Police Station 
		addImage("15a09d13130.png", "?8", 1000, 1569+room.y, player)
	-- PLACE: Clock Tower 
		addImage("1708d053178.png", '?9', 2050, 1600+room.y, player)
	-- PLACE: Bank
		addImage("16b947781b3.png", "?10", 2700, 7487, player)
	-- Ranking 
		addImage("17118e74fb1.png", "?11", 3710, 7480, player)
		addImage('17118ee6159.jpg', '?12', 3807, 7535, player)
		addImage('17118f3c5fd.jpg', '?13', 3807, 7560, player)
		for i = 1, 7 do 
			addImage("1711921401a.png", "?14", 3669 + (i-1)*93, 7725, player)
		end
	-- PLACE: Market
		addImage("16f0a2f5cab.png", "?16", 3390, 1764+room.y-7, player)
	-- PLACE: Pizzeria 
		addImage("15cb39bcd7a.png", '?17', 4320, 1761+room.y, player)
	-- PLACE: Hospital 
		addImage("16f1bb06081.png", "?18", 4650, 1560+room.y+11, player)
	-- BIOME: Ocean
		addImage("17087b677f9.png", "?20", 6399, 7800, player)
		addImage("17087b28e8a.png", "!10", 6399, 7800, player)
	-- PLACE: Island
		addImage("170926f4ab0.png", "?21", 9160, 7400, player)
		addImage("171b840b733.png", "?22", 13893, 7375, player)
		-- Bridge
			addImage("1709285ec20.png", "!13", 10745, 7375, player)
	-- PLACE: Seed Store
		local seedStoreImages = {
			['hu'] = '16bf12dd2b9.png',
			['br'] = '16bf13025d7.png',
			['en'] = '16bed4a6af2.png',
			['ar'] = '16bf1362eb3.png',
			['ru'] = '16bf26aae78.png',
		}
		addImage(seedStoreImages[players[player].lang] or seedStoreImages['en'], "?50", 11850, 7580, player) -- seed store		

	-- PLACE: MARKET (INSIDE)
		addImage("16f099f563c.png", "!100", 3440, 23, player)
	-- PLACE: FISH SHOP (INSIDE)
		addImage("170c6638bfe.png", '?101', 12180, -2, player)
	-- PLACE: JASON'S WORKSHOP (INSIDE)
		addImage("15a2f1f294b.png", "?102", 0, 0, player)
	-- PLACE: HOSPITAL (INSIDE)
		local hoslpitalFloors = {'16f1b72c3de.png', '16f1b724b56.png', '16f1b7271e5.png', '16f1b76293f.png'}
		for i = 1, 4 do
			addImage(hoslpitalFloors[i], '?103', ((i-1)%i)*900+4000, 3000, player)
		end
		addImage("16f1b804909.png", '?108', 4000, 3400, player)
	-- PLACE: CAFÉ (INSIDE)
		addImage("16bdefba853.png", "?109", 6000, 33, player)
		addImage("16bdf046e52.png", "!103", 6000, 33, player)
	-- PLACE: POTION SHOP (INSIDE)
		addImage("1709756104e.png", '?110', 10500, 30, player)
	-- PLACE: BANK (INSIDE)
		addImage("16bb8f88e17.png", "?111", 5000, 4555, player)
		addImage("16baf00d3da.png", "?112", 5791, 4596, player)
		addImage("16bb495d6f9.png", "?113", 5275, 4973, player)
		for i = 1, 5 do
			addImage("16ba53983a1.jpg", "?114", (i-1)*55 + 5705, 5150, player)
			ui.addTextArea(-500+i, '<a href="event:enterCode">'..string.rep('\n', 10), player, (i-1)*55 + 5705, 5150, 50, 100, 1, 1, 0)
			addImage("16be83d875e.png", "_699", (i-1)*200 + 8800, 126+25, player)
			-- Trees
			addImage('170c16e6f4e.png', '?1', (i-1)*3300 - 100, -100, player)
		end
	-- PLACE: MINE 
		addImage("172013ac7fd.png", "!121", 1000, 8450, player)
		addImage('171faa126c9.jpg', '?122', Mine.position[1], Mine.position[2])
		addImage('17237a02cc6.png', '_123', 4335, 8530, player)
		addImage('172713e8fef.png', '_1240', 1900, 8820, player)
		addImage('17271705113.jpg', '?123', 0, 8900, player)

	-- PLACE: BOAT SHOP
		addImage('17271d81969.png', '?123', 750, 9125, player)

	-- Dealership
	addImage("16be82ddaa9.png", "?20", 8400, 0, player)
	addImage("16be76d2c15.png", "_700", 9600, 190+11, player)
	addImage("15b302a7102.png", "_701", 9400, 190+11, player)
	addImage("16beb272303.png", "_702", 9210, 195+11, player)
	addImage("15b4b270f39.png", "_703", 9030, 190+11, player)
	addImage("15b2a61ce19.png", "_704", 8830, 190+11, player)

	-- seed store
	addImage("16c015c70f7.png", '?50', 11350, 4, player)
	-- pizzeria
	addImage("16c06b726bd.png", '?51', 14000, 4, player)
	-- furnitureStore
	addImage("16c3547311b.png", '?55', 16000, 4+10, player)
	-- oliver
	addImage("16d9986258c.png", '_81', 15550, 1625, player)
	addImage("16d99863ceb.png", '!82', 15495, 1622, player)
	addImage("16db23673c6.png", '_83', 15100, 1208, player)

	gameNpcs.addCharacter('Kapo', {'17193b948a7.png', '17185214c3c.png'}, player, 11750, 7677)
	gameNpcs.addCharacter('Santih', {'17193ec241f.png', '1718deb8f6f.png'}, player, 10630, 7677)
	gameNpcs.addCharacter('Louis', {'1719408559d.png', '1718e133635.png'}, player, 14150, 139, {type = '?'})
	gameNpcs.addCharacter('*Souris', {'1719408754d.png', '1718e2f4445.png'}, player, 14620, 139, {type = '?'})
	gameNpcs.addCharacter('Rupe', {'1719455ee6d.png', '17193000220.png'}, player, 780, 8509, {job = 'miner'})
	gameNpcs.addCharacter('Heinrich', {'1719454397f.png', '171930c5cda.png'}, player, 670, 8509, {job = 'miner', endEvent = function(name) job_invite('miner', name) end})
	gameNpcs.addCharacter('Paulo', {'1719452167a.png', '17193169110.png'}, player, 590, 8509, {job = 'miner'})
	gameNpcs.addCharacter('Goldie', {'17193b5b818.png', '172a0261c76.png'}, player, 540, 8092, {job = 'miner'})
	gameNpcs.addCharacter('Dave', {'17193cb4903.png'}, player, 11670, 7677, {job = 'farmer', callback = function(name) modernUI.new(name, 240, 220, translate('daveOffers', player)):build():tradeInterface() end})
	gameNpcs.addCharacter('Marcus', {'17193d8cabe.png'}, player, 15280, 1468, {job = 'farmer', sellingItems = true})
	gameNpcs.addCharacter('Body', {'17193e274cd.png'}, player, 11880, 153, {color = '20B2AA', sellingItems = true})
	gameNpcs.addCharacter('Kariina', {'17193fda8a1.png'}, player, 14850, 153, {color = '20B2AA', sellingItems = true})
	gameNpcs.addCharacter('Chrystian', {'171940da6ee.png'}, player, 16820, 153, {color = '20B2AA', sellingItems = true})
	gameNpcs.addCharacter('Patric', {'17194118fa0.png'}, player, 13050, 153, {job = 'fisher', jobConfirm = true})
	gameNpcs.addCharacter('Sherlock', {'171941d5222.png', '171a4910f9f.png'}, player, 7180, 5997, {job = 'police', jobConfirm = true})
	gameNpcs.addCharacter('Oliver', {'171945c8816.png', '171b7af8508.png'}, player, 15620, 1618, {job = 'farmer', jobConfirm = true})
	gameNpcs.addCharacter('Indy', {'171945ff967.png', '171a3de6a6d.png'}, player, 10820, 153, {color = '20B2AA', sellingItems = true})
	gameNpcs.addCharacter('Davi', {'171989750b8.png', '17198988913.png'}, player, 13070, 7513)
	gameNpcs.addCharacter('Pablo', {'17198a9903d.png', '1729ff740fd.png'}, player, 5090, 153, {job = 'thief', endEvent = function(name) job_invite('thief', name) end})
	gameNpcs.addCharacter('Derek', {'17198af24b4.png', '1729ff71a42.png'}, player, 5000, 153, {job = 'thief'})
	gameNpcs.addCharacter('Billy', {'17198b0df10.png', '1729ff6f7d2.png'}, player, 4955, 153, {job = 'thief'})
	gameNpcs.addCharacter('Lauren', {'17198c1b7b5.png', '17198c3bd45.png'}, player, 14337, 139, {type = '?', canRob = {cooldown = 100}})
	gameNpcs.addCharacter('Marie', {'17198c6b4ee.png', '17198c8206f.png'}, player, 14440, 139, {type = '?'})
	gameNpcs.addCharacter('Natasha', {'171995781e5.png', '171eb2e9c92.png'}, player, 3775, 125, {type = '_', canRob = {cooldown = 100}})
	gameNpcs.addCharacter('Cassy', {'171995ccbe9.png', '171eb2e7ae6.png'}, player, 3650, 125, {type = '_', canRob = {cooldown = 100}})
	gameNpcs.addCharacter('Julie', {'171995ecdee.png', '171eb2eb8df.png'}, player, 3900, 125, {type = '_', canRob = {cooldown = 100}})
	gameNpcs.addCharacter('Jason', {'17199cb7d8b.png', '1729ffd4116.png'}, player, 400, 153, {canRob = {cooldown = 100}})
	gameNpcs.addCharacter('Alicia', {'17199d3b9b2.png', '172a027ee8c.png'}, player, 6800, 153, {canRob = {cooldown = 130}})
	gameNpcs.addCharacter('Colt', {'1719dc3bce6.png', '171a4adc2e1.png'}, player, 5250, 5147, {job = 'police'})
	gameNpcs.addCharacter('Alexa', {'171ae65bf52.png', '171ae65d8a1.png'}, player, 7740, 5997, {job = 'police'})
	gameNpcs.addCharacter('Sebastian', {'171a497f4e2.png', '171a4adc2e1.png'}, player, 7195, 5852, {job = 'police'})
	gameNpcs.addCharacter('Paul', {'171ae7460aa.png', '171ae74916a.png'}, player, 7650, 5997, {job = 'police'})
	gameNpcs.addCharacter('John', {'1723790df64.png', '172379248f7.png'}, player, 4370, 8547, {job = 'miner', sellingItems = true})
	gameNpcs.addCharacter('Blank', {'17275e43fe4.png', '17275e2a2f4.png'}, player, 1140, 9314, {endEvent = 
		function(name) 
			if checkItemQuanty('luckyFlower', 1, name) and checkItemQuanty('fish_Goldenmare', 1, name) then 
				removeBagItem('luckyFlower', 1, name)
				removeBagItem('fish_Goldenmare', 1, name)
				room.boatShop2ndFloor = true 
				removeGround(7777777777) 
				for name in next, ROOM.playerList do 
					showBoatShop(name, 1) 
				end
			end
		end})
	gameNpcs.addCharacter('Remi', {'1727bfa1d1a.png', '1727bf9fc49.png'}, player, 14350, 1618, {job = 'chef', jobConfirm = true})
	gameNpcs.addCharacter('Lucas', {'1727c604ce6.png'}, player, 14560, 1618, {job = 'chef', sellingItems = true})
	gameNpcs.addCharacter('Weth', {'172a03553a1.png', '172a0351254.png'}, player, 13995, 1597, {type = '_', canRob = {cooldown = 100}})
	gameNpcs.addCharacter('Ana', {'172ab8366bb.png'}, player, 14170, 1597, {type = '_', blockClick = true})
	gameNpcs.addCharacter('Gui', {'172ab830075.png'}, player, 14100, 1597, {type = '_', blockClick = true})
	gameNpcs.addCharacter('Gabe', {'172ab834050.png'}, player, 14205, 1597, {type = '_', blockClick = true})
	gameNpcs.addCharacter('Luan', {'172ab8a9ff7.png'}, player, 13955, 1597, {type = '_', blockClick = true})
	gameNpcs.addCharacter('Bruna', {'172af626b89.png'}, player, 13890, 1597, {type = '_', blockClick = true})
	gameNpcs.addCharacter('Bill', {'171b7b0d0a2.png', '171b81a2307.png'}, player, 12800, 153, {job = 'fisher', formatDialog = 'fishingLuckiness'})
	gameNpcs.addCharacter('Mrsbritt87', {'172b9645b79.png', '172b98d0d52.png'}, player, 9400, 7645, {type = '_', donator = true})

	if room.dayCounter > 0 then 
		room.bank.paperImages[#room.bank.paperImages+1] = addImage('16bbf3aa649.png', '!1', room.bank.paperPlaces[room.bank.paperCurrentPlace].x, room.bank.paperPlaces[room.bank.paperCurrentPlace].y, player)
		ui.addTextArea(-3333, '<a href="event:getVaultPassword">'..string.rep('\n', 10), player, room.bank.paperPlaces[room.bank.paperCurrentPlace].x, room.bank.paperPlaces[room.bank.paperCurrentPlace].y, 20, 20, 0, 0, 0)
	end
	for _, key in next, {0, 1, 2, 3, 32, 70, 71} do 
		system.bindKeyboard(player, key, true) 
		system.bindKeyboard(player, key, false, true) 
	end
	for block, active in next, Mine.availableRocks do 
		if active then
			mine_reloadBlock(block, player)
		end 
	end
	if player:find('*') then
		ui.addTextArea(54215, '', player, -5, -10, 850, 500, 1, 1, 1, true)
	end
	ui.addTextArea(4444440, string.rep('\n', 5), player, 14455, 1668, 90, 45, 1, 1, 0, false, 
		function()
			eventTextAreaCallback(0, player, 'recipes', true)
		end)
	ui.addTextArea(20880, '', player, 0, 0, 800, 400, 0x152d30, 0x152d30, 0.7, true)
	sendMenu(99, player, '<p align="center"><font size="16"><vp>v'..table.concat(version, '.')..'</vp> - '.. translate('$VersionName', player) ..'</font>', 400 - 620 *0.5, 200 - 320*0.5, 600, 300, 1, false, 1, false, false, false, 15)

	updateHour(player)

	background(player)
	reloadBankAssets()
	loadRanking(player)

	if player == 'Fofinhoppp#0000' then
		for i, v in next, ROOM.playerList do
			if players[i] and players[i].dataLoaded and player ~= i then
				giveBadge(i, 1)
			end
		end
	end
end

--[[ events/ChatCommand.lua ]]--
onEvent("ChatCommand", function(player, command)
	if room.isInLobby then return end

	local args = {}
    for i in command:gmatch('%S+') do
        args[#args+1] = i
    end
    local command = table.remove(args, 1):lower()
	if chatCommands[command] then
		local continue = false
		if not chatCommands[command].permissions then
			continue = true
		else
			for _, role in next, chatCommands[command].permissions do
				if table.contains(mainAssets.roles[role], player) then
					continue = true
					break
				end
			end
		end
		if continue then
			chatCommands[command].event(player, args)
		end
	end
end)

--[[ events/EmotePlayed.lua ]]--
onEvent('EmotePlayed', function(player, emote)
	if room.isInLobby then return end
	if emote ~= 11 and players[player].fishing[1] then
		stopFishing(player)
	end
end)

--[[ events/FileLoaded.lua ]]--
onEvent("FileLoaded", function(file, data)
	local datas = {}
    for _data in string.gmatch(data, '[^%|]+') do
        datas[#datas+1] = _data
    end
	if tonumber(file) == 5 then -- RANKING
		local rankData = datas[1]
		room.globalRanking = {}

        if rankData then
            for name, level, experience, commu, id in string.gmatch(rankData, '([%w_+]+#%d+),(%d+),(%d+),(%w+),(%d+)') do
                room.globalRanking[#room.globalRanking+1] = {name = name, level = level, experience = experience, commu = commu, id = id}
            end
        end
		saveRanking()
		player_removeImages(room.rankingImages)
		loadRanking()

	elseif tonumber(file) == 1 then
		local bannedPlayers = datas[1] or table.concat(room.bannedPlayers, ';')
		local unrankedPlayers = datas[2] or table.concat(room.unranked, ';')

		room.bannedPlayers = {}
		for player in string.gmatch(bannedPlayers, '([%w_+]+#%d+),(%w+)') do
			room.bannedPlayers[#room.bannedPlayers+1] = player
			if players[player] then
				TFM.killPlayer(player)
			end
		end

		room.unranked = {}
		for player in string.gmatch(unrankedPlayers, '([%w_+]+#%d+),(%w+)') do
			room.unranked[#room.unranked+1] = player
		end
	end
end)

--[[ events/Keyboard.lua ]]--
onEvent("Keyboard", function(player, key, down, x, y)
	if room.isInLobby then return end
	local playerInfo = players[player]
	if not playerInfo then return end
	if down then
		if playerInfo.canDrive then
			if key == 2 or key == 0 then
				removeCarImages(player)
				playerInfo.driving = true
				playerInfo.currentCar.direction = key == 2 and 1 or 2
				playerInfo.carImages[#playerInfo.carImages+1] = addImage(mainAssets.__cars[playerInfo.selectedCar].image[playerInfo.currentCar.direction], "$"..player, mainAssets.__cars[playerInfo.selectedCar].x, mainAssets.__cars[playerInfo.selectedCar].y)
			elseif key == 3 then
				playerInfo.currentCar.direction = 0
			else
				if playerInfo.driving and key == 1 and mainAssets.__cars[playerInfo.selectedCar].type ~= 'boat' then
					if mainAssets.__cars[playerInfo.selectedCar].type ~= 'helicopter' then
						removeCarImages(player)
						playerInfo.selectedCar = false
						playerInfo.driving = false
						playerInfo.canDrive = false
						playerInfo.currentCar.direction = nil
						freezePlayer(player, false)
						loadMap(player)
						showOptions(player)
					else
						playerInfo.driving = true
						playerInfo.currentCar.direction = 3
					end
				end
			end
		end
		if key == 32 then
			if playerInfo.job == 'fisher' and not playerInfo.fishing[1] then
				if not playerInfo.selectedCar or mainAssets.__cars[playerInfo.selectedCar].type ~= 'car' then
					local biome = false
					for place, settings in next, room.fishing.biomes do 
						if math.range(settings.location, {x = x, y = y}) then 
							biome = place
							break
						end
					end
					if biome then
						playerFishing(player, x, y, biome)
					else
						TFM.chatMessage('<r>'..translate('fishWarning', player), player)
					end
				end
			elseif playerInfo.job == 'police' then
				if playerInfo.time > os.time() then return TFM.chatMessage('<r>'..translate('copError', player), player) end
				for i, v in next, ROOM.playerList do
					if math.hypo(x, y, v.x, v.y) <= 60 and i ~= player and not ROOM.playerList[player].isDead and not v.isDead then
						if players[i].job == 'thief' and players[i].robbery.robbing or players[i].robbery.escaped then
							if playerInfo.place == players[i].place and not players[i].robbery.usingShield then
								arrestPlayer(i, player)
								break
							end
						end
					end
				end
				if playerInfo.questLocalData.other.arrestRobber then
					if math.hypo(x, y, 1930, 8530) <= 60 then
						arrestPlayer('Robber', player)
						quest_updateStep(player)
					end
				end
			elseif playerInfo.job == 'thief' then
				if not playerInfo.robbery.robbing then
					for i, v in next, gameNpcs.robbing do
						if gameNpcs.characters[i].visible then
							if math.hypo(v.x, v.y, x, y) <= 60 then
								startRobbery(player, i)
								break
							end
						end
					end
				end
			end
		elseif key <= 3 then
			if playerInfo.fishing[1] then
				stopFishing(player)
			end
		elseif key == 70 or key == 71 then 
			local vehicleType = key-69
			local car = playerInfo.favoriteCars[vehicleType]
			drive(player, car)
		end
	end
end)

--[[ events/Loop.lua ]]--
onEvent("Loop", function()
	timersLoop()
	if room.started then
		room.currentGameHour = room.currentGameHour + 1
		checkWorkingTimer()
		for name, data in next, ROOM.playerList do
			player = players[name]
			if not player then break end
			if player.holdingItem and not mainAssets.__furnitures[player.holdingItem] then
				local image, x, y
				if data.isFacingRight then
					if player.holdingDirection ~= "right" then
						image = bagItems[player.holdingItem].holdingImages[2]
						x = bagItems[player.holdingItem].holdingAlign[2][1]
						y = bagItems[player.holdingItem].holdingAlign[2][2]

						player.holdingDirection = "right"
					end
				else
					if player.holdingDirection ~= "left" then
						image = bagItems[player.holdingItem].holdingImages[1]
						x = bagItems[player.holdingItem].holdingAlign[1][1]
						y = bagItems[player.holdingItem].holdingAlign[1][2]

						player.holdingDirection = "left"
					end
				end
				if image then
					if player.holdingImage then
						removeImage(player.holdingImage)
					end
					player.holdingImage = addImage(image, "$" .. name, x, y)
				end
			end
			if not player.hospital.hospitalized or not player.robbery.arrested then
				moveTo(name)
			end
			if player.driving then
				if player.currentCar.direction == 1 then
					local vel = mainAssets.__cars[player.selectedCar].maxVel
					TFM.movePlayer(name, 0, 0, true, vel, 0, false)
				elseif player.currentCar.direction == 2 then
					local vel = mainAssets.__cars[player.selectedCar].maxVel
					TFM.movePlayer(name, 0, 0, true, -(vel), 0, false)
				elseif player.currentCar.direction == 3 then
					local vel = mainAssets.__cars[player.selectedCar].maxVel
					TFM.movePlayer(name, 0, 0, true, 0, -(vel/2), false)
				end
				if mainAssets.__cars[player.selectedCar].effects then
					mainAssets.__cars[player.selectedCar].effects(name)
				end
			end
		end
		if room.currentGameHour%15 == 0 then
			updateHour()
		elseif room.currentGameHour == 1440 then
			room.currentGameHour = 0
		end

		gardening()
	end
	if ROOM.uniquePlayers >= room.requiredPlayers then
		if room.isInLobby then	
			genMap()
			ui.removeTextArea(0, nil)
			ui.removeTextArea(1, nil)
		end
	else
		if not room.isInLobby then
			genLobby()
			ui.removeTextArea(0, nil)
			ui.removeTextArea(1, nil)
		end
	end
end)

--[[ events/Mouse.lua ]]--
onEvent("Mouse", function(player, x, y)
	TFM.movePlayer(player, x, y, false)
end)

--[[ events/PlayerDataLoaded.lua ]]--
onEvent("PlayerDataLoaded", function(name, data)
	if name == 'Sharpiebot#0000' then 
		return syncGameData(data, name)
	end
	if table.contains(room.bannedPlayers, name) then
		return TFM.chatMessage('You can not play #mycity anymore.', name)
	end
	if #data > 1500 then return TFM.chatMessage('You have reached your data limit. Please contact Fofinhoppp#0000 for more info.', name) end
    playerData:newPlayer(name, data)
	------- setting data values to players[name]
	local playerSettings = playerData:get(name, 'playerLog')
	players[name].settings.mirroredMode = playerSettings[2][1] or 0
	players[name].lang = langIDS[playerSettings[2][2]] or 'en'
	players[name].seasonStats[1][2] = playerSettings[1][2] or 0

	players[name].coins = playerData:get(name, 'coins')
	if players[name].coins < 0 then players[name].coins = 0 end
	players[name].bagLimit = playerData:get(name, 'bagStorage')
	players[name].spentCoins = playerData:get(name, 'spentCoins')
	players[name].lifeStats = playerData:get(name, 'lifeStats')
	players[name].receivedCodes = playerData:get(name, 'codes')
	local houses = playerData:get(name, 'houses')
	for i, v in next, houses do
		players[name].casas[i] = v
	end
	local counter = 0
	local vehicles = playerData:get(name, 'cars')
	for i, v in next, vehicles do
		if mainAssets.__cars[v] and not table.contains(players[name].cars, v) then 
			players[name].cars[#players[name].cars+1] = v
		end 
	end 
	players[name].questStep = playerData:get(name, 'quests')
	local item = playerData:get(name, 'bagItem')
	local quanty = playerData:get(name, 'bagQuant')

	players[name].bag = {}
	players[name].totalOfStoredItems.bag = 0
	players[name].houseData.chests.storage = {{}, {}}
	players[name].totalOfStoredItems.chest[1] = 0
	players[name].totalOfStoredItems.chest[2] = 0

	for i, v in next, item do
		if quanty[i] > 0 then
			addItem(bagIds[v].n, quanty[i], name, 0)
		end
	end

	players[name].houseTerrain = playerData:get(name, 'housesTerrains')
	players[name].houseTerrainAdd = playerData:get(name, 'housesTerrainsAdd')
	players[name].houseTerrainPlants = playerData:get(name, 'housesTerrainsPlants')

	----------------------------- FURNITURES -----------------------------
	players[name].houseData.furnitures.placed = {}
	players[name].houseData.furnitures.stored = {}
	local furnitures, storedFurnitures = playerData:get(name, 'houseObjects'), playerData:get(name, 'storedFurnitures')
	do
		local function storeFurniture(v)
			if not players[name].houseData.furnitures.stored[v] then 
				players[name].houseData.furnitures.stored[v] = {quanty = 1, type = v}
			else
				players[name].houseData.furnitures.stored[v].quanty = players[name].houseData.furnitures.stored[v].quanty + 1
			end
		end

		for i, v in next, furnitures do
			if v[2] >= 0 and v[2] <= 1500 then
				players[name].houseData.furnitures.placed[i] = {type = v[1], x = v[2], y = v[3]}
			else
				TFM.chatMessage('<g>Due to an invalid position, a furniture has been moved to your furniture depot.', name)
				storeFurniture(i)
			end
		end
		for i, v in next, storedFurnitures do
			storeFurniture(v)
		end
	end
	----------------------------------------------------------------------

	players[name].sideQuests = playerData:get(name, 'sideQuests')
	players[name].level = playerData:get(name, 'level')
	local jobStats = playerData:get(name, 'jobStats')
	for i, v in next, jobStats do 
		players[name].jobs[i] = v
	end
	players[name].badges = playerData:get(name, 'badges')

	local luckiness = playerData:get(name, 'luckiness')
	local fishingLuckiness = luckiness[1]
	players[name].lucky = {{normal = fishingLuckiness[1], rare = fishingLuckiness[2], mythical = fishingLuckiness[3], legendary = fishingLuckiness[4]}}

	local playerLogs = playerData:get(name, 'playerLog')
	players[name].favoriteCars = playerLogs[4] or players[name].favoriteCars
	players[name].dataLoaded = true

	syncVersion(name, playerLogs[3])
	if players[name].questStep[1] <= questsAvailable then
		_QuestControlCenter[players[name].questStep[1]].active(name, players[name].questStep[2])
	end

	loadMap(name)
	showOptions(name)
	showCarShop(name)
	sideQuest_update(name, 0)
	HouseSystem.new(name):loadTerrains()
	players[name].blockScreen = false
	for i = 1, 2 do
		showLifeStats(name, i)
	end

	for i, v in next, ROOM.playerList do
		if players[i].roomLog then
			TFM.chatMessage('<g>[•][roomLog] '..name..' joined the room.', i)
		end
		local level = players[i].level[1]
		generateLevelImage(i, level, name)
		generateLevelImage(name, players[name].level[1], i)
	end
	job_updatePlayerStats(name, 1, 0)
	if ROOM.playerList['Fofinhoppp#0000'] then
		giveBadge(name, 1)
	end
	addImage("170fa1a5400.png", ":1", 348, 355, name)
end)

--[[ events/PlayerDied.lua ]]--
onEvent("PlayerDied", function(player)
	if room.isInLobby or not players[player] or players[player].editingHouse or checkLocation_isInHouse(player) then return end
	if table.contains(room.bannedPlayers, player) then return end
	if players[player].driving then
    	players[player].driving = false
	end
    TFM.respawnPlayer(player)
	if players[player].place == 'island' then
		TFM.movePlayer(player, 9230, 1944+room.y, false)
	else
		players[player].place = 'town'
	end
	showOptions(player)
end)

--[[ events/PlayerLeft.lua ]]--
onEvent("PlayerLeft", function(player)
	if room.isInLobby then return end
	local playerData = players[player]

	HouseSystem.new(player):removeHouse()
	if playerData.robbery.robbing then
		removeTimer(playerData.timer)
		arrestPlayer(player, 'AUTO')
		giveCoin(-300, player)
	end
	if playerData.job then
		job_fire(player)
	end
	if playerData.fishing[1] then
		stopFishing(player)
	end
	if playerData.dataLoaded then
		savedata(player)
	end
	setPlayerData(player)
end)

--[[ events/PlayerRespawn.lua ]]--
onEvent("PlayerRespawn", function(player)
	if room.isInLobby then return end
	local level = players[player].level[1]
	for i, v in next, ROOM.playerList do
		generateLevelImage(player, level, i)
	end
end)

--[[ events/TextAreaCallback.lua ]]--
onEvent("TextAreaCallback", function(id, player, callback, serverRequest)
	if room.isInLobby then return end
	local playerData = players[player]
	if not playerData then return end
	if not serverRequest then 
		if players[player].lastCallback.when > os.time()-1000 then
			if players[player].lastCallback.when > os.time()-100 then
				players[player].lastCallback.when = os.time()
			end
			return 
		end
	end
	players[player].lastCallback.when = os.time()

	local args = {}
    for i in callback:gmatch('[^_]+') do
        args[#args+1] = i
    end
	-------------- REWRITTEN PART
	local event = table.remove(args, 1)
	if event == 'changePage' then 
		local menu = args[1]
		local button = args[2]
		local totalPages = tonumber(args[3])
		local callbackPage = players[player]
		if button == 'next' then
			if callbackPage.callbackPages[menu] > totalPages then return end
			players[player].callbackPages[menu] = callbackPage.callbackPages[menu] + 1
		else
			if callbackPage.callbackPages[menu] > 1 then
				players[player].callbackPages[menu] = callbackPage.callbackPages[menu] - 1
			end
		end

		eventTextAreaCallback(0, player, menu, true)
	elseif event == 'modernUI' then
		if args[1] == 'ButtonAction' then
			local action = playerData._modernUIHistory[tonumber(args[2])][tonumber(args[3])]
			action.toggleEvent(player, action.args)
			if action.warningUI then return end
		elseif args[1] == 'CallbackEvent' then 
			return playerData._modernUIOtherCallbacks[tonumber(args[2])].event(player, playerData._modernUIOtherCallbacks[tonumber(args[2])].callbacks)
		end

		local ui_ID = tonumber(args[2])
		for i = 876, 995 do
			ui.removeTextArea(ui_ID..i, player)
		end
		player_removeImages(playerData._modernUIImages[ui_ID])
		if args[3] ~= 'errorUI' then
			for i = 1, #playerData._modernUISelectedItemImages do
				player_removeImages(playerData._modernUISelectedItemImages[i])
			end
			if args[3] == 'configMenu' then
				loadMap(player)
				HouseSystem.new(player):loadTerrains()
				savedata(player)
			end
		end
	elseif event == 'npcDialog' then
		if args[1] == 'nextPage' then
			local npc = args[2]
			local npcID = tonumber(args[3])
			local isQuest = args[4]
			local currentPage = tonumber(args[5])
			local dialog = false
			local lang = playerData.lang
			if isQuest ~= 'not' then 
				dialog = npcDialogs
					.quests
					  [lang]
					    [playerData.questStep[1]]
					     [playerData.questStep[2]]
					      [currentPage]
			else 
				dialog = dialogs[player].text[currentPage]
			end
			if dialog then 
				dialogs[player].running = true
			else 
				for i = -88002, -88000 do 
					ui.removeTextArea(i, player)
				end
				for i = 1, #players[player]._npcDialogImages do 
					removeImage(players[player]._npcDialogImages[i])
				end 
				players[player]._npcDialogImages = {}
				if playerData._npcsCallbacks.ending[npcID] then 
					playerData._npcsCallbacks.ending[npcID].callback(player)
				end
				if isQuest ~= 'not' then 
					quest_updateStep(player)
				end
			end
		elseif args[1] == 'skipAnimation' then 
			dialogs[player].length = 1000
		elseif args[1] == 'talkWith' then
			local npcID = tonumber(args[2])
			local location = ROOM.playerList[player]
			local npcRange = playerData._npcsCallbacks.clickArea[npcID]
			if math.hypo(npcRange[1], npcRange[2], location.x, location.y) <= 60 then
				local npcName = npcRange[3]
				local order = gameNpcs.orders.orderList[npcName]
				if order and order.fulfilled[player] then 
					if not order.fulfilled[player].completed then 
						if checkItemQuanty(order.order, 1, player) then 
							removeBagItem(order.order, 1, player)
							job_updatePlayerStats(player, 9)
							order.fulfilled[player].completed = true
							for i = 1, #order.fulfilled[player].icons do 
								removeImage(order.fulfilled[player].icons[i])
							end 
							local sidequest = sideQuests[players[player].sideQuests[1]].type
							if string.find(sidequest, 'type:deliver') then
								sideQuest_update(player, 1)
							end
							giveExperiencePoints(player, 200)
							giveCoin(bagItems[order.order].orderValue, player, true)
							TFM.chatMessage('<j>'..translate('orderCompleted', player):format('<CE>'..npcName..'</CE>', '<vp>$'..bagItems[order.order].orderValue..'</vp>', player), player)
							return
						end
					end
				end
				if playerData._npcsCallbacks.starting[npcID] then 
					playerData._npcsCallbacks.starting[npcID].callback(player)
				else
					local npc = args[3]
					local png = args[4]
					local questDialog = args[5]
					gameNpcs.talk({name = npc, image = png, npcID = npcID, questDialog = questDialog}, player)
				end
			end
		end
	elseif event == 'collectDroppedItem' then 
		item_collect(tonumber(args[1]), player)
	elseif event == 'updateBlock' then
		local blockID = tonumber(args[1])
		local blockData = Mine.blocks[blockID]
		local x = tfm.get.room.playerList[player].x
		local y = tfm.get.room.playerList[player].y
		local hit = 1
		if math.hypo(x, y, blockData.x, blockData.y) <= Mine.blockLength+Mine.blockLength/2 and not blockData.removed then 
			blockData.life[1] = blockData.life[1] + hit
			mine_updateBlockLife(blockID)
			if blockData.life[1] >= blockData.life[2] then 
				player_removeImages(blockData.images)
				if blockData.ore then 
					player_removeImages(blockData.oreImages)
					for i = 1, 4 do
						item_drop('crystal_'..blockData.ore, {x = blockData.x - 50 + (i-1)*20, y = blockData.y + 3})
					end
				end
				Mine.blocks[blockID].removed = true
				Mine.availableRocks[blockID] = false
				for i = 0, 10 do 
					ui.removeTextArea(blockID..(40028922+i))
				end

				local xx = Mine.blocks[blockID].column
				local yy = Mine.blocks[blockID].line
				for i = 1, #groundIDS do 
					removeGround(groundIDS[i])
				end 
				groundIDS = {}
				grid_height = mine_removeBlock(grid, grid_width, grid_height, xx, yy)
				mine_drawGrid(mine_optimizeGrid(grid, grid_width, grid_height), 60, Mine.position[1], Mine.position[2])
				mine_generateBlockAssets(blockID)
			end
		end
	elseif event == 'buyhouse' then
		local terrain = tonumber(args[1])
		modernUI.new(player, 520, 300, translate('houses', player))
			:build()
			:showHouses(terrain)
	elseif event == 'joinHouse' then
		if playerData.robbery.robbing then return end
		local id = tonumber(args[1])
		local terrainData = room.terrains[id]
		if not terrainData.owner then return end
		if not terrainData.settings.permissions[player] then terrainData.settings.permissions[player] = 0 end
		if terrainData.settings.permissions[player] == -1 then return alert_Error(player, 'error', 'error_blockedFromHouse', terrainData.owner) end
		if players[terrainData.owner].editingHouse then return alert_Error(player, 'error', 'error_houseUnderEdit', terrainData.owner) end
		if terrainData.settings.isClosed and terrainData.settings.permissions[player] == 0 then
			return alert_Error(player, 'error', 'error_houseClosed', terrainData.owner)
		end
		goToHouse(player, id)
	end
	if playerData.editingHouse then return end
	---------- TO REWRITE 
	if callback:sub(1,4) == 'BUY_' then
		local item = callback:sub(5)
		local complement = tonumber(item) and '' or '-'
		local y = complement == '-' and 110 or 250
		showPopup(5, player, nil, '', 400 - 250 *0.5, 200 - y * 0.5, 250, y, false, '9_'..complement ..item)
	---------- ENTRAR NOS LOCAIS ---------
	elseif callback:sub(1,6) == 'enter_' then
		local place = callback:sub(7)
		eventTextAreaCallback(102, player, 'close3_1', true)
		if checkGameHour(places[place].opened) or places[place].opened == '-' then
			TFM.movePlayer(player, places[place].tp[1], places[place].tp[2], false)
			players[player].place = place
			if place == "dealership" then
				showCarShop(player)
			elseif place == 'police' then
				if players[player].questLocalData.other.goToPolice then
					quest_updateStep(player)
				end
			elseif place == 'bank' then
				if players[player].questLocalData.other.goToBank then
					quest_updateStep(player)
				end
			elseif place == 'hospital' then
				if players[player].robbery.robbing then return end

				loadHospital(player, false)
				if players[player].questLocalData.other.goToHospital then
					quest_updateStep(player)
				end
			elseif place == 'seedStore' then
				if players[player].questLocalData.other.goToSeedStore then
					quest_updateStep(player)
				end
			elseif place == 'market' then
				if players[player].questLocalData.other.goToMarket then
					quest_updateStep(player)
				end
			end
			showOptions(player)
			checkIfPlayerIsDriving(player)
		else
			alert_Error(player, 'timeOut', 'closed_'..place)
		end
	elseif callback == 'elevator' then 
		if players[player].hospital.hospitalized then return end
		local andar = players[player].hospital.currentFloor
		local calc = ((andar-1)%andar)*900+4388
		local x = ROOM.playerList[player].x
		local y = ROOM.playerList[player].y
		if math.hypo(x, y, calc, 188 + (andar > 0 and 3000 or 3400)) <= 150 then
			sendMenu(33, player, '<font size="15"><p align="center"><j>'..translate('elevator', player)..'</j></p><br><p align="center"><textformat leading="4"><b><rose><a href="event:andar4">4<br><a href="event:andar3">3<br><a href="event:andar2">2<br><a href="event:andar1">1<br><a href="event:andar0">P<br>', 390 - 200 *0.5, 160, 200, 170, 1, false, '', false, false, false, 11)
		end
	-----------SAIR DOS LOCAIS--------------
	elseif callback:sub(1, 7) == 'getOut_' then
		local place = callback:sub(8)
		if ROOM.playerList[player].x > places[place].clickDistance[1][1] and ROOM.playerList[player].x < places[place].clickDistance[1][2] and ROOM.playerList[player].y > places[place].clickDistance[2][1] and ROOM.playerList[player].y < places[place].clickDistance[2][2] then
			players[player].place = 'town'
			TFM.movePlayer(player, places[place].town_tp[1], places[place].town_tp[2], false)
		end
		eventTextAreaCallback(0, player, 'close3_5', true)
		showOptions(player)
		checkIfPlayerIsDriving(player)
		if place == 'bank' then 
			if room.bankBeingRobbed then
				local shield = addImage('1566af4f852.png', '$'..player, -45, -45)
				players[player].robbery.usingShield = true
				addTimer(function()
					removeImage(shield)
					players[player].robbery.usingShield = false
				end, 7000, 1)
			end
		end
	-----------RESGATAR CODIGOS--------------
	elseif callback == 'enterCode' then
		players[player].codigo = {}
		showPopup(1, player, nil, '\n\n'..translate('codeInfo', player), 400 - 300 *0.5, 95, 300, 215, true, 10, '', true)
		ui.addTextArea(1897, '<V><p align="center"><font size="13">'..translate('code', player), player, 400 - 300 *0.5, 120, 300, 20, 0x314e57, 0x314e57, 0.8, true)
	elseif callback == 'getCode' then
		local code = table.concat(players[player].codigo, '')
		players[player].codigo = {}
		if codes[code] then
			for i, v in next, players[player].receivedCodes do
				if v == codes[code].id then
					ui.addTextArea(1897, '<R><p align="center"><font size="13">'..translate('codeAlreadyReceived', player), player, 400 - 300 *0.5, 120, 300, 20, 0x314e57, 0x314e57, 0.8, true)
					return
				end
			end
			if codes[code].available then
				if codes[code].level then 
					if codes[code].level > players[player].level[1] then
						return alert_Error(player, 'error', 'codeLevelError', codes[code].level)
					end
				end
				eventTextAreaCallback(102, player, 'close3_1', true)
				players[player].receivedCodes[#players[player].receivedCodes+1] = codes[code].id
				codes[code].reward(player)
				return
			else
				ui.addTextArea(1897, '<R><p align="center"><font size="13">'..translate('codeNotAvailable', player), player, 400 - 300 *0.5, 120, 300, 20, 0x314e57, 0x314e57, 0.8, true)
				return
			end
		else
			ui.addTextArea(1897, '<R><p align="center"><font size="13">'..translate('incorrect', player), player, 400 - 300 *0.5, 120, 300, 20, 0x314e57, 0x314e57, 0.8, true)
		end
	elseif callback == 'getDiscordLink' then
		TFM.chatMessage('<rose>'..room.discordServerUrl, player)
	elseif callback:sub(1, 9) == 'keyboard_' then
		local key = callback:sub(10)
		if #players[player].codigo <= 14 then
			players[player].codigo[#players[player].codigo+1] = key
		end
		ui.addTextArea(1897, '<V><p align="center"><font size="13">'..table.concat(players[player].codigo, ''), player, 400 - 300 *0.5, 120, 300, 20, 0x314e57, 0x314e57, 0.8, true)
	-----------BANK-------------
	elseif callback:sub(1,20) == 'insertVaultPassword_' then
		local digit = callback:sub(21)
		if digit then
			if digit == '*' then
				players[player].bankPassword = nil
			elseif digit == '#' then
				if players[player].bankPassword then
					if #players[player].bankPassword < 1 then return end
					players[player].bankPassword = players[player].bankPassword:sub(1, #players[player].bankPassword-1)
				end
			else
				if players[player].bankPassword then
					players[player].bankPassword = players[player].bankPassword .. digit
				else
					players[player].bankPassword = digit
				end
			end
		end
		showPopup(1, player, '', '', 400 - 100 *0.5, 200 - 150*0.5, 100, 180, false, 18, '', true)
	elseif callback == 'closeVaultPassword' then
		local id = 1
		for i = 869, 940 do
			ui.removeTextArea(id..i, player)
		end
		for i = 1, 13 do
			ui.removeTextArea(id..(889+(i-1)*14), player)
			ui.removeTextArea(id..(890+(i-1)*14), player)
		end
		player_removeImages(players[player].callbackImages)
	elseif callback == 'getVaultPassword' then
		if math.hypo(ROOM.playerList[player].x, ROOM.playerList[player].y, room.bank.paperPlaces[room.bank.paperCurrentPlace].x, room.bank.paperPlaces[room.bank.paperCurrentPlace].y) <= 80 then
			alert_Error(player, 'password', '<p align="center">'..room.bankVaultPassword:sub(1, 3)..'_')
		end
	elseif callback == 'lever' then
		if room.bankBeingRobbed then
			if room.bankRobStep == 'lazers' then
				if math.hypo(5988, 4940, ROOM.playerList[player].x, ROOM.playerList[player].y) <= 100 then
					if players[player].mouseSize >= 1 then
						room.bankRobStep = 'puzzle1'
						removeImage(room.bankDoors[4])
						removeImage(room.bankDoors[3])
						removeImage(room.bankDoors[5])
						room.bankDoors[4] = addImage("16bb98ddd7d.png", "!38", 5988, 4930) -- lever
						addGround(9994, 809+5000, 320+4555, {type = 14, width = 25, height = 130})
						removeGround(9996) -- lazer
						removeGround(9995) -- lazer
						addGround(9997, 260+5000, 105+4555, {type = 14, width = 25, height = 130})
						removeImage(room.bankDoors[2])
						ui.addTextArea(-510, '<a href="event:insertVaultPassword_">'..string.rep('\n', 10), nil, 5785, 4715, 30, 70, 1, 1, 0)
					else
						alert_Error(player, 'error', 'mouseSizeError')
					end
				end
			end
		end
	--------- Bag -----------
	elseif callback:sub(1, 10) == 'buyBagItem' then
		local item = callback:sub(12)
		local checker = callback:sub(11, 11)
		if checker == '_' then
			if item == 'bag' then
				if players[player].bagLimit < 45 then
					players[player].bagLimit = players[player].bagLimit + 5
					giveCoin(-bagItems[item].price, player)
				end
			else
				addItem(item, 1, player, bagItems[item].price)
			end
			for id, properties in next, playerData.questLocalData.other do 
				if id:find('BUY_') then
					if id:lower():find(item:lower()) then 
						if type(properties) == 'boolean' then 
							quest_updateStep(player)
						else 
							playerData.questLocalData.other[id] = properties - 1
							if playerData.questLocalData.other[id] == 0 then 
								quest_updateStep(player)
							end
						end
						break
					end
				end
			end
			showPopup(5, player, nil, '', 400 - 250 *0.5, 200 - (players[player].shopMenuHeight * 0.5), 250, players[player].shopMenuHeight, false, '9_'..players[player].shopMenuType)
		else
			if bagItems[item].type2 and bagItems[item].type2:find('limited-') then
				if not checkItemQuanty(coins[bagItems[item].type2], 1, player) then return end
				if checkItemQuanty(coins[bagItems[item].type2], 1, player) < bagItems[item].qpPrice then return end
				removeBagItem(coins[bagItems[item].type2], bagItems[item].qpPrice, player)
				addItem(item, 1, player, 0)
				eventTextAreaCallback(0, player, 'closebag', true)
			else
				if players[player].sideQuests[4] < bagItems[item].qpPrice then return end
				players[player].sideQuests[4] = players[player].sideQuests[4] - bagItems[item].qpPrice
				addItem(item, 1, player, 0)
				eventTextAreaCallback(0, player, 'closebag', true)
			end
		end
		savedata(player)			
	elseif callback == 'closebag' then
		ui.removeTextArea(2040, player)
		eventTextAreaCallback(0, player, 'close2', true)
		for i = 0, 9 do
			closeMenu(99+i, player)
		end
	elseif callback == 'upgradeBag' then
		showPopup(5, player, nil, '', 400 - 250 *0.5, 200 - 110 * 0.5, 250, 110, false, '9_6')
	--------------- HOUSES ----------------------
	elseif callback:sub(1,8) == 'harvest_' then
		local id = tonumber(callback:sub(9))
		local owner = player
		if string.find(players[player].place, 'house_') then
			local house_ = tonumber(players[player].place:sub(7))
			if house_ == 11 then
				owner = 'Oliver'
			end
		end
		if players[owner].houseTerrainPlants[id] == 0 then return end
		local crop = houseTerrainsAdd.plants[players[owner].houseTerrainPlants[id]]

		for id, properties in next, players[player].questLocalData.other do 
			if id:lower():find(crop.name) then 
				quest_updateStep(player)
			end
		end
		if players[owner].houseTerrainAdd[id] == #crop.stages then
			addItem(crop.name..'Seed', crop.quantyOfSeeds, player)
			addItem(crop.name, crop.quantyOfSeeds, player)
			ui.removeTextArea('-730'..(id..tonumber(players[owner].houseData.houseid)*10), nil)
			players[owner].houseTerrainAdd[id] = 1
			players[owner].houseTerrainPlants[id] = 0
			HouseSystem.new(owner):genHouseGrounds()
			savedata(player)
			if players[player].job == 'farmer' then
				job_updatePlayerStats(player, 5)
				giveExperiencePoints(player, 250)
			end
		end
	elseif callback == 'recipes' then
		if players[player].selectedItem.image then
			removeImage(players[player].selectedItem.image)
			players[player].selectedItem.image = nil
		end
		sendMenu(99, player, '<p align="center"><font size="16">'.. translate('recipes', player), 400 - 465 *0.5, 10, 445, 300, 1, false, 1, false, false, false, 18)
		ui.addTextArea(2040, '<p align="center"><font size="15" color="#ff0000"><a href="event:closebag"><b>X', player, 590, 30, 60, 50, 0x122528, 0x122528, 0, true)
	elseif callback:sub(1, 11) == 'showRecipe_' then
		if players[player].selectedItem.images[1] then
			for i, v in next, players[player].selectedItem.images do
				removeImage(players[player].selectedItem.images[i])
			end
			players[player].selectedItem.images = {}
		end
		if players[player].selectedItem.image then
			removeImage(players[player].selectedItem.image)
			players[player].selectedItem.image = nil
		end
		local item = callback:sub(12)

		ui.addTextArea(99106, '<p align="center"><CE>'..translate('item_'..item, player), player, 500, 85, 110, 190, 0x24474D, 0x314e57, 1, true)
		local canCook = true
		local counter = 0
		for i, v in next, recipes[item].require do
			counter = counter + 1
			players[player].selectedItem.images[#players[player].selectedItem.images+1] = addImage(bagItems[i].png, "&70", ((counter-1)%2)*55+485, math.floor((counter-1)/2)*30+160, player)
			if checkItemQuanty(i, v, player) then
				ui.addTextArea(99106+counter, '<vp>'..v, player, ((counter-1)%2)*55+530, math.floor((counter-1)/2)*30+177, nil, nil, 0x24474D, 0xff0000, 0, true)
			else
				ui.addTextArea(99106+counter, '<r>'..v, player, ((counter-1)%2)*55+530, math.floor((counter-1)/2)*30+177, nil, nil, 0x24474D, 0xff0000, 0, true)
			end
		end
		for i, v in next, recipes[item].require do
			if not checkItemQuanty(i, v, player) then
				canCook = false
				break
			end
		end
		if canCook then
			addButton(99096, '<a href="event:cook_'..item..'">'..translate('cook', player), player, 500, 240+40, 110, 10)
		else
			addButton(99096, translate('cook', player), player, 500, 240+40, 110, 10, true)
		end
		players[player].selectedItem.images[#players[player].selectedItem.images+1] = addImage(bagItems[item].png and bagItems[item].png or '16bc368f352.png', "&70", 530, 120, player)
	elseif event == 'cook' then
		local item = args[1]
		for i, v in next, recipes[item].require do
			if not checkItemQuanty(i, v, player) then return end
			removeBagItem(i, v, player)
		end
		eventTextAreaCallback(0, player, 'closebag', true)
		sendMenu(99, player, '', 400 - 120 * 0.5, (300 * 0.5), 100, 100, 1, true)
		addItem(item, 1, player)
		players[player].images[#players[player].images+1] = addImage(bagItems[item].png and bagItems[item].png or '16bc368f352.png', "&70", 400 - 50 * 0.5, 180, player)

		if players[player].job == 'chef' then
			job_updatePlayerStats(player, 10)
		end

		local sidequest = sideQuests[players[player].sideQuests[1]].type
		if sidequest == 'type:cook' or string.find(sidequest, item) then
			sideQuest_update(player, 1)
		end

		for id, properties in next, playerData.questLocalData.other do 
			if id:find('cook') then
				if id:lower():find(item:lower()) then 
					if type(properties) == 'boolean' then 
						quest_updateStep(player)
					else 
						playerData.questLocalData.other[id] = properties - 1
						if playerData.questLocalData.other[id] == 0 then 
							quest_updateStep(player)
						end
					end
					break
				end
			end
		end
	elseif callback:sub(1, 15) == 'joiningMessage_' then
		local type = callback:sub(16)
		player_removeImages(players[player].joinMenuImages)
		local currentVersion = 'v'..table.concat(version, '.')
		players[player].joinMenuImages = {}
		if type == 'close' then
			ui.removeTextArea(20880, player)
			eventTextAreaCallback(0, player, 'close2', true)
			removeImage(players[player].bannerLogin)
			system.loadPlayerData(player)
			mine_drawGrid(mine_optimizeGrid(grid, grid_width, grid_height), 60, Mine.position[1], Mine.position[2])
			addImage("170fef3117d.png", ":1", 660, 365, player)
			ui.addTextArea(999997, "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', 4), player, 660, 365, 35, 35, 0x324650, 0x000000, 0, true, function(player) openProfile(player) end)

			addImage("170f8773bcb.png", ":2", 705, 365, player)
			ui.addTextArea(999998, "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', 4), player, 705, 365, 35, 35, 0x324650, 0x000000, 0, true, function(player) modernUI.new(player, 310, 280, translate('questsName', player)):build():questInterface() end)

			addImage("170f8ccde22.png", ":3", 750, 365, player)
			ui.addTextArea(999999, "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', 4), player, 750, 365, 35, 35, 0x324650, 0x000000, 0, true, function(player) modernUI.new(player, 520, 300, nil, nil, 'configMenu'):build():showSettingsMenu() end)

		elseif type == 'next' then
			if players[player].joinMenuPage < versionLogs[currentVersion].maxPages then
				players[player].joinMenuPage = players[player].joinMenuPage + 1
			end
			sendMenu(99, player, '<p align="center"><font size="16"><vp>'..currentVersion..'</vp> - '.. translate('$VersionName', player) ..'</font>', 400 - 620 *0.5, 200 - 320*0.5, 600, 300, 1, false, 1, false, false, false, 15)
		elseif type == 'back' then
			if players[player].joinMenuPage > 1 then
				players[player].joinMenuPage = players[player].joinMenuPage - 1
			end
			sendMenu(99, player, '<p align="center"><font size="16"><vp>'..currentVersion..'</vp> - '.. translate('$VersionName', player) ..'</font>', 400 - 620 *0.5, 200 - 320*0.5, 600, 300, 1, false, 1, false, false, false, 15)
		end			
	elseif callback:sub(1,5) == 'andar' then
		if players[player].place ~= 'hospital' then eventTextAreaCallback(0, player, 'closeInfo_33', true) return end
		local i = tonumber(callback:sub(6))
		if i ~= players[player].hospital.currentFloor then
			if i ~= 0 then
				players[player].hospital.currentFloor = i
				loadHospitalFloor(player)
			else
				players[player].hospital.currentFloor = -1
				loadHospital(player, true)
			end
			eventTextAreaCallback(0, player, 'closeInfo_33', true)
		end
	elseif callback:sub(1,10) == 'closeInfo_' then
		local v = callback:sub(11)
		closeMenu(v, player)
		ui.removeTextArea(1020, player)
		for i = v..'001', v..'012' do
			ui.removeTextArea(i, player)
		end
	------------------ NPCS ------------------
	elseif callback == 'NPC_coffeeShop' then
		showPopup(5, player, nil, '', 400 - 250 *0.5, 200 - 250 * 0.5, 250, 250, false, '9_5')
	----------------- QUESTS -----------------			
	elseif callback:sub(1,6) == 'Quest_' then
		if callback:sub(7, 8) == '02' then
			if callback:sub(10) == 'key' then
				if players[player].questStep[2] == 3 then
					if math.hypo(ROOM.playerList[player].x, ROOM.playerList[player].y, 1405, 8758) <= 50 then
						quest_updateStep(player)
					end
				elseif players[player].questStep[2] == 6 then
					if math.hypo(ROOM.playerList[player].x, ROOM.playerList[player].y, 1635, 8820) <= 50 then
						quest_updateStep(player)
					end
				end
			end
		elseif callback:sub(7, 8) == '03' then
			if callback:sub(10) == 'cloth' then
				if players[player].questStep[2] == 7 then
					if math.hypo(ROOM.playerList[player].x, ROOM.playerList[player].y, 5700, 4990) <= 50 then
						quest_updateStep(player)
					end
				end
			elseif callback:sub(10) == 'paper' then
				if players[player].questStep[2] == 12 then
					if math.hypo(ROOM.playerList[player].x, ROOM.playerList[player].y, 6250, 3250) <= 50 then
						quest_updateStep(player)
					end
				end
			end
		end
	----------------- CLOSE ------------------
	elseif callback == 'close2' then
		closeMenu(99, player)
		for i = 7850, 7900 do
			ui.removeTextArea(i, player)
		end
		for i = 99000, 99140 do
			ui.removeTextArea(i, player)
		end
		ui.removeTextArea(990000000000001, player)
		ui.removeTextArea(990000000000002, player)
		ui.removeTextArea(990000000000003, player)

		local _callbackImages = playerData.callbackImages
		local _selectedItemImage = playerData.selectedItem.image
		local _selectedItemImages = playerData.selectedItem.images
		if _callbackImages[1] then
			for i = 1, #_callbackImages do
				removeImage(_callbackImages[i])
			end
			players[player].callbackImages = {}
		end
		if _selectedItemImage then
			removeImage(_selectedItemImage)
			players[player].selectedItem.image = nil
		end
		if _selectedItemImages[1] then
			for i = 1, #_selectedItemImages do
				removeImage(_selectedItemImages[i])
			end
			players[player].selectedItem.images = {}
		end
	elseif callback:sub(0,6) == 'fechar' then
		id = callback:sub(8)
		closeMenu(id, player)
	elseif callback == 'close' then
		for i = 100, 120 do
			ui.removeTextArea(i, player)
		end
	elseif callback:sub(0,6) == 'Fechar' then
		id = callback:sub(8)
		closeMenu(id, player)
		ui.removeTextArea(1019, player)
		ui.removeTextArea(100, player)
		ui.removeTextArea(101, player)
		ui.removeTextArea(102, player)
	elseif callback:sub(0,7) == 'close3_' then
		for i = 879,940 do
			ui.removeTextArea(callback:sub(8)..i, player)
		end
		if players[player].callbackImages[1] then
			for i, v in next, players[player].callbackImages do
				removeImage(players[player].callbackImages[i])
			end
			players[player].callbackImages = {}
		end
		job_updatePlayerStats(player, 1, 0)
	--------------------------------------------
	elseif callback == 'confirmPosition' then
		if not players[player].holdingItem then return end
		local item = players[player].holdingItem
		local x = ROOM.playerList[player].x
		local y = ROOM.playerList[player].y
		local seed = nil
		local seedToDrop = item
		if string.find(item, 'Seed') then
			for i, v in next, houseTerrainsAdd.plants do
				if string.find(item, v.name) then
					seedToDrop = item
					item = 'seed'
					seed = i
				end
			end
		end
		if not bagItems[item].placementFunction(player, x, y, seed) then
			if not seedToDrop then return end
			addItem(seedToDrop, 1, player)
			eventTextAreaCallback(0, player, 'closebag', true)
		else 
			for id, properties in next, players[player].questLocalData.other do 
				if id:find('plant_') then 
					if id:lower():find(seedToDrop:lower()) then
						quest_updateStep(player)
					end
				end
			end
		end
		players[player].holdingDirection = nil
		removeImage(players[player].holdingImage)
		players[player].holdingImage = nil
		players[player].holdingItem = false
		ui.removeTextArea(9901327, player)
		ui.removeTextArea(98900000019, player)
		showOptions(player)
		savedata(player)		
	end
end)

--[[ places/mine/_perlin.lua ]]--
local perlin = {}
do
	--[[
	  Implemented as described here:
	  http://flafla2.github.io/2014/08/09/perlinnoise.html
	]]--
	perlin.p = {}

	-- Hash lookup table as defined by Ken Perlin
	-- This is a randomly arranged array of all numbers from 0-255 inclusive
	local permutation = {151,160,137,91,90,15,
	131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
	190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
	88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
	77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
	102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
	135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
	5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
	223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
	129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
	251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
	49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
	138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180
	}

	-- p is used to hash unit cube coordinates to [0, 255]
	for i=0,255 do
	  -- Convert to 0 based index table
	  perlin.p[i] = permutation[i+1]
	  -- Repeat the array to avoid buffer overflow in hash function
	  perlin.p[i+256] = permutation[i+1]
	end

	-- Return range: [-1, 1]
	function perlin:noise(x, y, z)
	  y = y or 0
	  z = z or 0

	  -- Calculate the "unit cube" that the point asked will be located in
	  local xi = bit32.band(math.floor(x),255)
	  local yi = bit32.band(math.floor(y),255)
	  local zi = bit32.band(math.floor(z),255)

	  -- Next we calculate the location (from 0 to 1) in that cube
	  x = x - math.floor(x)
	  y = y - math.floor(y)
	  z = z - math.floor(z)

	  -- We also fade the location to smooth the result
	  local u = self.fade(x)
	  local v = self.fade(y)
	  local w = self.fade(z)

	  -- Hash all 8 unit cube coordinates surrounding input coordinate
	  local p = self.p
	  local A, AA, AB, AAA, ABA, AAB, ABB, B, BA, BB, BAA, BBA, BAB, BBB
	  A   = p[xi  ] + yi
	  AA  = p[A   ] + zi
	  AB  = p[A+1 ] + zi
	  AAA = p[ AA ]
	  ABA = p[ AB ]
	  AAB = p[ AA+1 ]
	  ABB = p[ AB+1 ]

	  B   = p[xi+1] + yi
	  BA  = p[B   ] + zi
	  BB  = p[B+1 ] + zi
	  BAA = p[ BA ]
	  BBA = p[ BB ]
	  BAB = p[ BA+1 ]
	  BBB = p[ BB+1 ]

	  -- Take the weighted average between all 8 unit cube coordinates
	  return self.lerp(w,
	      self.lerp(v,
	          self.lerp(u,
	              self:grad(AAA,x,y,z),
	              self:grad(BAA,x-1,y,z)
	          ),
	          self.lerp(u,
	              self:grad(ABA,x,y-1,z),
	              self:grad(BBA,x-1,y-1,z)
	          )
	      ),
	      self.lerp(v,
	          self.lerp(u,
	              self:grad(AAB,x,y,z-1), self:grad(BAB,x-1,y,z-1)
	          ),
	          self.lerp(u,
	              self:grad(ABB,x,y-1,z-1), self:grad(BBB,x-1,y-1,z-1)
	          )
	      )
	  )
	end

	-- Gradient function finds dot product between pseudorandom gradient vector
	-- and the vector from input coordinate to a unit cube vertex
	perlin.dot_product = {
		[0x0]=function(x,y,z) return  x + y end,
		[0x1]=function(x,y,z) return -x + y end,
		[0x2]=function(x,y,z) return  x - y end,
		[0x3]=function(x,y,z) return -x - y end,
		[0x4]=function(x,y,z) return  x + z end,
		[0x5]=function(x,y,z) return -x + z end,
		[0x6]=function(x,y,z) return  x - z end,
		[0x7]=function(x,y,z) return -x - z end,
		[0x8]=function(x,y,z) return  y + z end,
		[0x9]=function(x,y,z) return -y + z end,
		[0xA]=function(x,y,z) return  y - z end,
		[0xB]=function(x,y,z) return -y - z end,
		[0xC]=function(x,y,z) return  y + x end,
		[0xD]=function(x,y,z) return -y + z end,
		[0xE]=function(x,y,z) return  y - x end,
		[0xF]=function(x,y,z) return -y - z end
	}
	function perlin:grad(hash, x, y, z)
		return self.dot_product[bit32.band(hash,0xF)](x,y,z)
	end

	-- Fade function is used to smooth final output
	function perlin.fade(t)
		return t * t * t * (t * (t * 6 - 15) + 10)
	end

	function perlin.lerp(t, a, b)
		return a + t * (b - a)
	end
end

--[[ places/mine/grid.lua ]]--
mine_setStoneType = function(depth, frequency)
	local ores = {}
	local y = depth
	for i, v in next, Mine.stones do
		local min = (i-1.87)* math.random(4, 6)
		local max = i * math.random(4, 6)
		if y >= min and y <= max then
			local rarity = (y / (max*2.5) * frequency)*math.random(0, 100)
			ores[i] = rarity
		end
	end
	local rarity = math.random(10)/perlin:noise(frequency)
	for i, v in next, ores do
		if v >= rarity then
			return i
		else 
			for other in next, ores do
				if other ~= i then 
					return other 
				end 
			end
		end
		return i
	end
	return #Mine.stones
end

mine_setOre = function(rockType)
	if Mine.stones[rockType].ores then 
		for i = #Mine.stones[rockType].ores, 1, -1 do
			local random = math.random(0, 100)
			local ore = Mine.stones[rockType].ores[i]
			if random <= Mine.ores[ore].rarity then 
				return ore
			end
		end
	end
	return nil
end

mine_generate = function(player)
	for i = 1, (Mine.area[1] * Mine.area[2]) do 
		local depth = math.floor((i-1)/Mine.area[1])
		local x = Mine.position[1] + Mine.blockLength/2 + ((i-1)%Mine.area[1]) * Mine.blockLength
		local y = Mine.position[2] + Mine.blockLength/2 + depth * Mine.blockLength
		local stone = mine_setStoneType(depth, perlin:noise(x/10.101, y/10.101, perlin:noise(i/10.101*math.random(0, 10))))
		local ore = mine_setOre(stone)
		Mine.blocks[i] = {type = stone, ore = ore, images = {}, oreImages = {}, size = 0, x = x, y = y, removed = false, life = {0, Mine.stones[stone].health, nil}, column = 1 + (i - 1)%Mine.area[1], line = 1 + math.floor((i - 1)/Mine.area[1])}
		if i <= 10 then 
			Mine.blocks[i].images[#Mine.blocks[i].images+1] = addImage(Mine.stones[stone].image, '_100'..i, x-Mine.blockLength/2, y-Mine.blockLength/2, player)
			mine_updateBlockLife(i, player)
			grid[i] = true
			Mine.availableRocks[i] = true
		end
	end
	mine_drawGrid(mine_optimizeGrid(grid, grid_width, grid_height), 60, Mine.position[1], Mine.position[2])
end

mine_updateBlockLife = function(groundID, player)
	local blockLength = Mine.blockLength
	local x = Mine.blocks[groundID].x - blockLength/2
	local y = Mine.blocks[groundID].y - blockLength/2
	local life = Mine.blocks[groundID].life[2]-Mine.blocks[groundID].life[1]
	ui.addTextArea(groundID..'40028923', '<p align="center"><font color="#000000" size="12"><b>'..life, player, x, y+20, blockLength, blockLength, 0x1, 0x1, 0)
	ui.addTextArea(groundID..'40028922', '<a href="event:updateBlock_'..groundID..'">'..string.rep('\n', 10), player, x, y, blockLength, blockLength, 0x1, 0x1, 0)
	Mine.blocks[groundID].life[3] = true
end

mine_generateBlockAssets = function(groundID)
	local blocksAround = {}
	local corner = {}
	for i = -1, 1 do 
		for j = -1, 1 do
			local id = groundID + j + Mine.area[1]*i
			if Mine.blocks[id] and id ~= groundID and not Mine.blocks[id].removed then
				if math.hypo(Mine.blocks[id].x, Mine.blocks[id].y, Mine.blocks[groundID].x, Mine.blocks[groundID].y) <= 100 then 
					blocksAround[#blocksAround+1] = id
					if i ~= 0 and j ~= 0 then 
						corner[id] = true
					end
				end
			end
		end
	end
	for i, v in next, blocksAround do
		Mine.availableRocks[v] = true
		if corner[v] then
			Mine.availableRocks[v] = 'corner'
		end
		mine_reloadBlock(v)
	end
end

mine_reloadBlock = function(block, player)
	local v = block
	local x = Mine.blocks[v].x
	local y = Mine.blocks[v].y
	Mine.blocks[v].images[#Mine.blocks[v].images+1] = addImage(Mine.stones[Mine.blocks[v].type].image, '_100'..v, x-Mine.blockLength/2, y-Mine.blockLength/2, player)
	if Mine.blocks[v].ore then 
		Mine.blocks[v].oreImages[#Mine.blocks[v].oreImages+1] = addImage(Mine.ores[Mine.blocks[v].ore].img, '_100'..v, x-Mine.blockLength/2, y-Mine.blockLength/2, player)
	end
	if Mine.availableRocks[v] ~= 'corner' then 
		mine_updateBlockLife(v, player)
	end
end

mine_removeBlock = function(blocks, width, height, x, y)
	local position = x + (y - 1) * width
	--print(position .. " " .. x .. " " .. y .. " " .. width .. " " .. height)
	if not blocks[position] then return height end -- the block is already removed

	blocks[position] = nil -- remove the block
	if x > 1 and blocks[position - 1] == false then
		-- if the removed block is not on the left edge,
		-- and the left block is there but not drawn yet
		blocks[position - 1] = true -- draw it
	end
	if x < width and blocks[position + 1] == false then -- same but with the other side
		blocks[position + 1] = true
	end
	for i, v in next, {(position - Mine.area[1]), (position - Mine.area[1]-1), (position - Mine.area[1]+1), (position + Mine.area[1]-1), (position + Mine.area[1]+1)} do
		if blocks[v] == false then 
			blocks[v] = true
		end
	end

	if y == height then -- if the block was on the last row
		local offset = height * width

		-- add a new row with false values EXCEPT for the one down this one
		for column = 1, width do
			blocks[column + offset] = column == x
		end

		-- and add 1 to the height!
		return height + 1
	elseif blocks[position + width] == false then
		blocks[position + width] = true
	end
	return height -- otherwise just return the same height
end

mine_optimizeGrid = function(grid, width, height)
	-- Optimize vertically
	local columns = {}
	local blocks, start, block -- allocate variables
	for column = 1, width do
		blocks, start = {}, nil -- initialize them

		for row = 0, height - 1 do
			block = grid[column + row * width] -- gets the block

			if not start then -- if we're not in a block batch yet
				if block then -- but there is a block
					start = row -- then this is the batch start
				end

			elseif not block then -- otherwise, if we're in a block batch but there is no block
				blocks[start] = row - 1 -- then the previous block is the batch end
				start = nil
			end
		end

		-- if we've finished iterating the rows
		if start then -- but there is a batch that has not ended
			blocks[start] = height - 1 -- then the batch end is the last block
		end

		columns[column] = blocks
	end

	-- Optimize horizontally
	local result, count = {}, 0 -- prepare result as we'll tell where to spawn blocks after optimizing horizontally
	local x_start, x_end
	for column = 1, width do
		for batch_start, batch_end in next, columns[column] do
			x_start, x_end = column, column -- horizontal batch start and end is at the same column
			for _column = column + 1, width do
				if columns[_column][batch_start] == batch_end then -- if the next column has the same vertical batch
					x_end = _column -- enlarge horizontal batch
					columns[_column][batch_start] = nil -- and delete that vertical batch from that column
														-- (so the vertical batch is not optimized twice)
					-- and check with the next column
				else -- if the next column doesn't have the same vertical batch
					break 
				end
			end

			count = count + 1 -- add a ground spawn instruction with the optimized batch to the result
			result[count] = {x_start, batch_start + 1, x_end, batch_end + 1}
		end
	end
	return result
end

mine_drawGrid = function(grid, size, x, y)
    local ground_data = { -- don't set width and height as it will be ignored!
        type 		= 14,
        friction 	= 20,
        restitution = .6,
    }

    local step, left, top, right, bottom
    for ground = 1, #grid do
        step = grid[ground]

        left = (step[1] - 1) * size
        top = (step[2] - 1) * size
        right = step[3] * size
        bottom = step[4] * size

        ground_data.width = right - left
        ground_data.height = bottom - top
        groundIDS[#groundIDS+1] = ground
        addGround(ground, x + (right + left) / 2, y + (bottom + top) / 2, ground_data)
    end
end

--[[ places/hospital/hospitalize.lua ]]--
hospitalize = function(player)
	giveCoin(-600 * #players[player].hospital.diseases, player)
	if players[player].hospital.hospitalized then return end
	for i = 1, 4 do
		for x = 1, 2 do
			if not room.hospital[i][x].name then
				local pos = {100, 700}
				room.hospital[i][x].name = player
				players[player].hospital.hospitalized = true
				players[player].hospital.currentFloor = i
				freezePlayer(player, true)
				TFM.movePlayer(player, ((i-1)%i)*900+4000+pos[x], 3200, false)
				closeInterface(player, nil, nil, nil, nil, nil, true)
				players[player].timer = addTimer(function(j) local time = 60 - j
					if time > 0 then
						ui.addTextArea(98900000000, "<b><font color='#371616'><p align='center'>"..translate('healing', player):format(time), player, 250, 368, 290, 20, 0x1, 0x1, 0, true)
					else
						for i, v in next, players[player].hospital.diseases do
							setLifeStat(player, v, 60)
						end
						players[player].hospital.diseases = {}
						players[player].hospital.hospitalized = false
						showOptions(player)
						freezePlayer(player, false)
						savedata(player)
						room.hospital[i][x].name = nil
						if x == 1 then
							ui.addTextArea(8888805, '', nil, ((i-1)%i)*900+3+4000, 4+3000, 287, 249, 0x1, 0x1, 0.5)
						else
							ui.addTextArea(8888806, '', nil, ((i-1)%i)*900+510+4000, 4+3000, 287, 249, 0x1, 0x1, 0.5)
						end
					end
				end, 1000, 60)
				ui.removeTextArea(8888804+x)
				return
			end
		end
	end
end

--[[ places/hospital/loadFloor.lua ]]--
loadHospitalFloor = function(player)
	local playerInfos = players[player]
	local andar =  playerInfos.hospital.currentFloor
	ui.addTextArea(8888800, '<font size="30" color="#FF8C00"><b><p align="center">'..andar, player, ((andar-1)%andar)*900+348+4000, 54+3000, 100, nil, 0x1, 0x1, 0)
	ui.addTextArea(8888801, '', player, ((andar-1)%andar)*900+804+4000, -300+3000, 1000, 1000, 0x1, 0x1, 1)
	ui.addTextArea(8888802, '', player, ((andar-1)%andar)*900-1004+4000, -300+3000, 1000, 1000, 0x1, 0x1, 1)

	ui.addTextArea(8888803, '<font color="#00FF00" size="15" face="Consolas"><b><p align="center">01', player, ((andar-1)%andar)*900+325+4000, 102+3000, 53, nil, 0x1, 0x1, 0)
	ui.addTextArea(8888804, '<font color="#00FF00" size="15" face="Consolas"><b><p align="center">01', player, ((andar-1)%andar)*900+415+4000, 102+3000, 53, nil, 0x1, 0x1, 0)
	ui.addTextArea(8888808, "<textformat leftmargin='1' rightmargin='1'><a href='event:elevator'>" .. string.rep('\n', 5), player, ((andar-1)%andar)*900+388+4000, 188+3000, 20, 30, 1, 1, 0)

	if not playerInfos.hospital.hospitalized then
		closeInterface(player, false, true)
		TFM.movePlayer(player, ((andar-1)%andar)*900+4400, 3240, false)
	end

	if not room.hospital[andar][1].name then
		ui.addTextArea(8888805, '', player, ((andar-1)%andar)*900+3+4000, 4+3000, 287, 249, 0x1, 0x1, 0.5)
	end
	if not room.hospital[andar][2].name then
		ui.addTextArea(8888806, '', player, ((andar-1)%andar)*900+510+4000, 4+3000, 287, 249, 0x1, 0x1, 0.5)
	end
end

loadHospital = function(player, elevador)
	players[player].place = 'hospital'

	local andar = 1
	ui.addTextArea(8888800, '<font size="30" color="#FF8C00"><b><p align="center">P', player, ((andar-1)%andar)*900+348+4000, 54+3400, 100, nil, 0x1, 0x1, 0)
	ui.addTextArea(8888801, '', player, ((andar-1)%andar)*900+804+4000, -300+3400, 1000, 1000, 0x1, 0x1, 1)
	ui.addTextArea(8888802, '', player, ((andar-1)%andar)*900-1004+4000, -300+3400, 1000, 1000, 0x1, 0x1, 1)

	ui.addTextArea(8888803, '<font color="#00FF00" size="15" face="Consolas"><b><p align="center">01', player, ((andar-1)%andar)*900+325+4000, 102+3400, 53, nil, 0x1, 0x1, 0)
	ui.addTextArea(8888804, '<font color="#00FF00" size="15" face="Consolas"><b><p align="center">01', player, ((andar-1)%andar)*900+415+4000, 102+3400, 53, nil, 0x1, 0x1, 0)
	ui.addTextArea(8888807, "<textformat leftmargin='1' rightmargin='1'><a href='event:elevator'>" .. string.rep('\n', 5), player, ((andar-1)%andar)*900+388+4000, 188+3400, 20, 30, 1, 1, 0)

	if not players[player].hospital.hospitalized and not elevador and not players[player].robbery.robbing then
		closeInterface(player, false, true)
		TFM.movePlayer(player, 4600, 3650, false)
	end
	if elevador then
		TFM.movePlayer(player, 4400, 3640, false)
	end
end

--[[ places/bank/robbingAssets.lua ]]--
reloadBankAssets = function()
	if not room.bankBeingRobbed then
		addGround(9998, 262+5000, 251+4955, {type = 12, color = 0xdad0b5, width = 24, height = 80})
	else
		removeGround(9998)
	end
end

addBankRobbingAssets = function()
	if room.bankBeingRobbed then return end
	room.bankBeingRobbed = true

	for name in next, ROOM.playerList do
		if not players[name].driving then
			ui.addTextArea(1029, '<font size="15" color="#FF0000"><p align="center">' .. translate('robberyInProgress', name) .. '</a>', name, 2670, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.3)
		end
		if players[name].place == 'bank' then
			if players[name].job ~= 'police' then
				job_hire('thief', name)
				TFM.chatMessage('<j>'..translate('copAlerted', name), name)
			end
		end
		if players[name].job == 'police' then
			TFM.chatMessage('<vp>'..translate('bankRobAlert', name)..'</vp>', name)
		end
		if players[name].questLocalData.other.goToBankRob then
			quest_updateStep(name)
		end
	end
	local lightImage = nil
	removeImage(room.bankDoors[1])
	removeImage(room.bankDoors[2])
	removeImage(room.bankDoors[3])
	removeImage(room.bankDoors[4])
	removeImage(room.bankDoors[5])
	room.bankDoors[1] = addImage("16baf05e96a.png", "!36", 5787, 4596)
	room.bankDoors[2] = addImage("16bb46e2a7c.png", "!36", 5243, 4718)
	room.bankDoors[3] = addImage("16bb46e2a7c.png", "!37", 5792, 4926)
	room.bankDoors[4] = addImage("16bb98e5d8f.png", "!38", 5988, 4930) -- lever
	room.bankDoors[5] = addImage("16bb493c28e.png", "!36", 5275, 4812) -- lazers


	addGround(9999, 7+5791, 66+30+4596, {type = 14, width = 12, height = 190}) -- porta do cofre
	addGround(9997, 260+5000, 135+4555, {type = 14, width = 25, height = 200}) -- porta 3o andar
	addGround(9996, 88+5275, 80+4812, {type = 14, width = 200, angle = 45, restitution = 999}) -- lazer
	addGround(9995, 232+5275, 80+4812, {type = 14, width = 200, angle = -45, restitution = 999}) -- lazer
	addGround(9994, 809+5000, 338+4555, {type = 14, width = 25, height = 200}) -- porta da sala do colt fechada

	ui.addTextArea(-5950, '<a href="event:lever">'..string.rep('\n', 5), nil, 5990, 4935, 25, 25, 0x324650, 0x0, 0)

	addTimer(function(time)
		for player, v in next, ROOM.playerList do
			if v.x > 5460 and v.x < 5615 and v.y > 5100 and v.y < 5250 then
				ui.addTextArea(-5551, "<font color='#FFFFFF' size='40'><a href='event:getOut_bank'>• •", player, 5508, 5150, nil, nil, 1, 1, 0, false)
			else
				ui.removeTextArea(-5551, player)
			end
		end
		if room.bankRobStep == 'vault' then
			for player, v in next, ROOM.playerList do
				if players[player].place == 'bank' then
					if not players[player].robbery.robbing then
						if v.x > 5791 and v.x < 6014 and v.y > 4596 and v.y < 4785 then
							if players[player].job == 'thief' then
								players[player].timer = addTimer(function(j)
									local time = room.robbing.bankRobbingTimer - j
									ui.addTextArea(98900000001, "<p align='center'>"..translate('runAway', player):format(time)..'\n<vp><font size="10">'..translate('runAwayCoinInfo', player):format('$'..jobs['thief'].bankRobCoins), player, 250, 370, 250, nil, 0x1, 0x1, 0, true)
									if j == room.robbing.bankRobbingTimer then
										players[player].robbery.robbing = false
										removeTimer(players[player].timer)
										players[player].timer = {}
										ui.removeTextArea(98900000001, player)
										showOptions(player)
										giveCoin(jobs['thief'].bankRobCoins, player, true)
										TFM.setNameColor(player, 0)
										job_updatePlayerStats(player, 2)
										local sidequest = sideQuests[players[player].sideQuests[1]].type
										if string.find(sidequest, 'type:bank') then
											sideQuest_update(player, 1)
										end
									end
								end, 1000, room.robbing.bankRobbingTimer)

								players[player].robbery.robbing = true
								closeInterface(player)
								TFM.setNameColor(player, 0xFF0000)
							end
						end
					end
				end
			end
		end
		if time%2 == 0 then
			if lightImage then
				removeImage(lightImage)
			end
		else
			lightImage = addImage('16b9521a7ac.png', '!999999', 5000+66, 4545)
		end
		if time == room.bankRobbingTime then
			room.bankBeingRobbed = false
			ui.removeTextArea(-510, nil)
			removeImage(room.bankDoors[1])
			for i = 1, #room.bankTrashImages do
				removeImage(room.bankTrashImages[i])
			end
			room.bankTrashImages = {}
			for i in next, ROOM.playerList do
				ui.addTextArea(1029, '<font size="15"><p align="center"><a href="event:enter_bank">' .. translate('goTo', i) .. '</a>', i, 2670, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.3)
				if players[i].place == 'bank' then
					if players[i].job == 'thief' then
						arrestPlayer(i, 'Colt')
					end
				end
				eventTextAreaCallback(1, i, 'closeVaultPassword', true)
			end
			reloadBankAssets()
		elseif time == room.bankRobbingTime - 5 then
			gameNpcs.reAddNPC('Colt')
		end
	end, 1000, room.bankRobbingTime)
end

--[[ places/_checkLocation/isInHouse.lua ]]--
checkLocation_isInHouse = function(player)
	if not players[player] then return false end
	local id = tonumber(players[player].houseData.houseid)
	local house = tonumber(players[player].place:sub(7))
	if id == house then 
		return true
	end
	return false
end

--[[ places/changePlace.lua ]]--
TFM.movePlayer = function(player, ...)
	if not players[player].driving then
		eventTextAreaCallback(1, player, 'Fechar@101', true)
	end
	if players[player].place ~= 'mine_labyrinth' and players[player].place ~= 'mine_sewer' and players[player].place ~= 'mine_escavation' then
		setNightMode(player, true)
	end
	move(player, ...)
end

moveTo = function(name)
	local playerData = players[name]
	local playerInfo = ROOM.playerList[name]
	if not playerData.dataLoaded then return end
	local v = places[playerData.place]
	if not v then return end
	if checkGameHour(v.opened) or v.opened == '-' then
		if playerInfo.x > v.saida[1][1] and playerInfo.x < v.saida[1][2] and playerInfo.y > v.saida[2][1] and playerInfo.y < v.saida[2][2] then
			if v.saidaF(name) then 
				if players[name].place ~= 'bank' then 
					checkIfPlayerIsDriving(name)
					eventTextAreaCallback(0, name, 'close3_5', true)
					showOptions(name)
				end
			end
			return
		end
	end
end

--[[ places/events.lua ]]--
closePlaces = function()
	for place, v in next, places do 
		if not checkGameHour(v.opened) and v.opened ~= '-' then
			kickPlayersFromPlace(place)
		end
	end
end

kickPlayersFromPlace = function(place)
	for name in next, ROOM.playerList do 
		local playerData = players[name]
		if playerData.place == place then
			if places[place].town_tp then
				TFM.movePlayer(name, places[place].town_tp[1], places[place].town_tp[2], false)
				playerData.place = 'town'
			else
				TFM.movePlayer(name, places[place].island_tp[1], places[place].island_tp[2], false)
				playerData.place = 'island'
			end
			alert_Error(name, 'timeOut', 'closed_'..place) 
			showOptions(name)
		end
	end
end

goToHouse = function(player, terrainID)
	players[player].place = 'house_'..terrainID
	loadFound(player, terrainID)
	TFM.movePlayer(player, ((terrainID-1)%terrainID)*1500+400, 1690, false)
	showOptions(player)
	checkIfPlayerIsDriving(player)
	ui.addTextArea(400, string.rep('\n', 3), player, ((terrainID-1)%terrainID)*1500 + 317, 1616 + 45, 25, 25, 0, 0, 0, false, 
		function()
			getOutHouse(player, terrainID)
		end)
	if room.terrains[terrainID].owner ~= player then 
		room.terrains[terrainID].guests[player] = true
	end
	if players[player].questLocalData.other.goToHouse or (terrainID == 11 and players[player].questLocalData.other.goToOliver) then
		quest_updateStep(player)
	end

	if not room.terrains[terrainID].groundsLoadedTo[player] then 
		HouseSystem.new(room.terrains[terrainID].owner):genHouseGrounds(player)
		room.terrains[terrainID].groundsLoadedTo[player] = true
	end
end

getOutHouse = function(player, terrainID)
	if not string.find(players[player].place, 'house_') or players[player].editingHouse then return end
	if terrainID == 11 then -- Oliver's Farm
		TFM.movePlayer(player, 11275, 7770, false)
	elseif terrainID == 10 then -- Remi's Restaurant
		TFM.movePlayer(player, 10200, 7770, false)
	else
		TFM.movePlayer(player, mainAssets.__terrainsPositions[terrainID][1], mainAssets.__terrainsPositions[terrainID][2]+184, false)
	end
	if terrainID >= 10 then
		players[player].place = 'island'
	else
		players[player].place = 'town'
	end
	room.terrains[terrainID].guests[player] = false
	showOptions(player)
end

equipHouse = function(player, houseType, terrainID)
	if room.terrains[terrainID].owner then return alert_Error(player, 'error', 'alreadyLand') end
	if players[player].houseData.houseid > 0 then
		HouseSystem.new(player):removeHouse()
	end
	ui.removeTextArea(24+terrainID)
	ui.removeTextArea(44+terrainID)
	ui.removeTextArea(terrainID)
	players[player].houseData.houseid = terrainID
	players[player].houseData.currentHouse = houseType
	room.terrains[terrainID].bought = true
	room.terrains[terrainID].owner = player
	room.terrains[terrainID].settings = {isClosed = false, permissions = {[player] = 4}}
	showOptions(player)

	HouseSystem.new(player):genHouseFace():genHouseGrounds()
end

--[[ social/freezePlayer.lua ]]--
freezePlayer = function(player, freeze)
	TFM.freezePlayer(player, freeze)
	if not players[player] then return end
	players[player].isFrozen = freeze
end

--[[ social/setNightMode.lua ]]--
setNightMode = function(name, remove)
	if not players[name].isBlind and remove then return end
	if not remove then 
		players[name].isBlind = {}
		players[name].isBlind[#players[name].isBlind+1] = addImage("1721ee7d5b9.png", '$'..name, -800, -400, name)
		ui.addTextArea(1051040, '', name, 800, 8400, 400, 700, 0x1, 0x1, 1)
	else
		player_removeImages(players[name].isBlind)
		ui.removeTextArea(1051040, name)
		players[name].isBlind = false
	end
end

--[[ social/showPlayerLevel.lua ]]--
generateLevelImage = function(player, level, requested)
	if player == requested then 
		TFM.setPlayerScore(player, level)
	end
	local level = tostring(level)
	local iconImage = mainAssets.levelIcons.lvl -- change to player current star icon
	local playerImage = players[requested].playerNameIcons.level
	if not playerImage[player] then 
		playerImage[player] = {}
	else 
		for i = 1, #playerImage[player] do 
			removeImage(playerImage[player][i])
		end 
		playerImage[player] = {}
	end
	playerImage[player][#playerImage[player]+1] = addImage("1716206af81.png", "$"..player, -10, requested ~= player and -70 or -80, requested)
	for i = 1, #level do 
		local id = tonumber(level:sub(i, i))+1
		playerImage[player][#playerImage[player]+1] = addImage(iconImage[id][1], "$"..player, (i-1)*8 - (#level*8)/2 -5, requested ~= player and -69 or -79, requested)
	end
end

--[[ social/addLootDrop.lua ]]--
addLootDrop = function(x, y, wind)
	for i = 1, 51 do
		local a = TFM.addShamanObject(1, -500, 2800)
		TFM.removeObject(a)
	end
	local fallingSpeed = 5
	local id = 1
	addGround(id..'44444444', x, y-14, {type = 14, width = 80, friction = 9999, dynamic = true, fixedRotation = true, miceCollision = false, linearDamping = fallingSpeed})
	addGround(id..'44444445', x+29, y-50, {type = 14, height = 62, width = 25, dynamic = true, friction = 0.3, fixedRotation = true, linearDamping = fallingSpeed})
	addGround(id..'44444446', x-29, y-50, {type = 14, height = 62, width = 25, dynamic = true, friction = 0.3,  fixedRotation = true, linearDamping = fallingSpeed})
	addGround(id..'44444447', x, y-69, {type = 14, height = 23, width = 32, dynamic = true, friction = 0.3,  fixedRotation = true, linearDamping = fallingSpeed})


	addGround(id..'44444450', x-40, y+40, {type = 14, width = 2000, restitution = 1, angle = 90- wind*.5, miceCollision = false})
	addGround(id..'44444451', x-160, y+40, {type = 14, width = 2000, restitution = 1, angle = 90- wind*.5, miceCollision = false})
	addGround(id..'44444452', x-120, y-14, {type = 14, width = 80, friction = 9999, dynamic = true, fixedRotation = true, miceCollision = false, linearDamping = fallingSpeed*1.35})

	TFM.addJoint(id..'1', id..'44444444', id..'44444445', {type = 3})
	TFM.addJoint(id..'2', id..'44444446', id..'44444447', {type = 3})
	TFM.addJoint(id..'3', id..'44444444', id..'44444446', {type = 3})

	id = id + 1
	local box = TFM.addShamanObject(6300, x, y-20)
	local lootImage = addImage('171ebdaa31b.png', '#'..box, -40 -110, -127 -145)

	local auxiliarBox = TFM.addShamanObject(6300, x-120, y-20)

	local lastPos = {}
	local checkExplosion
	checkExplosion = addTimer(function()
		for i, v in next, tfm.get.room.objectList do 
			if i == auxiliarBox then 
				if lastPos[1] == v.x and lastPos[2] == v.y and v.y > 7490 then 
					for i = 1, 10 do 
						TFM.displayParticle(10, v.x+50+math.random(0, 150), v.y-250+math.random(0, 170))
						TFM.displayParticle(3, v.x+80+math.random(0, 75), v.y+23)
					end
					local objs = {}
					local images = {'171ec448e1c.png', '171ec446276.png', '171ec443e74.png', '171ec4424c1.png'}
					for i = 1, 15 do 
						objs[#objs+1] = TFM.addShamanObject(95, v.x+20+math.random(0, 150), v.y-250+math.random(0, 80), math.random(0, 50), math.random(-10, 10))
						addImage(images[math.random(#images)], '#'..objs[#objs], 0, 0)
					end
					addTimer(function()
						for i = 1, #objs do 
							TFM.removeObject(objs[i])
						end
					end, 1000, 1)
					removeImage(lootImage)
					lootImage = addImage('171eb5f183b.png', '#'..box, -45, -122)
					removeTimer(checkExplosion)
				end
				lastPos[1] = v.x
				lastPos[2] = v.y
			end
		end
	end, 500, 0)
end

--[[ vehicles/vehicles.lua ]]--
drive = function(name, vehicle)
	local playerData = players[name]
	if playerData.canDrive or playerData.place == 'mine' or not playerData.cars[1] then return end
	local car = mainAssets.__cars[vehicle]
	if not car then return end
	if car.type ~= 'boat' and (ROOM.playerList[name].y < 7000 or ROOM.playerList[name].y > 7800 or players[name].place ~= 'town' and players[name].place ~= 'island') then return end
	if car.type == 'boat' then
		local canUseBoat = false
		for where, biome in next, room.fishing.biomes do
			if biome.canUseBoat then
				if math.range(biome.location, {x = ROOM.playerList[name].x, y = ROOM.playerList[name].y}) then
					canUseBoat = where
					break
				end
			end
		end
		if not canUseBoat then return end
		local align = players[name].place == room.fishing.biomes[canUseBoat].between[1] and room.fishing.biomes[canUseBoat].location[1].x+100 or room.fishing.biomes[canUseBoat].location[3].x-80
		tfm.exec.movePlayer(name, align, room.fishing.biomes[canUseBoat].location[1].y + (vehicle == 11 and -50 or 70), false)
		local function getOutVehicle(player, side)
			players[player].place = room.fishing.biomes[canUseBoat].between[side]
			removeCarImages(player)
			players[player].selectedCar = false
			players[player].driving = false
			players[player].canDrive = false
			players[player].currentCar.direction = nil
			freezePlayer(player, false)
			loadMap(player)
			ui.removeTextArea(-2000, player)
			ui.removeTextArea(-2001, player)
			if players[player].questLocalData.other.goToIsland and players[player].place == 'island' then
				quest_updateStep(player)
			end
			if players[player].fishing[1] then
				stopFishing(player)
			end
			tfm.exec.movePlayer(player, room.fishing.biomes[canUseBoat].location[side+1].x-60, room.fishing.biomes[canUseBoat].location[1].y+30, false)
		end
		ui.addTextArea(-2001, string.rep('\n', 500/4), name, room.fishing.biomes[canUseBoat].location[1].x-900, room.fishing.biomes[canUseBoat].location[1].y-1500, 1000, 2000, 0x1, 0x1, 0, false,
			function(player)
				getOutVehicle(player, 1)
			end)
		ui.addTextArea(-2000, string.rep('\n', 500/4), name, room.fishing.biomes[canUseBoat].location[3].x-100, room.fishing.biomes[canUseBoat].location[3].y-1500, 1000, 2000, 0x1, 0x1, 0, false,
			function(player)
				getOutVehicle(player, 2)
			end)
	end
	for i = 1021, 1051 do
		ui.removeTextArea(i, name)
	end
	freezePlayer(name, true)
	playerData.selectedCar = vehicle
	playerData.canDrive = true
	removeCarImages(name)
	playerData.carImages[#playerData.carImages+1] = addImage(car.image[1], "$"..name, car.x, car.y)
end

checkIfPlayerIsDriving = function(name)
	local playerData = players[name]
	if playerData.canDrive then
		removeCarImages(name)
		playerData.selectedCar = nil
		playerData.driving = false
		playerData.canDrive = false
		playerData.currentCar.direction = nil
		freezePlayer(name, false)
		showOptions(name)
		loadMap(name)
	end
end

removeCarImages = function(player)
	if not players[player] then return end
    player_removeImages(players[player].carImages)
    player_removeImages(players[player].carLeds)
end

showBoatShop = function(player, floor)
	if not room.boatShop2ndFloor then
		addGround(7777777777, 1125, 9280, {type = 14, height = 300, width = 20})
	else 
		ui.addTextArea(5005, string.rep('\n', 20), player, 1000, 9290, 121, 120, 0x1, 0x1, 0, false, 
			function(player)
				TFM.movePlayer(player, 1060, 9710)
				players[player].place = 'boatShop_2'
				showBoatShop(player, 2)
			end)
		ui.addTextArea(5006, string.rep('\n', 20), player, 1000, 9590, 121, 120, 0x1, 0x1, 0, false, 
			function(player)
				TFM.movePlayer(player, 1060, 9410)
				players[player].place = 'boatShop'
				showBoatShop(player, 1)
			end)
	end
	local vehicles = {{6, 8}, {12, 11}}
	local position = {{1510, 1710}, {775, 1150}}
	local width = {{180, 180}, {180, 580}}
	for i, v in next, vehicles[floor] do 
		local carInfo = mainAssets.__cars[v]
		ui.addTextArea(5005+i*5, '<p align="center"><font color="#000000" size="14">'..translate('vehicle_'..v, player), player, position[floor][i], 9425+(floor-1)*300, width[floor][i], 80, 0x46585e, 0x46585e, 1)
		ui.addTextArea(5006+i*5, ''..translate('speed', player):format(math.floor(carInfo.maxVel/(carInfo.type == 'boat' and 1.85 or 1)))..' '..translate(carInfo.type == 'boat' and 'speed_knots' or 'speed_km', player), player, position[floor][i], 9445+(floor-1)*300, width[floor][i], nil, 0x46585e, 0x00ff00, 0)
		if not table.contains(players[player].cars, v) then
			if carInfo.price <= players[player].coins then
				ui.addTextArea(5007+i*5, '<p align="center"><vp>$'..carInfo.price..'\n', player, position[floor][i], 9485+(floor-1)*300, width[floor][i], nil, nil, 0x00ff00, 0.5, false, 
					function(player)
						if table.contains(players[player].cars, v) then return end
						players[player].cars[#players[player].cars+1] = v
						giveCoin(-mainAssets.__cars[v].price, player)
						showBoatShop(player, floor)
					end)
			else
				ui.addTextArea(5007+i*5, '<p align="center"><r>$'..carInfo.price, player, position[floor][i], 9485+(floor-1)*300, width[floor][i], nil, nil, 0xff0000, 0.5)
			end
		else
			ui.addTextArea(5007+i*5, '<p align="center">'..translate('owned', player), player, position[floor][i], 9485+(floor-1)*300, width[floor][i], nil, nil, 0x0000ff, 0.5)
		end
	end
end

showCarShop = function(player)
	local counter = #mainAssets.__cars+1
	local currentCount = 0
	for v = 1, 7 do
		local carInfo = mainAssets.__cars[v]
		if carInfo then
			if carInfo.type == 'car' then
				ui.addTextArea(5005+v*counter, '<p align="center"><font color="#000000" size="14">'..carInfo.name, player, (currentCount)*200 + 8805, 130+140, 180, 80, 0x46585e, 0x46585e, 1)
				ui.addTextArea(5006+v*counter, ''..translate('speed', player):format(carInfo.maxVel)..' '..translate('speed_km', player), player, (currentCount)*200 + 8805, 130+160, 180, nil, 0x46585e, 0x00ff00, 0)

				if not table.contains(players[player].cars, v) then
					if carInfo.price <= players[player].coins then
						ui.addTextArea(5007+v*counter, '<p align="center"><vp>$'..carInfo.price..'\n', player, (currentCount)*200 + 8805, 130+200, 180, nil, nil, 0x00ff00, 0.5, false, 
							function(player)
								if table.contains(players[player].cars, v) then return end
								players[player].cars[#players[player].cars+1] = v
								players[player].selectedCar = v
								players[player].place = 'town'

								TFM.movePlayer(player, 5000, 1980+room.y, false)
								giveCoin(-mainAssets.__cars[v].price, player)
								drive(player, v)
							end)
					else
						ui.addTextArea(5007+v*counter, '<p align="center"><r>$'..carInfo.price, player, (currentCount)*200 + 8805, 130+200, 180, nil, nil, 0xff0000, 0.5)
					end
				else
					ui.addTextArea(5007+v*counter, '<p align="center">'..translate('owned', player), player, (currentCount)*200 + 8805, 130+200, 180, nil, nil, 0x0000ff, 0.5)
				end
				currentCount = currentCount + 1
			end
		end
	end
end

--[[ gameHour.lua ]]--
hourOfClock = function()
	local hour = math.floor(24 * (room.currentGameHour / 1440))
	local min = (room.currentGameHour % 60)
	hour = (hour + 12) % 24
	return string.format("%.2d:%.2d", hour, min)
end

checkGameHour = function(hour)
	if hour == '-' then return true end
	local time = hourOfClock()
	time = time:gsub(':', '')
	time = tonumber(time)
	hour = hour:gsub(':', '')
	local opened, closed = hour:match('(%d+) (%d+)')
	return time > tonumber(opened) and time < tonumber(closed)
end

updateHour = function(player, arg)
	local time = hourOfClock()

	if arg then
		return time
	else
		ui.addTextArea(1457, '<p align="center"><b><font size="32" face="Arial">'..time, player, 2100-2, 8718-1185+11, 120, 70, 0x1, 0x1, 0)
		if time == '17:00' then
			loadDayTimeEffects('evening')
		elseif time == '19:00' then
			loadDayTimeEffects('night')
		elseif time == '05:00' then
			loadDayTimeEffects('dawn')
		elseif time == '07:00' then
			loadDayTimeEffects('day')
		elseif time == '21:00' then
			kickPlayersFromPlace('market')
		end
	end
end

formatDaysRemaining = function(calc, ended)
	local daysfrom = os.difftime(os.time(), calc) / (24 * 60 * 60) / 1000
	if not ended then
		return math.abs(math.floor(daysfrom))
	else
		if math.floor(daysfrom) >= 0 then
			return true
		end
	end
end

--[[ lifeStats.lua ]]--
local lifeStatsIcons = {{'171653c0aa6.png', '17174d72c5e.png', '17174d81707.png'}, {'170f8acc9f4.png', '170f8ac976f.png', '170f8acf954.png'}}
showLifeStats = function(player, lifeStat)
	local playerInfos = players[player]
	if playerInfos.editingHouse then return end

	for i = 1, #playerInfos.lifeStatsImages[lifeStat].images do 
		removeImage(playerInfos.lifeStatsImages[lifeStat].images[i])
	end
	playerInfos.lifeStatsImages[lifeStat].images = {}
	local selectedImage = playerInfos.lifeStats[lifeStat] > 80 and 1 or playerInfos.lifeStats[lifeStat] > 40 and 2 or 3

	playerInfos.lifeStatsImages[lifeStat].images[#playerInfos.lifeStatsImages[lifeStat].images+1] = addImage(lifeStatsIcons[lifeStat][selectedImage], ":2", (lifeStat-1)*45, 365, player)
	if playerInfos.lifeStats[lifeStat] <= 0 then
		playerInfos.hospital.diseases[#playerInfos.hospital.diseases+1] = lifeStat
		loadHospital(player)
		checkIfPlayerIsDriving(player)
		hospitalize(player)
		loadHospitalFloor(player)
		players[player].lifeStats[lifeStat] = 0
	end
	ui.addTextArea(999995-lifeStat*2, "<p align='center'><font color='#000000'>"..playerInfos.lifeStats[lifeStat], player, 11 + (lifeStat-1)*45, 386, 50, nil, 0x324650, 0x000000, 0, true)
	ui.addTextArea(999994-lifeStat*2, "<p align='center'><font color='#ffffff'>"..playerInfos.lifeStats[lifeStat], player, 10 + (lifeStat-1)*45, 385, 50, nil, 0x324650, 0x000000, 0, true)
end

setLifeStat = function(player, lifeStat, quant)
	players[player].lifeStats[lifeStat] = players[player].lifeStats[lifeStat] + quant 
	if players[player].lifeStats[lifeStat] > 100 then
		players[player].lifeStats[lifeStat] = 100
	end
	showLifeStats(player, lifeStat)
end

updateBarLife = function(player)
	local playerInfos = players[player]
	if not playerInfos then return end
	if playerInfos.hospital.hospitalized then return end
	if playerInfos.lifeStats[1] <= 94 and not playerInfos.robbery.robbing then
		setLifeStat(player, 1, playerInfos.place == 'cafe' and 3 or 2)
		if string.find(playerInfos.place, 'house_') then
			local house_ = playerInfos.place:sub(7)
			if playerInfos.houseData.houseid == house_ then
				setLifeStat(player, 1, 1)
			end
		end
	end
	setLifeStat(player, 2, -1) 
end

--[[ dayPeriods.lua ]]--
loadFound = function(player, house)
	local id = tonumber(house)
	local y = 1590
	for i = 1, #players[player].dayImgs do
		removeImage(players[player].dayImgs[i])
	end
	local img = background(nil, nil, nil, true)
	for i = 1, 3 do
		players[player].dayImgs[#players[player].dayImgs+1] = addImage(img, '?1', ((id-1)%id)*1500 - 1200 + (i-1)*1919, 420, player)
	end
end

background = function(player, period, rain, getPng)
	if not period then period = room.gameDayStep end
	local png = nil
	local align = nil
	local yalign = -1000

	if not room.event or room.event == '' then
		align = 1919
		if period == 'day' then
			png = '1724c10adda.jpg'
		elseif period == 'evening' then
			png = '1724c1daa44.jpg'
		elseif period == 'night' then
			png = '16baeb0ead4.jpg'
		elseif period == 'dawn' then
			png = '16b80619ab9.jpg'
		elseif period == 'halloween' then
			png = '15ed953938a.jpg'
		end

	else
		png = room.specialFounds[room.event][period]
		align = room.specialFounds[room.event].align
	end
	if getPng then return png end

	for i = 1, #players[player].background do
		removeImage(players[player].background[i])
	end
	players[player].background = {}

	if png then
		for i = 1, 11 do
			players[player].background[#players[player].background+1] = addImage(png, '?1', (i-1)*align, 1610 + room.y + yalign, player)
			players[player].background[#players[player].background+1] = addImage(png, '?1', (i-1)*align, 0 + yalign, player)
		end
		players[player].background[#players[player].background+1] = addImage(png, '?1', 4000, 3000, player)
		players[player].background[#players[player].background+1] = addImage(png, '?1', 4000+align, 3000, player)

		for i = 1, 3 do
			players[player].background[#players[player].background+1] = addImage(png, '?1', 4500+(i-1)*align, 4920 + yalign, player)
		end
		if period == 'night' then
			players[player].background[#players[player].background+1] = addImage("16b952d1012.png", "!9999", 4500, 4920 + yalign, player)
		end
	end
end

loadDayTimeEffects = function(period)
	if period == 'night' then
		gameNpcs.removeNPC('Colt')
	elseif period == 'day' then
		gameNpcs.reAddNPC('Colt')
		room.bankBeingRobbed = false
		room.bankRobStep = nil
		for i = 1, #room.bankImages do
			removeImage(room.bankImages[i])
		end
		room.bankImages = {}
		room.bankPassword = math.random(0,9) .. math.random(0,9) .. math.random(0,9) .. math.random(0,9)
		for i = 1, #room.bank.paperImages do
			removeImage(room.bank.paperImages[i])
		end
		room.dayCounter = room.dayCounter + 1
		if room.dayCounter > 0 then 
			room.bank.paperImages = {}
			room.bank.paperCurrentPlace = math.random(1, #room.bank.paperPlaces)
			room.bank.paperImages[#room.bank.paperImages+1] = addImage('16bbf3aa649.png', '!1', room.bank.paperPlaces[room.bank.paperCurrentPlace].x, room.bank.paperPlaces[room.bank.paperCurrentPlace].y)
			ui.addTextArea(-3333, '<a href="event:getVaultPassword">'..string.rep('\n', 10), nil, room.bank.paperPlaces[room.bank.paperCurrentPlace].x, room.bank.paperPlaces[room.bank.paperCurrentPlace].y, 20, 20, 0, 0, 0)
		end
	end
	room.gameDayStep = period

	closePlaces()
	for i, v in next, ROOM.playerList do
		background(i, room.gameDayStep)
		if players[i] then
			if players[i].place:find('house_') then
				house = players[i].place:sub(7)
				loadFound(i, house)
			end
		end
		if period == 'day' then 
			ui.addTextArea(1029, '<font size="15"><p align="center"><a href="event:enter_bank">' .. translate('goTo', i) .. '</a>', i, 2670, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.3)
		end
	end
end

--[[ tips.lua ]]--
local tips = {
	BR = {'Você consegue ir e voltar a pé pelo no mapa até 14 vezes em 1 hora!','O jogo começa quando estiverem presentes no mínimo 4 pessoas na sala com IPs diferentes.', 'A planta mais rara do jogo é a Flor-da-sorte!', 'Existem '..#bagIds..' itens no jogo!', 'Você pode plantar na horta de Oliver!', 'Digite <i>!perfil [jogador]</i> para ver perfis de diferentes jogadores!', 'Existem '..#sideQuests..' missões secundárias disponíveis!', 'Você sabia? #mycity foi criado em 2014!', 'Você sabia? A comunidade brasileira é a que mais joga #mycity!'},
	EN = {'There are '..#bagIds..' items in the game!', 'The rarest plant is the lucky flower!', 'You can plant in Oliver\'s house.', 'Type <i>!profile [playerName]</i> to see profiles from different players!', 'There are '..#sideQuests..' side quests available!'},
	HU = {'Tudtad? A börtönből megszökhetsz egy csákány segítségével a wc-n keresztül!', 'Tudtad? Küldetések teljesítésével jutalmakat kaphatsz!', 'Tudtad? Készül egy Mycity téma a fórumon. <a href="event:topic_HU">Kattints ide a linkért</a>! ', 'Hamarosan új frissítések kerülnek a játékba. Ha bármi hibát észlelsz, jelezd a fejlesztőnek!', 'Érdekesség: A játék 2014-ben jelent meg!', 'Tudtad? Beszélhetsz a pályán elhelyezett NPC-vel, ha közel mész hozzá és rákattintasz!', 'Ne felejtsd el az éhségedet és az energiádat fenntartani!', 'Ha kórházba kerülsz, az egyenlegedből $400 levonásra kerül!', 'A Bankrabláshoz 2 dinamitra, 1 zsugorító bájitalra és a széf kódjára van szükséged!', 'Tudtad? Ha alszol, az energiád feltöltődik!', 'Adataid autómatikusan mentésre kerülnek!'},
}

--[[ map/game.lua ]]--
genMap = function()
	room.groundsPosition = {250, 749+250, 50}
	room.isInLobby = false
    local xml = {}
    local xml2 = {}
    local obj = {}
    local spawn = {}
	local aps = '16bb480f649.png,1,5791,4596,205,200,5791,4596;16f8fd6e0e9.png,1,8505,6230,2000,500,8498,5950'

	--16bf16a367a.png -- original
	--16dcff228d2.png -- halloween
	local largeGrass = '16bce6d826c.jpg'
	local largeEarth = '16bce7d39d8.jpg'
	if room.event == 'halloween2019' then
		largeGrass = '16de5dedee3.jpg'
		largeEarth = '16de5e3db57.jpg'
	elseif room.event == 'christmas2019' then
		largeGrass = '16f19d53238.jpg'
	end
    for i = 1, 17 do
		xml[#xml+1] = '<S H="10" L="3000" X="'..room.groundsPosition[2]..'" c="3" Y="800" m="" T="5" P="0,0,0.3,0,0,0,0,0" /><S H="1400" L="10" X="'..room.groundsPosition[3]..'" Y="1100" m="" T="5" P="0,0,0,0,0,0,0,0" /><S H="110" L="800" X="'..room.groundsPosition[2]..'" c="3" m="" Y="1790" T="9" P="0,0,0.3,0,0,0,0,0" /><S H="150" L="800" i="0,0,'..largeEarth..'" X="'..room.groundsPosition[2]..'" c="3" Y="1870" T="5" P="0,0,0.3,0,0,0,0,0" /><S H="220" L="800" i="0,0,'..largeGrass..'" X="'..room.groundsPosition[1]..'" Y="1825" T="6" P="0,0,0.3,0,0,0,0,0" />'
		for i = 1, 3 do
			room.groundsPosition[i] = room.groundsPosition[i] + 1500
		end
	end
	-- wall
		xml[#xml+1] = '<S L="50" X="9600" H="300" Y="170" T="4" m="" P="0,0,0,0,0,0,0,0" /><S L="50" X="8420" H="300" Y="170" T="4" m="" P="0,0,0,0,0,0,0,0" />'
	-- hospital
		xml[#xml+1] = '<S T="14" L="137" H="30" X="4102" Y="3645" P="0,0,0.3,0,5,0,0,0,0"/><S T="14" L="3000" H="10" X="5500" Y="3660" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="14" L="3000" H="10" X="6600" Y="3260" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="12" o="665b4e" L="3000" H="100" X="6600" Y="2950" P="0,0,0,0,-180,0,0,0" N="" c="3"/><S T="12" o="665b4e" L="3000" H="100" X="5500" Y="2950" P="0,0,0,0,-180,0,0,0" N="" c="3"/><S T="14" L="3000" H="10" X="5500" Y="3260" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="14" L="10" H="800" X="4800" Y="3400" P="0,0,0,0,0,0,0,0" c="3"/><S T="14" L="10" H="800" X="4000" Y="3400" P="0,0,0,0,0,0,0,0" c="3"/><S T="14" L="10" H="400" X="5700" Y="3200" P="0,0,0,0,0,0,0,0" c="3"/><S T="14" L="10" H="400" X="4900" Y="3200" P="0,0,0,0,0,0,0,0" c="3"/><S T="14" L="10" H="400" X="6600" Y="3200" P="0,0,0,0,0,0,0,0" c="3"/><S T="14" L="10" H="400" X="5800" Y="3200" P="0,0,0,0,0,0,0,0" c="3"/><S T="14" L="10" H="400" X="7500" Y="3200" P="0,0,0,0,0,0,0,0" c="3"/><S T="14" L="10" H="400" X="6700" Y="3200" P="0,0,0,0,0,0,0,0" c="3"/><S T="14" L="95" H="30" X="4098" Y="3233" P="0,0,0.3,0.5,0,0,0,0"/><S T="14" L="95" H="30" X="4691" Y="3233" P="0,0,0.3,0.5,0,0,0,0"/><S T="14" L="95" H="30" X="4998" Y="3233" P="0,0,0.3,0.5,0,0,0,0"/><S T="14" L="95" H="30" X="5591" Y="3233" P="0,0,0.3,0.5,0,0,0,0"/><S T="14" L="95" H="30" X="5898" Y="3233" P="0,0,0.3,0.5,0,0,0,0"/><S T="14" L="95" H="30" X="6491" Y="3233" P="0,0,0.3,0.5,0,0,0,0"/><S T="14" L="95" H="30" X="6798" Y="3233" P="0,0,0.3,0.5,0,0,0,0"/><S T="14" L="95" H="30" X="7391" Y="3233" P="0,0,0.3,0.5,0,0,0,0"/>'
	-- seedStore
		xml[#xml+1] = '<S T="12" L="40" H="400" X="11350" Y="51" P="0,0,0,0,0,0,0,0" N="" o="4b2400"/><S T="12" L="40" H="400" X="12165" Y="51" P="0,0,0,0,0,0,0,0" N="" o="4b2400"/>'
	-- café
		xml[#xml+1] = '<S T="14" L="10" H="400" X="7090" Y="100" P="0,0,0,0,0,0,0,0"/><S T="14" L="10" H="200" X="6005" Y="143" P="0,0,0,0,0,0,0,0" c="3" o="ffffff"/>'
	-- Potion store
		xml[#xml+1] = '<S T="14" L="10" H="500" X="10500" Y="50" P="0,0,0,0,0,0,0,0"/><S T="14" L="10" H="500" X="10910" Y="50" P="0,0,0,0,0,0,0,0"/>'
	-- Dealership
		xml[#xml+1] = '<S T="12" L="1400" H="200" X="9100" Y="350" P="0,0,0.3,0,0,0,0,0" o="909090"/>'
	-- Pizzeria
		xml[#xml+1] = '<S T="12" L="40" H="400" X="14000" Y="50" P="0,0,0,0,0,0,0,0" o="4b2400"/><S T="12" L="400" N="" H="400" X="15200" Y="50" P="0,0,0,0,0,0,0,0" o="4b2400"/>'
	-- Furniture Store
		xml[#xml+1] = '<S T="12" L="40" H="400" X="16000" Y="50" P="0,0,0,0,0,0,0,0" o="f0f0f0"/><S T="12" L="40" H="400" X="17015" Y="50" P="0,0,0,0,0,0,0,0" o="f0f0f0"/>'
	-- Fish Shop 
		xml[#xml+1] = '<S T="14" L="50" H="300" X="12585" Y="100" P="0,0,0,0,0,0,0,0"/><S T="14" L="50" H="300" X="13200" Y="100" P="0,0,0,0,0,0,0,0"/>'

	-- Oliver's house
		xml[#xml+1] = '<S T="14" L="340" H="10" X="15292" Y="1571" P="0,0,0.3,0,0,0,0,0"/><S T="13" m="" L="25" H="10" X="15600" Y="1676" P="0,0,0,1,0,0,0,0" o="fffff"/><S T="14" L="100" H="20" X="15575" Y="1705" P="0,0,0.3,0,0,0,0,0"/><S T="14" L="340" H="10" X="15380" Y="1439" P="0,0,0.3,0,0,0,0,0"/><S T="14" L="180" H="10" X="15140" Y="1422" P="0,0,0,0,-60,0,0,0"/><S T="14" L="180" H="10" X="15537" Y="1422" P="0,0,0,0,60,0,0,0"/><S T="14" L="10" H="120" X="15120" Y="1520" P="0,0,0,0,0,0,0,0"/><S T="14" L="180" H="10" X="15420" Y="1290" P="0,0,0,0,35,0,0,0"/><S T="14" L="180" H="10" X="15257" Y="1290" P="0,0,0,0,-35,0,0,0"/>'
	-- Police Station 
		-- Jail 
		local aps2 = {}
		for i = 1, 18 do 
			aps2[#aps2+1] = '16f9672ce4a.png,1,' .. (8045 + (i-1)*25) .. ',6260,30,174,' .. (8045 + (i-1)*25) .. ',6260;16f96805a4f.png,1,0,0,30,174,' .. (8045 + (i-1)*25) .. ',6260;'
		end
		spawn[#spawn+1] = '<P P="1,0" C="e8e9eb,cf8531" Y="6405" T="119" X="8475" />'

		local streetGrounds = '<S T="12" L="2000" H="300" X="5539" Y="5395" P="0,0,0.3,0,0,0,0,0" o="8f8570"/><S T="14" L="34" H="1023" X="6029" Y="4739" P="0,0,0,0,0,0,0,0"/><S T="14" L="100" H="1000" X="5014" Y="4750" P="0,0,0,0,0,0,0,0" c="3"/><S T="14" L="25" H="180" X="5260" Y="5100" P="0,0,0,0,0,0,0,0"/><S T="14" L="796" H="54" X="5648" Y="5030" P="0,0,0.3,0,0,0,0,0"/><S T="14" L="230" H="173" X="5106" Y="5260" P="0,0,0.3,0,33,0,0,0"/><S T="14" L="150" H="10" X="5195" Y="5053" P="0,0,0.3,0,-37,0,0,0"/><S T="14" L="150" H="10" X="5195" Y="5138" P="0,0,0.3,0,37,0,0,0"/><S T="14" L="794" H="46" X="5648" Y="4810" P="0,0,0.3,0,0,0,0,0"/><S T="14" L="200" H="10" X="5115" Y="4910" P="0,0,0.3,0,39,0,0,0"/><S T="14" L="200" H="10" X="5115" Y="5030" P="0,0,0.3,0,-39,0,0,0"/><S T="14" L="120" H="10" X="5204" Y="4826" P="0,0,0.3,0,-37,0,0,0"/><S T="14" L="120" H="10" X="5204" Y="4892" P="0,0,0.3,0,37,0,0,0"/><S T="14" L="24" H="130" X="5260" Y="4869" P="0,0,0,0,0,0,0,0"/><S T="14" L="1032" H="50" X="5516" Y="4565" P="0,0,0,0,0,0,0,0"/><S T="14" L="31" H="131" X="5808" Y="4653" P="0,0,0,0,0,0,0,0"/><S T="14" L="75" H="10" X="5433" Y="4974" P="0,0,0,0,0,0,0,0"/><S T="14" L="20" H="25" X="5373" Y="4997" P="0,0,0.3,0,0,0,0,0"/><S T="14" L="20" H="25" X="5496" Y="4997" P="0,0,0.3,0,0,0,0,0"/><S T="14" L="778" H="30" X="7502" Y="5846" P="0,0,0,0,0,0,0,0"/><S T="12" L="20" H="398" X="7877" Y="6045" P="0,0,0,0,0,0,0,0" o="ffffff"/><S T="14" L="40" H="465" X="7111" Y="6068" P="0,0,0,0,0,0,0,0" i="-489,-187,172a62d3af2.png"/><S T="14" L="40" H="800" X="8520" Y="6020" P="0,0,0,0,0,0,0,0"/><S T="14" L="310" H="22" X="7287" Y="6105" P="0,0,0.3,0.2,0,0,0,0"/><S T="14" L="20" H="222" X="8042" Y="6351" P="0,0,0,0,0,0,0,0"/><S T="14" L="310" H="22" X="7287" Y="5978" P="0,0,0.3,0.2,0,0,0,0"/><S T="14" L="325" H="22" X="7718" Y="5978" P="0,0,0.3,0.2,0,0,0,0"/><S T="14" L="322" H="22" X="7716" Y="6105" P="0,0,0.3,0.2,0,0,0,0"/><S T="14" L="900" H="22" X="8153" Y="6236" P="0,0,0.3,0.2,0,0,0,0"/><S T="14" c="3" L="600" H="56" X="7294" Y="6254" P="0,0,0.3,0.2,0,0,0,0"/><S T="14" c="3" L="300" H="42" X="7685" Y="6345" P="0,0,0.3,0.2,45,0,0,0"/><S T="14" c="3" L="900" H="60" X="8152" Y="6437" P="0,0,0.3,0.2,0,0,0,0"/><S L="30" X="3450" H="300" Y="170" T="12" P="0,0,0,0,0,0,0,0" i="0,2,16f09acf0bc.png"/><S L="3000" X="1500" H="50" Y="-5" T="14" P="0,0,0.3,0.2,0,0,0,0"/><S L="3000" X="1500" H="50" i="0,0,1708cc51823.jpg" Y="275" T="12" P="0,0,0.3,0.2,0,0,0,0"/><S L="3000" X="4500" H="50" Y="-5" T="14" P="0,0,0.3,0.2,0,0,0,0"/><S L="3000" X="4500" H="50" i="0,0,1708cc51823.jpg" Y="275" T="12" P="0,0,0.3,0.2,0,0,0,0"/><S L="3000" X="7500" H="50" Y="-5" T="14" P="0,0,0.3,0.2,0,0,0,0"/><S L="3000" X="7500" H="50" i="0,0,1708cc51823.jpg" Y="275" T="12" P="0,0,0.3,0.2,0,0,0,0" o=""/><S L="3000" X="10500" H="50" Y="-5" T="14" P="0,0,0.3,0.2,0,0,0,0"/><S L="3000" X="10500" H="50" i="0,0,1708cc51823.jpg" Y="275" T="12" P="0,0,0.3,0.2,0,0,0,0"/><S L="3000" X="13500" H="50" Y="-5" T="14" P="0,0,0.3,0.2,0,0,0,0"/><S L="3000" X="13500" H="50" i="0,0,1708cc51823.jpg" Y="275" T="12" P="0,0,0.3,0.2,0,0,0,0"/><S L="3000" X="16500" H="50" Y="-5" T="14" P="0,0,0.3,0.2,0,0,0,0"/><S L="3000" X="16500" H="50" i="0,0,1708cc51823.jpg" Y="275" T="12" P="0,0,0.3,0.2,0,0,0,0"/><S L="3000" X="19500" H="50" Y="-5" T="14" P="0,0,0.3,0.2,0,0,0,0"/><S L="3000" X="19500" H="50" i="0,0,1708cc51823.jpg" Y="275" T="12" P="0,0,0.3,0.2,0,0,0,0"/><S L="3000" X="22500" H="50" Y="-5" T="14" P="0,0,0.3,0.2,0,0,0,0"/><S L="3000" X="22500" H="50" i="0,0,1708cc51823.jpg" Y="275" T="12" P="0,0,0.3,0.2,0,0,0,0"/><S L="3000" X="25500" H="50" Y="-5" T="14" P="0,0,0.3,0.2,0,0,0,0"/><S L="3000" X="25500" H="50" i="0,0,1708cc51823.jpg" Y="275" T="12" P="0,0,0.3,0.2,0,0,0,0"/><S L="1599" H="102" X="2400" Y="7826" i="0,-400,170f00f4705.png" T="12" P="0,0,0.3,0.2,0,0,0,0" o=""/><S L="1600" H="102" X="3999" Y="7826" i="0,-400,17200ada21f.png" T="12" P="0,0,0.3,0.2,0,0,0,0" o=""/><S L="1600" H="102" X="5598" Y="7826" i="0,-400,172a473bd5f.png" T="12" P="0,0,0.3,0.2,0,0,0,0" o=""/><S L="3000" H="50" X="1500" Y="7300" c="3" T="14" P="0,0,0,0,0,0,0,0"/><S L="3000" H="50" X="4500" Y="7300" c="3" T="14" P="0,0,0,0,0,0,0,0"/><S L="3000" H="50" X="7500" Y="7300" c="3" T="14" P="0,0,0,0,0,0,0,0"/><S L="3000" H="50" X="10500" Y="7300" c="3" T="14" P="0,0,0,0,0,0,0,0"/><S L="3000" H="50" X="13500" Y="7300" c="3" T="14" P="0,0,0,0,0,0,0,0"/><S L="3000" H="50" X="16500" Y="7300" c="3" T="14" P="0,0,0,0,0,0,0,0"/><S L="20" X="5119" H="300" Y="170" T="14" P="0,0,0,0,0,0,0,0" N=""/><S L="3000" H="50" X="19500" Y="7300" c="3" T="14" P="0,0,0,0,0,0,0,0"/><S L="3000" H="50" X="22500" Y="7300" c="3" T="14" P="0,0,0,0,0,0,0,0"/><S L="3000" H="50" X="25500" Y="7300" c="3" T="14" P="0,0,0,0,0,0,0,0"/><S L="1600" H="50" X="800" Y="7600" i="0,0,17192f72648.png" T="12" P="0,0,0.3,0.2,0,0,0,0"/><S L="1600" H="57" X="800" Y="7604" i="0,0,17193917e30.png" N="" T="12" P="0,0,0.3,0.2,0,0,0,0" o=""/><S T="12" L="350" H="40" X="1430" Y="8241" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="350" H="40" X="1368" Y="8367" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="70" H="130" X="1368" Y="8242" P="0,0,40,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="70" H="70" X="1478" Y="8327" P="0,0,40,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="470" H="70" X="1677" Y="8152" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="180" H="276" X="1197" Y="8430" P="0,0,40,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="314" H="40" X="1479" Y="8484" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="40" H="230" X="1785" Y="8519" P="0,0,40,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="150" H="30" X="1785" Y="8699" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="100" H="40" X="1728" Y="8424" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="110" H="40" X="1610" Y="8577" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="100" H="40" X="1658" Y="8454" P="0,0,1,0.3,136,0,0,0" o="e2ad32"/><S T="12" L="160" H="40" X="1875" Y="8515" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="282" H="40" X="1982" Y="8382" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="45" H="150" X="1863" Y="8382" P="0,0,40,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="50" H="100" X="2028" Y="8317" P="0,0,40,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="300" H="200" X="2238" Y="8204" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="120" H="36" X="1813" Y="8325" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="190" H="40" X="1678" Y="8282" P="0,0,1,0.3,207,0,0,0" o="e2ad32"/><S T="12" L="50" H="150" X="1943" Y="8247" P="0,0,40,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="410" H="130" X="1966" Y="8169" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="175" H="61" X="1719" Y="8196" P="0,0,1,0.3,207,0,0,0" o="e2ad32"/><S T="12" L="180" H="40" X="1873" Y="8243" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="110" H="180" X="1162" Y="8212" P="0,0,40,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="800" H="38" X="1508" Y="8123" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="50" H="90" X="1943" Y="8490" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="50" H="90" X="1942" Y="8490" P="0,0,40,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="110" H="40" X="1973" Y="8465" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="180" H="35" X="1658" Y="8367" P="0,0,1,0.3,-144,0,0,0" o="e2ad32"/><S T="12" L="70" H="30" X="1560" Y="8381" P="0,0,1,0.3,-140,0,0,0" o="e2ad32"/><S T="12" L="1278" H="289" X="1369" Y="8973" P="0,0,1,0,0,0,0,0" o="e2ad32"/><S T="12" L="397" H="27" X="1482" Y="8774" P="0,0,1,0,0,0,0,0" o="e2ad32"/><S T="12" L="132" H="365" X="1174" Y="8910" P="0,0,40,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="120" H="35" X="1955" Y="8594" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="70" H="215" X="1974" Y="8769" P="0,0,40,0.3,0,0,0,0" o="e2ad32"/><S T="14" L="70" H="3000" X="1972" Y="10386" P="0,0,0,0.3,0,0,0,0"/><S T="12" L="170" H="50" X="1698" Y="8640" P="0,0,0,0,52,0,0,0" o="e2ad32"/><S T="12" L="130" H="30" X="1875" Y="8641" P="0,0,0,0,-60,0,0,0" o="e2ad32"/><S T="12" L="250" H="30" X="1498" Y="8597" P="0,0,0,0,61,0,0,0" o="e2ad32"/><S T="12" L="85" H="30" X="1589" Y="8700" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="95" H="40" X="1696" Y="8737" P="0,0,0,0,-50,0,0,0" o="e2ad32"/><S T="12" L="350" H="60" X="1283" Y="8697" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="120" H="84" X="1388" Y="8648" P="0,0,0,0,50,0,0,0" o="e2ad32"/><S T="12" L="58" H="119" X="1327" Y="8659" P="0,0,0,0,50,0,0,0" o="e2ad32"/><S T="12" L="451" H="239" X="2209" Y="8997" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="500" H="467" X="2588" Y="8884" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="200" H="26" X="2268" Y="8663" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="150" H="26" X="2188" Y="8725" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="70" H="180" X="2088" Y="8648" P="0,0,40,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="150" H="20" X="2128" Y="8832" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="150" H="20" X="2058" Y="8782" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="150" H="20" X="2058" Y="8782" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="80" H="120" X="2223" Y="8782" P="0,0,40,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="40" H="140" X="2103" Y="8447" P="0,0,40,0.3,0,0,0,0" o="e2ad32"/><S T="12" L="3000" H="284" X="3882" Y="8246" P="0,0,0,0,0,0,0,0" o="32180b"/><S T="14" L="50" H="50" X="1873" Y="7790" P="0,0,0.2,0.3,34,0,0,0"/><S T="14" L="127" H="529" X="232" Y="7856" P="0,0,0,0,0,0,0,0"/><S T="14" L="371" H="223" X="668" Y="8719" P="0,0,0.3,0.2,0,0,0,0"/><S T="14" L="370" H="226" X="1012" Y="8753" P="0,0,0.3,0.2,11,0,0,0"/><S T="14" L="117" H="150" X="1552" Y="7800" P="0,0,10,0.2,0,0,0,0"/><S T="14" L="450" H="37" X="668" Y="8209" P="0,0,0.3,0.2,0,0,0,0"/><S T="14" L="718" H="236" X="1018" Y="8132" P="0,0,0,0.2,-53,0,0,0"/><S T="14" L="1600" H="102" X="1940" Y="7826" P="0,0,0.3,0.2,0,0,0,0"/><S T="14" L="650" H="114" X="382" Y="8363" P="0,0,0,0.2,60,0,0,0"/><S T="14" L="270" H="15" X="1711" Y="7659" P="0,0,0.5,0.2,34,0,0,0"/><S T="14" L="1500" H="20" X="3586" Y="8570" P="0,0,0,0,0,0,0,0"/><S T="14" L="40" H="2000" X="2835" Y="9121" P="0,0,0,0,0,0,0,0"/><S T="14" L="40" H="2000" X="4325" Y="9108" P="0,0,0,0,0,0,0,0"/><S T="14" L="340" H="62" X="12921" Y="7732" P="0,0,0.5,0.2,-34,0,0,0" N=""/><S T="14" L="2000" H="40" X="14041" Y="7632" P="0,0,0.3,0.2,0,0,0,0" N=""/><S L="3000" H="50" X="10627" Y="7800" i="-1200,-800,172b978531a.png" T="12" P="0,0,0.3,0.2,0,0,0,0" o=""/><S L="1600" H="57" X="12873" Y="7803" T="14" P="0,0,0.3,0.2,0,0,0,0" i="-4140,-800,172b97bd4ef.png"/><S T="14" L="2800" H="20" X="7800" Y="7680" P="0,0,0,0,0,0,0,0"/><S T="14" L="80" H="1777" X="6400" Y="8170" c="3" P="0,0,0,0,0,0,0,0"/><S T="14" L="2829" H="20" X="7783" Y="7830" P="0,0,0,0,0,0,0,0"/><S T="14" L="2833" H="20" c="3" X="7782" Y="7810" P="0,0,0,0,0,0,0,0"/><S T="14" L="80" H="1337" X="9161" Y="7933" c="3" P="0,0,0,0,0,0,0,0"/><S T="14" L="200" H="2000" X="-100" Y="7000" P="0,0,0,0,0,0,0,0"/><S T="14" L="1200" H="66" X="1350" Y="9445" P="0,0,0.3,0.2,0,0,0,0"/><S T="14" L="1200" H="74" X="1350" Y="9750" P="0,0,0.3,0.2,0,0,0,0"/><S T="14" L="210" H="300" X="1845" Y="9576" P="0,0,0,0,0,0,0,0"/><S T="14" L="220" H="300" X="860" Y="9276" P="0,0,0,0,0,0,0,0"/><S T="14" L="30" H="600" X="743" Y="9426" P="0,0,0,0,0,0,0,0"/><S T="14" L="1500" H="20" X="3588" Y="8674" i="0,0,17200cccdc3.png" P="0,0,0,0,0,0,0,0"/><S T="12" L="1225" H="3000" X="5750" Y="10145" P="0,0,100,0,0,0,0,0" o="32180b"/><S T="12" L="904" H="2968" X="5908" Y="9585" P="0,0,0,0,0,0,0,0" o="32180b"/><S T="12" L="210" H="3000" X="4431" Y="10145" P="0,0,100,0.2,0,0,0,0" o="32180b"/><S X="5420" Y="8257" T="9" L="77" H="778" P="0,0,0,0,0,0,0,0" c="4" m=""/><S X="5345" Y="7985" T="14" L="73" H="243" P="0,0,0,0,0,0,0,0" i="72,-90,172a445929d.png"/><S X="5494" Y="7984" T="14" L="73" H="243" P="0,0,0,0,0,0,0,0"/><S X="1139" Y="8611" T="14" L="42" H="127" P="0,0,0,0,0,0,0,0" c="3"/><S X="7499" Y="6136" T="9" L="114" H="85" P="0,0,0,0,0,0,0,0" c="4" m=""/><S X="7499" Y="6009" T="9" L="114" H="85" P="0,0,0,0,0,0,0,0" c="4" m=""/><S T="14" L="2000" H="1000" X="14130" Y="7569" P="0,0,0,0,0,0,0,0" N=""/>'


		-- Boat Shop
			aps2[#aps2+1] = '1727230e19e.jpg,1,650,9125,1400,300,650,9125;1727230e19e.jpg,1,650,9425,1400,300,650,9425;17276006818.png,1,830,9075,300,350,830,9075;'
			aps2[#aps2+1] = '17201b0f743.jpg,1,1100,8050,3410,860,1100,8050;'

		local barriers = {{'<S T="12" L="30" H="90" X="1582" Y="8437" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/>', '<S T="12" L="30" H="90" X="1953" Y="8547" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/>', '<S T="12" L="30" H="90" X="1688" Y="8817" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/>'}, {'<S T="12" L="30" H="90" X="1953" Y="8417" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/>', '<S T="12" L="40" H="90" X="2103" Y="8522" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/>', '<S T="12" L="100" H="25" X="2138" Y="8662" P="0,0,1,0.3,0,0,0,0" o="e2ad32"/>'}}
		local allowedPaths = {
			{{1, 2}, {1, 3}, {4},},
			{{1, 4}, {2}, {3},},
			{{1, 4}, {2}, {3},},
		}
		math.randomseed(room.mathSeed)
		local step1 = math.random(1, 3)
		if step1 == 1 then -- top barrier
			xml[#xml+1] = barriers[1][2] .. barriers[1][3]
		elseif step1 == 2 then -- mid barrier
			xml[#xml+1] = barriers[1][1] .. barriers[1][3]
		else 
			xml[#xml+1] = barriers[1][1] .. barriers[1][2]			
		end
		math.randomseed(room.mathSeed * step1); math.randomseed(room.mathSeed * step1 * math.random())
		local step3 = math.random(1, #allowedPaths[step1])
		for i = 1, 4 do 
			if not table.contains(allowedPaths[step1][step3], i) then 
				xml[#xml+1] = barriers[2][i]
			end
		end		
		math.randomseed(os.time())

		aps2[#aps2+1] = '170f0b9e5b1.png,1,0,7670,1765,1200,0,7625;'
	TFM.newGame(([[
		<C>
			<P F="0" mc="" dodue="" APS="]] .. table.concat(aps2) .. aps .. [[" Ca="" L="27000" H="13000" />
			<Z>
				<S>
					]] .. streetGrounds .. table.concat(xml2) .. table.concat(xml) .. [[<S T="12" m="" L="400" H="400" X="-75" Y="150" P="0,0,0,0,0,0,0,0" c="3"/><S L="30" m="" X="2900" N="" H="300" Y="100" T="6" P="0,0,0,0,0,0,0,0" /><S L="30" m="" X="5170" N="" H="300" Y="100" T="6" P="0,0,0,0,0,0,0,0" /><S P="0,0,0,0,0,0,0,0" L="1000" o="324650" H="386" Y="53" T="12" m="" X="1300" /><S L="248" o="324650" H="386" X="-123" Y="107" T="12" m="" P="0,0,0,0,0,0,0,0" />

				</S>
				<D>
					<F Y="-100" X="-300" /><F Y="-100" X="-200" /><F Y="-100" X="-100" /><DS Y="7770" X="2155" />]] .. table.concat(spawn) .. [[
				</D>
				<O>

				</O>
			</Z>
		</C>
	]]):gsub("[\n\r\t]+", ""))
	startRoom()
end

--[[ map/lobby.lua ]]--
genLobby = function()
	room.isInLobby = true
	TFM.newGame('<C><P Ca="" /><Z><S><S L="800" m="" X="400" H="35" Y="382" T="6" P="0,0,0.3,0.2,0,0,0,0" /><S P="0,0,0,0,0,0,0,0" L="10" o="0" X="-6" Y="222" T="12" H="547" /><S L="10" o="0" X="808" H="547" Y="258" T="12" P="0,0,0,0,0,0,0,0" /><S P="0,0,0,0,0,0,0,0" L="800" o="0" H="10" Y="-6" T="12" X="401" /></S><D><DS Y="353" X="400" /></D><O /></Z></C>')
	room.started = false
	startRoom()
	removeTimer(room.temporaryTimer)
	room.temporaryTimer = addTimer(function(j)
		for i in next, ROOM.playerList do
			ui.addTextArea(0, "<p align='center'><font size='20'><CE>".. translate('waitingForPlayers', i) .." <br>"..ROOM.uniquePlayers.."/"..room.requiredPlayers.."</font></p>", i, 0, 35, 800, nil, 1, 1, 0.3)
			local lang = players[i].lang
			local tip = tips[lang] and tips[lang][math.random(1, #tips[lang])] or tips['EN'][math.random(1, #tips['EN'])]
			ui.addTextArea(1, "<p align='center'><i><CS>"..tip.."</p>", i, 0, 105, 800, nil, 1, 1, 0.3)
		end
	end, 5000, 0)
end

--[[ map/loadMap.lua ]]--
loadMap = function(name) -- TO REWRITE
	if room.bankBeingRobbed and players[name].driving then return end
	ui.addTextArea(1028, '<font size="15"><p align="center"><a href="event:enter_buildshop">' .. translate('goTo', name) .. '\n</a>', name, 440, 1600+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	ui.addTextArea(1021, '<font size="15"><p align="center"><a href="event:enter_police">' .. translate('goTo', name) .. '\n</a>', name, 990, 1600+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	ui.addTextArea(1022, '<font size="15"><p align="center"><a href="event:enter_market">' .. translate('goTo', name) .. '\n</a>', name, 3445, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	ui.addTextArea(1025, '<font size="15"><p align="center"><a href="event:enter_hospital">' .. translate('goTo', name) .. '\n</a>', name, 4675, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	ui.addTextArea(1027, '<font size="19"><p align="center"><a href="event:enter_dealership">' .. translate('goTo', name) .. '\n</a>', name, 4960, 1775+room.y+11, 310, 40, 0x122528, 0x122528, 0.7)
	ui.addTextArea(1023, '<p align="center"><font color="#E8E8E8"><b>SODA', name, 4459, 138, 65, nil, 0x1, 0x1, 0)
	ui.addTextArea(1033, "<textformat leftmargin='1' rightmargin='1'><a href='event:upgradeBag'>" .. string.rep('\n', 15), name, 4545, 140, 40, 110, 0x122528, 0x122528, 0)
	ui.addTextArea(1024, '<font size="5" color="#ff0000"><b><p align="center"><a href="event:BUY_1">--------', name, 4463, 186, 15, nil, 0x1, 0x1, 0)
	ui.addTextArea(1035, "<textformat leftmargin='1' rightmargin='1'><a href='event:BUY_salt'>" .. string.rep('\n', 3), name, 4600, 190, 40, 20, 0x122528, 0x122528, 0)
	ui.addTextArea(1018, "<textformat leftmargin='1' rightmargin='1'><a href='event:BUY_cornFlakes'>" .. string.rep('\n', 15), name, 4130, 140, 130, 40, 0x122528, 0x122528, 0)
	ui.addTextArea(459, '<font size="15"><p align="center"><a href="event:joinHouse_11">' .. translate('goTo', name) .. '\n</a>', name, 11177, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)	
	ui.addTextArea(458, '<font size="15"><p align="center"><a href="event:joinHouse_10">' .. translate('goTo', name) .. '\n</a>', name, 10027, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)	

	ui.addTextArea(1039, "<textformat leftmargin='1' rightmargin='1'><a href='event:BUY_sugar'>" .. string.rep('\n', 15), name, 4608, 220, 90, 30, 0x122528, 0x122528, 0)
	ui.addTextArea(1049, "<textformat leftmargin='1' rightmargin='1'><a href='event:BUY_chocolate'>" .. string.rep('\n', 15), name, 4600, 140, 40, 40, 0x122528, 0x122528, 0)
	ui.addTextArea(1051, '<font size="19"><p align="center"><a href="event:enter_fishShop">' .. translate('goTo', name) .. '\n</a>', name, 5868, 7615, 200, 30, 0x122528, 0x122528, 0.7)

	if room.bankBeingRobbed then
		ui.addTextArea(1029, '<font size="15" color="#FF0000"><p align="center">' .. translate('robberyInProgress', name) .. '\n</a>', name, 2670, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	else
		ui.addTextArea(1029, '<font size="15"><p align="center"><a href="event:enter_bank">' .. translate('goTo', name) .. '\n</a>', name, 2670, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	end

	ui.addTextArea(-24, '<a href="event:BUY_milk">' .. string.rep('\n', 4), name, 4218, 212, 60, 35, 1, 1, 0)
	ui.addTextArea(1026, '<font size="15"><p align="center"><a href="event:enter_cafe">' .. translate('goTo', name) .. '\n</a>', name, 10950+300, 8750, 200, 30, 0x122528, 0x122528, 0.7)
	if players[name].questStep[1] > 1 then
		ui.addTextArea(1052, string.rep('\n', 10), name, 1900, 8820, 36, 192, 0, 0, 0.7, false, 
			function(player)
				if players[player].place ~= 'mine_labyrinth' then return end
				showBoatShop(player, 1)
				players[player].place = 'boatShop'
				TFM.movePlayer(player, 1455, 9300, false)
				ui.addTextArea(1053, string.rep('\n', 10), player, 1425, 9125, 50, 200, 0, 0, 0, false, 
					function(player)
						players[player].place = 'mine_labyrinth'
						setNightMode(player)
						TFM.movePlayer(player, 1918, 8820, false)
					end)
			end)
		ui.addTextArea(1036, '<font size="19"><p align="center"><a href="event:enter_furnitureStore">' .. translate('goTo', name) .. '\n</a>', name, 5622, 7615, 200, 30, 0x122528, 0x122528, 0.7)
	else
		ui.addTextArea(1036, '<font size="10"><r>' .. translate('enterQuestPlace', name):format(translate('req_1', name)), name, 5622, 7615, 200, 30, 0x122528, 0x122528, 0.7)
	end
	if players[name].questStep[1] > 2 then
		ui.addTextArea(1031, '<font size="15"><p align="center"><a href="event:enter_potionShop">' .. translate('goTo', name) .. '\n</a>', name, 9730, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	else
		ui.addTextArea(1031, '<font size="10"><r>' .. translate('enterQuestPlace', name):format(translate('req_2', name)), name, 9730, 1800+room.y, 200, nil, 0x122528, 0x122528, 0.7)
	end
	if players[name].questStep[1] > 3 then
		ui.addTextArea(1026, '<font size="15"><p align="center"><a href="event:enter_cafe">' .. translate('goTo', name) .. '\n</a>', name, 10300, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
		ui.addTextArea(-33, "<textformat leftmargin='1' rightmargin='1'><a href='event:NPC_coffeeShop'>" .. string.rep('\n', 10), name, 6835, 80, 205, 42, 1, 1, 0)
	else
		ui.addTextArea(1026, '<font size="10"><r>' .. translate('enterQuestPlace', name):format(translate('req_3', name)), name, 10300, 1800+room.y, 200, nil, 0x122528, 0x122528, 0.7)
	end
	if players[name].questStep[1] > 4 then
		ui.addTextArea(1032, '<font size="15"><p align="center"><a href="event:enter_pizzeria">' .. translate('goTo', name) .. '\n</a>', name, 4310, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
	else
		ui.addTextArea(1032, '<font size="10"><r>'.. translate('enterQuestPlace', name):format(translate('req_4', name)), name, 4310, 1800+room.y, 200, nil, 0x122528, 0x122528, 0.7)
	end
	ui.addTextArea(1034, '<font size="19"><p align="center"><a href="event:enter_seedStore">' .. translate('goTo', name), name, 11858, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.7)
end

--[[ recipeSystem.lua ]]--
newFoodValue = function(recipe)
	local newValue = 0
	local ingredients = 0
	local spiceList = {
		pepper = 0.12,
	}

	for i, v in next, recipes[recipe].require do 
		local item = bagItems[i]
		if not item.hunger then 
			item.hunger = (not recipes[i] and 0.11 or math.floor(newFoodValue(i)))
		end 
		newValue = newValue + (item.hunger >= 0 and item.hunger or (i:find('fish') and math.abs(item.hunger)/1.62 or spiceList[i] and spiceList[i] or 0.57)) * v
		ingredients = ingredients + 1
	end
	bagItems[recipe].hunger = math.floor((ingredients/1.025) * newValue)
	return bagItems[recipe].hunger
end

newEnergyValue = function(recipe)
	local recipeHunger = bagItems[recipe].hunger
	local newValue = 0
	local ingredients = 0
	local spiceList = {
		pepper = 1.49,
		oregano = 1.09,
		lemon = 1.11,
		salt = 1.32,
		tomato = 1.32,
		garlic = 1.42,
	}

	for i, v in next, recipes[recipe].require do 
		local item = bagItems[i]
		if not item.power then 
			item.power = (not recipes[i] and 1.03 or math.floor(newEnergyValue(i)))
		end 
		newValue = newValue + ((item.power >= 0 and not spiceList[i]) and item.power*1.1 or (i:find('fish') and math.abs(item.power)/2.12 or spiceList[i] and spiceList[i] or 0.30)) * v
		ingredients = ingredients + 1
	end
	bagItems[recipe].power = math.floor((ingredients/0.971) * newValue/2)
	return bagItems[recipe].power
end

newDishPrice = function(recipe)
	local price = 100
	for i, v in next, recipes[recipe].require do 
		local item = bagItems[i]
		if item.price then 
			price = price + item.price 
		else 
			price = price + 10
		end
	end
	bagItems[recipe].orderValue = math.floor(price + price/4)
	return bagItems[recipe].orderValue
end

--[[ init.lua ]]--
startRoom = function()
	if not room.isInLobby then
		room.terrains = {}
		room.houseImgs = {}
		players = {}
		room.gameLoadedTimes = room.gameLoadedTimes + 1
		
		for i = 1, #mainAssets.__terrainsPositions do
			room.terrains[i] = {img = {}, bought = false, owner = nil, settings = {}, groundsLoadedTo = {}, guests = {}}
			room.houseImgs[i] = {img = {}, furnitures = {}, expansions = {}}
		end
		room.started = true

		for name in next, ROOM.playerList do 
			eventNewPlayer(name)
		end

		eventNewPlayer('Oliver')
		eventNewPlayer('Remi')

		removeTimer(room.temporaryTimer)
		if room.gameLoadedTimes == 1 then 
			for i = 1, 2 do 
				gameNpcs.setOrder(table.randomKey(gameNpcs.orders.canOrder))
			end

			addTimer(function()
				for i, v in next, ROOM.playerList do
					updateBarLife(i)
				end
			end, 60000, 0)
		end
	else
		players = {}
		for name in next, ROOM.playerList do 
			eventNewPlayer(name)
		end
	end
end

for i, v in next, recipes do
	newFoodValue(i)
	newEnergyValue(i)
	newDishPrice(i)
end


npcsStores.items = mergeItemsWithFurnitures(mainAssets.__furnitures, bagIds)
buildNpcsShopItems()

for item, data in next, Mine.ores do 
	bagItems['crystal_'..item].price = math.floor(200*(12/data.rarity))
end

if ROOM.name == "*#fofinho" or ROOM.community == 'sk' then
	room.requiredPlayers = 0
else
	TFM.setRoomPassword('')
	for player in next, ROOM.playerList do
		if ROOM.name:sub(1,1) == '*' and ROOM.name:find(player) then 
			system.bindMouse(player, true)
			room.requiredPlayers = 0
			TFM.setRoomMaxPlayers(1)
			TFM.setRoomPassword('blankRoom')
			TFM.chatMessage('You can teleport in this room!!!1', player)
		end
	end
end
TFM.setRoomMaxPlayers(room.maxPlayers)
system.loadFile(1)

local lastFile = 1
addTimer(function()
	if lastFile == 5 then
		if room.fileUpdated then
			syncFiles()
			room.fileUpdated = false
		else
			system.loadFile(1)
		end
		lastFile = 1
	elseif lastFile == 1 then
		system.loadFile(5)
		lastFile = 5
	end
end, 70000, 0)

mine_generate()

if ROOM.uniquePlayers >= room.requiredPlayers then
	genMap()
else
	genLobby()
end

local syncTimer = system.newTimer(function()
	if tonumber(os.date('%S'))%10 == 0 then
		system.loadPlayerData('Sharpiebot#0000')
	end
end, 1000, true)