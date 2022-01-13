initialization.Recipes = function()
	for i, v in next, recipes do
		if v.require then
			newFoodValue(i)
			newEnergyValue(i)
			newDishPrice(i)
		end
	end
end