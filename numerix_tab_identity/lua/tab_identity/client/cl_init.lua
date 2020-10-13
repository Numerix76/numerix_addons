--[[ TAB --------------------------------------------------------------------------------------

TAB made by Numerix (https://steamcommunity.com/id/numerix/) 

--------------------------------------------------------------------------------------------------]]
local colorline_frame = Color( 255, 255, 255, 100 )
local colorbg_frame = Color(52, 55, 64, 100)

local color_text = Color(255,255,255,255)


-----------------------------------------------------------------
--  TAB:Launch
-----------------------------------------------------------------
local blur = Material("pp/blurscreen")
local function blurPanel(p, a, h)
	local x, y = p:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.SetMaterial(blur)
	for i = 1, (h or 3) do
		blur:SetFloat("$blur", (i/3)*(a or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x*-1,y*-1,scrW,scrH)
	end
end

function TAB:Launch()
	local ply = LocalPlayer()

	if IsValid( TAB.Base ) then
		return
	end

	if TAB.Settings.HideHUD then
		hook.Add("HUDShouldDraw", "TAB.HideAllHUD", function()
			return false
		end)
	end

	gui.EnableScreenClicker(true)

    TAB.Base = vgui.Create("DFrame")
	TAB.Base:SetTitle("")
	TAB.Base:SetDraggable( false )
	TAB.Base:ShowCloseButton( false )
	TAB.Base:SetSize(ScrW(), ScrH())
	TAB.Base:Center()

	if string.sub(TAB.Settings.Background, 1, 4) == "http" then
		TAB.GetImage(TAB.Settings.Background, TAB.Settings.BackgroundName, function(url, filename)
			local background = Material(filename)
			TAB.Base.Paint = function(self, w, h)
				surface.SetDrawColor(color_white)
				surface.SetMaterial(background)
				surface.DrawTexturedRect(0, 0, w, h)
			end
		end)
	elseif TAB.Settings.Background == "color" then 
		TAB.Base.Paint = function(self, w, h)
			surface.SetDrawColor(TAB.Settings.BackgroundColor or color_white)
			surface.DrawRect(0, 0, w, h)
		end
	elseif TAB.Settings.Background == "blur" then
		TAB.Base.Paint = function(self, w, h)
			blurPanel(self, 4)
		end
	elseif TAB.Settings.Background != "" then
		local background = Material(TAB.Settings.Background)
		TAB.Base.Paint = function(self, w, h)
			surface.SetDrawColor(color_white)
			surface.SetMaterial(background)
			surface.DrawTexturedRect(0, 0, w, h)
		end
	else
		TAB.Base.Paint = function(self, w, h) end
	end

	TAB.Menu = vgui.Create("DPanel", TAB.Base)
	TAB.Menu:SetSize(ScrW()/1.02, ScrH()/1.2)
	TAB.Menu:Center()
    TAB.Menu.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, colorbg_frame)
		surface.SetDrawColor( colorline_frame )
		surface.DrawOutlinedRect( 0, 0, w, h )

		draw.SimpleText(GetHostName(), "TAB.Info.Text", w/2, 5, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(TAB.GetLanguage("Number of players").. " : "..player.GetCount().."/"..game.MaxPlayers(), "TAB.Info.Text", w/2, 40, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	if DarkRP and !DarkRP.disabledDefaults["modules"]["fadmin"] then
		local Setting = Material("numerix_tab/settings.png")
		local Back = Material("numerix_tab/back.png")
		if TAB.Settings.Staff then
			TAB.Setting = vgui.Create( "DButton", TAB.Menu )
			TAB.Setting:SetText( "" )			
			TAB.Setting:SetPos( 10, 10 )				
			TAB.Setting:SetSize( 64, 64 )	
			TAB.Setting:SetToolTip(TAB.GetLanguage("Settings"))
			TAB.Setting.Paint = function(self, w, h)
				if IsValid(TAB.ServerActionsCat) or IsValid(TAB.InfoPanel1) then	
					surface.SetMaterial( Back )
					surface.SetDrawColor( color_white )
					surface.DrawTexturedRect( 0, 0, 64, 64 )
				else
					surface.SetMaterial( Setting )
					surface.SetDrawColor( color_white )
					surface.DrawTexturedRect( 0, 0, 64, 64 )
				end
			end
			TAB.Setting.DoClick = function()
				if IsValid( TAB.Content ) then
					TAB.Content:Remove()
					TAB.Content = vgui.Create("DPanelList", TAB.Menu)
					TAB.Content:SetSize(TAB.Menu:GetWide()/1.02, TAB.Menu:GetTall()-130)
					TAB.Content:SetPos(TAB.Menu:GetWide()/100,100)
					TAB.Content.Paint = function(self, w, h) end
				end
				if !IsValid(TAB.ServerActionsCat) and !IsValid(TAB.InfoPanel1) then
					vgui.Create("TAB_Tab_Settings", TAB.Content)
					TAB.Setting:SetToolTip(TAB.GetLanguage("Players List"))
				else
					vgui.Create("TAB_Tab_Home", TAB.Content)
					TAB.Setting:SetToolTip(TAB.GetLanguage("Settings"))
				end
			end
		end
		
		local CleanUP = Material("numerix_tab/cleanup.png")
		if FAdmin.Access.PlayerHasPrivilege(ply, "CleanUp") then
			TAB.CleanUP = vgui.Create( "DButton", TAB.Menu )
			TAB.CleanUP:SetText( "" )			
			TAB.CleanUP:SetPos( TAB.Menu:GetWide()-100, 10 )				
			TAB.CleanUP:SetSize( 64, 64 )	
			TAB.CleanUP:SetToolTip("CleanUp")	
			TAB.CleanUP.Paint = function(self, w, h)	
				surface.SetMaterial( CleanUP )
				surface.SetDrawColor( color_white )
				surface.DrawTexturedRect( 0, 0, 64, 64 )
			end
			TAB.CleanUP.DoClick = function()
				if ply:IsValid() then
					RunConsoleCommand("gmod_admin_cleanup")
				end
			end
		end

		local StopSound = Material("numerix_tab/stopsound.png")
		if FAdmin.Access.PlayerHasPrivilege(ply, "CleanUp") then
			TAB.StopSound = vgui.Create( "DButton", TAB.Menu )
			TAB.StopSound:SetText( "" )			
			TAB.StopSound:SetPos( TAB.Menu:GetWide()-100-75, 10 )				
			TAB.StopSound:SetSize( 64, 64 )	
			TAB.StopSound:SetToolTip("StopSounds")	
			TAB.StopSound.Paint = function(self, w, h)
				surface.SetMaterial( StopSound )
				surface.SetDrawColor( color_white )
				surface.DrawTexturedRect( 0, 0, 64, 64 )
			end
			TAB.StopSound.DoClick = function()
				if ply:IsValid() then
					RunConsoleCommand("_FAdmin", "StopSounds")
				end
			end
		end

		local ClearDecals = Material("numerix_tab/cleardecals.png")
		if FAdmin.Access.PlayerHasPrivilege(ply, "CleanUp") then
			TAB.ClearDecals = vgui.Create( "DButton", TAB.Menu )
			TAB.ClearDecals:SetText( "" )			
			TAB.ClearDecals:SetPos( TAB.Menu:GetWide()-100-74*2, 10 )				
			TAB.ClearDecals:SetSize( 64, 64 )	
			TAB.ClearDecals:SetToolTip("ClearDecals")	
			TAB.ClearDecals.Paint = function(self, w, h)	
				surface.SetMaterial( ClearDecals )
				surface.SetDrawColor( color_white )
				surface.DrawTexturedRect( 0, 0, 64, 64 )
			end
			TAB.ClearDecals.DoClick = function()
				if ply:IsValid() then
					RunConsoleCommand("_FAdmin", "ClearDecals")
				end
			end
		end
	end

	if not IsValid( TAB.Content ) then
		TAB.Content = vgui.Create("DPanelList", TAB.Menu)
		TAB.Content:SetSize(TAB.Menu:GetWide()/1.02, TAB.Menu:GetTall()-130)
		TAB.Content:SetPos(TAB.Menu:GetWide()/100,100)
		TAB.Content.Paint = function(self, w, h) end
	end
	vgui.Create("TAB_Tab_Home", TAB.Content)	
end
-----------------------------------------------------------------
--  Keybinds
-----------------------------------------------------------------
hook.Add("ScoreboardShow", "aaaNumerix_ShowTab", function()
	TAB:Launch()
	return false
end)


hook.Add("ScoreboardHide", "Numerix_HideTab", function()
	if IsValid(TAB.Base) then
		TAB.Base:Close()
	end

	hook.Remove("HUDShouldDraw", "TAB.HideAllHUD")

	gui.EnableScreenClicker(false)
end)
		