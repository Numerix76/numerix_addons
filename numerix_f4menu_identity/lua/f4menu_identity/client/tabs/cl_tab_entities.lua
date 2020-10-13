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

    F4Menu.EntScroll = vgui.Create( "DScrollPanel", F4Menu.Init ) 
    F4Menu.EntScroll:SetPos( 5, 5 )
    F4Menu.EntScroll:SetSize( ScrW() - F4Menu.Model:GetWide() + 95 , ScrH() - ScrH()/3.75 )
    F4Menu.EntScroll.VBar.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_hover )
    end
    F4Menu.EntScroll.VBar.btnUp.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    F4Menu.EntScroll.VBar.btnDown.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    F4Menu.EntScroll.VBar.btnGrip.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_scrollbar )
	end
    F4Menu.EntScroll.Paint = function( self, w, h )
        draw.SimpleText( F4Menu.GetLanguage("Nothing available !"), "F4Menu.Weapons.Text", w / 2, h / 4,  color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    F4Menu.EntList = vgui.Create( "DIconLayout", F4Menu.EntScroll )
    F4Menu.EntList:SetPos( 5, 5 )
    F4Menu.EntList:SetSize( ScrW() - F4Menu.Model:GetWide() + 95 , ScrH() - ScrH()/3.75 )
    F4Menu.EntList:SetSpaceY( 10 ) 
    F4Menu.EntList:SetSpaceX( 5 ) 
    F4Menu.EntList:SetStretchHeight(true) 

    for k, v in SortedPairsByMemberValue(DarkRP.getCategories()["entities"], "sortOrder", false) do
        local entnum = 0

        for _, ent in ipairs(v.members) do
            if not ent.allowed or (type(ent.allowed) == "table" and table.HasValue(ent.allowed, ply:Team())) and (not ent.customCheck or (ent.customCheck and ent.customCheck(ply))) then
                entnum = entnum + 1
            end

            if !isnumber(ent.sortOrder) then
                ent.sortOrder = 2000
            end
        end

        if entnum != 0 then    
            local bgcolor = v.color
            local EntFrame = F4Menu.EntList:Add( "DPanel" )
            EntFrame:SetSize( F4Menu.EntList:GetWide(), 70 * entnum + 60)
            EntFrame.Paint = function(self, w, h)
                draw.RoundedBox( 0, 0, 0, w -15, 30, bgcolor )
            end
            EntFrame.PaintOver = function( self, w, h )
                draw.SimpleText( v.name, "F4Menu.Jobs.Title", w/2, 15, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end

            local EntList = vgui.Create( "DIconLayout", EntFrame )
            EntList:SetWide( EntFrame:GetWide() )
            EntList:SetPos( 0, 50 )
            EntList:SetSpaceY( 10 )
            EntList:SetSpaceX( 5 ) 
            EntList:SetStretchHeight(true)

            for _, ent in SortedPairsByMemberValue(v.members, "sortOrder", false) do
                local canafford = true
                if not ent.allowed or (type(ent.allowed) == "table" and table.HasValue(ent.allowed, ply:Team())) and (not ent.customCheck or (ent.customCheck and ent.customCheck(ply))) then

                    if !ply:canAfford(ent.price) then
                        canafford = false
                    end

                    if LevelSystemConfiguration and ent.level and ent.level > ply:getDarkRPVar("level") then
                        canafford = false
                    end

                    local EntPanel = EntList:Add( "DPanel" )
                    EntPanel:SetSize( F4Menu.EntList:GetWide(), 60 )
                    EntPanel.Paint = function( self, w, h )
                        
                        draw.RoundedBox(0, 0, 0, w -15, h, F4Menu.Settings.BackPanelColor)

                        if !canafford then
                            draw.RoundedBox(0, 0, 0, w -15, h, F4Menu.Settings.BackPanelNoAccessColor)
                        end
                            
                        draw.SimpleText( string.upper(ent.name), "F4Menu.Jobs.Text", 60, 5, color_text )
                        draw.SimpleText( F4Menu.GetLanguage("Price")..": "..GAMEMODE.Config.currency..""..string.upper(ent.price), "F4Menu.Jobs.Text", 60, 22.5, color_text2 )
                        if LevelSystemConfiguration and ent.level then
                            draw.SimpleText( F4Menu.GetLanguage("Level")..": "..ent.level, "F4Menu.Jobs.Text", 60, 40, color_text2 )
                        end
                    end

                    if canafford then
                        local entButton = vgui.Create( "DButton", EntPanel )
                        entButton:SetSize( 90, 35 )
                        entButton:SetPos( EntPanel:GetWide()/1.15, (EntPanel:GetTall() / 2) - 17.5 )
                        entButton:SetText( F4Menu.GetLanguage("Buy") )
                        entButton:SetFont( "F4Menu.Jobs.Button" )
                        entButton:SetTextColor( color_text )
                        entButton.Paint = function( self, w, h )
                            draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

                            surface.SetDrawColor( colorline_button )
                            surface.DrawOutlinedRect( 0, 0, w, h )

                            if self:IsHovered() or self:IsDown() then
                                draw.RoundedBox( 0, 0, 0, w, h, color_hover )
                            end
                        end
                        entButton.DoClick = function()
                            RunEntCmd(ent.cmd)
                        end
                    end 
                        
                    local entModel = vgui.Create( "SpawnIcon", EntPanel )
                    entModel:SetSize( 52, 52 )
                    entModel:SetPos( 0, 4 )
                    entModel:SetModel( ent.model )

                    F4Menu.EntScroll.Paint = function( self, w, h )
                    end
                end
            end
        end
    end
end
vgui.Register("F4Menu_Tab_Entities", PANEL, "DPanel")
