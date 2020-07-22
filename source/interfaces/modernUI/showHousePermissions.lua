modernUI.showHousePermissions = function(self)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) + 20
	local y = (200 - height/2) + 70
	local playerList = {}
	local i = 1
	local terrainID = players[player].houseData.houseid
	local function button(i, text, callback, x, y)
		local width = 150
		local height = 15
		ui.addTextArea(id..(930+i*5), '', player, x-1, y-1, width, height, 0x95d44d, 0x95d44d, 1, true)
		ui.addTextArea(id..(931+i*5), '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
		ui.addTextArea(id..(932+i*5), '', player, x, y, width, height, 0x44662c, 0x44662c, 1, true)
		ui.addTextArea(id..(933+i*5), '<p align="center"><font color="#cef1c3" size="13">'..text..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true, callback)
	end
	for user in next, ROOM.playerList do
		if user ~= player and players[user] and players[user].inRoom then
			ui.addTextArea(id..(896+i), user, player, x+4 + (i-1)%2*173, y + math.floor((i-1)/2)*15, nil, nil, -1, 0xff0000, 0, true, 
				function(player, i)
					if not room.terrains[terrainID].settings.permissions[user] then room.terrains[terrainID].settings.permissions[user] = 0 end
					local userPermission = room.terrains[terrainID].settings.permissions[user]
					ui.addTextArea(id..'930', '<p align="center"><ce>'..user..'</ce>\n<v><font size="10">«'..translate("permissions_"..mainAssets.housePermissions[userPermission], player)..'»</font></v>', player, x+4 + (i-1)%2*173, y + math.floor((i-1)/2)*15, 150, 70, 0x432c04, 0x7a5817, 1, true)
					local counter = 0
					for _ = -1, 1 do
						if _ ~= room.terrains[terrainID].settings.permissions[user] then
							ui.addTextArea(id..(931+counter), translate('setPermission', player):format(translate('permissions_'..mainAssets.housePermissions[_], player)), player, x+4 + (i-1)%2*173, y + 25 + math.floor((i-1)/2)*15 + counter*15, nil, nil, 0x432c04, 0x7a5817, 0, true,
								function()
									if room.terrains[terrainID].settings.permissions[user] == _ then return end
									room.terrains[terrainID].settings.permissions[user] = _
									for i = 930, 934 do
										ui.removeTextArea(id..i, player)
									end
									if _ == -1 then
										if room.terrains[terrainID].guests[user] then 
											getOutHouse(user, terrainID)
											alert_Error(user, 'error', 'error_blockedFromHouse', player)
										end
									end
								end)
							counter = counter + 1
						end
					end
				end, i)
			i = i + 1
		end
	end
	local function buttonAction(option)
		if option == 1 then
			if not room.terrains[terrainID].settings.isClosed then
				for guest in next, room.terrains[terrainID].guests do
					if room.terrains[terrainID].guests[guest] then 
						if not room.terrains[terrainID].settings.permissions[guest] then room.terrains[terrainID].settings.permissions[guest] = 0 end
						if room.terrains[terrainID].settings.permissions[guest] < 1 then
							getOutHouse(guest, terrainID)
							alert_Error(guest, 'error', 'error_houseClosed', player)
						end
					end
				end
			end
			room.terrains[terrainID].settings.isClosed = not room.terrains[terrainID].settings.isClosed
		elseif option == 2 then 
			room.terrains[terrainID].settings.permissions = {[player] = 4}
		end
		eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
	end
	for i, v in next, {room.terrains[terrainID].settings.isClosed and translate('houseSettings_unlockHouse', player) or translate('houseSettings_lockHouse', player), translate('houseSettings_reset', player)} do
		button(i, v, function() 
			buttonAction(i)
		end, x + 12 + (i-1)*166, y + 175)
	end
	return setmetatable(self, modernUI)
end