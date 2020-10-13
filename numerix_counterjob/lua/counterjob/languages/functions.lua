--[[ Counter Job --------------------------------------------------------------------------------------

Counter Job made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

function CounterJob.GetLanguage(sentence)
    if CounterJob.Language[CounterJob.Settings.Language] and CounterJob.Language[CounterJob.Settings.Language][sentence] then
        return CounterJob.Language[CounterJob.Settings.Language][sentence]
    else
        return CounterJob.Language["default"][sentence]
    end
end

local PLAYER = FindMetaTable("Player")

function PLAYER:CounterJobChatInfo(msg, type)
    if SERVER then
        if type == 1 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[CounterJob] : ]] , Color( 0, 165, 225 ), [["..msg.."]])")
        elseif type == 2 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[CounterJob] : ]] , Color( 180, 225, 197 ), [["..msg.."]])")
        else
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[CounterJob] : ]] , Color( 225, 20, 30 ), [["..msg.."]])")
        end
    end

    if CLIENT then
        if type == 1 then
            chat.AddText(Color( 225, 20, 30 ), [[[CounterJob] : ]] , Color( 0, 165, 225 ), msg)
        elseif type == 2 then
            chat.AddText(Color( 225, 20, 30 ), [[[CounterJob] : ]] , Color( 180, 225, 197 ), msg)
        else
            chat.AddText(Color( 225, 20, 30 ), [[[CounterJob] : ]] , Color( 225, 20, 30 ), msg)
        end
    end
end