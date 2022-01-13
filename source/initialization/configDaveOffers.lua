initialization.DaveOffers = function()
	daveOffers = {}
	local i = 1
	while #daveOffers < 5 do
		randomseed(room.mathSeed * i^2)
		local offerID = random(1, #mainAssets.__farmOffers)
		local nextItem = mainAssets.__farmOffers[offerID].item[1]
		local alreadySelling = false
		for id, offer in next, daveOffers do
			local item = mainAssets.__farmOffers[offer].item[1]
			if item == nextItem then
				alreadySelling = true
			end
		end
		if not alreadySelling then
			daveOffers[#daveOffers+1] = offerID
		end
		i = i + 1
	end
end