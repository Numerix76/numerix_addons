--[[ HUD Identity --------------------------------------------------------------------------------------

HUD Identity made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local ply

hook.Add("HUDPaint", "HUD.Identity:VoiceHUD", function()
	local ShouldDraw = hook.Call("HUDShouldDraw", GAMEMODE, "HUD.Identity:IconVoiceHUD")

	if ShouldDraw == false then return end
	
    ply = LocalPlayer()

    if ply.DRPIsTalking then
        surface.SetMaterial(HUD.Settings.VoiceIcon)
        surface.SetDrawColor( Color(255,255,255,255) )
        surface.DrawTexturedRect(ScrW() - 100, ScrH()/2 - 32, 64, 64, backwards)
    end
end)

local PANEL = {}
local PlayerVoicePanels = {}

function PANEL:Init()

	self.LabelName = vgui.Create( "DLabel", self )
	self.LabelName:SetFont( "GModNotify" )
	self.LabelName:Dock( FILL )
	self.LabelName:DockMargin( 8, 0, 0, 0 )
	self.LabelName:SetTextColor( Color( 255, 255, 255, 255 ) )

	self.Avatar = vgui.Create( "AvatarImage", self )
	self.Avatar:Dock( LEFT )
	self.Avatar:SetSize( 32, 32 )

	self.Color = color_transparent

	self:SetSize( 250, 42 )
	self:DockPadding( 4, 4, 4, 4 )
	self:DockMargin( 2, 2, 2, 2 )
	self:Dock( BOTTOM )

end

function PANEL:Setup( ply )

	self.ply = ply
	self.LabelName:SetText( ply:Nick() )
	self.Avatar:SetPlayer( ply )
	
	self.Color = team.GetColor( ply:Team() )
	
	self:InvalidateLayout()

end

function PANEL:Paint( w, h )

    if ( !IsValid( self.ply ) ) then return end

    draw.RoundedBox( 4, 0, 0, w, h, Color( 15, 200, 230, math.Clamp(self.ply:VoiceVolume() * 255 * 1.5, 0, 255 ) ) )
	
	HUD.DrawRect(0, 0, w, h)

end

function PANEL:Think()
	
	if ( IsValid( self.ply ) ) then
		self.LabelName:SetText( self.ply:Nick() )
	end

	if ( self.fadeAnim ) then
		self.fadeAnim:Run()
	end

end

function PANEL:FadeOut( anim, delta, data )
	
	if ( anim.Finished ) then
	
		if ( IsValid( PlayerVoicePanels[ self.ply ] ) ) then
			PlayerVoicePanels[ self.ply ]:Remove()
			PlayerVoicePanels[ self.ply ] = nil
			return
		end
		
	return end
	
	self:SetAlpha( 255 - ( 255 * delta ) )

end

derma.DefineControl( "VoiceNotify", "", PANEL, "DPanel" )

hook.Add("PlayerStartVoice", "HUD.Identity:VoiceHUD", function( ply )
	
	ply.IsTalking = true
	
	if ( !IsValid( HUD.VoicePanelList )  or ply == LocalPlayer()) then return end
	
	-- There'd be an exta one if voice_loopback is on, so remove it.
	GAMEMODE:PlayerEndVoice( ply )


	if ( IsValid( PlayerVoicePanels[ ply ] ) ) then

		if ( PlayerVoicePanels[ ply ].fadeAnim ) then
			PlayerVoicePanels[ ply ].fadeAnim:Stop()
			PlayerVoicePanels[ ply ].fadeAnim = nil
		end

		PlayerVoicePanels[ ply ]:SetAlpha( 255 )

		return

	end

	if ( !IsValid( ply ) ) then return end

	local pnl = HUD.VoicePanelList:Add( "VoiceNotify" )
	pnl:Setup( ply )
	
	PlayerVoicePanels[ ply ] = pnl

end)

local function VoiceClean()

	for k, v in pairs( PlayerVoicePanels ) do
	
		if ( !IsValid( k ) ) then
			GAMEMODE:PlayerEndVoice( k )
		end
	
	end

end
timer.Create( "VoiceClean", 10, 0, VoiceClean )

hook.Add("PlayerEndVoice", "HUD.Identity:VoiceHUD", function( ply )

	ply.IsTalking = false

	if ( IsValid( PlayerVoicePanels[ ply ] ) ) then

		if ( PlayerVoicePanels[ ply ].fadeAnim ) then return end

		PlayerVoicePanels[ ply ].fadeAnim = Derma_Anim( "FadeOut", PlayerVoicePanels[ ply ], PlayerVoicePanels[ ply ].FadeOut )
		PlayerVoicePanels[ ply ].fadeAnim:Start( 2 )

	end

end)

local function CreateVoiceVGUI()

	HUD.VoicePanelList = vgui.Create( "DPanel" )

	HUD.VoicePanelList:ParentToHUD()
	HUD.VoicePanelList:SetPos( ScrW() - 254, 100 )
	HUD.VoicePanelList:SetSize( 250, ScrH() - 200 )
	HUD.VoicePanelList:SetPaintBackground( false )
	function HUD.VoicePanelList:Think()
		self:SetSize(self:GetWide(), (HUD.RightBottomLastPos or 0 ) - ( ( HUD.Settings.AgendaHUD and DarkRP and LocalPlayer().getAgenda and LocalPlayer():getAgendaTable() or false ) and HUD.Settings.AgendaPos == "RightBottom" and 115 or 0) - 98 ) 
	end

end
hook.Remove("InitPostEntity", "CreateVoiceVGUI")

if !HUD.Settings.VoiceHUD then
	hook.Add( "InitPostEntity", "HUD.Identity:VoiceHUD", CreateVoiceVGUI )
end