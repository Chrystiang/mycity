startRobbery = function(player, character)
	local npcTimer = gameNpcs.robbing[character].cooldown
	addTimer(function(j)
		gameNpcs.removeNPC(character)
		if j == npcTimer then
			gameNpcs.reAddNPC(character)
		end
	end, 1000, npcTimer)

	local shield = addImage('1566af4f852.png', '$'..player, -45, -45)
	players[player].robbery.usingShield = true
	players[player].robbery.robbing = true
	players[player].timer = addTimer(function(j)
		local time = room.robbing.robbingTimer - j
		showTextArea(98900000000, "<b><font color='#371616'><p align='center'>"..translate('runAway', player):format(time)..'\n<vp><font size="10">'..translate('runAwayCoinInfo', player):format('$'..jobs['thief'].coins), player, 253, 364, 290, nil, 1, 1, 0, true)
		if j == 10 then
			removeImage(shield)
			players[player].robbery.usingShield = false
			
		elseif j == room.robbing.robbingTimer then 
			sideQuest_sendTrigger(player, 'rob', 1)
			sideQuest_sendTrigger(player, 'rob_npc', 1, character)

			players[player].robbery.robbing = false
			removeTimer(players[player].timer)
			players[player].timer = {}
			removeTextArea(98900000000, player)
			showOptions(player)
			giveExperiencePoints(player, 100)
			job_updatePlayerStats(player, 2)
			giveCoin(jobs['thief'].coins, player, true)
			TFM.setNameColor(player, 0)
		end
	end, 1000, room.robbing.robbingTimer)
	closeInterface(player, nil, nil, nil, nil, nil, true)

	chatMessage('<j>'..translate('copAlerted', player), player)
	TFM.setNameColor(player, 0xFF0000)

	for _, cop in next, jobs['police'].working do
		chatMessage('<vp>['..translate('alert', cop)..'] <v>'.. player, cop)
	end
end