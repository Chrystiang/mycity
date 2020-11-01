onEvent("Mouse", function(player, x, y)
	movePlayer(player, x, y, false)
	chatMessage('X: '..x..', Y: '..y, player)
end)