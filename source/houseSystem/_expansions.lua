HouseSystem.expansions = {
	[0] = {
		name = 'grass',
		png = '16c0abef269.png',
		price = 100,
	},
	[1] = {
		name = 'pool',
		png = '16c0abf2610.png',
		price = 2000,
		add = function(owner, y, terrainID, plotID, guest)
			room.houseImgs[terrainID].expansions[#room.houseImgs[terrainID].expansions+1] = addImage('16bc4577c60.png', '!1', (terrainID-1)*1500+737-(175/2) + (plotID-1)*175, y+170-30, guest)
		end,
	},
	[2] = {
		name = 'garden',
		png = '16c0abf41c9.png',
		price = 4000,
		add = function(owner, y, terrainID, plotID, guest)
			if players[owner].houseTerrainPlants[plotID] == 0 then players[owner].houseTerrainPlants[plotID] = 1 end
			local stage = HouseSystem.plants[players[owner].houseTerrainPlants[plotID]].stages[players[owner].houseTerrainAdd[plotID]]
			room.houseImgs[terrainID].expansions[#room.houseImgs[terrainID].expansions+1] = addImage('16bf5b9e800.jpg', '_99991', (terrainID-1)*1500+738-(175/2) + (plotID-1)*175, y+170-45, guest)
			room.houseImgs[terrainID].expansions[#room.houseImgs[terrainID].expansions+1] = addImage(stage, '!200000', (terrainID-1)*1500+738-(175/2) + (plotID-1)*175, y+170-45-280, guest)
			if owner == 'Oliver' then
				room.houseImgs[terrainID].expansions[#room.houseImgs[terrainID].expansions+1] = addImage(stage, '?10', 11330 + (plotID-1)*65, 7470+30, guest)
			end
		end,
	},
}