chatCommands.profile = {
	event = function(player, args)
		local target = string.nick(args[1])
		openProfile(player, target)
	end
}
chatCommands.perfil = table.copy(chatCommands.profile)
chatCommands.profil = table.copy(chatCommands.profile)