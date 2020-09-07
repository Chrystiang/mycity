newFoodValue = function(recipe)
	local newValue = 0
	local ingredients = 0
	local spiceList = {
		pepper = 0.12,
	}

	for i, v in next, recipes[recipe].require do 
		local item = bagItems[i]
		if not item.hunger then 
			item.hunger = (not recipes[i] and 0.11 or math.floor(newFoodValue(i)))
		end 
		newValue = newValue + (item.hunger >= 0 and item.hunger or ((i:find('fish') or i:find('meat')) and math.abs(item.hunger)/1.62 or spiceList[i] and spiceList[i] or 0.57)) * v
		ingredients = ingredients + 1
	end
	bagItems[recipe].hunger = math.floor((ingredients/1.025) * newValue)
	return bagItems[recipe].hunger
end

newEnergyValue = function(recipe)
	local recipeHunger = bagItems[recipe].hunger
	local newValue = 0
	local ingredients = 0
	local spiceList = {
		pepper = 1.49,
		oregano = 1.09,
		lemon = 1.11,
		salt = 1.32,
		tomato = 1.32,
		garlic = 1.42,
	}

	for i, v in next, recipes[recipe].require do 
		local item = bagItems[i]
		if not item.power then 
			item.power = (not recipes[i] and 1.03 or math.floor(newEnergyValue(i)))
		end 
		newValue = newValue + ((item.power >= 0 and not spiceList[i]) and item.power*1.1 or ((i:find('fish') or i:find('meat')) and math.abs(item.power)/2.12 or spiceList[i] and spiceList[i] or 0.30)) * v
		ingredients = ingredients + 1
	end
	bagItems[recipe].power = math.floor((ingredients/0.971) * newValue/2)
	return bagItems[recipe].power
end

newDishPrice = function(recipe)
	local price = 100
	for i, v in next, recipes[recipe].require do 
		local item = bagItems[i]
		if item.price then 
			price = price + item.price 
		else 
			price = price + 10
		end
	end
	bagItems[recipe].sellingPrice = math.floor(price + price/4)
	return bagItems[recipe].sellingPrice
end