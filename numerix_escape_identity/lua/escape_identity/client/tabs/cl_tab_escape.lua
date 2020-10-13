--[[ Escape --------------------------------------------------------------------------------------

Escape made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
local colorline_frame = Color( 255, 255, 255, 100 )
local colorbg_frame = Color(0, 0, 0, 200)

local color_text = Color(255,255,255,255)
local PANEL = {}

function PANEL:Init()

    local ply = LocalPlayer()

    Echap.Init = self
    Echap.Init:Dock(FILL)
    Echap.Init:DockMargin(0, 0, 0, 0)
    Echap.Init.Paint = function( self, w, h )
    end

    Echap.Home = vgui.Create( "DPanel",Echap.Init )
    Echap.Home:SetSize( ScrW() - Echap.Model:GetWide() + 100, ScrH() - ScrH()/4-10 )
    Echap.Home:SetPos(0 ,0)
    Echap.Home.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, h, colorbg_frame)
        surface.SetDrawColor( colorline_frame )
        surface.DrawOutlinedRect( 0, 0, w , h )
    end

    Echap.Home_Content = vgui.Create("RichText", Echap.Home)
    Echap.Home_Content:SetPos(10, 10)
    Echap.Home_Content:SetSize(ScrW() - Echap.Model:GetWide() + 90, Echap.Home:GetTall()-50)
    Echap.Home_Content:AppendText(string.format(Echap.Settings.TexteHome, ply:GetName()))
    function Echap.Home_Content:PerformLayout()
        self:SetFontInternal( "Echap.Home.Text" )
        self:SetFGColor( color_text )
        self:SetVerticalScrollbarEnabled(false)
    end
end
vgui.Register("Echap_Tab_Escape", PANEL, "DPanel")