modernUI.showAvailableTradingPlayers = function(self)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = (400 - width/2) + 20
	local y = (200 - height/2) + 70
	local playerList = {}
	local i = 1

	for user in next, ROOM.playerList do
		if user ~= player and players[user] and players[user].dataLoaded and players[user].inRoom then
			ui.addTextArea(id..(896+i), user, player, x+4 + (i-1)%2*173, y + math.floor((i-1)/2)*15, nil, nil, -1, 0xff0000, 0, true, 
				function(player, i)
					ui.addTextArea(id..'930', '<p align="center"><ce>'..user..'</ce>', player, x+4 + (i-1)%2*173, y + math.floor((i-1)/2)*15, 150, 70, 0x432c04, 0x7a5817, 1, true)
					ui.addTextArea(id..'931', translate('txt_openProfile', player), player, x+4 + (i-1)%2*173, y + 25 + math.floor((i-1)/2)*15, nil, nil, 0x432c04, 0x7a5817, 0, true,
						function()
							eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
							openProfile(player, user)
						end)
					ui.addTextArea(id..'932', translate('trade_invitePlayer', player), player, x+4 + (i-1)%2*173, y + 25 + math.floor((i-1)/2)*15 + 15, nil, nil, 0x432c04, 0x7a5817, 0, true,
						function()
							eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
							if players[user].questStep[1] <= 4 then return alert_Error(player, 'error', 'trade_error_quest2', user, '<r>'..translate('req_4', player)..'</r>') end
							if players[player].questStep[1] <= 4 then return alert_Error(player, 'error', 'trade_error_quest', '<r>'..translate('req_4', player)..'</r>') end
							tradeSystem.invite(player, user)
						end)
				end, i)
			i = i + 1
		end
	end
	return setmetatable(self, modernUI)
end