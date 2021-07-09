arrestPlayer = function(thief, cop, command)
	local i = thief
	local player = cop
	local thiefData = players[thief]
	local copData = players[cop]
	if not copData then
		eventNewPlayer(cop)
		return arrestPlayer(thief, cop, command)
	elseif not thiefData then
		eventNewPlayer(thief)
		return arrestPlayer(thief, cop, command)
	end

	checkIfPlayerIsDriving(thief)
	removeGroupImages(players[thief].images)
	removeTextArea(1012, thief)
	removeTextArea(5001, thief)
	closeMenu(920, thief)
	removeTimer(thiefData.timer)
	job_fire(thief)
	eventTextAreaCallback(1, thief, 'closeVaultPassword', true)

	players[thief].place = 'police'
	players[thief].blockScreen = true
	players[thief].robbery.arrested = true
	players[thief].robbery.robbing = false
	players[thief].robbery.usingShield = false
	players[thief].robbery.whenWasArrested = os_time()
	players[thief].robbery.escaped = false
	players[thief].timer = {}
	players[thief].bankPassword = nil

	if thief == 'Robber' then
		quest_updateStep(cop)
		return
	else
		closeInterface(thief, nil, nil, nil, nil, nil, true)
		players[thief].timer = addTimer(function(j)
			local time = room.robbing.prisonTimer - j
			local thiefPosition = ROOM.playerList[thief]

			showTextArea(98900000000, string.format("<b><font color='#371616'><p align='center'>"..translate('looseMgs', thief), time), thief, 253, 368, 290, nil, 1, 1, 0, true)
			if j == room.robbing.prisonTimer then
				removeTimer(thiefData.timer)
				players[thief].robbery.arrested = false
				players[thief].blockScreen = false
				players[thief].timer = {}
				movePlayer(thief, 8020, 6400, false)
				showOptions(thief)
			end

			if not (thiefPosition.x > 8040 and thiefPosition.y > 6260 and thiefPosition.x < 8500 and thiefPosition.y < 6420) then
	 			movePlayer(thief, random(8055, 8330), 6400, false)
	 		end
		end, 1000, command and 30 or room.robbing.prisonTimer)
	end

	setNightMode(thief, true)
	giveExperiencePoints(thief, 10)
	giveExperiencePoints(cop, 30)
	local complement = i:gmatch('(.-)#[0-9]+$')()
	if not i:match('#0000') then
		complement = i:gsub('#', '<g>#')
	end
	for name in next, ROOM.playerList do
		if name ~= cop then
			chatMessage(string.format(translate('captured', name), complement), name)
		end
	end
	chatMessage(string.format(translate('arrestedPlayer', cop), complement), cop)

	sideQuest_sendTrigger(cop, 'arrest', 1)
	giveCoin(jobs['police'].coins, cop, true)
	job_updatePlayerStats(cop, 1)
	players[cop].time = os_time() + 10000
end