--[[ ServerInfo --------------------------------------------------------------------------------------

ServerInfo made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')
 
util.AddNetworkString( "ServerInfo:OpenMenu" )
 
function ENT:Initialize()
	self:SetModel(ServerInfo.Settings.Model)
	self:SetHullType(0)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
end

function ENT:AcceptInput( Name, Activator, Caller )	
	if Name == "Use" and Caller:IsPlayer() then
		net.Start( "ServerInfo:OpenMenu" )
		net.Send( Activator )
	end	
end