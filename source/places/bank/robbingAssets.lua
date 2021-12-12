reloadBankAssets = function()
	if not room.bankBeingRobbed then
		addGround(9998, 262+5000, 251+4955, {type = 12, color = 0xdad0b5, width = 24, height = 80})
	else
		removeGround(9998)
	end
end

addBankRobbingAssets = function()
	if room.bankBeingRobbed then return end
	room.bankBeingRobbed = true

	for name in next, ROOM.playerList do
		if not players[name].driving then
			showTextArea(1029, '<font size="15" color="#FF0000"><p align="center">' .. translate('robberyInProgress', name) .. '</a>', name, 2670, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.3)
		end
		if players[name].place == 'bank' then
			if players[name].job ~= 'police' then
				job_hire('thief', name)
				chatMessage('<j>'..translate('copAlerted', name), name)
			end
		end
		if players[name].job == 'police' then
			chatMessage('<vp>'..translate('bankRobAlert', name)..'</vp>', name)
		end
		if players[name].questLocalData.other.goToBankRob then
			quest_updateStep(name)
		end
	end
	local lightImage = nil
	removeImage(room.bankDoors[1])
	removeImage(room.bankDoors[2])
	removeImage(room.bankDoors[3])
	removeImage(room.bankDoors[4])
	removeImage(room.bankDoors[5])
	room.bankDoors[1] = addImage("16baf05e96a.png", "!36", 5787, 4596)
	room.bankDoors[2] = addImage("16bb46e2a7c.png", "!36", 5243, 4718)
	room.bankDoors[3] = addImage("16bb46e2a7c.png", "!37", 5792, 4926)
	room.bankDoors[4] = addImage("16bb98e5d8f.png", "!38", 5988, 4930) -- lever
	room.bankDoors[5] = addImage("16bb493c28e.png", "!36", 5275, 4812) -- lasers


	addGround(9999, 7+5791, 66+30+4596, {type = 14, width = 12, height = 190})
	addGround(9997, 260+5000, 135+4555, {type = 14, width = 25, height = 200})
	addGround(9996, 88+5275, 80+4812, {type = 14, width = 200, angle = 45, restitution = 999}) -- laser
	addGround(9995, 232+5275, 80+4812, {type = 14, width = 200, angle = -45, restitution = 999}) -- laser
	addGround(9994, 809+5000, 338+4555, {type = 14, width = 25, height = 200})

	showTextArea(-5950, '<a href="event:lever">'..string.rep('\n', 5), nil, 5990, 4935, 25, 25, 0x324650, 0x0, 0)

	addTimer(function(time)
		if room.bankRobStep == 'vault' then
			for player, v in next, ROOM.playerList do
				if players[player].place == 'bank' then
					if not players[player].robbery.robbing then
						if v.x > 5791 and v.x < 6014 and v.y > 4596 and v.y < 4785 then
							if players[player].job == 'thief' then
								players[player].timer = addTimer(function(j)
									local time = room.robbing.bankRobbingTimer - j
									showTextArea(98900000001, "<p align='center'>"..translate('runAway', player):format(time)..'\n<vp><font size="10">'..translate('runAwayCoinInfo', player):format('$'..jobs['thief'].bankRobCoins), player, 250, 370, 250, nil, 0x1, 0x1, 0, true)
									if j == room.robbing.bankRobbingTimer then
										players[player].robbery.robbing = false
										removeTimer(players[player].timer)
										players[player].timer = {}
										removeTextArea(98900000001, player)
										giveCoin(jobs['thief'].bankRobCoins, player, true)
										TFM.setNameColor(player, 0)
										giveExperiencePoints(player, 250)
										job_updatePlayerStats(player, 2)
										sideQuest_sendTrigger(player, 'bank', 1)
									end
								end, 1000, room.robbing.bankRobbingTimer)

								players[player].robbery.robbing = true
								TFM.setNameColor(player, 0xFF0000)
							end
						end
					end
				end
			end
		end
		if time%2 == 0 then
			if lightImage then
				removeImage(lightImage)
			end
		else
			lightImage = addImage('16b9521a7ac.png', '!999999', 5000+66, 4545)
		end
		if time == room.bankRobbingTime then
			room.bankBeingRobbed = false
			removeTextArea(-510, nil)
			removeImage(room.bankDoors[1])
			for i = 1, #room.bankTrashImages do
				removeImage(room.bankTrashImages[i])
			end
			room.bankTrashImages = {}
			for i in next, ROOM.playerList do
				showTextArea(1029, '<font size="15"><p align="center"><a href="event:enter_bank">' .. translate('goTo', i) .. '</a>', i, 2670, 1800+room.y, 200, 30, 0x122528, 0x122528, 0.3)
				if players[i].place == 'bank' then
					if players[i].job == 'thief' then
						if players[i].inRoom then
							arrestPlayer(i, 'Colt')
						end
					end
				end
				eventTextAreaCallback(1, i, 'closeVaultPassword', true)
			end
			reloadBankAssets()
		elseif time == room.bankRobbingTime - 5 then
			gameNpcs.reAddNPC('Colt')
		end
	end, 1000, room.bankRobbingTime)
end