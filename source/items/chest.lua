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
	amount = math.abs(amount)
	for i, v in next, players[player].houseData.chests.storage[chest] do
		if v.name == item then
			v.qt = v.qt - amount
			if v.qt <= 0 then
				table.remove(players[player].houseData.chests.storage[chest], i)
			end
			break
		end
	end
	players[player].totalOfStoredItems.chest[chest] = players[player].totalOfStoredItems.chest[chest] - amount
	savedata(player)
end