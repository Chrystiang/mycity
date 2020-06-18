local commandImages = {}
chatCommands.image = {
	permissions = {'admin'},
	event = function(player, args)
		local image = args[1] or ''
		local imgType = args[2] or '!10'
		local x = args[3] or -100
		local y = args[4] or -100

		commandImages[#commandImages+1] = addImage(image, imgType, x, y)
		TFM.chatMessage('<FC>Adding image... ID: <rose>'..#commandImages..'</rose>\n<t>' .. 
			' Ξ url: '..image..'\n' .. 
			' Ξ type: '..imgType..'\n' ..
			' Ξ x: '..x..'\n' ..
			' Ξ y: '..y
		, player)
	end
}
chatCommands.removeimage = {
	permissions = {'admin'},
	event = function(player, args)
		local id = tonumber(args[1])
		if commandImages[id] then
			removeImage(commandImages[id])
			commandImages[id] = nil
			TFM.chatMessage('<g>image removed!', player)
		end
	end
}
