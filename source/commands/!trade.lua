chatCommands.trade = {
	permissions = {'admin'},
	event = function(player, args)
		local player1 = string_nick(args[1]) or player
		local player2 = string_nick(args[2])
		if not player2 then return end
		tradeSystem.invite(player1, player2)
	end
}