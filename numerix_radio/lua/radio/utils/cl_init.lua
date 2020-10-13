--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local volume
local pause
local music_state
local id
local ply
function Radio.Think(self, ent)
	ply = LocalPlayer()
	id = ent:GetNWString("Radio:ID")
	if id == "" and (self.Playing or self.Error) then 
		Radio.StopMusic(self)
	end
	
	if id != "" and !self.Playing and !self.StartedPlaying then 
		self.StartedPlaying = true --To not lunch multiple times the music
		sound.PlayURL(id, "3d noblock", function( station, errorID, error )
			if errorID then
				if !self.Error then
					Radio.Error(ply, string.format(Radio.GetLanguage("Impossible to play the music. Contact an administrator if this persists. (Error : %s, Name : %s)", errorID or "", error or "")))
				end
					
				self.Error = true
				self.StartedPlaying = false

				return
			end
		
			self.Error = false

			if ( IsValid( station ) ) then
				self.station = station

				station:SetPos( self:GetPos() )
			
				station:Play()

				station:Set3DFadeDistance( -1, 1 )
				
				self.Playing = true
			end

			self.StartedPlaying = false
		end )
	end

	if !self.Playing then return end

	self.station:SetPos( self:GetPos() )

	if ( Radio.IsCar(self) and ( !ply:InVehicle() or ( !IsValid( ply:GetVehicle():GetParent() ) and ply:GetVehicle() != self or IsValid( ply:GetVehicle():GetParent() ) and ply:GetVehicle():GetParent() != self ) ) ) or ( self:GetClass() == "numerix_radio_swep" and IsValid(self.Owner:GetActiveWeapon()) and self.Owner:GetActiveWeapon():GetClass() != "numerix_radio_swep" ) and self.Playing then
		volume = 0
	else	
		volume = self:GetNWInt( "Radio:Volume")/100

		volume = volume * ( 1 - ( self.station:GetPos():DistToSqr( ply:EyePos() ) ) / self:GetNWInt("Radio:DistanceSound") )
		volume = math.Clamp(volume, 0, 1)

		if Radio.IsCar(self) then
			volume = volume * 3
		end
	end
	
	if self.station:GetVolume() != volume then
		self.station:SetVolume(volume)
	end

	pause = ent:GetNWBool("Radio:Pause")
	music_state = self.station:GetState()

	if ( music_state != GMOD_CHANNEL_PAUSED and pause ) then
		self.station:Pause();
	elseif ( music_state == GMOD_CHANNEL_PAUSED and !pause ) then
		self.station:Play();
	elseif music_state == GMOD_CHANNEL_STOPPED and id != "" then
		self.station:Play();
	end

	if ent:GetNWString("Radio:Mode") != "3" and (!pause) then
		local time = CurTime() - ent:GetNWInt("Radio:Time")
		
		if math.abs( self.station:GetTime() - time ) > 0.5 then -- There is a difference between what he should listen
			time = math.Clamp(time, self.station:GetTime() - 30 * 60, self.station:GetTime() + 30 *60)
			time = math.Clamp(time, 0, ent:GetNWInt("Radio:Duration"))
			self.station:SetTime(time)
		end
	end
end

function Radio.StartMusic(url, ent, name)
	local ply = LocalPlayer()
	local id = Radio.GetYoutubeID(url)

	if url == "" then return end 
	if string.len(url) > 512 then
		ply:RadioChatInfo(Radio.GetLanguage("URL too long (max: 512 characters)."), 3)
		return
	end
	if id then
		net.Start("Radio:SetMusic")
		net.WriteEntity(ent)
		net.WriteString(name or id)
		net.WriteString("1")
		net.SendToServer()
	elseif string.StartWith(url, "https://soundcloud.com/") or string.StartWith(url, "https://www.soundcloud.com/") then

		url = Radio.GetSoundCloud(url)
		if url or name then
			net.Start("Radio:SetMusic")
			net.WriteEntity(ent)
			net.WriteString(name or url)
			net.WriteString("3")
			net.SendToServer()
		else
			ply:RadioChatInfo(Radio.GetLanguage("URL SoundCloud invalid"), 3)
		end

	else
		net.Start("Radio:SetMusic")
		net.WriteEntity(ent)
		net.WriteString(name or url)
		net.WriteString("2")
		net.SendToServer()
	end
end

function Radio.StopMusic(self)
	if self.station and IsValid(self.station) then
		self.station:Stop()

		self.station = nil
		self.Playing = false
	end
end