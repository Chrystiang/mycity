mainAssets.__cars = {
	[1] = {
		type    = 'car',
		price   = 2000,
		maxVel  = 70,
		image   = {'15b2a6174cc.png', '15b2a61ce19.png'},
		x       = -61,
		y       = -29,
		name    = 'Classic XI',
		icon    = '16ab8193788.png',
	},
	[2] = {
		type    = 'car',
		price   = 6000,
		maxVel  = 90,
		image   = {'15b4b26768c.png','15b4b270f39.png'},
		x       = -60,
		y       = -26,
		name    = 'Mini Cooper',
		icon    = '16ab8194efa.png',
	},
	[3] = {
		type    = 'car',
		price   = 10000,
		maxVel  = 120,
		image   = {'16beb25759c.png', '16beb272303.png'},
		x       = -85,
		y       = -30,
		name    = 'BMW',
		icon    = '16ab819666d.png',
	},
	[4] = {
		type    = 'car',
		price   = 15000,
		maxVel  = 150,
		image   = {'15b302ac269.png', '15b302a7102.png'},
		x       = -91,
		y       = -21,
		name    = 'Ferrari 488',
		icon    = '16ab831a98a.png',
	},
	[5] = {
		type    = 'boat',
		price   = 1000000,
		maxVel  = 50,
		image   = {'164d43b8055.png', '164d43ba0bd.png'},
		x       = -50,
		y       = -3,
		name    = 'Boat',
		icon    = '16ab82e10f6.png',
	},
	[6] = {
		type    = 'boat',
		price   = 30000,
		maxVel  = 100,
		image   = {'16bc49d0cb5.png', '16bc4a93359.png'},
		x       = -250,
		y       = -170,
		name    = 'tugShip',
		icon    = '16bc4afc305.png',
	},
	[7] = {
		type    = 'car',
		price   = 45000,
		maxVel  = 210,
		image   = {'16be76fd925.png', '16be76d2c15.png'},
		x       = -90,
		y       = -30,
		name    = 'Lamborghini',
		icon    = '16be7831a66.png',
	},
	[8] = {
		type    = 'boat',
		price  = 40000,
		maxVel = 130,
		image  = {'1716571c641.png', '171656f6573.png'},
		x      = -100,
		y      = -80,
		name   = 'motorboat',
		icon    = '1716566629c.png',
	},
	[9] = { -- Sleigh
		type    = 'car',
		price   = 20000,
		maxVel  = 90,
		image   = {'16f1a649b5e.png', '16f1a683125.png'},
		x       = -60,
		y       = -25,
		name    = 'Sleigh',
		icon    = '16f1fd0857f.png',
		effects = function(player)
					if math.random() < 0.5 then
						TFM.movePlayer(player, 0, 0, true, 0, -50, false)
					end
				end,
	},
	[11] = {
		type    = 'boat',
		price  = 500000,
		maxVel = 200,
		image  = {'1716aa827f8.png', '1716a699fd4.png'},
		x      = -400,
		y      = -50,
		name   = 'yatch',
		icon    = '171658e5be2.png',
	},
	[12] = { -- Bugatti
		type    = 'car',
		price   = 500000,
		maxVel  = 400,
		image   = {'16eccf772fe.png', '16eccf74fae.png'},
		x       = -90,
		y       = -27,
		name    = 'Bugatti',
		icon    = '16eccfc33a2.png',
		effects = function(player)
					local lights = {'16ecd112e05.png', '16ecd116c89.png', '16ecd118bc9.png', '16ecd125468.png', '16ecd125468.png', '16ecd13a260.png'}
					player_removeImages(players[player].carLeds)
					players[player].carLeds[#players[player].carLeds+1] = addImage(lights[math.random(#lights)], '$'..player, -130, -20)
				end,
	},
	[13] = {
		type    = 'car',
		price   = 1000000000,
		maxVel  = 210,
		image   = {'16beb3ebb56.png', '16beb3e7f19.png'},
		x       = -90,
		y       = -30,
		name    = 'Green Lamborghini',
		icon    = '1733b04eb29.png',
	},
	[14] = {
		type    = 'car',
		price   = 1000000000,
		maxVel  = 500,
		image   = {'173d50d7ad9.png', '173d50d525c.png'},
		x       = -100,
		y       = -35,
		name    = 'Koenigsegg Agera',
		icon    = '173d50d2a11.png',
		effects = function(player)
					local lights = {'16ecd112e05.png', '16ecd116c89.png', '16ecd118bc9.png', '16ecd125468.png', '16ecd125468.png', '16ecd13a260.png'}
					player_removeImages(players[player].carLeds)
					local light = lights[math.random(#lights)]
					players[player].carLeds[#players[player].carLeds+1] = addImage(light, '$'..player, -145, -25)
					players[player].carLeds[#players[player].carLeds+1] = addImage(light, '$'..player, -145, -25)
				end,
	},
}