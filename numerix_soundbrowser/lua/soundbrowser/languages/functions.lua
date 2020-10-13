--[[ SoundBrowser --------------------------------------------------------------------------------------

SoundBrowser made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

function SoundBrowser.GetLanguage(sentence)
	if SoundBrowser.Language[SoundBrowser.Settings.Language] and SoundBrowser.Language[SoundBrowser.Settings.Language][sentence] then
        return SoundBrowser.Language[SoundBrowser.Settings.Language][sentence]
    else
        return SoundBrowser.Language["default"][sentence]
    end
end


local PLAYER = FindMetaTable("Player")

function PLAYER:SoundBrowserChatInfo(msg, type)
    if SERVER then
        if type == 1 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[SoundBrowser] : ]] , Color( 0, 165, 225 ), [["..msg.."]])")
        elseif type == 2 then
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[SoundBrowser] : ]] , Color( 180, 225, 197 ), [["..msg.."]])")
        else
            self:SendLua("chat.AddText(Color( 225, 20, 30 ), [[[SoundBrowser] : ]] , Color( 225, 20, 30 ), [["..msg.."]])")
        end
    end

    if CLIENT then
        if type == 1 then
            chat.AddText(Color( 225, 20, 30 ), [[[SoundBrowser] : ]] , Color( 0, 165, 225 ), msg)
        elseif type == 2 then
            chat.AddText(Color( 225, 20, 30 ), [[[SoundBrowser] : ]] , Color( 180, 225, 197 ), msg)
        else
            chat.AddText(Color( 225, 20, 30 ), [[[SoundBrowser] : ]] , Color( 225, 20, 30 ), msg)
        end
    end
end