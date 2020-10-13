--[[ OpenScript --------------------------------------------------------------------------------------

OpenScript made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
local colorline_button = Color( 255, 255, 255, 100 )
local colorbg_button = Color(33, 31, 35, 200)
local color_hover = Color(0, 0, 0, 100)
local color_text = Color(255, 255, 255, 255)

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

net.Receive( "OpenScript:OpenPanel" , function ( len , ply )
    OpenScript.Base = vgui.Create( "DFrame" )
    OpenScript.Base:SetPos( 0, 0 )
    OpenScript.Base:SetSize( ScrW(), ScrH() )
    OpenScript.Base:SetTitle( "" )
    OpenScript.Base:SetDraggable( false )
    OpenScript.Base:MakePopup()
    OpenScript.Base:ShowCloseButton(false)
    timer.Simple(0.001, function() OpenScript.Base:MoveToFront() end)

    if string.sub(OpenScript.Settings.Background, 1, 4) == "http" then
		OpenScript.GetImage(OpenScript.Settings.Background, OpenScript.Settings.BackgroundName, function(url, filename)
			local background = Material(filename)
            OpenScript.Base.Paint = function(self, w, h)
                surface.SetDrawColor(color_white)
				surface.SetMaterial(background)
				surface.DrawTexturedRect(0, 0, w, h)
			end
		end)
	elseif OpenScript.Settings.Background == "color" then 
		OpenScript.Base.Paint = function(self, w, h)
			surface.SetDrawColor(OpenScript.Settings.BackgroundColor or color_white)
			surface.DrawRect(0, 0, w, h)
		end
	elseif OpenScript.Settings.Background == "blur" then
		OpenScript.Base.Paint = function(self, w, h)
			blurPanel(self, 4)
		end
	elseif OpenScript.Settings.Background != "" then
		local background = Material(OpenScript.Settings.Background)
        OpenScript.Base.Paint = function(self, w, h)
            surface.SetDrawColor(color_white)
			surface.SetMaterial(background)
			surface.DrawTexturedRect(0, 0, w, h)
		end
	else
        OpenScript.Base.Paint = function(self, w, h)
            draw.RoundedBox(1, 0, 0, w, h, color_black)
        end
	end

    local PanelSecondaire = vgui.Create( "DPanel", OpenScript.Base )
    PanelSecondaire:SetPos( 0, 0 ) 
    PanelSecondaire:SetSize( ScrW(), ScrH() )
    function PanelSecondaire:Think()
        local realtime = os.time()
        local timeouverture = OpenScript.Settings.Horaire	
        TimeLeft = os.difftime(timeouverture, realtime)
        
        if TimeLeft < 0 then
            if IsValid( OpenScript.Base ) then
                OpenScript.Base:Remove()
            end
        end

        if OpenScript.Settings.GroupeBypass[LocalPlayer():GetNWString("usergroup")] then
            if IsValid( OpenScript.Base ) then
                OpenScript.Base:Remove()
            end
        end
    end
    function PanelSecondaire:Paint(w, h)
        draw.SimpleText(OpenScript.Settings.Community, "TextOuverture", ScrW()/2, 50, OpenScript.Settings.ColorCommunity, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText(OpenScript.GetLanguage("The server open in").." : "..SecondsToClock(TimeLeft), "TextOuverture", ScrW()/2, 200, OpenScript.Settings.ColorTimeLeft, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    local icon1 = Material(OpenScript.Settings.Link1IMG)
    if string.sub(OpenScript.Settings.Link1IMG, 1, 4) == "http" then
		OpenScript.GetImage(OpenScript.Settings.Link1IMG, OpenScript.Settings.Link1Name, function(url, filename)
			icon1 = Material(filename)
        end)
    end

    local Button_Site = vgui.Create( "DButton", OpenScript.Base )
    Button_Site:SetSize( 150, 50 )
    Button_Site:SetPos( ScrW() / 2 - 150*2, ScrH()/2-25)
    Button_Site:SetText( "" )
    Button_Site:SetFont( "Button" )
    Button_Site:SetTextColor( color_text )
    Button_Site.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end	

        draw.DrawText( string.upper(OpenScript.Settings.Link1Text), "Button", w/2.5, h/2-7.5, color_text, TEXT_ALIGN_LEFT )

        surface.SetMaterial( icon1 )
        surface.SetDrawColor( color_white )
        surface.DrawTexturedRect( 10, h/2-15, 32, 32 )
    end
    Button_Site.DoClick = function()
        gui.OpenURL(OpenScript.Settings.Link1URL)
    end

    local icon2 = Material(OpenScript.Settings.Link2IMG)
    if string.sub(OpenScript.Settings.Link2IMG, 1, 4) == "http" then
        OpenScript.GetImage(OpenScript.Settings.Link2IMG, OpenScript.Settings.Link2Name, function(url, filename)
			icon2 = Material(filename)
        end)
    end

    local Button_Boutique = vgui.Create( "DButton", OpenScript.Base )
    Button_Boutique:SetSize( 150, 50 )
    Button_Boutique:SetPos( ScrW() / 2 -150/2, ScrH()/2-25)
    Button_Boutique:SetText( "" )
    Button_Boutique:SetFont( "Button" )
    Button_Boutique:SetTextColor( color_text )
    Button_Boutique.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end	

        draw.DrawText( string.upper(OpenScript.Settings.Link2Text), "Button", w/2.5, h/2-7.5, color_text, TEXT_ALIGN_LEFT )

        surface.SetMaterial( icon2 )
        surface.SetDrawColor( color_white )
        surface.DrawTexturedRect( 10, h/2-15, 32, 32 )
    end
    Button_Boutique.DoClick = function()
        gui.OpenURL(OpenScript.Settings.Link2URL)
    end

    local icon3 = Material(OpenScript.Settings.Link3IMG)
    if string.sub(OpenScript.Settings.Link3IMG, 1, 4) == "http" then
		OpenScript.GetImage(OpenScript.Settings.Link3IMG, OpenScript.Settings.Link3Name, function(url, filename)
			icon3 = Material(filename)
        end)
    end

    local Button_Forum = vgui.Create( "DButton", OpenScript.Base )
    Button_Forum:SetSize( 150, 50 )
    Button_Forum:SetPos( ScrW() / 2 +150, ScrH()/2-25)
    Button_Forum:SetText( "" )
    Button_Forum:SetFont( "Button" )
    Button_Forum:SetTextColor( color_text )
    Button_Forum.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end	

        draw.DrawText( string.upper(OpenScript.Settings.Link3Text), "Button", w/2.5, h/2-7.5, color_text, TEXT_ALIGN_LEFT )

        surface.SetMaterial( icon3 )
        surface.SetDrawColor( color_white )
        surface.DrawTexturedRect( 10, h/2-15, 32, 32 )
    end
    Button_Forum.DoClick = function()
        gui.OpenURL(OpenScript.Settings.Link3URL)
    end

    local icon4 = Material(OpenScript.Settings.DisconnectIMG)
    if string.sub(OpenScript.Settings.DisconnectIMG, 1, 4) == "http" then
		OpenScript.GetImage(OpenScript.Settings.DisconnectIMG, OpenScript.Settings.DisconnectName, function(url, filename)
			icon4 = Material(filename)
        end)
    end

    local DiconnectButton = vgui.Create("DButton", OpenScript.Base)
    DiconnectButton:SetText( "" )
    DiconnectButton:SetTextColor(color_text)					
    DiconnectButton:SetPos( ScrW()/2 - 150/2, ScrH() / 2 + 50 )					
    DiconnectButton:SetSize( 150, 50 )
    DiconnectButton.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end

        draw.DrawText( string.upper(OpenScript.GetLanguage("Quit")), "Button", w/2.5, h/2-7.5, color_text, TEXT_ALIGN_LEFT )

        surface.SetMaterial( icon4 )
        surface.SetDrawColor( color_white )
        surface.DrawTexturedRect( 10, h/2-15, 32, 32 )
    end					
    DiconnectButton.DoClick = function(ply)				
	    RunConsoleCommand("disconnect")
    end
end)

function SecondsToClock(seconds)
    local seconds = tonumber(seconds)
  
    if seconds <= 0 then
      return "00:00:00";
    else
        hours = string.format("%02.f", math.floor(seconds/3600));
        mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
        secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
        return hours..":"..mins..":"..secs
    end
end


surface.CreateFont( "TextOuverture", {
    font = "Roboto",
    extended = false,
    size = 50,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
} )

surface.CreateFont( "Button", {
	size = 16,
	weight = 700,
	antialias = true,
	shadow = false,
	font = "Roboto"
})