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
	local RadioContent = self
	
	local radio = Radio.ConnectedRadio

	self.Think = function()
		radio = Radio.ConnectedRadio
	end

    self.Paint = function(self, w, h) end

    local SetURL = vgui.Create( "DTextEntry", self )
	SetURL:SetPos( self:GetWide()/4, 10 )
	SetURL:SetSize( RadioContent:GetWide()/2, 30 )
	SetURL:SetPlaceholderText(Radio.GetLanguage("Search"))
	SetURL:SetDrawLanguageID(false)
	SetURL:SetDrawBorder( false )
	SetURL:SetDrawBackground( false )
	SetURL:SetCursorColor( Radio.Color["text"] )
	SetURL:SetPlaceholderColor( Radio.Color["text_placeholder"] )
	SetURL:SetTextColor( Radio.Color["text"] )
	function SetURL:OnEnter()
		Radio.GetSearch(type, self:GetValue(), RadioContent, ent)
	end
	function SetURL:Paint(w,h)
		if self:IsEditing() then
			draw.RoundedBox(10, 0, 0, w, h, Radio.Color["textentry_edit"])
		else
			draw.RoundedBox(10, 0, 0, w, h, Radio.Color["textentry_background"])
		end
		derma.SkinHook( "Paint", "TextEntry", self, w, h )
	end

	if istable(type == 1 and Radio.SearchYoutube or type == 2 and Radio.SearchSoundCloud) then
		Radio.ReloadMenu(RadioContent, type == 1 and Radio.SearchYoutube or type == 2 and Radio.SearchSoundCloud, type, ent)
	end
end
vgui.Register("Radio_Search", PANEL, "DPanel")

local function getinfoYT(video, menu, ent)
	http.Fetch("https://www.googleapis.com/youtube/v3/videos?part=contentDetails,snippet&id="..video.."&key="..Radio.Settings.APIKey, 
		function( body, len, headers, code )
			local data = util.JSONToTable(body)
	
			if istable(data) and istable(data.items) then
				Radio.SearchYoutube = data.items
				
				Radio.ReloadMenu(menu, Radio.SearchYoutube, 1, ent)
			else
				Radio.SearchYoutube = nil
				Radio.Error(LocalPlayer(), Radio.GetLanguage("An error occurred while retrieving the data. Contact an administrator if this persists."))
				
				Radio.ReloadMenu(menu, {}, 1, ent, true)
			end
		end, 
		function( error )
			Radio.SearchYoutube = nil
			Radio.Error(LocalPlayer(), string.format(Radio.GetLanguage("An error occurred while retrieving the data. Contact an administrator if this persists. Error : %s"), error))
			
			Radio.ReloadMenu(menu, {}, 1, ent, true)
		end
	)
end

local RadioScroll
function Radio.ReloadMenu(menu, data, type, ent, error)
	if !IsValid(menu) then return end
	
	if ispanel(RadioScroll) then
		RadioScroll:Remove()
	end

	RadioScroll = vgui.Create( "DScrollPanel", menu )
    RadioScroll:SetPos(5, 60)
	RadioScroll:SetSize(menu:GetWide() - 10, menu:GetTall() - 60)
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
	
	menu.Paint = function(self, w, h)
		if error then
			draw.SimpleText(Radio.GetLanguage("An error occured. Check the message in chat"), "Radio.Menu", w/2, h/2, Radio.Color["text"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		elseif table.Count(data) < 1 then
			draw.SimpleText(Radio.GetLanguage("No result"), "Radio.Menu", w/2, h/2, Radio.Color["text"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
	
	if error then return end
    
    local PresetList = vgui.Create( "DIconLayout", RadioScroll )
    PresetList:Dock( FILL )
    PresetList:SetSpaceY( 30 )
    PresetList:SetSpaceX( 10 )
	PresetList:SetSize(RadioScroll:GetWide(), menu:GetTall()/2 - 10)
	
	local foundCompatibleRes
	for k, v in ipairs(data) do
		local durationMusic = type == 1 and Radio.getDurationYT(v.contentDetails.duration) or v.duration/1000
		if durationMusic > Radio.Settings.MaxDuration or durationMusic <= 0 then continue end

		foundCompatibleRes = true
		local base = PresetList:Add("DPanel")
		base:SetPos(0,0)
		base:SetSize(PresetList:GetWide()/2.05-5, 90)
		base.Paint = function(s, w, h) end
		
		Radio.GetImage(type == 1 and v.snippet.thumbnails.default.url or v.artwork_url, v.id..".jpg", function(url, filename)
			local icon = vgui.Create("DImage", base)
			icon:SetPos(0, 0)
			icon:SetSize(base:GetWide()/5, base:GetTall())
			icon:SetImage(filename)
		end)
		
		local title = vgui.Create("DLabel", base)
		title:SetText(type == 1 and v.snippet.title or v.title)
		title:SetTextColor(Radio.Color["text"])
		title:SetFont("Radio.Video.Info")
		title:SetPos(base:GetWide()/5 + 10, 0)
		title:SetSize(base:GetWide() - base:GetWide()/5 - 10, 20)
		
		local author = vgui.Create("DLabel", base)
		author:SetText(type == 1 and v.snippet.channelTitle or v.user.username)
		author:SetTextColor(Radio.Color["text"])
		author:SetFont("Radio.Video.Info")
		author:SetPos(base:GetWide()/5 + 10, 20)
		author:SetSize(base:GetWide() - base:GetWide()/5 - 10, 20)
		
		local duration = vgui.Create("DLabel", base)
		duration:SetText(Radio.SecondsToClock(durationMusic))
		duration:SetTextColor(Radio.Color["text"])
		duration:SetFont("Radio.Video.Info")
		duration:SetPos(base:GetWide()/5 + 10, 40)
		duration:SetSize(base:GetWide() - base:GetWide()/5 - 10, 20)

        local ChangeMusic = vgui.Create("DButton", base )		
        ChangeMusic:SetPos( base:GetWide()/5 + 10, 65 )
        ChangeMusic:SetText( "Jouer" )
        ChangeMusic:SetToolTip( "Jouer" )
        ChangeMusic:SetFont("Radio.Button")
        ChangeMusic:SetTextColor( Radio.Color["text"] )
		ChangeMusic:SetSize( base:GetWide()/4, 25 )
        ChangeMusic.Paint = function( self, w, h )
            draw.RoundedBox(5, 0, 0, w, h, Radio.Color["button_background"])
            
            if self:IsHovered() or self:IsDown() then
                draw.RoundedBox( 5, 0, 0, w, h, Radio.Color["button_hover"] )
            end
        end
		ChangeMusic.DoClick = function()
    		ent:StartMusicRadio(type == 1 and v.id or v.permalink_url or "")
		end
		
		local QueueMusic = vgui.Create("DButton", base )		
        QueueMusic:SetPos( base:GetWide()/5 + base:GetWide()/4 + 25, 65 )
        QueueMusic:SetText( "Add to queue" )
        QueueMusic:SetToolTip( "Add to queue" )
        QueueMusic:SetFont("Radio.Button")
        QueueMusic:SetTextColor( Radio.Color["text"] )
		QueueMusic:SetSize( base:GetWide()/4, 25 )
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
	
	if foundCompatibleRes then return end
	menu.Paint = function(self, w, h)
		draw.SimpleText(Radio.GetLanguage("No result"), "Radio.Menu", w/2, h/2, Radio.Color["text"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function Radio.GetSearch(type, search, menu, ent)
	search = string.Replace(search, " ", "%20")
	if type == 1 then	
		http.Fetch("https://www.googleapis.com/youtube/v3/search?part=id&maxResults=50&q="..search.."&key="..Radio.Settings.APIKey, 
			function( body, len, headers, code )
				local data = util.JSONToTable(body)
		
				if istable(data) and istable(data.items) then
					Radio.SearchYoutube = data.items

					local id = ""
					for k, v in ipairs(Radio.SearchYoutube) do
						if !v.id or !v.id.videoId then continue end
						id = id..v.id.videoId..","
					end
					id = string.sub(id, 0,  string.len(id)-1)

					getinfoYT(id, menu, ent)
				else
					Radio.SearchYoutube = nil
					Radio.Error(LocalPlayer(), Radio.GetLanguage("An error occurred while retrieving the data. Contact an administrator if this persists."))
					
					Radio.ReloadMenu(menu, {}, 1, ent, true)
				end
			end, 
			function( error )
				Radio.SearchYoutube = nil
				Radio.Error(LocalPlayer(), string.format(Radio.GetLanguage("An error occurred while retrieving the data. Contact an administrator if this persists. Error : %s"), error))
				
				Radio.ReloadMenu(menu, {}, 1, ent, true)
			end
		)
	elseif type == 2 then
		http.Fetch("http://api.soundcloud.com/tracks.json?q='"..search.."'&client_id=93e33e327fd8a9b77becd179652272e2", 
			function( body, len, headers, code )
				local data = util.JSONToTable(body)
				
				if istable(data) then
					Radio.SearchSoundCloud = data
					Radio.ReloadMenu(menu, Radio.SearchSoundCloud, 2, ent)
				else
					Radio.SearchSoundCloud = nil
					Radio.Error(LocalPlayer(), Radio.GetLanguage("An error occurred while retrieving the data. Contact an administrator if this persists."))
					
					Radio.ReloadMenu(menu, {}, 2, ent, true)
				end
			end, 
			function( error )
				Radio.SearchSoundCloud = nil
				Radio.Error(LocalPlayer(), string.format(Radio.GetLanguage("An error occurred while retrieving the data. Contact an administrator if this persists. Error : %s"), error))

				Radio.ReloadMenu(menu, {}, 2, ent, true)
			end
		)
	end	

	if ispanel(RadioScroll) then
		RadioScroll:Remove()
	end

	menu.Paint = function(self, w, h)
	    draw.SimpleText("Recherche en cours...", "Radio.Menu", w/2, h/2, Radio.Color["text"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end