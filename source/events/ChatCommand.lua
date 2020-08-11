onEvent("ChatCommand", function(player, command)
	if room.isInLobby then return end

	local args = {}
	for i in command:gmatch('%S+') do
		args[#args+1] = i
	end
	local command = table.remove(args, 1):lower()
	if chatCommands[command] then
		local continue = false
		if not chatCommands[command].permissions then
			continue = true
		else
			for _, role in next, chatCommands[command].permissions do
				if table.contains(mainAssets.roles[role], player) then
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