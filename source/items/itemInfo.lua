item_getDescription = function(item, player, isFurniture)
	local itemData = isFurniture and mainAssets.__furnitures[item] or bagItems[item]
	local description = lang.en['itemDesc_'..item] and '<p align="center"><i>"'..translate('itemDesc_'..item, player)..'"</i><v><p align="left">\n' or ''
	if not isFurniture then
		local itemType = itemData.type
		local power = itemData.power or 0
		local hunger = itemData.hunger or 0	
		if itemType == 'complementItem' then
			description = '<p align="center"><i>"'..translate('itemDesc_'..item, player):format(itemData.complement)..'"</i><v><p align="left">\n'
		end
		if itemType == 'food' then 
			description = description .. '<font size="10"><v>'..string.format(translate('energyInfo', player) ..'\n'.. translate('hungerInfo', player), '<vp>'..power..'</vp>', '<vp>'..hunger..'</vp>')
		elseif itemData.miningPower then 
			description = description .. translate('itemInfo_miningPower', player):format('<vp>0</vp>')
		elseif item:find('Seed') and not isFurniture then 
			local txt = translate('itemInfo_Seed', player)
			for i, v in next, houseTerrainsAdd.plants do 
				if item:lower():find(v.name:lower()) then 
					txt = txt:format((v.growingTime * (#v.stages-2)/60), v.pricePerSeed)..'\n'
					break
				end
			end
			description = description .. txt
		end
	end
	if itemData.credits then
		description = description ..translate('createdBy', player):format('<v>'..itemData.credits)..'\n'
	end
	return description
end

loadExtraItemInfo = function(v, player)
	if players[player].selectedItem.images[1] then
		for i, v in next, players[player].selectedItem.images do
			removeImage(players[player].selectedItem.images[i])
		end
		players[player].selectedItem.images = {}
	end
	if v.limitedTime then
		if not formatDaysRemaining(v.limitedTime, true) then
			ui.addTextArea(99079, '<font size="9"><r>'..translate('daysLeft', player):format(formatDaysRemaining(v.limitedTime)), player, 525, 200, nil, nil, 0xff0000, 0xff0000, 0, true)
			players[player].selectedItem.images[#players[player].selectedItem.images+1] = addImage('16ddbab9690.png', "&70",	510, 198, player)
		else
			ui.addTextArea(99079, '<font size="9"><r><p align="center">'..translate('collectorItem', player), player, 500, 200, 110, nil, 0xff0000, 0xff0000, 0, true)
		end
	end
end