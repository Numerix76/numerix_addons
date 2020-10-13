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
local color_text2 = Color( 210, 210, 210 )

local PANEL = {}

function PANEL:Init()
    local ply = LocalPlayer()

	F4Menu.Init = self
    F4Menu.Init:Dock(FILL)
    F4Menu.Init:DockMargin(0, 0, 0, 0)
    F4Menu.Init.Paint = function( obj, w, h )
        draw.RoundedBox(0, 0, 0, w, h, colorbg_frame)
    end

    F4Menu.AmmoScroll = vgui.Create( "DScrollPanel", F4Menu.Init ) 
    F4Menu.AmmoScroll:SetPos( 5, 5 )
    F4Menu.AmmoScroll:SetSize( ScrW() - F4Menu.Model:GetWide() + 95 , ScrH() - ScrH()/3.75 )
    F4Menu.AmmoScroll.VBar.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_hover )
    end
    F4Menu.AmmoScroll.VBar.btnUp.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    F4Menu.AmmoScroll.VBar.btnDown.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    F4Menu.AmmoScroll.VBar.btnGrip.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_scrollbar )
	end
    F4Menu.AmmoScroll.Paint = function( self, w, h ) 
        draw.SimpleText( F4Menu.GetLanguage("Nothing available !"), "F4Menu.Weapons.Text", w / 2, h / 4, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    F4Menu.AmmoList = vgui.Create( "DIconLayout", F4Menu.AmmoScroll )
    F4Menu.AmmoList:SetPos( 5, 5 )
    F4Menu.AmmoList:SetSize( ScrW() - F4Menu.Model:GetWide() + 95 , ScrH() - ScrH()/3.75 )
    F4Menu.AmmoList:SetSpaceY( 10 ) 
    F4Menu.AmmoList:SetSpaceX( 5 ) 
    F4Menu.AmmoList:SetStretchHeight(true)
    
    for k, v in SortedPairsByMemberValue(DarkRP.getCategories()["ammo"], "sortOrder", false) do
        local ammonum = 0

        for _, ammo in ipairs (v.members) do
            if not ammo.customCheck or (ammo.customCheck and ammo.customCheck(ply)) then
                ammonum = ammonum + 1
            end

            if !isnumber(ammo.sortOrder) then
                ammo.sortOrder = 2000
            end
        end

        if ammonum != 0 then
            local bgcolor = v.color
            local AmmoFrame = F4Menu.AmmoList:Add( "DPanel" )
            AmmoFrame:SetSize( F4Menu.AmmoList:GetWide(), 70 * ammonum + 60)
            AmmoFrame.Paint = function(self, w, h)
                draw.RoundedBox( 0, 0, 0, w -15, 30, bgcolor )
            end
            AmmoFrame.PaintOver = function( self, w, h )
                draw.SimpleText( v.name, "F4Menu.Jobs.Title", w/2, 15, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end

            local AmmoList = vgui.Create( "DIconLayout", AmmoFrame )
            AmmoList:SetWide( AmmoFrame:GetWide() )
            AmmoList:SetPos( 0, 50 )
            AmmoList:SetSpaceY( 10 )
            AmmoList:SetSpaceX( 5 ) 
            AmmoList:SetStretchHeight(true)

            for _, ammo in SortedPairsByMemberValue(v.members, "sortOrder", false) do
                local canafford = true

                if not ammo.customCheck or (ammo.customCheck and ammo.customCheck(ply)) then
                    
                    if !ply:canAfford(ammo.price) then
                        canafford = false
                    end

                    if LevelSystemConfiguration and ammo.level and ammo.level > ply:getDarkRPVar("level") then
                        canafford = false
                    end

                    local AmmoPanel = AmmoList:Add( "Panel" )
                    AmmoPanel:SetSize( F4Menu.AmmoList:GetWide(), 60 )
                    AmmoPanel:SetText( "" )
                    AmmoPanel.Paint = function( self, w, h )
                        draw.RoundedBox(0, 0, 0, w -15, h, F4Menu.Settings.BackPanelColor)

                        if !canafford then
                            draw.RoundedBox(0, 0, 0, w -15, h, F4Menu.Settings.BackPanelNoAccessColor)
                        end
                        
                        draw.SimpleText( string.upper(ammo.name), "F4Menu.Jobs.Text", 60, 5, color_text )
                        draw.SimpleText( F4Menu.GetLanguage("Price")..": "..GAMEMODE.Config.currency..""..string.upper(ammo.price), "F4Menu.Jobs.Text", 60, 22.5, color_text2 )
                        if LevelSystemConfiguration and ammo.level then
                            draw.SimpleText( F4Menu.GetLanguage("Level")..": "..ammo.level, "F4Menu.Jobs.Text", 60, 40, color_text2 )
                        end
                    end
                        
                    local AmmoModel = vgui.Create( "SpawnIcon", AmmoPanel )
                    AmmoModel:SetSize( 52, 52 )
                    AmmoModel:SetPos( 1, 1 )
                    AmmoModel:SetModel(ammo.model)
                    AmmoModel:SetMouseInputEnabled(false)
                    AmmoModel.PaintOver = function() end
                    
                    if canafford then
                        local AmmoButton = vgui.Create( "DButton", AmmoPanel )
                        AmmoButton:SetSize( 90, 35 )
                        AmmoButton:SetPos( AmmoPanel:GetWide()/1.15, (AmmoPanel:GetTall() / 2) - 17.5 )
                        AmmoButton:SetText( F4Menu.GetLanguage("Buy") )
                        AmmoButton:SetFont( "F4Menu.Jobs.Button" )
                        AmmoButton:SetTextColor( color_text )
                        AmmoButton.Paint = function( self, w, h )
                            draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

                            surface.SetDrawColor( colorline_button )
                            surface.DrawOutlinedRect( 0, 0, w, h )

                            if self:IsHovered() or self:IsDown() then
                                draw.RoundedBox( 0, 0, 0, w, h, color_hover )
                            end
                        end
                        AmmoButton.DoClick = function()
                            RunEntCmd("buyammo "..ammo.ammoType)
                        end
                    end
                end
                F4Menu.AmmoScroll.Paint = function( self, w, h )
                end
            end
        end
    end    
end
vgui.Register("F4Menu_Tab_Ammo", PANEL, "DPanel")