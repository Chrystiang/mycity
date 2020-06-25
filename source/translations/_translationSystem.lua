translate = function(message, name)
    if not players[name] then return '?' end
    local cmm = players[name].lang or 'en'
    if message:sub(1, 3) == 'req' then
        local quest = tonumber(message:sub(5))
        return lang[cmm].quests[quest].name
    end
    if message == '$VersionText' then
        local playerVersion = 'v'..table.concat(version, '.')
        return versionLogs[playerVersion][cmm] and versionLogs[playerVersion][cmm]['_'..players[name].joinMenuPage] or (versionLogs[playerVersion].en['_'..players[name].joinMenuPage] or message)
    elseif message == '$VersionName' then
        local playerVersion = 'v'..table.concat(version, '.')
        return versionLogs[playerVersion][cmm] and versionLogs[playerVersion][cmm].name or (versionLogs[playerVersion].en.name or message)
    end
    return lang[cmm][message] and lang[cmm][message] or '$txt_'..message
end

translatedMessage = function(msg, ...)
    for name in next, ROOM.playerList do
        TFM.chatMessage(string.format(translate(msg, name), ...), name)
    end
end