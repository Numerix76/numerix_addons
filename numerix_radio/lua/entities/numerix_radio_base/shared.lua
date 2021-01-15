--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName		= "Radio Base"
ENT.Category		= "Numerix Scripts"
ENT.Author			= "Numerix"
ENT.Contact			= "https://steamcommunity.com/id/numerix/"
ENT.Purpose			= ""
ENT.Instructions	= ""					
ENT.Spawnable = true
ENT.DistanceSound = Radio.Settings.DistanceSound^2 --Distance Maximum ou est émit le son
ENT.VolumeStart = 50 --Volume quand le joueur n'a pas encore touché au volume

function ENT:SetupDataTables()
    self:InitRadio()
end

function ENT:Think()
    self:ThinkRadio()
end