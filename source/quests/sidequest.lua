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
	
	sideQuest_new(player)
	players[player].sideQuests[3] = players[player].sideQuests[3] + 1
	giveExperiencePoints(player, newxp)
end

sideQuest_checkAlias = function(nextQuest, currentQuest)
	if sideQuests[nextQuest].alias then
		if sideQuests[nextQuest].alias ~= currentQuest then
			return true
		end
	else
		return true
	end
	return false
end

sideQuest_new = function(player)
	local nextQuest
	while true do
		nextQuest = math.random(#sideQuests)
		if players[player].sideQuests[5] == math.floor(os.time() / (24*60*60*1000)) then
			if nextQuest ~= players[player].sideQuests[1] then
				if sideQuest_checkAlias(nextQuest, players[player].sideQuests[6]) then
					break
				end
			end
		else
			if nextQuest ~= players[player].sideQuests[1] and nextQuest ~= 8 then
				if sideQuest_checkAlias(nextQuest, players[player].sideQuests[1]) then
					break
				end
			end
		end
	end
	players[player].sideQuests[1] = nextQuest
	players[player].sideQuests[2] = 0
	savedata(player)
end