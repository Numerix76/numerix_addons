--[[ ServerInfo --------------------------------------------------------------------------------------

ServerInfo made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

function ServerInfo.GetLanguage(sentence)
    if ServerInfo.Language[ServerInfo.Settings.Language] and ServerInfo.Language[ServerInfo.Settings.Language][sentence] then
        return ServerInfo.Language[ServerInfo.Settings.Language][sentence]
    else
        return ServerInfo.Language["default"][sentence]
    end
end

local PLAYER = FindMetaTable("Player")

function PLAYER:ServerInfoChatInfo(msg, type)
    if SERVER then
        if type == 1 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[NPC Server Info] : ]] , Color( 0, 165, 225 ), [["..msg.."]])")
        elseif type == 2 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[NPC Server Info] : ]] , Color( 180, 225, 197 ), [["..msg.."]])")
        else
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[NPC Server Info] : ]] , Color( 225, 20, 30 ), [["..msg.."]])")
        end
    end

    if CLIENT then
        if type == 1 then
            chat.AddText(Color( 225, 20, 30 ), [[[NPC Server Info] : ]] , Color( 0, 165, 225 ), msg)
        elseif type == 2 then
            chat.AddText(Color( 225, 20, 30 ), [[[NPC Server Info] : ]] , Color( 180, 225, 197 ), msg)
        else
            chat.AddText(Color( 225, 20, 30 ), [[[NPC Server Info] : ]] , Color( 225, 20, 30 ), msg)
        end 
    end
end