--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local ENT = FindMetaTable("Entity")

local volume
local pause
local music_state
local id
local ply
local ent

function ENT:ThinkRadio()
    if !IsValid(self) then return end
    ent = self:GetControlerRadio()
	
	if !IsValid(ent) then return end

	ply = LocalPlayer()
    id  = ent:GetNWString("Radio:ID")
    
	if id == "" and (self.Playing or self.Error) then 
		self:StopMusicRadio()
	end

    
    if id != "" and !self.Playing and !self.StartedPlaying then 
		self.StartedPlaying = true --To not lunch multiple times the music
		sound.PlayURL(id, "3d noblock", function( station, errorID, errorName )
			if errorID then
				if !self.Error then
					Radio.Error(ply, string.format(Radio.GetLanguage("Impossible to play the music. Contact an administrator if this persists. (Error : %s, Name : %s)"), errorID or "", errorName or ""))
				end
					
				self.Error = true
				self.StartedPlaying = false

				return
			end
		
			self.Error = false

			if ( IsValid( station ) ) then
				station:SetPos( self:GetPos() )
				station:Play()
				station:Set3DFadeDistance( -1, 1 )
				
				self.Playing = true
				self.station = station
				self.TimeStart = self:GetTimeStartRadio()
			end

			self.StartedPlaying = false
		end)
	end

	if !self.Playing then return end

	if self.TimeStart != self:GetTimeStartRadio() then
		self:StopMusicRadio() --Restart when seek to avoid freeze

		return
	end

	self.station:SetPos( self:GetPos() )

	if !self:CanHearRadio(ply) then
		volume = 0
	else	
		volume = self:GetNWInt( "Radio:Volume")/100
		volume = volume * ( 1 - ( self.station:GetPos():DistToSqr( ply:EyePos() ) ) / self:GetNWInt("Radio:DistanceSound") )
		volume = math.Clamp(volume, 0, 1)

		if self:IsCarRadio() then
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

	if !self:IsPlayingLive() and (!pause) then
		local time = self:GetCurrentTimeRadio(false, true)

		if math.abs( self.station:GetTime() - time ) > 0.5 then -- There is a difference between what he should listen
			time = math.Clamp(time, 0, ent:GetDurationRadio())
			self.station:SetTime(time)
		end
	end
end

function ENT:StartMusicRadio(url)
	local ply = LocalPlayer()

	if url == "" then return end 

	if string.len(url) > 512 then
		ply:RadioChatInfo(Radio.GetLanguage("URL too long (max: 512 characters)."), 3)
		return
    end

    net.Start("Radio:SetMusic")
    net.WriteEntity(self)
    net.WriteString(url)
    net.SendToServer()
end

function ENT:IsPausedRadio()
    return self and ( self:GetNWBool("Radio:Pause") or self.station and self.station:GetState() == GMOD_CHANNEL_PAUSED)
end

function ENT:StopMusicRadio()
	if self.station and IsValid(self.station) then
		self.station:Stop()

		self.station = nil
		self.Playing = false
	end
end