saveRanking = function()
	if ROOM.name:sub(1,2) == "*" then
		return
	elseif ROOM.uniquePlayers < room.requiredPlayers then
		return
	end
	local newRanking = {}
	local localRanking = table.copy(room.globalRanking)

	for i = #localRanking, 1, -1 do
		local name = localRanking[i].name
		if players[name] and players[name].inRoom and players[name].dataLoaded then
			table.remove(localRanking, i)
		end
	end
	for name in next, ROOM.playerList do
		local player = players[name]
		if player and player.inRoom and players[name].dataLoaded then
			if player.seasonStats[1][1] == mainAssets.season then
				if not table.contains(room.unranked, name) then
					localRanking[#localRanking+1] = {name = name, level = player.level[1], experience = player.seasonStats[1][2], commu = ROOM.playerList[name].language, id = ROOM.playerList[name].id}
				end
			end
		end
	end
	table.sort(localRanking, function(a, b) return tonumber(a.experience) > tonumber(b.experience) end)

	if #localRanking > 20 then
		local len = #localRanking
		for i = len, 21, -1 do
			table.remove(localRanking, i)
		end
	end

	for _, player in next, localRanking do
		newRanking[#newRanking+1] = string.format('%s,%i,%i,%s,%i', player.name, player.level, player.experience, player.commu, player.id)
	end

	-------------------------------------------
	--system.saveFile(table.concat(newRanking, ';')..'|'..mainAssets.fileCopy._ranking..'|', 5)
	system.saveFile(mainAssets.fileCopy._ranking..'|'..table.concat(newRanking, ';')..'|', 5)
end