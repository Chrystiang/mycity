chatCommands.snow = {
	permissions = {'admin', 'mod', 'helper'},
	event = function(player, args)
		local duration = args[1] or 0
		local snowballPower = args[2] or 10
		TFM.snow(duration, snowballPower)
		TFM.chatMessage('<g>[•] Done! Snowing for '..duration..', snow ball power: '..snowballPower, player) 
	end
}