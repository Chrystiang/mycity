modernUI.showHouseSettings = function(self)
	local id = self.id
	local player = self.player
	local height = self.height
	local x = (400 - 180/2)
	local y = (200 - height/2) + 50

	local function button(i, text, callback, x, y, width, height)
		local width = width or 180
		local height = height or 15
		showTextArea(id..(930+i*5), '', player, x-1, y-1, width, height, 0x95d44d, 0x95d44d, 1, true)
		showTextArea(id..(931+i*5), '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
		showTextArea(id..(932+i*5), '', player, x, y, width, height, 0x44662c, 0x44662c, 1, true)
		showTextArea(id..(933+i*5), '<p align="center"><font color="#cef1c3" size="13">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, callback)
	end
	local images = {bg = {}, icons = {}, pages = {}, expansions = {}}
	local terrainID = players[player].houseData.houseid
	local showFurnitures, updateScrollbar, updatePage
	local buildModeImages = {currentFurniture = nil, furnitures = {}}
	local playerFurnitures = table_copy(players[player].houseData.furnitures.stored)
	local playerFurnitures_length = table_getLength(playerFurnitures)
	local playerPlacedFurnitures = table_copy(players[player].houseData.furnitures.placed)
	local totalOfPlacedFurnitures = table_getLength(players[player].houseData.furnitures.placed)

	local function removeFurniture(index)
		if not players[player].editingHouse then return end
		local data = playerPlacedFurnitures[index]
		if not data then return end
		playerPlacedFurnitures[index] = false
		removeImage(data.image)
		removeTextArea(- 85000 - (terrainID*200 + index), player)
		if mainAssets.__furnitures[data.type].grounds then
			removeGround(- 7000 - (terrainID-1)*200 - index)
		end
		totalOfPlacedFurnitures = totalOfPlacedFurnitures - 1
		if not playerFurnitures[data.type] then 
			playerFurnitures[data.type] = {quanty = 1, type = data.type}
		else 
			playerFurnitures[data.type].quanty = playerFurnitures[data.type].quanty + 1
		end
		ui.updateTextArea(id..'891', '<font size="12"><cs>'..translate('placedFurnitures', player):format('<fc><b>'..totalOfPlacedFurnitures..'/'..maxPlacedFurnitures..'</b></fc>'), player)
		updatePage(0)
	end
	local function placeFurniture(index)
		if not players[player].editingHouse then return end
		if totalOfPlacedFurnitures >= maxPlacedFurnitures then return alert_Error(player, 'error', 'maxPlacedFurnitures', maxPlacedFurnitures) end
		if buildModeImages.currentFurniture then 
			removeImage(buildModeImages.currentFurniture)
			buildModeImages.currentFurniture = nil
		end
		local data = playerFurnitures[index]
		if not data then return alert_Error(player, 'error', 'unknownFurniture') end
		local furniture = mainAssets.__furnitures[data.type]
		buildModeImages.currentFurniture = addImage(furniture.image, '%'..player, furniture.align.x, furniture.align.y, player)
		images.icons[#images.icons+1] = addImage('172469fea71.jpg', ':25', 350, 317, player)
		showTextArea(id..'892', '<p align="center"><b><fc><font size="14">'..translate('houseSettings_placeFurniture', player)..'\n', player, 350, 321, 100, 25, 0x24474D, 0x00ff00, 0, true, 
			function()
				removeTextArea(id..'892', player)
				if not playerFurnitures[index] then return end
				if playerFurnitures[index].quanty <= 0 then return end
				local x, y = ROOM.playerList[player].x, ROOM.playerList[player].y
				if y < 1000 or y > 2000 then return end
				if x > terrainID*1500 or x < (terrainID-1)*1500+100 then return end

				playerFurnitures[index].quanty = playerFurnitures[index].quanty - 1
				totalOfPlacedFurnitures = totalOfPlacedFurnitures + 1
				ui.updateTextArea(id..'891', '<font size="12"><cs>'..translate('placedFurnitures', player):format('<fc><b>'..totalOfPlacedFurnitures..'/'..maxPlacedFurnitures..'</b></fc>'), player)

				local id = terrainID

				killPlayer(player)
				respawnPlayer(player)
				movePlayer(player, x, y, false)

				local furniture_X = x + furniture.align.x 
				local furniture_Y = y + furniture.align.y
				local idd = #playerPlacedFurnitures+1
				playerPlacedFurnitures[idd] = {type = data.type, x = furniture_X - (id-1)*1500, y = furniture_Y - 1000, image = addImage(furniture.image, '?1000'..idd, furniture_X, furniture_Y, player)}
				showTextArea(- 85000 - (id*200 + idd), "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', furniture.area[2]/8), player, furniture_X, furniture_Y, furniture.area[1], furniture.area[2], 1, 0xfff000, 0, false, 
					function()
						removeFurniture(idd)
					end)

				if furniture.grounds then
					furniture.grounds(furniture_X,  furniture_Y, - 7000 - (id-1)*200 - idd)
					movePlayer(player, 0, - 50, true)
				end

				if playerFurnitures[index].quanty <= 0 then 
					playerFurnitures[index] = false
				end
				updatePage(0)
			end)

	end
	local function sellFurniture(index)
		if not players[player].editingHouse then return end
		local data = playerFurnitures[index]
		if not data then return alert_Error(player, 'error', 'unknownFurniture') end
		local furniture = mainAssets.__furnitures[data.type]
		if playerFurnitures[index].quanty <= 0 then return end
		playerFurnitures[index].quanty = playerFurnitures[index].quanty - 1
		if playerFurnitures[index].quanty <= 0 then 
			playerFurnitures[index] = nil
		end
		if buildModeImages.currentFurniture then
			local x, y = ROOM.playerList[player].x, ROOM.playerList[player].y
			killPlayer(player)
			respawnPlayer(player)
			movePlayer(player, x, y, false)
			buildModeImages.currentFurniture = nil
			removeTextArea(id..'892', player)
		end
		players[player].houseData.furnitures.stored = {}
		for i, v in next, playerFurnitures do
			if v then
				players[player].houseData.furnitures.stored[i] = v
			end
		end
		players[player].houseData.furnitures.placed = {}
		for i, v in next, playerPlacedFurnitures do 
			if v then
				players[player].houseData.furnitures.placed[i] = v
				removeImage(v.image)
				removeTextArea(- 85000 - (terrainID*200 + i), player)
			end
		end
		giveCoin(furniture.price and furniture.price/2 or 0, player)
		updatePage(0)
	end
	local function closeExpansionMenu()
		removeGroupImages(images.expansions)
		removeTextArea(id..'889', player)
		removeTextArea(id..'890', player)
		updatePage(0)
	end
	button(0, translate('houseSettings_permissions', player), function() 
		eventTextAreaCallback(0, player, 'modernUI_Close_'..id, 'errorUI')
		modernUI.new(player, 380, 280, translate('houseSettings_permissions', player))
		:build()
		:showHousePermissions()
	end, x, y)

	button(1, translate('houseSettings_buildMode', player), function() 
		if players[player].editingHouse then return end
		players[player].editingHouse = true
		for i = 0, 4 do 
			removeTextArea(98900000000+i, player)
			removeTextArea(999990+i, player)
		end

		removeGroupImages(room.houseImgs[terrainID].furnitures)
		for i, furniture in next, playerPlacedFurnitures do
			local data = mainAssets.__furnitures[furniture.type]
			local x = furniture.x + ((terrainID-1)%terrainID)*1500
			local y = furniture.y + 1000
			furniture.image = addImage(data.image, '?1000', x, y, player)
			showTextArea(- 85000 - (terrainID*200 + i), "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', data.area[2]/8), player, x, y, data.area[1], data.area[2], 1, 0xfff000, 0, false, 
				function()
					removeFurniture(i)
				end)
		end
		for guest in next, room.terrains[terrainID].guests do
			if room.terrains[terrainID].guests[guest] then 
				getOutHouse(guest, terrainID)
				alert_Error(guest, 'error', 'error_houseUnderEdit', player)
			end
		end
		room.terrains[terrainID].guests = {}

		eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
		for i = 0, 4 do
			if players[player].houseTerrainAdd[i+1] <= 1 then
				showTextArea(id..(885+i), '<p align="center"><fc>'..translate('houseSettings_changeExpansion', player)..'\n', player, (terrainID-1)*1500 + 650 + i*175, 1740, 175, nil, 0x24474D, 0xff0000, 0, false,
					function()
						if images.expansions[1] then return end
						showTextArea(id..'889', '', player, 0, 0, 800, 400, 0x24474D, 0xff0000, 0, true)
						local counter = 0
						for _ = 0, 4 do
							if _ ~= i then 
								images.expansions[#images.expansions+1] = addImage('17285e3d8e1.png', "!1000", (terrainID-1)*1500 + 650 + _*175, 1715, player)
							end
						end
						images.expansions[#images.expansions+1] = addImage('171d2a2e21a.png', ":25", 280, 140, player)
						showTextArea(id..'890', string.rep('\n', 4), player, 487, 150, 25, 25, 0xff0000, 0xff0000, 0, true, function() closeExpansionMenu() end)
						for expansionID, v in next, HouseSystem.expansions do
							if players[player].houseTerrain[i+1] ~= expansionID then
								images.expansions[#images.expansions+1] = addImage(v.png, ":26", counter*109 + 324, 150, player)
								button(counter, translate('confirmButton_Buy2', player):format('<fc>'..translate('expansion_'..v.name, player)..'</fc>','<fc>$'..v.price..'</fc>'), 
									function()
										if players[player].coins < v.price or players[player].houseTerrain[i+1] == expansionID then return end
										players[player].houseTerrain[i+1] = expansionID
										players[player].houseTerrainAdd[i+1] = 1
										players[player].houseTerrainPlants[i+1] = 0
										HouseSystem.new(player):genHouseGrounds()
										giveCoin(-v.price, player)
										closeExpansionMenu()
									end, counter*109 + 299, 210, 95, 30)
								counter = counter + 1
							end
						end
					end)
			end
		end
		local currentPage = 1
		local maxPages = math.ceil(playerFurnitures_length/14)
		images.bg[#images.bg+1] = addImage('1723ed04fb4.jpg', ':25', 5, 340, player)
		images.bg[#images.bg+1] = addImage('172469fea71.jpg', ':25', 695, 317, player)

		showTextArea(id..'891', '<font size="12"><cs>'..translate('placedFurnitures', player):format('<fc><b>'..totalOfPlacedFurnitures..'/'..maxPlacedFurnitures..'</b></fc>'), player, 0, 321, nil, nil, 0x24474D, 0xff0000, 0, true)
		showTextArea(id..'893', '', player, 0, 340, 800, 60, 0x24474D, 0xff0000, 0, true)
		showTextArea(id..'894', '<p align="center"><b><font color="#95d44d" size="14">'..translate('houseSettings_finish', player)..'\n', player, 695, 321, 100, nil, 0x24474D, 0xff0000, 0, true, 
			function()
				if not players[player].editingHouse then return end
				local x, y = ROOM.playerList[player].x, ROOM.playerList[player].y
				killPlayer(player)
				respawnPlayer(player)
				movePlayer(player, x, y, false)

				players[player].houseData.furnitures.stored = {}
				for i, v in next, playerFurnitures do
					if v then
						players[player].houseData.furnitures.stored[i] = v
					end
				end
				players[player].houseData.furnitures.placed = {}
				for i, v in next, playerPlacedFurnitures do 
					if v then
						players[player].houseData.furnitures.placed[i] = v
						removeImage(v.image)
						removeTextArea(- 85000 - (terrainID*200 + i), player)
					end
				end
				players[player].houseData.chests.position = {}
				players[player].editingHouse = false
				savedata(player)
				HouseSystem.new(player):genHouseFace()
				for i = 1, 2 do 
					showLifeStats(player, i)
				end
				removeGroupImages(images.icons)
				removeGroupImages(images.pages)
				removeGroupImages(images.bg)
				eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
			end)
		showFurnitures = function()
			local minn = 14 * (currentPage-1) + 1
			local maxx = currentPage * 14
			local i = 0
			for index, v in next, playerFurnitures do
				if v then
					i = i + 1
					if i >= minn and i <= maxx then
						local i = i - 14 * (currentPage-1)
						local furnitureData = mainAssets.__furnitures[v.type]
						images.icons[#images.icons+1] = addImage('1723ed07002.png', ':26', 37 + (i-1) * 52, 350, player)
						images.icons[#images.icons+1] = addImage(furnitureData.png, ':27', 39 + (i-1) * 52, 350, player)
						images.icons[#images.icons+1] = addImage('172559203c1.png', ':28', 37 + (i-1) * 52, 350, player)

						showTextArea(id..(895+i*3), '<p align="right"><font color="#95d44d" size="13"><b>x'..v.quanty, player, 35 + (i-1)*52, 383, 54, nil, 0xff0000, 0xff0000, 0, true)
						showTextArea(id..(896+i*3), '\n\n\n\n', player, 35 + (i-1)*52, 347, 55, 55, 0xff0000, 0xff0000, 0, true,
							function()
								placeFurniture(index)
							end)
						showTextArea(id..(897+i*3), "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', 3), player, 37 + (i-1)*52, 350, 10, 10, 0xff0000, 0xff0000, 0, true,
							function()
								modernUI.new(player, 240, 220, translate('sellFurniture', player), translate('sellFurnitureWarning', player))
								:build()
								:addConfirmButton(function()
									sellFurniture(index)
								end, translate('confirmButton_Sell', player):format('<b><fc>$'..(furnitureData.price and furnitureData.price/2 or 0)..'</fc></b>'), 200)
							end)

					end
				end
			end
		end
		updatePage = function(count)
			if currentPage + count > maxPages or currentPage + count < 1 then return end 
			currentPage = currentPage + count
			removeGroupImages(images.icons)
			removeGroupImages(images.pages)
			for i = 895, 995 do
				removeTextArea(id..i, player)
			end
			updateScrollbar()
			showFurnitures()
		end
		updateScrollbar = function()
			if currentPage > 1 then
				images.pages[#images.pages+1] = addImage('1723f16c0ba.jpg', ':25', 5, 340, player)
				showTextArea(id..'895', string.rep('\n', 10), player, 12, 345, 20, 60, 0x24474D, 0xff0000, 0, true, 
					function()
						updatePage(-1)
					end)
			end
			if currentPage < maxPages then
				images.pages[#images.pages+1] = addImage('1723f16e3ba.jpg', ':25', 761, 340, player)
				showTextArea(id..'896', string.rep('\n', 10), player, 767, 345, 20, 60, 0x24474D, 0xff0000, 0, true, 
					function()
						updatePage(1)
					end)
			end
		end
		if maxPages > 1 then 
			updateScrollbar()
		end
		showFurnitures()
	end, x, y+30)

	return setmetatable(self, modernUI)
end