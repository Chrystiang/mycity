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

local bagIds, bagItems, recipes, modernUI, HouseSystem, _QuestControlCenter

local chatCommands  = {}
local Mine          = {}
local grid          = {}
local grid_width    = 10
local grid_height   = 01
local groundIDS     = {}
local players       = {}

local maxFurnitureStorage   = 50
local maxFurnitureDepot     = 60

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
    maxPlayers      = 12,
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
    season = 1,
    roles = {
        admin = {},
        mod = {},
        helper = {},
    },
    supportedCommunity = {'en', 'br', 'es', 'ar', 'tr', 'hu', 'pl', 'ru', 'fr', 'e2', 'sk'},
    housePermissions = {
        [-1] = 'blocked',
        [0] = 'guest',
        [1] = 'roommate',
        [2] = 'coowner',
        [3] = 'owner',
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
            addGround(- 2000 - (terrainID-1)*30 - plotID, (terrainID-1)*1500+737 + (plotID-1)*175, y+170, {type = 14, width = 175, height = 90, friction = 0.3})
            room.houseImgs[terrainID].expansions[#room.houseImgs[terrainID].expansions+1] = addImage('16bce83f116.jpg', '?1', (terrainID-1)*1500+738-(175/2) + (plotID-1)*175, y+170-45, guest)
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
            addGround(- 2000 - (terrainID-1)*30 - plotID, (terrainID-1)*1500+737 + (plotID-1)*175, y+170, {type = 14, width = 175, height = 90, friction = 0.3})
            if players[owner].houseTerrainPlants[plotID] == 0 then players[owner].houseTerrainPlants[plotID] = 1 end
            local stage = houseTerrainsAdd.plants[players[owner].houseTerrainPlants[plotID]].stages[players[owner].houseTerrainAdd[plotID]]
            room.houseImgs[terrainID].expansions[#room.houseImgs[terrainID].expansions+1] = addImage('16bf5b9e800.jpg', '?1', (terrainID-1)*1500+738-(175/2) + (plotID-1)*175, y+170-45, guest)
            room.houseImgs[terrainID].expansions[#room.houseImgs[terrainID].expansions+1] = addImage(stage, '!2', (terrainID-1)*1500+738-(175/2) + (plotID-1)*175, y+170-45-280, guest)
            if owner == 'Oliver' then 
                room.houseImgs[terrainID].expansions[#room.houseImgs[terrainID].expansions+1] = addImage(stage, '?10', 11330 + (plotID-1)*65, 7470+30, guest)
            end
        end,
    },
}
local badges        = {
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
local places        = {
    market = {
        opened  = '08:00 21:00',
        tp      = {3600, 250},
        town_tp = {3473, 7770},
        saida   = {{3300, 3500}, {0, 300}},
        saidaF  = function(player)
            TFM.movePlayer(player, 3473, 7770, false)
            players[player].place = 'town'
            return true
        end
    },
    hospital = {
        opened = '-',
        tp      = {4600, 3650},
        saida   = {{4650, 4800}, {3400, 3700}},
        saidaF  = function(player)
            TFM.movePlayer(player, 4850, 7770, false)
            players[player].place = 'town'
            showOptions(player)
            return true
        end
    },
    police = {
        opened  = '-',
        tp      = {220+7100, 265+5950},
        saida   = {{7130, 7300}, {6116, 6230}},
        saidaF  = function(player)
            TFM.movePlayer(player, 1090, 7570, false)
            players[player].place = 'town'
            return true
        end
    },
    buildshop = {
        opened  = '08:00 19:00',
        tp      = {200, 250},
        town_tp = {495, 7570},
        saida   = {{0, 180}, {50, 300}},
        saidaF  = function(player)
            TFM.movePlayer(player, 495, 7570, false)
            players[player].place = 'town'
            return true
        end,
    },
    dealership = {
        opened  = '07:00 19:00',
        tp      = {8710, 240},
        town_tp = {5400, 7770},
        saida   = {{8000, 8680}, {0, 300}},
        saidaF  = function(player)
            TFM.movePlayer(player, 5000, 7770, false)
            players[player].place = 'town'
            return true
        end
    },
    bank = {
        opened  = '07:00 19:00',
        tp      = {5538, 5238},
        town_tp = {2775, 7770},
        clickDistance = {{5460, 5615}, {5100, 5250}},
        saida   = {{5273, 6012}, {5100, 5250}},
        saidaF  = function(player)
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
        opened  = '-',
        tp      = {14200, 250},
        town_tp = {4410, 7770},
        saida   = {{14000, 14150}, {50, 300}},
        saidaF  = function(player)
            TFM.movePlayer(player, 4410, 7770, false)
            players[player].place = 'town'
            return true
        end,
    },
    fishShop = {
        opened  = '-',
        tp      = {12700, 250},
        town_tp = {6030, 7770},
        saida   = {{12600, 12695}, {50, 300}},
        saidaF  = function(player)
            TFM.movePlayer(player, 6030, 7770, false)
            players[player].place = 'town'
            return true
        end,
    },
    furnitureStore = {
        opened = '08:00 19:00',
        tp      = {16150, 248},
        town_tp = {5770, 7770},
        saida   = {{16000, 16100}, {100, 250}},
        saidaF  = function(player)
            TFM.movePlayer(player, 5770, 7770, false)
            players[player].place = 'town'
            return true
        end,
    },
    town = {
        opened  = '-',
        saida   = {{0, 1649}, {7600, 7800}},
        saidaF  = function(player)
            players[player].place = 'mine'
            checkIfPlayerIsDriving(player)
            if players[player].questLocalData.other.goToMine then
                quest_updateStep(player)
            end
            return true
        end
    },
    mine = {
        opened  = '-',
        saida   = {{995, 6000}, {7600, 8670}},
        saidaF  = function(player)
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
        opened  = '-',
        saida   = {{1100, 1200}, {8490, 8670}},
        saidaF  = function(player)
            players[player].place = 'mine'
            TFM.movePlayer(player, 990, 8632, false)
            showOptions(player)
            return true
        end
    },
    mine_escavation = {
        opened = '-',
        saida   = {{5355, 5470}, {7830, 8200}},
        saidaF  = function(player)
            players[player].place = 'town'
            TFM.movePlayer(player, 5415, 7770, false)
        end
    },
    --- island
    cafe = {
        opened  = '-',
        tp      = {6150, 250},
        saida   = {{6000, 6140}, {50, 300}},
        saidaF  = function(player)
            TFM.movePlayer(player, 10470, 7770, false)
            players[player].place = 'island'
            return true
        end,
    },
    potionShop = {
        opened = '11:00 19:00',
        tp      = {10620, 248},
        island_tp = {9895, 7770},
        saida   = {{10500, 10615}, {100, 250}},
        saidaF  = function(player)
            TFM.movePlayer(player, 9895, 7770, false)
            players[player].place = 'island'
            return true
        end,
    },
    seedStore = {
        opened = '10:00 19:00',
        tp      = {11500, 248},
        island_tp = {12000, 7770},
        saida   = {{11350, 11460}, {100, 250}},
        saidaF  = function(player)
            TFM.movePlayer(player, 12000, 7770, false)
            players[player].place = 'island'
            return true
        end,
    },
}
local jobs          = {}

local version = {3, 0, 1}
local versionLogs = {
    ['v3.0.1'] = {
        releaseDate = '12/06/2020', -- dd/mm/yy
        maxPages = 1,
        images = {'172a97d8145.png'},
        br = {
            name = 'A nova atualização chegou!',
            _1 = '<rose>Novo:</rose> Mapa redesenhado!\n\n<rose>Novos lugares:</rose> Restaurante, Loja de barcos e Loja de pesca!\n\n<rose>Novo trabalho:</rose> Cozinheiro!\nFale com Remi e comece a fazer pratos deliciosos!\n\n<rose>Nova mina:</rose> Novas áreas: labirinto, esgoto e zona de escavação!\nAdicionado um novo sistema de mineração.\n\nE muito mais!',
        },
        en = {
            name = 'Our newest update is here!',
            _1 = '<rose>New:</rose> Map update!\n\n<rose>New places:</rose> Restaurant, Boat shop and Fish shop!\n\n<rose>New job:</rose> Chef!\nTalk with Remi and start cooking delicious dishes!\n\n<rose>New mine:</rose> New places: labyrinth, sewer, and excavation area!\nAdded a new mining system.\n\nAnd a lot more!'
        },
        hu = {
            name = 'Itt a legújabb frissítésünk!',
            _1 = '<rose>Új:</rose> Pálya frissítés!\n\n<rose>Új helyek:</rose> Étterem, Hajóbolt és Halbolt!\n\n<rose>Új munka:</rose> Séf!\nBeszélj Remi-vel és kezdj el finom ételeket főzni!\n\n<rose> Új helyek: labirintus, szennyvízcsatorna, és ásatási terület!\nHozzáadva egy új bányászati rendszer.\n\nÉs még sok más!'
        },
        fr = {
             name = 'Notre dernière mise à jour est arrivée!',
             _1 = '<rose>Nouveauté:</rose> Mise à jour de la carte!\n\n<rose>Nouveaux lieux:</rose> Restaurant, Boutique de bâteaux and Poissonnerie!\n\n<rose>Nouveau métier:</rose> Chef!\nParlez avec Remi et commencez à cuisiner de délicieux plats!\n\n<rose>Nouvelle mine:</rose> Nouveaux lieux: labyrinthe, égouts, et zone d\'excavation!\nAjout d\'un nouveau système de minage.\n\nEt bien plus!'
        },
        he = {
            name = 'העדכון הכי חדש שלנו כאן!',
            _1 = '<rose>חדש:</rose> עדכון מפה!\n\n<rose>מקומות חדשים:</rose> מסעדה, חנות סירות וחנות דגים!\n\n<rose>עבודה חדשה:</rose> שף!\nדברו עם רמי והתחילו לבשל מאכלים טעימים!\n\n<rose>מכרה חדש:</rose> מקומות חדשים: לבירינת, ביוב, ואיזור חפירה!\nנוספה מערכת חציבה חדשה.\n\nועוד הרבה יותר!'
        },
        tr = {
            name = 'Yeni güncellememiz çıktı!',
            _1 = '<rose>Yeni:</rose> Harita güncellemesi!\n\n<rose>Yeni mekanlar:</rose> Restorant, Tekne dükkanı ve Balık dükkanı!\n\n<rose>Yeni meslek:</rose> Şef!\nRemi ile konuş ve şahane yiyecekler pişir!\n\n<rose>Yeni maden:</rose> Yeni mekanlar: labirent, lağım ve kazı alanı!\nYeni madencilik sistemi eklendi.\n\nVe çok daha fazlası!'
        },
        ar = {
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