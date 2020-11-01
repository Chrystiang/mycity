chatCommands.quest = {
	permissions = {'admin'},
	event = function(player, args)
		local quest = tonumber(args[1])
		if not lang['en'].quests[quest] then return chatMessage('<g>[•] invalid quest ID.', player) end
		local questStep = tonumber(args[2]) or 0
		local target = string_nick(args[3])
		if not players[target] then target = player end
		if players[target].questStep[1] < quest then
			_QuestControlCenter[players[target].questStep[1]].reward(target)
		end
		players[target].questStep[1] = quest
		players[target].questStep[2] = questStep
		players[target].questLocalData.step = 0
		savedata(target)

		_QuestControlCenter[quest].active(target, 0)

		chatMessage('<g>[•] quest '..quest..':'..questStep..' set to '..target..'.', player)
	end
}