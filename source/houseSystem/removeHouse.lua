HouseSystem.removeHouse = function(self)
	local ownerData = players[self.houseOwner]
	if ownerData.houseData.houseid > 0 then
		local terrainID = ownerData.houseData.houseid
		for i = 1, 4 do
			removeTextArea('-730'..i..(ownerData.houseData.houseid*10))
			removeGround(- 2000 - (terrainID-1)*30 - i)
		end
		ownerData.houseData.houseid = -10
		ownerData.houseData.currentHouse = nil
		removeGroupImages(room.houseImgs[terrainID].expansions)
		removeGroupImages(room.houseImgs[terrainID].furnitures)
		removeGroupImages(room.houseImgs[terrainID].img)
		for i = 0, 15 do
			removeGround(-6500+terrainID*20-i)
		end
		for i, v in next, ownerData.houseData.furnitures.placed do 
			local furniture = mainAssets.__furnitures[v.type]
			if furniture.grounds then
				removeGround(- 7000 - (terrainID-1)*200 - i)
			end
		end
		room.houseImgs[terrainID].img[#room.houseImgs[terrainID].img+1] = addImage('174ea4a42d3.png', "?" .. terrainID + 100, mainAssets.__terrainsPositions[terrainID][1], mainAssets.__terrainsPositions[terrainID][2])
		for name in next, ROOM.playerList do
			showTextArea(terrainID + 44, "<a href='event:buyhouse_" .. terrainID .. "'><font color='#ffffff'>" .. translate("sale", name), name, mainAssets.__terrainsPositions[terrainID][1]+40, mainAssets.__terrainsPositions[terrainID][2]+114, nil, nil, 0xFF0000, 0xFF0000, 0)
		end
		for guest in next, room.terrains[terrainID].guests do
			if room.terrains[terrainID].guests[guest] then 
				getOutHouse(guest, terrainID)
			end
		end
		removeTextArea(terrainID)
		room.terrains[terrainID] = {img = {}, bought = false, owner = nil, settings = {}, groundsLoadedTo = {}, guests = {}}
	end
	return setmetatable(self, HouseSystem)
end