--[[ SpawnChooser --------------------------------------------------------------------------------------

SpawnChooser made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

function SpawnChooser.GetLanguage(sentence)
    if SpawnChooser.Language[SpawnChooser.Settings.Language] and SpawnChooser.Language[SpawnChooser.Settings.Language][sentence] then
        return SpawnChooser.Language[SpawnChooser.Settings.Language][sentence]
    else
        return SpawnChooser.Language["default"][sentence]
    end
end

local PLAYER = FindMetaTable("Player")

function PLAYER:SpawnChooserChatInfo(msg, type)
    if SERVER then
        if type == 1 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[SpawnChooser] : ]] , Color( 0, 165, 225 ), [["..msg.."]])")
        elseif type == 2 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[SpawnChooser] : ]] , Color( 180, 225, 197 ), [["..msg.."]])")
        else
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[SpawnChooser] : ]] , Color( 225, 20, 30 ), [["..msg.."]])")
        end
    end

    if CLIENT then
        if type == 1 then
            chat.AddText(Color( 225, 20, 30 ), [[[SpawnChooser] : ]] , Color( 0, 165, 225 ), msg)
        elseif type == 2 then
            chat.AddText(Color( 225, 20, 30 ), [[[SpawnChooser] : ]] , Color( 180, 225, 197 ), msg)
        else
            chat.AddText(Color( 225, 20, 30 ), [[[SpawnChooser] : ]] , Color( 225, 20, 30 ), msg)
        end
    end
end