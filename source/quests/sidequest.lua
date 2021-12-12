sideQuest_update = function(player, value)
	players[player].sideQuests[2] = players[player].sideQuests[2] + value

	local currentAmount = players[player].sideQuests[2]
	local requiredAmount = players[player].sideQuests[7] or sideQuests[players[player].sideQuests[1]].amount

	if currentAmount >= requiredAmount then
		sideQuest_reward(player)
	end
end

sideQuest_sendTrigger = function(player, triggerName, value, extraData)
	local playerData 	= players[player]
	local sidequest 	= sideQuests[playerData.sideQuests[1]].type

	if string_find(sidequest, triggerName) then
		if playerData.sideQuests[8] then
			if not extraData then return end
			if extraData:lower() ~= playerData.sideQuests[8]:lower() then return end
		end
		sideQuest_update(player, value)
	end
end

sideQuest_reward = function(player)
	local currentSideQuest 	= players[player].sideQuests[1]
	local hasNewDataFormat 	= players[player].sideQuests[7]
	local qpPoints 			= sideQuests[currentSideQuest].points

	if hasNewDataFormat then
		local id = table_find(sideQuests[currentSideQuest].amount, hasNewDataFormat) or 1
		qpPoints = sideQuests[currentSideQuest].points[id]
	end

	players[player].sideQuests[4] = players[player].sideQuests[4] + qpPoints

	local newxp = qpPoints * 100
	modernUI.new(player, 240, 220)
		:rewardInterface({
			{text = translate('experiencePoints', player), quanty = newxp, format = '+'},
			{currency = 'diamond', quanty = qpPoints},
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
 
sideQuest_new = function(player, specificQuest)
	local nextQuest = specificQuest
	if not specificQuest then
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
	end

	players[player].sideQuests[1] = nextQuest
	players[player].sideQuests[2] = 0
	players[player].sideQuests[7] = type(sideQuests[nextQuest].amount) == "table" and sideQuests[nextQuest].amount[random(#sideQuests[nextQuest].amount)] or nil
	players[player].sideQuests[8] = sideQuests[nextQuest].extraData and sideQuests[nextQuest].extraData() or nil

	savedata(player)
end