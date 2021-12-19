saveRanking = function()
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
		if player and player.inRoom and player.dataLoaded and player.level[1] >= 10 then
			if not table_find(room.unranked, name) then
				localRanking[#localRanking+1] = {name = name, level = player.level[1], gifts = player.jobs[21], commu = player.lang, id = ROOM.playerList[name].id}
			end
		end
	end
	table_sort(localRanking, function(a, b) return tonumber(a.gifts) > tonumber(b.gifts) end)

	if #localRanking > 20 then
		local len = #localRanking
		for i = len, 21, -1 do
			table_remove(localRanking, i)
		end
	end

	for _, player in next, localRanking do
		newRanking[#newRanking+1] = string.format('%s,%i,%i,%s,%i', player.name, player.level, player.gifts, player.commu, player.id)
	end

	saveFile(table_concat(newRanking, ';')..'|', 30)
end