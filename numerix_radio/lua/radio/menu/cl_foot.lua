--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local PANEL = {}

function PANEL:Init()   
end

function PANEL:PerformLayout(width, height)
    self:SetSize(width, height)
end

function PANEL:MakeContent(ent, type)
	local radio = Radio.ConnectedRadio

	self.Think = function()
		radio = Radio.ConnectedRadio
	end
	
	self.Paint = function(s, w, h) 

		if ent.Error then
			draw.DrawText(Radio.GetLanguage("An error occured. Check the message in chat"), "Radio.Menu", w/2, h/2 - 10, Radio.Color["text"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			return
		end

		if radio:GetNWString("Radio:Info") != "" then
			draw.DrawText(ent:GetNWString("Radio:Info"), "Radio.Menu", w/2, h/2 - 10, Radio.Color["text"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			return
		end

		if radio:GetNWString("Radio:ID") == "" then
			if radio != ent then
				draw.SimpleText(Radio.GetLanguage("Waiting for a server music"), "Radio.Menu", w/2, h/2 - 10, Radio.Color["text"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText(Radio.GetLanguage("Enter a Youtube/MP3/SoundCloud URL"), "Radio.Menu", w/2, h/2 - 10, Radio.Color["text"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end
	
	local lastThumbnail = radio:GetNWString("Radio:Thumbnail")

	local icon = vgui.Create("DImage", self)
	icon:SetPos(5, 0)
	icon:SetSize(self:GetTall() + 25, self:GetTall() - 5)

	Radio.GetImage( radio:GetNWString("Radio:Thumbnail"), radio:GetNWString("Radio:ThumbnailName")..".jpg", function(url, filename)
		icon:SetImage(filename)
	end)

	self.Think = function()
		if radio:GetNWString("Radio:Thumbnail") != lastThumbnail then
			Radio.GetImage( radio:GetNWString("Radio:Thumbnail"), radio:GetNWString("Radio:ThumbnailName")..".jpg", function(url, filename)
				if !IsValid(icon) then return end
				icon:SetImage(filename)
				lastThumbnail = radio:GetNWString("Radio:Thumbnail")
			end)
		end

		if IsValid(icon) then
			if radio:GetNWString("Radio:ID") == "" then
				icon:SetAlpha(0)
			else
				icon:SetAlpha(255)
			end
		end
	end

	local pause = !(radio and radio:IsPausedRadio())

    PlayPauseButton = vgui.Create( "DImageButton", self )
    PlayPauseButton:SetPos( self:GetWide()/10, 0 )				
    PlayPauseButton:SetSize( self:GetTall()/2, self:GetTall()/2 )			
    PlayPauseButton:SetImage( "icon16/bomb.png" )
    PlayPauseButton:CenterVertical(0.5)
    PlayPauseButton.Think = function( self )
		if ent != radio or ent == radio and ent:GetNWString("Radio:ID") == "" then
			self:SetAlpha(0)
		else
			self:SetAlpha(255)
        end

		if ent and ent:IsPausedRadio() then
            if !pause then
                self:SetText( Radio.GetLanguage("Pause") )
                self:SetToolTip( Radio.GetLanguage("Pause") )

                self:SetImage("icon16/control_play.png")
                pause = true
            end
        else
            if pause then
			    self:SetText( Radio.GetLanguage("UnPause") )
                self:SetToolTip(Radio.GetLanguage("unPause") )
            
                self:SetImage("icon16/control_pause.png")

                pause = false
            end
        end
	end
	PlayPauseButton.Paint = function( self, w, h )
		draw.RoundedBox(5, 0, 0, w, h, Radio.Color["button_background"])
            
		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 5, 0, 0, w, h, Radio.Color["button_hover"] )
		end
	end
	PlayPauseButton.DoClick = function()
		if ent == radio and ent:GetNWString("Radio:ID") != "" then
			net.Start("Radio:PauseMusic")
			net.WriteEntity(ent)
			net.WriteBool(ent and ent.station and ent.station:GetState() != GMOD_CHANNEL_PAUSED or false)
			net.SendToServer()
		end
    end
    
    local StopMusic = vgui.Create( "DImageButton", self )		
	StopMusic:SetPos( self:GetWide()/10 + self:GetTall()/2 + 10, 0 )
	StopMusic:SetSize( self:GetTall()/2, self:GetTall()/2 )			
	StopMusic:SetToolTip( Radio.GetLanguage("Stop") )
	StopMusic:SetFont("Radio.Button")
    StopMusic:SetImage( "icon16/control_stop.png" )
    StopMusic:CenterVertical(0.5)
	StopMusic.Paint = function( self, w, h )
		draw.RoundedBox(5, 0, 0, w, h, Radio.Color["button_background"])
            
		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 5, 0, 0, w, h, Radio.Color["button_hover"] )
		end
	end
	StopMusic.Think = function(self)
		if ent != radio  or ent == radio and ent:GetNWString("Radio:ID") == "" then
			self:SetAlpha(0)
		else
			self:SetAlpha(255)
		end
	end
	StopMusic.DoClick = function()
		if ent == radio and ent:GetNWString("Radio:ID") != "" then
			net.Start("Radio:StopMusic")
			net.WriteEntity(ent)
			net.SendToServer()
		end
	end

	local NextMusic = vgui.Create( "DImageButton", self )		
	NextMusic:SetPos( self:GetWide()/10 + (self:GetTall()/2 + 10)*2, 0 )
	NextMusic:SetSize( self:GetTall()/2, self:GetTall()/2 )			
	NextMusic:SetToolTip( "Next Music" )
	NextMusic:SetFont("Radio.Button")
    NextMusic:SetImage( "icon16/control_end.png" )
    NextMusic:CenterVertical(0.5)
	NextMusic.Paint = function( self, w, h )
		draw.RoundedBox(5, 0, 0, w, h, Radio.Color["button_background"])
            
		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 5, 0, 0, w, h, Radio.Color["button_hover"] )
		end
	end
	NextMusic.Think = function(self)
		if ent != radio or ent == radio and ent:GetNWString("Radio:ID") == "" then
			self:SetAlpha(0)
		else
			self:SetAlpha(255)
		end
	end
	NextMusic.DoClick = function()
		if ent == radio and ent:GetNWString("Radio:ID") != "" then
			net.Start("Radio:NextMusic")
			net.WriteEntity(ent)
			net.SendToServer()
		end
	end

	local LoopMusic = vgui.Create( "DImageButton", self )		
	LoopMusic:SetPos( self:GetWide()/10 + (self:GetTall()/2 + 10)*3, 0 )
	LoopMusic:SetSize( self:GetTall()/2, self:GetTall()/2 )			
	LoopMusic:SetToolTip( "Loop Music" )
	LoopMusic:SetFont("Radio.Button")
    LoopMusic:SetImage( "icon16/control_repeat.png" )
    LoopMusic:CenterVertical(0.5)
	LoopMusic.Paint = function( self, w, h )
		draw.RoundedBox(5, 0, 0, w, h, Radio.Color["button_background"])
            
		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 5, 0, 0, w, h, Radio.Color["button_hover"] )
		end
	end
	LoopMusic.Think = function(self)
		if ent != radio or ent == radio and ent:GetNWString("Radio:ID") == "" then
			self:SetAlpha(0)
		else
			self:SetAlpha(255)
		end
	end
	LoopMusic.DoClick = function()
		if ent == radio and ent:GetNWString("Radio:ID") != "" then
			net.Start("Radio:ChangeLoopState")
			net.WriteEntity(ent)
			net.WriteBool(!ent:GetNWBool("Radio:Loop"))
			net.SendToServer()
		end
	end
    
    local TimeInfo = vgui.Create( "DLabel", self )
	TimeInfo:SetText( "" )
	TimeInfo:SetTextColor(Radio.Color["text"])
	TimeInfo:SetFont("Radio.Menu")
	TimeInfo:SizeToContents()
    TimeInfo:CenterVertical(0.5)
    TimeInfo:CenterHorizontal(0.25)
	TimeInfo.Think = function(self)
		if ent.Playing then
			if radio:GetNWString("Radio:Mode") != "3" then
				self:SetText(Radio.SecondsToClock(ent.station:GetTime()).."/"..Radio.SecondsToClock(radio:GetNWInt("Radio:Duration")))	
			else
				self:SetText(Radio.SecondsToClock(ent.station:GetTime()))
			end
			self:SetAlpha(255)

			self:SizeToContents()
		else
			self:SetAlpha(0)
		end
	end

	local TimeSlider = vgui.Create( "DNumSlider", self )			
    TimeSlider:SetSize( self:GetWide()/4, 40 )		
	TimeSlider:SetText( "" )
	TimeSlider.Label:Dock(0)
	TimeSlider.Label:SetSize(0,0)	
	TimeSlider.Label:SetTextColor( Radio.Color["text"] )
	TimeSlider.Label:SetFont("Radio.Button")
	TimeSlider.Scratch:Dock(0)
	TimeSlider.Scratch:SetSize(0,0)
	TimeSlider.Slider:Dock(0)
	TimeSlider.Slider:SetPos(0,0)
	TimeSlider.Slider:SetSize(TimeSlider:GetWide(), 40)
    TimeSlider:SetMin( 0 )				
    TimeSlider:SetMax( ent:GetNWInt("Radio:Duration") )				
    TimeSlider:SetDecimals( 0 )	
    TimeSlider:SetValue(CurTime() - ent:GetNWInt("Radio:Time"))
    TimeSlider.TextArea:SetVisible(false)
	TimeSlider.Think = function(s)
		if ent.Playing and radio:GetNWString("Radio:Mode") != "3" and Radio.Settings.Seek then
			if( !s:IsEditing() ) then
				s:SetValue(ent.station:GetTime())
			end

			s:SetMax( radio:GetNWInt("Radio:Duration") )		

			s:SetAlpha(255)

            s:CenterVertical(0.5)
            local _, y = s:GetPos()
            local x, _ = TimeInfo:GetPos()
            s:SetPos( x + TimeInfo:GetWide() + 10, y)
		else
			s:SetAlpha(0)
		end
	end
	TimeSlider.Slider.Think = function(self)
		if ent.Playing and radio:GetNWString("Radio:Mode") != "3" and Radio.Settings.Seek then
			self:SetAlpha(255)
		else
			self:SetAlpha(0)
		end
	end
    TimeSlider.Slider.Paint = function(self, w, h)
		surface.SetDrawColor( Radio.Color["button_line"] )
		surface.DrawRect( 0, h / 2 - 1, w-12, 5 )
		
		local x, y = self.Knob:GetPos()
		surface.SetDrawColor( Radio.Color["button_hover"] )
		surface.DrawRect( 0, h / 2 - 1, x+(7.5/2), 5 )
	end 
    TimeSlider.Slider.Knob.Paint = function(self, w, h)
		if TimeSlider:IsHovered() or self:IsHovered() then
			surface.SetDrawColor( Radio.Color["button_hover"] )
			draw.NoTexture()
	
			draw.Circle( 7.5/2, 10, 7.5, 360 )
		end
	end
	function TimeSlider.Slider:OnMouseReleased( mcode )
		
		self:SetDragging( false );
		self:MouseCapture( false );

		net.Start("Radio:SeekMusic")
        net.WriteEntity(ent)
        net.WriteString(self:GetSlideX() * ent:GetNWInt("Radio:Duration"))
        net.SendToServer() 
			
	end
	function TimeSlider.Slider.Knob:OnMouseReleased( mcode )
		if ent.Playing and radio:GetNWString("Radio:Mode") != "3" and Radio.Settings.Seek and ent == radio then
			net.Start("Radio:SeekMusic")
			net.WriteEntity(ent)
			net.WriteString(self:GetParent():GetSlideX() * ent:GetNWInt("Radio:Duration"))
			net.SendToServer() 
		end

		return DLabel.OnMouseReleased( self, mcode );
	end

	local VolumeInfo = vgui.Create( "DLabel", self )
	VolumeInfo:SetText( Radio.GetLanguage("Volume") )
	VolumeInfo:SetFont("Radio.Menu")
	VolumeInfo:SetTextColor(Radio.Color["text"])
    VolumeInfo:SizeToContents()
    VolumeInfo:CenterVertical(0.5)
    VolumeInfo:CenterHorizontal(0.8)
	VolumeInfo.Think = function(self)
		if ent.Playing then
			self:SetAlpha(255)
		else
			self:SetAlpha(0)
		end
	end

    local x, y = VolumeInfo:GetPos()
    local VolumeSlider = vgui.Create( "DNumSlider", self )
    VolumeSlider:SetPos( x + VolumeInfo:GetWide() + 10, 0 )	
    VolumeSlider:SetSize( self:GetWide()/6, 40 )		
    VolumeSlider:SetText( "" )	
	VolumeSlider.Label:Dock(0)
	VolumeSlider.Label:SetSize(0,0)	
	VolumeSlider.Label:SetTextColor( Radio.Color["text"] )
	VolumeSlider.Label:SetFont("Radio.Button")
	VolumeSlider.Scratch:Dock(0)
	VolumeSlider.Scratch:SetSize(0,0)
	VolumeSlider.Slider:Dock(0)
	VolumeSlider.Slider:SetPos(0,0)
	VolumeSlider.Slider:SetSize(VolumeSlider:GetWide(), 40)
    VolumeSlider:SetMin( 0 )				
    VolumeSlider:SetMax( 100 )				
    VolumeSlider:SetDecimals( 0 )	
    VolumeSlider:SetValue(ent:GetNWInt("Radio:Volume"))
	VolumeSlider.TextArea:SetVisible(false)
    VolumeSlider:CenterVertical(0.5)	
	VolumeSlider.Think = function(self)
		if ent.Playing then
			self:SetAlpha(255)
		else
			self:SetAlpha(0)
		end
	end		
    VolumeSlider.Slider.Paint = function(self, w, h)
		surface.SetDrawColor( Radio.Color["button_line"] )
		surface.DrawRect( 0, h / 2 - 1, w-12, 5 )

		local x, y = self.Knob:GetPos()
		surface.SetDrawColor( Radio.Color["button_hover"] )
		surface.DrawRect( 0, h / 2 - 1, x+(7.5)/2, 5 )
	end
	    
    VolumeSlider.Slider.Knob.Paint = function(self, w, h)
		if VolumeSlider:IsHovered() or self:IsHovered() then
			surface.SetDrawColor( Radio.Color["button_hover"] )
			draw.NoTexture()
	
			draw.Circle( 7.5/2, 10, 7.5, 360 )
		end
	end
	function VolumeSlider.Slider:OnMouseReleased( mcode )

		self:SetDragging( false );
		self:MouseCapture( false );

		if ent:GetNWInt("Radio:Volume") == self:GetSlideX() then return end
        net.Start("Radio:UpdateVolume")
        net.WriteEntity(ent)
        net.WriteString(self:GetSlideX() * 100)
		net.SendToServer() 	
		
	end
	function VolumeSlider.Slider.Knob:OnMouseReleased( mcode )

		if ent:GetNWInt("Radio:Volume") == self:GetParent():GetSlideX() then return end
        net.Start("Radio:UpdateVolume")
        net.WriteEntity(ent)
        net.WriteString(self:GetParent():GetSlideX())
        net.SendToServer() 

		return DLabel.OnMouseReleased( self, mcode )

	end
end
vgui.Register("Radio_Foot", PANEL, "DPanel")