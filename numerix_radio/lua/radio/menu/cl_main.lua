--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local PANEL = {}

function PANEL:Init()   
end

function PANEL:PerformLayout(width, height)
    self:SetSize(width, height)
end

function PANEL:MakeContent(ent)
	local RadioMenu = self:GetParent():GetParent() 
	local RadioContent = self

	local radio = ent:GetControlerRadio()

	self.Think = function()
		radio = ent:GetControlerRadio()
	end

    RadioContent.Paint = function(self, w, h) end

    local Playing = vgui.Create( "DLabel", RadioContent )
	Playing:SetPos( 10, 40 )
	Playing:SetSize( RadioContent:GetWide()/2-25, 50 )
	Playing:SetText( Radio.GetLanguage("Now Playing :") )
	Playing:SetTextColor(Radio.Color["text"])
	Playing:SetFont("Radio.Menu")
	Playing.Think = function(self)
		if ent.Playing then
			self:SetAlpha(255)
		else
			self:SetAlpha(0)
		end
	end

	local Title = vgui.Create( "DLabel", RadioContent )
	Title:SetPos( 20, 70 )
	Title:SetSize( RadioContent:GetWide()/2-25, 50 )
	Title:SetText( Radio.GetLanguage("Title : ")..radio:GetNWString("Radio:Title") )
	Title:SetTextColor(Radio.Color["text"])
	Title:SetFont("Radio.Menu")
	Title.Think = function(self)
		if ent.Playing then
			if radio:IsPlayingLive() then
				self:SetText( Radio.GetLanguage("Radio Internet") )
			else
				self:SetText( Radio.GetLanguage("Title : ")..radio:GetNWString("Radio:Title") )
			end

			self:SetAlpha(255)
		else
			self:SetAlpha(0)
		end
	end

	local Author = vgui.Create( "DLabel", RadioContent )
	Author:SetPos( 20, 90 )
	Author:SetSize( RadioContent:GetWide()/2-25, 50 )
	Author:SetText( Radio.GetLanguage("Author : ")..radio:GetNWString("Radio:Author") )
	Author:SetTextColor(Radio.Color["text"])
	Author:SetFont("Radio.Menu")
	Author.Think = function(self)
		if ent.Playing and !radio:IsPlayingLive() then
			self:SetText( Radio.GetLanguage("Author : ")..radio:GetNWString("Radio:Author") )

			self:SetAlpha(255)
		else
			self:SetAlpha(0)
		end
	end
	
	local SetURL
	if (ent.IsServer and !Radio.Settings.ActivePresetOnlyServer) or ( ( ent:IsCarRadio() or ent.ENTRadio or ent.SWEPRadio ) and !Radio.Settings.ActivePresetOnlyRadio ) then
		SetURL = vgui.Create( "DTextEntry", RadioContent )
		SetURL:SetPos( 5, 10 )
		SetURL:SetSize( RadioContent:GetWide()/2-10, 30 )
		SetURL:SetPlaceholderText("https://gmod-radio-numerix.mtxserv.com/exemple/Dennis%20Lloyd%20-%20NEVERMIND.mp3")
		SetURL:SetDrawLanguageID(false)
		SetURL:SetDrawBorder( false )
		SetURL:SetDrawBackground( false )
		SetURL:SetCursorColor( Radio.Color["text"] )
		SetURL:SetPlaceholderColor( Radio.Color["text_placeholder"] )
		SetURL:SetTextColor( Radio.Color["text"] )
		function SetURL:OnEnter()
			local url = self:GetValue()
			url = string.gsub(url, ":[:%d]+", "")
			url = string.Replace(url, " ", "")
			ent:StartMusicRadio(url)

			if IsValid(ServerList) then
				for k, line in pairs( ServerList:GetLines() ) do
					line:SetColumnText( 1, Radio.GetLanguage("No") )
				end
			end
		end
		function SetURL:Paint(w,h)
			if self:IsEditing() then
				draw.RoundedBox(10, 0, 0, w, h, Radio.Color["textentry_edit"])
			else
				draw.RoundedBox(10, 0, 0, w, h, Radio.Color["textentry_background"])
			end
            derma.SkinHook( "Paint", "TextEntry", self, w, h )
		end
	end

	if !ent.IsServer then
		local connect = vgui.Create("Radio_Connect", RadioContent)
		connect:SetPos(RadioContent:GetWide()/2, 10)
		connect:SetSize(RadioContent:GetWide()/2 - 5, RadioContent:GetTall() - 10)
		connect:MakeContent(ent)
	else
		local server_settings = vgui.Create("Radio_Server_Settings", RadioContent)
		server_settings:SetPos(RadioContent:GetWide()/2, 10)
		server_settings:SetSize(RadioContent:GetWide()/2 - 5, RadioContent:GetTall() - 10)
		server_settings:MakeContent(ent)
	end
end
vgui.Register("Radio_Main", PANEL, "DPanel")