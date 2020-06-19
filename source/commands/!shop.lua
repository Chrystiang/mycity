chatCommands.shop = {
	permissions = {'admin'},
	event = function(player, args)
		showNPCShop(player, args[1])
	end
}