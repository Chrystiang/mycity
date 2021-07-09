onEvent("Mouse", function(player, x, y)
	if player and isExploiting[player] then return end
	movePlayer(player, x, y, false)
	chatMessage('X: '..x..', Y: '..y, player)
end)