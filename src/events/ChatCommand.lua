onEvent("ChatCommand", function(player, command)
	if room.isInLobby then return end
	if player == 'Bodykudo#0000' or player == 'Fofinhoppp#0000' or player == 'Weth#9837' or player == 'Lucasrslv#0000' then
		if command:sub(1, 3) == 'ban' then
			local playerr = string.nick(command:sub(5))
			if not players[playerr] then return end
			room.bannedPlayers[#room.bannedPlayers+1] = playerr
			TFM.killPlayer(playerr)
			translatedMessage('playerBannedFromRoom', playerr)
		elseif command:sub(1, 5) == 'place' then 
			local place = command:sub(7)
			if places[place] then 
				places[place].saidaF(player) 
			end
		elseif command:sub(1, 5) == 'unban' then
			local playerr = string.nick(command:sub(7))
			if not players[playerr] then return end
			if table.contains(room.bannedPlayers, playerr) then
				for i, v in next, room.bannedPlayers do
					if v == playerr then
						table.remove(room.bannedPlayers, i)
						break
					end
				end
				TFM.respawnPlayer(playerr)
				translatedMessage('playerUnbannedFromRoom', playerr)
			end
		elseif command:sub(1, 6) == 'punish' then
			local playerr = string.nick(command:sub(8))
			if players[playerr] then
				TFM.chatMessage('[•] removing $100 from '..playerr..'...', player)
				giveCoin(-100, playerr)
			else
				TFM.chatMessage('<g>[•] error $playerName not found.', player)
			end
		elseif command:sub(1, 6) == 'moveTo' then
			local playerr = string.nick(command:sub(8))
			if players[playerr] then
				TFM.chatMessage('[•] teleporting to '..players[playerr].place..'...', player)
				TFM.movePlayer(player, ROOM.playerList[playerr].x, ROOM.playerList[playerr].y, false)
				players[player].place = players[playerr].place
			else
				if gameNpcs.characters[command:sub(8)] then 
					TFM.chatMessage('[•] teleporting to <v>[NPC]</v> '..command:sub(8)..'...', player)
					TFM.movePlayer(player, gameNpcs.characters[command:sub(8)].x+50, gameNpcs.characters[command:sub(8)].y+50, false)
				else
					TFM.chatMessage('<g>[•] error $playerName not found.', player)
				end
			end
		elseif command:sub(1, 4) == 'jail' then
			local playerr = string.nick(command:sub(6))
			if players[playerr] then
				TFM.chatMessage('<g>[•] arresting '..playerr..'...', player)
				arrestPlayer(playerr, 'Colt')
			else
				TFM.chatMessage('<g>[•] error $playerName not found.', player)
			end
		elseif command:sub(1, 5) == 'spawn' then
			local playerr = string.nick(command:sub(7))
			if players[playerr] then
				TFM.chatMessage('<g>[•] moving '..playerr..' to spawn...', player)
				players[playerr].place = 'town'
				TFM.killPlayer(playerr)
			else
				TFM.chatMessage('<g>[•] error $playerName not found.', player)
			end
		elseif command == 'roomLog' then
			if not players[player].roomLog then
				players[player].roomLog = true
				TFM.chatMessage('<g>[•] roomLog enabled.', player)
			else
				players[player].roomLog = false
				TFM.chatMessage('<g>[•] roomLog disabled.', player)
			end
		end
	end
	if player == 'Fofinhoppp#0000' or player == 'Lucasrslv#0000' then
		if command:sub(1, 5) == 'horas' then
			room.currentGameHour = command:sub(7)
			TFM.chatMessage('<rose>' ..updateHour(player, true))
		elseif command == 'coin' then 
			giveCoin(50000, player)
		elseif command:sub(1, 3) == 'job' then 
			local job = command:sub(5)
			if not jobs[job] then return end
			job_invite(job, player)
		elseif command:sub(1,4) == 'shop' then
			local npc = command:sub(6) 
			showNPCShop(player, npc)
		elseif command == 'encomenda' then 
			local x = math.random(0, 12000)
			addLootDrop(x, 7200, 20)
			--TFM.chatMessage('alerta a encomenda chegará proximo ao X: '..x)
			for i, v in next, ROOM.playerList do 
				TFM.movePlayer(i, x, 7600, false)
			end
		elseif command:sub(1, 6) == 'insert' then
			local item = command:sub(8)
			if not bagItems[item] then return end
			players[player].totalOfStoredItems.bag = 0
			addItem(item, 1, player, 0)
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
		elseif command == 'cheese' then 
	       	TFM.giveCheese(player)
		elseif command == 'win' then 
			TFM.playerVictory(player)
			TFM.respawnPlayer(player)
		end
	end
	if command:sub(1, 7) == 'profile' or command:sub(1, 6) == 'perfil' then
		local target = string.nick(command:sub(9)) or string.nick(command:sub(8))
		openProfile(player, target)
	end
	end)