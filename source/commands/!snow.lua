chatCommands.snow = {
	permissions = {'admin', 'mod', 'helper'},
	event = function(player, args)
		local duration = tonumber(args[1]) or 0
		local snowballPower = tonumber(args[2]) or 0
		
		TFM.snow(duration, snowballPower)
		chatMessage('<g>[•] Done! Snowing for '..duration..' seconds', player)
	end
}