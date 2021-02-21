--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
function Radio.OpenStreamMenu()
	
	if IsValid(RadioBase) then
		RadioBase:Close()
	end

    local ent =  net.ReadEntity()
	local radio = ent:GetControlerRadio()

	local RadioMenu = vgui.Create( "DFrame" )
	RadioMenu:SetSize(ScrW(), ScrH())
	RadioMenu:Center()
	RadioMenu:MakePopup()
	RadioMenu:SetDraggable( false ) 
	RadioMenu:ShowCloseButton( false ) 
	RadioMenu:SetTitle( " " )
	RadioMenu.Paint = function() end
	RadioMenu.Think = function ()
		radio = ent:GetControlerRadio()
	end

    local RadioBase = vgui.Create( "DPanel", RadioMenu )
	RadioBase:SetSize(ScrW()/1.5, ScrH()/1.5)
	RadioBase:CenterHorizontal(0.6)
	RadioBase:CenterVertical(0.5)
	RadioBase.Paint = function( self, w, h )	
		draw.RoundedBox(10, 0, 0, w, h, Radio.Color["frame_background"])
		draw.RoundedBoxEx(10, 0, 0, w, h/10, Radio.Color["frame_top"], true, true)
		
		draw.SimpleText(Radio.GetLanguage("Radio management"), "Radio.Menu", w/2, h/10/2, Radio.Color["text"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local Close = vgui.Create( "DButton", RadioBase )		
	Close:SetPos( RadioBase:GetWide() - 35, RadioBase:GetTall()/10/2 - 25/2 )
	Close:SetText( "X" )
	Close:SetTextColor( Radio.Color["text"] )
	Close:SetFont("Radio.Button")
	Close:SetSize( 25, 25 )
	Close.Paint = function( self, w, h ) end
	Close.DoClick = function()
        RadioMenu:Close()
	end

	local RadioNav = vgui.Create("Radio_Nav", RadioMenu)
	RadioNav:SetSize(RadioBase:GetWide()/3.5, RadioBase:GetTall())
	RadioNav:CenterHorizontal(0.15)
	RadioNav:CenterVertical(0.5)
	RadioNav:MakeContent(ent, RadioBase)
	
	for k, v in ipairs( Radio.Settings.Navigation ) do
		if v.OnLoadInit then
			Radio.RadioContent = vgui.Create(v.DoLoadPanel, RadioBase)
			Radio.RadioContent:SetPos(0, RadioBase:GetTall()/10)
			Radio.RadioContent:SetSize(RadioBase:GetWide(), RadioBase:GetTall() - RadioBase:GetTall()/5)
			Radio.RadioContent:MakeContent(ent, v.type or RadioBase)
			
			break
		end
	end

	local x, y = Radio.RadioContent:GetPos()
	local RadioFoot = vgui.Create("Radio_Foot", RadioBase)
	RadioFoot:SetPos(0, y + Radio.RadioContent:GetTall() + 10)
	RadioFoot:SetSize(RadioBase:GetWide(), RadioBase:GetTall() - (y + Radio.RadioContent:GetTall() + 10 ) )
	RadioFoot:MakeContent(ent)
end
net.Receive("Radio:OpenStreamMenu", Radio.OpenStreamMenu)