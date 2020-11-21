--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

if file.Exists("radio/config/sh_config.lua", "LUA") then
    include("radio/config/sh_config.lua")
else
    include("radio/config/sh_config_default.lua")
end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Radio"
ENT.Category		= "Numerix Scripts"
ENT.Author			= "Numerix"
ENT.Contact			= "https://steamcommunity.com/id/numerix/"
ENT.Purpose			= ""
ENT.Instructions	= ""					
ENT.Spawnable = true
ENT.DistanceSound = Radio.Settings.DistanceSound^2 --Distance Maximum ou est émit le son
ENT.VolumeStart = 50 --Volume quand le joueur n'a pas encore touché au volume

function ENT:SetupDataTables()

    self:SetNWString( "Radio:ID", "" )
    self:SetNWString( "Radio:Author", "" )
    self:SetNWString( "Radio:Title", "" )
    self:SetNWString( "Radio:Mode", "0" )
    self:SetNWString( "Radio:Info", "" )
    self:SetNWString( "Radio:Visual", "255 255 255" )
    self:SetNWString( "Radio:Color", "255 255 255" )

    self:SetNWInt( "Radio:Volume", 50 )
    self:SetNWInt( "Radio:Time", CurTime() )
    self:SetNWInt( "Radio:Duration", 0)
    self:SetNWInt( "Radio:DistanceSound", self.DistanceSound)

    self:SetNWBool( "Radio:Pause", false)
    self:SetNWBool( "Radio:Rainbow", false)
    self:SetNWBool( "Radio:Loop", false)
    self:SetNWBool( "Radio:Private", false)
    self:SetNWBool( "Radio:PrivateBuddy", false)

    self:SetNWEntity( "Radio:Entity", self)

    Radio.AllRadio[self] = true
end