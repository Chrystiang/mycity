item_addToChest = function(item, amount, player, chest)
	if not chest then chest = 1 end
	players[player].totalOfStoredItems.chest[chest] = players[player].totalOfStoredItems.chest[chest] + amount
	for i, v in next, players[player].houseData.chests.storage[chest] do
		if v.name == item then
			v.qt = v.qt + amount
			return
		end
	end
	players[player].houseData.chests.storage[chest][#players[player].houseData.chests.storage[chest]+1] = {name = item, qt = amount}
end

item_removeFromChest = function(item, amount, player, chest)
	amount = abs(amount)
	if chest then
		for i, v in next, players[player].houseData.chests.storage[chest] do
			if v.name == item then
				v.qt = v.qt - amount
				if v.qt <= 0 then
					table_remove(players[player].houseData.chests.storage[chest], i)
				end
				break
			end
		end
		players[player].totalOfStoredItems.chest[chest] = players[player].totalOfStoredItems.chest[chest] - amount
	else
		local playerChests = players[player].houseData.chests.storage
		for chest = 1, #playerChests do
			local _amount = 0
			for i, v in next, playerChests[chest] do
				if v.name == item then
					_amount = _amount + v.qt
					table_remove(players[player].houseData.chests.storage[chest], i)
					break
				end
			end
			players[player].totalOfStoredItems.chest[chest] = players[player].totalOfStoredItems.chest[chest] - _amount
		end
	end
	savedata(player)
end