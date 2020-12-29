item_drop = function(item, player, amount)
	local x, y, _player
	amount = amount or 1
	if type(player) == 'string' then  -- if is from a player
		if players[player].isTrading then return alert_Error(player, 'error', 'error') end
		x = ROOM.playerList[player].x
		y = ROOM.playerList[player].y-10
		_player = player
	else -- or from the server, with x and y positions
		x = player.x 
		y = player.y-10
		player = 'Oliver'
	end
	room.droppedItems[#room.droppedItems+1] = {owner = player, amount = amount, x = x, y = y, item = item, id = bagItems[item].id, collected = false, image = addImage(bagItems[item].png and bagItems[item].png or '16bc368f352.png', '_70000', x, y, _player)}
	showTextArea(-40000-#room.droppedItems, "<textformat leftmargin='1' rightmargin='1'><a href='event:collectDroppedItem_"..#room.droppedItems.."'>"..string.rep('\n', 5), _player, x, y, 50, 50, 1, 1, 0, false)
	item_droppedEvent(#room.droppedItems, player)
end

item_collect = function(item, target, amount)
	if room.droppedItems[item].amount <= 0 then return end
	if not amount then amount = 1 end

	local xx = target and ROOM.playerList[target].x or room.droppedItems[item].x
	local yy = target and ROOM.playerList[target].y or room.droppedItems[item].y
	if math_hypo(room.droppedItems[item].x, room.droppedItems[item].y, xx, yy) > 60 then return end

	if target then
		if players[target].isTrading then return alert_Error(target, 'error', 'error') end
		local data = room.droppedItems[item]
		addItem(data.item, amount, target)
	end
	room.droppedItems[item].amount = room.droppedItems[item].amount - amount

	if room.droppedItems[item].amount <= 0 then 
		removeImage(room.droppedItems[item].image)
		removeTextArea(-40000-item)
		room.droppedItems[item].collected = true
	end
end

item_droppedEvent = function(id, player)
	local canRemove = false
	local item = room.droppedItems[id].item
	local amount = room.droppedItems[id].amount
	local itemData = bagItems[item]
	local itemName = item
	if itemName:find('_luckyFlowerSeed') then
		itemName = 'luckyFlowerSeed'
	elseif itemName:find('_luckyFlower') then
		itemName = 'luckyFlower'
	end
						
	if amount <= 0 then return end
	if players[player].place == 'clockTower' and item:find('Present') then
		canRemove = true
		local giftValue = 1000
		giveCoin(giftValue * amount, player)
		chatMessage('<j>'..translate('seedSold', player):format('<vp>'..translate('item_'..itemName, player)..'</vp>', '<fc>$'..(giftValue * amount)..'</fc>'), player)	
		job_updatePlayerStats(player, 18, amount)
	end
	if checkLocation_isInHouse(player) then
		local terrainID = players[player].houseData.houseid
		for chestID, v in next, players[player].houseData.chests.position do
			if v.x then
				if math_hypo(ROOM.playerList[player].x, ROOM.playerList[player].y, v.x+20, v.y+20) <= 90 then
					if players[player].totalOfStoredItems.chest[chestID] + amount > 50 then return chatMessage('<r>'.. translate('chestIsFull', player), player) end
					item_addToChest(item, amount, player, chestID)
					savedata(player)
					chatMessage('<j>'.. translate('itemAddedToChest', player):format('<vp>'.. translate('item_'..itemName, player) ..'</vp> <CE>('..amount..')</CE>'), player)
					canRemove = true
					break
				end
			end
		end
	elseif players[player].job == 'farmer' then
		if tonumber(players[player].place:sub(7)) == 12 and string_find(item, 'Seed') then
			for i, v in next, HouseSystem.plants do
				if string_find(item, v.name) then
					canRemove = true
					giveCoin(v.pricePerSeed * amount, player, true)
					chatMessage('<j>'..translate('seedSold', player):format('<vp>'..translate('item_'..v.name..'Seed', player)..'</vp>', '<fc>$'..(v.pricePerSeed * amount)..'</fc>'), player)
					job_updatePlayerStats(player, 6, amount)
					giveExperiencePoints(player, 2 * amount)
					break
				end
			end
		elseif math_hypo(ROOM.playerList[player].x, ROOM.playerList[player].y, 11650, 7645) <= 200 then
			if itemData.isFruit then
				canRemove = true
				giveCoin(itemData.sellingPrice * amount, player, true)
				chatMessage('<j>'..translate('seedSold', player):format('<vp>'..translate('item_'..itemName, player)..'</vp>', '<fc>$'..(itemData.sellingPrice * amount)..'</fc>'), player)
				job_updatePlayerStats(player, 11, amount)
				giveExperiencePoints(player, 2 * amount)
			end
		end
	elseif players[player].job == 'fisher' and players[player].place == 'fishShop' and string_find(item, 'fish_') then
		canRemove = true
		giveCoin(bagItems[item].price * amount, player)
		chatMessage('<j>'..translate('seedSold', player):format('<vp>'..translate('item_'..itemName, player)..'</vp>', '<fc>$'..(bagItems[item].price * amount)..'</fc>'), player)
	elseif players[player].job == 'miner' and players[player].place == 'town' then
		if item:find('crystal_') or item:find('goldNugget') then
			if ROOM.playerList[player].x > 475 and ROOM.playerList[player].x < 745 and ROOM.playerList[player].y > 8070 and ROOM.playerList[player].y < 8230 then
				canRemove = true
				giveCoin(bagItems[item].price * amount, player)
				giveExperiencePoints(player, 40 * amount)
				chatMessage('<j>'..translate('seedSold', player):format('<vp>'..translate('item_'..itemName, player)..'</vp>', '<fc>$'..(bagItems[item].price * amount)..'</fc>'), player)
				if item:find('crystal_') then
					job_updatePlayerStats(player, bagItems[item].jobStatID, amount)
				end
			end
		end
	end
	if canRemove then 
		item_collect(id, nil, amount)
	end
end