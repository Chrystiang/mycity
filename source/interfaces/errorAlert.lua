alert_Error = function(player, title, text, args)
	if not args then args = '?' end
	local title = lang.en[title] and translate(title, player) or title
	local text = lang.en[text] and translate(text, player) or text
	modernUI.new(player, 240, 120, title, text:format(args), 'errorUI')
	:build()
end