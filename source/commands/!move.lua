chatCommands.move = {
	permissions = {'admin', 'mod', 'helper'},
	event = function(player, args)
		if not args[1] or not args[2] then return end
		local target1 = string_nick(args[1]) or ''
		local target2 = string_nick(args[2])
		local originalName = args[2]
		if not target2 then
			target2 = target1
			target1 = player
			originalName = args[1]
		end
		if players[target1] then
			if gameNpcs.characters[originalName] then
				local _place = gameNpcs.characters[originalName].place or 'town'
				chatMessage('[•] teleporting to <v>[NPC]</v> '..originalName..' ('.._place..')...', player)
				movePlayer(player, gameNpcs.characters[originalName].x+50, gameNpcs.characters[originalName].y+50, false)
				players[target1].place = _place
			elseif players[target2] then
				chatMessage('[•] ['..target1 .. '] teleporting to ['.. target2 ..'] ('..players[target2].place..')...', player)
				movePlayer(target1, ROOM.playerList[target2].x, ROOM.playerList[target2].y, false)
				players[target1].place = players[target2].place
			else
				chatMessage('<g>[•] $playerName not found. ('..target2..')', player)
			end
		else
			chatMessage('<g>[•] $playerName not found. ('..target1..')', player)
		end
	end
}