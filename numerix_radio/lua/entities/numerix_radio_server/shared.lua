--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

if file.Exists("radio/config/sh_config.lua", "LUA") then
    include("radio/config/sh_config.lua")
else
    include("radio/config/sh_config_default.lua")
end

ENT.Type            = "anim"
ENT.Base            = "numerix_radio_base"
 
ENT.PrintName       = "Radio Server"
ENT.Category		= "Numerix Scripts"
ENT.Author			= "Numerix"
ENT.Contact			= "https://steamcommunity.com/id/numerix/"
ENT.Purpose			= ""
ENT.Instructions	= ""					
ENT.Spawnable       = true

ENT.DistanceSound   = Radio.Settings.DistanceSound^2 --Distance Maximum ou est émit le son
ENT.VolumeStart     = 50 --Volume quand le joueur n'a pas encore touché au volume
ENT.Model           = "models/props_lab/servers.mdl"
ENT.IsServer        = true