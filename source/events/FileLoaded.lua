onEvent("FileLoaded", function(file, data)
	local datas = {}
	for _data in string.gmatch(data, '[^%|]+') do
		datas[#datas+1] = _data
	end

	if tonumber(file) == 5 then -- RANKING
		mainAssets.fileCopy._ranking = datas[2]
		local rankData = datas[1]
		room.globalRanking = {}

		if rankData then
			for name, level, experience, commu, id in string.gmatch(rankData, '([%w_+]+#%d+),(%d+),(%d+),(%w+),(%d+)') do
				room.globalRanking[#room.globalRanking+1] = {name = name, level = level, experience = experience, commu = commu, id = id}
			end
		end
		saveRanking()
		removeGroupImages(room.rankingImages)
		loadRanking()

	elseif tonumber(file) == 1 then
		local bannedPlayers = datas[1] or table_concat(room.bannedPlayers, ';')
		local unrankedPlayers = datas[2] or table_concat(room.unranked, ';')
		local admin = datas[3] or ''
		local mod = datas[4] or ''
		local helper = datas[5] or ''
		local moduleTeam = datas[6] or ''

		room.bannedPlayers = {}
		for player in string.gmatch(bannedPlayers, '([%w_+]+#%d+),(%w+)') do
			room.bannedPlayers[#room.bannedPlayers+1] = player
			if players[player] then
				killPlayer(player)
			end
		end

		room.unranked = {}
		for player in string.gmatch(unrankedPlayers, '([%w_+]+#%d+),(%w+)') do
			room.unranked[#room.unranked+1] = player
		end

		for index, role in next, {admin, mod, helper, moduleTeam} do
			local _role = (index == 1 and 'admin') or (index == 2 and 'mod') or (index == 3 and 'helper') or 'moduleTeam'
			mainAssets.roles[_role] = {}
			for player in string.gmatch(role, '([%w_+]+#%d+)') do
				mainAssets.roles[_role][#mainAssets.roles[_role]+1] = player
			end
		end
	end
end)