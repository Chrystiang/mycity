chatCommands.moveto = {
	permissions = {'admin', 'mod', 'helper'},
	event = function(player, args)
		local target = string.nick(args[1])
		if players[target] then --return TFM.chatMessage('<g>[•] $playerName not found.', player) end
			TFM.chatMessage('[•] teleporting to ['..target .. '] ('..players[target].place..')...', player)
			TFM.movePlayer(player, ROOM.playerList[target].x, ROOM.playerList[target].y, false)
			players[player].place = players[target].place
		elseif gameNpcs.characters[args[1]] then
			TFM.chatMessage('[•] teleporting to <v>[NPC]</v> '..args[1]..'...', player)
			TFM.movePlayer(player, gameNpcs.characters[args[1]].x+50, gameNpcs.characters[args[1]].y+50, false)
		else
			TFM.chatMessage('<g>[•] error $playerName not found.', player)
		end
	end
}