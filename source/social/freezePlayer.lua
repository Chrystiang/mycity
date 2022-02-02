freezePlayer = function(player, freeze, displayIce)
	TFM.freezePlayer(player, freeze, displayIce)
	if not players[player] then return end
	players[player].isFrozen = freeze
end