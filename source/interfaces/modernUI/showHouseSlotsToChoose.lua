modernUI.showHouseSlotsToChoose = function(self, houseId, terrainId)
	local id 		= self.id
	local player 	= self.player
	local width 	= self.width 
	local height 	= self.height
	local x 		= (400 - width/2) - 12
	local y 		= (200 - height/2) - 20

	for saveSlot = 1, 2 do
		local totalOfPlacedFurnitures = table_getLength(players[player].houseData.furnitures.placed[saveSlot])

		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage("1717eaef706.png", "~20", 288, y+65 + (saveSlot-1)*45, player)
		showTextArea(id..(900+(saveSlot-1)*3), '<font size="9"><bl><p align="right">'..translate('placedFurnitures', player):format('<v><b>'..totalOfPlacedFurnitures..'/'..maxPlacedFurnitures..'</b></v>'), player, 320, y+88 + (saveSlot-1)*45, 155, nil, 0xff0000, 0xff0000, 0, true)
		showTextArea(id..(901+(saveSlot-1)*3), '<b><ce>'..translate("slot", player):format(saveSlot), player, 320, y+65 + (saveSlot-1)*45, 155, 40, 0xff0000, 0xff0000, 0, true)

		showTextArea(id..(902+(saveSlot-1)*3), "<textformat leftmargin='1' rightmargin='1'>" .. string.rep('\n', 5), player, 320, y+65 + (saveSlot-1)*45, 155, 40, 0xff0000, 0xff0000, 0, true,
			function()
				players[player].houseData.currentSaveSlot = saveSlot
				eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
				loadHouse(player, houseId, terrainId)
			end)
	end
	
	return setmetatable(self, modernUI)
end