mainAssets.__houses = {
	[1] = {
		properties = {
			price   = 2000,
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
			price   = 7000,
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
			limitedTime = os_time{day=1, year=2020, month=1},
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
			limitedTime = os_time{day=11, year=2019, month=11},
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
			limitedTime = os_time{day=15, year=2020, month=1},
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
	[8] = { -- Modern House
		properties = {
			price = 100000,
			png = '174129c8f60.png',
		},
		inside = {
			image   = '17460703d0c.png',
			grounds = function(terrainID)
				addGround(-6500+terrainID*20, 76 + (terrainID-1)*1500 + 60, 1397 -550 + 706, {type = 12, color = 0xb8947c, height = 22, width = 150, friction = 0.3, restitution = 0.2})
				addGround(-6501+terrainID*20, 400 + (terrainID-1)*1500 + 60, 1397 -550 + 706, {type = 12, color = 0xb8947c, height = 22, width = 360, friction = 0.3, restitution = 0.2})
				addGround(-6502+terrainID*20, 202 + (terrainID-1)*1500 + 60, 1396, {type = 12, color = 0xb8947c, height = 24, width = 295, friction = 0.3})
				addGround(-6503+terrainID*20, 470 + (terrainID-1)*1500 + 60, 1396 , {type = 12, color = 0xb8947c, height = 24, width = 115, friction = 0.3})
				addGround(-6504+terrainID*20, 180 + (terrainID-1)*1500 + 60, 1397 -550 + 390, {type = 12, color = 0xb8947c, height = 24, width = 332, friction = 0.3})
				addGround(-6505+terrainID*20, 493 + (terrainID-1)*1500 + 60, 1397 -550 + 390, {type = 12, color = 0xb8947c, height = 24, width = 156, friction = 0.3})
				addGround(-6506+terrainID*20, 353 + (terrainID-1)*1500 + 60, 1397 -550 + 346-158, {type = 14, height = 15, width = 200, angle = 45})
				addGround(-6507+terrainID*20, 223 + (terrainID-1)*1500 + 60, 1397 -550 + 346-158, {type = 14, height = 15, width = 200, angle = -45})
				addGround(-6508+terrainID*20, 186 + (terrainID-1)*1500 + 60, 1397 -550 + 866, {type = 12, color = 0xb8947c, height = 10, width = 74, friction = 0.3, restitution = 1.2})
				addGround(-6509+terrainID*20, 381 + (terrainID-1)*1500 + 60, 1397 -550 + 692, {type = 12, color = 0xb8947c, height = 10, width = 72, friction = 0.3, restitution = 1.2})
				addGround(-6510+terrainID*20, 530 + (terrainID-1)*1500 + 60, 1396, {type = 14, color = 0xb8947c, height = 320, friction = 0.3, restitution = 0.2})
				addGround(-6511+terrainID*20,  52 + (terrainID-1)*1500 + 60, 1396, {type = 14, color = 0xb8947c, height = 320, friction = 0.3, restitution = 0.2})
				addGround(-6512+terrainID*20, 153 + (terrainID-1)*1500 + 60, 1397 -550 + 322, {type = 14, height = 148, width = 10, friction = 0.3})
				addGround(-6513+terrainID*20, 423 + (terrainID-1)*1500 + 60, 1397 -550 + 322, {type = 14, height = 148, width = 10, friction = 0.3})
			end
		},
		outside = {
			icon	= '174129a5ee3.png',
			axis	= {0, -28},
		},
	},
	[9] = { -- Restaurant
		properties = {
			price = 25,
			png = '1727ba2f8dd.png',
			limitedTime = os_time{day=25, year=2020, month=4},
		},
		inside = {
			image   = '174085c9366.png',
		},
		outside = {
			icon    = '1727ba0e8b2.png',
			axis    = {0, -50},
		},
	},
	[10] = { -- Pumpkin House
		properties = {
			price = 100000000,
			png = '1750410633b.png',
			limitedTime = os_time{day=16, year=2019, month=11},
		},
		inside = {
			image   = '',
		},
		outside = {
			icon    = '17503e6b5ac.png',
			axis    = {0, -32},
		},
	},
}