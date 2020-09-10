eventChatMessage = function(player, msg)
    if ROOM.community == "en" then 
        if not table.contains(mainAssets.roles.moduleTeam, player) and not string.find(player, "#0010") and not string.find(player, "#0020") then
            local community = ROOM.playerList[player].community
            msg = string.format("<v>[%s] [%s<font size='10'><g>%s</g></font>]<n> %s", community, string.sub(player, 1, -6), string.sub(player, -5), msg)
            for target in next, ROOM.playerList do
                if ROOM.playerList[target].community ~= community and not string.find(target, "#0010") and not string.find(target, "#0020") then
                    TFM.chatMessage(msg, target)
                end
            end
        end
    end
end