freezePlayer = function(player, freeze)
	TFM.freezePlayer(player, freeze)
	if not players[player] then return end
	players[player].isFrozen = freeze
end