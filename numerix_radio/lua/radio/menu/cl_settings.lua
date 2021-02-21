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

	self.Paint = function(s, w, h) end

	local Mixer = vgui.Create("DColorMixer", self)
	Mixer:SetPos(5, 5)					
	Mixer:SetSize(self:GetWide() - 10, self:GetTall()/1.4)
	Mixer:SetPalette(true)  			
	Mixer:SetAlphaBar(false) 			
	Mixer:SetWangs(false) 				
	Mixer:SetColor(string.ToColor(ent:GetNWString("Radio:Visual")))	

	local rainbow = vgui.Create( "DCheckBoxLabel", self )
	rainbow:SetPos( 5, 5 + self:GetTall()/1.4 ) 
	rainbow:SetText( Radio.GetLanguage("Rainbow mode ?") )
	rainbow:SetTextColor(Radio.Color["text"])
	rainbow:SetFont("Radio.Menu")
	rainbow:SetValue( ent:GetNWBool("Radio:Rainbow") )
	
	local Private
	local Buddy
	if FPP then
		Private = vgui.Create( "DCheckBoxLabel", self )
		Private:SetPos( 5, 5 + self:GetTall()/1.4 + rainbow:GetTall() ) 
		Private:SetText( Radio.GetLanguage("Private radio ?") )
		Private:SetTextColor(Radio.Color["text"])
		Private:SetFont("Radio.Menu")
		Private:SetValue( ent:GetNWBool("Radio:Private") )

		Buddy = vgui.Create( "DCheckBoxLabel", self )
		Buddy:SetPos( 5, 5 + self:GetTall()/1.4 + rainbow:GetTall() + Private:GetTall() ) 
		Buddy:SetText( Radio.GetLanguage("Allow buddy (FPP) to use radio ?") )
		Buddy:SetTextColor(Radio.Color["text"])
		Buddy:SetFont("Radio.Menu")
		Buddy:SetValue( ent:GetNWBool("Radio:PrivateBuddy") )
		Buddy.Think = function(self)
			if Private:GetChecked() then
				self:SetAlpha(255)
			else
				self:SetAlpha(0)
			end
		end
	end

	local Visual = vgui.Create( "DButton", self )		
	Visual:SetPos( 5, self:GetTall()-30 )
	Visual:SetText( "Save" )
	Visual:SetToolTip( "Save" )
	Visual:SetFont("Radio.Button")
	Visual:SetTextColor( Radio.Color["text"] )
	Visual:SetSize( self:GetWide()-10, 25 )
	Visual.Paint = function( self, w, h )
		draw.RoundedBox(5, 0, 0, w, h, Radio.Color["button_background"])
            
		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 5, 0, 0, w, h, Radio.Color["button_hover"] )
		end
	end
    Visual.DoClick = function()
		local color = Mixer:GetColor()
		
        net.Start("Radio:UpdateSettings")
		net.WriteEntity(ent)
		net.WriteColor(Color(color.r, color.g, color.b))
		net.WriteBool(rainbow:GetChecked() or false)
		net.WriteBool(FPP and Private:GetChecked() or false)
		net.WriteBool(FPP and Buddy:GetChecked() or false)
		net.SendToServer()
	end

end
vgui.Register("Radio_Settings", PANEL, "DPanel")