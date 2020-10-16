gameNpcs.removeNPC = function(npcName, target)
	local npc = gameNpcs.characters[npcName]
	if not target then 
		for player, v in next, npc.players do
			if v.image then  
				removeImage(v.image)
				gameNpcs.removeTextAreas(v.id, player)
				v.image = nil
			end
		end
		npc.visible = false 
	else
		local v = npc.players[target]
		if v.image then 
			removeImage(v.image)
			v.image = nil
			gameNpcs.removeTextAreas(v.id, target)
		end
	end
end