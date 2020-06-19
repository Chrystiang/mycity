chatCommands.place = {
	permissions = {'admin', 'mod', 'helper'},
	event = function(player, args)
		if places[args[1]] then
			places[args[1]].saidaF(player)
		end
	end
}