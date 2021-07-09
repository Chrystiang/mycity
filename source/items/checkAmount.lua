checkItemAmount = function(item, quant, player)
	if not players[player].bag then return end
	if #players[player].bag == 0 then return false end
	for i, v in next, players[player].bag do
		if v.name == item then
			if v.qt >= quant then
				return v.qt
			end
		end
	end
	return false
end

checkItemInChest = function(item, quant, player)
	local playerChests = players[player].houseData.chests.storage
	local amount = 0
	for chest = 1, #playerChests do
		for i, v in next, playerChests[chest] do
			if v.name == item then
				amount = amount + v.qt
			end
		end
	end
	if amount >= quant then
		return amount
	end
	return false
end