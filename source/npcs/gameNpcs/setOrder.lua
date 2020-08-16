gameNpcs.setOrder = function(npcName)
	local npc = gameNpcs.characters[npcName]
	local image = npc.image
	local type = npc.type
	local x = npc.x
	local y = npc.y
	local character = gameNpcs.orders
	local order = table.randomKey(recipes)
	local place = character.canOrder[npcName]
	character.orderList[npcName] = {order = order, fulfilled = {}}
	character.canOrder[npcName] = nil
	do
		local counter = 0
		local orderPaperList = '' -- orders to show in the restaurant
		player_removeImages(character.trashImages)
		for i, v in next, character.orderList do
			orderPaperList = orderPaperList .. i..'\n\n'
			character.trashImages[#character.trashImages+1] = addImage(bagItems[v.order].png, "_1000", 15955, 1560+counter*28)
			counter = counter + 1
		end
		ui.addTextArea(4444441, '<font size="10">'..orderPaperList, nil, 15995, 1580, nil, nil, 1, 1, 0)
	end
	local images = character.orderList[npcName].fulfilled
	for _, player in next, jobs['chef'].working do
		images[player] = {
			icons = {
				addImage('171c7ac4232.png', type.."1000", x, y-20, player), 
				addImage(bagItems[order].png, type.."1000", x+25, y-20, player),
			},
			completed = false,
		}
	end
	local orderTime = math.random(60*2.5, 60*3)
	addTimer(function(time)
		if time == orderTime then
			local images = character.orderList[npcName].fulfilled
			for player, k in next, images do 
				if not k.completed then
					player_removeImages(k.icons)
				end
			end
			character.orderList[npcName] = nil
			character.canOrder[npcName] = place
			local nextOrder
			while true do
				nextOrder = table.randomKey(character.canOrder)
				--TFM.chatMessage('<CS>Trying to choose '..nextOrder)
				local isOpened = places[character.canOrder[nextOrder]].opened
				if checkGameHour(isOpened) or isOpened == '-' then
					--TFM.chatMessage('<rose>'..character.canOrder[nextOrder]..' is opened!')
					break
				end
				--TFM.chatMessage('<rose>'..character.canOrder[nextOrder]..' is closed!')
			end

			--TFM.chatMessage('<FC>'..nextOrder..' was chosen!')
			gameNpcs.setOrder(nextOrder)
		end
	end, 1000, orderTime)
end