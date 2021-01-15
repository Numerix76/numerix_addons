--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model or "models/sligwolf/grocel/radio/ghettoblaster.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )      
	self:SetMoveType( MOVETYPE_VPHYSICS )  
	self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )
 
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
    end
    
    if isnumber(self.SID) and FPP then
        self:CPPISetOwner(Player(self.SID))
    end
end

function ENT:AcceptInput( Name, Activator, Caller )	
    if Name == "Use" and Caller:IsPlayer() and self:CanModificateRadio(Activator) then
        net.Start( "Radio:OpenStreamMenu" )
        net.WriteEntity( self )
        net.Send( Activator )
	end	
end

function ENT:OnRemove()
    self:DeleteRadio()
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end