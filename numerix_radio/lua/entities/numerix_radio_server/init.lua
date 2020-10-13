--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_lab/servers.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )      
	self:SetMoveType( MOVETYPE_VPHYSICS )  
	self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )
 
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:AcceptInput( Name, Activator, Caller )	
    if Name == "Use" and Caller:IsPlayer() and Radio.CanModificateRadio(Activator, self) then
        net.Start( "Radio:OpenStreamMenu" )
        net.WriteEntity( self )
        net.Send( Activator )
	end	
end

function ENT:OnRemove()
    self:SetNWString( "Radio:ID", "" )
    self:SetNWString( "Radio:Author", "" )
    self:SetNWString( "Radio:Title", "" )
    self:SetNWString( "Radio:Mode", "0" )
    self:SetNWInt( "Radio:Duration", 0)

    for ent, _ in pairs(Radio.AllRadio) do
        if ent:GetNWEntity("Radio:Entity") == self then ent:SetNWEntity("Radio:Entity", ent) end
    end

    Radio.AllServer[self] = nil
end

function ENT:Think()
    Radio.Think(self, self:GetNWEntity("Radio:Entity"))
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end