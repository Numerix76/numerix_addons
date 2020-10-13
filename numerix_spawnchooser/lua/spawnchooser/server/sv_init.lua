--[[ SpawnChooser --------------------------------------------------------------------------------------

SpawnChooser made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

util.AddNetworkString("SpawnChooser:OpenMenu")
util.AddNetworkString("SpawnChooser:CloseMenu")
util.AddNetworkString("SpawnChooser:SetPos")

local function SpawnTP(ply)
	if !DarkRP and true or !ply:isArrested() then
		if !SpawnChooser.Settings.BlackListTeam[ply:Team()] then
			net.Start("SpawnChooser:OpenMenu")
			net.WriteTable(SpawnChooser.Settings.Spawn)
			net.WriteInt(ply:Team(), 9)
			net.Send(ply)
			ply.spawned = false
		end
	end
end
hook.Add( "PlayerSpawn", "SpawnChooser:PlayerSpawn", SpawnTP )

net.Receive("SpawnChooser:SetPos", function(len, ply)
	local SpawnLocation = net.ReadString()
	
	if !ply.spawned and (SpawnChooser.Settings.Spawn[SpawnLocation].restricted == false or SpawnChooser.Settings.Spawn[SpawnLocation].restricted[ply:Team()]) then
		ply:SetPos(table.Random(SpawnChooser.Settings.Spawn[SpawnLocation].pos))
		ply.spawned = true
	end

	ServerLog("[SpawnChooser] "..ply:Name().." ("..ply:SteamID()..") has selected a new spawn. ("..SpawnLocation..")")
end)

local function CloseTPMenu(ply)
	net.Start("SpawnChooser:CloseMenu")
	net.Send(ply)
end
hook.Add("onPlayerRevived", "SpawnChooser:onPlayerRevived", CloseTPMenu )