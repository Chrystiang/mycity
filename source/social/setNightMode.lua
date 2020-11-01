setNightMode = function(name, remove)
	if not players[name].isBlind and remove then return end
	if not remove then 
		players[name].isBlind = {}
		players[name].isBlind[#players[name].isBlind+1] = addImage("1721ee7d5b9.png", '$'..name, -800, -400, name)
		showTextArea(1051040, '', name, 800, 8400, 400, 700, 0x1, 0x1, 1)
	else
		removeGroupImages(players[name].isBlind)
		removeTextArea(1051040, name)
		players[name].isBlind = false
	end
end