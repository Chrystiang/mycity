TFM.movePlayer = function(player, ...)
	if not players[player].driving then
		eventTextAreaCallback(1, player, 'Fechar@101', true)
	end
	if players[player].place ~= 'mine_labyrinth' and players[player].place ~= 'mine_sewer' and players[player].place ~= 'mine_escavation' then
		setNightMode(player, true)
	end
	move(player, ...)
end

moveTo = function(name)
	local playerData = players[name]
	local playerInfo = ROOM.playerList[name]
	if not playerData.dataLoaded then return end
	local v = places[playerData.place]
	if not v then return end
	if checkGameHour(v.opened) or v.opened == '-' then
		if playerInfo.x > v.saida[1][1] and playerInfo.x < v.saida[1][2] and playerInfo.y > v.saida[2][1] and playerInfo.y < v.saida[2][2] then
			if v.saidaF(name) then 
				if players[name].place ~= 'bank' then 
					checkIfPlayerIsDriving(name)
					eventTextAreaCallback(0, name, 'close3_5', true)
					showOptions(name)
				end
			end
			return
		end
	end
end