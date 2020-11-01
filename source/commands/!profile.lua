chatCommands.profile = {
	event = function(player, args)
		local target = string_nick(args[1])
		openProfile(player, target)
	end
}
chatCommands.perfil = table_copy(chatCommands.profile)
chatCommands.profil = table_copy(chatCommands.profile)