--[[ F4Menu --------------------------------------------------------------------------------------

F4Menu made by Numerix (https://steamcommunity.com/id/numerix/) 

--------------------------------------------------------------------------------------------------]]

function F4Menu.GetLanguage(sentence)
    if F4Menu.Language[F4Menu.Settings.Language] and F4Menu.Language[F4Menu.Settings.Language][sentence] then
        return F4Menu.Language[F4Menu.Settings.Language][sentence]
    else
        return F4Menu.Language["default"][sentence]
    end
end

local PLAYER = FindMetaTable("Player")

function PLAYER:F4MenuChatInfo(msg, type)
    if SERVER then
        if type == 1 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[F4Menu Identity] : ]] , Color( 0, 165, 225 ), [["..msg.."]])")
        elseif type == 2 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[F4Menu Identity] : ]] , Color( 180, 225, 197 ), [["..msg.."]])")
        else
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[F4Menu Identity] : ]] , Color( 225, 20, 30 ), [["..msg.."]])")
        end
    end

    if CLIENT then
        if type == 1 then
            chat.AddText(Color( 225, 20, 30 ), [[[F4Menu Identity] : ]] , Color( 0, 165, 225 ), msg)
        elseif type == 2 then
            chat.AddText(Color( 225, 20, 30 ), [[[F4Menu Identity] : ]] , Color( 180, 225, 197 ), msg)
        else
            chat.AddText(Color( 225, 20, 30 ), [[[F4Menu Identity] : ]] , Color( 225, 20, 30 ), msg)
        end
    end
end