local _bindMouse = {}
chatCommands.teleport = {
	permissions = {'admin'},
	event = function(player)
		if not _bindMouse[player] then
			_bindMouse[player] = false
		end
		_bindMouse[player] = not _bindMouse[player]
		system.bindMouse(player, _bindMouse[player])
		chatMessage('<g>[•] Done! Teleport '.. (_bindMouse[player] and 'enabled' or 'disabled'), player)
	end
}