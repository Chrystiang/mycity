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
end