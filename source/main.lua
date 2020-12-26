--[[
#Mycity.lua

MIT License

Copyright (c) 2020 Chrystian Gabriel

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--
local version       = {3, 4, 0}
local TFM           = tfm.exec
local ROOM          = tfm.get.room
local system 		= system

local getmetatable  = getmetatable
local ipairs 		= ipairs
local math          = math
local next         	= next
local os 			= os
local setmetatable 	= setmetatable
local string        = string
local table         = table
local tonumber     	= tonumber
local type         	= type

local ceil   		= math.ceil
local floor 		= math.floor
local gsub          = string.gsub
local os_time		= os.time
local os_date 		= os.date
local random 		= math.random
local randomseed 	= math.randomseed
local string_find 	= string.find
local table_concat 	= table.concat
local table_insert 	= table.insert
local table_remove 	= table.remove
local table_sort   	= table.sort
local table_unpack  = table.unpack

local loadFile      = system.loadFile
local loadPlayerData= system.loadPlayerData
local saveFile      = system.saveFile
local savePlayerData= system.savePlayerData

local addGround     = TFM.addPhysicObject
local addImage      = TFM.addImage
local changeSize 	= TFM.changePlayerSize
local chatMessage 	= TFM.chatMessage
local killPlayer 	= TFM.killPlayer
local lowerSyncDelay= TFM.lowerSyncDelay
local movePlayer    = TFM.movePlayer
local removeGround  = TFM.removePhysicObject
local removeImage   = TFM.removeImage
local respawnPlayer = TFM.respawnPlayer
local setPlayerLimit= TFM.setRoomMaxPlayers
local setPlayerScore= TFM.setPlayerScore

local addTextArea   = ui.addTextArea
local removeTextArea= ui.removeTextArea

local bagIds, bagItems, lootDrops, recipes, modernUI, HouseSystem, _QuestControlCenter, places, sideQuests, versionLogs
local codes, codesIds, community, badges, bagUpgrades

local chatCommands  = {}
local Mine          = {}
local grid          = {}
local grid_width    = 10
local grid_height   =  1
local groundIDS     = {}
local players       = {}
local jobs          = {}
local daveOffers 	= {}

local maxFurnitureStorage   = 65
local maxFurnitureDepot     = 75
local questsAvailable       =  5

randomseed(os_time())

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

local room = { -- Assets that change while the script runs
	gameMode 		= nil,
	maxPlayers      = 15,
	errorLogs		= {},
	gameLoadedTimes = 0,
	fileUpdated     = false,
	dayCounter      = 0,
	mathSeed        = os_date("%j"),
	unranked        = {},
	bannedPlayers   = {},
	rankingImages   = {},
	droppedItems    = {},
	terrains        = {},
	gardens         = {},
	boatShop2ndFloor= false,
	isInLobby       = true,
	requiredPlayers = 4,
	discordServerUrl= 'https://discord.gg/uvGwa2y',
	globalRanking   = {},
	event           = 'christmas2020',
	gameDayStep     = 'day',
	houseImgs       = {},
	y               = 5815,
	currentGameHour = 0,
	groundsPosition = {250, 749+250, 50},
	started         = false,
	robbing             = {
		prisonTimer = 100,
		robbingTimer = 90,
		bankRobbingTimer = 60,
	},
	temporaryTimer  = nil,
	map 			= {
		gravity = 10,
		wind 	= 0,
	},
	giftsPositions = {
		{x =   500, y =  240}, -- Jason's Workshop
		{x =  7150, y = 6085}, -- Police Station, next to sherlock
		{x =  7300, y = 5960}, -- Police Station, office
		{x =  8200, y = 6400}, -- Police Station, jail
		{x =  4980, y =  240}, -- Market
		{x = 14700, y =  240}, -- Pizzeria
		{x = 13130, y =  240}, -- Fish Shop
		{x = 17500, y = 1710}, -- Oliver's Farm, garden
		{x = 12120, y =  240}, -- Seed Store
		{x =  6480, y =  240}, -- Café
		{x = 10750, y =  240}, -- Potion Shop
		{x = 11000, y = 7770}, -- Island, next to bridge
		{x = 15970, y = 1705}, -- Remi's restaurant
		{x =   700, y = 8180}, -- Mine
		{x =  5800, y = 5235}, -- Bank
		{x =  1618, y = 8558}, -- Maze
		{x =  1979, y = 8449}, -- Maze
		{x =  2562, y = 8651}, -- Maze
		{x =  4489, y = 8644}, -- Maze
		{x =  5440, y = 8352}, -- Maze
		{x =  5844, y = 7774}, -- Town
		{x =  2664, y = 7774}, -- Town
		{x =  5812, y = 5244}, -- Bank
		{x =   538, y = 7406}, -- Town - Build Shop
		{x = 10835, y = 7620}, -- Bridge
		{x = 12000, y = 7580}, -- Island - Seed Store
		{x = 13390, y = 7464}, -- Apiary
		{x =  9962, y = 7774}, -- Island
	},
}

local mainAssets = { -- Assets that rarely changes while the script runs
	season = 7,
	gamemodes = {},
	fileCopy = {
		_ranking = 'Emirfaresi#0000 Zeldris#3874 Pandorastark#2899 Drivg#0000 Andy19#3870 Kb65#0000 Akbaba#0241 Ddayyy#0000 Gothic_girl#7500 Ratagominha#0000',
	},
	roles = {
		admin = {},
		mod = {},
		helper = {},
		moduleTeam = {},
	},
	housePermissions = {
		[-1] = 'blocked',
		[ 0] = 'guest',
		[ 1] = 'roommate',
		[ 2] = 'coowner',
		[ 3] = 'owner',
	},
	levelIcons = {
		star = {
			'17479edf863.png', -- Default
			'17479ee69ad.png', -- Season 1
			'17479ee3dbc.png', -- Season 2
			'17479ee148d.png', -- Season 3
			'17529b24a35.png', -- Season 4
			'17529b280e3.png', -- Halloween2020
			'175d27458f5.png', -- Season 5
			'1769064dc3b.png', -- Season 6
			'1769069fec5.png', -- Christmas2020
		},
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
		translations = {['Bodykudo#0000'] = 'ar', ['Chamelinct#0000'] = 'es', ['Zielony_olii#8526'] = 'pl', ['Melikefn#0000'] = 'tr', ['Danielthemouse#6206'] = 'he', ['Francio2582#3155'] = 'fr', ['Godzi#0941'] = 'pl', ['Noooooooorr#0000'] = 'ar', ['Tocutoeltuco#0000'] = 'es', ['Weth#9837'] = 'hu', ['Zigwin#0000'] = 'ru', ['Ppabcd#0000'] = 'id'},
		arts = {'Iho#5679', 'Kariina#0000', 'Mescouleur#0000'},
		creator = {'Fofinhoppp#0000'},
		help = {'Bolodefchoco#0000', 'Laagaadoo#0000', 'Lucasrslv#0000', 'Tocutoeltuco#0000'},
	},
}

local syncData = {
	connected = false,
	players   = {},
	quests    = {
		newQuestDevelopmentStage = 11,
	},
	updating  = {
		isUpdating    = false,
		updateMessage = '',
	},
}

local imgsToLoad = {'175130b40ff.png', '1721ee7d5b9.png', '17184484e6b.png', '1718435fa5c.png', '171843a9f21.png', '171d2134def.png', '171d20cca72.png', '171d1f8d911.png', '171d21cd12d.png', '171d1e559be.png', '171d20548bd.png', '171d1933add.png', '1717aae387a.jpg', '1717a86b38f.png', '171d2a2e21a.png', '171d28150ea.png', '171d6f313c8.png', '174558f6393.png', '1745588b429.png', '17455904362.png', '17455876d27.png', '1745590f162.png', '17455847e27.png', '1745591a12a.png', '1745581e99b.png', '174559244ca.png', '1745572fc55.png', '1745592d979.png', '174557c2791.png', '17455936450.png', '174557f051a.png',}

local npcsStores = {
	items = {},
	shops = {
		marcus = {}, chrystian = {}, jason = {}, john = {}, indy = {}, kariina = {}, body = {}, lucas = {}, iho = {}, alicia = {}, drekkemaus = {}, jingle = {}, all = {},
	},
}

local dialogs = {}
local npcDialogs = {
	normal = {},
	quests = {},
}