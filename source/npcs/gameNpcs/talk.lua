gameNpcs.talk = function(npc, player)
	local playerData = players[player]
	local lang = playerData.lang
	local npcText = npcDialogs.normal[lang][npc.name] and npcDialogs.normal[lang][npc.name] or (npc.name:find('Souris') and {' '} or npcDialogs.normal[lang]['Natasha'])
	if npc.questDialog then
		npcText = npcDialogs
			.quests
			  [lang]
				[playerData.questStep[1]]
				  [playerData.questStep[2]]
	end
	local dialog = npc.text or npcText
	dialog = table_copy(dialog)
	local formatText = playerData._npcsCallbacks.formatDialog[npc.name]

	if formatText == 'fishingLuckiness' then
		local lucky = playerData.lucky[1]
		dialog[3] = dialog[3]:format(lucky.normal..'%', lucky.rare..'%', lucky.mythical..'%')
		dialog[4] = dialog[4]:format(lucky.legendary..'%')
	elseif formatText == 'christmasEventEnds' then
		dialog[7] = dialog[7]:format(formatDaysRemaining(os_time{day=15, year=2022, month=1}))
	end

	dialogs[player] = {name = npc.name, text = dialog, length = 0, currentPage = 1, running = true, npcID = npc.npcID, isQuest = npc.questDialog}
	local tbl = players[player]._npcDialogImages

	local alignFix = gameNpcs.characters[npc.name].fixAlign
	if not npcDialogs.normal[lang][npc.name] and npc.image ~= gameNpcs.characters[npc.name].image2 then
		alignFix = {0, -23}
	end
	tbl[#tbl+1] = addImage('17184484e6b.png', ":0", 0, 0, player)
	tbl[#tbl+1] = addImage('1718435fa5c.png', ":1", 300, 250, player)
	tbl[#tbl+1] = addImage(npc.image, ":2", 270+alignFix[1], 260+alignFix[2], player)
	tbl[#tbl+1] = addImage('171843a9f21.png', ":3", 270, 330, player)
	--npc.name = npc.name:gsub('$', '')
	local font = 15
	if #npc.name > 8 then
		font = 12
	elseif #npc.name > 13 then
		font = 10
	end
	showTextArea(-88000, '<p align="center"><font size="'..font..'" color="#ffffea"><b>'..npc.name:gsub('%$', ''), player, 275, 335 + (15-font), 90, 30, 1, 1, 0, true)
	showTextArea(-88001, '', player, 380, 260, 210, 75, 1, 1, 0, true)
	showTextArea(-88002, "<textformat leftmargin='1' rightmargin='1'><a href='event:npcDialog_skipAnimation'>" .. string.rep('\n', 10), player, 300, 250, 300, 100, nil, 1, 0, true)
end