loadFound = function(player, house)
	local id = tonumber(house)
	local align = room.event and room.specialFounds[room.event].align or 1919
	for i = 1, #players[player].dayImgs do
		removeImage(players[player].dayImgs[i])
	end
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
		if period == 'day' then
			png = '1724c10adda.jpg'
		elseif period == 'evening' then
			png = '1724c1daa44.jpg'
		elseif period == 'night' then
			png = '16baeb0ead4.jpg'
		elseif period == 'dawn' then
			png = '16b80619ab9.jpg'
		elseif period == 'halloween' then
			png = '15ed953938a.jpg'
		end

	else
		png = room.specialFounds[room.event][period]
		align = room.specialFounds[room.event].align
	end
	if getPng then return png end

	for i = 1, #players[player].background do
		removeImage(players[player].background[i])
	end
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
		end
		if period == 'night' then
			players[player].background[#players[player].background+1] = addImage("16b952d1012.png", "!9999", 4500, 4920 + yalign, player)
		end
	end
end

loadDayTimeEffects = function(period)
	if period == 'night' then
		gameNpcs.removeNPC('Colt')
	elseif period == 'day' then
		gameNpcs.reAddNPC('Colt')
		room.bankBeingRobbed = false
		room.bankRobStep = nil
		for i = 1, #room.bankImages do
			removeImage(room.bankImages[i])
		end
		room.bankImages = {}
		room.bankPassword = math.random(0,9) .. math.random(0,9) .. math.random(0,9) .. math.random(0,9)
		for i = 1, #room.bank.paperImages do
			removeImage(room.bank.paperImages[i])
		end
		room.dayCounter = room.dayCounter + 1
		if room.dayCounter > 0 then 
			room.bank.paperImages = {}
			room.bank.paperCurrentPlace = math.random(1, #room.bank.paperPlaces)
			room.bank.paperImages[#room.bank.paperImages+1] = addImage('16bbf3aa649.png', '!1', room.bank.paperPlaces[room.bank.paperCurrentPlace].x, room.bank.paperPlaces[room.bank.paperCurrentPlace].y)
			ui.addTextArea(-3333, '<a href="event:getVaultPassword">'..string.rep('\n', 10), nil, room.bank.paperPlaces[room.bank.paperCurrentPlace].x, room.bank.paperPlaces[room.bank.paperCurrentPlace].y, 20, 20, 0, 0, 0)
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
			ui.addTextArea(1029, '<font size="15"><p align="center"><a href="event:enter_bank">' .. translate('goTo', i) .. '</a>', i, 2670, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.3)
		end
	end
end