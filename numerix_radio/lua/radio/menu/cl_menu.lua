--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
local colorline_frame = Color( 255, 255, 255, 200 )
local colorbg_frame = Color(52, 55, 64, 200)

local colorline_button = Color( 255, 255, 255, 100 )
local colorbg_button = Color(33, 31, 35, 200)
local color_hover = Color(0, 0, 0, 100)

local color_button_scroll = Color( 255, 255, 255, 5)
local color_scrollbar = Color( 175, 175, 175, 150 )

local ServerList
local function MakeConnectPanel(ent, panel)
	local selectedstation
	local selectedindex
	ServerList = vgui.Create( "DListView", panel )
    ServerList:SetPos(panel:GetWide()/2,Radio.Settings.ActivePreset and 50 or 125)					
	ServerList:SetSize(panel:GetWide()/2-5,Radio.Settings.ActivePreset and panel:GetTall()-75-10 or panel:GetTall()-150-10)
    ServerList:SetMultiSelect( false )
    ServerList:AddColumn( Radio.GetLanguage("Connected") ):SetFixedWidth(ServerList:GetWide()/6)
    ServerList:AddColumn( Radio.GetLanguage("Station" ) )
    ServerList:AddColumn( Radio.GetLanguage("Actual Title") )
	ServerList:AddColumn( Radio.GetLanguage("Actual Author") )
	ServerList.Paint = function(self, w, h)
		
		draw.RoundedBox(0, 0, 0, w, h, colorbg_button)
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	ServerList.OnRequestResize = function() return end

	ServerList.VBar.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_hover )
    end
    ServerList.VBar.btnUp.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    ServerList.VBar.btnDown.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    ServerList.VBar.btnGrip.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_scrollbar )
	end

    for station, _ in pairs(Radio.AllServer) do
        local pnl = ServerList:AddLine(station == ent:GetNWEntity("Radio:Entity") and Radio.GetLanguage("Yes") or Radio.GetLanguage("No") , station:GetNWString("Radio:StationName"), station:GetNWString("Radio:Title"),station:GetNWString("Radio:Author"))
		pnl.ent = station
	end
	
	for _, columns in ipairs(ServerList.Columns) do
		columns.Header:SetTextColor(color_white)
		columns.Header.Paint = function(self, w, h)
			local GetColorInner = draw.RoundedBox(0, 0, 0, w, h, colorbg_button)
		
			surface.SetDrawColor( colorline_button )
			surface.DrawOutlinedRect( 0, 0, w, h )
		end
	end

	for k, line in ipairs( ServerList:GetLines() ) do
		for _, columns in ipairs(line.Columns) do
			columns:SetTextColor(color_white)
		end
	end

	ServerList.OnRowSelected = function( lst, index, pnl )
        selectedstation = pnl.ent
		selectedindex = pnl
	end
	
	local Connect = vgui.Create( "DButton", panel )		
	Connect:SetPos( panel:GetWide()/2, panel:GetTall() - 30 )
	Connect:SetText( Radio.GetLanguage("Connect") )
	Connect:SetToolTip( Radio.GetLanguage("Connect") )
	Connect:SetFont("Radio.Button")
	Connect:SetTextColor( color_white )
	Connect:SetSize( panel:GetWide()/4-5, 25 )
	Connect.Paint = function( self, w, h )
		local GetColorInner = draw.RoundedBox(0, 0, 0, w, h, colorbg_button)
		
		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )
		
		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end
	end
	Connect.DoClick = function()
		if !IsValid(selectedstation) then return end
		net.Start("Radio:ConnectRadio")
		net.WriteEntity(ent)
		net.WriteEntity(selectedstation)
		net.WriteBool(true)
		net.SendToServer()

		for k, line in ipairs( ServerList:GetLines() ) do
			line:SetColumnText( 1, Radio.GetLanguage("No") )
		end

		selectedindex:SetColumnText( 1, Radio.GetLanguage("Yes") )
	end

	local Disconnect = vgui.Create( "DButton", panel )		
	Disconnect:SetPos( panel:GetWide()-panel:GetWide()/4, panel:GetTall() - 30 )
	Disconnect:SetText( Radio.GetLanguage("Disconnect") )
	Disconnect:SetToolTip( Radio.GetLanguage("Disconnect") )
	Disconnect:SetFont("Radio.Button")
	Disconnect:SetTextColor( color_white )
	Disconnect:SetSize( panel:GetWide()/4-5, 25 )
	Disconnect.Paint = function( self, w, h )
		local GetColorInner = draw.RoundedBox(0, 0, 0, w, h, colorbg_button)
		
		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )
		
		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end
	end
	Disconnect.DoClick = function()
        net.Start("Radio:ConnectRadio")
        net.WriteEntity(ent)
        net.WriteEntity(nil)
        net.WriteBool(false)
		net.SendToServer()
		
		for k, line in ipairs( ServerList:GetLines() ) do
			line:SetColumnText( 1, Radio.GetLanguage("No") )
		end
	end
end

function MakeServerSettingPanel(ent, panel)
	local StationName = vgui.Create( "DLabel", panel )
	StationName:SetPos( panel:GetWide()/2, Radio.Settings.ActivePreset and 55 or 130 )
	StationName:SetText( Radio.GetLanguage("Station Name") )
	StationName:SetTextColor( color_white )
	StationName:SetFont("Radio.Menu")
	StationName:SizeToContents()

	local NameEntry = vgui.Create( "DTextEntry", panel )
	NameEntry:SetPos( panel:GetWide()/2 + 5 + StationName:GetWide(), Radio.Settings.ActivePreset and 50 or 125 )
	NameEntry:SetSize( panel:GetWide()/2-StationName:GetWide() - 10, 30 )
	NameEntry:SetText(ent:GetNWString("Radio:StationName"))
	NameEntry:SetDrawLanguageID(false)
	function NameEntry:OnEnter()
		net.Start("Radio:SetNameServer")
		net.WriteEntity(ent)
        net.WriteString(NameEntry:GetValue())
		net.SendToServer()
	end

	local Save = vgui.Create( "DButton", panel )		
	Save:SetPos( panel:GetWide()-panel:GetWide()/10, Radio.Settings.ActivePreset and 90 or 165 )
	Save:SetText( Radio.GetLanguage("Save") )
	Save:SetToolTip( Radio.GetLanguage("Save") )
	Save:SetFont("Radio.Button")
	Save:SetTextColor( color_white )
	Save:SetSize( panel:GetWide()/10-5, 25 )
	Save.Paint = function( self, w, h )
		local GetColorInner = draw.RoundedBox(0, 0, 0, w, h, colorbg_button)
		
		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )
		
		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end
	end
	Save.DoClick = function()
		net.Start("Radio:SetNameServer")
		net.WriteEntity(ent)
        net.WriteString(NameEntry:GetValue())
		net.SendToServer()
	end

	local Viewer = vgui.Create( "DLabel", panel )
	Viewer:SetPos( panel:GetWide()/2, Radio.Settings.ActivePreset and 120 or 195 )
	Viewer:SetText( string.format(Radio.GetLanguage("Auditors : %i"), ent:GetNWInt("Radio:Viewer")) )
	Viewer:SetTextColor( color_white )
	Viewer:SetFont("Radio.Menu")
	Viewer:SizeToContents()

	local voice = vgui.Create( "DCheckBoxLabel", panel )
	voice:SetPos( panel:GetWide()/2, Radio.Settings.ActivePreset and 150 or 225 ) 
	voice:SetText( Radio.GetLanguage("Transmit voice ?") )
	voice:SetTextColor(color_white)
	voice:SetFont("Radio.Menu")
	voice:SetValue( ent:GetNWBool("Radio:Voice") )
	function voice:OnChange(bVal)
		net.Start("Radio:TransmitVoice")
		net.WriteEntity(ent)
		net.WriteBool(bVal)
		net.SendToServer()
	end
end


function Radio.OpenStreamMenu(vehicle)
	
	if IsValid(RadioBase) then
		RadioBase:Close()
	end

    local ent = net.ReadEntity() or vehicle
	local radio = ent:GetNWEntity("Radio:Entity")

    local RadioBase = vgui.Create( "DFrame" )
	RadioBase:SetSize(ScrW()/1.5, 325)
	RadioBase:Center()
	RadioBase:MakePopup()
	RadioBase:SetDraggable( false ) 
	RadioBase:ShowCloseButton( false ) 
	RadioBase:SetTitle( " " )
	RadioBase.Paint = function( self, w, h )	
		draw.RoundedBox(0, 0, 0, w, h, colorbg_frame)

		surface.SetDrawColor( colorline_frame )
		surface.DrawOutlinedRect( 0, 0, w, h )
        
		draw.SimpleText(Radio.GetLanguage("Radio management"), "Radio.Menu", w/2, 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		if ent.Error then
			draw.DrawText(Radio.GetLanguage("An error occured. Check the message in chat"), "Radio.Menu", w/4, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			return
		end

		if ent:GetNWString("Radio:Info") != "" then
			draw.DrawText(ent:GetNWString("Radio:Info"), "Radio.Menu", w/4, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			return
		end

		if radio:GetNWString("Radio:ID") == "" then
			if radio != ent then
				draw.SimpleText(Radio.GetLanguage("Waiting for a server music"), "Radio.Menu", w/4, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText(Radio.Settings.ActivePreset and Radio.GetLanguage("Click on the play button") or Radio.GetLanguage("Enter a Youtube/MP3/SoundCloud URL"), "Radio.Menu", w/4, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end
	RadioBase.Think = function()
		radio = ent:GetNWEntity("Radio:Entity")
	end

	local Playing = vgui.Create( "DLabel", RadioBase )
	Playing:SetPos( 10, 40 )
	Playing:SetSize( RadioBase:GetWide()/2-25, 20 )
	Playing:SetText( Radio.GetLanguage("Now Playing :") )
	Playing:SetTextColor(color_white)
	Playing:SetFont("Radio.Menu")
	Playing.Think = function(self)
		if ent.Playing then
			self:SetAlpha(255)
		else
			self:SetAlpha(0)
		end
	end

	local Title = vgui.Create( "DLabel", RadioBase )
	Title:SetPos( 20, 70 )
	Title:SetSize( RadioBase:GetWide()/2-25, 20 )
	Title:SetText( radio:GetNWString("Radio:Title") )
	Title:SetTextColor(color_white)
	Title:SetFont("Radio.Menu")
	Title.Think = function(self)
		if ent.Playing then
			self:SetText( radio:GetNWString("Radio:Title") )

			self:SetAlpha(255)
		else
			self:SetAlpha(0)
		end
	end

	local Author = vgui.Create( "DLabel", RadioBase )
	Author:SetPos( 20, 90 )
	Author:SetSize( RadioBase:GetWide()/2-25, 20 )
	Author:SetText( radio:GetNWString("Radio:Author") )
	Author:SetTextColor(color_white)
	Author:SetFont("Radio.Menu")
	Author.Think = function(self)
		if ent.Playing and radio:GetNWString("Radio:Mode") != "3" then
			self:SetText( radio:GetNWString("Radio:Author") )

			self:SetAlpha(255)
		else
			self:SetAlpha(0)
		end
	end

	local Close = vgui.Create( "DButton", RadioBase )		
	Close:SetPos( RadioBase:GetWide() - 30, 5 )
	Close:SetText( "X" )
	Close:SetTextColor( color_white )
	Close:SetSize( 25, 25 )
	Close.Paint = function( self, w, h )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	Close.DoClick = function()
		RadioBase:Close()
	end

	local SetURL
	if !Radio.Settings.ActivePreset then
		SetURL = vgui.Create( "DTextEntry", RadioBase )
		SetURL:SetPos( RadioBase:GetWide()/2, 50 )
		SetURL:SetSize( RadioBase:GetWide()/2-5, 30 )
		SetURL:SetPlaceholderText("https://gmod-radio-numerix.mtxserv.com/exemple/Dennis%20Lloyd%20-%20NEVERMIND.mp3")
		SetURL:SetDrawLanguageID(false)
		function SetURL:OnEnter()
			local url = self:GetValue()
			url = string.gsub(url, ":[:%d]+", "")
			url = string.Replace(url, " ", "")
			Radio.StartMusic(url, ent)

			if IsValid(ServerList) then
				for k, line in pairs( ServerList:GetLines() ) do
					line:SetColumnText( 1, "No" )
				end
			end
		end

		local OpenWebYT = vgui.Create( "DButton", RadioBase )		
		OpenWebYT:SetPos(RadioBase:GetWide()/2, 90 )
		OpenWebYT:SetText( Radio.GetLanguage("Youtube") )
		OpenWebYT:SetFont("Radio.Button")
		OpenWebYT:SetTextColor( color_white )
		OpenWebYT:SetSize( RadioBase:GetWide()/4.5, 25 )
		OpenWebYT.Paint = function( self, w, h )
			local GetColorInner = draw.RoundedBox(0, 0, 0, w, h, colorbg_button)
        
			surface.SetDrawColor( colorline_button )
			surface.DrawOutlinedRect( 0, 0, w, h )
			
			if self:IsHovered() or self:IsDown() then
				draw.RoundedBox( 0, 0, 0, w, h, color_hover )
			end
		end
		OpenWebYT.DoClick = function()
			Radio.OpenWebBrowser(1, ent)
			RadioBase:Close()
		end
		
		local OpenWebSC = vgui.Create( "DButton", RadioBase )		
		OpenWebSC:SetPos( RadioBase:GetWide() - RadioBase:GetWide()/4.5 - 5, 90 )
		OpenWebSC:SetText( Radio.GetLanguage("SoundCloud") )
		OpenWebSC:SetFont("Radio.Button")
		OpenWebSC:SetTextColor( color_white )
		OpenWebSC:SetSize( RadioBase:GetWide()/4.5, 25 )
		OpenWebSC.Paint = function( self, w, h )
			local GetColorInner = draw.RoundedBox(0, 0, 0, w, h, colorbg_button)
        
			surface.SetDrawColor( colorline_button )
			surface.DrawOutlinedRect( 0, 0, w, h )
			
			if self:IsHovered() or self:IsDown() then
				draw.RoundedBox( 0, 0, 0, w, h, color_hover )
			end
		end
		OpenWebSC.DoClick = function()
			Radio.OpenWebBrowser(2, ent)
			RadioBase:Close()
		end
	end
	
	local TimeInfo = vgui.Create( "DLabel", RadioBase )
	TimeInfo:SetPos( 20, 130 )
	TimeInfo:SetSize( RadioBase:GetWide()/2, 20 )
	TimeInfo:SetText( "" )
	TimeInfo:SetTextColor(color_white)
	TimeInfo:SetFont("Radio.Menu")
	TimeInfo.Think = function(self)
		if ent.Playing then
			if radio:GetNWString("Radio:Mode") != "3" then
				self:SetText(Radio.SecondsToClock(ent.station:GetTime()).."/"..Radio.SecondsToClock(radio:GetNWInt("Radio:Duration")))	
			else
				self:SetText(Radio.SecondsToClock(ent.station:GetTime()))
			end
			self:SetAlpha(255)
		else
			self:SetAlpha(0)
		end
	end

	local TimeSlider = vgui.Create( "DNumSlider", RadioBase )
    TimeSlider:SetPos( -RadioBase:GetWide()/11, 145 )			
    TimeSlider:SetSize( RadioBase:GetWide()/3.5, 40 )		
    TimeSlider:SetText( "" )	
	TimeSlider.Label:SetTextColor( color_white )
	TimeSlider.Label:SetFont("Radio.Button")
    TimeSlider:SetMin( 0 )				
    TimeSlider:SetMax( ent:GetNWInt("Radio:Duration") )				
    TimeSlider:SetDecimals( 0 )	
    TimeSlider:SetValue(CurTime() - ent:GetNWInt("Radio:Time"))
	TimeSlider.TextArea:SetVisible(false)
	TimeSlider.Think = function(self)
		if ent.Playing and radio:GetNWString("Radio:Mode") != "3" and Radio.Settings.Seek and ent == radio then
			if( !self:IsEditing() ) then
				self:SetValue(ent.station:GetTime())
			end

			self:SetMax( radio:GetNWInt("Radio:Duration") )		

			self:SetAlpha(255)
		else
			self:SetAlpha(0)
		end
	end
	TimeSlider.Slider.Think = function(self)
		if ent.Playing and radio:GetNWString("Radio:Mode") != "3" and Radio.Settings.Seek and ent == radio then
			self:SetAlpha(255)
		else
			self:SetAlpha(0)
		end
	end
    TimeSlider.Slider.Paint = function(self, w, h)
        surface.SetDrawColor( colorline_button )
		surface.DrawRect( 0, h / 2 - 1, w, 1 )
    end
    TimeSlider.Slider.Knob.Paint = function(self, w, h)
        surface.SetDrawColor( colorline_button )
		surface.DrawRect( w / 2 - 2, 0, 4, h )
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

	local VolumeInfo = vgui.Create( "DLabel", RadioBase )
	VolumeInfo:SetPos( 20, 180 )
	VolumeInfo:SetSize( RadioBase:GetWide()/2, 20 )
	VolumeInfo:SetText( Radio.GetLanguage("Volume") )
	VolumeInfo:SetFont("Radio.Menu")
	VolumeInfo:SetTextColor(color_white)
	VolumeInfo.Think = function(self)
		if ent.Playing then
			self:SetAlpha(255)
		else
			self:SetAlpha(0)
		end
	end

    local VolumeSlider = vgui.Create( "DNumSlider", RadioBase )
    VolumeSlider:SetPos( -RadioBase:GetWide()/11, 195 )			
    VolumeSlider:SetSize( RadioBase:GetWide()/3.5, 30 )		
    VolumeSlider:SetText( "" )	
	VolumeSlider.Label:SetTextColor( color_white )
	VolumeSlider.Label:SetFont("Radio.Button")
    VolumeSlider:SetMin( 0 )				
    VolumeSlider:SetMax( 100 )				
    VolumeSlider:SetDecimals( 0 )	
    VolumeSlider:SetValue(ent:GetNWInt("Radio:Volume"))
	VolumeSlider.TextArea:SetVisible(false)
	VolumeSlider.Think = function(self)
		if ent.Playing then
			self:SetAlpha(255)
		else
			self:SetAlpha(0)
		end
	end		
    VolumeSlider.Slider.Paint = function(self, w, h)
        surface.SetDrawColor( colorline_button )
		surface.DrawRect( 0, h / 2 - 1, w, 1 )
    end
    VolumeSlider.Slider.Knob.Paint = function(self, w, h)
        surface.SetDrawColor( colorline_button )
		surface.DrawRect( w / 2 - 2, 0, 4, h )
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

	local loop = vgui.Create( "DCheckBoxLabel", RadioBase )
	loop:SetPos( 20, 230 ) 
	loop:SetText( Radio.GetLanguage("Make music loop ?") )
	loop:SetTextColor(color_white)
	loop:SetFont("Radio.Menu")
	loop:SetValue( ent:GetNWBool("Radio:Loop") )
	function loop:OnChange(bVal)
		net.Start("Radio:ChangeLoopState")
		net.WriteEntity(ent)
		net.WriteBool(bVal)
		net.SendToServer()
	end
	loop.Think = function(self)
		if ent.Playing and radio:GetNWString("Radio:Mode") != "3" and ent == radio then
			self:SetAlpha(255)
		else
			self:SetAlpha(0)
		end
	end

	if FPP then
		local Private = vgui.Create( "DCheckBoxLabel", RadioBase )
		Private:SetPos( 20, 250 ) 
		Private:SetText( Radio.GetLanguage("Private radio ?") )
		Private:SetTextColor(color_white)
		Private:SetFont("Radio.Menu")
		Private:SetValue( ent:GetNWBool("Radio:Private") )
		function Private:OnChange(bVal)
			net.Start("Radio:ChangePrivateState")
			net.WriteEntity(ent)
			net.WriteBool(bVal)
			net.SendToServer()
		end

		local Buddy = vgui.Create( "DCheckBoxLabel", RadioBase )
		Buddy:SetPos( 20, 270 ) 
		Buddy:SetText( Radio.GetLanguage("Allow buddy (FPP) to use radio ?") )
		Buddy:SetTextColor(color_white)
		Buddy:SetFont("Radio.Menu")
		Buddy:SetValue( ent:GetNWBool("Radio:PrivateBuddy") )
		function Buddy:OnChange(bVal)
			net.Start("Radio:ChangePrivateBuddyState")
			net.WriteEntity(ent)
			net.WriteBool(bVal)
			net.SendToServer()
		end
		Buddy.Think = function(self)
			if ent:GetNWBool("Radio:Private") then
				self:SetAlpha(255)
			else
				self:SetAlpha(0)
			end
		end
	end

	local w = (ent:GetClass() == "numerix_radio_server" or ent:GetClass() == "numerix_radio" and (LocalPlayer():HasWeapon("numerix_radio_swep") or !Radio.Settings.EnableSWEP ) ) and RadioBase:GetWide()/2/4 - 15 or RadioBase:GetWide()/2/5 - 15
	local Play = vgui.Create( "DButton", RadioBase )		
	Play:SetPos( 15, RadioBase:GetTall()-30 )
	Play:SetText( Radio.GetLanguage("Play") )
	Play:SetToolTip( Radio.GetLanguage("Play") )
	Play:SetFont("Radio.Button")
	Play:SetTextColor( color_white )
	Play:SetSize( w, 25 )
	Play.Paint = function( self, w, h )
		local GetColorInner = draw.RoundedBox(0, 0, 0, w, h, colorbg_button)
        
        surface.SetDrawColor( colorline_button )
        surface.DrawOutlinedRect( 0, 0, w, h )
        
        if self:IsHovered() or self:IsDown() then
            draw.RoundedBox( 0, 0, 0, w, h, color_hover )
        end
	end
	Play.DoClick = function()
		if Radio.Settings.ActivePreset then RadioBase:Close() Radio.OpenPresetMenu(ent) return end
		
		Radio.StartMusic(SetURL:GetValue(), ent)
	end

    local StopMusic = vgui.Create( "DButton", RadioBase )		
	StopMusic:SetPos( (w+5)*1 + 15, RadioBase:GetTall()-30 )
	StopMusic:SetText( Radio.GetLanguage("Stop") )
	StopMusic:SetToolTip( Radio.GetLanguage("Stop") )
	StopMusic:SetFont("Radio.Button")
	StopMusic:SetTextColor( color_white )
	StopMusic:SetSize( w, 25 )
	StopMusic.Paint = function( self, w, h )
		local GetColorInner = draw.RoundedBox(0, 0, 0, w, h, colorbg_button)
        
        surface.SetDrawColor( colorline_button )
        surface.DrawOutlinedRect( 0, 0, w, h )
        
        if self:IsHovered() or self:IsDown() then
            draw.RoundedBox( 0, 0, 0, w, h, color_hover )
        end
	end
	StopMusic.Think = function(self)
		if ent != radio  or ent == radio and ent:GetNWString("Radio:ID") == "" then
			self:SetAlpha(150)
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
	
	local PauseMusic = vgui.Create( "DButton", RadioBase )		
	PauseMusic:SetPos( (w+5)*2 + 15, RadioBase:GetTall()-30 )
	PauseMusic:SetText( Radio.GetLanguage("Pause") )
	PauseMusic:SetToolTip( Radio.GetLanguage("Pause") )
	PauseMusic:SetFont("Radio.Button")
	PauseMusic:SetTextColor( color_white )
	PauseMusic:SetSize( w, 25 )
	PauseMusic.Think = function( self )
		if ent != radio or ent == radio and ent:GetNWString("Radio:ID") == "" then
			self:SetAlpha(150)
		else
			self:SetAlpha(255)
		end

		if ent and ( !ent:GetNWBool("Radio:Pause") or ent.station and ent.station:GetState() != GMOD_CHANNEL_PAUSED) then
			self:SetText( Radio.GetLanguage("Pause") )
			self:SetToolTip( Radio.GetLanguage("Pause") )
		else
			self:SetText( Radio.GetLanguage("UnPause") )
			self:SetToolTip(Radio.GetLanguage("unPause") )
		end
	end
	PauseMusic.Paint = function( self, w, h )
		local GetColorInner = draw.RoundedBox(0, 0, 0, w, h, colorbg_button)
        
        surface.SetDrawColor( colorline_button )
        surface.DrawOutlinedRect( 0, 0, w, h )
        
        if self:IsHovered() or self:IsDown() then
            draw.RoundedBox( 0, 0, 0, w, h, color_hover )
        end
	end
	PauseMusic.DoClick = function()
		if ent == radio and ent:GetNWString("Radio:ID") != "" then
			net.Start("Radio:PauseMusic")
			net.WriteEntity(ent)
			net.WriteBool(ent and ent.station and ent.station:GetState() != GMOD_CHANNEL_PAUSED or false)
			net.SendToServer()
		end
	end

	if ent:GetClass() != "numerix_radio_server" then
		MakeConnectPanel(ent, RadioBase)
	else
		MakeServerSettingPanel(ent, RadioBase)
	end

	local Visual = vgui.Create( "DButton", RadioBase )		
	Visual:SetPos( (w+5)*3 + 15, RadioBase:GetTall()-30 )
	Visual:SetText( Radio.GetLanguage("Visual") )
	Visual:SetToolTip( Radio.GetLanguage("Visual") )
	Visual:SetFont("Radio.Button")
	Visual:SetTextColor( color_white )
	Visual:SetSize( w, 25 )
	Visual.Paint = function( self, w, h )
		local GetColorInner = draw.RoundedBox(0, 0, 0, w, h, colorbg_button)
        
        surface.SetDrawColor( colorline_button )
        surface.DrawOutlinedRect( 0, 0, w, h )
        
        if self:IsHovered() or self:IsDown() then
            draw.RoundedBox( 0, 0, 0, w, h, color_hover )
        end
	end
    Visual.DoClick = function()
        Radio.OpenVisual(ent)
		RadioBase:Close()
	end

	if Radio.Settings.EnableSWEP and ent:GetClass() == "numerix_radio" and !LocalPlayer():HasWeapon("numerix_radio_swep") then
		local Take = vgui.Create( "DButton", RadioBase )		
		Take:SetPos( (w+5)*4 + 15, RadioBase:GetTall()-30 )
		Take:SetText( Radio.GetLanguage("Take") )
		Take:SetToolTip( Radio.GetLanguage("Take") )
		Take:SetFont("Radio.Button")
		Take:SetTextColor( color_white )
		Take:SetSize( w, 25 )
		Take.Paint = function( self, w, h )
			local GetColorInner = draw.RoundedBox(0, 0, 0, w, h, colorbg_button)
        
			surface.SetDrawColor( colorline_button )
			surface.DrawOutlinedRect( 0, 0, w, h )
			
			if self:IsHovered() or self:IsDown() then
				draw.RoundedBox( 0, 0, 0, w, h, color_hover )
			end
		end
		Take.DoClick = function()
			net.Start("Radio:Take")
			net.WriteEntity(ent)
			net.SendToServer()

			RadioBase:Close()
		end
	end
end
net.Receive("Radio:OpenStreamMenu", Radio.OpenStreamMenu)