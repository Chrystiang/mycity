codesIds = {
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

codes = {
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