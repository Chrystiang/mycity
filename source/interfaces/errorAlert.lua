alert_Error = function(player, title, text, ...)
	local title = lang.en[title] and translate(title, player) or title
	local text = lang.en[text] and translate(text, player) or text
	modernUI.new(player, 240, 120, title, text:format(...), 'errorUI')
	:build()
end