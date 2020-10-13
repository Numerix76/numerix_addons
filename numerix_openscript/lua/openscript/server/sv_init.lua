--[[ OpenScript --------------------------------------------------------------------------------------

OpenScript made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

util.AddNetworkString("OpenScript:OpenPanel")

local function NumerixOuverture(ply)
	if !OpenScript.Settings.GroupeBypass[ply:GetNWString("usergroup")] and !OpenScript.Settings.SteamIDBypass[ply:SteamID()] then	
		local realtime = os.time()
		local timeouverture = OpenScript.Settings.Horaire
		
        TimeLeft = os.difftime(timeouverture, realtime)

		if TimeLeft > 0 then
			net.Start("OpenScript:OpenPanel")
			net.Send(ply)
		end

		ply:Freeze(true)
		
		timer.Create(ply:SteamID64().."_openscript", TimeLeft, 1,function()
			ply:Freeze(false)
		end)

	end
end
hook.Add( "PlayerSpawn", "OpenScript:PlayerSpawn", NumerixOuverture )

hook.Add("PlayerDisconnected", "OpenScript:PlayerDisconnected", function(ply)	
	if timer.Exists(ply:SteamID64().."_openscript") then
		timer.Destroy(ply:SteamID64().."_openscript")
	end
end)
