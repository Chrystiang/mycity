gameNpcs.reAddNPC = function(npcName)
	local npc = gameNpcs.characters[npcName]
	if npc.visible then return end
	local image = npc.image
	local type = npc.type
	local x = npc.x
	local y = npc.y
	local callback = npc.callback
	local color = npc.color
	npc.visible = true
	for player, v in next, npc.players do 
		local id = -89000+(v.id*6)
		gameNpcs.setNPCName(id, npcName, callback, player, x, y, color, true)
		v.image = addImage(image, type.."1000", x, y, player, npc.properties)
	end
end