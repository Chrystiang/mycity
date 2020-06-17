checkLocation_isInHouse = function(player)
	if not players[player] then return false end
	local id = tonumber(players[player].houseData.houseid)
	local house = tonumber(players[player].place:sub(7))
	if id == house then 
		return true
	end
	return false
end