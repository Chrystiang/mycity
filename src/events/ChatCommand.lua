onEvent("ChatCommand", function(player, command)
	if room.isInLobby then return end
	if player == 'Fofinhoppp#0000' or player == 'Lucasrslv#0000' then
		if command:sub(1, 5) == 'horas' then
			room.currentGameHour = command:sub(7)
			TFM.chatMessage('<rose>' ..updateHour(player, true))								
		elseif command == 'encomenda' then 
			local x = math.random(0, 12000)
			addLootDrop(x, 7200, 20)
			--TFM.chatMessage('alerta a encomenda chegará proximo ao X: '..x)
			for i, v in next, ROOM.playerList do 
				TFM.movePlayer(i, x, 7600, false)
			end

		elseif command:sub(1, 9) == 'sidequest' then 
			local nextQuest = tonumber(command:sub(11))
			if not sideQuests[nextQuest] then return end
			players[player].sideQuests[1] = nextQuest
			players[player].sideQuests[2] = 0
			players[player].sideQuests[3] = players[player].sideQuests[3] + 1
		elseif command == 'up' then
			quest_updateStep(player)
		elseif command:sub(1, 5) == 'quest' then
			local quest = tonumber(command:sub(7))
			
			_QuestControlCenter[players[player].questStep[1]].reward(player)
			players[player].questStep[1] = players[player].questStep[1] +1
			loadMap(player)

			if not lang['en'].quests[quest] then 
				return 
			end

			players[player].questStep[1] = quest
			players[player].questStep[2] = 0
			players[player].questLocalData.step = 0
			savedata(player)

			_QuestControlCenter[quest].active(player, 0)
		elseif command:sub(1,5) == 'image' then
			local imgg = command:sub(7)
			imgAtual = imgg
			removeImage(img)
	    	img = addImage(imgAtual, typeimg, pos.x, pos.y)
			TFM.chatMessage('<rose>Imagem atual: '..imgAtual, player)
		elseif command:sub(1,4) == 'type' then
			local type = command:sub(6)
			typeimg = type
		    removeImage(img)
	        TFM.chatMessage('<rose>Tipo da imagem: '..typeimg, player)
	        img = addImage(imgAtual, typeimg, pos.x, pos.y)
	    elseif command:sub(1,1) == 'x' then
	        local x = command:sub(3)
	        pos.x = x
	        removeImage(img)
	        TFM.chatMessage('<rose>X:'..x, player)
	        img = addImage(imgAtual, typeimg, pos.x, pos.y)
	   	elseif command:sub(1,1) == 'y' then
	        local y = command:sub(3)
	        pos.y = y
	        removeImage(img)
	        TFM.chatMessage('<rose>Y:'..y, player)
	        img = addImage(imgAtual, typeimg, pos.x, pos.y)
		end
	end
	end)