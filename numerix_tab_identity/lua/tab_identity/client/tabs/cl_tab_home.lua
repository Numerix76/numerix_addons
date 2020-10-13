--[[ TAB --------------------------------------------------------------------------------------

TAB made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local colorline_button = Color( 255, 255, 255, 100 )
local colorbg_button = Color(33, 31, 35, 200)
local color_hover = Color(0, 0, 0, 100)

local color_button_scroll = Color( 255, 255, 255, 5)
local color_scrollbar = Color( 175, 175, 175, 150 )

local function SortedPairsByFunction(Table, Sorted, SortDown)
    local CopyTable = {}
    for k,v in pairs(Table) do
        table.insert(CopyTable, {NAME = tostring(v:Nick()), PLY = v})
    end
    table.SortByMember(CopyTable, "NAME", SortDown)

    local SortedTable = {}
    for k,v in ipairs(CopyTable) do
        if not IsValid(v.PLY) or not v.PLY[Sorted] then continue end
        local SortBy = (Sorted ~= "Team" and v.PLY[Sorted](v.PLY)) or team.GetName(v.PLY[Sorted](v.PLY))
        SortedTable[SortBy] = SortedTable[SortBy] or {}
        table.insert(SortedTable[SortBy], v.PLY)
    end

    local SecondSort = {}
    for k,v in SortedPairs(SortedTable, SortDown) do
        table.insert(SecondSort, v)
    end

    CopyTable = {}
    for k,v in pairs(SecondSort) do
        for a,b in pairs(v) do
            table.insert(CopyTable, b)
        end
    end

    return ipairs(CopyTable)
end

local PANEL = {}

function PANEL:Init()
    local ply = LocalPlayer()

    TAB.Init = self
    TAB.Init:Dock(FILL)
    TAB.Init:DockMargin(0, 0, 0, 0)
    TAB.Init.Paint = function( self, w, h )
    end

    local numbutton = 0
    for num, action in pairs(TAB.Settings.ActionPlayer) do
        if action.visible(ply) then
            numbutton = numbutton + 1
        end
    end

    TAB.SortName = vgui.Create( "DButton", TAB.Content )
    TAB.SortName:SetPos( 60, 0 )
    TAB.SortName:SetSize( 20, 20 )
    TAB.SortName:SetText(TAB.SortOrderAcs and "▲" or "▼")
    TAB.SortName:SetTextColor(color_white)
    TAB.SortName.DoClick = function(self)
        TAB.SortOrder = "Name"
        TAB.SortOrderAcs = !TAB.SortOrderAcs

        if IsValid( TAB.Content ) then
            TAB.Content:Remove()
            TAB.Content = vgui.Create("DPanelList", TAB.Menu)
            TAB.Content:SetSize(TAB.Menu:GetWide()/1.02, TAB.Menu:GetTall()-130)
            TAB.Content:SetPos(TAB.Menu:GetWide()/100,100)
            TAB.Content.Paint = function(self, w, h) end
        end

        vgui.Create("TAB_Tab_Home", TAB.Content)
    end
    TAB.SortName.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end	
    end

    if TAB.Settings.ShowJobULX != "" then
        local posx
        
        if TAB.Content:GetWide()-100-numbutton*50 > TAB.Content:GetWide()/2 then
            posx = TAB.Content:GetWide()/2
        else
            posx = TAB.Content:GetWide()-240-numbutton*50
        end

        TAB.SortTeam = vgui.Create( "DButton", TAB.Content )
        TAB.SortTeam:SetPos( posx, 0 )
        TAB.SortTeam:SetSize( 20, 20 )
        TAB.SortTeam:SetText(TAB.SortOrderAcs and "▲" or "▼")
        TAB.SortTeam:SetTextColor(color_white)
        TAB.SortTeam.DoClick = function(self)
            TAB.SortOrder = "Team"
            TAB.SortOrderAcs = !TAB.SortOrderAcs

            if IsValid( TAB.Content ) then
                TAB.Content:Remove()
                TAB.Content = vgui.Create("DPanelList", TAB.Menu)
                TAB.Content:SetSize(TAB.Menu:GetWide()/1.02, TAB.Menu:GetTall()-130)
                TAB.Content:SetPos(TAB.Menu:GetWide()/100,100)
                TAB.Content.Paint = function(self, w, h) end
            end

            vgui.Create("TAB_Tab_Home", TAB.Content)
        end
        TAB.SortTeam.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

            surface.SetDrawColor( colorline_button )
            surface.DrawOutlinedRect( 0, 0, w, h )

            if self:IsHovered() or self:IsDown() then
                draw.RoundedBox( 0, 0, 0, w, h, color_hover )
            end
        end
    end

    TAB.PlayersScroll = vgui.Create( "DScrollPanel", TAB.Init ) 
    TAB.PlayersScroll:SetPos( 0, 25 )
    TAB.PlayersScroll:SetSize( TAB.Content:GetWide() , TAB.Content:GetTall()-25 )
    TAB.PlayersScroll.VBar.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_hover )
    end
    TAB.PlayersScroll.VBar.btnUp.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    TAB.PlayersScroll.VBar.btnDown.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    TAB.PlayersScroll.VBar.btnGrip.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_scrollbar )
    end

    TAB.PlayersList = vgui.Create( "DIconLayout", TAB.PlayersScroll )
    TAB.PlayersList:SetPos( 0, 0 )
    TAB.PlayersList:SetSize( TAB.Content:GetWide() , TAB.Content:GetTall()-25 )
    TAB.PlayersList:SetSpaceY( 10 ) 
    TAB.PlayersList:SetSpaceX( 5 ) 
    TAB.PlayersList:SetStretchHeight(true)

    for _, victim in SortedPairsByFunction(player.GetAll(), TAB.SortOrder or "Team", TAB.SortOrderAcs) do
        
        TAB.PanelPlayer = DarkRP and TAB.Settings.PlayerTab and TAB.PlayersList:Add( "DButton" ) or TAB.PlayersList:Add( "DPanel" )
        TAB.PanelPlayer:SetPos( 10, 30 )
        TAB.PanelPlayer:SetSize( TAB.Content:GetWide(), 50 )
        TAB.PanelPlayer:SetText("")
        TAB.PanelPlayer.Paint = function(self, w, h)
            if victim:IsValid() then
                local teamcolor = team.GetColor(victim:Team())
                draw.RoundedBox(0, 0, 0, w, h, TAB.Settings.UseColorTeamBG and Color(teamcolor.r, teamcolor.g, teamcolor.b, 200) or colorbg_button)

                if TAB.Settings.Staff[victim:GetUserGroup()] and TAB.Settings.ShowJobULXAdmin != "" or TAB.Settings.ShowJobULX != "" then
                    local usergroup = victim:GetUserGroup()
                    local name = victim:Name()
                    local teamname = DarkRP and victim:getDarkRPVar("job") or team.GetName( victim:Team() )
                    local infostaff = TAB.Settings.ShowJobULXAdmin == "job" and teamname or TAB.Settings.ShowJobULXAdmin == "rank" and (TAB.Settings.RankName[usergroup] or usergroup) or TAB.Settings.ShowJobULXAdmin == "job+rank" and teamname.." ("..(TAB.Settings.RankName[usergroup] or usergroup)..")" or teamname
                    local infouser = TAB.Settings.ShowJobULX == "job" and teamname or TAB.Settings.ShowJobULX == "rank" and (TAB.Settings.RankName[usergroup] or usergroup) or TAB.Settings.ShowJobULX == "job+rank" and teamname.." ("..(TAB.Settings.RankName[usergroup] or usergroup)..")" or teamname
                    local info = TAB.Settings.Staff[victim:GetUserGroup()] and infostaff or infouser
                    local color = TAB.Settings.ColorJob and teamcolor or color_white


                    surface.SetFont("TAB.Player.Name")
                    local endposinfo = TAB.PanelPlayer:GetWide()/2 + surface.GetTextSize(info)/2
                    local endposbutton = TAB.PanelPlayer:GetWide()-140-numbutton*50

                    local totalsizeinfo = TAB.PanelPlayer:GetWide()-140-numbutton*50 - 100 - surface.GetTextSize(info)
                    
                    if endposinfo < endposbutton then
                        draw.SimpleText(info, "TAB.Player.Name", w/2, h/2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                        local width, _ = surface.GetTextSize(name)
                        if( width > totalsizeinfo + 10 ) then

                            for i = string.len( name ), 1, -1 do
        
                                width, _ = surface.GetTextSize( string.sub( name, 1, i ) );
                                if( width <= totalsizeinfo - 10 ) then

                                    draw.SimpleText(string.sub( name, 1, i ) .. "...", "TAB.Player.Name", 60, h/2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                                    break;
        
                                end
        
                            end
        
                        else
                            draw.SimpleText(name, "TAB.Player.Name", 60, h/2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        end

                    else
                        local posx = TAB.PanelPlayer:GetWide()-140-numbutton*50
                        local widthinfo, _ = surface.GetTextSize(info)
                        local width, _ = surface.GetTextSize(name)

                        if( posx - widthinfo - 50 < 0 ) then
                            
                            for i = string.len( name ), 1, -1 do
        
                                width, _ = surface.GetTextSize( string.sub( name, 1, i ) );

                                if( width <= TAB.PanelPlayer:GetWide()-140-numbutton*50-50) then

                                    draw.SimpleText(string.sub( name, 1, i ) .. "...", "TAB.Player.Name", 60, h/2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                                    break;
        
                                end
        
                            end
                        elseif( width > totalsizeinfo + 10 ) then
                            for i = string.len( name ), 1, -1 do
        
                                width, _ = surface.GetTextSize( string.sub( name, 1, i ) );
                                if( width <= totalsizeinfo - 10 ) then

                                    draw.SimpleText(string.sub( name, 1, i ) .. "...", "TAB.Player.Name", 60, h/2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                                    break;
        
                                end
        
                            end

                            draw.SimpleText(info, "TAB.Player.Name", posx, h/2, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        
                        else
                            draw.SimpleText(name, "TAB.Player.Name", 60, h/2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                            draw.SimpleText(info, "TAB.Player.Name", posx, h/2, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                        end
                    end
                else
                    local name = victim:Name()
                    draw.SimpleText(name, "TAB.Player.Name", 60, h/2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end

                local pingcolor
                local playerping = victim:Ping()

                if playerping < TAB.Settings.PingGood then
                    pingcolor = color_green
                elseif playerping < TAB.Settings.PingMedium then
                    pingcolor = color_orange
                else
                    pingcolor = color_red
                end
                draw.SimpleText(playerping..' ms', "TAB.Player.Name", w-50, h/2, pingcolor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            else
                draw.SimpleText(TAB.GetLanguage("Disconnected"), "TAB.Player.Name", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
        if DarkRP then
            TAB.PanelPlayer.DoClick = function(self)
                if IsValid( TAB.Content ) then
                    TAB.Content:Remove()
                    TAB.Content = vgui.Create("DPanelList", TAB.Menu)
                    TAB.Content:SetSize(TAB.Menu:GetWide()/1.02, TAB.Menu:GetTall()-130)
                    TAB.Content:SetPos(TAB.Menu:GetWide()/100,100)
                    TAB.Content.Paint = function(self, w, h) end
                end
                TAB.SelectedPlayer = victim
                vgui.Create("TAB_Tab_Player", TAB.Content)
                TAB.Setting:SetToolTip(TAB.GetLanguage("Players List"))
            end
        end

        TAB.PlayerLogo = vgui.Create( "AvatarImage", TAB.PanelPlayer )
		TAB.PlayerLogo:SetSize( TAB.PanelPlayer:GetTall(), TAB.PanelPlayer:GetTall() )
		TAB.PlayerLogo:SetPos( 0, 0 )
        TAB.PlayerLogo:SetPlayer( victim, 128 )
        
        local actionvisible = 1
        for num, action in pairs(TAB.Settings.ActionPlayer) do
            if action.visible(ply) and victim:IsValid() then
                local iconstring, iconname = action.icon(ply, victim)
                local icon = Material(iconstring)

                if string.sub(iconstring, 1, 4) == "http" then
					TAB.GetImage(iconstring, iconname, function(url, filename)
						icon = Material( filename )
					end)
				end

                TAB.ActionPlayerButton = vgui.Create( "DButton", TAB.PanelPlayer )
                TAB.ActionPlayerButton:SetText( "" )			
                TAB.ActionPlayerButton:SetPos( TAB.PanelPlayer:GetWide()-100-actionvisible*50, TAB.PanelPlayer:GetTall()/2-32/2 )				
                TAB.ActionPlayerButton:SetSize( 40, 40 )	
                TAB.ActionPlayerButton:SetToolTip(action.text)	
                TAB.ActionPlayerButton.Paint = function(self, w, h)	
                    if victim:IsValid() then
                        surface.SetMaterial( icon )
                        surface.SetDrawColor( color_white )
                        surface.DrawTexturedRect( 0, 0, 32, 32 )
                    end
                end
                TAB.ActionPlayerButton.DoClick = function()
                    if victim:IsValid() then
                        action.func(ply, victim)
                        timer.Simple(0.1, function()
                            iconstring, iconname = action.icon(ply, victim)
                            icon = Material(iconstring)

                            if string.sub(iconstring, 1, 4) == "http" then
                                TAB.GetImage(iconstring, iconname, function(url, filename)
                                    icon = Material( filename )
                                end)
                            end
                        end)
                    end
                end
                actionvisible = actionvisible + 1
            end
        end
    end
end
vgui.Register("TAB_Tab_Home", PANEL, "DPanel")