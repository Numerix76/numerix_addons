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

end
vgui.Register("Radio_PlayList", PANEL, "DPanel")