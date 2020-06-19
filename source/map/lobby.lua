genLobby = function()
	room.isInLobby = true
	TFM.newGame('<C><P Ca="" /><Z><S><S L="800" m="" X="400" H="35" Y="382" T="6" P="0,0,0.3,0.2,0,0,0,0" /><S P="0,0,0,0,0,0,0,0" L="10" o="0" X="-6" Y="222" T="12" H="547" /><S L="10" o="0" X="808" H="547" Y="258" T="12" P="0,0,0,0,0,0,0,0" /><S P="0,0,0,0,0,0,0,0" L="800" o="0" H="10" Y="-6" T="12" X="401" /></S><D><DS Y="353" X="400" /></D><O /></Z></C>')
	room.started = false
	startRoom()
	removeTimer(room.temporaryTimer)
	room.temporaryTimer = addTimer(function(j)
		for i in next, ROOM.playerList do
			ui.addTextArea(0, "<p align='center'><font size='20'><CE>".. translate('waitingForPlayers', i) .." <br>"..ROOM.uniquePlayers.."/"..room.requiredPlayers.."</font></p>", i, 0, 35, 800, nil, 1, 1, 0.3)
			local lang = players[i].lang
			local tip = tips[lang] and tips[lang][math.random(1, #tips[lang])] or tips['EN'][math.random(1, #tips['EN'])]
			ui.addTextArea(1, "<p align='center'><i><CS>"..tip.."</p>", i, 0, 105, 800, nil, 1, 1, 0.3)
		end
	end, 5000, 0)
end