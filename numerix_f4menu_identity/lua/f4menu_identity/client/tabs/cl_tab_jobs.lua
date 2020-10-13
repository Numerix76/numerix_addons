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
local PosX
local leveltxt
function PANEL:Init()
    local ply = LocalPlayer()
    
    F4Menu.Init = self
    F4Menu.Init:Dock(FILL)
    F4Menu.Init:DockMargin(0, 0, 0, 0)
    F4Menu.Init.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, h, colorbg_frame)
    end

    F4Menu.JobScroll = vgui.Create( "DScrollPanel", F4Menu.Init ) 
    F4Menu.JobScroll:SetPos( 5, 5 )
    F4Menu.JobScroll:SetSize( ScrW() - F4Menu.Model:GetWide() + 95 , ScrH() - ScrH()/3.75 )
    F4Menu.JobScroll.VBar.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_hover )
    end
    F4Menu.JobScroll.VBar.btnUp.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    F4Menu.JobScroll.VBar.btnDown.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    F4Menu.JobScroll.VBar.btnGrip.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_scrollbar )
	end

    F4Menu.JobsList = vgui.Create( "DIconLayout", F4Menu.JobScroll )
    F4Menu.JobsList:SetPos( 5, 5 )
    F4Menu.JobsList:SetSize( ScrW() - F4Menu.Model:GetWide() + 95 , ScrH() - ScrH()/3.75 )
    F4Menu.JobsList:SetSpaceY( 10 ) 
    F4Menu.JobsList:SetSpaceX( 5 ) 
    F4Menu.JobsList:SetStretchHeight(true) 

    if F4Menu.Settings.ShowModel then
        PosX = 65
    else
        PosX = 5
    end

    for k, v in SortedPairsByMemberValue(DarkRP.getCategories()["jobs"], "sortOrder", false) do
        if table.Count(v.members) != 0 then
            local bgcolor = v.color
            local JobFrame = F4Menu.JobsList:Add( "DPanel" )
            JobFrame:SetSize( F4Menu.JobsList:GetWide(), 70 * (table.Count(v.members)) + 60 )
            JobFrame.Paint = function(self, w, h)
                draw.RoundedBox( 0, 0, 0, w -15, 30, bgcolor )
            end
            JobFrame.PaintOver = function( self, w, h )
                draw.SimpleText( v.name, "F4Menu.Jobs.Title", w/2, 15, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end

            local JobList = vgui.Create( "DIconLayout", JobFrame )
            JobList:SetWide( JobFrame:GetWide() )
            JobList:SetPos( 0, 50 )
            JobList:SetSpaceY( 10 )
            JobList:SetSpaceX( 5 ) 
            JobList:SetStretchHeight(true)

            for t, job in ipairs(v.members) do
                if !isnumber(job.sortOrder) then
                    job.sortOrder = 2000
                end
            end

            for t, job in SortedPairsByMemberValue(v.members, "sortOrder", false) do
                local canchange = true
                local id = F4Menu.GetTeamID(job.name)
                
                if (type(job.NeedToChangeFrom) == "number" and ply:Team() ~= job.NeedToChangeFrom) or (type(job.NeedToChangeFrom) == "table" and not table.HasValue(job.NeedToChangeFrom, ply:Team())) then
                    canchange = false
                end

                if job.customCheck and !job.customCheck(ply) then
                    canchange = false
                end

                if LevelSystemConfiguration and job.level and job.level > ply:getDarkRPVar("level") then
                    canchange = false
                end
                
                F4Menu.JobPanel = JobList:Add( "DPanel" )
                F4Menu.JobPanel:SetSize( JobList:GetWide(), 60 )
                F4Menu.JobPanel:SetToolTip(job.description)
                F4Menu.JobPanel.Paint = function( self, w, h )
                    draw.RoundedBox(0, 0, 0, w -15, h, F4Menu.Settings.BackPanelColor)
                    
                    if !canchange then
                        draw.RoundedBox(0, 0, 0, w -15, h, F4Menu.Settings.BackPanelNoAccessColor)
                    end

                    draw.SimpleText( string.upper(job.name), "F4Menu.Jobs.Text", PosX, 5, color_text )
                    draw.SimpleText( F4Menu.GetLanguage("Salary")..": "..GAMEMODE.Config.currency..""..string.upper(job.salary), "F4Menu.Jobs.Text", PosX, 22.5, color_text2 )    
                    
                    if LevelSystemConfiguration and job.level then
                        leveltxt = F4Menu.GetLanguage("Level")..": "..job.level
                    else
                        leveltxt = ""
                    end

                    if F4Menu.Settings.ShowSlot then
                        if job.max > 0 then
                            draw.SimpleText( team.NumPlayers(id).."/"..job.max.."   "..leveltxt , "F4Menu.Jobs.Text", PosX, 40, color_text2 )
                        else
                            draw.SimpleText( team.NumPlayers(id).."/∞   "..leveltxt, "F4Menu.Jobs.Text", PosX, 40, color_text2 )
                        end
                    else
                        if job.level then
                            draw.SimpleText( leveltxt, "F4Menu.Jobs.Text", PosX, 40, color_text2 )
                        end
                    end
            
                end
                F4Menu.JobPanel.OnCursorEntered = function( self )

                end
                F4Menu.JobPanel.OnCursorEntered = function( self )

                end

                if F4Menu.Settings.ShowModel then
                    local model 
                    if istable(job.model) then
                        model = table.Random(job.model)
                    else
                        model = job.model
                    end

                    F4Menu.ModelTeam = vgui.Create( "SpawnIcon" , F4Menu.JobPanel )
                    F4Menu.ModelTeam:SetPos(0,0)
                    F4Menu.ModelTeam:SetSize(F4Menu.JobPanel:GetTall(), F4Menu.JobPanel:GetTall())
                    F4Menu.ModelTeam:SetModel( model or "" )
                end
                
                if canchange then
                    F4Menu.JobButton = vgui.Create( "DButton", F4Menu.JobPanel )
                    F4Menu.JobButton:SetSize( 90, 35 )
                    F4Menu.JobButton:SetPos( F4Menu.JobPanel:GetWide()/1.15, (F4Menu.JobPanel:GetTall() / 2) - 17.5 )
                    F4Menu.JobButton:SetText( F4Menu.GetLanguage("Choose") )
                    F4Menu.JobButton:SetFont( "F4Menu.Jobs.Button" )
                    F4Menu.JobButton:SetTextColor( color_text )
                    F4Menu.JobButton.Paint = function( self, w, h )
                        draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

                        surface.SetDrawColor( colorline_button )
                        surface.DrawOutlinedRect( 0, 0, w, h )

                        if self:IsHovered() or self:IsDown() then
                            draw.RoundedBox( 0, 0, 0, w, h, color_hover )
                        end
                    end
                    F4Menu.JobButton.DoClick = function( self )
                        if istable(job.model) && table.Count(job.model) > 1 then 
                            F4Menu.OpenModelChoice(job) 
                        else
                            if job.vote then
                                if ((job.admin == 0 and ply:IsAdmin()) or (job.admin == 1 and ply:IsSuperAdmin())) then
                                    local menu = DermaMenu()
                                    menu:AddOption(F4Menu.GetLanguage("Make a vote"), function() RunCmd("/vote"..job.command) F4Menu:Launch() end)
                                    menu:AddOption(F4Menu.GetLanguage("Don't make a vote"), function() RunCmd("/"..job.command) F4Menu:Launch() end)
                                    menu:Open()
                                else
                                    RunCmd("/vote"..job.command)
                                    F4Menu:Launch()
                                end
                            else
                                RunCmd("/"..job.command)
                                F4Menu:Launch()
                            end
                        end
                    end
                end
            end
        end
    end
end
vgui.Register("F4Menu_Tab_Jobs", PANEL, "DPanel")


function F4Menu.GetTeamID(name)
    for k, v in ipairs(RPExtraTeams) do
        if v.name == name then
            return k
        end
    end
end