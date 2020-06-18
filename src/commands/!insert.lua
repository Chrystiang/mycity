chatCommands.insert = {
	permissions = {'admin'},
	event = function(player, args)
		local item = args[1]
		local amount = tonumber(args[2]) or 1
		if not bagItems[item] then return end
		addItem(item, amount, player)
	end
}