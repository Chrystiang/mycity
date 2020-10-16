modernUI.showATM_Machine = function(self)
	local id = self.id
	local player = self.player
	local width = self.width 
	local height = self.height
	local x = 290
	local y = (200 - height/2) + 28

	local writtenCode = {}

	ui.addTextArea(id..(900), '<V><p align="center"><font size="13">'..translate('code', player), player, 300, y+20, 200, 20, 0x314e57, 0x314e57, 0.8, true)

	local keys = {'QWERTYUIOP', 'ASDFGHJKL', 'ZXCVBNM'}
	for index, v in next, {{6, 56}, {17, 79}, {42, 102}} do
		for i = 1, #keys[index] do
			local letter = keys[index]:sub(i, i)
			ui.addTextArea(id..(900+i+(13*(index-1))), "<p align='center'><CS>"..letter, player, x + (i-1)*22 + v[1], y + v[2], nil, 15, 0, 0, 0, true, 
				function()
					if #writtenCode < 15 then
						writtenCode[#writtenCode+1] = letter
						ui.updateTextArea(id..(900), '<V><p align="center"><font size="13">'..table.concat(writtenCode, ''), player)
					end
				end)
		end
	end

	greenButton(id, 1, translate('submit', player), player, 
		function()
			local code = table.concat(writtenCode, '')
			writtenCode = {}
			if codes[code] then
				for i, v in next, players[player].receivedCodes do
					if v == codes[code].id then
						ui.updateTextArea(id..(900), '<R><p align="center"><font size="10">'..translate('codeAlreadyReceived', player), player)
						return
					end
				end
				if codes[code].available then
					if codes[code].level then
						if codes[code].level > players[player].level[1] then
							return alert_Error(player, 'error', 'codeLevelError', codes[code].level)
						end
					end
					eventTextAreaCallback(0, player, 'modernUI_Close_'..id, true)
					players[player].receivedCodes[#players[player].receivedCodes+1] = codes[code].id
					codes[code].reward(player)
					return
				else
					ui.updateTextArea(id..(900), '<R><p align="center"><font size="10">'..translate('codeNotAvailable', player), player)
					return
				end
			else
				ui.updateTextArea(id..(900), '<R><p align="center"><font size="13">'..translate('incorrect', player), player)
			end
		end, 
	300, y + 160, 200, 12)

	return setmetatable(self, modernUI)
end