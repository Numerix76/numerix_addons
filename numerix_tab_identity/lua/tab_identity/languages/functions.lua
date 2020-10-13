--[[ TAB --------------------------------------------------------------------------------------

TAB made by Numerix (https://steamcommunity.com/id/numerix/) 

--------------------------------------------------------------------------------------------------]]

function TAB.GetLanguage(sentence)
    if TAB.Language[TAB.Settings.Language] and TAB.Language[TAB.Settings.Language][sentence] then
        return TAB.Language[TAB.Settings.Language][sentence]
    else
        return TAB.Language["default"][sentence]
    end
end

local PLAYER = FindMetaTable("Player")

function PLAYER:TABChatInfo(msg, type)
    if SERVER then
        if type == 1 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[TAB] : ]] , Color( 0, 165, 225 ), [["..msg.."]])")
        elseif type == 2 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[TAB] : ]] , Color( 180, 225, 197 ), [["..msg.."]])")
        else
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[TAB] : ]] , Color( 225, 20, 30 ), [["..msg.."]])")
        end
    end

    if CLIENT then
        if type == 1 then
            chat.AddText(Color( 225, 20, 30 ), [[[TAB] : ]] , Color( 0, 165, 225 ), msg)
        elseif type == 2 then
            chat.AddText(Color( 225, 20, 30 ), [[[TAB] : ]] , Color( 180, 225, 197 ), msg)
        else
            chat.AddText(Color( 225, 20, 30 ), [[[TAB] : ]] , Color( 225, 20, 30 ), msg)
        end
    end
end