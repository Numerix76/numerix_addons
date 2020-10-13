--[[ HUD Identity  --------------------------------------------------------------------------------------

HUD Identity made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

function HUD.GetLanguage(sentence)
    if HUD.Language[HUD.Settings.Language] and HUD.Language[HUD.Settings.Language][sentence] then
        return HUD.Language[HUD.Settings.Language][sentence]
    else
        return HUD.Language["default"][sentence]
    end
end

local PLAYER = FindMetaTable("Player")

function PLAYER:HUDChatInfo(msg, type)
    if SERVER then
        if type == 1 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[HUD] : ]] , Color( 0, 165, 225 ), [["..msg.."]])")
        elseif type == 2 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[HUD] : ]] , Color( 180, 225, 197 ), [["..msg.."]])")
        else
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[HUD] : ]] , Color( 225, 20, 30 ), [["..msg.."]])")
        end
    end

    if CLIENT then
        if type == 1 then
            chat.AddText(Color( 225, 20, 30 ), [[[HUD] : ]] , Color( 0, 165, 225 ), msg)
        elseif type == 2 then
            chat.AddText(Color( 225, 20, 30 ), [[[HUD] : ]] , Color( 180, 225, 197 ), msg)
        else
            chat.AddText(Color( 225, 20, 30 ), [[[HUD] : ]] , Color( 225, 20, 30 ), msg)
        end
    end
end