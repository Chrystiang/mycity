HouseSystem.loadTerrains = function(self)
	local name = self.houseOwner
	local nameData = players[name]
	if room.terrains[1] then
		for i = 1, #mainAssets.__terrainsPositions do
			if not room.terrains[i].bought then
				room.houseImgs[i].img[#room.houseImgs[i].img+1] = addImage('1708781ad73.png', "?"..i+100, mainAssets.__terrainsPositions[i][1], mainAssets.__terrainsPositions[i][2], name)
				ui.addTextArea(44 +  i, '<a href="event:buyhouse_'..i..'"><font color="#fffffff">' .. translate('sale', name), name, mainAssets.__terrainsPositions[i][1]+40, mainAssets.__terrainsPositions[i][2]+114, nil, nil, 0xFF0000, 0xFF0000, 0)
			else
				self.houseOwner = room.terrains[i].owner
				room.terrains[i].groundsLoadedTo[name] = false
				HouseSystem.genHouseFace(self, name)
			end
		end
	end
	return setmetatable(self, HouseSystem)
end