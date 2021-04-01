hospitalize = function(player)
	setNightMode(player, true)
	giveCoin(-600 * #players[player].hospital.diseases, player)
	if players[player].hospital.hospitalized then return end
	for i = 1, 4 do
		for x = 1, 2 do
			if not room.hospital[i][x].name then
				local pos = {100, 700}
				room.hospital[i][x].name = player
				players[player].hospital.hospitalized = true
				players[player].hospital.currentFloor = i
				freezePlayer(player, true)
				movePlayer(player, ((i-1)%i)*900+4000+pos[x], 3200, false)
				closeInterface(player, nil, nil, nil, nil, nil, true)
				players[player].timer = addTimer(function(j) local time = 60 - j
					if time > 0 then
						showTextArea(98900000000, "<b><font color='#371616'><p align='center'>"..translate('healing', player):format(time), player, 250, 368, 290, 20, 0x1, 0x1, 0, true)
					else
						for i, v in next, players[player].hospital.diseases do
							setLifeStat(player, v, 60)
						end
						players[player].hospital.diseases = {}
						players[player].hospital.hospitalized = false
						showOptions(player)
						freezePlayer(player, false)
						savedata(player)
						room.hospital[i][x].name = nil
						if x == 1 then
							showTextArea(8888805, '', nil, ((i-1)%i)*900+3+4000, 4+3000, 287, 249, 0x1, 0x1, 0.5)
						else
							showTextArea(8888806, '', nil, ((i-1)%i)*900+510+4000, 4+3000, 287, 249, 0x1, 0x1, 0.5)
						end
					end
				end, 1000, 60)
				removeTextArea(8888804+x)
				return
			end
		end
	end
end