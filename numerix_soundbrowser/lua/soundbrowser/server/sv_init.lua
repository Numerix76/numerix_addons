--[[ SoundBrowser --------------------------------------------------------------------------------------

SoundBrowser made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

util.AddNetworkString("SoundBrowser:OpenMenu")

function SoundBrowser.ChatCommand( ply, text, public )
	local cmdlen = string.len(SoundBrowser.Settings.Cmd)

    if (string.sub(text, 1, cmdlen) == SoundBrowser.Settings.Cmd) then 
		if SoundBrowser.Settings.AllowedGroup[ply:GetNWString("usergroup")] then
			net.Start( "SoundBrowser:OpenMenu" )
			net.Send( ply )
		else
			ply:SoundBrowserChatInfo(SoundBrowser.GetLanguage("You are not allowed to do that"), 3)
		end
		return ""
	end
end
hook.Add( "PlayerSay", "SoundBrowser:ChatCommand", SoundBrowser.ChatCommand )