--[[ OpenScript --------------------------------------------------------------------------------------

OpenScript made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

function OpenScript.GetLanguage(sentence)
    if OpenScript.Language[OpenScript.Settings.Language] and OpenScript.Language[OpenScript.Settings.Language][sentence] then
        return OpenScript.Language[OpenScript.Settings.Language][sentence]
    else
        return OpenScript.Language["default"][sentence]
    end
end

local PLAYER = FindMetaTable("Player")

function PLAYER:OpenScriptChatInfo(msg, type)
    if SERVER then
        if type == 1 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[OpenScript] : ]] , Color( 0, 165, 225 ), [["..msg.."]])")
        elseif type == 2 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[OpenScript] : ]] , Color( 180, 225, 197 ), [["..msg.."]])")
        else
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[OpenScript] : ]] , Color( 225, 20, 30 ), [["..msg.."]])")
        end
    end

    if CLIENT then
        if type == 1 then
            chat.AddText(Color( 225, 20, 30 ), [[[OpenScript] : ]] , Color( 0, 165, 225 ), msg)
        elseif type == 2 then
            chat.AddText(Color( 225, 20, 30 ), [[[OpenScript] : ]] , Color( 180, 225, 197 ), msg)
        else
            chat.AddText(Color( 225, 20, 30 ), [[[OpenScript] : ]] , Color( 225, 20, 30 ), msg)
        end
    end
end