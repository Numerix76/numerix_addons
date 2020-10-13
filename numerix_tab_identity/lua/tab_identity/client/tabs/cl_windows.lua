--[[ TAB --------------------------------------------------------------------------------------

TAB made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
local colorbg_baseframe = Color(0,0,0,200)

local colorline_frame = Color( 255, 255, 255, 100 )
local colorbg_frame = Color(52, 55, 64, 100)

local colorline_button = Color( 255, 255, 255, 100 )
local colorbg_button = Color(33, 31, 35, 200)
local color_hover = Color(0, 0, 0, 100)

local color_text = Color(255,255,255,255)

function TAB.OpenKickDialog(victim)
	local ply = LocalPlayer()

	local BasePanel = vgui.Create( "DFrame" )
	BasePanel:SetSize( ScrW(), ScrH() )
	BasePanel:SetTitle( "" )
	BasePanel:ShowCloseButton( false )
	BasePanel:SetDraggable( false )
	BasePanel.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, colorbg_baseframe )
	end
	BasePanel:MakePopup()

	local frame = vgui.Create( "DFrame", BasePanel )
	frame:SetSize( 400, 200 )
	frame:SetPos( -500, ScrH() / 2 - 100 )
	frame:SetTitle( "" )
	frame:ShowCloseButton( false )
	frame.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, colorbg_frame )
		surface.SetDrawColor( colorline_frame )
        surface.DrawOutlinedRect( 0, 0, w , h )
	end
	frame:MoveTo( ScrW() / 2 - 200, ScrH() / 2 - 100, 0.5, 0, 0.05 )
			
	local Text = vgui.Create( "DLabel", frame )
	Text:SetPos( 0, 15 )
	Text:SetText( TAB.GetLanguage("Enter a reason") )
	Text:SetTextColor(color_text)
	Text:SetSize(400, 20)
	Text:SetContentAlignment(5)

	local TextEntry = vgui.Create( "DTextEntry", frame )
	TextEntry:SetPos( 25, 50 )
	TextEntry:SetSize( 350, 40 )
	TextEntry:SetText( TAB.GetLanguage("Reason") )
			
	local Valider = vgui.Create( "DButton",frame )
	Valider:SetPos( 6, 120 )
	Valider:SetText( TAB.GetLanguage("Validate") )
	Valider:SetTextColor(color_text)
	Valider:SetSize( 388, 30 )
	Valider.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end	
	end
	Valider.DoClick = function()
		ply:ConCommand('ulx kick "'..victim..'" '..TextEntry:GetValue())
		BasePanel:Close()
	end
			
	local Annuler = vgui.Create( "DButton",frame )
	Annuler:SetPos( 6, 160 )
	Annuler:SetText( TAB.GetLanguage("Cancel") )
	Annuler:SetTextColor(Color (255, 255, 255, 255))
	Annuler:SetSize( 388, 30 )
	Annuler.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end
	end
	Annuler.DoClick = function()
		BasePanel:Close()
	end
end

function TAB.OpenBanDialog(victim)
	local ply = LocalPlayer()

	local multiplicateur = 1

	local BasePanel = vgui.Create( "DFrame" )
	BasePanel:SetSize( ScrW(), ScrH() )
	BasePanel:SetTitle( "" )
	BasePanel:ShowCloseButton( false )
	BasePanel:SetDraggable( false )
	BasePanel.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, colorbg_baseframe )
	end
	BasePanel:MakePopup()

	local frame = vgui.Create( "DFrame", BasePanel )
	frame:SetSize( 400, 200 )
	frame:SetPos( -500, ScrH() / 2 - 100 )
	frame:SetTitle( "" )
	frame:ShowCloseButton( false )
	frame.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, colorbg_frame )
		surface.SetDrawColor( colorline_frame )
        surface.DrawOutlinedRect( 0, 0, w , h )
	end
	frame:MoveTo( ScrW() / 2 - 200, ScrH() / 2 - 100, 0.5, 0, 0.05 )
			
	local DComboBox = vgui.Create( "DComboBox", frame)
	DComboBox:SetPos( 290, 40 )
	DComboBox:SetSize( 100, 20 )
	DComboBox:SetValue( TAB.GetLanguage("Minute(s)") )
	DComboBox:AddChoice( TAB.GetLanguage("Minute(s)") )
	DComboBox:AddChoice( TAB.GetLanguage("Hours(s)") )
	DComboBox:AddChoice( TAB.GetLanguage("Day(s)"))
	DComboBox:AddChoice( TAB.GetLanguage("Week(s)") )
	DComboBox:AddChoice( TAB.GetLanguage("Year(s)") )
	DComboBox.OnSelect = function( panel, index, value )
		if value == TAB.GetLanguage("Minute(s)") then multiplicateur = 1
		elseif value == TAB.GetLanguage("Hours(s)") then multiplicateur = 60
		elseif value == TAB.GetLanguage("Day(s)") then multiplicateur = 60*24
		elseif value == TAB.GetLanguage("Week(s)") then multiplicateur = 60*24*7
		elseif value == TAB.GetLanguage("Year(s)") then multiplicateur = 60*24*365
		end
	end
			
	local Text1 = vgui.Create( "DLabel", frame )
	Text1:SetPos( 0, 15 )
	Text1:SetText( TAB.GetLanguage("Choose the time of the ban (0 = permanent)") )
	Text1:SetTextColor(color_text)
	Text1:SetSize(400, 20)
	Text1:SetContentAlignment(5)

	local Temps = vgui.Create( "DTextEntry", frame )
	Temps:SetPos( 25, 40 )
	Temps:SetSize( 250, 20 )
	Temps:SetText( "0" )
			
	local Text2 = vgui.Create( "DLabel", frame )
	Text2:SetPos( 0, 65 )
	Text2:SetText( TAB.GetLanguage("Enter a reason") )
	Text2:SetTextColor(color_text)
	Text2:SetSize(400, 20)
	Text2:SetContentAlignment(5)

	local Raison = vgui.Create( "DTextEntry", frame )
	Raison:SetPos( 25, 90 )
	Raison:SetSize( 350, 20 )
	Raison:SetText( TAB.GetLanguage("Reason") )
			
			
	local Valider = vgui.Create( "DButton",frame )
	Valider:SetPos( 6, 120 )
	Valider:SetText( TAB.GetLanguage("Validate") )
	Valider:SetTextColor(color_text)
	Valider:SetSize( 388, 30 )
	Valider.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end	
	end
	Valider.DoClick = function()
		ply:ConCommand('ulx ban "'..victim..'" '..Temps:GetValue()*multiplicateur..' '..Raison:GetValue())
		BasePanel:Close()
	end
			
	local Annuler = vgui.Create( "DButton",frame )
	Annuler:SetPos( 6, 160 )
	Annuler:SetText( TAB.GetLanguage("Cancel") )
	Annuler:SetTextColor(color_text)
	Annuler:SetSize( 388, 30 )
	Annuler.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end	
	end
	Annuler.DoClick = function()
		BasePanel:Close()
	end
end

function TAB.OpenSetTeam(victim)
	local List = DermaMenu()

	for k, v in SortedPairsByMemberValue(team.GetAllTeams(), "Name") do
		List:AddOption(v.Name, function() RunConsoleCommand("_FAdmin", "setteam", victim, k) end)
	end

	List:Open(gui.MouseX(), gui.MouseY())
end