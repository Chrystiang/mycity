modernUI.showLevelOrb = function(self)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) + 12
	local y = (200 - height/2) + 40
	local i = 0

	for _, v in next, players[player].starIcons.owned do
		local isCurrentOrb = v == players[player].starIcons.selected
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(mainAssets.levelIcons.star[v], "~20", x + (i%5)*57, y + floor(i/5)*57, player, nil, nil, nil, isCurrentOrb and 1 or .3)
		if not isCurrentOrb then
			showTextArea(id..(900+i*5), string.rep('\n', 5), player, x + (i%5)*57, y + floor(i/5)*40, 57, 57, 0, 0, 0, true,
				function()
					eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
					players[player].starIcons.selected = v
					savedata(player)
					local level = players[player].level[1]
					for i, v in next, ROOM.playerList do
						generateLevelImage(player, level, i)
					end
				end)
		end
		i = i + 1
	end
	return setmetatable(self, modernUI)
end