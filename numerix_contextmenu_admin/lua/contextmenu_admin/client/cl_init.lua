--[[ ContextMenu Admin --------------------------------------------------------------------------------------

ContextMenu Admin made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

timer.Simple(1, function()
properties.Add( "contextmenu_admin", {
    MenuLabel = ContextMenuAdmin.GetLanguage("Action on the player"),
    Order = 9999,
    MenuIcon = "icon16/user.png",

	Filter = function( self, ent, ply )
        return (ent.GetClass and ent:GetClass() and IsValid(ent) and ent:IsPlayer() and ContextMenuAdmin.Settings.AdminGroup[ply:GetNWString("usergroup")])
    end,
	MenuOpen = function( self, option, ent, tr )
		local ply = LocalPlayer()

		local submenu = option:AddSubMenu("base")
		local ulx_fun = submenu:AddSubMenu(ContextMenuAdmin.GetLanguage("Fun"))
		local ulx_util = submenu:AddSubMenu(ContextMenuAdmin.GetLanguage("Util"))
	
		local function addulx_fun(str, data)
            local menu = ulx_fun:AddOption(str, data.callback)

            if data.icon then
                menu:SetImage( data.icon )
            end

            return menu
        end
		
		local function addulx_util(str, data)
            local menu = ulx_util:AddOption(str, data.callback)

            if data.icon then
                menu:SetImage( data.icon )
            end

            return menu
        end
			
		addulx_fun( "Slap", {
			callback = function() ContextMenuAdmin.textentry(ContextMenuAdmin.GetLanguage("Choose the damage inflicted"), 'ulx slap "' ..ent:Name()..'"') end,
		})
			
		addulx_fun( "Whip", {
			callback = function() ContextMenuAdmin.textentry_2choix(ContextMenuAdmin.GetLanguage("Choose how often the action occurs (min: 2)"), ContextMenuAdmin.GetLanguage("Choose the damage inflicted"), 'ulx whip "'..ent:Name()..'"') end,
		})
			
		addulx_fun( "Slay", {
			callback = function() ply:ConCommand('ulx slay "'..ent:Name()..'"') end,
		})
			
		addulx_fun( "Sslay", {
			callback = function() ply:ConCommand('ulx sslay "'..ent:Name()..'"') end,
		})
			
		if ent:IsOnFire() then
			addulx_fun( "UnIgnite", {
				callback = function() ply:ConCommand('ulx unignite "'..ent:Name()..'"') end,
			})
		else
			addulx_fun( "Ignite", {
				callback = function() ply:ConCommand('ulx ignite "'..ent:Name()..'"') end,
			})
		end
			
		if ent:IsFrozen() then
			addulx_fun( "UnFreeze", {
				callback = function() ply:ConCommand('ulx unfreeze "'..ent:Name()..'"') end,
			})
		else
			addulx_fun( "Freeze", {
				callback = function() ply:ConCommand('ulx freeze "'..ent:Name()..'"') end,
			})
		end
			
		addulx_fun( "God", {
			callback = function() ply:ConCommand('ulx god "'..ent:Name()..'"') end,
		})
			
		addulx_fun( "UnGod", {
			callback = function() ply:ConCommand('ulx ungod "'..ent:Name()..'"') end,
		})
			
		addulx_fun( "HP", {
			callback = function() ContextMenuAdmin.textentry(ContextMenuAdmin.GetLanguage("Choose how much life the player should have"), 'ulx hp "' ..ent:Name()..'"') end,
		})
			
		addulx_fun( "Armor", {
			callback = function() ContextMenuAdmin.textentry(ContextMenuAdmin.GetLanguage("Choose how much armor the player should have"), 'ulx armor "' ..ent:Name()..'"') end,
		})
			
		addulx_fun( "Cloak", {
			callback = function() ply:ConCommand('ulx cloak "'..ent:Name()..'"') end,
		})
			
		addulx_fun( "UnCloak", {
			callback = function() ply:ConCommand('ulx uncloak "'..ent:Name()..'"') end,
		})
			
		addulx_fun( "Blind", {
			callback = function() ContextMenuAdmin.textentry(ContextMenuAdmin.GetLanguage("Choose the level of blindness"), 'ulx blind "' ..ent:Name()..'"') end,
		})
			
		addulx_fun( "UnBlind", {
			callback = function() ply:ConCommand('ulx unblind "'..ent:Name()..'"') end,
		})
			
		addulx_fun( "Jail", {
			callback = function() ContextMenuAdmin.textentry(ContextMenuAdmin.GetLanguage("Choose the jail time"), 'ulx jail "' ..ent:Name()..'"') end,
		})
			
		addulx_fun( "UnJail", {
			callback = function() ply:ConCommand('ulx unjail "'..ent:Name()..'"') end,
		})
			
		addulx_fun( "Maul", {
			callback = function() ply:ConCommand('ulx maul "'..ent:Name()..'"') end,
		})
			
		addulx_fun( "Strip", {
			callback = function() ply:ConCommand('ulx strip "'..ent:Name()..'"') end,
		})
			
		addulx_util( "Who", {
			callback = function() 
				ply:ConCommand("ulx who "..ent:SteamID()) 
				ply:ContextMenuAdminChatInfo(ContextMenuAdmin.GetLanguage("Open your console to have informations"), 2)
			end,
		})
			
		addulx_util( "Kick", {
			callback = function() ContextMenuAdmin.textentry(ContextMenuAdmin.GetLanguage("Enter the reason"), 'ulx kick "'..ent:Name()..'"') end,
		})
			
		addulx_util( "Ban", {
			callback = function() ContextMenuAdmin.textentry_3choix(ContextMenuAdmin.GetLanguage("Choose the ban time (0 = permanent ban)"), ContextMenuAdmin.GetLanguage("Enter the reason"), 'ulx ban "'..ent:Name()..'"') end,
		})
			
	end,
})
end)

function ContextMenuAdmin.textentry(text, cmd)
	local ply = LocalPlayer()

	local frame = vgui.Create( "DFrame" )
	frame:SetSize( 400, 200 )
	frame:SetTitle( " " )
	frame:SetDraggable( true )
	frame:ShowCloseButton( false )
	frame:Center()
	frame:MakePopup()
	frame.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 175) )
		draw.RoundedBox( 0, 5, 5, w - 10, h - 10, Color(0, 0, 0, 200) )
	end
			
	local Text = vgui.Create( "DLabel", frame )
	Text:SetPos( 0, 15 )
	Text:SetText( text )
	Text:SetTextColor(Color (255, 255, 255, 255))
	Text:SetSize(400, 20)
	Text:SetContentAlignment(5)

	local TextEntry = vgui.Create( "DTextEntry", frame )
	TextEntry:SetPos( 25, 50 )
	TextEntry:SetSize( 350, 40 )
	TextEntry:SetText( "0" )
			
	local Valider = vgui.Create( "DButton",frame )
	Valider:SetPos( 6, 120 )
	Valider:SetText( ContextMenuAdmin.GetLanguage("Validate") )
	Valider:SetTextColor(Color (255, 255, 255, 255))
	Valider:SetSize( 388, 30 )
	Valider.Paint = function( self, w, h )
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
	end
	Valider.DoClick = function()
		ply:ConCommand(cmd.." "..TextEntry:GetValue())
		frame:Close()
	end
			
	local Annuler = vgui.Create( "DButton",frame )
	Annuler:SetPos( 6, 160 )
	Annuler:SetText( ContextMenuAdmin.GetLanguage("Cancel") )
	Annuler:SetTextColor(Color (255, 255, 255, 255))
	Annuler:SetSize( 388, 30 )
	Annuler.Paint = function( self, w, h )
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
	end
	Annuler.DoClick = function()
		frame:Close()
	end
end


function ContextMenuAdmin.textentry_2choix(text1, text2, cmd)
	local ply = LocalPlayer()

	local frame = vgui.Create( "DFrame" )
	frame:SetSize( 400, 200 )
	frame:SetTitle( " " )
	frame:SetDraggable( true )
	frame:ShowCloseButton( false )
	frame:Center()
	frame:MakePopup()
	frame.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 175) )
		draw.RoundedBox( 0, 5, 5, w - 10, h - 10, Color(0, 0, 0, 200) )
	end
			
	local Text1 = vgui.Create( "DLabel", frame )
	Text1:SetPos( 0, 15 )
	Text1:SetText( text1 )
	Text1:SetTextColor(Color (255, 255, 255, 255))
	Text1:SetSize(400, 20)
	Text1:SetContentAlignment(5)

	local Temps = vgui.Create( "DTextEntry", frame )
	Temps:SetPos( 25, 40 )
	Temps:SetSize( 350, 20 )
	Temps:SetText( "0" )
			
	local Text2 = vgui.Create( "DLabel", frame )
	Text2:SetPos( 0, 65 )
	Text2:SetText( text2 )
	Text2:SetTextColor(Color (255, 255, 255, 255))
	Text2:SetSize(400, 20)
	Text2:SetContentAlignment(5)

	local Autre = vgui.Create( "DTextEntry", frame )
	Autre:SetPos( 25, 90 )
	Autre:SetSize( 350, 20 )
	Autre:SetText( "0" )
			
			
	local Valider = vgui.Create( "DButton",frame )
	Valider:SetPos( 6, 120 )
	Valider:SetText( ContextMenuAdmin.GetLanguage("Validate") )
	Valider:SetTextColor(Color (255, 255, 255, 255))
	Valider:SetSize( 388, 30 )
	Valider.Paint = function( self, w, h )
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
	end
	Valider.DoClick = function()
		ply:ConCommand(cmd.." "..Temps:GetValue().." "..Autre:GetValue())
		frame:Close()
	end
			
	local Annuler = vgui.Create( "DButton",frame )
	Annuler:SetPos( 6, 160 )
	Annuler:SetText( ContextMenuAdmin.GetLanguage("Cancel") )
	Annuler:SetTextColor(Color (255, 255, 255, 255))
	Annuler:SetSize( 388, 30 )
	Annuler.Paint = function( self, w, h )
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
	end
	Annuler.DoClick = function()
		frame:Close()
	end
end


function ContextMenuAdmin.textentry_3choix(text1, text2, cmd)
	local ply = LocalPlayer()

	local multiplicateur = 1

	local frame = vgui.Create( "DFrame" )
	frame:SetSize( 400, 200 )
	frame:SetTitle( " " )
	frame:SetDraggable( true )
	frame:ShowCloseButton( false )
	frame:Center()
	frame:MakePopup()
	frame.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 175) )
		draw.RoundedBox( 0, 5, 5, w - 10, h - 10, Color(0, 0, 0, 200) )
	end
			
	local DComboBox = vgui.Create( "DComboBox", frame)
	DComboBox:SetPos( 290, 40 )
	DComboBox:SetSize( 100, 20 )
	DComboBox:SetValue( ContextMenuAdmin.GetLanguage("Minute(s)") )
	DComboBox:AddChoice( ContextMenuAdmin.GetLanguage("Minute(s)") )
	DComboBox:AddChoice( ContextMenuAdmin.GetLanguage("Hours(s)") )
	DComboBox:AddChoice( ContextMenuAdmin.GetLanguage("Day(s)"))
	DComboBox:AddChoice( ContextMenuAdmin.GetLanguage("Week(s)") )
	DComboBox:AddChoice( ContextMenuAdmin.GetLanguage("Year(s)") )
	DComboBox.OnSelect = function( panel, index, value )
		if value == ContextMenuAdmin.GetLanguage("Minute(s)") then multiplicateur = 1
		elseif value == ContextMenuAdmin.GetLanguage("Hours(s)") then multiplicateur = 60
		elseif value == ContextMenuAdmin.GetLanguage("Day(s)") then multiplicateur = 60*24
		elseif value == ContextMenuAdmin.GetLanguage("Week(s)") then multiplicateur = 60*24*7
		elseif value == ContextMenuAdmin.GetLanguage("Year(s)") then multiplicateur = 60*24*365
		end
	end
			
	local Text1 = vgui.Create( "DLabel", frame )
	Text1:SetPos( 0, 15 )
	Text1:SetText( text1 )
	Text1:SetTextColor(Color (255, 255, 255, 255))
	Text1:SetSize(400, 20)
	Text1:SetContentAlignment(5)

	local Temps = vgui.Create( "DTextEntry", frame )
	Temps:SetPos( 25, 40 )
	Temps:SetSize( 250, 20 )
	Temps:SetText( "0" )
			
	local Text2 = vgui.Create( "DLabel", frame )
	Text2:SetPos( 0, 65 )
	Text2:SetText( text2 )
	Text2:SetTextColor(Color (255, 255, 255, 255))
	Text2:SetSize(400, 20)
	Text2:SetContentAlignment(5)

	local Raison = vgui.Create( "DTextEntry", frame ) 
	Raison:SetPos( 25, 90 )
	Raison:SetSize( 350, 20 )
	Raison:SetText( ContextMenuAdmin.GetLanguage("Reason") )
			
			
	local Valider = vgui.Create( "DButton",frame )
	Valider:SetPos( 6, 130 )
	Valider:SetText( ContextMenuAdmin.GetLanguage("Validate") )
	Valider:SetTextColor(Color (255, 255, 255, 255))
	Valider:SetSize( 388, 20 )
	Valider.Paint = function( self, w, h )
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
	end
	Valider.DoClick = function()
		ply:ConCommand(cmd.." "..Temps:GetValue()*multiplicateur.." "..Raison:GetValue())
		frame:Close()
	end
			
	local Annuler = vgui.Create( "DButton",frame )
	Annuler:SetPos( 6, 170 )
	Annuler:SetText( ContextMenuAdmin.GetLanguage("Cancel") )
	Annuler:SetTextColor(Color (255, 255, 255, 255))
	Annuler:SetSize( 388, 20 )
	Annuler.Paint = function( self, w, h )
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
	end
	Annuler.DoClick = function()
		frame:Close()
	end
end