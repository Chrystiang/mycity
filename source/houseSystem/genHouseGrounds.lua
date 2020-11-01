HouseSystem.genHouseGrounds = function(self, guest)
	local ownerData = players[self.houseOwner]
	local houseType = ownerData.houseData.currentHouse
	local terrainID = ownerData.houseData.houseid
	local y = self.y
	if not guest then 
		removeGroupImages(room.houseImgs[terrainID].expansions)
	end
	for i = 1, 5 do
		if not ownerData.houseTerrain[i] then
			ownerData.houseTerrain[i] = 0
			ownerData.houseTerrainAdd[i] = 1
			ownerData.houseTerrainPlants[i] = 0
		end
		if HouseSystem.expansions[ownerData.houseTerrain[i]].add then
			HouseSystem.expansions[ownerData.houseTerrain[i]].add(self.houseOwner, 1590, terrainID, i, guest)
		end
	end
	return setmetatable(self, HouseSystem)
end