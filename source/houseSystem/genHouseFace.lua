HouseSystem.genHouseFace = function(self, guest)
	local ownerData = players[self.houseOwner]
	local terrainID = ownerData.houseData.houseid
	local houseType = ownerData.houseData.currentHouse
	local complement = self.houseOwner:match('#0000') and self.houseOwner:gmatch('(.-)#[0-9]+$')() or self.houseOwner:gsub('#', '<font size="7"><g>#')

	local y = self.y
	if not guest then
		removeGroupImages(room.houseImgs[terrainID].img)
	end
	room.houseImgs[terrainID].img[#room.houseImgs[terrainID].img+1] = addImage(mainAssets.__houses[houseType].outside.icon, "?100"..terrainID, mainAssets.__terrainsPositions[terrainID][1] + mainAssets.__houses[houseType].outside.axis[1], mainAssets.__terrainsPositions[terrainID][2]+60 + mainAssets.__houses[houseType].outside.axis[2], guest)
	room.houseImgs[terrainID].img[#room.houseImgs[terrainID].img+1] = addImage('17272033fc9.png', "_600"..terrainID, mainAssets.__terrainsPositions[terrainID][1], mainAssets.__terrainsPositions[terrainID][2]+176, guest)

	showTextArea(44 + terrainID, '<p align="center"><font size="12"><a href="event:joinHouse_'..terrainID..'">'..complement..'\n', guest, mainAssets.__terrainsPositions[terrainID][1], mainAssets.__terrainsPositions[terrainID][2]+176+23, 150, nil, 0x1, 0x1, 0)
	showTextArea(terrainID, '<p align="center">' .. terrainID, guest, mainAssets.__terrainsPositions[terrainID][1], mainAssets.__terrainsPositions[terrainID][2]+176+11, 150, nil, 0, 0)
	room.houseImgs[terrainID].img[#room.houseImgs[terrainID].img+1] = addImage(mainAssets.__houses[houseType].inside.image, "?100", (terrainID-1)*1500 + 60, 847, guest)
	room.houseImgs[terrainID].img[#room.houseImgs[terrainID].img+1] = addImage('17256286356.jpg', '?901', (terrainID-1)*1500 + 317, 1616, guest) -- door
	room.houseImgs[terrainID].img[#room.houseImgs[terrainID].img+1] = addImage('1725d43cb08.png', '_9020', (terrainID-1)*1500 + 317, 1616, guest) -- handle

	for i, v in next, ownerData.houseData.furnitures.placed do 
		local x = v.x + (terrainID-1)*1500
		local y = v.y + 1000
		room.houseImgs[terrainID].furnitures[#room.houseImgs[terrainID].furnitures+1] = addImage(mainAssets.__furnitures[v.type].image, '?1000'..i, x, y, guest)
		local furniture = mainAssets.__furnitures[v.type]
		if furniture.grounds then
			furniture.grounds(x,  y, - 7000 - (terrainID-1)*200 - i)
		end
		if furniture.usable then
			if not guest then
				showTextArea(- 85000 - (terrainID*200 + i), "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', mainAssets.__furnitures[v.type].area[2]/8), self.houseOwner, x, y, mainAssets.__furnitures[v.type].area[1], mainAssets.__furnitures[v.type].area[2], 1, 0xfff000, 0, false, 
					function(player)
						furniture.usable(player)
					end)
				if furniture.name == 'chest' or furniture.name == 'freezer' then
					players[self.houseOwner].houseData.chests.position[furniture.uniqueID] = {x = x, y = y}
				end
			end
		end
	end
	for i, v in next, ownerData.houseTerrain do
		if v == 2 then
			if ownerData.houseTerrainAdd[i] > 1 then
				room.gardens[#room.gardens+1] = {owner = self.houseOwner, timer = os_time(), terrain = i, idx = terrainID, plant = ownerData.houseTerrainPlants[i]}
			end
		end
	end

	if mainAssets.__houses[houseType].inside.grounds then 
		mainAssets.__houses[houseType].inside.grounds(terrainID)
	end
	return setmetatable(self, HouseSystem)
end