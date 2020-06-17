gameNpcs.removeTextAreas = function(id, player)
	local ID = -89000+(id*6)
	for i = 0, 5 do 
		ui.removeTextArea(ID+i, player)
	end
end