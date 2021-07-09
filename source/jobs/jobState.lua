job_fire = function(i)
	if not players[i] then return end
	if not ROOM.playerList[i] then return end
	removeGroupImages(players[i].images)
	TFM.setNameColor(i, 0)

	local job = players[i].job
	if not job then return end
	jobs[job].working[i] = nil
	for index, player in next, jobs[job].working do
		if player == i then 
			table_remove(jobs[job].working, index)
			break
		end
	end
	players[i].job = nil
	local images = players[i].temporaryImages.jobDisplay
	if images[1] then 
		for i = 1, #images do 
			removeImage(images[i])
		end 
		players[i].temporaryImages.jobDisplay = {}
		removeTextArea(1012, i)
	end
	if job == 'farmer' then 
		for i = 1, 4 do
			removeTextArea('-730'..(i..tonumber(players['Oliver'].houseData.houseid)*10), i)
		end
	end
end

job_invite = function(job, player)
	local playerData = players[player]
	if not jobs[job] or not playerData then return end
	if playerData.job == job then return end 
	modernUI.new(player, 240, 220)
	:build()
	:jobInterface(job)
	:addConfirmButton(function(player, job) job_hire(job, player) end, translate('confirmButton_Work', player), job)
end

job_hire = function(job, player)
	local playerData = players[player]
	if not playerData or playerData.robbery.robbing then return end
	if job == 'police' and playerData.place ~= 'police' then 
		return alert_Error(player, 'error', 'error')
	end

	if playerData.job then 
		job_fire(player)
	end
	players[player].temporaryImages.jobDisplay[#players[player].temporaryImages.jobDisplay+1] = addImage("171d301df6c.png", ":1", 0, 22, player)
	players[player].temporaryImages.jobDisplay[#players[player].temporaryImages.jobDisplay+1] = addImage(jobs[job].icon, ":2", 107, 22, player)
	showTextArea(1012, '<p align="center"><b><font size="14" color="#371616">'..translate(job, player), player, 0, 29, 110, 30, 0x1, 0x1, 0, true)

	if job ~= 'thief' then
		TFM.setNameColor(player, '0x'..jobs[job].color)
		if jobs[job].specialAssets then 
			jobs[job].specialAssets(player)
		end
	else 
		TFM.setNameColor(player, 0)
	end
		
	local image = playerData.callbackImages
	if image[1] then
		for i = 1, #image do
			removeImage(image[i])
		end
		players[player].callbackImages = {}
	end

	players[player].job = job
	jobs[job].working[#jobs[job].working+1] = player
end

job_updatePlayerStats = function(player, type, quant)
	if not quant then quant = 1 end
	local playerData = players[player]
	if not players[player].jobs[type] then players[player].jobs[type] = 0 end
	players[player].jobs[type] = playerData.jobs[type] + quant

	if playerData.jobs[4] >= 1000 then
		giveBadge(player, 3)
	end
	if playerData.jobs[3] >= 500 then
		giveBadge(player, 2)
	end
	if playerData.jobs[5] >= 500 then
		giveBadge(player, 4)
	end
	if playerData.jobs[6] >= 500 then
		giveBadge(player, 8)
	end
	if playerData.jobs[2] >= 500 then -- THIEF
		giveBadge(player, 5)
	end
	if playerData.jobs[1] >= 500 then -- COP
		giveBadge(player, 10)
	end
	if playerData.jobs[9] >= 500 then -- Deliver 500 orders
		giveBadge(player, 9)
	end
	if playerData.jobs[10] >= 500 then -- Cook 500 dishes
		giveBadge(player, 14)
	end
	if playerData.jobs[12] >= 300 then -- Sold 300 yellow crystals
		giveBadge(player, 15)
	end
	if playerData.jobs[13] >= 150 then -- Sold 150 blue crystals
		giveBadge(player, 16)
	end
	if playerData.jobs[14] >= 75 then -- Sold 75 purple crystals
		giveBadge(player, 17)
	end
	if playerData.jobs[15] >= 30 then -- Sold 30 green crystals
		giveBadge(player, 18)
	end
	if playerData.jobs[16] >= 10 then -- Sold 10 red crystals
		giveBadge(player, 19)
	end
	if playerData.jobs[11] >= 500 then -- Sell 500 fruits
		giveBadge(player, 25)
	end
	--17: Halloween 2019 
	--24: Christmas 2020

	savedata(player)
end