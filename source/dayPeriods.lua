loadFound = function(player, house)
	local id = tonumber(house)
	local align = room.event ~= '' and room.specialBackgrounds[room.event].align or 1919
	removeGroupImages(players[player].dayImgs)
	local img = background(nil, nil, nil, true)
	for i = 1, 3 do
		players[player].dayImgs[#players[player].dayImgs+1] = addImage(img, '?1', ((id-1)%id)*1500 - 1200 + (i-1)*align, 320, player)
	end
end

background = function(player, period, rain, getPng)
	if not period then period = room.gameDayStep end
	local png = nil
	local align = nil
	local yalign = -1000

	if not room.event or room.event == '' then
		align = 1919
		local bgColor
		if period == 'day' then
			png = '1724c10adda.jpg'
			bgColor = "#608EC6"
		elseif period == 'evening' then
			png = '1724c1daa44.jpg'
			bgColor = "#FBA676"
		elseif period == 'night' then
			png = '16baeb0ead4.jpg'
			bgColor = "#58235d"
		elseif period == 'dawn' then
			png = '16b80619ab9.jpg'
			bgColor = "#2A287b"
		end

		ui.setBackgroundColor(bgColor)
	else
		png = room.specialBackgrounds[room.event][period]
		align = room.specialBackgrounds[room.event].align
		ui.setBackgroundColor(room.specialBackgrounds[room.event].uiBackground[period])
	end

	if getPng then return png end

	removeGroupImages(players[player].background)
	players[player].background = {}

	if png then
		for i = 1, 11 do
			players[player].background[#players[player].background+1] = addImage(png, '?1', (i-1)*align, 6405, player)
			players[player].background[#players[player].background+1] = addImage(png, '?1', (i-1)*align, 0 + yalign, player)
		end
		players[player].background[#players[player].background+1] = addImage(png, '?1', 4000, 3000, player)
		players[player].background[#players[player].background+1] = addImage(png, '?1', 4000+align, 3000, player)

		for i = 1, 3 do
			players[player].background[#players[player].background+1] = addImage(png, '?1', 6700+(i-1)*align, 4830, player) -- police station
			players[player].background[#players[player].background+1] = addImage(png, '?1', 4500+(i-1)*align, 4920 + yalign, player)
			players[player].background[#players[player].background+1] = addImage(png, '?1', 8230+(i-1)*align, 3900, player)
		end
		if period == 'night' then
			players[player].background[#players[player].background+1] = addImage("16b952d1012.png", "!9999", 4500, 4920 + yalign, player)
		end
	end
end

loadDayTimeEffects = function(period)
	if period == 'night' then
		gameNpcs.hideNPC('Colt')
	elseif period == 'day' then
		gameNpcs.showNPC('Colt')
		removeGroupImages(room.bankImages)
		removeGroupImages(room.bank.paperImages)
		room.bankBeingRobbed = false
		room.bankRobStep = nil
		room.bankPassword = random(0,9) .. random(0,9) .. random(0,9) .. random(0,9)
		room.dayCounter = room.dayCounter + 1
		if room.dayCounter > 0 then 
			room.bank.paperImages = {}
			room.bank.paperCurrentPlace = random(1, #room.bank.paperPlaces)
			room.bank.paperImages[#room.bank.paperImages+1] = addImage('16bbf3aa649.png', '!1', room.bank.paperPlaces[room.bank.paperCurrentPlace].x, room.bank.paperPlaces[room.bank.paperCurrentPlace].y)
			showTextArea(-3333, '<a href="event:getVaultPassword">'..string.rep('\n', 10), nil, room.bank.paperPlaces[room.bank.paperCurrentPlace].x, room.bank.paperPlaces[room.bank.paperCurrentPlace].y, 20, 20, 0, 0, 0)
		end
	end
	room.gameDayStep = period

	closePlaces()
	for i, v in next, ROOM.playerList do
		background(i, room.gameDayStep)
		if players[i] then
			if players[i].place:find('house_') then
				house = players[i].place:sub(7)
				loadFound(i, house)
			end
		end
		if period == 'day' then 
			showTextArea(1029, '<font size="15"><p align="center"><a href="event:enter_bank">' .. translate('goTo', i) .. '</a>', i, 2670, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.3)
		end
	end
end