modernUI.showMill = function(self)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) - 12
	local y = (200 - height/2)

	for i = 1, 3 do
		local amount = i > 1 and i*i or i
		local amount2 = amount*5

		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage("1717eaef706.png", ":20", 288, y+65 + (i-1)*45, player) -- Background

		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('1717f0a6947.png', ":21", 315, y+66 + (i-1)*45, player) -- Item background1
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(bagItems.wheat.png, ":22", 310, y+60 + (i-1)*45, player) -- Required Item Image

		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171830fd281.png', ":25", 377, y+70 + (i-1)*45, player) -- Arrow

		showTextArea(id..(900+(i-1)*3), '<p align="right"><b><font size="9"><j>x<font size="12"><vp>'..amount, player, 447, y+86 + (i-1)*45, 30, nil, 0xff0000, 0xff0000, 0, true)

		if checkItemAmount('wheat', amount2, player) then
			showTextArea(id..(901+(i-1)*3), '<p align="right"><b><font size="9"><j>x<font size="12"><vp>'..amount2, player, 322, y+86 + (i-1)*45, 30, nil, 0xff0000, 0xff0000, 0, true)
			showTextArea(id..(902+(i-1)*3), "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', 5), player, 320, y+65 + (i-1)*45, 155, 40, 0xff0000, 0xff0000, 0, true,
				function()
					if not checkItemAmount('wheat', amount2, player) then return end
					removeBagItem('wheat', amount2, player)
					addItem('wheatFlour', amount, player)
					chatMessage('<j>'..translate('transferedItem', player):format('<vp>'..translate('item_wheatFlour', player)..' <fc>('..amount..')</fc></vp>'), player)
					eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
				end)
		else
			showTextArea(id..(901+(i-1)*3), '<p align="right"><b><font size="9"><j>x<font size="12"><r>'..amount2, player, 322, y+86 + (i-1)*45, 30, nil, 0xff0000, 0xff0000, 0, true)
			players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage("1717eaef706.png", ":30", 288, y+65 + (i-1)*45, player)
		end
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('1717f0a6947.png', ":23", 440, y+66 + (i-1)*45, player) -- Item background1
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(bagItems.wheatFlour.png, ":24",	435, y+60 + (i-1)*45, player) -- Final Item Image
	end
	return setmetatable(self, modernUI)
end