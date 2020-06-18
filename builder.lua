local tree = {
	'main.lua',

	'api/table.lua',
	'api/string.lua',
	'api/math.lua',
	
	'translations/_langIDS.lua',
	'translations/ar.lua',
	'translations/br.lua',
	'translations/de.lua',
	'translations/en.lua',
	'translations/es.lua',
	'translations/fr.lua',
	'translations/he.lua',
	'translations/hu.lua',
	'translations/pl.lua',
	'translations/ru.lua',
	'translations/tr.lua',
	'translations/_merge.lua',
	'translations/_translationSystem.lua',

	'classes/DataHandler.lua',
	'classes/EventHandler.lua',
	'classes/Timers.lua',
	'classes/SystemLooping.lua',

	'checkTimers.lua',

	'houseSystem/_new.lua',
	'houseSystem/genHouseFace.lua',
	'houseSystem/genHouseGrounds.lua',
	'houseSystem/loadTerrains.lua',
	'houseSystem/removeHouse.lua',
	'houseSystem/gardening.lua',

	'interfaces/modernUI/modernUI.lua',
	'interfaces/modernUI/interfaces.lua',
	'interfaces/toRewrite/oldInterface.lua',
	'interfaces/errorAlert.lua',

	'commands/!ban.lua',
	'commands/!unban.lua',
	'commands/!coin.lua',
	'commands/!insert.lua',
	'commands/!place.lua',
	'commands/!profile.lua',
	'commands/!shop.lua',
	'commands/!spawn.lua',
	'commands/!punish.lua',
	'commands/!jail.lua',
	'commands/!roomlog.lua',
	'commands/!moveto.lua',
	'commands/!job.lua',

	'npcs/npcDialogs.lua',
	'npcs/gameNpcs/_main.lua',
	'npcs/gameNpcs/addCharacter.lua',
	'npcs/gameNpcs/reAddNPC.lua',
	'npcs/gameNpcs/removeNPC.lua',
	'npcs/gameNpcs/removeTextAreas.lua',
	'npcs/gameNpcs/setNPCName.lua',
	'npcs/gameNpcs/setOrder.lua',
	'npcs/gameNpcs/talk.lua',
	'npcs/gameNpcs/updateDialogBox.lua',
	'npcs/gameNpcs/updateDialogs.lua',
	'npcs/shops/loadShop.lua',

	'playerData/_dataStructure.lua',
	'playerData/_localDataStructure.lua',
	'playerData/_dataToSave.lua',
	'playerData/player.lua',

	'quests/controlCenter.lua',
	'quests/mainquest.lua',
	'quests/sidequest.lua',

	'syncGame.lua',

	'ranking/load.lua',
	'ranking/save.lua',

	'jobs/jobState.lua',
	'jobs/cop/arrest.lua',
	'jobs/thief/rob.lua',
	'jobs/fisher/fish.lua',

	'items/itemList/bagIds.lua',
	'items/itemList/bagItems.lua',
	'items/itemList/recipes.lua',

	'items/bag.lua',
	'items/checkAmount.lua',
	'items/chest.lua',
	'items/drop.lua',
	'items/itemInfo.lua',

	'events/NewPlayer.lua',
	'events/ChatCommand.lua',
	'events/EmotePlayed.lua',
	'events/FileLoaded.lua',
	'events/Keyboard.lua',
	'events/Loop.lua',
	'events/Mouse.lua',
	'events/PlayerDataLoaded.lua',
	'events/PlayerDied.lua',
	'events/PlayerLeft.lua',
	'events/PlayerRespawn.lua',
	'events/TextAreaCallback.lua',

	'places/mine/_perlin.lua',
	'places/mine/grid.lua',
	'places/hospital/hospitalize.lua',
	'places/hospital/loadFloor.lua',
	'places/bank/robbingAssets.lua',

	'places/_checkLocation/isInHouse.lua',
	'places/changePlace.lua',
	'places/events.lua',

	'social/freezePlayer.lua',
	'social/setNightMode.lua',
	'social/showPlayerLevel.lua',
	'social/addLootDrop.lua',

	'vehicles/vehicles.lua',

	'gameHour.lua',
	'lifeStats.lua',
	'dayPeriods.lua',

	'tips.lua',
	'map/game.lua',
	'map/lobby.lua',
	'map/loadMap.lua',

	'recipeSystem.lua',

	'init.lua',

}

local getFile = function(path)
	local file = io.open('src/' .. path, 'r')
	local data = file:read('*a')
	file:close()
	return (string.gsub(data, '\n*$', '', 1))
end

local writeFile = function(path, data)
	local file = io.open(path, 'w+')
	file:write(data)
	file:flush()
	file:close()
end

local fileData = { }

local path, file
for i = 1, #tree do
	path = tree[i]
	fileData[i] = '--[[ ' .. path .. ' ]]--\n' .. getFile(path)

	print('Writing ' .. path)
end
fileData = table.concat(fileData, '\n\n')

writeFile('last_build.lua', fileData)
writeFile('builds/' .. os.date('%m-%d-%y') .. '.lua', fileData)

print('Done')
