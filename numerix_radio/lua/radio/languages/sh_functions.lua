--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

function Radio.GetLanguage(sentence)
    if Radio.Language[Radio.Settings.Language] and Radio.Language[Radio.Settings.Language][sentence] then
        return Radio.Language[Radio.Settings.Language][sentence]
    else
        return Radio.Language["default"][sentence]
    end
end

local PLAYER = FindMetaTable("Player")

function PLAYER:RadioChatInfo(msg, type)
    if SERVER then
        if type == 1 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[Radio] : ]] , Color( 0, 165, 225 ), [["..msg.."]])")
        elseif type == 2 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[Radio] : ]] , Color( 180, 225, 197 ), [["..msg.."]])")
        else
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[Radio] : ]] , Color( 225, 20, 30 ), [["..msg.."]])")
        end
    end

    if CLIENT then
        if type == 1 then
            chat.AddText(Color( 225, 20, 30 ), [[[Radio] : ]] , Color( 0, 165, 225 ), msg)
        elseif type == 2 then
            chat.AddText(Color( 225, 20, 30 ), [[[Radio] : ]] , Color( 180, 225, 197 ), msg)
        else
            chat.AddText(Color( 225, 20, 30 ), [[[Radio] : ]] , Color( 225, 20, 30 ), msg)
        end
    end
end