--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
local colorline_frame = Color( 255, 255, 255, 200 )
local colorbg_frame = Color(52, 55, 64, 200)

local colorline_button = Color( 255, 255, 255, 100 )
local colorbg_button = Color(33, 31, 35, 200)
local color_hover = Color(0, 0, 0, 100)

local color_button_scroll = Color( 255, 255, 255, 5)
local color_scrollbar = Color( 175, 175, 175, 150 )

local RadioScroll
function Radio.OpenWebBrowser(type, ent)
	local BrowserBase = vgui.Create( "DFrame" )
	BrowserBase:SetSize(ScrW()/2, ScrH()/2.5)
	BrowserBase:Center()
	BrowserBase:MakePopup()
	BrowserBase:SetDraggable( false ) 
	BrowserBase:ShowCloseButton( false ) 
	BrowserBase:SetTitle( " " )
	BrowserBase.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, colorbg_frame)

		surface.SetDrawColor( colorline_frame )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	BrowserBase.OnClose = function()
		if timer.Exists("Radio:Search") then
			timer.Destroy("Radio:Search")
		end
	end
	
    local Close = vgui.Create( "DButton", BrowserBase )		
	Close:SetPos( BrowserBase:GetWide() - 30, 5 )
	Close:SetText( "X" )
	Close:SetTextColor( color_white )
	Close:SetSize( 25, 25 )
	Close.Paint = function( self, w, h )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	Close.DoClick = function()
        BrowserBase:Close()
        Radio.OpenStreamMenu(ent)
	end

	local SetURL = vgui.Create( "DTextEntry", BrowserBase )
	SetURL:SetPos( BrowserBase:GetWide()/4, 5 )
	SetURL:SetSize( BrowserBase:GetWide()/2, 30 )
	SetURL:SetPlaceholderText(Radio.GetLanguage("Search"))
	SetURL:SetDrawLanguageID(false)
	function SetURL:OnEnter()
		Radio.GetSearch(type, self:GetValue(), BrowserBase, ent)
	end

	if istable(type == 1 and Radio.SearchYoutube or Radio.SearchSoundCloud) then
		Radio.ReloadMenu(BrowserBase, type == 1 and Radio.SearchYoutube or Radio.SearchSoundCloud, type, ent)
	end
	
end

function Radio.GetSearch(type, search, menu, ent)
	search = string.Replace(search, " ", "%20")
	if type == 1 then
		
		http.Fetch("https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&q="..search.."&key="..Radio.Settings.APIKey, 
			function( body, len, headers, code )
				local data = util.JSONToTable(body)
		
				if istable(data) and istable(data.items) then
					Radio.SearchYoutube = data.items
					Radio.ReloadMenu(menu, Radio.SearchYoutube, 1, ent)
				else
					Radio.Error(LocalPlayer(), Radio.GetLanguage("An error occurred while retrieving the data. Contact an administrator if this persists."))
					
					Radio.ReloadMenu(menu, {}, 2, ent, true)
				end
			end, 
			function( error )
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
					Radio.Error(LocalPlayer(), Radio.GetLanguage("An error occurred while retrieving the data. Contact an administrator if this persists."))
					
					Radio.ReloadMenu(menu, {}, 2, ent, true)
				end
			end, 
			function( error )
				Radio.Error(LocalPlayer(), string.format(Radio.GetLanguage("An error occurred while retrieving the data. Contact an administrator if this persists. Error : %s"), error))

				Radio.ReloadMenu(menu, {}, 2, ent, true)
			end
		)
	end	
end

local RadioScroll
function Radio.ReloadMenu(menu, data, type, ent, error)
	if !IsValid(menu) then return end

	if ispanel(RadioScroll) then
		RadioScroll:Remove()
	end

	RadioScroll = vgui.Create( "DScrollPanel", menu )
    RadioScroll:SetPos(5,50)
    RadioScroll:SetSize(menu:GetWide() - 10, menu:GetTall()-55)
    RadioScroll.VBar.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_hover )
    end
    RadioScroll.VBar.btnUp.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    RadioScroll.VBar.btnDown.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    RadioScroll.VBar.btnGrip.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_scrollbar )
	end

	if error then
		menu.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, colorbg_frame)

			surface.SetDrawColor( colorline_frame)
			surface.DrawOutlinedRect( 0, 0, w, h )

			draw.SimpleText(Radio.GetLanguage("An error occured. Check the message in chat"), "Radio.Menu", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		return
	end

	if table.Count(data) < 1 then
		menu.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, colorbg_frame)

			surface.SetDrawColor( colorline_frame)
			surface.DrawOutlinedRect( 0, 0, w, h )

			draw.SimpleText(Radio.GetLanguage("No result"), "Radio.Menu", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	else
		menu.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, colorbg_frame)

			surface.SetDrawColor( colorline_frame)
			surface.DrawOutlinedRect( 0, 0, w, h )
		end
	end

    local wide = table.Count(data)/4*30 > RadioScroll:GetTall() and 25 or 5
    
    local PresetList = vgui.Create( "DIconLayout", RadioScroll )
    PresetList:Dock( FILL )
    PresetList:SetSpaceY( 5 )
    PresetList:SetSpaceX( 5 )
	PresetList:SetSize(RadioScroll:GetWide() - wide, menu:GetTall()/2 - 10)

    for k, v in ipairs(data) do
        local ChangeMusic = PresetList:Add("DButton" )		
        ChangeMusic:SetPos( 0, 0 )
        ChangeMusic:SetText( type == 1 and v.snippet.title or v.title )
        ChangeMusic:SetToolTip( type == 1 and v.snippet.title or v.title )
        ChangeMusic:SetFont("Radio.Button")
        ChangeMusic:SetTextColor( color_white )
		ChangeMusic:SetSize( PresetList:GetWide()/4.1, 25 )
        ChangeMusic.Paint = function( self, w, h )
            local GetColorInner = draw.RoundedBox(0, 0, 0, w, h, colorbg_button)
        
            surface.SetDrawColor( colorline_button )
            surface.DrawOutlinedRect( 0, 0, w, h )
            
            if self:IsHovered() or self:IsDown() then
                draw.RoundedBox( 0, 0, 0, w, h, color_hover )
            end
        end
        ChangeMusic.DoClick = function()
            if type == 1 then
				Radio.StartMusic(v.id.videoId or "", ent)
				menu:Close()
				Radio.OpenStreamMenu(ent)
			elseif type == 2 then
				Radio.StartMusic(v.permalink_url or "", ent)
				menu:Close()
				Radio.OpenStreamMenu(ent)
			end
        end
    end
end