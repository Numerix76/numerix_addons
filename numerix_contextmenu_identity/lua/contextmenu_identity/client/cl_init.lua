--[[ ContextMenu Identity --------------------------------------------------------------------------------------

ContextMenu Identity made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
local colorline_frame = Color( 255, 255, 255, 100 )
local colorbg_frame = Color(52, 55, 64, 100)

local colorbg_baseframe = Color(0,0,0,200)
local color_outline = Color(242,242,242,255)

local colorline_button = Color( 255, 255, 255, 100 )
local colorbg_button = Color(33, 31, 35, 200)
local color_hover = Color(0, 0, 0, 100)

local color_button_scroll = Color( 255, 255, 255, 5)
local color_scrollbar = Color( 175, 175, 175, 150 )

local colorbg_nav = Color(52, 55, 64, 100)

local color_text = Color(255,255,255,255)
local color_line = Color(255,255,255,255)

local size
local allow
local plyweapon
hook.Add("OnContextMenuOpen", "Numerix_ContextMenu_Open", function()

	local ply = LocalPlayer()

	allow = true
	if ply:Alive() and ply:GetActiveWeapon() and ply:GetActiveWeapon():IsValid() then
		plyweapon = ply:GetActiveWeapon():GetClass()

		for k, v in ipairs(ContextMenuIdentity.Settings.WeaponBlacklist) do
			if string.sub(plyweapon, 0, string.len(v)) == v then
				allow = false
				break
			end
		end
	end

	if allow then
		gui.EnableScreenClicker(true)
		
		ContextMenuBase = vgui.Create( "DFrame" )
		ContextMenuBase:SetSize( ScrW(), ScrH() )
		ContextMenuBase:SetPos( 0, 0 )
		ContextMenuBase:SetTitle( "" )
		ContextMenuBase:SetDraggable( false )
		ContextMenuBase:ShowCloseButton( false )
		ContextMenuBase.Paint = function(self, w, h)
		end
		ContextMenuBase.OnMousePressed = function( p, code )
			hook.Run( "GUIMousePressed", code, gui.ScreenToVector( gui.MousePos() ) )
		end
		ContextMenuBase.OnMouseReleased = function( p, code )
			hook.Run( "GUIMouseReleased", code, gui.ScreenToVector( gui.MousePos() ) )
		end
		if ContextMenuIdentity.Settings.AllowEveryone or ContextMenuIdentity.Settings.StaffGroup[ply:GetNWString("usergroup")] then
			ContextMenuBase:SetWorldClicker( true )
		end

		local ContextMenuSecondaire = vgui.Create( "DPanel", ContextMenuBase )
		ContextMenuSecondaire:SetSize( ScrW()/5, ScrH() )
		ContextMenuSecondaire:SetPos( ContextMenuIdentity.Settings.Border() - ContextMenuSecondaire:GetWide(), 0 )
		ContextMenuSecondaire:SetWorldClicker( false )
		ContextMenuSecondaire.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, colorbg_frame)
			surface.SetDrawColor( colorline_frame )
			surface.DrawOutlinedRect( 0, 0, w, h )

			for k, v in ipairs(ContextMenuIdentity.Settings.Info) do
				if not v.Enabled then continue end
				draw.SimpleText( v.Value(ply), "ContextMenu.Text", w/2, w/2.7 + k*25, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end

			draw.SimpleText( ContextMenuIdentity.Settings.Server, "ContextMenu.Server", w/2, h/1.05, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		if string.sub(ContextMenuIdentity.Settings.Logo, 1, 16) == "usesteamprofile" then
			ContextImage = vgui.Create( "AvatarImage", ContextMenuSecondaire )
			ContextImage:SetSize( ScrW()/15, ScrW()/15 )
			ContextImage:SetPos( ContextMenuSecondaire:GetWide()/2 - ContextImage:GetWide()/2, 10 )
			ContextImage:SetPlayer( ply, 128 )
		elseif string.sub(ContextMenuIdentity.Settings.Logo, 1, 4) == "http" then
			ContextMenuIdentity.GetImage(ContextMenuIdentity.Settings.Logo, ContextMenuIdentity.Settings.LogoName, function(url, filename)
				ContextImage = vgui.Create( "DImage", ContextMenuSecondaire )
				ContextImage:SetSize( ScrW()/15, ScrW()/15 )
				ContextImage:SetPos( ContextMenuSecondaire:GetWide()/2 - ContextImage:GetWide()/2, 10 )
				ContextImage:SetImage( filename )
			end)
		else
			ContextImage = vgui.Create( "DImage", ContextMenuSecondaire )
			ContextImage:SetSize( ScrW()/15, ScrW()/15 )
			ContextImage:SetPos( ContextMenuSecondaire:GetWide()/2 - ContextImage:GetWide()/2, 10 )
			ContextImage:SetImage( ContextMenuIdentity.Settings.Logo )
		end

		size = 0
		for k, v in ipairs(ContextMenuIdentity.Settings.Info) do
			if not v.Enabled then continue end
			size = k*25
		end

		ContextMenuScroll = vgui.Create( "DScrollPanel", ContextMenuSecondaire ) 
		ContextMenuScroll:SetPos( 5, ScrW()/11 + size*1.1 )
		ContextMenuScroll:SetSize( ContextMenuSecondaire:GetWide() - 10 , ScrH()/1.1 - ScrW()/11 - size*1.1 )
		ContextMenuScroll.VBar.Paint = function( s, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end
		ContextMenuScroll.VBar.btnUp.Paint = function( s, w, h ) 
			draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
		end
		ContextMenuScroll.VBar.btnDown.Paint = function( s, w, h ) 
			draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
		end
		ContextMenuScroll.VBar.btnGrip.Paint = function( s, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, color_scrollbar )
		end
		
		local ContextMenuButtonList = vgui.Create( "DIconLayout", ContextMenuScroll )
		ContextMenuButtonList:Dock( FILL )
		ContextMenuButtonList:SetSpaceY( 15 )
		ContextMenuButtonList:SetSpaceX( 5 )

		local numbutton = 0
		for k, v in ipairs( ContextMenuIdentity.Settings.Button ) do
			if not v.Visibility(ply) then continue end
			if v.Space and ContextMenuIdentity.Settings.TwoButton and math.fmod(numbutton, 2) == 0 then
				numbutton = numbutton + 3
			else
				numbutton = numbutton + 1
			end
		end
		
		local wide = 0
		local actualbutton = 0

		if ContextMenuIdentity.Settings.TwoButton then
			if numbutton/2*65 > ContextMenuScroll:GetTall() then
				wide = ContextMenuScroll:GetWide()/1.91-20
			else
				wide = ContextMenuScroll:GetWide()/2.03-0
			end
		elseif numbutton*65 > ContextMenuScroll:GetTall() then
			wide = ContextMenuScroll:GetWide()-20 
		else
			wide = ContextMenuScroll:GetWide()
		end

		for k, v in ipairs( ContextMenuIdentity.Settings.Button ) do
			
			if not v.Visibility(ply) then continue end
			actualbutton = actualbutton + 1

			if v.Space then
				if ContextMenuIdentity.Settings.TwoButton then
					if math.fmod(actualbutton, 2) == 0 then
						local ContextSpace = ContextMenuButtonList:Add( "DPanel", ContextMenuBase )
						ContextSpace:SetSize( ContextMenuScroll:GetWide()/2.03, 50 )
						ContextSpace.Paint = function(s,w,h) end

						local ContextSpace = ContextMenuButtonList:Add( "DPanel", ContextMenuBase )
						ContextSpace:SetSize( numbutton/2*65 > ContextMenuScroll:GetTall() and ContextMenuScroll:GetWide()-20 or ContextMenuScroll:GetWide(), 50 )
						ContextSpace.Paint = function(s,w,h)
							surface.SetDrawColor( v.ColorLine or color_line )

							if v.DrawLineUp then
								surface.DrawLine(0, 0, w, 0)
							end

							draw.SimpleText( v.Name, "ContextMenu.Text", w/2, h/2, v.ColorText or color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
							
							if v.DrawLineDown then
								surface.DrawLine(0, h-1, w, h-1)
							end
						end
					else
						
						local ContextSpace = ContextMenuButtonList:Add( "DPanel", ContextMenuBase )
						ContextSpace:SetSize( numbutton/2*65 > ContextMenuScroll:GetTall() and ContextMenuScroll:GetWide()-20 or ContextMenuScroll:GetWide(), 50 )
						ContextSpace.Paint = function(s,w,h)
							surface.SetDrawColor( v.ColorLine or color_line )

							if v.DrawLineUp then
								surface.DrawLine(0, 0, w, 0)
							end

							draw.SimpleText( v.Name, "ContextMenu.Text", w/2, h/2, v.ColorText or color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
							
							if v.DrawLineDown then
								surface.DrawLine(0, h-1, w, h-1)
							end							
						end
					end
				else
					local ContextSpace = ContextMenuButtonList:Add( "DPanel", ContextMenuBase )
					ContextSpace:SetSize( numbutton*65 > ContextMenuScroll:GetTall() and ContextMenuScroll:GetWide()-20 or ContextMenuScroll:GetWide(), 50 )
					ContextSpace.Paint = function(s,w,h)
						surface.SetDrawColor( v.ColorLine or color_line )

						if v.DrawLineUp then
							surface.DrawLine(0, 0, w, 0)
						end

						draw.SimpleText( v.Name, "ContextMenu.Text", w/2, h/2, v.ColorText or color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						
						if v.DrawLineDown then
							surface.DrawLine(0, h-1, w, h-1)
						end
					end
				end
			else
				local icon = Material( v.Icon )

				if string.sub(v.Icon, 1, 4) == "http" then
					ContextMenuIdentity.GetImage(v.Icon, v.IconName, function(url, filename)
						v.Icon = filename
						icon = Material( v.Icon )
					end)
				end
				
				local ColorLine = v.ColorLine or Color( 255, 255, 255, 100 )
				local ColorBase = v.ColorBase or Color(33, 31, 35, 200)
				local ColorHover = v.ColorHover or Color( 0, 0, 0, 100 )
				local ColorText = v.ColorText or Color( 255, 255, 255, 255 )
				local ColorImage = v.ColorImage or Color(255,255,255,255)

				local ContextButton = ContextMenuButtonList:Add("DButton")
				ContextButton:SetSize(wide, 50)
				ContextButton:SetText("")
				ContextButton:SetTooltip(v.Desc or "")
				ContextButton.Paint = function(self, w, h)
					draw.RoundedBox(0, 0, 0, w, h, ColorBase)

					if !v.NotDrawLine then
						surface.SetDrawColor( ColorLine )
						surface.DrawOutlinedRect( 0, 0, w, h)
					end
					
					if self:IsHovered() or self:IsDown() then
						draw.RoundedBox( 0, 0, 0, w, h, ColorHover )
					end

					if ContextMenuIdentity.Settings.TwoButton then
						draw.SimpleText( string.upper(v.Name), "ContextMenu.Button.Text", 50, h/2, ColorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( string.upper(v.Name), "ContextMenu.Button.Text", w/2, h/2, ColorText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end

					if v.Icon != "" then
						surface.SetMaterial( icon )
						surface.SetDrawColor( ColorImage )
						surface.DrawTexturedRect( 10, h/2-15, 32, 32 )
					end
				end
				ContextButton.DoClick = function()
					v.DoFunc(ply)
				end
			end
		end
	end

	timer.Simple(0.01, function()
		if ( IsValid( g_ContextMenu ) ) then
			g_ContextMenu:Remove()
			g_ContextMenu = nil
		end
	end)
end)


hook.Add("OnContextMenuClose", "Numerix_ContextMenu_Open", function()
	if IsValid(ContextMenuBase) then
		ContextMenuBase:Close()
	end
	gui.EnableScreenClicker(false)
end)


function ContextMenuIdentity.OpenTextEntry(text1, text2, cmd ) 
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
		
		draw.SimpleText( string.upper( text1 ), "ContextMenu.Text.Windows", 24, 20, color_text )
		
		surface.SetDrawColor( color_outline )
		surface.DrawLine( 24, 44, 182 - 26, 44 )
	end
	Panel:MoveTo( ScrW() / 2 - 150, ScrH() / 2 - 200, 0.5, 0, 0.05 )
	
	local label = vgui.Create( "DLabel", Panel )
	label:SetPos( 28, 54 )
	label:SetSize( Panel:GetWide() - 56, 40 )
	label:SetWrap( true )
	label:SetText( string.upper(text2) )
	label:SetFont( "ContextMenu.Text.Windows" )
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
	Confirm:SetText( ContextMenuIdentity.GetLanguage("Accept") )
	Confirm:SetFont( "ContextMenu.Text.Windows" )
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