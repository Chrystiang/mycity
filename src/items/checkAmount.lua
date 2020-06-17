checkItemQuanty = function(item, quant, player)
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