setNightMode = function(name, remove)
	if not players[name].isBlind and remove then return end

	setPlayerNightMode(name, not remove)
	players[name].isBlind = not remove
end