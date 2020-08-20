addQuestAsset = function(player, npc)
	if players[player].questLocalData.images[1] then
		for i, v in next, players[player].questLocalData.images do
			removeImage(players[player].questLocalData.images[i])
		end
	end
	players[player].questLocalData.images = {}
	for i = -50, -40 do
		ui.removeTextArea(i, player)
	end
	if npc:find('_key') then
		players[player].questLocalData.images[#players[player].questLocalData.images+1] = addImage("16bbd9655ca.png", "!30", 1400, 8753, player)
		ui.addTextArea(-46, "<textformat leftmargin='1' rightmargin='1'><a href='event:Quest_02_key'>" .. string.rep('\n', 4), player, 1390, 8743, 25, 25, 1, 1, 0, false)
	end
	if npc:find('_key2') then
		players[player].questLocalData.images[#players[player].questLocalData.images+1] = addImage("16bbd9655ca.png", "!30", 1630, 8815, player)
		ui.addTextArea(-46, "<textformat leftmargin='1' rightmargin='1'><a href='event:Quest_02_key'>" .. string.rep('\n', 4), player, 1620, 8805, 25, 25, 1, 1, 0, false)
	end
	if npc:find('_cloth') then
		players[player].questLocalData.images[#players[player].questLocalData.images+1] = addImage("16bca0b1f2e.png", "!30", 5700, 4990, player)
		ui.addTextArea(-46, "<textformat leftmargin='1' rightmargin='1'><a href='event:Quest_03_cloth'>" .. string.rep('\n', 4), player, 5700, 4990, 25, 25, 1, 1, 0, false)
	end
	if npc:find('_paper') then
		players[player].questLocalData.images[#players[player].questLocalData.images+1] = addImage("16bbf3aa649.png", "!30", 6250, 3250, player)
		ui.addTextArea(-46, "<textformat leftmargin='1' rightmargin='1'><a href='event:Quest_03_paper'>" .. string.rep('\n', 4), player, 6250, 3250, 25, 25, 1, 1, 0, false)
	end
end

quest_formatText = function(player, quest, step)
	local formats = {
		[1] = {
			[1] = players[player].questLocalData.other.fish_ and (5 - players[player].questLocalData.other.fish_) .. '/5',
			[3] = players[player].questLocalData.other.BUY_energyDrink_Ultra and (3 - players[player].questLocalData.other.BUY_energyDrink_Ultra) .. '/3',
		},
		[5] = {
			[17] = players[player].questStep[3] and (20 - players[player].questStep[3]) .. '/20',
		},
		[99] = {
			[9] = players[player].questLocalData.other.ItemQuanty_lemon and (10 - players[player].questLocalData.other.ItemQuanty_lemon) .. '/10',
			[11] = players[player].questLocalData.other.ItemQuanty_tomato and (10 - players[player].questLocalData.other.ItemQuanty_tomato) .. '/10',
		},
	}
	if formats[quest] then
		if formats[quest][step] then
			return formats[quest][step]
		end
	end
	return '-'
end

quest_setNewQuest = function(player, syncRewards)
	if not syncRewards then
		if _QuestControlCenter[players[player].questStep[1]].reward then
			_QuestControlCenter[players[player].questStep[1]].reward(player)
			savedata(player)
		end
		players[player].questStep[1] = players[player].questStep[1] + 1
		players[player].questStep[2] = 0
		players[player].questStep[3] = nil
		players[player].questLocalData.step = 0
		loadMap(player)
		syncRewards = players[player].questStep[1]-1
	end
	players[player].sideQuests[4] = players[player].sideQuests[4] + 20
	giveExperiencePoints(player, 3000)
	modernUI.new(player, 240, 220)
		:rewardInterface({
			{text = translate('experiencePoints', player), quanty = 3000, format = '+'},
			{text = 'QP$', quanty = 20, format = '+'},
		}, nil, translate('questCompleted', player):format('<CE><i>'..lang[players[player].lang].quests[syncRewards].name..'</i></CE>'))
		:build()
		:addConfirmButton(function() end, translate('confirmButton_Great', player))
end

quest_updateStep = function(player)
	local playerData = players[player]

	local currentQuest = playerData.questStep[1]
	local currentStep = playerData.questStep[2]

	for i, character in next, _QuestControlCenter[currentQuest].npcs do 
		if playerData._npcsCallbacks.questNPCS[character] then
			gameNpcs.removeNPC(character, player)
			players[player]._npcsCallbacks.questNPCS[character] = nil
		end 
	end 
	if playerData.questLocalData.images[1] then
		for i, v in next, playerData.questLocalData.images do
			removeImage(playerData.questLocalData.images[i])
		end
	end
	players[player].questLocalData.images = {}
	for i = -50, -40 do
		ui.removeTextArea(i, player)
	end

	players[player].questStep[3] = nil
	players[player].questLocalData.other = {}
	players[player].questStep[2] = currentStep + 1
	players[player].questLocalData.step = 1

	--TFM.chatMessage('<CS>[DEBUG]</CS> '..player..' completed a new quest step! Current step: <v>'..playerData.questStep[2])
	if players[player].questStep[2] == #lang['en'].quests[currentQuest]+1 then			
		quest_setNewQuest(player)
		if players[player].questStep[1] > questsAvailable then
			return 'no more quests'
		end
	end
	_QuestControlCenter[players[player].questStep[1]].active(player, players[player].questStep[2])
	savedata(player)
end

quest_checkIfCanTalk = function(questID, questStep, npc)
	if lang['en'].quests[questID][questStep]._add:find(npc) then 
		return true
	end
	return false
end