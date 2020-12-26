item_getDescription = function(item, player, isFurniture)
	local itemData = isFurniture and mainAssets.__furnitures[item] or bagItems[item]
	local description = lang.en['itemDesc_'..item] and '<p align="center"><i>"'..translate('itemDesc_'..item, player)..'"</i><v><p align="left">\n' or '<v>'
	local isLimitedTime = itemData.limitedTime
	local isOutOfSale = isLimitedTime and formatDaysRemaining(isLimitedTime, true)

	if not isFurniture then
		local itemType = itemData.type
		local power = itemData.power or 0
		local hunger = itemData.hunger or 0	
		if itemType == 'complementItem' then
			description = '<p align="center"><i>"'..translate('itemDesc_'..item, player):format(itemData.complement)..'"</i><v><p align="left">\n'
		end
		if itemType == 'food' then 
			description = description ..string.format(translate('energyInfo', player) ..'\n'.. translate('hungerInfo', player)..'\n', '<vp>'..power..'</vp>', '<vp>'..hunger..'</vp>')
		elseif itemData.miningPower then 
			description = description .. translate('itemInfo_miningPower', player):format('<vp>0</vp>')
		elseif item:find('Seed') and not isFurniture then 
			local txt = translate('itemInfo_Seed', player)
			for i, v in next, HouseSystem.plants do
				if v.name:find(item:gsub('Seed', '')) then 
					txt = txt:format((v.growingTime * (#v.stages-2)/60), v.pricePerSeed)..'\n'
					break
				end
			end
			description = description .. txt
		end
		if itemData.sellingPrice then
			description = description .. translate('itemInfo_sellingPrice', player):format('<vp>$'..itemData.sellingPrice..'</vp>')..'\n'
		end
	end
	if itemData.credits then
		description = description ..translate('createdBy', player):format('<cs>'..itemData.credits..'</cs>')..'\n'
	end

	if isLimitedTime then
		description = description ..'\n<p align="center"><font size="9"><r>'..translate('collectorItem', player)
	end

	return description
end