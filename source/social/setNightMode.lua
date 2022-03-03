setNightMode = function(name, remove)
	if not players[name].isBlind and remove then return end
	if not remove then
		setPlayerNightMode(name, true)
		showTextArea(1051040, '', name, 800, 8400, 400, 700, 0x1, 0x1, 1)
		players[name].isBlind = true
	else
		setPlayerNightMode(name, false)
		removeTextArea(1051040, name)
		players[name].isBlind = false
	end
end