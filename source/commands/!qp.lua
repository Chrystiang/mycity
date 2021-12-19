chatCommands.qp = {
	permissions = {'admin'},
	event = function(player, args)
		local target = string_nick(args[2])
		local amount = tonumber(args[1]) or 0
		if not players[target] then return chatMessage('<g>[•] $playerName not found.', player) end
		giveDiamond(amount, target)
		savedata(target)
		chatMessage('<g>[•] Done! QP$'..amount..' set to '..target..'.', player)
	end
}