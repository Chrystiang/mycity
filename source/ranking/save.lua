saveRanking = function()
	if room.event == 'christmas2020' then return end
	if ROOM.name:sub(1,2) == "*" then
		return
	elseif ROOM.uniquePlayers < room.requiredPlayers then
		return
	end
	local newRanking = {}
	local localRanking = table_copy(room.globalRanking)

	for i = #localRanking, 1, -1 do
		local name = localRanking[i].name
		if players[name] and players[name].inRoom and players[name].dataLoaded then
			table_remove(localRanking, i)
		end
	end
	for name in next, ROOM.playerList do
		local player = players[name]
		if player and player.inRoom and player.dataLoaded and player.level[1] >= 20 then
			if player.seasonStats[1][1] == mainAssets.season then
				if not table_find(room.unranked, name) then
					localRanking[#localRanking+1] = {name = name, level = player.level[1], experience = player.seasonStats[1][2], commu = player.lang, id = ROOM.playerList[name].id}
				end
			end
		end
	end
	table_sort(localRanking, function(a, b) return tonumber(a.experience) > tonumber(b.experience) end)

	if #localRanking > 20 then
		local len = #localRanking
		for i = len, 21, -1 do
			table_remove(localRanking, i)
		end
	end

	for _, player in next, localRanking do
		newRanking[#newRanking+1] = string.format('%s,%i,%i,%s,%i', player.name, player.level, player.experience, player.commu, player.id)
	end

	if mainAssets.season%2 == 0 then 
		saveFile(mainAssets.fileCopy._ranking..'|'..table_concat(newRanking, ';')..'|', 5)
	else
		saveFile(table_concat(newRanking, ';')..'|'..mainAssets.fileCopy._ranking..'|', 5)
	end
end