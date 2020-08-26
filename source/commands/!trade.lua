chatCommands.trade = {
	permissions = {'admin'},
	event = function(player, args)
		local player1 = string.nick(args[1]) or player
		local player2 = string.nick(args[2])
		if not player2 then return end

		modernUI.new(player2, 240, 170, translate('trade_invite_title', player2), translate('trade_invite', player2):format(player1))
		:build()
		:addConfirmButton(function(player2) 
			tradeSystem.new(player1, player2)
		end, translate('submit', player2), player1)
	end
}