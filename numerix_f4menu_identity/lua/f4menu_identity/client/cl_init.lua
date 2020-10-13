--[[ F4menu --------------------------------------------------------------------------------------

F4Menu made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
local colorline_button = Color( 255, 255, 255, 100 )
local colorbg_button = Color(33, 31, 35, 200)

local colorbg_nav = Color(52, 55, 64, 100)

local IsF4MenuOpen = false
local countTabsTotal
local getWidth
local InitialPanel = false

-----------------------------------------------------------------
--  F4Menu:Launch
-----------------------------------------------------------------
local blur = Material("pp/blurscreen")
local function blurPanel(p, a, h)
		local x, y = p:LocalToScreen(0, 0)
		local scrW, scrH = ScrW(), ScrH()
		surface.SetDrawColor(color_white)
		surface.SetMaterial(blur)
		for i = 1, (h or 3) do
			blur:SetFloat("$blur", (i/3)*(a or 6))
			blur:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(x*-1,y*-1,scrW,scrH)
		end
end

function F4Menu:Launch()
	local ply = LocalPlayer()
	
	if IsValid( F4Menu.Base ) then
		if F4Menu.Base:IsVisible() then
			F4Menu.Base:Remove()
			gui.EnableScreenClicker(false)
			IsF4MenuOpen = false

			F4Menu.HideBox()
			hook.Remove("HUDShouldDraw", "F4Menu.HideAllHUD")

			return false
		end
	end

	hook.Add("HUDShouldDraw", "F4Menu.HideAllHUD", function()
		return false
	end)

	gui.EnableScreenClicker(true)

    F4Menu.Base = vgui.Create("DFrame")
	F4Menu.Base:SetTitle("")
	F4Menu.Base:SetDraggable( false )
	F4Menu.Base:ShowCloseButton( false )
	F4Menu.Base:MakePopup()
    F4Menu.Base:SetPos(0,0)
    F4Menu.Base:SetSize(ScrW(), ScrH())
	
	if string.sub(F4Menu.Settings.Background, 1, 4) == "http" then
		F4Menu.GetImage(F4Menu.Settings.Background, F4Menu.Settings.BackgroundName, function(url, filename)
			local background = Material(filename)
			F4Menu.Base.Paint = function(self, w, h)
				surface.SetMaterial(background)
				surface.DrawTexturedRect(0, 0, w, h)
			end
		end)
	elseif F4Menu.Settings.Background == "color" then 
		F4Menu.Base.Paint = function(self, w, h)
			surface.SetDrawColor(F4Menu.Settings.BackgroundColor or color_white)
			surface.DrawRect(0, 0, w, h)
		end
	elseif F4Menu.Settings.Background == "blur" then
		F4Menu.Base.Paint = function(self, w, h)
			blurPanel(self, 4)
		end
	elseif F4Menu.Settings.Background != "" then
		local background = Material(F4Menu.Settings.Background)
		F4Menu.Base.Paint = function(self, w, h)
			surface.SetMaterial(background)
			surface.DrawTexturedRect(0, 0, w, h)
		end
	else
		F4Menu.Base.Paint = function(self, w, h) end
	end

    F4Menu.Icon = vgui.Create( "DPanel", F4Menu.Base)
	F4Menu.Icon:SetSize( ScrW()/12.5+2, ScrW()/12.5+2 )
	F4Menu.Icon:SetPos(ScrW()/30-1, 25)
	F4Menu.Icon.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, Color(33, 31, 35, 255))
		surface.SetDrawColor( Color( 255, 255, 255, 100 ) )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end

	if string.sub(F4Menu.Settings.Logo, 1, 16) == "usesteamprofile" then
		F4Menu.Icon.Image = vgui.Create( "AvatarImage", F4Menu.Icon )
		F4Menu.Icon.Image:SetSize( ScrW()/12.5-1, ScrW()/12.5-1 )
		F4Menu.Icon.Image:SetPos( 1, 1 )
		F4Menu.Icon.Image:SetPlayer( ply, 128 )
	elseif string.sub(F4Menu.Settings.Logo, 1, 4) == "http" then
		F4Menu.GetImage(F4Menu.Settings.Logo, F4Menu.Settings.LogoName, function(url, filename)
			F4Menu.Icon.Image = vgui.Create( "DImage", F4Menu.Icon )
			F4Menu.Icon.Image:SetPos( 1,1 )
			F4Menu.Icon.Image:SetSize( ScrW()/12.5, ScrW()/12.5 )
			F4Menu.Icon.Image:SetImage( filename )
		end)
	else
		F4Menu.Icon.Image = vgui.Create( "DImage", F4Menu.Icon )
		F4Menu.Icon.Image:SetPos( 1,1 )
		F4Menu.Icon.Image:SetSize( ScrW()/12.5, ScrW()/12.5 )
		F4Menu.Icon.Image:SetImage( F4Menu.Settings.Logo )
	end

    F4Menu.Nav = vgui.Create( "DPanel", F4Menu.Base)
	F4Menu.Nav:SetSize( ScrW() - ScrW()/30 - ScrW()/12.5 - ScrW()/50, ScrW()/25 )
	F4Menu.Nav:SetPos(ScrW()/30 + ScrW()/12.5 , 25)
	F4Menu.Nav.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, colorbg_nav)
		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end

	F4Menu.Model = vgui.Create( "DModelPanel", F4Menu.Base )
	F4Menu.Model:SetSize( ScrH()/1.2, ScrH()/1.2 )
	F4Menu.Model:SetPos(ScrW()/1.6,ScrH()/4)
	F4Menu.Model:SetModel( ply:GetModel() )
	F4Menu.Model:SetMouseInputEnabled(false)
	function F4Menu.Model:LayoutEntity( ent ) 
		local lookAng = ( self.vLookatPos-self.vCamPos ):Angle()
		self:SetLookAng( lookAng )
		ent:SetAngles( Angle( 0, 45, 0 ) )
		F4Menu.Model:SetFOV( 40 )
		F4Menu.Model:SetLookAt( Vector(0,0,50) )
		return 
	end

	F4Menu.Content = vgui.Create("DPanelList", F4Menu.Base)
    F4Menu.Content:SetSize(ScrW()/3, ScrH() - ScrH()/4-10)
    F4Menu.Content:SetPos(ScrW()/30-1,ScrH()/4)
	F4Menu.Content.Paint = function(self, w, h)
	end

	countTabsTotal = 0
	for k, v in ipairs(F4Menu.Settings.Navigation) do
		if not v.Enabled or v.Visible and !v.Visible(ply) then continue end
		countTabsTotal = countTabsTotal + 1
	end

	F4Menu.Navigation = {}
	
	getWidth = math.Round( F4Menu.Nav:GetWide() / countTabsTotal )
	F4Menu.Nav:SetWide(getWidth*countTabsTotal)

	for k, v in ipairs( F4Menu.Settings.Navigation ) do

		if not v.Enabled or v.Visible and !v.Visible(ply) then continue end

		local icon = Material( v.Icon )

		if string.sub(v.Icon, 1, 4) == "http" then
			F4Menu.GetImage(v.Icon, v.IconName, function(url, filename)
				v.Icon = filename
				icon = Material( v.Icon )
			end)
		end

		local ColorLine = v.ColorLine or Color( 255, 255, 255, 100 )
		local ColorBase = v.ColorBase or Color(33, 31, 35, 200)
		local ColorHover = v.ColorHover or Color( 0, 0, 0, 100 )
		local ColorText = v.ColorText or Color( 255, 255, 255, 255 )
		local ColorImage = v.ColorImage or Color(255,255,255,255)
		local ColorSelected = v.ColorSelected or Color(47, 174, 79, 100)

		self.F4Menu_Nav_Button = vgui.Create("DButton", F4Menu.Nav)
		self.F4Menu_Nav_Button:Dock(LEFT)
		self.F4Menu_Nav_Button:DockMargin( 0, 0, 0, 0 )
		self.F4Menu_Nav_Button:SetWide(getWidth)
		self.F4Menu_Nav_Button:SetText("")
		self.F4Menu_Nav_Button:SetTooltip(v.Desc or "")
		self.F4Menu_Nav_Button.Paint = function(self, w, h)

			if self.active then
				draw.RoundedBox(0, 0, 0, w, h, ColorSelected)
			else
				draw.RoundedBox(0, 0, 0, w, h, ColorBase)
			end
			
			if !v.NotDrawLine then
				surface.SetDrawColor( ColorLine )
				surface.DrawOutlinedRect( 0, 0, w, h )
			end

			if self:IsHovered() or self:IsDown() then
				draw.RoundedBox( 0, 0, 0, w, h, ColorHover )
			end

			draw.DrawText( string.upper(v.Name), "F4Menu.Button.Text", 60, h/2-7, ColorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			
			surface.SetMaterial( icon )
			surface.SetDrawColor( ColorImage )
			surface.DrawTexturedRect( 10, h/2-15, 32, 32 )
		end

		self.F4Menu_Nav_Button.DoClick = function(obj)

			if ( v.WebsiteEnabled and v.WebsiteURL ) then
				for _, button in ipairs( F4Menu.Navigation ) do
					button.active = false
				end
				gui.OpenURL( v.WebsiteURL or "https://www.google.com" )
				
				return
			end

			if v.DoFunc then
				v.DoFunc()
				return
			end

			for _, button in ipairs( F4Menu.Navigation ) do
				button.active = false
			end

			obj.active = true

			F4Menu.HideBox()

			F4Menu.Content:Remove()
			if not IsValid( F4Menu.Content ) then
				F4Menu.Content = vgui.Create("DPanelList", F4Menu.Base)
    			F4Menu.Content:SetSize(ScrW() - F4Menu.Model:GetWide()+ 100, ScrH() - ScrH()/4-10)
    			F4Menu.Content:SetPos(ScrW()/30-1,ScrH()/4)
				F4Menu.Content.Paint = function(self, w, h) end
			end
			vgui.Create(v.DoLoadPanel, F4Menu.Content)

		end
		table.insert( F4Menu.Navigation, self.F4Menu_Nav_Button )
		if v.OnLoadInit and !InitialPanel and !v.DoFunc then
			F4Menu.Content:Remove()
			if not IsValid( F4Menu.Content ) then
				F4Menu.Content = vgui.Create("DPanelList", F4Menu.Base)
				F4Menu.Content:SetSize(ScrW() - F4Menu.Model:GetWide()+ 100, ScrH() - ScrH()/4-10)
				F4Menu.Content:SetPos(ScrW()/30-1,ScrH()/4)
				F4Menu.Content.Paint = function(self, w, h) end
			end
			vgui.Create( v.DoLoadPanel, F4Menu.Content )

			for _, button in ipairs( F4Menu.Navigation ) do
				button.active = false
			end
			self.F4Menu_Nav_Button.active = true
			InitialPanel = true
		end
	end

	if !InitialPanel then
		F4Menu.Content:Remove()
		if not IsValid( F4Menu.Content ) then
			F4Menu.Content = vgui.Create("DPanelList", F4Menu.Base)
			F4Menu.Content:SetSize(ScrW() - F4Menu.Model:GetWide()+ 100, ScrH() - ScrH()/4-10)
			F4Menu.Content:SetPos(ScrW()/30-1,ScrH()/4)
			F4Menu.Content.Paint = function(self, w, h) end
		end
		vgui.Create( "F4Menu_Tab_Home", F4Menu.Content )
	end
end

Texts = {}

Texts.DarkRPCommand = "say"

function RunCmd(...)
	local arg = {...}
	if Texts.DarkRPCommand:lower():find('say') then
			arg = table.concat(arg,' ')
	else
			arg = table.concat(arg,'" "')
	end
	
	RunConsoleCommand(Texts.DarkRPCommand,arg)
end

function RunEntCmd(...)
	local arg = {...}
	if Texts.DarkRPCommand:lower():find('say') then
			arg = table.concat(arg,' ')
	else
			arg = table.concat(arg,'" "')
	end
	
	RunConsoleCommand(Texts.DarkRPCommand, "/"..arg)
end
-----------------------------------------------------------------
--  Keybinds
-----------------------------------------------------------------

local keyNames
local function KeyNameToNumber(str)
    if not keyNames then
        keyNames = {}
        for i = 1, 107, 1 do
            keyNames[input.GetKeyName(i)] = i
        end
    end

    return keyNames[str]
end

hook.Add("ShowSpare2", "F4Menu:Override", function()
	return false
end)

hook.Add("PreRender", "F4Menu:PreRender", function()
	local F4Key = KeyNameToNumber(input.LookupBinding("gm_showspare2")) or KEY_F4
	if ( input.IsKeyDown( F4Key )  or input.IsKeyDown( KEY_ESCAPE ) && IsF4MenuOpen == true ) then
		timer.Create("AntiSpamF4",0.05,1, function() 
			InitialPanel = false
			IsF4MenuOpen = true
			if IsValid( F4Menu.Base ) then
	    		F4Menu:Launch()
				IsF4MenuOpen = false
			else
				F4Menu:Launch()
			end
		end)
	end
end)