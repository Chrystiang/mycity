setPlayerData = function(player)
	local playerLanguage = ROOM.playerList[player] and lang[ROOM.playerList[player].community] and ROOM.playerList[player].community or 'en'
	players[player] = {
		coins		= 0,
		spentCoins	= 0,
		mouseSize	= 1,
		isFrozen	= false,
		isBlind 	= false,
		level		= {1, 0},
		starIcons 	= {owned = {1}, selected = 1},
		badges		= {},
		jobs		= {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		--------- TRADE ---------
		isTrading 	= false,
		wishList 	= {},
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
				storage = {{}, {}, {}},
				position= {{}, {}, {}},
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
			chest = {0, 0, 0, 0},
		},
		selectedItem = {name = nil, image = nil, images = {}},
		bagLimit	= 20,
		holdingItem = false,
		holdingImage = nil,
		holdingDirection = nil,
		---------- QUESTS ----------
		questLocalData = {images = {}, other = {}, step = 1},
		questStep	= {1, 0},
		sideQuests	= {1, 0, 0, 0, 0, 0}, -- current quest, progress, completed side quests, QP$, When Skipped, Skipped Quest
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
		inRoom 			= false,
	}

	if player == 'Oliver' then
		players[player].lastCallback.when = 0
		players[player].houseTerrain = {2, 2, 2, 2}
		players[player].houseTerrainAdd = {2, 2, 2, 2}
		players[player].houseTerrainPlants = {6, 6, 6, 6}
		players[player].houseData.furnitures.placed = {[1] = {y = 656,x = 958,type = 46},[2] = {y = 656,x = 1036,type = 46},[3] = {y = 656,x = 1114,type = 46},[4] = {y = 656,x = 1192,type = 46},[5] = {y = 656,x = 1270,type = 46},[6] = {y = 656,x = 1348,type = 46},[7] = {y = 656,x = 1426,type = 46},[8] = {y = 670,x = 34,type = 12},[9] = {y = 670,x = 120,type = 12},[10] = {y = 632,x = 96,type = 12},[11] = {y = 676,x = 218,type = 9},[12] = {y = 609,x = 127,type = 32},[13] = {y = 657,x = 1334,type = 3},[14] = {y = 654,x = 1140,type = 30},[15] = {y = 655,x = 1456,type = 30},[16] = {y = 574,x = 971,type = 31},[17] = {y = 656,x = 802,type = 46},[18] = {y = 657,x = 880,type = 46},[19] = {y = 657,x = 724,type = 46},[20] = {y = 656,x = 646,type = 46},[21] = {y = 657,x = 568,type = 46}}
		equipHouse(player, 4, 12)
	elseif player == 'Remi' then
		players[player].lastCallback.when = 0
		players[player].houseData.furnitures.placed = {{type = 44, x = 423, y = 664}, {type = 44, x = 527, y = 664}, {type = 44, x = 632, y = 664}, {type = 44, x = 738, y = 663}, {type = 2, x = 922, y = 663}, {type = 2, x = 876, y = 663}, {type = 1, x = 967, y = 665}, {type = 2, x = 1012, y = 663}, {type = 41, x = 1201, y = 564}, {type = 45, x = 895, y = 559}, {type = 54, x = 829, y = 629}, {type = 64, x = 1232, y = 614}, {type = 64, x = 1175, y = 614}, {type = 0, x = 1123, y = 669}, {type = 0, x = 1068, y = 668}}
		equipHouse(player, 9, 11)
	end
end