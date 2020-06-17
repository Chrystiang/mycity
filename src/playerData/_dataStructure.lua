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