--[[ SoundBrowser --------------------------------------------------------------------------------------

SoundBrowser made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
local colorline_frame = Color( 255, 255, 255, 100 )
local colorbg_frame = Color(52, 55, 64, 200)

local colorline_button = Color( 255, 255, 255, 100 )
local colorbg_button = Color(33, 31, 35, 200)
local color_hover = Color(0, 0, 0, 100)

local color_text = Color(255,255,255,255)

function SoundBrowser.OpenMenu(len, ply)
  
  local SoundBasePanel = vgui.Create( "DFrame" )
  SoundBasePanel:SetSize( ScrW(), ScrH() )
  SoundBasePanel:Center()
  SoundBasePanel:MakePopup()
  SoundBasePanel:SetDraggable( false )
  SoundBasePanel:ShowCloseButton( false )
  SoundBasePanel:SetTitle( " " )
  SoundBasePanel.Paint = function( self, w, h )
    draw.RoundedBox( 0, 0, 0, w, h, colorbg_frame )
		surface.SetDrawColor( colorline_frame )
    surface.DrawOutlinedRect( 0, 0, w , h )
  end

  local CloseButton = vgui.Create( "DButton", SoundBasePanel)
  CloseButton:SetPos( SoundBasePanel:GetSize() - 25, 5 )
  CloseButton:SetText( "X" )
  CloseButton:SetTextColor( Color( 255, 255, 255, 255 ) )
  CloseButton:SetSize( 25, 25 )
  CloseButton.Paint = function( self, w, h )
  	draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end
  end
  CloseButton.DoClick = function()
    SoundBasePanel:Close()
  end
  
  local StopSoundButton = vgui.Create( "DButton", SoundBasePanel)
  StopSoundButton:SetPos( 5, 5 )
  StopSoundButton:SetText( SoundBrowser.GetLanguage("StopSound") )
  StopSoundButton:SetTextColor( Color( 255, 255, 255, 255 ) )
  StopSoundButton:SetSize( 125, 25 )
  StopSoundButton.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end
  end
  StopSoundButton.DoClick = function()
    for k, v in pairs( player.GetAll() ) do
      v:ConCommand("stopsound")
    end
  end

  local SoundList = vgui.Create( "DFileBrowser", SoundBasePanel )
  SoundList:Dock( FILL )
  SoundList:DockMargin( 0, 10, 0, 0 )
  SoundList:SetPath( "GAME" )
  SoundList:SetBaseFolder( "sound" )
  SoundList:SetOpen( true )
  SoundList:SetCurrentFolder( "persist" )

  function SoundList:OnSelect( path, pnl )
    for k, v in pairs( player.GetAll() ) do
      v:ConCommand("stopsound")
    end

    local p = path
    p = string.sub( p, 7 )

    LocalPlayer():ConCommand("ulx playsound " ..p)
  end
end
net.Receive("SoundBrowser:OpenMenu", SoundBrowser.OpenMenu)