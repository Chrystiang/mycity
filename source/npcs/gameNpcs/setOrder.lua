local circleSlices = {
	[1] = '174082d5bfd.png',
	[2] = '174082d7f11.png',
	[3] = '174082da029.png',
	[4] = '174082dc2d0.png',
	[5] = '174082e3e9a.png',
	[6] = '174082e63c6.png',
	[7] = '174082e85bd.png',
}

local orderList = {}

gameNpcs.setOrder = function(npcName)
	local npc = gameNpcs.characters[npcName]
	local image = npc.image
	local type = npc.type
	local x = npc.x
	local y = npc.y
	local character = gameNpcs.orders
	local order = table.randomKey(recipes)
	local place = character.canOrder[npcName]
	local orderTime = math.random(60*2, 60*3)
	local sliceDuration = math.floor(orderTime/8)
	local slice = 8
	local counter = 0
	local orderPaperList = '' -- orders to show in the restaurant

	character.orderList[npcName] = {order = order, fulfilled = {}}
	character.canOrder[npcName] = nil
	player_removeImages(character.trashImages)
	for i, v in next, character.orderList do
		orderPaperList = orderPaperList .. i..'\n\n\n'
		character.trashImages[#character.trashImages+1] = addImage(bagItems[v.order].png, "_1000", 15900, 1560+counter*40)			
		counter = counter + 1
		orderList[i] = counter
	end
	ui.addTextArea(4444441, '<font size="12">'..orderPaperList, nil, 15940, 1575, nil, nil, 1, 1, 0)

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
	local stopwatch = addImage('174082ea765.png', "_1001", 16020, 1577 + (orderList[npcName]-1)*40)
	local stopwatchTimer 
	stopwatchTimer = addTimer(function(time)
		slice = slice - 1
		removeImage(stopwatch)
		stopwatch = addImage(circleSlices[slice], "_1001", 16020, 1577 + (orderList[npcName]-1)*40)
	end, sliceDuration * 1000, 8)

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
			removeTimer(stopwatchTimer)
			removeImage(stopwatch)
			gameNpcs.setOrder(nextOrder)
		end
	end, 1000, orderTime)
end