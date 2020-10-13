--[[ F4menu --------------------------------------------------------------------------------------

F4Menu made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
local colorline_frame = Color( 255, 255, 255, 100 )
local colorbg_frame = Color(0, 0, 0, 200)

local color_text = Color(255,255,255,255)

local PANEL = {}

function PANEL:Init()
    local ply = LocalPlayer()

    F4Menu.Init = self
    F4Menu.Init:Dock(FILL)
    F4Menu.Init:DockMargin(0, 0, 0, 0)
    F4Menu.Init.Paint = function( self, w, h )
    end

    F4Menu.Home = vgui.Create( "DPanel", F4Menu.Init )
    F4Menu.Home:SetSize( ScrW() - F4Menu.Model:GetWide() + 100, ScrH() - ScrH()/4-10 )
    F4Menu.Home:SetPos(0 ,0)
    F4Menu.Home.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, h, colorbg_frame)
        surface.SetDrawColor( colorline_frame )
        surface.DrawOutlinedRect( 0, 0, w , h )
    end

    F4Menu.Home_Content = vgui.Create("RichText", F4Menu.Home)
    F4Menu.Home_Content:SetPos(10, 10)
    F4Menu.Home_Content:SetSize(ScrW() - F4Menu.Model:GetWide() + 90, F4Menu.Home:GetTall()/2-150)
    F4Menu.Home_Content:AppendText(string.format(F4Menu.Settings.TexteHome, ply:GetName()))
    function F4Menu.Home_Content:PerformLayout()
        self:SetFontInternal( "F4Menu.Home.Text" )
        self:SetFGColor( color_text )
        self:SetVerticalScrollbarEnabled(false)
    end
end
vgui.Register("F4Menu_Tab_Home", PANEL, "DPanel")
