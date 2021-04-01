modernUI = {}
modernUI.__index = modernUI

modernUI.new = function(player, width, height, title, text, errorUI, tag)
	local playerData = players[player]
	if not playerData then return end
	if type(errorUI) == 'boolean' then return end

	local self = {
		id 		= 10 + playerData._modernUIOpenedTabs,
		player 	= player,
		width 	= width or 200,
	  	height 	= height or 150,
	  	buttons = {},
	  	title 	= title,
	  	text 	= text,
	  	errorUI = errorUI or '',
	  	tag 	= tag or '',
	}

	local id = self.id

	local images = playerData._modernUIImages
	if images[id] then
		for i = 1, #images[id] do
			removeImage(images[id][i])
		end
	end
	players[player]._modernUIHistory[id] = {}
	players[player]._modernUIImages[id] = {}
	players[player]._modernUIOpenedTabs = playerData._modernUIOpenedTabs + 1

	if tag then
		if players[player][tag..'_isOpen'] then
			eventTextAreaCallback(0, player, "modernUI_Close_"..(id-1).."_ _"..tag, true)
			return
		end
		players[player][tag..'_isOpen'] = id
	end

	return setmetatable(self, modernUI)
end

modernUI.addButton = function(self, image, toggleEvent, ...)
	local player = self.player
	self.buttons[#self.buttons+1] = {image = image}
	players[player]._modernUIHistory[self.id][#self.buttons] = {toggleEvent = toggleEvent, args = ..., warningUI = true}
	return setmetatable(self, modernUI)
end

modernUI.build = function(self)
	local id = self.id
	local player = self.player
	local width = self.width
	local height = self.height
	local x = (400 - width/2) - 10
	local y = (200 - height/2)

	local totalButtons = #self.buttons
	local buttonAlign = totalButtons > 0 and totalButtons*25 - 10 or 0

	local backgrounds = {
		[120] = {
			[120] = '172cec377fb.png',
		},
		[200] = {
			[200] = '1729faa10a0.png',
		},
		[240] = {
			[120] = '171d2a2e21a.png',
			[170] = '1729fb0cb0f.png',
			[180] = '1729fae409e.png',
			[220] = '171d28150ea.png',
		},
		[310] = {
			[280] = '171d6f313c8.png',
		},
		[380] = {
			[280] = '17290d6d18e.png',
		},
		[520] = {
			[300] = '171dbed9f91.png',
		},
		[800] = {
			[400] = '175130b40ff.png',
		},
	}
	local _UI = backgrounds[width][height]
	local backgroundImage = _UI and _UI or error('Invalid modernUI size.')
	players[player]._modernUIImages[id][#players[player]._modernUIImages[id]+1] = addImage(backgroundImage, ":10", x+10, y, player)

	showTextArea(id..'876', '', player, 5 - width/2, 0, 400, 400, 0x152d30, 0x152d30, 0, true) showTextArea(id..'877', '', player, 395 + width/2, 0, 400, 400, 0x152d30, 0x152d30, 0, true) showTextArea(id..'878', '', player, 0, 6 - height/2, 800, 200, 0x152d30, 0x152d30, 0, true) showTextArea(id..'879', '', player, 0, 194 + height/2, 800, 200, 0x152d30, 0x152d30, 0, true)
	local function createButton(id)
		local button = self.buttons[id]
		players[player]._modernUIImages[self.id][#players[player]._modernUIImages[self.id]+1] = addImage(button.image, ":"..(100+id), (x+width)-23 - id*24, y+10, player)
		showTextArea(self.id..(896+id), "<textformat leftmargin='1' rightmargin='1'><a href='event:modernUI_ButtonAction_"..self.id.."_"..id.."'>\n\n", player, (x+width)-23 - id*24 , y+10, 25, 25, 0xff0000, 0xff0000, 0, true)
	end

	if self.title then
		showTextArea(id..'880', '<p align="center"><font color="#152d30" size="15"><b>'..self.title, player, x+26, y+16, width-55 + (totalButtons * -25), nil, 0x152d30, 0x152d30, 1, true)
		showTextArea(id..'881', '<p align="center"><font color="#caed87" size="15"><b>'..self.title, player, x+25, y+13, width-30, nil, 0x152d30, 0x152d3, 0, true)
	end
	if self.text then
		showTextArea(id..'882', '<font color="#ebddc3" size="13">'..self.text, player, x+25, y+47, width-30, height-65, 0x152d30, 0x152d30, 1, true)
	end
	if width ~= 800 then
		showTextArea(id..'896', "<textformat leftmargin='1' rightmargin='1'><a href='event:modernUI_Close_"..id.."_"..self.errorUI.."_"..self.tag.."'>\n\n", player, (x+width)-23, y+10, 25, 25, 0xff0000, 0xff0000, 0, true)
	else
		self.width = 520
		self.height = 300
	end
	
	for i = 1, totalButtons do
		createButton(i)
	end
	return setmetatable(self, modernUI)
end

modernUI.addConfirmButton = function(self, toggleEvent, buttonText, ...)
	local id = self.id
	local player = self.player
	local width = ... and (type(...) == 'number' and ... or 100) or 100
	local height = 15
	local x = (400 - width/2)
	local y = (200 - height/2) + self.height/2 - 30

	showTextArea(id..'930', '', player, x-1, y-1, width, height, 0x95d44d, 0x95d44d, 1, true)
	showTextArea(id..'931', '', player, x+1, y+1, width, height, 0x1, 0x1, 1, true)
	showTextArea(id..'932', '', player, x, y, width, height, 0x44662c, 0x44662c, 1, true)
	showTextArea(id..'933', '<p align="center"><font color="#cef1c3" size="13"><a href="event:modernUI_ButtonAction_'..self.id..'_'..(#self.buttons+1)..'">'..buttonText..'\n', player, x-4, y-4, width+8, height+8, 0xff0000, 0xff0000, 0, true)

	players[player]._modernUIHistory[id][#self.buttons+1] = {toggleEvent = toggleEvent, args = ...}
	return setmetatable(self, modernUI)
end