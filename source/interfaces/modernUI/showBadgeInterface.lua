modernUI.badgeInterface = function(self, badge)
	local id = self.id
	local player = self.player
	local x = (400 - 220/2)
	local y = (200 - 90/2) - 30

	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(badges[badge] and badges[badge].png, ":70", 385, 180, player)
	showTextArea(id..'890', '<p align="center"><i><v>'..translate('badgeDesc_'..badge, player), player, x+10, y+100, 200, nil, 0, 0x24474, 0, true)

	return setmetatable(self, modernUI)
end