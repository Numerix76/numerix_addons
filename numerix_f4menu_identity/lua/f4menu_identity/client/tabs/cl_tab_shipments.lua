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
local leveltxt
function PANEL:Init()

    local ply = LocalPlayer()

	F4Menu.Init = self
    F4Menu.Init:Dock(FILL)
    F4Menu.Init:DockMargin(0, 0, 0, 0)
    F4Menu.Init.Paint = function( obj, w, h )
        draw.RoundedBox(0, 0, 0, w, h, colorbg_frame)
    end

    F4Menu.ShipmentScroll = vgui.Create( "DScrollPanel", F4Menu.Init ) 
    F4Menu.ShipmentScroll:SetPos( 5, 5 )
    F4Menu.ShipmentScroll:SetSize( ScrW() - F4Menu.Model:GetWide() + 95 , ScrH() - ScrH()/3.75 )
    F4Menu.ShipmentScroll.VBar.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_hover )
    end
    F4Menu.ShipmentScroll.VBar.btnUp.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    F4Menu.ShipmentScroll.VBar.btnDown.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    F4Menu.ShipmentScroll.VBar.btnGrip.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_scrollbar )
	end
    F4Menu.ShipmentScroll.Paint = function( self, w, h ) 
        draw.SimpleText( F4Menu.GetLanguage("Nothing available !"), "F4Menu.Weapons.Text", w / 2, h / 4, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    F4Menu.ShipmentsList = vgui.Create( "DIconLayout", F4Menu.ShipmentScroll )
    F4Menu.ShipmentsList:SetPos( 5, 5 )
    F4Menu.ShipmentsList:SetSize( ScrW() - F4Menu.Model:GetWide() + 95 , ScrH() - ScrH()/3.75 )
    F4Menu.ShipmentsList:SetSpaceY( 10 ) 
    F4Menu.ShipmentsList:SetSpaceX( 5 ) 
    F4Menu.ShipmentsList:SetStretchHeight(true)
    
    for k, v in SortedPairsByMemberValue(DarkRP.getCategories()["shipments"], "sortOrder", false) do
        local weponnum = 0
        
        for _, weapon in ipairs(v.members) do
            if !weapon.noship and table.HasValue(weapon.allowed, ply:Team()) and (not weapon.customCheck or (weapon.customCheck and v.customCheck(ply))) then
                weponnum = weponnum + 1
            end

            if !isnumber(weapon.sortOrder) then
                weapon.sortOrder = 2000
            end
        end

        if weponnum != 0 then
            local bgcolor = v.color
            local WeaponFrame = F4Menu.ShipmentsList:Add( "DPanel" )
            WeaponFrame:SetSize( F4Menu.ShipmentsList:GetWide(), 70 * weponnum + 60)
            WeaponFrame.Paint = function(self, w, h)
                draw.RoundedBox( 0, 0, 0, w -15, 30, bgcolor )
            end
            WeaponFrame.PaintOver = function( self, w, h )
                draw.SimpleText( v.name, "F4Menu.Jobs.Title", w/2, 15, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end

            local WeaponsList = vgui.Create( "DIconLayout", WeaponFrame )
            WeaponsList:SetWide( WeaponFrame:GetWide() )
            WeaponsList:SetPos( 0, 50 )
            WeaponsList:SetSpaceY( 10 )
            WeaponsList:SetSpaceX( 5 ) 
            WeaponsList:SetStretchHeight(true)

            for _, weapon in SortedPairsByMemberValue(v.members, "sortOrder", false) do
                local canafford = true

                if !weapon.noship and table.HasValue(weapon.allowed, ply:Team()) and (not weapon.customCheck or (weapon.customCheck and weapon.customCheck(ply))) then
                    
                    if !ply:canAfford(weapon.price) then
                        canafford = false
                    end

                    if LevelSystemConfiguration and weapon.level and weapon.level > ply:getDarkRPVar("level") then
                        canafford = false
                    end

                    local WeaponPanel = WeaponsList:Add( "Panel" )
                    WeaponPanel:SetSize( F4Menu.ShipmentsList:GetWide(), 60 )
                    WeaponPanel:SetText( "" )
                    WeaponPanel.Paint = function( self, w, h )
                        
                        draw.RoundedBox(0, 0, 0, w -15, h, F4Menu.Settings.BackPanelColor)

                        if !canafford then
                            draw.RoundedBox(0, 0, 0, w -15, h, F4Menu.Settings.BackPanelNoAccessColor)
                        end
                        
                        draw.SimpleText( string.upper(weapon.name), "F4Menu.Jobs.Text", 60, 5, color_text )
                        draw.SimpleText( F4Menu.GetLanguage("Price")..": "..GAMEMODE.Config.currency..""..string.upper(weapon.price), "F4Menu.Jobs.Text", 60, 22.5, color_text2 )

                        if LevelSystemConfiguration and weapon.level then
                            draw.SimpleText( F4Menu.GetLanguage("Level")..": "..weapon.level, "F4Menu.Jobs.Text", 60, 40, color_text2 )
                        end
                    end
                        
                    local WeaponModel = vgui.Create( "SpawnIcon", WeaponPanel )
                    WeaponModel:SetSize( 52, 52 )
                    WeaponModel:SetPos( 1, 1 )
                    WeaponModel:SetModel(weapon.model)
                    WeaponModel:SetMouseInputEnabled(false)
                    WeaponModel.PaintOver = function() end
                    
                    if canafford then
                        local WeaponButton = vgui.Create( "DButton", WeaponPanel )
                        WeaponButton:SetSize( 90, 35 )
                        WeaponButton:SetPos( WeaponPanel:GetWide()/1.15, (WeaponPanel:GetTall() / 2) - 17.5 )
                        WeaponButton:SetText( F4Menu.GetLanguage("Buy") )
                        WeaponButton:SetFont( "F4Menu.Jobs.Button" )
                        WeaponButton:SetTextColor( color_text )
                        WeaponButton.Paint = function( self, w, h )
                            draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

                            surface.SetDrawColor( colorline_button )
                            surface.DrawOutlinedRect( 0, 0, w, h )

                            if self:IsHovered() or self:IsDown() then
                                draw.RoundedBox( 0, 0, 0, w, h, color_hover )
                            end

                            WeaponButton.OnCursorEntered = function(self)
                                self.hover = true
                            end
                            WeaponButton.OnCursorExited = function(self)
                                self.hover = false
                            end
                        end
                        WeaponButton.DoClick = function()
                            RunEntCmd("buyshipment "..weapon.name)
                        end
                    end
                end
                F4Menu.ShipmentScroll.Paint = function( self, w, h )
                end
            end
        end
    end    
end
vgui.Register("F4Menu_Tab_Shipments", PANEL, "DPanel")