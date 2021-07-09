onEvent('EmotePlayed', function(player, emote)
	if player and isExploiting[player] then return end
	if room.gameMode then return end
	if room.isInLobby then return end
	if emote ~= 11 and players[player].fishing[1] then
		stopFishing(player)
	end
end)