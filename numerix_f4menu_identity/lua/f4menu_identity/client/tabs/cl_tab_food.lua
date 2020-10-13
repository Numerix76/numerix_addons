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

    F4Menu.FoodScroll = vgui.Create( "DScrollPanel", F4Menu.Init ) 
    F4Menu.FoodScroll:SetPos( 5, 5 )
    F4Menu.FoodScroll:SetSize( ScrW() - F4Menu.Model:GetWide() + 95 , ScrH() - ScrH()/3.75 )
    F4Menu.FoodScroll.VBar.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_hover )
    end
    F4Menu.FoodScroll.VBar.btnUp.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    F4Menu.FoodScroll.VBar.btnDown.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    F4Menu.FoodScroll.VBar.btnGrip.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_scrollbar )
	end
    F4Menu.FoodScroll.Paint = function( self, w, h )
        draw.SimpleText( F4Menu.GetLanguage("Nothing available !"), "F4Menu.Weapons.Text", w / 2, h / 4, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    F4Menu.FoodList = vgui.Create( "DIconLayout", F4Menu.FoodScroll )
    F4Menu.FoodList:SetPos( 5, 5 )
    F4Menu.FoodList:SetSize( ScrW() - F4Menu.Model:GetWide() + 95 , ScrH() - ScrH()/3.75 )
    F4Menu.FoodList:SetSpaceY( 10 ) 
    F4Menu.FoodList:SetSpaceX( 5 ) 
    F4Menu.FoodList:SetStretchHeight(true)
    
    if !DarkRP.disabledDefaults["modules"]["hungermod"] then
        for k, food in ipairs( FoodItems ) do
            if !isnumber(food.sortOrder) then
                food.sortOrder = 2000
            end
        end

        for k, food in SortedPairsByMemberValue(FoodItems, "sortOrder", false) do
            local canbuy = true

            if (food.requiresCook == nil or food.requiresCook == true) and not ply:isCook() then canbuy = false end
            if food.customCheck and not food.customCheck(ply) then canbuy = false  end
            
            if canbuy then
                local FoodPanel = F4Menu.FoodList:Add( "DPanel" )
                FoodPanel:SetSize( F4Menu.FoodList:GetWide(), 60 )
                FoodPanel.Paint = function( self, w, h )
                draw.RoundedBox(0, 0, 0, w -15, h, F4Menu.Settings.BackPanelColor)
                    
                    if !ply:canAfford(food.price) then
                        draw.RoundedBox(0, 0, 0, w -15, h, F4Menu.Settings.BackPanelNoAccessColor)
                    end
                        
                    draw.SimpleText( string.upper(food.name), "F4Menu.Jobs.Text", 60, 14, color_text )
                    draw.SimpleText( F4Menu.GetLanguage("Price")..": "..GAMEMODE.Config.currency..""..string.upper(food.price), "F4Menu.Jobs.Text", 60, 30, color_text2 )
                end
                
                if ply:canAfford(food.price) then
                    local foodButton = vgui.Create( "DButton", FoodPanel )
                    foodButton:SetSize( 90, 35 )
                    foodButton:SetPos( FoodPanel:GetWide()/1.15, (FoodPanel:GetTall() / 2) - 17.5 )
                    foodButton:SetText( F4Menu.GetLanguage("Buy") )
                    foodButton:SetFont( "F4Menu.Jobs.Text" )
                    foodButton:SetTextColor( color_text )
                    foodButton.Paint = function( self, w, h )
                        draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

                        surface.SetDrawColor( colorline_button )
                        surface.DrawOutlinedRect( 0, 0, w, h )

                        if self:IsHovered() or self:IsDown() then
                            draw.RoundedBox( 0, 0, 0, w, h, color_hover)
                        end
                    end
                    foodButton.DoClick = function()
                        RunConsoleCommand( "say", "/buyfood "..food.name )
                    end
                end
                    
                local foodModel = vgui.Create( "SpawnIcon", FoodPanel )
                foodModel:SetSize( 52, 52 )
                foodModel:SetPos( 0, 0 )
                foodModel:SetModel( food.model )
                
                F4Menu.FoodScroll.Paint = function( self, w, h )
                end
            end
        end 
    end
end
vgui.Register("F4Menu_Tab_Food", PANEL, "DPanel")