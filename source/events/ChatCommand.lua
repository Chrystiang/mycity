onEvent("ChatCommand", function(player, command)
	if room.gameMode then return end
	if room.isInLobby then return end
	if not players[player].dataLoaded then return end
	
	local args = {}
	for i in command:gmatch('%S+') do
		args[#args+1] = i
	end
	local command = table_remove(args, 1):lower()
	if chatCommands[command] then
		local continue = false
		if not chatCommands[command].permissions then
			continue = true
		else
			for _, role in next, chatCommands[command].permissions do
				if table_find(mainAssets.roles[role], player) then
					continue = true
					break
				end
			end
		end
		if continue then
			chatCommands[command].event(player, args)
		end
	end
end)