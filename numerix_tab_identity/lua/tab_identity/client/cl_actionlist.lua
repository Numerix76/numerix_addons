--[[ TAB --------------------------------------------------------------------------------------

TAB made by Numerix (https://steamcommunity.com/id/numerix/) 

--------------------------------------------------------------------------------------------------]]

TAB.ActionButtons = {}


hook.Add("DarkRPFinishedLoading", "DarkRPFinishedLoading:LoadTAB", function()
	function TAB:AddActionButton(Name, Image, color, Visible, Action, OnButtonCreated)
		table.insert(TAB.ActionButtons, {TYPE = "PlayerActions", Name = Name, Image = Image, color = color, Visible = Visible, Action = Action, OnButtonCreated = OnButtonCreated})
	end

	local ContinueNewGroup
	local EditGroups

	local function RetrievePRIVS(len)
		FAdmin.Access.Groups = net.ReadTable()

		for k, v in pairs(FAdmin.Access.Groups) do
			if CAMI.GetUsergroup(k) then continue end

			CAMI.RegisterUsergroup({
				Name = k,
				Inherits = FAdmin.Access.ADMIN[v.ADMIN]
			}, "FAdmin")
		end

		-- Remove any groups that are removed from FAdmin from CAMI.
		for k in pairs(CAMI.GetUsergroups()) do
			if FAdmin.Access.Groups[k] then continue end

			CAMI.UnregisterUsergroup(k, "FAdmin")
		end
	end
	net.Receive("FADMIN_SendGroups", RetrievePRIVS)

	local function addPriv(um)
		local group = um:ReadString()
		FAdmin.Access.Groups[group] = FAdmin.Access.Groups[group] or {}
		FAdmin.Access.Groups[group].PRIVS[um:ReadString()] = true
	end
	usermessage.Hook("FAdmin_AddPriv", addPriv)

	local function removePriv(um)
		FAdmin.Access.Groups[um:ReadString()].PRIVS[um:ReadString()] = nil
	end
	usermessage.Hook("FAdmin_RemovePriv", removePriv)

	local function addGroupUI(ply, func)
		Derma_StringRequest("Set name",
		"What will be the name of the new group?",
		"",
		function(text)
			if text == "" then return end
			Derma_Query("On what access will this team be based? (the new group will inherit all the privileges from the group)", "Admin access",
				"user", function() ContinueNewGroup(ply, text, 0, func) end,
				"admin", function() ContinueNewGroup(ply, text, 1, func) end,
				"superadmin", function() ContinueNewGroup(ply, text, 2, func) end)
		end)
	end
	
	TAB:AddActionButton("Set access", "fadmin/icons/access", Color(155, 0, 0, 255),
    function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "SetAccess") or LocalPlayer():IsSuperAdmin() end, function(ply)
        local menu = DermaMenu()

        local Padding = vgui.Create("DPanel")
        Padding:SetPaintBackgroundEnabled(false)
        Padding:SetSize(1,5)
        menu:AddPanel(Padding)

        local Title = vgui.Create("DLabel")
        Title:SetText("  Set access:\n")
        Title:SetFont("UiBold")
        Title:SizeToContents()
        Title:SetTextColor(color_black)

        menu:AddPanel(Title)

        for k in SortedPairsByMemberValue(FAdmin.Access.Groups, "ADMIN", true) do
            menu:AddOption(k, function()
                if not IsValid(ply) then return end
                RunConsoleCommand("_FAdmin", "setaccess", ply:UserID(), k)
            end)
        end

        menu:AddOption("New...", function() addGroupUI(ply) end)
        menu:Open()
	end)

	ContinueNewGroup = function(ply, name, admin_access, func)
		if IsValid(ply) then
			RunConsoleCommand("_FAdmin", "setaccess", ply:UserID(), name, admin_access)
		else
			RunConsoleCommand("_FAdmin", "AddGroup", name, admin_access)
		end
	
		if func then
			func(name, admin_access)
		end
	end

	TAB:AddActionButton("Kick", "fadmin/icons/kick", nil, function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "Kick", ply) end, function(ply)
        TAB.OpenKickDialog(ply:Name())
	end)
	
	TAB:AddActionButton("Ban", "fadmin/icons/ban", nil, function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "Ban", ply) end, function(ply)
        TAB.OpenBanDialog(ply:Name())
	end)

	TAB:AddActionButton(function(ply)
        if ply:FAdmin_GetGlobal("FAdmin_chatmuted") then return "Unmute chat" end
        return "Mute chat"
    end, function(ply)
        if ply:FAdmin_GetGlobal("FAdmin_chatmuted") then return "fadmin/icons/chatmute" end
        return "fadmin/icons/chatmute", "fadmin/icons/disable"
    end, Color(255, 130, 0, 255),

    function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "Chatmute", ply) end, function(ply, button)
        if not ply:FAdmin_GetGlobal("FAdmin_chatmuted") then
            FAdmin.PlayerActions.addTimeMenu(function(secs)
                RunConsoleCommand("_FAdmin", "chatmute", ply:UserID(), secs)
                button:SetImage2("null")
                button:SetText("Unmute chat")
                button:GetParent():InvalidateLayout()
            end)
        else
            RunConsoleCommand("_FAdmin", "UnChatmute", ply:UserID())
        end

        button:SetImage2("fadmin/icons/disable")
        button:SetText("Mute chat")
        button:GetParent():InvalidateLayout()
	end)

	-- Warrant
	TAB:AddActionButton("Warrant", "fadmin/icons/message", Color(0, 0, 200, 255),
		function(ply) return LocalPlayer():isCP() end,
		function(ply, button)
			Derma_StringRequest("Warrant reason", "Enter the reason for the warrant", "", function(Reason)
				RunConsoleCommand("darkrp", "warrant", ply:UserID(), Reason)
			end)
		end
	)

	--wanted
	TAB:AddActionButton(function(ply)
		return ((ply:getDarkRPVar("wanted") and "Unw") or "W") .. "anted"
	end,
	function(ply) return "fadmin/icons/jail", ply:getDarkRPVar("wanted") and "fadmin/icons/disable" end,
	Color(0, 0, 200, 255),
	function(ply) return LocalPlayer():isCP() end,
	function(ply, button)
		if not ply:getDarkRPVar("wanted") then
			Derma_StringRequest("wanted reason", "Enter the reason to arrest this player", "", function(Reason)
				RunConsoleCommand("darkrp", "wanted", ply:UserID(), Reason)
			end)
		else
			RunConsoleCommand("darkrp", "unwanted", ply:UserID())
		end
	end
	)

	local function teamban(ply, button)
		local menu = DermaMenu()

		local Padding = vgui.Create("DPanel")
		Padding:SetPaintBackgroundEnabled(false)
		Padding:SetSize(1,5)
		menu:AddPanel(Padding)

		local Title = vgui.Create("DLabel")
		Title:SetText("  Jobs:\n")
		Title:SetFont("UiBold")
		Title:SizeToContents()
		Title:SetTextColor(color_black)
		menu:AddPanel(Title)

		local command = "teamban"
		local uid = ply:UserID()
		for k, v in SortedPairsByMemberValue(RPExtraTeams, "name") do
			local submenu = menu:AddSubMenu(v.name)
			submenu:AddOption("2 minutes",     function() RunConsoleCommand("darkrp", command, uid, k, 120)  end)
			submenu:AddOption("Half an hour",  function() RunConsoleCommand("darkrp", command, uid, k, 1800) end)
			submenu:AddOption("An hour",       function() RunConsoleCommand("darkrp", command, uid, k, 3600) end)
			submenu:AddOption("Until restart", function() RunConsoleCommand("darkrp", command, uid, k, 0)    end)
		end
		menu:Open()
	end

	TAB:AddActionButton("Ban from job", "fadmin/icons/changeteam", Color(200, 0, 0, 255),
		function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "DarkRP_AdminCommands", ply) end, teamban)
		
	local function teamunban(ply, button)
		local menu = DermaMenu()

		local Padding = vgui.Create("DPanel")
		Padding:SetPaintBackgroundEnabled(false)
		Padding:SetSize(1,5)
		menu:AddPanel(Padding)

		local Title = vgui.Create("DLabel")
		Title:SetText("  Jobs:\n")
		Title:SetFont("UiBold")
		Title:SizeToContents()
		Title:SetTextColor(color_black)
		menu:AddPanel(Title)

		local command = "teamunban"
		local uid = ply:UserID()
		for k, v in SortedPairsByMemberValue(RPExtraTeams, "name") do
			menu:AddOption(v.name, function() RunConsoleCommand("darkrp", command, uid, k) end)
		end
		menu:Open()
	end
		
	TAB:AddActionButton("Unban from job", function() return "fadmin/icons/changeteam", "fadmin/icons/disable" end, Color(200, 0, 0, 255),
	function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "DarkRP_AdminCommands", ply) end, teamunban)

	TAB:AddActionButton(function(ply)
        if ply:FAdmin_GetGlobal("FAdmin_frozen") then return "Unfreeze" end
        return "Freeze"
    end, function(ply)
        if ply:FAdmin_GetGlobal("FAdmin_frozen") then return "fadmin/icons/freeze", "fadmin/icons/disable" end
        return "fadmin/icons/freeze"
    end, Color(255, 130, 0, 255),

    function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "Freeze", ply) end, function(ply, button)
        if not ply:FAdmin_GetGlobal("FAdmin_frozen") then
            FAdmin.PlayerActions.addTimeMenu(function(secs)
                RunConsoleCommand("_FAdmin", "freeze", ply:UserID(), secs)
                button:SetImage2("fadmin/icons/disable")
                button:SetText("Unfreeze")
                button:GetParent():InvalidateLayout()
            end)
        else
            RunConsoleCommand("_FAdmin", "unfreeze", ply:UserID())
        end

        button:SetImage2("null")
        button:SetText("Freeze")
        button:GetParent():InvalidateLayout()
	end)

	local function GiveWeaponGui(ply)
		local frame = vgui.Create("DFrame")
		frame:SetTitle("Give weapon")
		frame:SetSize(ScrW() / 2, ScrH() - 50)
		frame:Center()
		frame:SetVisible(true)
		frame:MakePopup()
	
		local WeaponMenu = vgui.Create("FAdmin_weaponPanel", frame)
		WeaponMenu:StretchToParent(0,25,0,0)
	
		function WeaponMenu:DoGiveWeapon(SpawnName, IsAmmo)
			if not ply:IsValid() then return end
			local giveWhat = (IsAmmo and "ammo") or "weapon"
	
			RunConsoleCommand("FAdmin", "give" .. giveWhat, ply:UserID(), SpawnName)
		end
	
		WeaponMenu:BuildList()
	end
	
	TAB:AddActionButton("Give weapon(s)", "fadmin/icons/weapon", Color(255, 130, 0, 255),

    function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "giveweapon") end, function(ply, button)
        GiveWeaponGui(ply)
	end)

	TAB:AddActionButton(function(ply)
        if ply:FAdmin_GetGlobal("FAdmin_godded") then return "Ungod" end
        return "God"
    end, function(ply)
        if ply:FAdmin_GetGlobal("FAdmin_godded") then return "fadmin/icons/god", "fadmin/icons/disable" end
        return "fadmin/icons/god"
    end, Color(255, 130, 0, 255),

    function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "God") end, function(ply, button)
        if not ply:FAdmin_GetGlobal("FAdmin_godded") then
            RunConsoleCommand("_FAdmin", "god", ply:UserID())
        else
            RunConsoleCommand("_FAdmin", "ungod", ply:UserID())
        end

        if not ply:FAdmin_GetGlobal("FAdmin_godded") then button:SetImage2("fadmin/icons/disable") button:SetText("Ungod") button:GetParent():InvalidateLayout() return end
        button:SetImage2("null")
        button:SetText("God")
        button:GetParent():InvalidateLayout()
	end)

	TAB:AddActionButton("Set health", "icon16/heart.png", Color(255, 130, 0, 255),
    function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "SetHealth", ply) end,
    function(ply, button)
        --Do nothing when the button has been clicked
    end,
    function(ply, button) -- Create the Wang when the mouse is pressed
        button.OnMousePressed = function()
            local window = Derma_StringRequest("Select health", "What do you want the health of the person to be?", "",
                function(text)
                    local health = tonumber(text or 100) or 100
                    RunConsoleCommand("_fadmin", "SetHealth", ply:UserID(), health)
                end
            )

            -- The user is usually holding tab when clicking health, so fix the focus
            window:RequestFocus()
        end
	end)

	TAB:AddActionButton(function(ply) return (ply:FAdmin_GetGlobal("FAdmin_ignited") and "Extinguish") or "Ignite" end,
    function(ply) local disabled = (ply:FAdmin_GetGlobal("FAdmin_ignited") and "fadmin/icons/disable") or nil return "fadmin/icons/ignite", disabled end,
    Color(255, 130, 0, 255),
    function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "Ignite", ply) end,
    function(ply, button)
        if not ply:FAdmin_GetGlobal("FAdmin_ignited") then
            RunConsoleCommand("_FAdmin", "ignite", ply:UserID())
            button:SetImage2("fadmin/icons/disable")
            button:SetText("Extinguish")
            button:GetParent():InvalidateLayout()
        else
            RunConsoleCommand("_FAdmin", "unignite", ply:UserID())
            button:SetImage2("null")
            button:SetText("Ignite")
            button:GetParent():InvalidateLayout()
        end
	end)

	TAB:AddActionButton(function(ply)
        if ply:FAdmin_GetGlobal("fadmin_jailed") then return "Unjail" end
        return "Jail"
    end,
    function(ply)
        if ply:FAdmin_GetGlobal("fadmin_jailed") then return "fadmin/icons/jail", "fadmin/icons/disable" end
        return "fadmin/icons/jail"
    end,
    Color(255, 130, 0, 255),
    function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "Jail", ply) end,
    function(ply, button)
        if ply:FAdmin_GetGlobal("fadmin_jailed") then RunConsoleCommand("_FAdmin", "unjail", ply:UserID()) button:SetImage2("null") button:SetText("Jail") button:GetParent():InvalidateLayout() return end

        local menu = DermaMenu()

        local Padding = vgui.Create("DPanel")
        Padding:SetPaintBackgroundEnabled(false)
        Padding:SetSize(1,5)
        menu:AddPanel(Padding)

        local Title = vgui.Create("DLabel")
        Title:SetText("  Jail Type:\n")
        Title:SetFont("UiBold")
        Title:SizeToContents()
        Title:SetTextColor(color_black)

        menu:AddPanel(Title)

        for k, v in pairs(FAdmin.PlayerActions.JailTypes) do
            if v == "Unjail" then continue end
            FAdmin.PlayerActions.addTimeSubmenu(menu, v .. " jail",
                function()
                    RunConsoleCommand("_FAdmin", "Jail", ply:UserID(), k)
                    button:SetText("Unjail") button:GetParent():InvalidateLayout()
                    button:SetImage2("fadmin/icons/disable")
                end,
                function(secs)
                    RunConsoleCommand("_FAdmin", "Jail", ply:UserID(), k, secs)
                    button:SetText("Unjail")
                    button:GetParent():InvalidateLayout()
                    button:SetImage2("fadmin/icons/disable")
                end
            )
        end

        menu:Open()
	end)

	TAB:AddActionButton(function(ply)
        if ply:FAdmin_GetGlobal("fadmin_ragdolled") then return "Unragdoll" end
        return "Ragdoll"
    end,
    function(ply)
        if ply:FAdmin_GetGlobal("fadmin_ragdolled") then return "fadmin/icons/ragdoll", "fadmin/icons/disable" end
        return "fadmin/icons/ragdoll"
    end,
    Color(255, 130, 0, 255),
    function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "Ragdoll", ply) end,
    function(ply, button)
        if ply:FAdmin_GetGlobal("fadmin_ragdolled") then
            RunConsoleCommand("_FAdmin", "unragdoll", ply:UserID())
            button:SetImage2("null")
            button:SetText("Ragdoll")
            button:GetParent():InvalidateLayout()
        return end

        local menu = DermaMenu()

        local Padding = vgui.Create("DPanel")
        Padding:SetPaintBackgroundEnabled(false)
        Padding:SetSize(1,5)
        menu:AddPanel(Padding)

        local Title = vgui.Create("DLabel")
        Title:SetText("  Ragdoll Type:\n")
        Title:SetFont("UiBold")
        Title:SizeToContents()
        Title:SetTextColor(color_black)

        menu:AddPanel(Title)

        for k, v in pairs(FAdmin.PlayerActions.RagdollTypes) do
            if v == "Unragdoll" then continue end
            FAdmin.PlayerActions.addTimeSubmenu(menu, v,
                function()
                    RunConsoleCommand("_FAdmin", "Ragdoll", ply:UserID(), k)
                    button:SetImage2("fadmin/icons/disable")
                    button:SetText("Unragdoll")
                    button:GetParent():InvalidateLayout()
                end,
                function(secs)
                    RunConsoleCommand("_FAdmin", "Ragdoll", ply:UserID(), k, secs)
                    button:SetImage2("fadmin/icons/disable")
                    button:SetText("Unragdoll")
                    button:GetParent():InvalidateLayout()
                end
            )
        end

        menu:Open()
	end)

	local Damages = {0, 1, 10, 50, 100, 500, 9999999--[[for the 12-year-olds]]}
	local Repetitions = {[1] = "once", [5] = "5 times", [10] = "10 times", [50] = "50 times", [100] = "100 times"}
	TAB:AddActionButton("Slap", "fadmin/icons/slap", Color(255, 130, 0, 255), function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "Slap", ply) end, function(ply)
        local menu = DermaMenu()

        local Padding = vgui.Create("DPanel")
        Padding:SetPaintBackgroundEnabled(false)
        Padding:SetSize(1,5)
        menu:AddPanel(Padding)

        local Title = vgui.Create("DLabel")
        Title:SetText("  Damage:\n")
        Title:SetFont("UiBold")
        Title:SizeToContents()
        Title:SetTextColor(color_black)
        menu:AddPanel(Title)

        for _, v in ipairs(Damages) do
            local SubMenu = menu:AddSubMenu(v, function() RunConsoleCommand("_FAdmin", "slap", ply:UserID(), v) end)

            local SubMenuTitle = vgui.Create("DLabel")
            SubMenuTitle:SetText("  " .. v .. " damage\n")
            SubMenuTitle:SetFont("UiBold")
            SubMenuTitle:SizeToContents()
            SubMenuTitle:SetTextColor(color_black)

            SubMenu:AddPanel(SubMenuTitle)

            for reps, Name in SortedPairs(Repetitions) do
                local uid = ply:UserID()
                SubMenu:AddOption(Name, function() RunConsoleCommand("_FAdmin", "slap", uid, v, reps) end)
            end
        end
        menu:Open()
	end)

	TAB:AddActionButton("Slay", "fadmin/icons/slay", Color(255, 130, 0, 255),
    function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "Slay", ply) end,
    function(ply)
        local menu = DermaMenu()

        local Padding = vgui.Create("DPanel")
        Padding:SetPaintBackgroundEnabled(false)
        Padding:SetSize(1,5)
        menu:AddPanel(Padding)

        local Title = vgui.Create("DLabel")
        Title:SetText("  Kill Type:\n")
        Title:SetFont("UiBold")
        Title:SizeToContents()
        Title:SetTextColor(color_black)
        menu:AddPanel(Title)

        for k, v in pairs(FAdmin.PlayerActions.SlayTypes) do
            local uid = ply:UserID()
            menu:AddOption(v, function()
                RunConsoleCommand("_FAdmin", "slay", uid, k)
            end)
        end

        menu:Open()
	end)

	TAB:AddActionButton("Strip weapons", {"fadmin/icons/weapon", "fadmin/icons/disable"}, Color(255, 130, 0, 255),
    function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "StripWeapons", ply) end, function(ply, button)
        RunConsoleCommand("_FAdmin", "StripWeapons", ply:UserID())
	end)

	TAB:AddActionButton(function(ply)
		if ply:FAdmin_GetGlobal("FAdmin_voicemuted") then return "Unmute voice globally" end
		return "Mute voice globally"
	end,

	function(ply)
		if ply:FAdmin_GetGlobal("FAdmin_voicemuted") then return "fadmin/icons/voicemute" end
		return "fadmin/icons/voicemute", "fadmin/icons/disable"
	end,
	Color(255, 130, 0, 255),

	function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "Voicemute", ply) end,
	function(ply, button)
		if not ply:FAdmin_GetGlobal("FAdmin_voicemuted") then
			FAdmin.PlayerActions.addTimeMenu(function(secs)
				RunConsoleCommand("_FAdmin", "Voicemute", ply:UserID(), secs)
				button:SetImage2("null")
				button:SetText("Unmute voice globally")
				button:GetParent():InvalidateLayout()
			end)
		else
			RunConsoleCommand("_FAdmin", "UnVoicemute", ply:UserID())
		end

		button:SetImage2("fadmin/icons/disable")
		button:SetText("Mute voice globally")
		button:GetParent():InvalidateLayout()
	end)

	TAB:AddActionButton(function(ply)
		return ply.FAdminMuted and "Unmute voice" or "Mute voice"
	end,
	function(ply)
		if ply.FAdminMuted then return "fadmin/icons/voicemute" end
		return "fadmin/icons/voicemute", "fadmin/icons/disable"
	end,
	Color(255, 130, 0, 255),

	true,

	function(ply, button)
		ply:SetMuted(not ply.FAdminMuted)
		ply.FAdminMuted = not ply.FAdminMuted

		if ply.FAdminMuted then button:SetImage2("null") button:SetText("Unmute voice") button:GetParent():InvalidateLayout() return end

		button:SetImage2("fadmin/icons/disable")
		button:SetText("Mute voice")
		button:GetParent():InvalidateLayout()
	end)

	local function MessageGui(ply)
		if not FAdmin.Messages or not FAdmin.Messages.MsgTypes then return end
	
		local frame = vgui.Create("DFrame")
		frame:SetTitle("Send message")
		frame:SetSize(350, 170)
		frame:Center()
		frame:SetVisible(true)
		frame:MakePopup()
	
		local MsgType = 2
	
		local i = 0
		local TypeButtons = {}
		local MsgTypeNames = {ERROR = 1, NOTIFY = 2, QUESTION = 3, GOOD = 4, BAD = 5}
		for k, v in pairs(FAdmin.Messages.MsgTypes) do
	
	
			local MsgTypeButton = vgui.Create("DCheckBox", frame)
			MsgTypeButton:SetPos(20 + i * 64, 46)
			if k == "NOTIFY" then MsgTypeButton:SetValue(true) end
	
			function MsgTypeButton:DoClick()
				for _, B in pairs(TypeButtons) do B:SetValue(false) end
	
				self:SetValue(true)
				MsgType = MsgTypeNames[k]
			end
	
			local Icon = vgui.Create("DImageButton", frame)
			Icon:SetImage(v.TEXTURE)
			Icon:SetPos(20 + i * 64 + 16, 30)
			Icon:SetSize(32, 32)
			function Icon:DoClick()
				for _, B in pairs(TypeButtons) do B:SetValue(false) end
				MsgTypeButton:SetValue(true)
				MsgType = MsgTypeNames[k]
			end
	
			table.insert(TypeButtons, MsgTypeButton)
			i = i + 1
		end
	
		local OK = vgui.Create("DButton", frame)
		local TextBox = vgui.Create("DTextEntry", frame)
		TextBox:SetPos(20, 100)
		TextBox:StretchToParent(20, nil, 20, nil)
		TextBox:RequestFocus()
		function TextBox:Think() -- Most people are holding tab when they open this window. Get focus back!
			TextBox.InTab = TextBox.InTab or input.IsKeyDown(KEY_TAB)
			if TextBox.InTab and not input.IsKeyDown(KEY_TAB) then self:RequestFocus() end
		end
		function TextBox:OnEnter()
			OK:DoClick()
		end
	
		OK:SetSize(100, 20)
		OK:SetText("OK")
		OK:AlignRight(20)
		OK:AlignBottom(20)
		function OK:DoClick()
			frame:Close()
			if not IsValid(ply) then return end
			RunConsoleCommand("_FAdmin", "Message", ply:UserID(), MsgType, TextBox:GetValue())
		end
	end

	TAB:AddActionButton("Send message", "fadmin/icons/message", Color(0, 200, 0, 255),
        function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "Message") and not ply:IsBot() end, function(ply, button)
            MessageGui(ply)
        end
	)

	TAB:AddActionButton("Set team", "fadmin/icons/changeteam", Color(0, 200, 0, 255),
    function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "SetTeam", ply) end, function(ply, button)
        local menu = DermaMenu()

        local Padding = vgui.Create("DPanel")
        Padding:SetPaintBackgroundEnabled(false)
        Padding:SetSize(1,5)
        menu:AddPanel(Padding)

        local Title = vgui.Create("DLabel")
        Title:SetText("  Teams:\n")
        Title:SetFont("UiBold")
        Title:SizeToContents()
        Title:SetTextColor(color_black)

        menu:AddPanel(Title)
        for k, v in SortedPairsByMemberValue(team.GetAllTeams(), "Name") do
            local uid = ply:UserID()
            menu:AddOption(v.Name, function() RunConsoleCommand("_FAdmin", "setteam", uid, k) end)
        end
        menu:Open()
	end)

	local canSpectate = false
	local function calcAccess()
		CAMI.PlayerHasAccess(LocalPlayer(), "FSpectate", function(b, _)
			canSpectate = b
		end)
	end
	calcAccess()
	
	TAB:AddActionButton("Spectate", "fadmin/icons/spectate", Color(0, 200, 0, 255), function(ply) calcAccess() return canSpectate and ply ~= LocalPlayer() end, function(ply)
		if not IsValid(ply) then return end
		RunConsoleCommand("FSpectate", ply:UserID())
	end)

	TAB:AddActionButton(function(ply)
        if ply:FAdmin_GetGlobal("FAdmin_cloaked") then return "Uncloak" end
        return "Cloak"
    end, function(ply)
        if ply:FAdmin_GetGlobal("FAdmin_cloaked") then return "fadmin/icons/cloak", "fadmin/icons/disable" end
        return "fadmin/icons/cloak"
    end, Color(0, 200, 0, 255),

    function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "Cloak", ply) end, function(ply, button)
        if not ply:FAdmin_GetGlobal("FAdmin_cloaked") then
            RunConsoleCommand("_FAdmin", "Cloak", ply:UserID())
        else
            RunConsoleCommand("_FAdmin", "Uncloak", ply:UserID())
        end

        if not ply:FAdmin_GetGlobal("FAdmin_cloaked") then button:SetImage2("fadmin/icons/disable") button:SetText("Uncloak") button:GetParent():InvalidateLayout() return end
        button:SetImage2("null")
        button:SetText("Cloak")
        button:GetParent():InvalidateLayout()
	end)

	local sbox_noclip = GetConVar("sbox_noclip")

	local function EnableDisableNoclip(ply)
		return ply:FAdmin_GetGlobal("FADmin_CanNoclip") or
			((FAdmin.Access.PlayerHasPrivilege(ply, "Noclip") or sbox_noclip:GetBool())
				and not ply:FAdmin_GetGlobal("FADmin_DisableNoclip"))
	end
	
	TAB:AddActionButton(function(ply)
        if EnableDisableNoclip(ply) then
            return "Disable noclip"
        end
        return "Enable noclip"
    end, function(ply) return "fadmin/icons/noclip", EnableDisableNoclip(ply) and "fadmin/icons/disable" end, Color(0, 200, 0, 255),

    function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "SetNoclip") end, function(ply, button)
        if EnableDisableNoclip(ply) then
            RunConsoleCommand("_FAdmin", "SetNoclip", ply:UserID(), 0)
        else
            RunConsoleCommand("_FAdmin", "SetNoclip", ply:UserID(), 1)
        end

        if EnableDisableNoclip(ply) then
            button:SetText("Enable noclip")
            button:SetImage2("null")
            button:GetParent():InvalidateLayout()
            return
        end
        button:SetText("Disable noclip")
        button:SetImage2("fadmin/icons/disable")
        button:GetParent():InvalidateLayout()
	end)

	TAB:AddActionButton("Teleport", "fadmin/icons/teleport", Color(0, 200, 0, 255),
    function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "Teleport") end,
    function(ply, button)
        RunConsoleCommand("_FAdmin", "Teleport", ply:UserID())
    end)

    TAB:AddActionButton("Goto", "fadmin/icons/teleport", Color(0, 200, 0, 255),
    function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "Teleport") and ply ~= LocalPlayer() end,
    function(ply, button)
        RunConsoleCommand("_FAdmin", "goto", ply:UserID())
    end)

    TAB:AddActionButton("Bring", "fadmin/icons/teleport", Color(0, 200, 0, 255),
    function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "Teleport") and ply ~= LocalPlayer() end,
    function(ply, button)
        local menu = DermaMenu()

        local Padding = vgui.Create("DPanel")
        Padding:SetPaintBackgroundEnabled(false)
        Padding:SetSize(1,5)
        menu:AddPanel(Padding)

        local Title = vgui.Create("DLabel")
        Title:SetText("  Bring to:\n")
        Title:SetFont("UiBold")
        Title:SizeToContents()
        Title:SetTextColor(color_black)

        menu:AddPanel(Title)

        local uid = ply:UserID()
        menu:AddOption("Yourself", function() RunConsoleCommand("_FAdmin", "bring", uid) end)
        for _, v in pairs(DarkRP.nickSortedPlayers()) do
            if IsValid(v) and v ~= LocalPlayer() then
                local vUid = v:UserID()
                menu:AddOption(v:Nick(), function() RunConsoleCommand("_FAdmin", "bring", uid, vUid) end)
            end
        end
        menu:Open()
	end)
end)