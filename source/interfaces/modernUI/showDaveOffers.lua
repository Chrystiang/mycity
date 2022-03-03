modernUI.showDaveOffers = function(self)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) - 12
	local y = (200 - height/2) - 20

	for i, offerID in next, daveOffers do 
		local offer = mainAssets.__farmOffers[offerID]

		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage("1717eaef706.png", "~20", 288, y+65 + (i-1)*45, player) -- Background

		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('1717f0a6947.png', "~21",	315, y+66 + (i-1)*45, player) -- Item background1
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(bagItems[offer.requires[1]].png, "~22",	310, y+60 + (i-1)*45, player) -- Required Item Image

		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171830fd281.png', "~25",	377, y+70 + (i-1)*45, player) -- Arrow

		showTextArea(id..(900+(i-1)*3), '<p align="right"><b><font size="9"><j>x<font size="12"><vp>'..offer.item[2], player, 447, y+86 + (i-1)*45, 30, nil, 0xff0000, 0xff0000, 0, true)

		if checkItemAmount(offer.requires[1], offer.requires[2], player) then
			showTextArea(id..(901+(i-1)*3), '<p align="right"><b><font size="9"><j>x<font size="12"><vp>'..offer.requires[2], player, 322, y+86 + (i-1)*45, 30, nil, 0xff0000, 0xff0000, 0, true)
			showTextArea(id..(902+(i-1)*3), "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', 5), player, 320, y+65 + (i-1)*45, 155, 40, 0xff0000, 0xff0000, 0, true,
				function()
					if not checkItemAmount(offer.requires[1], offer.requires[2], player) then return end
					removeBagItem(offer.requires[1], offer.requires[2], player)
					addItem(offer.item[1], offer.item[2], player)
					sideQuest_sendTrigger(player, "trade_with_dave", 1)
					chatMessage('<j>'..translate('transferedItem', player):format('<vp>'..translate('item_'..offer.item[1], player)..' <fc>('..offer.item[2]..')</fc></vp>'), player)
					eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
				end)
		else
			showTextArea(id..(901+(i-1)*3), '<p align="right"><b><font size="9"><j>x<font size="12"><r>'..offer.requires[2], player, 322, y+86 + (i-1)*45, 30, nil, 0xff0000, 0xff0000, 0, true)
			players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage("1717eaef706.png", "~30", 288, y+65 + (i-1)*45, player)
		end
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('1717f0a6947.png', "~23",	440, y+66 + (i-1)*45, player) -- Item background1
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(bagItems[offer.item[1]].png, "~24",	435, y+60 + (i-1)*45, player) -- Final Item Image
	end
	return setmetatable(self, modernUI)
end