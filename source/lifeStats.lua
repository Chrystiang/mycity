local lifeStatsIcons = {{'171653c0aa6.png', '17174d72c5e.png', '17174d81707.png'}, {'170f8acc9f4.png', '170f8ac976f.png', '170f8acf954.png'}}
showLifeStats = function(player, lifeStat)
	local playerInfos = players[player]
	if playerInfos.editingHouse then return end

	for i = 1, #playerInfos.lifeStatsImages[lifeStat].images do 
		removeImage(playerInfos.lifeStatsImages[lifeStat].images[i])
	end
	playerInfos.lifeStatsImages[lifeStat].images = {}
	local selectedImage = playerInfos.lifeStats[lifeStat] > 80 and 1 or playerInfos.lifeStats[lifeStat] > 40 and 2 or 3

	playerInfos.lifeStatsImages[lifeStat].images[#playerInfos.lifeStatsImages[lifeStat].images+1] = addImage(lifeStatsIcons[lifeStat][selectedImage], ":2", (lifeStat-1)*45, 365, player)
	if playerInfos.lifeStats[lifeStat] <= 0 then
		playerInfos.hospital.diseases[#playerInfos.hospital.diseases+1] = lifeStat
		loadHospital(player)
		checkIfPlayerIsDriving(player)
		hospitalize(player)
		loadHospitalFloor(player)
		players[player].lifeStats[lifeStat] = 0
	end
	showTextArea(999995-lifeStat*2, "<p align='center'><font color='#000000'>"..playerInfos.lifeStats[lifeStat], player, 11 + (lifeStat-1)*45, 386, 50, nil, 0x324650, 0x000000, 0, true)
	showTextArea(999994-lifeStat*2, "<p align='center'><font color='#ffffff'>"..playerInfos.lifeStats[lifeStat], player, 10 + (lifeStat-1)*45, 385, 50, nil, 0x324650, 0x000000, 0, true)
end

setLifeStat = function(player, lifeStat, quant)
	if not players[player].dataLoaded then return end
	players[player].lifeStats[lifeStat] = players[player].lifeStats[lifeStat] + quant 
	if players[player].lifeStats[lifeStat] > 100 then
		players[player].lifeStats[lifeStat] = 100
	end
	showLifeStats(player, lifeStat)
end

updateBarLife = function(player)
	local playerInfos = players[player]
	if not playerInfos then return end
	if playerInfos.hospital.hospitalized then return end
	if playerInfos.lifeStats[1] <= 94 and not playerInfos.robbery.robbing then
		setLifeStat(player, 1, playerInfos.place == 'cafe' and 3 or 2)
		if string_find(playerInfos.place, 'house_') then
			local house_ = playerInfos.place:sub(7)
			if playerInfos.houseData.houseid == house_ then
				setLifeStat(player, 1, 1)
			end
		end
	end
	setLifeStat(player, 2, -1) 
end