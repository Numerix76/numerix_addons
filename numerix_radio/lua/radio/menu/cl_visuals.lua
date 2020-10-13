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

function Radio.OpenVisual(ent)
	local VisualBase = vgui.Create( "DFrame" )
	VisualBase:SetSize(ScrW()/4, ScrH()/2.5)
	VisualBase:Center()
	VisualBase:MakePopup()
	VisualBase:SetDraggable( false ) 
	VisualBase:ShowCloseButton( false ) 
	VisualBase:SetTitle( " " )
	VisualBase.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, colorbg_frame)

		surface.SetDrawColor( colorline_frame )
		surface.DrawOutlinedRect( 0, 0, w, h )

		draw.SimpleText(Radio.GetLanguage("Visual"), "Radio.Menu", w/2, 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	
    local Close = vgui.Create( "DButton", VisualBase )		
	Close:SetPos( VisualBase:GetWide() - 30, 5 )
	Close:SetText( "X" )
	Close:SetTextColor( color_white )
	Close:SetSize( 25, 25 )
	Close.Paint = function( self, w, h )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	Close.DoClick = function()
        VisualBase:Close()
        Radio.OpenStreamMenu(ent)
    end
    
    local Mixer = vgui.Create("DColorMixer", VisualBase)
	Mixer:SetPos(5, 35)					
	Mixer:SetSize(VisualBase:GetWide() -10, VisualBase:GetTall()-150-10)
	Mixer:SetPalette(true)  			
	Mixer:SetAlphaBar(false) 			
	Mixer:SetWangs(false) 				
	Mixer:SetColor(string.ToColor(ent:GetNWString("Radio:Visual")))	

	local checkbox = vgui.Create( "DCheckBoxLabel", VisualBase )
	checkbox:SetPos( 5, VisualBase:GetTall()-100 ) 
	checkbox:SetText( Radio.GetLanguage("Rainbow mode ?") )
	checkbox:SetTextColor(color_white)
	checkbox:SetFont("Radio.Menu")
	checkbox:SetValue( ent:GetNWBool("Radio:Rainbow") )

	local Visual = vgui.Create( "DButton", VisualBase )		
	Visual:SetPos( 5, VisualBase:GetTall()-30 )
	Visual:SetText( Radio.GetLanguage("Save Visual") )
	Visual:SetToolTip( Radio.GetLanguage("Save Visual") )
	Visual:SetFont("Radio.Button")
	Visual:SetTextColor( color_white )
	Visual:SetSize( VisualBase:GetWide()-10, 25 )
	Visual.Paint = function( self, w, h )
		local GetColorInner = draw.RoundedBox(0, 0, 0, w, h, colorbg_button)
        
        surface.SetDrawColor( colorline_button )
        surface.DrawOutlinedRect( 0, 0, w, h )
        
        if self:IsHovered() or self:IsDown() then
            draw.RoundedBox( 0, 0, 0, w, h, color_hover )
        end
	end
    Visual.DoClick = function()
        local color = Mixer:GetColor()
        net.Start("Radio:UpdateVisual")
		net.WriteEntity(ent)
		net.WriteColor(Color(color.r, color.g, color.b))
		net.WriteBool(checkbox:GetChecked())
		net.SendToServer()
		
		VisualBase:Close()
        Radio.OpenStreamMenu(ent)
	end
	
end