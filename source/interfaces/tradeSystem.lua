local tradeSystem = {
	trades = {},
}
greenButton = function(id, i, text, player, callback, x, y, width, height, blockClick)
	width = width or 180
	height = height or 15
	
	local colorPallete = {
		button_confirmBg = 0x95d44d,
		button_confirmFront = 0x44662c
	}
	if blockClick then 
		colorPallete.button_confirmBg = 0xbdbdbd
		colorPallete.button_confirmFront = 0x5b5b5b
		text = '<r>'..text
	end
	showTextArea(id..(930+i*5), '', player, x-1, y-1, width, height, colorPallete.button_confirmBg, colorPallete.button_confirmBg, 1, true)
	showTextArea(id..(931+i*5), '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
	showTextArea(id..(932+i*5), '', player, x, y, width, height, colorPallete.button_confirmFront, colorPallete.button_confirmFront, 1, true)
	showTextArea(id..(933+i*5), '<p align="center"><font color="#cef1c3" size="13">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, not blockClick and callback or nil)
end

tradeSystem.invite = function(player1, player2)
	if players[player2].isTrading then return alert_Error(player1, 'trade_cancelled_title', 'trade_playerAlreadyTrading', player2) end
	if not players[player2].dataLoaded or not players[player1].dataLoaded then return alert_Error(player1, 'trade_cancelled_title', 'error') end
	if players[player2].settings.disableTrades == 1 then return alert_Error(player1, 'trade_cancelled_title', 'trade_invite_error', player2) end

	modernUI.new(player2, 240, 170, translate('trade_invite_title', player2), translate('trade_invite', player2):format(player1))
	:build()
	:addConfirmButton(function()
		tradeSystem.new(player1, player2)
	end, translate('submit', player2), player1)
end

tradeSystem.playerInterface = function(tradeInfo, player)
	tradeSystem.showPlayerItems(tradeInfo, player)
	greenButton(200, 0, translate('confirmButton_trade', player), player, 
		function()
			if tradeInfo.tradeData.finished then return end
			if tradeInfo.tradeData.timer then return end
			if tradeInfo.tradeData.confirmed[player] then return end
			local canFinish = true
			tradeInfo.tradeData.confirmed[player] = true
			for p, tradingWith in next, tradeInfo.tradeData.players do
				local x = p == player and 265 or 465
				local id = p == player and 950 or 948
				showTextArea((200)..id, '', p, x, 115, 68, 200, 0x95d44d, 0x95d44d, 0.6, true)
				if not tradeInfo.tradeData.confirmed[p] then
					canFinish = false
				end
			end
			if canFinish then
				tradeInfo.tradeData.finished = true
				addTimer(function()
					tradeSystem.confirmTrade(tradeInfo)
					tradeSystem.endTrade(tradeInfo)
				end, 1000, 1)
			end
		end, 
	372, 197, 60, 12)
	greenButton(200, 1, translate('confirmButton_cancel', player), player, 
		function()
			if tradeInfo.tradeData.finished then return end
			if not tradeInfo.tradeData.confirmed[player] then
				tradeSystem.endTrade(tradeInfo, player)
			else
				tradeSystem.blockSubmitButton(tradeInfo, player)
			end
		end, 
	372, 222, 60, 12)
end

tradeSystem.insertItem = function(tradeInfo, item, player, originalID)
	if tradeInfo.tradeData.finished then return end
	local itemData = bagItems[item]
	local image = itemData.png or '16bc368f352.png'
	local index, y

	if not tradeInfo.tradeData.trading[player][item] then
		local positions = {120, 168, 216, 264}
		for _, data in next, tradeInfo.tradeData.trading[player] do
			if positions[data.index] then
				positions[data.index] = nil
			end
		end
		for i = 1, 4 do
			local v = positions[i]
			if v then
				y = positions[i]
				index = i
				break
			end
		end

		tradeInfo.tradeData.trading[player][item] = {amount = 1, index = index, height = y, images = {}}
	else
		index = tradeInfo.tradeData.trading[player][item].index
		y = tradeInfo.tradeData.trading[player][item].height
		tradeInfo.tradeData.trading[player][item].amount = tradeInfo.tradeData.trading[player][item].amount + 1
	end

	for p, tradingWith in next, tradeInfo.tradeData.players do
		local x = p == player and 277 or 477
		local id = p == player and 900 or 910

		if tradeInfo.tradeData.trading[player][item].amount == 1 then
			local bgImage = (itemData.limitedTime and formatDaysRemaining(itemData.limitedTime, true)) and '174eae7fde7.jpg' or '174280ced34.jpg'

			tradeInfo.tradeData.trading[player][item].images[#tradeInfo.tradeData.trading[player][item].images+1] = addImage(bgImage, ':50', x, y, p)
			tradeInfo.tradeData.trading[player][item].images[#tradeInfo.tradeData.trading[player][item].images+1] = addImage(image, ':50', x-2, y, p)
		end
		showTextArea((200)..(id+index*2), '<p align="right"><font color="#95d44d" size="10"><b>x'..tradeInfo.tradeData.trading[player][item].amount, p, x+4, y+29, 40, nil, 0xff0000, 0xff0000, 0, true)
		if p == player then
			showTextArea((200)..(id+1+index*2), '\n\n\n\n', p, x+2, y+2, 40, 40, 0xff0000, 0xff0000, 0, true,
				function()
					if not tradeInfo.tradeData.trading[player][item] then return end
					if tradeInfo.tradeData.trading[player][item].amount < 1 then return end
					tradeSystem.blockSubmitButton(tradeInfo, player)
					tradeInfo.tradeData.trading[player][item].amount = tradeInfo.tradeData.trading[player][item].amount - 1
					originalID[1].qt = originalID[1].qt + 1
					ui.updateTextArea(originalID[2], '<p align="right"><font color="#95d44d" size="10"><b>x'..originalID[1].qt, player)
					for pp, _tradingWith in next, tradeInfo.tradeData.players do
						local id = pp == player and 900 or 910
						ui.updateTextArea((200)..(id+index*2), '<p align="right"><font color="#95d44d" size="10"><b>x'..tradeInfo.tradeData.trading[player][item].amount, pp)
					end

					if tradeInfo.tradeData.trading[player][item].amount == 0 then
						removeGroupImages(tradeInfo.tradeData.trading[player][item].images)
						tradeInfo.tradeData.trading[player][item] = nil
						for pp, _tradingWith in next, tradeInfo.tradeData.players do
							local id = pp == player and 900 or 910
							removeTextArea((200)..(id+index*2), pp)
						end
					end
				end
			)
		end
	end
	tradeSystem.blockSubmitButton(tradeInfo, player)
end

tradeSystem.blockSubmitButton = function(tradeInfo, player)
	for p, tradingWith in next, tradeInfo.tradeData.players do
		tradeInfo.tradeData.confirmed[p] = false
		showTextArea(200999, '', p, 372, 197, 60, 12, 0x5b5b5b, 0x5b5b5b, .8, true)
		local id = p ~= player and 950 or 948
		removeTextArea((200)..id, p)
	end
	if tradeInfo.tradeData.timer then
		removeTimer(tradeInfo.tradeData.timer)
	end
	tradeInfo.tradeData.timer = addTimer(function()
		removeTextArea(200999, player)
		removeTextArea(200999, players[player].isTrading)
		tradeInfo.tradeData.timer = nil
	end, 3000, 1)
end

tradeSystem.showPlayerItems = function(tradeInfo, player)
	local items = table_copy(players[player].bag)

	local currentPage = 1
	local maxPages = math.ceil(#items/24)
	local minn = 24 * (currentPage-1) + 1
	local maxx = currentPage * 24

	local i, id, x, y = 0, 200, 46, 66
	for _ = 1, #items do 
		i = i + 1
		local v = items[_]
		if i >= minn and i <= maxx then
			local i = i - 24 * (currentPage-1)
			local itemData = bagItems[v.name]
			local image = itemData.png or '16bc368f352.png'
			local bgImage = (itemData.limitedTime and formatDaysRemaining(itemData.limitedTime, true)) and '174eae7e0e1.jpg' or '174283c22c9.jpg'

			tradeInfo.playerImages[player][#tradeInfo.playerImages[player]+1] = addImage(bgImage, ":26", x + ((i-1)%4)*43, y + floor((i-1)/4)*43, player)
			tradeInfo.playerImages[player][#tradeInfo.playerImages[player]+1] = addImage(image, ":26", x - 5 + ((i-1)%4)*43, y - 5 + floor((i-1)/4)*43, player)
			local cannotTrade = false
	
			if not table_find(mainAssets.roles.admin, player) then
				if v.name:find('FlowerSeed') and players[tradeInfo.tradeData.players[player]].jobs[5] < 1000  then
					cannotTrade = true
				elseif v.name:find('Goldenmare') and players[player].jobs[3] < 50*v.qt then
					cannotTrade = true
				elseif bagIds[itemData.id].blockTrades then
					cannotTrade = true
				end
			end

			if cannotTrade then
				tradeInfo.playerImages[player][#tradeInfo.playerImages[player]+1] = addImage('174bc80c9bd.png', ":26", x + ((i-1)%4)*43, y + floor((i-1)/4)*43, player)
			else
				showTextArea(id..(800+i*2), '<p align="right"><font color="#95d44d" size="10"><b>x'..v.qt, player, x + ((i-1)%4)*43, y + 24 + floor((i-1)/4)*43, 40, nil, 0xff0000, 0xff0000, 0, true)
				showTextArea(id..(801+i*2), '\n\n\n\n', player, x + ((i-1)%4)*43, y + floor((i-1)/4)*43, 40, 40, 0xff0000, 0xff0000, 0, true,
					function()
						if v.qt <= 0 or tradeInfo.tradeData.confirmed[player] then return end
						local counter = 0
						if not tradeInfo.tradeData.trading[player][v.name] then
							for _, data in next, tradeInfo.tradeData.trading[player] do
								counter = counter + 1
								if counter >= 4 then return end
							end
						end
						v.qt = v.qt - 1
						tradeSystem.insertItem(tradeInfo, v.name, player, {v, id..(800+i*2)})
						ui.updateTextArea(id..(800+i*2), '<p align="right"><font color="#95d44d" size="10"><b>x'..v.qt, player)
					end
				)
			end
		end
	end
end

tradeSystem.endTrade = function(tradeInfo, cancelled, playerLeft)
	tradeInfo.tradeData.finished = true
	removeGroupImages(tradeInfo.groupImages.fixed)
	removeGroupImages(tradeInfo.groupImages.temporary)
	for player, v in next, tradeInfo.playerImages do
		removeGroupImages(v)
		removeTextArea(7100999, player)
		for i = 800, 999 do
			removeTextArea((200)..i, player)
		end
		players[player].isTrading = false
		players[player].tradeId = nil
		if cancelled and cancelled ~= player then
			alert_Error(player, 'trade_cancelled_title', 'trade_cancelled', cancelled)
		elseif playerLeft and playerLeft ~= player then
			alert_Error(player, 'trade_cancelled_title', 'trade_playerLeftRoom', playerLeft)
		end
	end
	for p, items in next, tradeInfo.tradeData.trading do
		for item, data in next, items do
			removeGroupImages(data.images)
		end
	end
end

tradeSystem.confirmTrade = function(tradeInfo)
	for player, items in next, tradeInfo.tradeData.trading do
		if not players[player].inRoom then return alert_Error(tradeInfo.tradeData.players[player], 'trade_cancelled_title', 'trade_playerLeftRoom', player) end
		if players[player].holdingItem then return alert_Error(tradeInfo.tradeData.players[player], 'trade_cancelled_title', 'trade_playerUsingAnItem', player) end
		if players[player].totalOfStoredItems.bag > players[player].bagLimit then return alert_Error(tradeInfo.tradeData.players[player], 'trade_cancelled_title', 'trade_bagIsFull', player) end
	end

	for player, items in next, tradeInfo.tradeData.trading do
		for item, itemData in next, items do
			if checkItemAmount(item, itemData.amount, player) then
				if removeBagItem(item,  itemData.amount, player) then
					addItem(item, itemData.amount, tradeInfo.tradeData.players[player])
				end
			end
		end
		savedata(player)
	end
	local totalAmount = 0
	for player in next, tradeInfo.tradeData.trading do
		totalAmount = totalAmount + players[player].totalOfStoredItems.bag
	end

	for player in next, tradeInfo.tradeData.trading do
		if tradeInfo.tradeData.totalItems ~= totalAmount then
			players[player].bag = table_copy(tradeInfo.tradeData.bagBackup[player][1])
			players[player].totalOfStoredItems.bag = tradeInfo.tradeData.bagBackup[player][2]
			savedata(player)
			alert_Error(player, 'trade_title', 'trade_unknownItems')
		else
			alert_Error(player, 'trade_title', 'trade_success')
		end
	end
end

tradeSystem.new = function(player1, player2)
	for player, tradingWith in next, {[player1] = player2, [player2] = player1} do
		if players[player].isTrading then return alert_Error(tradingWith, 'trade_cancelled_title', 'trade_playerAlreadyTrading', player) end
		if players[player].holdingItem then return alert_Error(tradingWith, 'trade_cancelled_title', 'trade_playerUsingAnItem', player) end
		if not players[player].inRoom then return alert_Error(tradingWith, 'trade_cancelled_title', 'trade_playerLeftRoom', player) end
	end

	tradeID = #tradeSystem.trades+1
	tradeSystem.trades[tradeID] = {
		tradeData = {
			finished = false,
			confirmed = {
				[player1] = false, 
				[player2] = false,
			},
			players = {
				[player1] = player2, 
				[player2] = player1,
			},
			trading = {
				[player1] = {},
				[player2] = {},
			},
			totalItems = players[player1].totalOfStoredItems.bag + players[player2].totalOfStoredItems.bag,
			bagBackup = {
				[player1] = {table_copy(players[player1].bag), players[player1].totalOfStoredItems.bag},
				[player2] = {table_copy(players[player2].bag), players[player2].totalOfStoredItems.bag},
			},
			timer = nil,
		},
		groupImages	= {
			fixed = {},
			temporary = {},
		},
		playerImages = {
			[player1] = {},
			[player2] = {},
		},
	}
	local tradeInfo = tradeSystem.trades[tradeID]
	for player, tradingWith in next, {[player1] = player2, [player2] = player1} do
		players[player].isTrading = tradingWith
		players[player].tradeId = tradeID
		showTextArea(7100999, '', player, -5, -5, 805, 405, 1, 1, 0, true)
		tradeInfo.groupImages.fixed[#tradeInfo.groupImages.fixed+1] = addImage('17428377d34.png', ':50', 0, 0, player)
		tradeSystem.playerInterface(tradeInfo, player)
	end
end