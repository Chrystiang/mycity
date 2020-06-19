generateLevelImage = function(player, level, requested)
	if player == requested then 
		TFM.setPlayerScore(player, level)
	end
	local level = tostring(level)
	local iconImage = mainAssets.levelIcons.lvl -- change to player current star icon
	local playerImage = players[requested].playerNameIcons.level
	if not playerImage[player] then 
		playerImage[player] = {}
	else 
		for i = 1, #playerImage[player] do 
			removeImage(playerImage[player][i])
		end 
		playerImage[player] = {}
	end
	playerImage[player][#playerImage[player]+1] = addImage("1716206af81.png", "$"..player, -10, requested ~= player and -70 or -80, requested)
	for i = 1, #level do 
		local id = tonumber(level:sub(i, i))+1
		playerImage[player][#playerImage[player]+1] = addImage(iconImage[id][1], "$"..player, (i-1)*8 - (#level*8)/2 -5, requested ~= player and -69 or -79, requested)
	end
end