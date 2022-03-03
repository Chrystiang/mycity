modernUI.showNewLevelOrb = function(self, orb)
	local id = self.id
	local player = self.player
	local x = (400 - 220/2)
	local y = (200 - 90/2) - 30

	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(mainAssets.levelIcons.star[orb], "~70", 370, 145, player)
	showTextArea(id..'890', '<p align="center"><vp>'..translate('newLevelOrb_info', player), player, x+10, y+90, 200, nil, 0, 0x24474, 0, true)

	return setmetatable(self, modernUI)
end
