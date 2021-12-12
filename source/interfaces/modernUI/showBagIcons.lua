modernUI.showBagIcons = function(self)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) + 12
	local y = (200 - height/2) + 40
	local i = 0

	for index, v in next, bagIcons do
		local isCurrentIcon = index == players[player].currentBagIcon
		players[player]._modernUISelectedItemImages[4][#players[player]._modernUISelectedItemImages[4]+1] = addImage(v, ":20", x + (i%5)*45, y + floor(i/5)*45, player, nil, nil, nil, isCurrentIcon and 1 or .3)
		if not isCurrentIcon then
			showTextArea(id..(900+i*5), string.rep('\n', 5), player, x + (i%5)*45, y + floor(i/5)*45, 40, 29, 0, 1, 0, true,
				function()
					eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
					players[player].currentBagIcon = index
					savedata(player)
					loadBackpackIcon(player)
				end)
		end
		i = i + 1
	end
	return setmetatable(self, modernUI)
end