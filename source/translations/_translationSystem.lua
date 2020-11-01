translate = function(message, name)
	if not players[name] then return '?' end
	local cmm = players[name].lang or 'en'
	if message:sub(1, 3) == 'req' then
		local quest = tonumber(message:sub(5))
		return lang[cmm].quests[quest].name
	end
	if message == '$VersionName' then
		local playerVersion = 'v'..table_concat(version, '.')
		return versionLogs[playerVersion][cmm] or versionLogs[playerVersion].en
	end
	return lang[cmm][message] and lang[cmm][message] or '$txt_'..message
end

translatedMessage = function(msg, ...)
	for name in next, ROOM.playerList do
		chatMessage(string.format(translate(msg, name), ...), name)
	end
end