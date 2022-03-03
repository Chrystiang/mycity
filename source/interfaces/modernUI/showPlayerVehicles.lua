modernUI.showPlayerVehicles = function(self)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) + 45
	local y = (200 - height/2) + 70
	local currentPage = 1
	local filter = {'car', 'boat', 'air'}
	local pages = {'land', 'water', 'air'}
	local favorites = players[player].favoriteCars
	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('17238027fa4.jpg', "~26", x, y-16, player)

	local function showItems()
		showTextArea(id..'890', '<font color="#ebddc3" size="13"><b><p align="center">'..translate(pages[currentPage]..'Vehicles', player), player, 350, y-25, 100, nil, 0x152d30, 0x152d30, 0, true)
		local i = 1
		for _ = 1, #players[player].cars do 
			local v = mainAssets.__cars[players[player].cars[_]]
			if v.type == filter[currentPage] then 
				players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage('17237e4b350.jpg', "~26", x + ((i-1)%4)*107, y + floor((i-1)/4)*65, player)
				players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage(v.icon, "~26", x + ((i-1)%4)*107, y + floor((i-1)/4)*65, player)
				players[player]._modernUISelectedItemImages[3][#players[player]._modernUISelectedItemImages[3]+1] = addImage('17958659424.png', "~27", x + ((i-1)%4)*107, y + floor((i-1)/4)*65, player)

				local isFavorite = favorites[currentPage] == players[player].cars[_] and '17238fea420.png' or '17238fe6532.png'
				players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(isFavorite, "~27", x+82 + ((i-1)%4)*107, y +42 + floor((i-1)/4)*65, player)

				local vehicleName = lang.en['vehicle_'..players[player].cars[_]] and translate('vehicle_'..players[player].cars[_], player) or v.name
				showTextArea(id..(895+i*4), '<p align="center"><font color="#95d44d" size="10">'..vehicleName, player, x + ((i-1)%4)*107, y-2 + floor((i-1)/4)*65, 104, nil, 0xff0000, 0xff0000, 0, true)
				showTextArea(id..(896+i*4), '<font size="7">'..v.speed..' '..(v.type == 'boat' and translate('speed_knots', player) or translate('speed_km', player)), player, x + ((i-1)%4)*107, y+54 + floor((i-1)/4)*65, 104, nil, 0xff0000, 0xff0000, 0, true)
				showTextArea(id..(897+i*4), '\n\n\n\n', player, x + 3 + ((i-1)%4)*107, y + 3 + floor((i-1)/4)*65, 104, 62, 0xff0000, 0xff0000, 0, true,
					function(player)
						local car = players[player].cars[_]
						if currentPage ~= 2 and (ROOM.playerList[player].y < 7000 or ROOM.playerList[player].y > 7800 or players[player].place ~= 'town' and players[player].place ~= 'island') and not players[player].canDrive then return alert_Error(player, 'error', 'vehicleError') end
						drive(player, car)
						eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
						if v.type == 'air' then
							modernUI.new(player, 240, 120, translate('confirmButton_tip', player), translate('tip_airVehicle', player), 'errorUI')
							:build()
						end
					end)
				showTextArea(id..(898+i*4), "<textformat leftmargin='1' rightmargin='1'>\n\n\n\n", player, x + 82 + ((i-1)%4)*107, y + 42 + floor((i-1)/4)*65, 20, 20, 0xff0000, 0xff0000, 0, true,
					function(player)
						favorites[currentPage] = players[player].cars[_]
						players[player].favoriteCars[currentPage] = players[player].cars[_]
						showItems()
						savedata(player)
					end)
				i = i + 1
			end
		end
	end
	local function updateScrollbar()
		local function updatePage(count)
			if currentPage + count > 3 or currentPage + count < 1 then return end 
			currentPage = currentPage + count
			removeGroupImages(players[player]._modernUISelectedItemImages[1])
			removeGroupImages(players[player]._modernUISelectedItemImages[3])
			for i = 899, 950 do 
				removeTextArea(id..i, player)
			end
			updateScrollbar()
			showItems()
		end
		showTextArea(id..'888', string.rep('\n', 10), player, x, y+202, 212, 10, 0x24474D, 0xff0000, 0, true, 
			function()
				updatePage(-1)
			end)
		showTextArea(id..'889', string.rep('\n', 10), player, x+213, y+202, 212, 10, 0x24474D, 0xff0000, 0, true, 
			function()
				updatePage(1)
			end)

		removeGroupImages(players[player]._modernUISelectedItemImages[2])
		players[player]._modernUISelectedItemImages[2][#players[player]._modernUISelectedItemImages[2]+1] = addImage('172380798d8.jpg', "~26", x, y+205, player)
		for i = 1, 3 do 
			players[player]._modernUISelectedItemImages[2][#players[player]._modernUISelectedItemImages[2]+1] = addImage('172383aa660.jpg', "~27", x + (i-1)*85 + (currentPage-1)*85, y+205, player)
		end
	end

	updateScrollbar()
	showItems()
	return setmetatable(self, modernUI)
end