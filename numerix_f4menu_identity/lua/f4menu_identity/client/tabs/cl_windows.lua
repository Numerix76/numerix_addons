--[[ F4menu --------------------------------------------------------------------------------------

F4Menu made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
local colorline_frame = Color( 255, 255, 255, 100 )
local colorbg_frame = Color(52, 55, 64, 200)

local colorbg_baseframe = Color(0,0,0,200)
local color_outline = Color(242,242,242,255)

local colorline_button = Color( 255, 255, 255, 100 )
local colorbg_button = Color(33, 31, 35, 200)
local color_hover = Color(0, 0, 0, 100)

local color_text = Color(255,255,255,255)
local color_text2 = Color( 210, 210, 210 )

local function drawRectOutline( x, y, w, h, color )
	surface.SetDrawColor( color )
	surface.DrawOutlinedRect( x, y, w, h )
end

function F4Menu.OpenTextBox( text1, text2, cmd )

	local BasePanel = vgui.Create( "DFrame" )
	BasePanel:SetSize( ScrW(), ScrH() )
	BasePanel:SetTitle( "" )
	BasePanel:ShowCloseButton( false )
	BasePanel:SetDraggable( false )
	BasePanel.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, colorbg_baseframe )
	end
	BasePanel:MakePopup()

	local Panel = vgui.Create( "DFrame", BasePanel )
	Panel:SetSize( 300, 200 )
	Panel:SetPos( -500, ScrH() / 2 - 200 )
	Panel:SetTitle( "" )
	Panel:ShowCloseButton( false )
	Panel.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, colorbg_frame )
		surface.SetDrawColor( colorline_frame )
        surface.DrawOutlinedRect( 0, 0, w , h )
		
		draw.SimpleText( string.upper( text1 ), "F4Menu.Commande.Text.Windows", 24, 20, color_text )
		
		surface.SetDrawColor( color_outline )
		surface.DrawLine( 24, 44, 182 - 26, 44 )
	end
	Panel:MoveTo( ScrW() / 2 - 150, ScrH() / 2 - 200, 0.5, 0, 0.05 )
	
	local label = vgui.Create( "DLabel", Panel )
	label:SetPos( 28, 54 )
	label:SetSize( Panel:GetWide() - 56, 40 )
	label:SetWrap( true )
	label:SetText( string.upper(text2) )
	label:SetFont( "F4Menu.Commande.Text.Windows" )
	label:SetTextColor( color_text )
	
	local Close = vgui.Create( "DButton", Panel )
	Close:SetSize( 32, 32 )
	Close:SetPos( Panel:GetWide() - 38,6 )
	Close:SetText( "X" )
	Close:SetTextColor( color_text )
	Close.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end	
	end
	Close.DoClick = function()
		Panel:Close()
		BasePanel:Remove()
	end

	local EnterText = vgui.Create("DTextEntry", Panel)
	EnterText:SetText("")
	EnterText:SetPos( Panel:GetWide() / 2 - 100, Panel:GetTall() - 80 )
	EnterText:SetSize( 200, 20	)
	EnterText:SetDrawLanguageID(false)

	local Confirm = vgui.Create( "DButton", Panel )
	Confirm:SetSize( 80, 35 )
	Confirm:SetPos( Panel:GetWide() / 2 - 40, Panel:GetTall() - 44 )
	Confirm:SetText( F4Menu.GetLanguage("Accept") )
	Confirm:SetFont( "F4Menu.Button.Text.Windows" )
	Confirm:SetTextColor( color_text )
	Confirm.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end		
	end
	Confirm.DoClick = function()
		local amt = EnterText:GetValue()
		local str = cmd.." "..amt
		if amt then
			RunConsoleCommand( "say", str )
		end
		Panel:Close()
		BasePanel:Close()
	end
end

function F4Menu.OpenPlyBox( text1, text2, cmd )

	local BasePanel = vgui.Create( "DFrame" )
	BasePanel:SetSize( ScrW(), ScrH() )
	BasePanel:SetTitle( "" )
	BasePanel:ShowCloseButton( false )
	BasePanel:SetDraggable( false )
	BasePanel.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, colorbg_baseframe )
	end
	BasePanel:MakePopup()

	local Panel = vgui.Create( "DFrame", BasePanel )
	Panel:SetSize( 300, 200 )
	Panel:SetTitle("")
	Panel:SetPos( -500, ScrH() / 2 - 200 )
	Panel:ShowCloseButton( false )
	Panel.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, colorbg_frame )
		surface.SetDrawColor( colorline_frame )
        surface.DrawOutlinedRect( 0, 0, w , h )
		
		draw.SimpleText( string.upper( text1 ), "F4Menu.Commande.Text.Windows", 24, 20, color_text )
		
		surface.SetDrawColor( color_outline )
		surface.DrawLine( 24, 44, 182 - 26, 44 )
	end
	Panel:MoveTo( ScrW() / 2 - 150, ScrH() / 2 - 200, 0.5, 0, 0.05 )
	
	local label = vgui.Create( "DLabel", Panel )
	label:SetPos( 28, 54 )
	label:SetSize( Panel:GetWide() - 56, 40 )
	label:SetWrap( true )
	label:SetText( string.upper(text2) )
	label:SetFont( "F4Menu.Commande.Text.Windows" )
	label:SetTextColor( color_text )
	
	local Close = vgui.Create( "DButton", Panel )
	Close:SetSize( 32, 32 )
	Close:SetPos( Panel:GetWide() - 38,6 )
	Close:SetText( "X" )
	Close:SetTextColor( color_text )
	Close.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end	
	end
	Close.DoClick = function()
		Panel:Close()
		BasePanel:Remove()
	end

	local Choice = vgui.Create( "DComboBox", Panel)
	Choice:SetPos(Panel:GetWide() / 2 - 100, Panel:GetTall() - 74)
	Choice:SetSize( 200, 20 )
	for k,v in pairs(player.GetAll()) do
		Choice:AddChoice( v:Name() )
	end

	Choice.OnSelect = function( panel, index, value, data )
		target = string.Explode( " ", value )[1]
	end

	local Confirm = vgui.Create( "DButton", Panel )
	Confirm:SetSize( 80, 35 )
	Confirm:SetPos( Panel:GetWide() / 2 - 40, Panel:GetTall() - 44 )
	Confirm:SetText( F4Menu.GetLanguage("Accept") )
	Confirm:SetFont( "F4Menu.Button.Text.Windows" )
	Confirm:SetTextColor( color_text )
	Confirm.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end	
	end
	Confirm.DoClick = function()
		local str = cmd.." "..target
		if target then
			RunConsoleCommand( "say", str )
		end
		Panel:Close()
		BasePanel:Close()
	end
end

function F4Menu.OpenPlyReasonBox( text1, text2, text3, cmd )

	local BasePanel = vgui.Create( "DFrame" )
	BasePanel:SetSize( ScrW(), ScrH() )
	BasePanel:SetTitle( "" )
	BasePanel:ShowCloseButton( false )
	BasePanel:SetDraggable( false )
	BasePanel.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, colorbg_baseframe )
	end
	BasePanel:MakePopup()

	local Panel = vgui.Create( "DFrame", BasePanel )
	Panel:SetSize( 300, 250 )
	Panel:SetPos( -500, ScrH() / 2 - 200 )
	Panel:SetTitle( "" )
	Panel:ShowCloseButton( false )
	Panel.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, colorbg_frame )
		surface.SetDrawColor( colorline_frame )
        surface.DrawOutlinedRect( 0, 0, w , h )
		
		draw.SimpleText( string.upper( text1 ), "F4Menu.Commande.Text.Windows", 24, 20, color_text )
		
		surface.SetDrawColor( color_outline )
		surface.DrawLine( 24, 44, 182 - 26, 44 )
	end
	Panel:MoveTo( ScrW() / 2 - 150, ScrH() / 2 - 200, 0.5, 0, 0.05 )
	
	local label = vgui.Create( "DLabel", Panel )
	label:SetPos( 28, 54 )
	label:SetSize( Panel:GetWide() - 56, 40 )
	label:SetWrap( true )
	label:SetText( string.upper(text2) )
	label:SetFont( "F4Menu.Commande.Text.Windows" )
	label:SetTextColor( color_text )
	
	local Close = vgui.Create( "DButton", Panel )
	Close:SetSize( 32, 32 )
	Close:SetPos( Panel:GetWide() - 38,6 )
	Close:SetText( "X" )
	Close:SetTextColor( color_text )
	Close.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end	
	end
	Close.DoClick = function()
		Panel:Close()
		BasePanel:Remove()
	end

	local target

	local Choice = vgui.Create( "DComboBox", Panel)
	Choice:SetPos(Panel:GetWide() / 2 - 100, Panel:GetTall() - 120)
	Choice:SetSize( 200, 20 )
	for k,v in ipairs(player.GetAll()) do
			Choice:AddChoice( v:Name() )
	end

	Choice.OnSelect = function( panel, index, value, data )
		target = string.Explode( " ", value )[1]
	end

	local EnterText = vgui.Create("DTextEntry", Panel)
	EnterText:SetText("")
	EnterText:SetPos( Panel:GetWide() / 2 - 100, Panel:GetTall() - 74 )
	EnterText:SetSize( 200, 20	)
	EnterText:SetDrawLanguageID(false)

	local Confirm = vgui.Create( "DButton", Panel )
	Confirm:SetSize( 80, 35 )
	Confirm:SetPos( Panel:GetWide() / 2 - 40, Panel:GetTall() - 44 )
	Confirm:SetText( F4Menu.GetLanguage("Accept") )
	Confirm:SetFont( "F4Menu.Button.Text.Windows" )
	Confirm:SetTextColor( Color( 255, 255, 255 ) )
	Confirm.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end	
	end
	Confirm.DoClick = function()
		local amt = EnterText:GetValue()
		local str = cmd.." "..target.." "..amt
		if amt and target then
			RunConsoleCommand( "say", str )
		end
		Panel:Close()
		BasePanel:Close()
	end
end

function F4Menu.OpenModelChoice(job)
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

	local Panel = vgui.Create( "DFrame", BasePanel )
	Panel:SetSize( 400, 400 )
	Panel:SetPos( -500, ScrH() / 2 - 200 )
	Panel:SetTitle( "" )
	Panel:ShowCloseButton( false )
	Panel.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, colorbg_frame )
		surface.SetDrawColor( colorline_frame )
        surface.DrawOutlinedRect( 0, 0, w , h )
	end
	Panel:MoveTo( ScrW() / 2 - 150, ScrH() / 2 - 200, 0.5, 0, 0.05 )
	
	local Close = vgui.Create( "DButton", Panel )
	Close:SetSize( 32, 32 )
	Close:SetPos( Panel:GetWide() - 38,6 )
	Close:SetText( "X" )
	Close:SetTextColor( color_text )
	Close.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end		
	end
	Close.DoClick = function()
		BasePanel:Close()
	end

	local curModel = job.model[1]

	local Model = vgui.Create( "DModelPanel", Panel )
	Model:SetSize( 400, 300 )
	Model:SetModel( curModel )
	Model:Center()
	Model:SetAnimated(false)
	function Model:LayoutEntity(ent)
		ent:SetAngles(Angle(0, 45,  0))
	end

	local Prev = vgui.Create( "DButton", Panel )
	Prev:SetSize( 80, 35 )
	Prev:SetPos( 5, Panel:GetTall() - 44 )
	Prev:SetText( "<" )
	Prev:SetFont( "F4Menu.Button.Text.Windows" )
	Prev:SetTextColor( color_text )
	Prev.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end	
	end
	Prev.DoClick = function()
		local prevModel = table.FindPrev(job.model, curModel)
		Model:SetModel(prevModel)
		curModel = prevModel
	end

	local Next = vgui.Create( "DButton", Panel )
	Next:SetSize( 80, 35 )
	Next:SetPos( Panel:GetWide() - 85, Panel:GetTall() - 44 )
	Next:SetText( ">" )
	Next:SetFont( "F4Menu.Button.Text.Windows" )
	Next:SetTextColor( color_text )
	Next.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end	
	end
	Next.DoClick = function()
		local nextModel = table.FindNext(job.model, curModel)
		Model:SetModel(nextModel)
		curModel = nextModel
	end

	local Confirm = vgui.Create( "DButton", Panel )
	Confirm:SetSize( 80, 35 )
	Confirm:SetPos( Panel:GetWide() / 2 - 40, Panel:GetTall() - 44 )
	Confirm:SetText( F4Menu.GetLanguage("Accept") )
	Confirm:SetFont( "F4Menu.Button.Text.Windows" )
	Confirm:SetTextColor( color_text )
	Confirm.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end		
	end
	Confirm.DoClick = function()

		DarkRP.setPreferredJobModel(F4Menu.GetTeamID(job.name), curModel)

		if job.vote then
            if ((job.admin == 0 and ply:IsAdmin()) or (job.admin == 1 and ply:IsSuperAdmin())) then
                local menu = DermaMenu( )
                menu:AddOption(F4Menu.GetLanguage("Make a vote"), function() RunCmd("/vote"..job.command) F4Menu:Launch() BasePanel:Close() end)
                menu:AddOption(F4Menu.GetLanguage("Don't make a vote"), function() RunCmd("/"..job.command) F4Menu:Launch() BasePanel:Close() end)
                menu:Open()
            else
                RunCmd("/vote"..job.command)
				F4Menu:Launch()
				BasePanel:Close()
            end
        else
            RunCmd("/"..job.command)
			F4Menu:Launch()
			BasePanel:Close()
        end
	end
end