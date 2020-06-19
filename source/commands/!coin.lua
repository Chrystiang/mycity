chatCommands.coin = {
	permissions = {'admin'},
	event = function(player, args)
		giveCoin(50000, player)
	end
}