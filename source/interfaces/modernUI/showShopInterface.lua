modernUI.shopInterface = function(self, itemList)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) - 12
	local y = (200 - height/2)

	for i = 1, #itemList do 
		local item = bagItems[itemList[i]]
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage("1717eaef706.png", ":20", 288, y+65 + (i-1)*45, player) -- Background
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(item.png, ":21", 310, y+60 + (i-1)*45, player) -- Item Image
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage("1717ed9210a.png", ":22", 353, y+90 + (i-1)*45, player) -- Hunger Icon
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage("1717edcf98f.png", ":23", 353, y+80 + (i-1)*45, player) -- Energy Icon
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage("1717ee908e4.png", ":24", 430, y+85 + (i-1)*45, player) -- Coins Bar

		showTextArea(id..(900+(i-1)*5), string.format(translate('item_'..itemList[i], player).."\n<textformat leading='-2'><font size='10'><v>&nbsp;&nbsp;&nbsp;%s\n&nbsp;&nbsp;&nbsp;%s", item.power and item.power or 0, item.hunger and item.hunger or 0), player, 352, y+65 + (i-1)*45, nil, nil, 0xff0000, 0xff0000, 0, true)
		showTextArea(id..(901+(i-1)*5), '<b><p align="center"><font color="#54391e">$'..item.price, player, 430, y+86 + (i-1)*45, 50, nil, 0xff0000, 0xff0000, 0, true)

	end
	return setmetatable(self, modernUI)
end