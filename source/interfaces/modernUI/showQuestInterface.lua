modernUI.questInterface = function(self)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - 270/2)
	local y = (200 - 90/2) - 30

	local images = {'174070bd0ec.png', '174070e21a1.png'} -- available, unavailaible

	local playerData = players[player]
	local getLang = playerData.lang

	for i = 1, 2 do
		local icon = 1
		local title, min, max, goal = '', 0, 100, '<p align="center"><font color="#999999">'..translate('newQuestSoon', player):format(questsAvailable+1, '<CE>'..syncData.quests.newQuestDevelopmentStage)
		if i == 1 then 
			if playerData.questStep[1] > questsAvailable then
				icon = 2
			else
				title = lang[getLang].quests[playerData.questStep[1]].name
				min = playerData.questStep[2]
				max = #lang['en'].quests[playerData.questStep[1]]
				goal = string.format(lang[getLang].quests[playerData.questStep[1]][playerData.questStep[2]]._add, quest_formatText(player, playerData.questStep[1], playerData.questStep[2]))
			end
		else 
			title = '['..translate('_2ndquest', player)..']'
			min = playerData.sideQuests[2] 
			max = sideQuests[playerData.sideQuests[1]].quanty
			local sideQuestID = sideQuests[playerData.sideQuests[1]].alias or playerData.sideQuests[1]
			goal = lang[getLang].sideQuests[sideQuestID]:format(playerData.sideQuests[2] .. '/' .. sideQuests[playerData.sideQuests[1]].quanty)
		end
		local progress = math.floor(min / max * 100)
		local progress2 = math.floor(min / max * 250/11.5)
		ui.addTextArea(id..(890+i), '<font color="#caed87" size="14"><b>'..title, player, x+2, y+5 + (i-1)*100, 270, nil, 1, 0x24474, 0, true)
		ui.addTextArea(id..(892+i), '<font color="#ebddc3" size="13">'..goal, player, x+2, y+30 + (i-1)*100, 270, 40, 0x1, 0x1, 0, true)

		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(images[icon], ":26", x - 5, y + (i-1)*100, player)
		for ii = 1, progress2 do 
			players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171d74086d8.png', ":25", x+17 + (ii-1)*11, y+77 + (i-1)*100, player)
		end
		ui.addTextArea(id..(900+i), '<p align="center"><font color="#000000" size="14"><b>'..translate('percentageFormat', player):format(progress), player, x+11, y+73 + (i-1)*100, 250, nil, 0, 0x24474, 0, true)
		ui.addTextArea(id..(902+i), '<p align="center"><font color="#c6bb8c" size="14"><b>'..translate('percentageFormat', player):format(progress), player, x+10, y+72 + (i-1)*100, 250, nil, 0, 0x24474, 0, true)

		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171d736325c.png', ":27", x + 10, y + 70 + (i-1)*100, player)
		if i == 2 then -- Skip Side Quest
			-- If the player already skipped a quest today, end the function
			if players[player].sideQuests[5] == math.floor(os.time() / (24*60*60*1000)) then return end

			players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('174077c73af.png', ":28", x + 246, y + 8 + (i-1)*100, player)
			ui.addTextArea(id..(905), "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', 4), player, x + 246, y + 8 + (i-1)*100, 20, 20, 0, 0x24474, 0, true,
				function()
					-- If the player already skipped a quest today, end the function to avoid double click
					if players[player].sideQuests[5] == math.floor(os.time() / (24*60*60*1000)) then return end

					eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
					modernUI.new(player, 240, 170, translate('skipQuest', player), translate('skipQuestTxt', player), 0)
						:build()
							:addConfirmButton(function() 
								players[player].sideQuests[5] = math.floor(os.time() / (24*60*60*1000))
								players[player].sideQuests[6] = sideQuests[players[player].sideQuests[1]].alias or players[player].sideQuests[1]
								sideQuest_new(player)
							end, translate('confirmButton_skipQuest', player))
				end)		
		end
	end

	return setmetatable(self, modernUI)
end