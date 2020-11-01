sideQuest_update = function(player, quanty)
	players[player].sideQuests[2] = players[player].sideQuests[2] + quanty
	if players[player].sideQuests[2] >= sideQuests[players[player].sideQuests[1]].quanty then
		sideQuest_reward(player)
	end
end

sideQuest_reward = function(player)
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
	if nextQuest == currentQuest or nextQuest == 8 then
		return false
	elseif sideQuests[currentQuest].alias then
		if sideQuests[currentQuest].alias ~= nextQuest then
			if sideQuests[nextQuest].alias and sideQuests[nextQuest].alias == sideQuests[currentQuest].alias then
				return false
			else 
				return true
			end
		end
	elseif sideQuests[nextQuest].alias then
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
	local currentQuestType = sideQuests[players[player].sideQuests[1]].alias or players[player].sideQuests[1]
	while true do
		nextQuest = random(#sideQuests)
		if players[player].sideQuests[5] == floor(os_time() / (24*60*60*1000)) then
			if nextQuest ~= currentQuestType then
				if sideQuest_checkAlias(nextQuest, players[player].sideQuests[6]) then
					break
				end
			end
		else
			if nextQuest ~= currentQuestType then
				if sideQuest_checkAlias(nextQuest, currentQuestType) then
					break
				end
			end
		end
	end
	players[player].sideQuests[1] = nextQuest
	players[player].sideQuests[2] = 0
	savedata(player)
end