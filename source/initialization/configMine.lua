initialization.Mine = function()
	for item, data in next, Mine.ores do 
		bagItems['crystal_'..item].price = floor(200*(12/data.rarity))
		bagItems['crystal_'..item].sellingPrice = floor(200*(12/data.rarity))
	end
	
	mine_generate()
end