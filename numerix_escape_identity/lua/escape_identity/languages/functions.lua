--[[ Escape --------------------------------------------------------------------------------------

Escape made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

function Echap.GetLanguage(sentence)
    if Echap.Language[Echap.Settings.Language] and Echap.Language[Echap.Settings.Language][sentence] then
        return Echap.Language[Echap.Settings.Language][sentence]
    else
        return Echap.Language["default"][sentence]
    end
end

local PLAYER = FindMetaTable("Player")

function PLAYER:EchapChatInfo(msg, type)
    if SERVER then
        if type == 1 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[Escape Identity] : ]] , Color( 0, 165, 225 ), [["..msg.."]])")
        elseif type == 2 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[Escape Identity] : ]] , Color( 180, 225, 197 ), [["..msg.."]])")
        else
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[Escape Identity] : ]] , Color( 225, 20, 30 ), [["..msg.."]])")
        end
    end

    if CLIENT then
        if type == 1 then
            chat.AddText(Color( 225, 20, 30 ), [[[Escape Identity] : ]] , Color( 0, 165, 225 ), msg)
        elseif type == 2 then
            chat.AddText(Color( 225, 20, 30 ), [[[Escape Identity] : ]] , Color( 180, 225, 197 ), msg)
        else
            chat.AddText(Color( 225, 20, 30 ), [[[Escape Identity] : ]] , Color( 225, 20, 30 ), msg)
        end
    end
end