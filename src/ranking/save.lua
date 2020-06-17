saveRanking = function()
	if ROOM.name:sub(1,2) == "*" then
		return
	elseif ROOM.uniquePlayers < room.requiredPlayers then
		return
	end
	local newRanking = {}
	local localRanking = table.copy(room.globalRanking)

	for i = #localRanking, 1, -1 do
        if ROOM.playerList[localRanking[i].name] then
			if players[localRanking[i].name].coins > 0 then
            	table.remove(localRanking, i)
			end
        end
    end
	for name in next, ROOM.playerList do
        if players[name] then
			if players[name].coins > 0 then
				local player = players[name]
				if player.seasonStats[1][1] == mainAssets.season then 
					if not table.contains(room.unranked, name) then
						localRanking[#localRanking+1] = {name = name, level = player.level[1], experience = player.seasonStats[1][2], commu = ROOM.playerList[name].community, id = ROOM.playerList[name].id}
					end
				end
			end
        end
    end
	table.sort(localRanking, function(a, b) return tonumber(a.experience) > tonumber(b.experience) end)

	if #localRanking > 10 then
        local len = #localRanking
        for i = len, 11, -1 do
            table.remove(localRanking, i)
        end
    end

	for _, player in next, localRanking do
        newRanking[#newRanking+1] = string.format('%s,%i,%i,%s,%i', player.name, player.level, player.experience, player.commu, player.id)
    end

	-------------------------------------------
	system.saveFile(table.concat(newRanking, ';'), 5)
end