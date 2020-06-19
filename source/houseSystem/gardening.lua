gardening = function()
	for i, v in ipairs(room.gardens) do
		if players[v.owner].houseTerrainAdd[v.terrain] < #houseTerrainsAdd.plants[players[v.owner].houseTerrainPlants[v.terrain]].stages then
			if os.time() - v.timer >= houseTerrainsAdd.plants[players[v.owner].houseTerrainPlants[v.terrain]].growingTime*1000 then
				players[v.owner].houseTerrainAdd[v.terrain] = players[v.owner].houseTerrainAdd[v.terrain]+1
				v.timer = os.time()
				HouseSystem.new(v.owner):genHouseGrounds()
				savedata(v.owner)
			end
		else
			local y = 1500 + 90
			if v.owner ~= 'Oliver' then
				ui.addTextArea('-730'..(tonumber(v.terrain)..tonumber(players[v.owner].houseData.houseid)*10), '<a href="event:harvest_'..tonumber(v.terrain)..'"><p align="center"><font size="15">'..translate('harvest', v.owner)..'</font></p></a>', v.owner, ((tonumber(v.idx)-1)%tonumber(v.idx))*1500+738-(175/2)-2 + (tonumber(v.terrain)-1)*175, y+150, 175, 150, 0xff0000, 0xff0000, 0)
			else
				for ii, vv in next, ROOM.playerList do
					if players[ii].job == 'farmer' then
						ui.addTextArea('-730'..(tonumber(v.terrain)..tonumber(players[v.owner].houseData.houseid)*10), '<a href="event:harvest_'..tonumber(v.terrain)..'"><p align="center"><font size="15">'..translate('harvest', ii)..'</font></p></a>', ii, ((tonumber(v.idx)-1)%tonumber(v.idx))*1500+738-(175/2)-2 + (tonumber(v.terrain)-1)*175, y+150, 175, 150, 0xff0000, 0xff0000, 0)
					end
				end
			end
			savedata(v.owner)
			table.remove(room.gardens, i)
		end
	end
end