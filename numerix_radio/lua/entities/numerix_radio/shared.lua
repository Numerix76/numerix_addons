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
 
ENT.PrintName       = "Radio"
ENT.Category		= "Numerix Scripts"
ENT.Author			= "Numerix"
ENT.Contact			= "https://steamcommunity.com/id/numerix/"
ENT.Purpose			= ""
ENT.Instructions	= ""			
ENT.Spawnable       = true

ENT.Model           = "models/sligwolf/grocel/radio/ghettoblaster.mdl"
ENT.IsServer        = false