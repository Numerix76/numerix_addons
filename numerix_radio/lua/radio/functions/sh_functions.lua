--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local ENT = FindMetaTable("Entity")

function ENT:InitRadio()
	
	self.DistanceSound = Radio.Settings.DistanceSound^2

	self:SetNWString( "Radio:ID", "" )
    self:SetNWString( "Radio:Author", "" )
    self:SetNWString( "Radio:Title", "" )
    self:SetNWString( "Radio:Mode", "0" )
    self:SetNWString( "Radio:Info", "" )
    self:SetNWString( "Radio:Visual", "255 255 255" )
	self:SetNWString( "Radio:Color", "255 255 255" )
	self:SetNWString( "Radio:Thumbnail", "")
	self:SetNWString( "Radio:ThumbnailName", "")

    self:SetNWInt( "Radio:Volume", 50 )
    self:SetNWInt( "Radio:Time", CurTime() )
    self:SetNWInt( "Radio:Duration", 0)
	self:SetNWInt( "Radio:DistanceSound", self.DistanceSound)
	

    self:SetNWBool( "Radio:Pause", false)
	self:SetNWBool("Radio:Rainbow", false)
	self:SetNWBool("Radio:Private", false)
    self:SetNWBool("Radio:PrivateBuddy", false)

	self:SetNWEntity("Radio:Entity", self)
	self.LastStation = self

	if self.IsServer then
        self:SetNWString( "Radio:StationName", "Default Name")
        self:SetNWInt( "Radio:Viewer", 0)
        self:GetNWBool( "Radio:Voice", false)   
        self:SetNWEntity( "Radio:Entity", self)

        Radio.AllServer[self] = true
    end

	Radio.AllRadio[self] = true
	self.ENTRadio = true
end

function ENT:IsCarRadio()
    if !IsValid(self) then return false end
	if IsValid(self:GetParent()) then return false end --The ent is a part of a vehicle
	
    if self:IsVehicle() then return true end
    if simfphys and simfphys.IsCar(self) then return true end
    if self:GetClass() == "prop_vehicle_jeep" then return true end
	if scripted_ents.IsBasedOn(self:GetClass(), "wac_hc_base") then return true end
	
	local isCar = hook.Call("Radio:IsCar", nil, self)
	if isCar != nil then return iscar end

    return false
end

function ENT:CanHearInCarRadio(ply)
	return 	ply:InVehicle() and 
			( IsValid(ply:GetVehicle():GetParent()) and ply:GetVehicle():GetParent() == self or ply:GetVehicle() == self)
end

function ENT:GetCurrentTimeRadio(niceTime, serverTime)
	local ent = self:GetControlerRadio()
	local time = CLIENT and !serverTime and self.station:GetTime() or CurTime() - ent:GetTimeStartRadio()
	return niceTime and Radio.SecondsToClock( time ) or time
end

function ENT:CanHearRadio(ply)
    return ( self:IsCarRadio() and self:CanHearInCarRadio(ply) ) or ( self:CanHearSwepRadio() and self.SWEPRadio ) or self.ENTRadio
end

function ENT:CanHearSwepRadio()
	return self.SWEPRadio and IsValid(self.Owner:GetActiveWeapon()) and self.Owner:GetActiveWeapon().SWEPRadio
end

function ENT:GetDurationRadio()
	local ent = self:GetControlerRadio()
	return ent:GetNWString("Radio:Duration") or 0
end

function ENT:GetControlerRadio()
    return self:GetNWString("Radio:Entity") or self.controler or self.LastStation
end

function ENT:GetColorRadio()
	return string.ToColor(self:GetNWString("Radio:Visual")) or color_white
end

function ENT:GetTimeStartRadio()
    return self:GetNWInt("Radio:Time")
end

function ENT:IsPlayingLive()
	local ent = self:GetControlerRadio()
	return ent:GetNWString("Radio:Mode") == "3"
end
