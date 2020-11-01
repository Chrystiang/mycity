local playerFinder = {
	requests = {}
}

playerFinder.checkIfIsOnline = function(target, fn)
	if ROOM.playerList[target] then return fn() end
	playerFinder.requests[target] = fn
	loadPlayerData(target)
end