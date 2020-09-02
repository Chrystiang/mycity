HouseSystem.genHouseGrounds = function(self, guest)
	local ownerData = players[self.houseOwner]
	local houseType = ownerData.houseData.currentHouse
	local terrainID = ownerData.houseData.houseid
	local y = self.y
	if not guest then 
		player_removeImages(room.houseImgs[terrainID].expansions)
	end
	for i = 1, 4 do
		if HouseSystem.expansions[ownerData.houseTerrain[i]].add then
			HouseSystem.expansions[ownerData.houseTerrain[i]].add(self.houseOwner, 1590, terrainID, i, guest)
		end
	end
	return setmetatable(self, HouseSystem)
end