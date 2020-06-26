mainAssets.__houses = {
    [1] = {
        properties = {
            price   = 7000,
            png     = '1729fd5cfd0.png',
        },
        inside = {
            image   = '172566957cc.png',
        },
        outside = {
            icon    = '1729fd367cb.png',
            axis    = {8, 4},
        },
    },
    [2] = {
        properties = {
            price   = 13000,
            png     = '16c2524d88c.png',
        },
        inside = {
            image   = '172566a7a66.png',
            grounds = function(terrainID)
                addGround(-6500+terrainID*20, 290 + (terrainID-1)*1500 + 60, 1397 + 65, {type = 12, friction = 0.3, restitution = 0.2, width = 480, height = 30})
                addGround(-6501+terrainID*20, 225 + (terrainID-1)*1500 + 60, 1397 + 200, {type = 12, friction = 0.3, restitution = 0.2, width = 350, height = 15})
                addGround(-6502+terrainID*20, 055 + (terrainID-1)*1500 + 60, 1397 + 160, {type = 12, friction = 0.3, restitution = 0.2, height = 190})
                addGround(-6503+terrainID*20, 525 + (terrainID-1)*1500 + 60, 1397 + 160, {type = 12, friction = 0.3, restitution = 0.2, height = 190})
                addGround(-6504+terrainID*20, 480 + (terrainID-1)*1500 + 60, 1397 + 310, {type = 12, friction = 0.3, restitution = 0.9, width = 105, height = 20})
            end
        },
        outside = {
            icon    = '15909c0372a.png',
            axis    = {0, 0},
        },
    },
    [3] = {
        properties = {
            price   = 10000,
            png     = '16c2525f7c5.png',
        },
        inside = {
            image   = '172566a4e82.png',
            grounds = function(terrainID)
                addGround(-6500+terrainID*20, 345 + (terrainID-1)*1500 + 60, 1397 + 307, {type = 13, friction = 0.3, restitution = 1, width = 20})
                addGround(-6501+terrainID*20, 118 + (terrainID-1)*1500 + 60, 1397 + 307, {type = 13, friction = 0.3, restitution = 1, width = 20})
                addGround(-6502+terrainID*20, 188 + (terrainID-1)*1500 + 60, 1397 + 182, {type = 12, color = 0x46474a, friction = 0.3, restitution = 0.2, width = 260})
                addGround(-6503+terrainID*20, 460 + (terrainID-1)*1500 + 60, 1397 + 170, {type = 12, color = 0x46474a, friction = 0.3, restitution = 0.2, width = 180})       
            end
        },
        outside = {
            icon    = '15ef7b94b7f.png',
            axis    = {0, -50},
        },
    },
    [4] = {
        properties = {
            price = 13000,
            png = '16c795c65e8.png',
            limitedTime = os.time{day=1, year=2020, month=1},
        },
        inside = {
            image   = '172566a23a6.png',
        },
        outside = {
            icon    = '16c7957eefd.png',
            axis    = {0, -31},
        },
    },
    [5] = { -- Halloween2019
        properties = {
            price   = 20000,
            png     = '16dd75fa5a1.png',
            limitedTime = os.time{day=11, year=2019, month=11},
        },
        inside = {
            image   = '1725669f804.png',
            grounds = function(terrainID)
                addGround(-6500+terrainID*20, 201 + (terrainID-1)*1500 + 60, 1397 + 138, {type = 12, friction = 0.3, restitution = 0.2, width = 280, height = 20})
                addGround(-6501+terrainID*20, 463 + (terrainID-1)*1500 + 60, 1397 + 138, {type = 12, friction = 0.3, restitution = 0.2, width = 130, height = 20})
                addGround(-6502+terrainID*20, 290 + (terrainID-1)*1500 + 60, 1397 + 038, {type = 12, friction = 0.3, restitution = 0.2, width = 180, height = 20})
                addGround(-6503+terrainID*20, 373 + (terrainID-1)*1500 + 60, 1397 + 307, {type = 13, friction = 0.3, restitution = 1, width = 20})
                addGround(-6504+terrainID*20, 505 + (terrainID-1)*1500 + 60, 1397 + 114, {type = 13, friction = 0.3, restitution = 1, width = 20})  
            end
        },
        outside = {
            icon    = '16dd74f0f44.png',
            axis    = {0, -32},
        },
    },
    [6] = { -- Christmas2019
        properties = {
            price = 25000,
            png = '16ee526d8a3.png',
            limitedTime = os.time{day=15, year=2020, month=1},
        },
        inside = {
            image   = '1725669cbbb.png',
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
            icon    = '16ee521a785.png',
            axis    = {0, -49},
        },
    },
    [7] = { -- Treehouse
        properties = {
            price = 50000,
            png = '1714cb5c23b.png',
        },
        inside = {
            image   = '172572b0a32.png',
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
            icon    = '1714cb20371.png',
            axis    = {0, -30},
        },
    },
    [8] = { -- Spongebob House
        properties = {
            price = 25000000,
            png = '171b4158ba5.png',
            limitedTime = os.time{day=25, year=2020, month=4},
        },
        inside = {
            image   = '17256699f73.png',
        },
        outside = {
            icon    = '171b40ef58c.png',
            axis    = {0, -49},
        },
    },
    [9] = { -- Restaurant
        properties = {
            price = 25,
            png = '1727ba2f8dd.png',
            limitedTime = os.time{day=25, year=2020, month=4},
        },
        inside = {
            image   = '1727b98abb7.png',
        },
        outside = {
            icon    = '1727ba0e8b2.png',
            axis    = {0, -35},
        },
    },
}