--[[ ContextMenu Admin --------------------------------------------------------------------------------------

ContextMenu Admin made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

function ContextMenuAdmin.GetLanguage(sentence)
    if ContextMenuAdmin.Language[ContextMenuAdmin.Settings.Language] and ContextMenuAdmin.Language[ContextMenuAdmin.Settings.Language][sentence] then
        return ContextMenuAdmin.Language[ContextMenuAdmin.Settings.Language][sentence]
    else
        return ContextMenuAdmin.Language["default"][sentence]
    end
end

local PLAYER = FindMetaTable("Player")

function PLAYER:ContextMenuAdminChatInfo(msg, type)
    if SERVER then
        if type == 1 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[ContextMenu Admin] : ]] , Color( 0, 165, 225 ), [["..msg.."]])")
        elseif type == 2 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[ContextMenu Admin] : ]] , Color( 180, 225, 197 ), [["..msg.."]])")
        else
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[ContextMenu Admin] : ]] , Color( 225, 20, 30 ), [["..msg.."]])")
        end
    end

    if CLIENT then
        if type == 1 then
            chat.AddText(Color( 225, 20, 30 ), [[[ContextMenu Admin] : ]] , Color( 0, 165, 225 ), msg)
        elseif type == 2 then
            chat.AddText(Color( 225, 20, 30 ), [[[ContextMenu Admin] : ]] , Color( 180, 225, 197 ), msg)
        else
            chat.AddText(Color( 225, 20, 30 ), [[[ContextMenu Admin] : ]] , Color( 225, 20, 30 ), msg)
        end
    end
end