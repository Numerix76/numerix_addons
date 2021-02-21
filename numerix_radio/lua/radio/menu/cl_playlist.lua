--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
-- NOT AVAILABLE IN THIS UPDATE



-- local PANEL = {}

-- function PANEL:Init()   
-- end

-- function PANEL:PerformLayout(width, height)
--     self:SetSize(width, height)
-- end

-- function PANEL:MakeContent(ent, type)
--     local radio = Radio.ConnectedRadio

-- 	self.Think = function()
-- 		radio = Radio.ConnectedRadio
-- 	end

--     self.Paint = function(s, w, h) end

--     local RadioScroll = vgui.Create( "DScrollPanel", self )
--     RadioScroll:SetPos(5, 60)
-- 	RadioScroll:SetSize(self:GetWide() - 10, self:GetTall() - 60)
--     RadioScroll.VBar.Paint = function( s, w, h )
--         draw.RoundedBox( 0, 0, 0, w, h, Radio.Color["scroll_background"] )
--     end
--     RadioScroll.VBar.btnUp.Paint = function( s, w, h ) 
--         draw.RoundedBox( 0, 0, 0, w, h, Radio.Color["scroll_button"] )
--     end
--     RadioScroll.VBar.btnDown.Paint = function( s, w, h ) 
--         draw.RoundedBox( 0, 0, 0, w, h, Radio.Color["scroll_button"] )
--     end
--     RadioScroll.VBar.btnGrip.Paint = function( s, w, h )
--         draw.RoundedBox( 0, 0, 0, w, h, Radio.Color["scroll_bar"] )
-- 	end
	
-- 	self.Paint = function(self, w, h)
-- 		-- if error then
-- 		-- 	draw.SimpleText(Radio.GetLanguage("An error occured. Check the message in chat"), "Radio.Menu", w/2, h/2, Radio.Color["text"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
-- 		-- elseif table.Count(data) < 1 then
-- 		-- 	draw.SimpleText(Radio.GetLanguage("No result"), "Radio.Menu", w/2, h/2, Radio.Color["text"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
-- 		-- end
-- 	end
    
--     local PresetList = vgui.Create( "DIconLayout", RadioScroll )
--     PresetList:Dock( FILL )
--     PresetList:SetSpaceY( 30 )
--     PresetList:SetSpaceX( 10 )
-- 	PresetList:SetSize(RadioScroll:GetWide(), self:GetTall()/2 - 10)

--     for id, url in ipairs(ent.Playlist) do
-- 		--local durationMusic = type == 1 and Radio.getDurationYT(v.contentDetails.duration) or v.duration/1000
-- 		--if durationMusic > Radio.Settings.MaxDuration or durationMusic <= 0 then continue end

-- 		--foundCompatibleRes = true
-- 		local base = PresetList:Add("DPanel")
-- 		base:SetPos(0,0)
-- 		base:SetSize(PresetList:GetWide()/2.05-5, 90)
-- 		base.Paint = function(s, w, h) end
		
-- 		-- Radio.GetImage(type == 1 and v.snippet.thumbnails.default.url or v.artwork_url, v.id..".jpg", function(url, filename)
-- 		-- 	local icon = vgui.Create("DImage", base)
-- 		-- 	icon:SetPos(0, 0)
-- 		-- 	icon:SetSize(base:GetWide()/5, base:GetTall())
-- 		-- 	icon:SetImage(filename)
-- 		-- end)
		
-- 		local title = vgui.Create("DLabel", base)
-- 		title:SetText("Titre")
-- 		title:SetTextColor(Radio.Color["text"])
-- 		title:SetFont("Radio.Video.Info")
-- 		title:SetPos(base:GetWide()/5 + 10, 0)
-- 		title:SetSize(base:GetWide() - base:GetWide()/5 - 10, 20)
		
-- 		local author = vgui.Create("DLabel", base)
-- 		author:SetText("Auteur")
-- 		author:SetTextColor(Radio.Color["text"])
-- 		author:SetFont("Radio.Video.Info")
-- 		author:SetPos(base:GetWide()/5 + 10, 20)
-- 		author:SetSize(base:GetWide() - base:GetWide()/5 - 10, 20)
		
-- 		local duration = vgui.Create("DLabel", base)
-- 		duration:SetText(Radio.SecondsToClock(10))
-- 		duration:SetTextColor(Radio.Color["text"])
-- 		duration:SetFont("Radio.Video.Info")
-- 		duration:SetPos(base:GetWide()/5 + 10, 40)
-- 		duration:SetSize(base:GetWide() - base:GetWide()/5 - 10, 20)

--         local ChangeMusic = vgui.Create("DButton", base )		
--         ChangeMusic:SetPos( base:GetWide()/5 + 10, 65 )
--         ChangeMusic:SetText( "Supprimer" )
--         ChangeMusic:SetToolTip( "Jouer" )
--         ChangeMusic:SetFont("Radio.Button")
--         ChangeMusic:SetTextColor( Radio.Color["text"] )
-- 		ChangeMusic:SetSize( base:GetWide()/4, 25 )
--         ChangeMusic.Paint = function( self, w, h )
--             draw.RoundedBox(5, 0, 0, w, h, Radio.Color["button_background"])
            
--             if self:IsHovered() or self:IsDown() then
--                 draw.RoundedBox( 5, 0, 0, w, h, Radio.Color["button_hover"] )
--             end
--         end
-- 		ChangeMusic.DoClick = function()
--     		net.Start("Radio:RemoveMusicPlaylist")
--             net.WriteEntity(ent)
--             net.WriteUInt(id, 16)
--             net.SendToServer()
-- 		end
	
-- 	end

-- end
-- vgui.Register("Radio_PlayList", PANEL, "DPanel")