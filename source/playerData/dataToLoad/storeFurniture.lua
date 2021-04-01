storeFurniture = function(name, furniture)
	local isTable = type(furniture) == 'table'
	if isTable then
		local furnitureID = furniture[1]
		local amount = furniture[2]
		players[name].houseData.furnitures.stored[furnitureID] = {quanty = amount, type = furnitureID}
	else
		if not players[name].houseData.furnitures.stored[furniture] then
			players[name].houseData.furnitures.stored[furniture] = {quanty = 1, type = furniture}
		else
			players[name].houseData.furnitures.stored[furniture].quanty = players[name].houseData.furnitures.stored[furniture].quanty + 1
		end
	end
end