addItem = function(item, amount, player, coin, notify)
	local id = bagItems[item].id
	if not coin then coin = 0 end
	if players[player].coins < coin then return end

	for id, properties in next, players[player].questLocalData.other do 
		if id:find('ItemAmount_') then
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
	for i, v in next, players[player].bag do 
		if v.name == item then
			canAdd = i
		end
	end

	if notify then
		modernUI.new(player, 120, 120)
		:build()
		players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(bagItems[item].png, ":70", 400 - 50 * 0.5, 180, player)
	end

	if (players[player].totalOfStoredItems.bag + amount > players[player].bagLimit) and not players[player].trading then
		alert_Error(player, 'error', 'bagError')
		if coin == 0 then
			item_drop(item, player, amount)
		end
		return
	else
		players[player].totalOfStoredItems.bag = players[player].totalOfStoredItems.bag + amount
		if (players[player].totalOfStoredItems.bag + amount > players[player].bagLimit) and players[player].trading then
			modernUI.new(player, 240, 220, translate('warning', player), translate('bagTemporaryLimit', player):format(players[player].bagLimit), 'errorUI')
			:build()
		end
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
	local hasItem = false
	for i, v in next, players[player].bag do
		if v.name == item then
			if amount > v.qt then
				amount = v.qt
			end
			v.qt = v.qt - amount
			if v.qt <= 0 then
				table_remove(players[player].bag, i)
			end
			hasItem = true
			break
		end
	end
	if not hasItem then return false end

	players[player].totalOfStoredItems.bag = players[player].totalOfStoredItems.bag - amount
	savedata(player)
	
	return true
end