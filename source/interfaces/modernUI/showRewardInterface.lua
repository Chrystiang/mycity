modernUI.rewardInterface = function(self, rewards, title, text)
	local player = self.player
	if not title then title = translate('reward', player) end 
	if not text then text = translate('rewardText', player) end
	text = text..'\n'
	for i, v in next, rewards do
		if v.currency then
			text = text..'\n<font size="11">+'..mainAssets.currencies[v.currency].color..v.quanty..'<font>'
		else
			text = text..'\n<font size="11"><n>'..v.text..' ('..v.format..v.quanty..')'
		end
	end
	self.title = title 
	self.text = text
	return setmetatable(self, modernUI)
end