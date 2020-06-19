sideQuest_update = function(player, quanty)
	players[player].sideQuests[2] = players[player].sideQuests[2] + quanty
	if players[player].sideQuests[2] >= sideQuests[players[player].sideQuests[1]].quanty then
		sideQuest_reward(player)
	end
end

sideQuest_reward = function(player)
	eventTextAreaCallback(1, player, 'close2', true)
	players[player].sideQuests[4] = players[player].sideQuests[4] + sideQuests[players[player].sideQuests[1]].points
	local newxp = sideQuests[players[player].sideQuests[1]].points * 100
	modernUI.new(player, 240, 220)
		:rewardInterface({
			{text = translate('experiencePoints', player), quanty = newxp, format = '+'},
			{text = 'QP$', quanty = sideQuests[players[player].sideQuests[1]].points, format = '+'},
		}, nil, translate('sidequestCompleted', player))
		:build()
		:addConfirmButton(function() end, translate('confirmButton_Great', player))
	math.randomseed(os.time())
	repeat
			nextQuest = math.random(#sideQuests)
	until nextQuest ~= players[player].sideQuests[1] and nextQuest ~= 8
	players[player].sideQuests[1] = nextQuest
	players[player].sideQuests[2] = 0
	players[player].sideQuests[3] = players[player].sideQuests[3] + 1
	giveExperiencePoints(player, newxp)
	savedata(player)
end