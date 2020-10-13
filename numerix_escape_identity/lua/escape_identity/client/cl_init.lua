--[[ Escape --------------------------------------------------------------------------------------

Escape made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local isEscapeActive = false
local countTabsTotal
local getWidth
local InitialPanel = false

local colorline_button = Color( 255, 255, 255, 100 )
local colorbg_button = Color(33, 31, 35, 200)

local colorbg_nav = Color(52, 55, 64, 100)

-----------------------------------------------------------------
--  Echap:Launch
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

function Echap:Launch()
	local ply = LocalPlayer()

	if IsValid( Echap.Base ) then
		if Echap.Base:IsVisible() then
			Echap.Base:Remove()
			gui.EnableScreenClicker(false)
			isEscapeActive = false

			Echap.HideBox()
			hook.Remove("HUDShouldDraw", "Echap.HideAllHUD")

			return false
		end
	end

	hook.Add("HUDShouldDraw", "Echap.HideAllHUD", function()
		return false
	end)

	gui.EnableScreenClicker(true)

    Echap.Base = vgui.Create("DFrame")
	Echap.Base:SetTitle("")
	Echap.Base:SetDraggable( false )
	Echap.Base:ShowCloseButton( false )
	Echap.Base:MakePopup()
    Echap.Base:SetPos(0,0)
	Echap.Base:SetSize(ScrW(), ScrH())

	if string.sub(Echap.Settings.Background, 1, 4) == "http" then
		Echap.GetImage(Echap.Settings.Background, Echap.Settings.BackgroundName, function(url, filename)
			local background = Material(filename)
			Echap.Base.Paint = function(self, w, h)
				surface.SetMaterial(background)
				surface.DrawTexturedRect(0, 0, w, h)
			end
		end)
	elseif Echap.Settings.Background == "color" then 
		Echap.Base.Paint = function(self, w, h)
			surface.SetDrawColor(Echap.Settings.BackgroundColor or color_white)
			surface.DrawRect(0, 0, w, h)
		end
	elseif Echap.Settings.Background == "blur" then
		Echap.Base.Paint = function(self, w, h)
			blurPanel(self, 4)
		end
	elseif Echap.Settings.Background != "" then
		local background = Material(Echap.Settings.Background)
		Echap.Base.Paint = function(self, w, h)
			surface.SetMaterial(background)
			surface.DrawTexturedRect(0, 0, w, h)
		end
	else
		Echap.Base.Paint = function(self, w, h) end
	end

    Echap.Icon = vgui.Create( "DPanel", Echap.Base)
	Echap.Icon:SetSize( ScrW()/12.5+2, ScrW()/12.5+2 )
	Echap.Icon:SetPos(ScrW()/30-1, 25)
	Echap.Icon.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, colorbg_button)
		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end

	if string.sub(Echap.Settings.Logo, 1, 16) == "usesteamprofile" then
		Echap.Icon.Image = vgui.Create( "AvatarImage", Echap.Icon )
		Echap.Icon.Image:SetSize( ScrW()/12.5-1, ScrW()/12.5-1 )
		Echap.Icon.Image:SetPos( 1, 1 )
		Echap.Icon.Image:SetPlayer( ply, 128 )
	elseif string.sub(Echap.Settings.Logo, 1, 4) == "http" then
		Echap.GetImage(Echap.Settings.Logo, Echap.Settings.LogoName, function(url, filename)
			Echap.Icon.Image = vgui.Create( "DImage", Echap.Icon )
			Echap.Icon.Image:SetPos( 1,1 )
			Echap.Icon.Image:SetSize( ScrW()/12.5, ScrW()/12.5 )
			Echap.Icon.Image:SetImage( filename )
		end)
	else
		Echap.Icon.Image = vgui.Create( "DImage", Echap.Icon )
		Echap.Icon.Image:SetPos( 1,1 )
		Echap.Icon.Image:SetSize( ScrW()/12.5, ScrW()/12.5 )
		Echap.Icon.Image:SetImage( Echap.Settings.Logo )
	end

    Echap.Nav = vgui.Create( "DPanel", Echap.Base)
	Echap.Nav:SetSize( ScrW() - ScrW()/30 - ScrW()/12.5 - ScrW()/50, ScrW()/25 )
	Echap.Nav:SetPos(ScrW()/30 + ScrW()/12.5 , 25)
	Echap.Nav.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, colorbg_nav)
		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end

	Echap.Model = vgui.Create( "DModelPanel", Echap.Base )
	Echap.Model:SetSize( ScrH()/1.2, ScrH()/1.2 )
	Echap.Model:SetPos(ScrW()/1.6,ScrH()/4)
	Echap.Model:SetModel( ply:GetModel() )
	Echap.Model:SetMouseInputEnabled(false)
	function Echap.Model:LayoutEntity( ent ) 
		local lookAng = ( self.vLookatPos-self.vCamPos ):Angle()
		self:SetLookAng( lookAng )
		ent:SetAngles( Angle( 0, 45, 0 ) )
		Echap.Model:SetFOV( 40 )

		Echap.Model:SetLookAt( Vector(0,0,50) )
		return 
	end

	Echap.Content = vgui.Create("DPanelList", Echap.Base)
    Echap.Content:SetSize(ScrW()/3, ScrH() - ScrH()/4-10)
    Echap.Content:SetPos(ScrW()/30-1,ScrH()/4)
	Echap.Content.Paint = function(self, w, h)
	end

	countTabsTotal = 0
	for k, v in ipairs(Echap.Settings.Navigation) do
		if not v.Enabled or v.Visible and !v.Visible(ply) then continue end
		countTabsTotal = countTabsTotal + 1
	end

	Echap.Navigation = {}
	
	getWidth = math.Round( Echap.Nav:GetWide() / countTabsTotal )
	Echap.Nav:SetWide(getWidth*countTabsTotal)

	for k, v in ipairs( Echap.Settings.Navigation ) do
	
		if not v.Enabled or v.Visible and !v.Visible(ply) then continue end

		local icon = Material( v.Icon )

		if string.sub(v.Icon, 1, 4) == "http" then
			Echap.GetImage(v.Icon, v.IconName, function(url, filename)
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

		self.Echap_Nav_Button = vgui.Create("DButton", Echap.Nav)
		self.Echap_Nav_Button:Dock(LEFT)
		self.Echap_Nav_Button:DockMargin( 0, 0, 0, 0 )
		self.Echap_Nav_Button:SetWide(getWidth)
		self.Echap_Nav_Button:SetText("")
		self.Echap_Nav_Button:SetTooltip(v.Desc or "")
		self.Echap_Nav_Button.Paint = function(self, w, h)
			
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

			draw.DrawText( string.upper(v.Name), "Echap.Button.Text", 60, h/2-7, ColorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			
			surface.SetMaterial( icon )
			surface.SetDrawColor( ColorImage )
			surface.DrawTexturedRect( 10, h/2-15, 32, 32 )
		end
		self.Echap_Nav_Button.DoClick = function(obj)

			if ( v.WebsiteEnabled and v.WebsiteURL ) then
				for _, button in ipairs( Echap.Navigation ) do
					button.active = false
				end
				gui.OpenURL( v.WebsiteURL or "https://www.google.com/" )

				return
			end

			if v.DoFunc then
				v.DoFunc()
				return
			end

			for _, button in ipairs( Echap.Navigation ) do
				button.active = false
			end

			obj.active = true

			Echap.HideBox()

			Echap.Content:Remove()
			if not IsValid( Echap.Content ) then
				Echap.Content = vgui.Create("DPanelList", Echap.Base)
    			Echap.Content:SetSize(ScrW() - Echap.Model:GetWide()+ 100, ScrH() - ScrH()/4-10)
    			Echap.Content:SetPos(ScrW()/30-1,ScrH()/4)
				Echap.Content.Paint = function(self, w, h) end
			end
			vgui.Create(v.DoLoadPanel, Echap.Content)	
		end
		table.insert( Echap.Navigation, self.Echap_Nav_Button )

		if v.OnLoadInit and !InitialPanel and !v.DoFunc then
			Echap.Content:Remove()
			if not IsValid( Echap.Content ) then
				Echap.Content = vgui.Create("DPanelList", Echap.Base)
				Echap.Content:SetSize(ScrW() - Echap.Model:GetWide()+ 100, ScrH() - ScrH()/4-10)
				Echap.Content:SetPos(ScrW()/30-1,ScrH()/4)
				Echap.Content.Paint = function(self, w, h) end
			end
			vgui.Create( v.DoLoadPanel, Echap.Content )

			for _, button in pairs( Echap.Navigation ) do
				button.active = false
			end
			self.Echap_Nav_Button.active = true
			InitialPanel = true
		end
	end

	if !InitialPanel then
		Echap.Content:Remove()
		if not IsValid( Echap.Content ) then
			Echap.Content = vgui.Create("DPanelList", Echap.Base)
			Echap.Content:SetSize(ScrW() - Echap.Model:GetWide()+ 100, ScrH() - ScrH()/4-10)
			Echap.Content:SetPos(ScrW()/30-1,ScrH()/4)
			Echap.Content.Paint = function(self, w, h) end
		end
		vgui.Create( "Echap_Tab_Escape", Echap.Content )
	end
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

hook.Add("PreRender", "Echap:PreRender", function()
	local F4Key = KeyNameToNumber(input.LookupBinding("gm_showspare2")) or KEY_F4
	if ( gui.IsGameUIVisible() and input.IsKeyDown( KEY_ESCAPE ) or input.IsKeyDown( F4Key ) && isEscapeActive == true ) then
		isEscapeActive = true
		InitialPanel = false
		gui.HideGameUI()
		if IsValid( Echap.Base ) then
    		Echap:Launch()
			isEscapeActive = false
		else
			Echap:Launch()
		end
	end
end )