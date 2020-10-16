--[[eventChatMessage = function(player, msg)
    if ROOM.name:find('*') then 
        if not table.contains(mainAssets.roles.moduleTeam, player) and not player:find("#0010") and not player:find("#0020") then
            local language = ROOM.playerList[player].language
            msg = string.format("<v>[%s] [%s<font size='10'><g>%s</g></font>]<n> %s", language, string.sub(player, 1, -6), string.sub(player, -5), msg)
            for target in next, ROOM.playerList do
                if ROOM.playerList[target].language ~= language and not target:find("#0010") and not target:find("#0020") then
                    TFM.chatMessage(msg, target)
                end
            end
        end
    end
end]]--