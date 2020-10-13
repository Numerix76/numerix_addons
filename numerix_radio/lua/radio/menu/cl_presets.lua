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

function Radio.OpenPresetMenu(ent)
    local PresetBase = vgui.Create( "DFrame" )
	PresetBase:SetSize(ScrW()/2, ScrH()/2.5)
	PresetBase:Center()
	PresetBase:MakePopup()
	PresetBase:SetDraggable( false ) 
	PresetBase:ShowCloseButton( false ) 
	PresetBase:SetTitle( "" )
	PresetBase.Paint = function( self, w, h )	
		draw.RoundedBox(0, 0, 0, w, h, colorbg_frame)

		surface.SetDrawColor( colorline_frame )
        surface.DrawOutlinedRect( 0, 0, w, h )
        
        draw.SimpleText(Radio.GetLanguage("Play"), "Radio.Menu", w/2, 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    local Close = vgui.Create( "DButton", PresetBase )		
	Close:SetPos( PresetBase:GetWide() - 30, 5 )
	Close:SetText( "X" )
	Close:SetTextColor( color_white )
	Close:SetSize( 25, 25 )
	Close.Paint = function( self, w, h )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	Close.DoClick = function()
        PresetBase:Close()
        Radio.OpenStreamMenu(ent)
	end
    
    local RadioScroll = vgui.Create( "DScrollPanel", PresetBase )
    RadioScroll:SetPos(5,50)
    RadioScroll:SetSize(PresetBase:GetWide() - 10, PresetBase:GetTall()-55)
    RadioScroll.VBar.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_hover )
    end
    RadioScroll.VBar.btnUp.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    RadioScroll.VBar.btnDown.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    RadioScroll.VBar.btnGrip.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_scrollbar )
	end
    
    local wide = table.Count(Radio.Settings.Preset)/4*30 > RadioScroll:GetTall() and 25 or 5
    
    local PresetList = vgui.Create( "DIconLayout", RadioScroll )
    PresetList:Dock( FILL )
    PresetList:SetSpaceY( 5 )
    PresetList:SetSpaceX( 5 )
    PresetList:SetSize(RadioScroll:GetWide() - wide, PresetBase:GetTall()/2 - 10)

    for name, url in pairs(Radio.Settings.Preset) do
        
        local ChangeMusic = PresetList:Add("DButton" )		
        ChangeMusic:SetPos( 0, 0 )
        ChangeMusic:SetText( name )
        ChangeMusic:SetToolTip(name)
        ChangeMusic:SetFont("Radio.Button")
        ChangeMusic:SetTextColor( color_white )
        ChangeMusic:SetSize( PresetList:GetWide()/4.1, 25 )
        ChangeMusic.Paint = function( self, w, h )
            draw.RoundedBox(0, 0, 0, w, h, colorbg_button)
        
            surface.SetDrawColor( colorline_button )
            surface.DrawOutlinedRect( 0, 0, w, h )
            
            if self:IsHovered() or self:IsDown() then
                draw.RoundedBox( 0, 0, 0, w, h, color_hover )
            end
        end
        ChangeMusic.DoClick = function()
			url = string.gsub(url, ":[:%d]+", "")
			url = string.Replace(url, " ", "")
			Radio.StartMusic(url, ent, name)
        end
    end
end