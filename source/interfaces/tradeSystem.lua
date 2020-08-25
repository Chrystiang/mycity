local tradeSystem = {
	trades = {},
}

tradeSystem.updateGroupInterface = function(tradeID)
end

tradeSystem.playerInterface = function(tradeID, player)
	tradeSystem.showPlayerItems(tradeID, player)
end

tradeSystem.showPlayerItems = function(tradeID, player)
	local tradeInfo = tradeSystem.trades[tradeID]
	local items = players[player].bag

	local currentPage = 1
	local maxPages = math.ceil(#items/12)
	local minn = 12 * (currentPage-1) + 1
	local maxx = currentPage * 12

	local x, y = 50, 100
	for _ = 1, #items do 
		i = i + 1
		local v = items[_]
		if i >= minn and i <= maxx then
			local i = i - 12 * (currentPage-1)
			local image = bagItems[v.name].png or '16bc368f352.png'

			tradeInfo.playerImages[player][#tradeInfo.playerImages[player]+1] = addImage('1722d2d8234.jpg', ":26", x + ((i-1)%3)*63, y + math.floor((i-1)/3)*65, player)
			tradeInfo.playerImages[player][#tradeInfo.playerImages[player]+1] = addImage(image, ":26", x + 5 + ((i-1)%3)*63, y + 5 + math.floor((i-1)/3)*65, player)
			ui.addTextArea(id..(895+i*2), '<p align="right"><font color="#95d44d" size="13"><b>x'..v.qt, player, x + 5 + ((i-1)%3)*63, y + 42 + math.floor((i-1)/3)*65, 55, nil, 0xff0000, 0xff0000, 0, true)
			ui.addTextArea(id..(896+i*2), '\n\n\n\n', player, x + 3 + ((i-1)%3)*63, y + 3 + math.floor((i-1)/3)*65, 55, 55, 0xff0000, 0xff0000, 0, true,
				function(player)
		
				end
			)
		end
	end
end

tradeSystem.endTrade = function(tradeID)
end

tradeSystem.confirmTrade = function(tradeID)
end

tradeSystem.addGroupImages = function(tradeID, image, x, y)
	local tradeInfo = tradeSystem.trades[tradeID]
	-- Looping 2 elements in Transformice are heavier than simply duplicating the content of the loop
	tradeInfo.groupImages[#tradeInfo.groupImages+1] = addImage(image, x, y, ':50', tradeInfo.tradeData.players[1])
	tradeInfo.groupImages[#tradeInfo.groupImages+1] = addImage(image, x, y, ':50', tradeInfo.tradeData.players[2])
end

tradeSystem.init = function(player1, player2)
	tradeID = #tradeSystem.trades+1
	tradeSystem.trades[tradeID] = {
		tradeData = {
			finished = false,
			players = {player1, player2}
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
	tradeInfo.groupImages.fixed[#tradeInfo.groupImages.fixed+1] = addImage('17427299c6e.png', 0, 0, ':50', player1)
	tradeInfo.groupImages.fixed[#tradeInfo.groupImages.fixed+1] = addImage('17427299c6e.png', 0, 0, ':50', player2)

	tradeSystem.playerInterface(tradeID, player1)
	tradeSystem.playerInterface(tradeID, player2)
end