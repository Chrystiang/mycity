modernUI.profileInterface = function(self, target)
	local id = self.id
	local player = self.player
	local width = self.width
	local height = self.height
	local x = (400 - width/2)
	local y = (200 - height/2)

	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171dc2950de.png', ":26", x+170, y+80, player)
	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171dc2950de.png', ":27", x+340, y+80, player)

	local targetData = players[target]
	local level = targetData.level[1]
	local minXP = targetData.level[2]
	local maxXP = (targetData.level[1] * 2000) + 500
   	local progress = floor(minXP/maxXP * 490/23.5)
	for i = 1, progress do
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171dc34c3f0.png', ":28", 155 + (i-1)*23.5, y+68, player)
	end

	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(community[targetData.lang], ":27", x+width-25, y+height-27, player)
	if targetData.lang ~= ROOM.playerList[target].language then
		players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(community[ROOM.playerList[target].language], ":27", x+width-42, y+height-27, player)
	end

   	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage('171dc59da98.png', ":28", 150, y+48, player)

   	showTextArea(id..'900', '<p align="center"><font color="#c6bb8c" size="20"><b>'..level, player, 380, y+54, 40, 40, 0, 0x24474, 0, true)
   	showTextArea(id..'901', '<p align="center"><font color="#c6bb8c" size="12"><b>'..minXP..'/'..maxXP..'xp', player, 315, y+80, 170, nil, 0, 0x24474, 0, true)

   	local text_General =
   	   	string_replace(player, {["{0}"] = 'profile_diamonds', ["{1}"] = '$'..targetData.sideQuests[4]}) ..'\n' ..
   		string_replace(player, {["{0}"] = 'profile_coins', ["{1}"] = '$'..targetData.coins}) ..'\n' ..
   		string_replace(player, {["{0}"] = 'profile_spentCoins', ["{1}"] = '$'..targetData.spentCoins}) ..'\n' ..
   		string_replace(player, {["{0}"] = 'profile_purchasedHouses', ["{1}"] = #targetData.houses..'/'..#mainAssets.__houses-2}) ..'\n' ..
   		string_replace(player, {["{0}"] = 'profile_purchasedCars', ["{1}"] = #targetData.cars..'/'..#mainAssets.__cars-1}) ..'\n' ..
   		string_replace(player, {["{0}"] = 'profile_completedQuests', ["{1}"] = (targetData.questStep[1]-1)..'/'..questsAvailable}) ..'\n' ..
   		string_replace(player, {["{0}"] = 'profile_completedSideQuests', ["{1}"] = targetData.sideQuests[3]}) ..'\n' ..
   		string_replace(player, {["{0}"] = 'profile_timePlayed', ["{1}"] = floor(targetData.timePlayed)}) ..'\n'

	local text_Jobs = {
		police 	= 	string_replace(player, {["{0}"] = 'profile_arrestedPlayers', ["{1}"] = targetData.jobs[1]}),
		thief 	= 	string_replace(player, {["{0}"] = 'profile_robbery', ["{1}"] = targetData.jobs[2]}),
		fisher 	= 	string_replace(player, {["{0}"] = 'profile_fishes', ["{1}"] = targetData.jobs[3]}),
		miner 	= 	string_replace(player, {["{0}"] = 'profile_gold', ["{1}"] = targetData.jobs[4]}) ..'\n' ..
					translate('profile_crystalsSold', player) .. '\n' ..
					string_replace(player, {["{0}"] = 'profile_crystal_yellow', ["{1}"] = targetData.jobs[12]}) ..'\n' ..
					string_replace(player, {["{0}"] = 'profile_crystal_blue', ["{1}"] = targetData.jobs[13]}) ..'\n' ..
					string_replace(player, {["{0}"] = 'profile_crystal_purple', ["{1}"] = targetData.jobs[14]}) ..'\n' ..
					string_replace(player, {["{0}"] = 'profile_crystal_green', ["{1}"] = targetData.jobs[15]}) ..'\n' ..
					string_replace(player, {["{0}"] = 'profile_crystal_red', ["{1}"] = targetData.jobs[16]}),
		farmer 	= 	string_replace(player, {["{0}"] = 'profile_seedsPlanted', ["{1}"] = targetData.jobs[5]}) ..'\n' ..
					string_replace(player, {["{0}"] = 'profile_seedsSold', ["{1}"] = targetData.jobs[6]}) ..'\n' ..
					string_replace(player, {["{0}"] = 'profile_fruitsSold', ["{1}"] = targetData.jobs[11]}),
		chef 	= 	string_replace(player, {["{0}"] = 'profile_cookedDishes', ["{1}"] = targetData.jobs[10]}) ..'\n' ..
					string_replace(player, {["{0}"] = 'profile_fulfilledOrders', ["{1}"] = targetData.jobs[9]}),
		ghostbuster = string_replace(player, {["{0}"] = 'profile_capturedGhosts', ["{1}"] = targetData.jobs[7]}),
   	}
	showTextArea(id..'910', '<font size="10" color="#ebddc3">'..text_General, player, 155, y+102, 150, 150, 0x152d30, 0x152d30, 1, true)
	local job = {'police', 'thief', 'fisher', 'miner', 'farmer', 'chef', 'ghostbuster'}
	if targetData.jobs[7] == 0 then job[7] = nil end
	for i, v in next, job do
		showTextArea(id..(911+i), '<p align="left"><font size="11" color="#'..jobs[v].color..'">'..translate(v, player), player, 323, y+102 + (i-1)*17, 150, nil, 0x152d30, 0x152d3, 0, true)
		showTextArea(id..(921+i), '<p align="left"><font size="11" color="#caed87">→', player, 460, y+102 + (i-1)*17, nil, nil, 0x152d30, 0x152d3, 0, true,
			function(player, args)
				showTextArea(id..'930', '<font size="14" color="#'..jobs[args.title].color..'"><p align="center">'..translate(args.title, player)..'</p></font>\n'..args.data:gsub('7bbd40',jobs[args.title].color),
					player, 480, 180 + args.y*17 -31, 150, nil, 0x432c04, 0x7a5817, 1, true)
				showTextArea(id..'931', '<textformat leftmargin="1" rightmargin="1">'..string.rep('\n', 10),
					player, 480, 180 + args.y*17 -31, 150, nil, 0x432c04, 0x7a5817, 0, true,
						function(player)
							removeTextArea(id..'930')
							removeTextArea(id..'931')
						end)
			end, {title = v, data = text_Jobs[v], y = i-1})
	end

	local i = 0
	for _, v in next, badgesPriority do
		if table_find(players[target].badges, v) then
			players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(badges[v].png, ":33", x+352+(i%5)*31, y+109+floor(i/5)*31, player)
			showTextArea(id..(941+i), string.rep('\n', 4), player, x+352+(i%5)*31, y+109+floor(i/5)*31, 30, 30, 0, 0, 0, true,
				function(player, args)
					local i = args.i
					showTextArea(id..'930', '<p align="center"><i><v>'..translate('badgeDesc_'..v, player),
						player, x+352+(i%5)*31, y + 109 + 30 + floor(i/5)*31, 150, nil, 0x432c04, 0x7a5817, 1, true)
					showTextArea(id..'931', '<textformat leftmargin="1" rightmargin="1">'..string.rep('\n', 10),
						player, x+352+(i%5)*31, y + 109 + 30 + floor(i/5)*31, 150, nil, 0x432c04, 0x7a5817, 0, true,
							function(player)
								removeTextArea(id..'930')
								removeTextArea(id..'931')
							end)
				end, {i = i})
			i = i + 1
		end
	end

	return setmetatable(self, modernUI)
end