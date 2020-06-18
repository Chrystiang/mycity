chatCommands.place = {
	permissions = {'admin', 'helper'},
	event = function(player, args)
		if places[args[1]] then
			places[args[1]].saidaF(player)
		end
	end
}