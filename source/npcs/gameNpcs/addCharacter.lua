gameNpcs.addCharacter = function(name, image, player, x, y, properties)
	if not properties then properties = {} end
	local playerData = players[player]
	if properties.questNPC and playerData._npcsCallbacks.questNPCS[name] then return end
		local type = properties.type and properties.type or '!'
		local canClick = true 
		local canOrder = true 
		local imageFixAlign = {0, 0}
		if not image[2] then 
			image[2] = image[1]
			imageFixAlign = {0, -23}
		end
		local npcID = playerData._npcsAdded

	local color = '6c99d6'
	if properties.job then
		color = jobs[properties.job].color 
		if properties.jobConfirm then
			if not properties.endEvent then
				properties.callback = function(player) job_invite(properties.job, player) end
			end
			addImage('17408124c64.png', "!30", x+38, y+20, player)
		end
	elseif properties.color then
		color = properties.color
	elseif properties.canRob then 
		color = 'FF69B4'
		canOrder = false
	elseif properties.questNPC then
		color = 'b69efd'
		canOrder = false
		playerData._npcsCallbacks.questNPCS[name] = {id = npcID}
		local newName = name:gsub('%$', '')
		canClick = quest_checkIfCanTalk(playerData.questStep[1], playerData.questStep[2], newName)
		if gameNpcs.characters[newName] and not image[1] then
			local v = gameNpcs.characters[newName]
			x = v.x 
			y = v.y 
			image[1] = '171a497f4e2.png'
			image[2] = v.image2
			imageFixAlign = {0, 0}
			for id, obj in next, playerData._npcsCallbacks.starting do 
				if obj.name == newName then
					playerData._npcsCallbacks.ending[npcID] = {callback = playerData._npcsCallbacks.starting[id].callback, name = name}
					break
				end
			end
		end
	end
	if properties.formatDialog then
		playerData._npcsCallbacks.formatDialog[name] = properties.formatDialog
	end

	local callback = 'npcDialog_talkWith_'..npcID..'_'..name..'_'..image[2]
	if properties.callback then 
		callback = 'npcDialog_talkWith_'..npcID..'_otherCallback'
		playerData._npcsCallbacks.starting[npcID] = {callback = properties.callback, name = name}
	elseif properties.endEvent then 
		playerData._npcsCallbacks.ending[npcID] = {callback = properties.endEvent, name = name}
	elseif properties.sellingItems then 
		callback = 'npcDialog_talkWith_'..npcID..'_otherCallback'
		playerData._npcsCallbacks.starting[npcID] = {callback = function(player) showNPCShop(player, name) end, name = name}
		addImage('174080a7702.png', "!30", x+38, y+20, player)
	elseif properties.questNPC then 
		callback = callback .. '_questDialog'
	end

		if not gameNpcs.characters[name] then 
			if canOrder then
				gameNpcs.orders.canOrder[name] = properties.place or 'town' 
			end

			gameNpcs.characters[name] = {visible = true, x = x, y = y, type = type, players = {}, runningImages = nil, image = image[1], image2 = image[2], callback = callback, color = color, fixAlign = imageFixAlign, place = properties.place}
			if properties.canRob then 
				gameNpcs.robbing[name] = {x = x+50, y = y+80, cooldown = properties.canRob.cooldown} 				
			end
			imgsToLoad[#imgsToLoad+1] = image[1]
			imgsToLoad[#imgsToLoad+1] = image[2]
		end 

	playerData._npcsCallbacks.clickArea[npcID] = {x + 50, y + 80, name}

	gameNpcs.characters[name].players[player] = {id = npcID}
	if gameNpcs.characters[name].visible and players[player] then 
		gameNpcs.characters[name].players[player] = {id = npcID, image = addImage(image[1], type.."1000", x, y, player)} 

		local id = -89000+(npcID*6)
		gameNpcs.setNPCName(id, name:gsub('%$', ''), callback, player, x, y, color, canClick)
	end 
	players[player]._npcsAdded = npcID + 1
end