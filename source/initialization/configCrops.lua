initialization.Crops = function()
	for i, v in next, HouseSystem.plants do
		if bagItems[v.name] then
			bagItems[v.name].sellingPrice = bagItems[v.name].sellingPrice or v.pricePerSeed/10
			bagItems[v.name].isFruit = true
		end
	end
end