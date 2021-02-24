--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local PANEL = {}

function PANEL:Init()   
end

function PANEL:PerformLayout(width, height)
    self:SetSize(width, height)
end

function PANEL:MakeContent(ent, RadioBase)
    local Navigation = {}
    
    self.Paint = function(self, w, h)
        draw.RoundedBox(10, 0, 0, w, h, Radio.Color["frame_background"])
    end

    self.Scroll = vgui.Create( "DScrollPanel", self )
    self.Scroll:SetPos(5, 5)
	self.Scroll:SetSize(self:GetWide() - 10, self:GetTall() - 10)
    self.Scroll.VBar.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Radio.Color["scroll_background"] )
    end
    self.Scroll.VBar.btnUp.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, Radio.Color["scroll_button"] )
    end
    self.Scroll.VBar.btnDown.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, Radio.Color["scroll_button"] )
    end
    self.Scroll.VBar.btnGrip.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Radio.Color["scroll_bar"] )
	end

    local PresetList = vgui.Create( "DIconLayout", self.Scroll )
    PresetList:Dock( FILL )
    PresetList:SetSpaceX( 0 )
    PresetList:SetSpaceY( 10 )
	PresetList:SetSize(self.Scroll:GetWide(), self.Scroll:GetTall())

    local InitialPanel = false
    for k, v in ipairs( Radio.Settings.Navigation ) do

		if not v.Enabled or v.Visible and !v.Visible(LocalPlayer(), ent) then continue end

		local icon = Material( v.Icon )

		if string.sub(v.Icon, 1, 4) == "http" then
			Radio.GetImage(v.Icon, v.IconName, function(url, filename)
				v.Icon = filename
				icon = Material( v.Icon )
			end)
		end

		self.Nav_Button = PresetList:Add("DButton")
		self.Nav_Button:SetSize(self.Scroll:GetWide(), 50)
		self.Nav_Button:SetText(string.upper(v.Name))
        self.Nav_Button:SetTextColor( Radio.Color["text"] )
        self.Nav_Button:SetFont( "Radio.Button" )
		self.Nav_Button:SetTooltip(v.Desc or "")
		self.Nav_Button.Paint = function(self, w, h)            
            draw.RoundedBox(5, 0, 0, w, h, Radio.Color["button_background"])
            
            if self:IsHovered() or self:IsDown() or self.active then
                draw.RoundedBox( 5, 0, 0, w, h, Radio.Color["button_hover"] )
            end
			
			surface.SetMaterial( icon )
			surface.SetDrawColor( Radio.Color["image"] )
			surface.DrawTexturedRect( 10, h/2-15, 32, 32 )
		end

		self.Nav_Button.DoClick = function(obj)

			for _, button in ipairs( Navigation ) do
				button.active = false
			end

            obj.active = true
            
            if v.DoFunc then
                v.DoFunc(RadioBase:GetParent(), ent)
                return
            end

            if IsValid( Radio.RadioContent ) then
                Radio.RadioContent:Remove()
				Radio.RadioContent = vgui.Create(v.DoLoadPanel, RadioBase)
                Radio.RadioContent:SetPos(0, RadioBase:GetTall()/10)
                Radio.RadioContent:SetSize(RadioBase:GetWide(), RadioBase:GetTall() - RadioBase:GetTall()/5)
                Radio.RadioContent:MakeContent(ent, v.type or RadioBase)
			end

        end
        
		table.insert( Navigation, self.Nav_Button )
		if v.OnLoadInit and !InitialPanel then

			for _, button in ipairs( Navigation ) do
				button.active = false
            end
            
			self.Nav_Button.active = true
			InitialPanel = true
		end
	end
    
end
vgui.Register("Radio_Nav", PANEL, "DPanel")