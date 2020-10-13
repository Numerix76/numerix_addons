--[[ Timer Prison --------------------------------------------------------------------------------------

Timer Prison made by Numerix (https://steamcommunity.com/id/numerix/) 

--------------------------------------------------------------------------------------------------]]

function TimerPrison.GetLanguage(sentence)
    if TimerPrison.Language[TimerPrison.Settings.Language] and TimerPrison.Language[TimerPrison.Settings.Language][sentence] then
        return TimerPrison.Language[TimerPrison.Settings.Language][sentence]
    else
        return TimerPrison.Language["default"][sentence]
    end
end

local PLAYER = FindMetaTable("Player")

function PLAYER:TimerPrisonChatInfo(msg, type)
    if SERVER then
        if type == 1 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[Timer Prison] : ]] , Color( 0, 165, 225 ), [["..msg.."]])")
        elseif type == 2 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[Timer Prison] : ]] , Color( 180, 225, 197 ), [["..msg.."]])")
        else
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[Timer Prison] : ]] , Color( 225, 20, 30 ), [["..msg.."]])")
        end
    end

    if CLIENT then
        if type == 1 then
            chat.AddText(Color( 225, 20, 30 ), [[[Timer Prison] : ]] , Color( 0, 165, 225 ), msg)
        elseif type == 2 then
            chat.AddText(Color( 225, 20, 30 ), [[[Timer Prison] : ]] , Color( 180, 225, 197 ), msg)
        else
            chat.AddText(Color( 225, 20, 30 ), [[[Timer Prison] : ]] , Color( 225, 20, 30 ), msg)
        end
    end
end