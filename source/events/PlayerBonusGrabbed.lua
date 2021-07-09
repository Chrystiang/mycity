onEvent('PlayerBonusGrabbed', function(player, bonusId)
	if player and isExploiting[player] then return end
	TouchSensor.triggered(player, bonusId)
end)