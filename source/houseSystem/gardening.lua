HouseSystem.gardening = function()
	for i, v in ipairs(room.gardens) do
		if players[v.owner].houseTerrainAdd[v.terrain] < #HouseSystem.plants[players[v.owner].houseTerrainPlants[v.terrain]].stages then
			local growingTime = HouseSystem.plants[players[v.owner].houseTerrainPlants[v.terrain]].growingTime*1000
			if os_time() - v.timer >= growingTime then
				players[v.owner].houseTerrainAdd[v.terrain] = players[v.owner].houseTerrainAdd[v.terrain]+1
				v.timer = os_time()
				HouseSystem.new(v.owner):genHouseGrounds()
				savedata(v.owner)
			end
		else
			local y = 1590
			if v.owner ~= 'Oliver' then
				showTextArea('-730'..(tonumber(v.terrain)..tonumber(players[v.owner].houseData.houseid)*10), '<a href="event:harvest_'..tonumber(v.terrain)..'"><p align="center"><font size="15">'..translate('harvest', v.owner)..'</font></p></a>', v.owner, ((tonumber(v.idx)-1)%tonumber(v.idx))*1500+738-(175/2)-2 + (tonumber(v.terrain)-1)*175, y+150, 175, 150, 0xff0000, 0xff0000, 0)
			else
				for ii, vv in next, ROOM.playerList do
					if players[ii].job == 'farmer' then
						showTextArea('-730'..(tonumber(v.terrain)..tonumber(players[v.owner].houseData.houseid)*10), '<a href="event:harvest_'..tonumber(v.terrain)..'"><p align="center"><font size="15">'..translate('harvest', ii)..'</font></p></a>', ii, ((tonumber(v.idx)-1)%tonumber(v.idx))*1500+738-(175/2)-2 + (tonumber(v.terrain)-1)*175, y+150, 175, 150, 0xff0000, 0xff0000, 0)
					end
				end
			end
			savedata(v.owner)
			table_remove(room.gardens, i)
		end
	end
end

HouseSystem.fertilize = function(player, speed)
	if not players[player].place:find('house_') then return end
	local house = tonumber(players[player].place:sub(7))
	local owner = player

	if house == 12 then
		owner = 'Oliver'
		if players[player].job ~= 'farmer' then
			return
		end
	end
	
	if table_find(players[owner].houseTerrain, 2) then
		local x = ROOM.playerList[player].x
		local y = ROOM.playerList[player].y
		local idx = tonumber(players[owner].houseData.houseid)
		local yy = 1590
		for i, v in next, players[owner].houseTerrain do
			if v == 2 then
				if math_hypo(((idx-1)%idx)*1500+737 + (i-1)*175, yy+170, x, y) <= 90 then
					if players[owner].houseTerrainAdd[i] > 1 then
						for ii, vv in next, room.gardens do
							if vv.owner == owner then
								if vv.terrain == i then
									vv.timer = vv.timer - (speed * 60000)
									local sidequest = sideQuests[players[player].sideQuests[1]].type
									if string_find(sidequest, 'type:fertilize') then
										if (sidequest:find('oliver') and owner == 'Oliver') or not string_find(sidequest, 'oliver') then
											sideQuest_update(player, 1)
										end
									end
									return true
								end
							end
						end
					end
				end
			end
		end
	end

	return false
end

HouseSystem.removeCrop = function(player)
	if not players[player].place:find('house_') then return end
	local house = tonumber(players[player].place:sub(7))
	local owner = player
	if house == 12 then return end
	if table_find(players[owner].houseTerrain, 2) then
		local x = ROOM.playerList[player].x
		local y = ROOM.playerList[player].y
		local idx = tonumber(players[owner].houseData.houseid)
		local yy = 1590
		for i, v in next, players[owner].houseTerrain do
			if v == 2 then
				if math_hypo(((idx-1)%idx)*1500+737 + (i-1)*175, yy+170, x, y) <= 90 then
					if players[owner].houseTerrainAdd[i] > 1 then
						for ii, vv in next, room.gardens do
							if vv.owner == owner then
								if vv.terrain == i then
									removeTextArea('-730'..(i..(house*10)))
									players[owner].houseTerrainAdd[i] = 1
									players[owner].houseTerrainPlants[i] = 0
									HouseSystem.new(owner):genHouseGrounds()
									savedata(owner)
									table_remove(room.gardens, ii)
									return true
								end
							end
						end
					end
				end
			end
		end
	end
end