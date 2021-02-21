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

    local StationName = vgui.Create( "DLabel", self )
	StationName:SetPos( 0, 0 )
	StationName:SetText( Radio.GetLanguage("Station Name") )
	StationName:SetTextColor( Radio.Color["text"] )
	StationName:SetFont("Radio.Menu")
	StationName:SizeToContents()

	local NameEntry = vgui.Create( "DTextEntry", self )
	NameEntry:SetPos( 10 + StationName:GetWide(), 0 )
    NameEntry:SetSize( self:GetWide() - StationName:GetWide() - 20, 30 )
    NameEntry:SetDrawLanguageID(false)
    NameEntry:SetDrawBorder( false )
    NameEntry:SetDrawBackground( false )
    NameEntry:SetCursorColor( Radio.Color["text"] )
    NameEntry:SetPlaceholderColor( Radio.Color["text_placeholder"] )
    NameEntry:SetTextColor( Radio.Color["text"] )
	NameEntry:SetText(ent:GetNWString("Radio:StationName"))
	function NameEntry:OnEnter()
		net.Start("Radio:SetNameServer")
		net.WriteEntity(ent)
        net.WriteString(NameEntry:GetValue())
		net.SendToServer()
    end
    function NameEntry:Paint(w,h)
        if self:IsEditing() then
            draw.RoundedBox(10, 0, 0, w, h, Radio.Color["textentry_edit"])
        else
            draw.RoundedBox(10, 0, 0, w, h, Radio.Color["textentry_background"])
        end
        derma.SkinHook( "Paint", "TextEntry", self, w, h )
    end

	local Save = vgui.Create( "DButton", self )		
	Save:SetPos( self:GetWide() - self:GetWide()/5-5, 40 )
	Save:SetText( Radio.GetLanguage("Save") )
	Save:SetToolTip( Radio.GetLanguage("Save") )
	Save:SetFont("Radio.Button")
	Save:SetTextColor( Radio.Color["text"] )
	Save:SetSize( self:GetWide()/5-5, 25 )
	Save.Paint = function( self, w, h )
		draw.RoundedBox(5, 0, 0, w, h, Radio.Color["button_background"])
            
		if self:IsHovered() or self:IsDown() then
			draw.RoundedBox( 5, 0, 0, w, h, Radio.Color["button_hover"] )
		end
	end
	Save.DoClick = function()
		net.Start("Radio:SetNameServer")
		net.WriteEntity(ent)
        net.WriteString(NameEntry:GetValue())
		net.SendToServer()
	end

	local Viewer = vgui.Create( "DLabel", self )
	Viewer:SetPos( 0, 70 )
	Viewer:SetText( string.format(Radio.GetLanguage("Auditors : %i"), ent:GetNWInt("Radio:Viewer")) )
	Viewer:SetTextColor( Radio.Color["text"] )
	Viewer:SetFont("Radio.Menu")
	Viewer:SizeToContents()

	local voice = vgui.Create( "DCheckBoxLabel", self )
	voice:SetPos( 0, 100 ) 
	voice:SetText( Radio.GetLanguage("Transmit voice ?") )
	voice:SetTextColor(Radio.Color["text"])
	voice:SetFont("Radio.Menu")
	voice:SetValue( ent:GetNWBool("Radio:Voice") )
	function voice:OnChange(bVal)
		net.Start("Radio:TransmitVoice")
		net.WriteEntity(ent)
		net.WriteBool(bVal)
		net.SendToServer()
	end

end
vgui.Register("Radio_Server_Settings", PANEL, "DPanel")