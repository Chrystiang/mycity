gameNpcs.setNPCName = function(id, name, callback, player, x, y, color, canClick)
	ui.addTextArea(id+0, "<font color='#000000'><p align='center'>"..name, player, x-1, y+41, 100, nil, 1, 1, 0)
	ui.addTextArea(id+1, "<font color='#000000'><p align='center'>"..name, player, x-1, y+39, 100, nil, 1, 1, 0)
	ui.addTextArea(id+2, "<font color='#000000'><p align='center'>"..name, player, x+1, y+41, 100, nil, 1, 1, 0)
	ui.addTextArea(id+3, "<font color='#000000'><p align='center'>"..name, player, x+1, y+39, 100, nil, 1, 1, 0)
	ui.addTextArea(id+4, "<font color='#"..color.."' size='11'><p align='center'>"..name, player, x, y+40, 100, nil, 1, 1, 0)
	if canClick then 
		ui.addTextArea(id+5, "<textformat leftmargin='1' rightmargin='1'><a href='event:"..callback.."'>" .. string.rep('\n', 4), player, x+25, y+55, 50, 45, 1, 1, 0)
		if color == 'b69efd' then
			players[player].questLocalData.images[#players[player].questLocalData.images+1] = addImage("174080201fb.png", "!50", x+38, y+20, player)
		end
	end
end