onEvent("FileLoaded", function(file, data)
	if tonumber(file) == 5 then -- RANKING
		local datas = {}
        for _data in string.gmatch(data, '[^%|]+') do
            datas[#datas+1] = _data
        end
		local rankData = datas[1] -- ranking
		room.globalRanking = {}

        if rankData then
            for name, level, experience, commu, id in string.gmatch(rankData, '([%w_+]+#%d+),(%d+),(%d+),(%w+),(%d+)') do
                room.globalRanking[#room.globalRanking+1] = {name = name, level = level, experience = experience, commu = commu, id = id}
            end
        end
		saveRanking()
		player_removeImages(room.rankingImages)
		loadRanking()
	end
end)