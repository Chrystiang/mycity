loadHospitalFloor = function(player)
	local playerInfos = players[player]
	local andar =  playerInfos.hospital.currentFloor
	ui.addTextArea(8888800, '<font size="30" color="#FF8C00"><b><p align="center">'..andar, player, ((andar-1)%andar)*900+348+4000, 54+3000, 100, nil, 0x1, 0x1, 0)
	ui.addTextArea(8888801, '', player, ((andar-1)%andar)*900+804+4000, -300+3000, 1000, 1000, 0x1, 0x1, 1)
	ui.addTextArea(8888802, '', player, ((andar-1)%andar)*900-1004+4000, -300+3000, 1000, 1000, 0x1, 0x1, 1)

	ui.addTextArea(8888803, '<font color="#00FF00" size="15" face="Consolas"><b><p align="center">01', player, ((andar-1)%andar)*900+325+4000, 102+3000, 53, nil, 0x1, 0x1, 0)
	ui.addTextArea(8888804, '<font color="#00FF00" size="15" face="Consolas"><b><p align="center">01', player, ((andar-1)%andar)*900+415+4000, 102+3000, 53, nil, 0x1, 0x1, 0)
	ui.addTextArea(8888808, "<textformat leftmargin='1' rightmargin='1'><a href='event:elevator'>" .. string.rep('\n', 5), player, ((andar-1)%andar)*900+388+4000, 188+3000, 20, 30, 1, 1, 0)

	if not playerInfos.hospital.hospitalized then
		closeInterface(player, false, true)
		TFM.movePlayer(player, ((andar-1)%andar)*900+4400, 3240, false)
	end

	if not room.hospital[andar][1].name then
		ui.addTextArea(8888805, '', player, ((andar-1)%andar)*900+3+4000, 4+3000, 287, 249, 0x1, 0x1, 0.5)
	end
	if not room.hospital[andar][2].name then
		ui.addTextArea(8888806, '', player, ((andar-1)%andar)*900+510+4000, 4+3000, 287, 249, 0x1, 0x1, 0.5)
	end
end

loadHospital = function(player, elevador)
	players[player].place = 'hospital'

	local andar = 1
	ui.addTextArea(8888800, '<font size="30" color="#FF8C00"><b><p align="center">P', player, ((andar-1)%andar)*900+348+4000, 54+3400, 100, nil, 0x1, 0x1, 0)
	ui.addTextArea(8888801, '', player, ((andar-1)%andar)*900+804+4000, -300+3400, 1000, 1000, 0x1, 0x1, 1)
	ui.addTextArea(8888802, '', player, ((andar-1)%andar)*900-1004+4000, -300+3400, 1000, 1000, 0x1, 0x1, 1)

	ui.addTextArea(8888803, '<font color="#00FF00" size="15" face="Consolas"><b><p align="center">01', player, ((andar-1)%andar)*900+325+4000, 102+3400, 53, nil, 0x1, 0x1, 0)
	ui.addTextArea(8888804, '<font color="#00FF00" size="15" face="Consolas"><b><p align="center">01', player, ((andar-1)%andar)*900+415+4000, 102+3400, 53, nil, 0x1, 0x1, 0)
	ui.addTextArea(8888807, "<textformat leftmargin='1' rightmargin='1'><a href='event:elevator'>" .. string.rep('\n', 5), player, ((andar-1)%andar)*900+388+4000, 188+3400, 20, 30, 1, 1, 0)

	if not players[player].hospital.hospitalized and not elevador and not players[player].robbery.robbing then
		closeInterface(player, false, true)
		TFM.movePlayer(player, 4600, 3650, false)
	end
	if elevador then
		TFM.movePlayer(player, 4400, 3640, false)
	end
end