local circleSlices = {
	[ 1] = '174558f6393.png',
	[ 2] = '1745588b429.png',
	[ 3] = '17455904362.png',
	[ 4] = '17455876d27.png',
	[ 5] = '1745590f162.png',
	[ 6] = '17455847e27.png',
	[ 7] = '1745591a12a.png',
	[ 8] = '1745581e99b.png',
	[ 9] = '174559244ca.png',
	[10] = '1745572fc55.png',
	[11] = '1745592d979.png',
	[12] = '174557c2791.png',
	[13] = '17455936450.png',
	[14] = '174557f051a.png',
}

local currentOrders = {
	images = {},
	orders = {},
	index  = {},
}

showDishOrders = function(target)
	if not target then
		player_removeImages(currentOrders.images)
	end

	local counter = 0
	for npc, order in next, currentOrders.orders do
		currentOrders.images[#currentOrders.images+1] = addImage(bagItems[order].png, "_1000", 15900, 1560+counter*40, target)
		ui.addTextArea(4444441+counter, npc, target, 15940, 1575+counter*40, nil, nil, 1, 1, 0)
		currentOrders.index[npc] = counter
		counter = counter + 1
	end
end

gameNpcs.setOrder = function(npcName)
	local npc = gameNpcs.characters[npcName]
	local image = npc.image
	local type = npc.type
	local x = npc.x
	local y = npc.y
	local character = gameNpcs.orders
	local order = (math.random(1, 2) == 1 and (room.gameDayStep == 'night' or room.gameDayStep == 'dawn')) and 'strangePumpkin' or table.randomKey(recipes)
	local place = character.canOrder[npcName]
	local orderTime = math.random(60*2, 60*3)

	character.orderList[npcName] = {order = order, fulfilled = {}}
	character.canOrder[npcName] = nil
	player_removeImages(character.trashImages)
	currentOrders.orders[npcName] = order

	showDishOrders()

	local images = character.orderList[npcName].fulfilled
	local function addDataToPlayer(player)
		images[player] = {
			icons = {
				addImage('171c7ac4232.png', type.."1000", x, y-20, player), 
				addImage(bagItems[order].png, type.."1000", x+25, y-20, player),
			},
			completed = false,
		}
	end
	if order ~= 'strangePumpkin' then
		for _, player in next, jobs['chef'].working do
			addDataToPlayer(player)
		end
	else
		for player in next, ROOM.playerList do
			if players[player].inRoom then
				addDataToPlayer(player)
			end
		end
	end

	local currentSlice = 14
	local sliceDuration = math.ceil(orderTime/14)
	local stopwatch = addImage('174082ea765.png', "_1001", 16020, 1577 + currentOrders.index[npcName]*40)
	local stopwatchTimer

	stopwatchTimer = addTimer(function(time)
		currentSlice = currentSlice - 1
		removeImage(stopwatch)
		stopwatch = addImage(circleSlices[currentSlice], "_1001", 16020, 1577 + currentOrders.index[npcName]*40)
	end, sliceDuration * 1000, 0)

	addTimer(function(time)
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
		removeImage(stopwatch)
		removeTimer(stopwatchTimer)
		currentOrders.index[npcName] = nil
		currentOrders.orders[npcName] = nil

		gameNpcs.setOrder(nextOrder)
	end, orderTime * 1000, 1)
end