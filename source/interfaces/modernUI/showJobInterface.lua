modernUI.jobInterface = function(self, job)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - 161/2)
	local y = (200 - 161/2) + 40
	local color = '#'..jobs[job].color
	showTextArea(id..'884', '<p align="center"><b><font color="#f4e0c5" size="14">'..translate(job, player), player, x+38, y-10, 110, 30, 0xff0000, 0xff0000, 0, true)

	local jobImage = jobs[job].icon
	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171d2f983ba.png', ":26", x+30, y-19, player)
	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(jobImage, ":27", x, y-20, player)

	return setmetatable(self, modernUI)
end