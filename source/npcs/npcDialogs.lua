for commu, v in next, lang do
	for id, message in next, v do 
		if id:find('npcDialog_') then 
			if not npcDialogs.normal[commu] then npcDialogs.normal[commu] = {} end
			local npc = id:sub(11)
			local message = message
			local dialog = {}
			for text in message:gmatch('[^\n]+') do 
				dialog[#dialog+1] = text
			end
			npcDialogs.normal[commu][npc] = dialog
		end
	end
	for questID, properties in next, v.quests do
		for questStep, stepData in next, properties do
			if tonumber(questStep) then 
				if not npcDialogs.quests[commu] then npcDialogs.quests[commu] = {} end
				if not npcDialogs.quests[commu][questID] then npcDialogs.quests[commu][questID] = {} end
				if not npcDialogs.quests[commu][questID][questStep] then npcDialogs.quests[commu][questID][questStep] = {} end
				local message = {}
				if stepData.dialog then
					for msg in stepData.dialog:gmatch('[^\n]+') do 
						message[#message+1] = msg
					end
				end
				npcDialogs.quests[commu][questID][questStep] = message
			end
		end
	end
end