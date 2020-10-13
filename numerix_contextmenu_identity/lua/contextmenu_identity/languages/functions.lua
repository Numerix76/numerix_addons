--[[ ContextMenu Identity --------------------------------------------------------------------------------------

ContextMenu Identity made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

function ContextMenuIdentity.GetLanguage(sentence)
    if ContextMenuIdentity.Language[ContextMenuIdentity.Settings.Language] and ContextMenuIdentity.Language[ContextMenuIdentity.Settings.Language][sentence] then
        return ContextMenuIdentity.Language[ContextMenuIdentity.Settings.Language][sentence]
    else
        return ContextMenuIdentity.Language["default"][sentence]
    end
end

local PLAYER = FindMetaTable("Player")

function PLAYER:ContextMenuIdentityChatInfo(msg, type)
    if SERVER then
        if type == 1 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[ContextMenu Identity] : ]] , Color( 0, 165, 225 ), [["..msg.."]])")
        elseif type == 2 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[ContextMenu Identity] : ]] , Color( 180, 225, 197 ), [["..msg.."]])")
        else
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[ContextMenu Identity] : ]] , Color( 225, 20, 30 ), [["..msg.."]])")
        end
    end

    if CLIENT then
        if type == 1 then
            chat.AddText(Color( 225, 20, 30 ), [[[ContextMenu Identity] : ]] , Color( 0, 165, 225 ), msg)
        elseif type == 2 then
            chat.AddText(Color( 225, 20, 30 ), [[[ContextMenu Identity] : ]] , Color( 180, 225, 197 ), msg)
        else
            chat.AddText(Color( 225, 20, 30 ), [[[ContextMenu Identity] : ]] , Color( 225, 20, 30 ), msg)
        end
    end
end