chatCommands.givecar = {
	permissions = {'admin'},
	event = function(player, args)
		local target = string.nick(args[1])
		local carID = tonumber(args[2])
		if not players[target] then return TFM.chatMessage('<g>[•] $playerName not found.', player) end
		if not mainAssets.__cars[carID] then return TFM.chatMessage('<g>[•] Unknown Vehicle.', player) end

		giveCar(target, carID)
		TFM.chatMessage('<g>[•] Done! '..mainAssets.__cars[carID].name..' given to '..target..'.', player)
	end
}