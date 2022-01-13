initialization.Places = function()
	for place, data in next, places do
		local placeToGo
		local placeToGoPosition
		for property, v in next, data do
			if property:find('tp_') then
				placeToGo = property:gsub('tp_', '')
				placeToGoPosition = v
				break
			end
		end

		if data.exitSensor then
			TouchSensor.add(
				0,
				data.exitSensor[1],
				data.exitSensor[2],
				data.id,
				0,
				false,
				0,
				function(player)
					if players[player].place == placeToGo then return end
					movePlayer(player, placeToGoPosition[1], placeToGoPosition[2], false)
					players[player].place = placeToGo

					checkIfPlayerIsDriving(player)
					if placeToGo == 'mine' or placeToGo == 'mine_excavation' then
						setNightMode(player, false)
					else
						setNightMode(player, true)
					end

					for i, v in next, players[player].questLocalData.other do
						if i:lower():find(players[player].place:lower()) and i:find('goTo') then
							quest_updateStep(player)
						end
					end
					if data.afterExit then
						data.afterExit(player)
					end
				end,
				true
			)
		end
	end
end