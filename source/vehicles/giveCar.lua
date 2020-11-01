giveCar = function(player, car)
	if not mainAssets.__cars[car] then return alert_Error(player, 'error', 'Unknown Vehicle') end
	if table_find(players[player].cars, car) then return end
	players[player].cars[#players[player].cars+1] = car
	modernUI.new(player, 240, 220, translate('newCar', player), translate('unlockedCar', player))
	:build()
	:addConfirmButton(function() end, translate('confirmButton_Great', player))
	players[player]._modernUISelectedItemImages[1][#players[player]._modernUISelectedItemImages[1]+1] = addImage(mainAssets.__cars[car].icon, "&70", 349, 180, player)

	savedata(player)
end