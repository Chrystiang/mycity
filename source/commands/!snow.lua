chatCommands.snow = {
	permissions = {'admin', 'mod', 'helper'},
	event = function(player, args)
		local duration = tonumber(args[1]) or 0
		if duration > 0 then
			TFM.snow(duration, snowballPower)
			TFM.chatMessage('<g>[•] Done! Snowing for '..duration.., player)
		else
			TFM.chatMessage('<g>[•] Invalid syntax', player)
		end
	end
}
