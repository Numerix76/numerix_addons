--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local ENT = FindMetaTable("Entity")

function ENT:InitRadio()
	
	if self.IsServer then
		self.DistanceSound = Radio.Settings.DistanceSoundServer^2
	else
		self.DistanceSound = Radio.Settings.DistanceSoundRadio^2
	end

	if SERVER then
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
	end

	if self.IsServer then
		if SERVER then
			self:SetNWString( "Radio:StationName", "Default Name")
			self:SetNWInt( "Radio:Viewer", 0)
			self:GetNWBool( "Radio:Voice", false)   
			self:SetNWEntity( "Radio:Entity", self)
		end

        Radio.AllServer[self] = true
    end

	Radio.AllRadio[self] = true
	if !self.SWEPRadio and !self.IsServer then self.ENTRadio = true end
end

function ENT:IsCarRadio()
    if !IsValid(self) then return false end
	if IsValid(self:GetParent()) then return false end --The ent is a part of a vehicle
	
    if self:IsVehicle() then return true end
    if simfphys and simfphys.IsCar and simfphys.IsCar(ent) then return true end
    if self:GetClass() == "prop_vehicle_jeep" then return true end
	if scripted_ents.IsBasedOn(self:GetClass(), "wac_hc_base") then return true end
	
	local isCar = hook.Call("Radio:IsCar", nil, self)
	if isCar != nil then return isCar end

    return false
end

function ENT:CanHearInCarRadio(ply)
	return 	ply:InVehicle() and 
			( IsValid(ply:GetVehicle():GetParent()) and ply:GetVehicle():GetParent() == self or ply:GetVehicle() == self)
end

function ENT:GetCurrentTimeRadio(niceTime, serverTime)
	local ent = self:GetControlerRadio()
	local time = CLIENT and !serverTime and self.station and self.station:GetTime() or CurTime() - ent:GetTimeStartRadio()
	return niceTime and Radio.SecondsToClock( time ) or time
end

function ENT:CanHearRadio(ply)
    return ( self:IsCarRadio() and self:CanHearInCarRadio(ply) ) or ( (self.SWEPRadio and self:CanHearSwepRadio()) or self.ENTRadio or self.IsServer )
end

function ENT:CanHearSwepRadio()
	return self.SWEPRadio and IsValid(self.Owner:GetActiveWeapon()) and self.Owner:GetActiveWeapon().SWEPRadio
end

function ENT:GetDurationRadio()
	local ent = self:GetControlerRadio()
	return ent:GetNWString("Radio:Duration") or 0
end

function ENT:GetControlerRadio()
    return self:GetNWEntity("Radio:Entity") or self.LastStation
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

function ENT:IsPlayingMP3()
	local ent = self:GetControlerRadio()
	return ent:GetNWString("Radio:Mode") == "2"
end
