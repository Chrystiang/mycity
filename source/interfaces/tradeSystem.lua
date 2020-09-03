local tradeSystem = {
	trades = {},
}

greenButton = function(id, i, text, player, callback, x, y, width, height)
	local width = width or 180
	local height = height or 15
	ui.addTextArea(id..(930+i*5), '', player, x-1, y-1, width, height, 0x95d44d, 0x95d44d, 1, true)
	ui.addTextArea(id..(931+i*5), '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
	ui.addTextArea(id..(932+i*5), '', player, x, y, width, height, 0x44662c, 0x44662c, 1, true)
	ui.addTextArea(id..(933+i*5), '<p align="center"><font color="#cef1c3" size="13">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, callback)
end

tradeSystem.playerInterface = function(tradeInfo, player)
	tradeSystem.showPlayerItems(tradeInfo, player)
	greenButton(200, 0, translate('confirmButton_trade', player), player, 
		function()
			if tradeInfo.tradeData.finished then return end
			if tradeInfo.tradeData.confirmed[player] then return end
			local canFinish = true
			tradeInfo.tradeData.confirmed[player] = true
			for p, tradingWith in next, tradeInfo.tradeData.players do
				local x = p == player and 265 or 465
				local id = p == player and 950 or 948
				ui.addTextArea((200)..id, '', p, x, 115, 68, 200, 0x95d44d, 0x95d44d, 0.6, true)
				if not tradeInfo.tradeData.confirmed[p] then
					canFinish = false
				end
			end
			if canFinish then
				tradeInfo.tradeData.finished = true
				addTimer(function()
					tradeSystem.endTrade(tradeInfo)
					tradeSystem.confirmTrade(tradeInfo)
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
				--tradeInfo.tradeData.confirmed[player] = false
			end
		end, 
	372, 222, 60, 12)
end

tradeSystem.insertItem = function(tradeInfo, item, player)
	if tradeInfo.tradeData.finished then return end
	if not tradeInfo.tradeData.trading[player][item] then
		tradeInfo.tradeData.trading[player][item] = {amount = 1}
	else
		tradeInfo.tradeData.trading[player][item].amount = tradeInfo.tradeData.trading[player][item].amount + 1
	end

	local image = bagItems[item].png or '16bc368f352.png'
	local y = 72

	for i, v in next, tradeInfo.tradeData.trading[player] do
		y = y + 48
	end

	for p, tradingWith in next, tradeInfo.tradeData.players do
		local x = p == player and 277 or 477
		tradeInfo.groupImages.temporary[#tradeInfo.groupImages.temporary+1] = addImage('174280ced34.jpg', ':50', x, y, p)
		tradeInfo.groupImages.temporary[#tradeInfo.groupImages.temporary+1] = addImage(image, ':50', x-2, y, p)
	end
end

tradeSystem.showPlayerItems = function(tradeInfo, player)
	local items = table.copy(players[player].bag)

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
			local image = bagItems[v.name].png or '16bc368f352.png'

			tradeInfo.playerImages[player][#tradeInfo.playerImages[player]+1] = addImage('174283c22c9.jpg', ":26", x + ((i-1)%4)*43, y + math.floor((i-1)/4)*43, player)
			tradeInfo.playerImages[player][#tradeInfo.playerImages[player]+1] = addImage(image, ":26", x - 5 + ((i-1)%4)*43, y - 5 + math.floor((i-1)/4)*43, player)
			ui.addTextArea(id..(800+i*2), '<p align="right"><font color="#95d44d" size="10"><b>x'..v.qt, player, x + ((i-1)%4)*43, y + 24 + math.floor((i-1)/4)*43, 40, nil, 0xff0000, 0xff0000, 0, true)
			ui.addTextArea(id..(801+i*2), '\n\n\n\n', player, x + ((i-1)%4)*43, y + math.floor((i-1)/4)*43, 40, 40, 0xff0000, 0xff0000, 0, true,
				function()
					if v.qt <= 0 or tradeInfo.tradeData.confirmed[player] then return end
					v.qt = v.qt - 1
					tradeSystem.insertItem(tradeInfo, v.name, player)
					ui.updateTextArea(id..(800+i*2), '<p align="right"><font color="#95d44d" size="10"><b>x'..v.qt, player)
				end
			)
		end
	end
end

tradeSystem.endTrade = function(tradeInfo, cancelled)
	tradeInfo.tradeData.finished = true
	player_removeImages(tradeInfo.groupImages.fixed)
	player_removeImages(tradeInfo.groupImages.temporary)
	for player, v in next, tradeInfo.playerImages do
		player_removeImages(v)
		for i = 800, 950 do
			ui.removeTextArea((200)..i, player)
		end
		if cancelled and cancelled ~= player then
			alert_Error(player, 'trade_cancelled_title', 'trade_cancelled', cancelled)
		end
	end
end

tradeSystem.confirmTrade = function(tradeInfo)
	for player, items in next, tradeInfo.tradeData.trading do
		for item, itemData in next, items do
			removeBagItem(item,  itemData.amount, player)
			addItem(item, itemData.amount, tradeInfo.tradeData.players[player])
		end
	end
end

tradeSystem.new = function(player1, player2)
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
	-- Looping 2 elements in Transformice are heavier than simply duplicating the content of the loop
	tradeInfo.groupImages.fixed[#tradeInfo.groupImages.fixed+1] = addImage('17428377d34.png', ':50', 0, 0, player1)
	tradeInfo.groupImages.fixed[#tradeInfo.groupImages.fixed+1] = addImage('17428377d34.png', ':50', 0, 0, player2)

	tradeSystem.playerInterface(tradeInfo, player1)
	tradeSystem.playerInterface(tradeInfo, player2)
end