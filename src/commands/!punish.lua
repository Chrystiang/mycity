chatCommands.punish = {
	permissions = {'admin', 'mod', 'helper'},
	event = function(player, args)
		local target = string.nick(args[1])
		if not players[target] then return TFM.chatMessage('<g>[•] $playerName not found.', player) end
		TFM.chatMessage('[•] removing $100 from '..target..'...', player)
		giveCoin(-100, target)
	end
}