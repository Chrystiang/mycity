playerFishing = function(name, x, y, biome)
	local player = players[name]
	local playerStatus = ROOM.playerList[name]

	randomseed(os_time())
	local chances = random(1, 10000)
	local counter = 0
	local rarityFished = 'normal'

	for rarity, percentage in next, player.lucky[1] do
		counter = counter + (percentage * 100)
		if (percentage * 100) >= chances then 
			rarityFished = rarity
			break
		end
	end

	player.fishing[1] = true 
	TFM.playEmote(name, 26)
	player.fishing[3][#player.fishing[3]+1] = addImage(playerStatus.isFacingRight and '170b1daa3ed.png' or '170b1daccfb.png', '$'..name, playerStatus.isFacingRight and 0 or -40, -42)

	player.fishing[2] = addTimer(function(j)
		if j == 2 then 
			playerStatus = ROOM.playerList[name]
			if not players[name].canDrive and biome == 'sea' then
				checkIfPlayerIsDriving(name)
				movePlayer(name, playerStatus.x, playerStatus.y, false)
				addGround(77777 + playerStatus.id, playerStatus.x + (playerStatus.isFacingRight and 40 or -40), playerStatus.y - 40, {type = 14, miceCollision = false, groundCollision = false})
				addGround(77777 + playerStatus.id+1, playerStatus.x + (playerStatus.isFacingRight and 70 or -70), playerStatus.y - 30, {type = 14, dynamic = true, miceCollision = false})

				TFM.addJoint(77777 + playerStatus.id, 77777 + playerStatus.id, 77777 + playerStatus.id+1, {type = 0, color = 0xc1c1c1, line = 1, frequency = 0.2})
				for i = 1, #player.fishing[3] do 
					removeImage(player.fishing[3][i])
				end
				player.fishing[3] = {}
				player.fishing[3][#player.fishing[3]+1] = addImage(playerStatus.isFacingRight and '170b1daa3ed.png' or '170b1daccfb.png', '$'..name, playerStatus.isFacingRight and 0 or -40, -42)

			else
				player.fishing[3][#player.fishing[3]+1] = addImage('170b66954aa.png', '$'..name, playerStatus.isFacingRight and 35 or -40, -35)
			end
			
		elseif j == 28 then 
			player.fishing[1] = false
			TFM.playEmote(name, 9)
			job_updatePlayerStats(name, 3)

			local align = playerStatus.isFacingRight and 20 or -90
			for particles = 1, 10 do
				TFM.displayParticle(14, particles * 3 + x + align, y + 50,  random(-5, 5), random(-2, 0.5), random(-0.7, 0.1))
			end

			randomseed(os_time())
			local willFish = room.fishing.biomes[biome].fishes[rarityFished][random(#room.fishing.biomes[biome].fishes[rarityFished])]
			local willFishInfo = bagItems[willFish]

			modernUI.new(name, 120, 120)
			:build()
			players[name]._modernUISelectedItemImages[1][#players[name]._modernUISelectedItemImages[1]+1] = addImage(willFishInfo.png, ":70", 400 - 50 * 0.5, 180, name)

			local canAddItem = true
			if willFish:find('Goldenmare') then
				local amount = (checkItemInChest('fish_Goldenmare', 1, name) or 0) + (checkItemQuanty('fish_Goldenmare', 1, name) or 0)
				if amount > 10 then
					canAddItem = false
					giveCoin(10000, name)
					chatMessage('<j>'..translate('seedSold', name):format('<vp>'..translate('item_fish_Goldenmare', name)..'</vp>', '<fc>$10000</fc>'), name)
				end
			end
			if canAddItem then
				addItem(willFish, 1, name)
			end

			if rarityFished == 'normal' then 
				players[name].lucky[1]['normal'] = player.lucky[1]['normal'] - .5
				players[name].lucky[1]['rare'] = player.lucky[1]['rare'] + .5
				giveExperiencePoints(name, 10)
			elseif rarityFished == 'rare' then 
				players[name].lucky[1]['rare'] = player.lucky[1]['rare'] - .25
				players[name].lucky[1]['mythical'] = player.lucky[1]['mythical'] + .25	
				giveExperiencePoints(name, 100)
			elseif rarityFished == 'mythical' then 
				players[name].lucky[1]['normal'] = player.lucky[1]['normal'] + player.lucky[1]['mythical']/2
				players[name].lucky[1]['legendary'] = player.lucky[1]['legendary'] + player.lucky[1]['mythical']/2
				players[name].lucky[1]['mythical'] = 0
				giveExperiencePoints(name, 500)
			else
				players[name].lucky[1] = {normal = 100, rare = 0, mythical = 0, legendary = 0}	
				giveExperiencePoints(name, 1000)
				translatedMessage('caught_goldenmare', name)
			end

			local sidequest = sideQuests[player.sideQuests[1]].type
			if sidequest == 'type:fish' or string_find(sidequest, willFish) then
				sideQuest_update(name, 1)
			end
			for id, properties in next, player.questLocalData.other do 
				if id:find('fish_') then
					if type(properties) == 'boolean' then 
						quest_updateStep(name)
					else 
						player.questLocalData.other[id] = properties - 1
						if player.questLocalData.other[id] == 0 then 
							quest_updateStep(name)
						end
					end
					break
				end
			end
			for i = 1, #player.fishing[3] do 
				removeImage(player.fishing[3][i])
			end
			players[name].fishing[3] = {}
			for i = 77777 + playerStatus.id, 77777 + playerStatus.id+2 do 
				removeGround(i)
			end
			setLifeStat(name, 1, random(-11, -8))
		end
	end, 1000, 28)
end

stopFishing = function(player)
	local playerStatus = ROOM.playerList[player]
	if not playerStatus then return end
	players[player].fishing[1] = false
	removeTimer(players[player].fishing[2])
	chatMessage('<r>'..translate('fishingError', player), player)
	for i = 1, #players[player].fishing[3] do 
		removeImage(players[player].fishing[3][i])
	end
	players[player].fishing[3] = {}
	for i = 77777 + playerStatus.id, 77777 + playerStatus.id+2 do 
		removeGround(i)
	end
end