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
local version       = {3, 1, 0}
local TFM           = tfm.exec
local ROOM          = tfm.get.room
local string        = string
local math          = math
local table         = table
local gsub          = string.gsub

local addGround     = TFM.addPhysicObject
local removeGround  = TFM.removePhysicObject
local addTextArea   = ui.addTextArea
local move          = TFM.movePlayer

local addImage      = TFM.addImage
local removeImage   = TFM.removeImage

local bagIds, bagItems, recipes, modernUI, HouseSystem, _QuestControlCenter, places, sideQuests, versionLogs
local codes, codesIds, community, badges, bagUpgrades

local chatCommands  = {}
local Mine          = {}
local grid          = {}
local grid_width    = 10
local grid_height   =  1
local groundIDS     = {}
local players       = {}
local jobs          = {}

local maxFurnitureStorage   = 50
local maxFurnitureDepot     = 60
local questsAvailable       =  5

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

local room = { -- Assets that change while the script runs
	maxPlayers      = 15,
	gameLoadedTimes = 0,
	fileUpdated     = false,
	dayCounter      = 0,
	mathSeed        = os.date("%j"),
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
	event           = nil,
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
}

local mainAssets = { -- Assets that rarely changes while the script runs
	season = 3,
	fileCopy = {
		_ranking = 'Xzowtx#0000, Saugha#0000, Okxyautumn#8940, Emirfaresi#0000, Luquinhas#3157, Q_lt#0000, Brunadrr#0000, Kb65#0000, Kjbondetomjk#0000, Ratagominha#0000,',
	},
	roles = {
		admin = {},
		mod = {},
		helper = {},
	},
	supportedCommunity = {'en', 'br', 'es', 'ar', 'tr', 'hu', 'pl', 'ru', 'fr', 'e2', 'sk'},
	housePermissions = {
		[-1] = 'blocked',
		[ 0] = 'guest',
		[ 1] = 'roommate',
		[ 2] = 'coowner',
		[ 3] = 'owner',
	},
	levelIcons = {
		star = {
			'1733a811072.png',
			'1733a815fb4.png',
			'1733a815fb4.png',
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
		translations = {['Bodykudo#0000'] = 'ar', ['Chamelinct#0000'] = 'es', ['Zielony_olii#8526'] = 'pl', ['Melikefn#0000'] = 'tr', ['Danielthemouse#6206'] = 'il', ['Francio2582#3155'] = 'fr', ['Godzi#0941'] = 'pl', ['Noooooooorr#0000'] = 'ar', ['Tocutoeltuco#0000'] = 'es', ['Weth#9837'] = 'hu', ['Zigwin#0000'] = 'ru'},
		arts = {'Iho#5679', 'Kariina#0000', 'Mescouleur#0000'},
		creator = {'Fofinhoppp#0000'},
		help = {'Bolodefchoco#0000', 'Laagaadoo#0000', 'Lucasrslv#0000', 'Tocutoeltuco#0000'},
	},
}

local syncData = {
	connected = false,
	players   = {},
	quests    = {
		newQuestDevelopmentStage = 60,
	},
	updating  = {
		isUpdating    = false,
		updateMessage = '',
	},
}

local imgsToLoad = {'1721ee7d5b9.png', '17184484e6b.png', '1718435fa5c.png', '171843a9f21.png', '171d2134def.png', '171d20cca72.png', '171d1f8d911.png', '171d21cd12d.png', '171d1e559be.png', '171d20548bd.png', '171d1933add.png', '1717aae387a.jpg', '1717a86b38f.png', '171d2a2e21a.png', '171d28150ea.png', '171d6f313c8.png',}

local npcsStores = {
	items = {},
	shops = {
		marcus = {}, chrystian = {}, jason = {}, john = {}, indy = {}, kariina = {}, body = {}, lucas = {}, iho = {}, all = {},
	},
}

local dialogs = {}
local npcDialogs = {
	normal = {},
	quests = {},
}