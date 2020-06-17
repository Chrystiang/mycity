updateDialogs = function(counter)
	for npc, v in next, dialogs do
		if v.running then 
			v.length = v.length + counter
			gameNpcs.updateDialogBox(npc)
		end
	end
end