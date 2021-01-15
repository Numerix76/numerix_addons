--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
local PANEL = {}

function PANEL:Init()   
end

function PANEL:PerformLayout(width, height)
    self:SetSize(width, height)
end

function PANEL:MakeContent(ent, type)
    local radio = Radio.ConnectedRadio

	self.Think = function()
		radio = Radio.ConnectedRadio
    end
    
    self.Paint = function(s, w, h) end

    local RadioScroll = vgui.Create( "DScrollPanel", self )
    RadioScroll:SetPos(5, 60)
	RadioScroll:SetSize(self:GetWide() - 10, self:GetTall() - 60)
    RadioScroll.VBar.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Radio.Color["scroll_background"] )
    end
    RadioScroll.VBar.btnUp.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, Radio.Color["scroll_button"] )
    end
    RadioScroll.VBar.btnDown.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, Radio.Color["scroll_button"] )
    end
    RadioScroll.VBar.btnGrip.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Radio.Color["scroll_bar"] )
	end
    
    local wide = table.Count(Radio.Settings.Preset)/4*30 > RadioScroll:GetTall() and 25 or 5
    
    local PresetList = vgui.Create( "DIconLayout", RadioScroll )
    PresetList:Dock( FILL )
    PresetList:SetSpaceY( 10 )
    PresetList:SetSpaceX( 10 )
	PresetList:SetSize(RadioScroll:GetWide(), self:GetTall()/2 - 10)

    for name, url in pairs(Radio.Settings.Preset) do

        local base = PresetList:Add("DPanel")
		base:SetPos(0,0)
        base:SetSize(PresetList:GetWide()/3.05-5, 90)
        base:SetContentAlignment(5)
		base.Paint = function(s, w, h) end
        
        local title = vgui.Create("DLabel", base)
		title:SetText(name)
		title:SetTextColor(Radio.Color["text"])
		title:SetFont("Radio.Video.Info")
		title:SetPos(0, 0)
        title:SetSize(base:GetWide(), 20)
        title:SetContentAlignment(8)

        local ChangeMusic = vgui.Create("DButton", base )		
        ChangeMusic:SetPos( 5, 30 )
        ChangeMusic:SetText( "Jouer" )
        ChangeMusic:SetToolTip( "Jouer" )
        ChangeMusic:SetFont("Radio.Button")
        ChangeMusic:SetTextColor( Radio.Color["text"] )
		ChangeMusic:SetSize( base:GetWide()/2 - 10 , 25 )
        ChangeMusic.Paint = function( self, w, h )
            draw.RoundedBox(5, 0, 0, w, h, Radio.Color["button_background"])
            
            if self:IsHovered() or self:IsDown() then
                draw.RoundedBox( 5, 0, 0, w, h, Radio.Color["button_hover"] )
            end
        end
		ChangeMusic.DoClick = function()
    		ent:StartMusicRadio(url)
		end
		
		local QueueMusic = vgui.Create("DButton", base )		
        QueueMusic:SetPos( base:GetWide()/2 + 5, 30 )
        QueueMusic:SetText( "Add to queue" )
        QueueMusic:SetToolTip( "Add to queue" )
        QueueMusic:SetFont("Radio.Button")
        QueueMusic:SetTextColor( Radio.Color["text"] )
		QueueMusic:SetSize( base:GetWide()/2 - 10, 25 )
        QueueMusic.Paint = function( self, w, h )
            draw.RoundedBox(5, 0, 0, w, h, Radio.Color["button_background"])
            
            if self:IsHovered() or self:IsDown() then
                draw.RoundedBox( 5, 0, 0, w, h, Radio.Color["button_hover"] )
            end
        end
        QueueMusic.DoClick = function()
			--ent:StartMusicRadio(type == 1 and v.id or v.permalink_url or "", ent)
        end
    end
end
vgui.Register("Radio_Preset", PANEL, "DPanel")