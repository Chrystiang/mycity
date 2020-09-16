loadRanking = function(player)
	local minn = 1
	local maxx = 10

	local playerList = {}
	local playerLevel = {{}, {}}
	local playerExperience = {{}, {}}

	local color = ''
	local xAlign = 3710
	local yAlign = 7480

	for i = minn, maxx do
		if not room.globalRanking[i] then break end
		local name = room.globalRanking[i].name
		local level = room.globalRanking[i].level
		local experience = room.globalRanking[i].experience
		local commu = room.globalRanking[i].commu
		if not room.globalRanking[i].commu then
			room.globalRanking[i].commu = 'xx'
		end
		if i == 1 then
			color = '#FFD700'
		elseif i == 2 then
			color = '#c9c9c9'
		elseif i == 3 then
			color = '#A0522D'
		else
			color = '#BEBEBE'
		end

		playerList[#playerList+1] = '<font size="10" color="'..color..'">'..i..'. <font color="#000000">' .. name
		playerLevel[2][#playerLevel[2]+1] = '<p align="right"><font size="10"><cs>'.. level
		playerLevel[1][#playerLevel[1]+1] = '<p align="right"><font size="10" color="#000000">'.. level

		playerExperience[2][#playerExperience[2]+1] = '<p align="right"><font size="10"><vp>'.. experience ..'xp'
		playerExperience[1][#playerExperience[1]+1] = '<p align="right"><font size="10" color="#2F692F">'.. experience ..'xp'

		room.rankingImages[#room.rankingImages+1] = addImage('1711870c79c.jpg', '?1000', 95 + xAlign, (i-1)*12+102 + yAlign, player)
		room.rankingImages[#room.rankingImages+1] = addImage((community[commu] and community[commu] or community['xx']), '?1001', 109 + xAlign, (i-1)*12+102 + yAlign, player)
		room.rankingImages[#room.rankingImages+1] = addImage('173f47ce384.png', '?1002', 97 + xAlign, (i-1)*12+103 + yAlign, player)
		playerFinder.checkIfIsOnline(name, 
				function()
					room.rankingImages[#room.rankingImages+1] = addImage('173f47cffe1.png', '?1002', 97 + xAlign, (i-1)*12+103 + yAlign, player)
				end
			)
	end
	if not room.globalRanking[1] then
		playerList[#playerList+1] = '\n\nConnecting...'
	end

	ui.addTextArea(5432, table.concat(playerList, '\n'), player, 128 + xAlign, 100 + yAlign, 180, 130, 0x324650, 0x0, 0)
	ui.addTextArea(5433, table.concat(playerLevel[1], '\n'), player, 276+10+ xAlign, 101 + yAlign, 40, 130, 0x324650, 0x0, 0)
	ui.addTextArea(5434, table.concat(playerLevel[2], '\n'), player, 275+10+ xAlign, 100 + yAlign, 40, 130, 0x324650, 0x0, 0)

	ui.addTextArea(5435, table.concat(playerExperience[1], '\n'), player, 276+65+ xAlign, 101 + yAlign, 70, 130, 0x324650, 0x0, 0)
	ui.addTextArea(5436, table.concat(playerExperience[2], '\n'), player, 275+65+ xAlign, 100 + yAlign, 70, 130, 0x324650, 0x0, 0)

	if player then
		ui.addTextArea(5440, '<p align="center"><font size="20" color="#000000">'..translate('ranking_Season', player):format(mainAssets.season), player, 94+ xAlign, 55+ yAlign, 400, nil, 0x324650, 0x0, 0)
		ui.addTextArea(5441, '<p align="center"><font size="20"><cs>'..translate('ranking_Season', player):format(mainAssets.season), player, 93+ xAlign, 54+ yAlign, 400, nil, 0x324650, 0x0, 0)

		ui.addTextArea(5442, '<p align="center"><font size="14"><r>'..translate('daysLeft', player):format(formatDaysRemaining(os.time{day=15, year=2020, month=10})), player, 93+ xAlign, 84+ yAlign, 400, nil, 0x324650, 0x0, 0)
	end
end