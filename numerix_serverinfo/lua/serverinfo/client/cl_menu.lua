--[[ ServerInfo --------------------------------------------------------------------------------------

ServerInfo made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
local colorline_frame = Color( 255, 255, 255, 100 )
local colorbg_frame = Color(52, 55, 64, 200)

local colorline_button = Color( 255, 255, 255, 100 )
local colorbg_button = Color(33, 31, 35, 200)
local color_hover = Color(0, 0, 0, 100)

local color_button_scroll = Color( 255, 255, 255, 5)
local color_scrollbar = Color( 175, 175, 175, 150 )

local colorbg_nav = Color(52, 55, 64, 100)

local color_text = Color(255,255,255,255)

local BaseFrame
net.Receive( "ServerInfo:OpenMenu", function () 

    local numbutton = 0
    for k, v in pairs( ServerInfo.Settings.Info ) do
        if not v.Visibility(LocalPlayer()) then continue end
        numbutton = numbutton + 1
    end

    if math.fmod(numbutton, 2) == 1 then
        numbutton = numbutton + 1
    end

    local tall = math.Clamp(50 + numbutton/2*65 - 10, 0, ScrH()/2)
    BaseFrame = vgui.Create( "DFrame" )
    BaseFrame:SetSize( ScrW()/2, tall + 15 )
    BaseFrame:Center()
    BaseFrame:ShowCloseButton(false)
    BaseFrame:SetTitle("")
    BaseFrame:SetDraggable(false)
    BaseFrame:MakePopup()
    BaseFrame.Paint = function(self, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, colorbg_frame )
		surface.SetDrawColor( colorline_frame )
        surface.DrawOutlinedRect( 0, 0, w , h )

        draw.SimpleText( ServerInfo.GetLanguage("Informations of").." "..ServerInfo.Settings.Server, "ServerInfo.Server", w/2, 5, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
    end

    local close = vgui.Create("DButton", BaseFrame)
    close:SetPos(BaseFrame:GetWide() - 35, 5)
    close:SetSize(30 , 30)
    close:SetText("X")
    close:SetTextColor(color_white)
    close.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end
    end
    close.DoClick = function() BaseFrame:Close() end

    ServerInfoScroll = vgui.Create( "DScrollPanel", BaseFrame ) 
    ServerInfoScroll:SetPos( 5, 50 )
    ServerInfoScroll:SetSize( BaseFrame:GetWide() - 5 , BaseFrame:GetTall() - 55 )
    ServerInfoScroll.VBar.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_hover )
    end
    ServerInfoScroll.VBar.btnUp.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    ServerInfoScroll.VBar.btnDown.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    ServerInfoScroll.VBar.btnGrip.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_scrollbar )
    end
    
    local ServerInfoButtonList = vgui.Create( "DIconLayout", ServerInfoScroll )
    ServerInfoButtonList:Dock( FILL )
    ServerInfoButtonList:SetSpaceY( 15 )
    ServerInfoButtonList:SetSpaceX( 5 )

    if numbutton/2*65 > ServerInfoScroll:GetTall() + 1 then
        wide = ServerInfoScroll:GetWide()/2-10 
    else
        wide = ServerInfoScroll:GetWide()/2-5
    end
    
    for k, v in pairs(ServerInfo.Settings.Info) do
        if not v.Visibility(LocalPlayer()) then continue end

        local icon = Material(v.Icon)

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

        local ServerInfoButton = ServerInfoButtonList:Add("DButton")
        ServerInfoButton:SetSize(wide , 50)
        ServerInfoButton:SetText("")
        ServerInfoButton.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, ColorBase)

            if !v.NotDrawLine then
                surface.SetDrawColor( ColorLine )
                surface.DrawOutlinedRect( 0, 0, w, h)
            end
            
            if self:IsHovered() or self:IsDown() then
                draw.RoundedBox( 0, 0, 0, w, h, ColorHover )
            end

            draw.SimpleText( string.upper(v.Name), "ServerInfo.Button.Text", w/2, h/2, ColorText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

            if v.Icon != "" then
                surface.SetMaterial( icon )
                surface.SetDrawColor( ColorImage )
                surface.DrawTexturedRect( 10, h/2-15, 32, 32 )
            end
        end
        ServerInfoButton.DoClick = function()
            if v.WebSiteEnabled then
                gui.OpenURL(v.WebSiteURL or "https://google.com")
            else
                v.DoFunc(LocalPlayer())
            end 
        end
    end

end)

function ServerInfo.TextMenu(title, text)
    if !isstring(text) or !isstring(title) then return end
    if IsValid(BaseFrame) then BaseFrame:Close() end

    local BaseText = vgui.Create( "DFrame" )
    BaseText:SetSize( ScrW()/2, ScrH()/2 )
    BaseText:Center()
    BaseText:ShowCloseButton(false)
    BaseText:SetTitle("")
    BaseText:SetDraggable(false)
    BaseText:MakePopup()
    BaseText.Paint = function(self, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, colorbg_frame )
		surface.SetDrawColor( colorline_frame )
        surface.DrawOutlinedRect( 0, 0, w , h )

        draw.SimpleText(title, "ServerInfo.Server", w/2, 5, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
    end

    local close = vgui.Create("DButton", BaseText)
    close:SetPos(BaseText:GetWide() - 35, 5)
    close:SetSize(30 , 30)
    close:SetText("X")
    close:SetTextColor(color_white)
    close.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, colorbg_button)

		surface.SetDrawColor( colorline_button )
		surface.DrawOutlinedRect( 0, 0, w, h )

		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, color_hover )
		end
    end
    close.DoClick = function() BaseText:Close() end

    TextPanel = vgui.Create("RichText", BaseText)
    TextPanel:SetPos(5, 50)
    TextPanel:SetSize(BaseText:GetWide() - 10, BaseText:GetTall() - 55)
    function TextPanel:PerformLayout()
        self:SetFontInternal( "ServerInfo.Text" )
        self:SetFGColor( Color( 255, 255, 255 ) )
        self:SetVerticalScrollbarEnabled(true)
    end
    TextPanel:AppendText(text)
end