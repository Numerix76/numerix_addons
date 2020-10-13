--[[ F4menu --------------------------------------------------------------------------------------

F4Menu made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
local colorline_frame = Color( 255, 255, 255, 100 )
local colorbg_frame = Color(0, 0, 0, 200)

local colorline_button = Color( 255, 255, 255, 100 )
local colorbg_button = Color(33, 31, 35, 200)
local color_hover = Color(0, 0, 0, 100)

local color_button_scroll = Color( 255, 255, 255, 5)
local color_scrollbar = Color( 175, 175, 175, 150 )

local color_text = Color(255,255,255,255)

local PANEL = {}

function PANEL:Init()
    local ply = LocalPlayer()

	F4Menu.Init = self
    F4Menu.Init:Dock(FILL)
    F4Menu.Init:DockMargin(0, 0, 0, 0)
    F4Menu.Init.Paint = function( obj, w, h )
        draw.RoundedBox(0, 0, 0, w, h, colorbg_frame)
    end

    F4Menu.CommandScroll = vgui.Create( "DScrollPanel", F4Menu.Init ) 
    F4Menu.CommandScroll:SetPos( 5, 5 )
    F4Menu.CommandScroll:SetSize( ScrW() - F4Menu.Model:GetWide() + 95 , ScrH() - ScrH()/3.75 )
    F4Menu.CommandScroll.VBar.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_hover )
    end
    F4Menu.CommandScroll.VBar.btnUp.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    F4Menu.CommandScroll.VBar.btnDown.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    F4Menu.CommandScroll.VBar.btnGrip.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_scrollbar )
	end

    F4Menu.CommandList = vgui.Create( "DIconLayout", F4Menu.CommandScroll )
    F4Menu.CommandList:SetPos( 5, 5 )
    F4Menu.CommandList:SetSize( ScrW() - F4Menu.Model:GetWide() + 95 , ScrH() - ScrH()/3.75 )
    F4Menu.CommandList:SetSpaceY( 20 ) 
    F4Menu.CommandList:SetSpaceX( 5 ) 
    F4Menu.CommandList:SetStretchHeight(true) 

    for name, v in SortedPairs( F4Menu.Settings.Commandes ) do
        if v.visible(ply) then
            local bgcolor = v.colorhead
            local CommandFrame = F4Menu.CommandList:Add( "DPanel" )
            CommandFrame:SetSize( F4Menu.CommandList:GetWide(), 40 * (table.Count(v.action))+40)
            CommandFrame.Paint = function(self, w, h)
                draw.RoundedBox( 0, 0, 0, w -15, 30, bgcolor )
            end
            CommandFrame.PaintOver = function( self, w, h )
                draw.SimpleText( name, "F4Menu.Commande.Title", w/2, 15, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end
            
            local ActionList = vgui.Create( "DIconLayout", CommandFrame )
            ActionList:SetWide( CommandFrame:GetWide() )
            ActionList:SetPos( 0, 50 )
            ActionList:SetSpaceY( 5 )
            ActionList:SetSpaceX( 5 ) 
            ActionList:SetStretchHeight(true)
            
            for info, func in SortedPairs( v.action, true ) do
                local CommandButton = ActionList:Add( "DButton" )
                CommandButton:SetSize( F4Menu.CommandList:GetWide(), 35 )
                CommandButton:SetPos( 0, 0 )
                CommandButton:SetText( info )
                CommandButton:SetFont( "F4Menu.Commande.Text" )
                CommandButton:SetTextColor( color_text )
                CommandButton.Paint = function( self, w, h )
                    draw.RoundedBox( 0, 0, 0, w -15, self:GetTall(), F4Menu.Settings.BackPanelColor )
                end
                CommandButton.DoClick = function()
                    func()
                end
            end
        end
    end
end
vgui.Register("F4Menu_Tab_Commands", PANEL, "DPanel")
