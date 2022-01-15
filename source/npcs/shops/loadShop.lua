showNPCShop = function(player, npc)
	npc = npc:lower()
	if not npcsStores.shops[npc] then return alert_Error(player, 'error', 'nonexistentShop') end
	modernUI.new(player, 520, 300)
	:build()
	:showNPCShop(npcsStores.shops[npc], npc)
end

buildNpcsShopItems = function()
	for npc in next, npcsStores.shops do
		local newFormat = {}
		for i, k in next, npcsStores.items do
			local v = type(k) == 'table' and k or bagItems[k]
			if v and (not v.limitedTime or not formatDaysRemaining(v.limitedTime, true)) then
				if npc ~= 'chrystian' then
					if v.npcShop and v.npcShop:find(npc) then
						newFormat[#newFormat+1] = {i, k}
					end
				else
					if not v.npcShop and not v.qpPrice and mainAssets.__furnitures[i] then
						newFormat[#newFormat+1] = {i, k}
					end
				end
			end
			if npc == 'all' then
				newFormat[#newFormat+1] = {i, k}
			end
		end
		npcsStores.shops[npc] = newFormat
	end
end

checkIfPlayerHasFurniture = function(player, furniture)
	for _, v in next, players[player].houseData.furnitures.placed[players[player].houseData.currentSaveSlot] do
		if v.type == furniture then
			return true
		end
	end
	for _, v in next, players[player].houseData.furnitures.stored do
		if v.type == furniture then
			return true
		end
	end
	return false
end

mergeItemsWithFurnitures = function(t1, t2) -- Merge bag items with furnitures
	local newTbl = table_copy(t1)
	for i, v in next, t2 do
		newTbl[i+1000] = v.n
	end
	return newTbl
end