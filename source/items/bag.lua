addItem = function(item, amount, player, coin)
	local id = bagItems[item].id
	if not coin then coin = 0 end
	if players[player].coins < coin then return end

	for id, properties in next, players[player].questLocalData.other do 
		if id:find('ItemQuanty_') then
			if id:lower():find(item:lower()) then 
				if type(properties) == 'boolean' then 
					quest_updateStep(player)
				else 
					players[player].questLocalData.other[id] = properties - 1
					if players[player].questLocalData.other[id] <= 0 then 
						quest_updateStep(player)
					end
				end
				break
			end
		end
	end
	local canAdd = false
	players[player].totalOfStoredItems.bag = 0
	for i, v in next, players[player].bag do 
		players[player].totalOfStoredItems.bag = players[player].totalOfStoredItems.bag + v.qt
		if v.name == item then
			canAdd = i
		end
	end

	if players[player].totalOfStoredItems.bag + amount > players[player].bagLimit then
		alert_Error(player, 'error', 'bagError')
		if coin == 0 then
			item_drop(item, player, amount)
		end
		return
	else
		players[player].totalOfStoredItems.bag = players[player].totalOfStoredItems.bag + amount
	end
	if canAdd then 
		players[player].bag[canAdd].qt = players[player].bag[canAdd].qt + amount
		giveCoin(-coin, player)
		return
	end

	players[player].bag[#players[player].bag+1] = {name = item, qt = amount}
	giveCoin(-coin, player)
end

removeBagItem = function(item, amount, player)
	amount = math.abs(amount)
	for i, v in next, players[player].bag do
		if v.name == item then
			v.qt = v.qt - amount
			if v.qt <= 0 then
				table.remove(players[player].bag, i)
			end
			break
		end
	end
	players[player].totalOfStoredItems.bag = players[player].totalOfStoredItems.bag - amount
	savedata(player)
end