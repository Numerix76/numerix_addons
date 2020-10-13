--[[ HUD Identity --------------------------------------------------------------------------------------

HUD Identity made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local ScreenPos = ScrH() - 200

local Icons = {}
Icons[ NOTIFY_GENERIC ]	= Material( "vgui/notices/generic" )
Icons[ NOTIFY_ERROR ]		= Material( "vgui/notices/error" )
Icons[ NOTIFY_UNDO ]		= Material( "vgui/notices/undo" )
Icons[ NOTIFY_HINT ]		= Material( "vgui/notices/hint" )
Icons[ NOTIFY_CLEANUP ]	= Material( "vgui/notices/cleanup" )

local LoadingIcon = Material( "vgui/notices/undo" )

local Notifications = {}

local function DrawNotification( x, y, w, h, text, icon, col, progress )   
    HUD.DrawRect(x, y, w, h)

	draw.SimpleText( text, "HUD.Identity.NotificationHUD.Text", x + 42 + 10, y + h / 2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

	surface.SetDrawColor( Color(255,255,255,255) )
	surface.SetMaterial( icon )

	if progress then
		surface.DrawTexturedRectRotated( x + 20, y + h / 2, 32, 32, -CurTime() * 360 % 360 )
	else
		surface.DrawTexturedRect( x + 5, y + 5, 32, 32 )
	end
end

function notification.AddLegacy( text, type, time )
	surface.SetFont( "HUD.Identity.NotificationHUD.Text" )

	local w = surface.GetTextSize( text ) + 20 + 32 + 10
	local h = 42
	local x = ScrW() - 5
	local y = (HUD.RightBottomLastPos or 0) - ( ( HUD.Settings.AgendaHUD and DarkRP and LocalPlayer().getAgenda and LocalPlayer():getAgendaTable() or false ) and HUD.Settings.AgendaPos == "RightBottom" and 115 or 0) - h

	table.insert( Notifications, 1, {
		x = x,
		y = y,
		w = w,
		h = h,

		text = text,
		icon = Icons [ type ],
		time = CurTime() + time,

		progress = false,
	} )
end

function notification.AddProgress( id, text )
	surface.SetFont( "HUD.Identity.NotificationHUD.Text" )

	local w = surface.GetTextSize( text ) + 20 + 32
	local h = 42
	local x = ScrW() - 5
	local y = (HUD.RightBottomLastPos or 0) - ( ( HUD.Settings.AgendaHUD and DarkRP and LocalPlayer().getAgenda and LocalPlayer():getAgendaTable() or false ) and HUD.Settings.AgendaPos == "RightBottom" and 115 or 0) - h

	table.insert( Notifications, 1, {
		x = x,
		y = y,
		w = w,
		h = h,

		id = id,
		text = text,
		icon = LoadingIcon,
		time = math.huge,

		progress = true,
	} )	
end

function notification.Kill( id )
	for k, v in ipairs( Notifications ) do
		if v.id == id then v.time = 0 end
	end
end

hook.Add( "HUDPaint", "HUD.Identity:NotificationHUD", function()
    local ShouldDraw = hook.Call("HUDShouldDraw", GAMEMODE, "HUD.Identity:NotificationHUD")

    if ShouldDraw == false then return end

	for k, v in ipairs( Notifications ) do
		DrawNotification( math.floor( v.x ), math.floor( v.y ), v.w, v.h, v.text, v.icon, v.col, v.progress )

		ScreenPos = (HUD.RightBottomLastPos or 0) - ( ( HUD.Settings.AgendaHUD and DarkRP and LocalPlayer().getAgenda and LocalPlayer():getAgendaTable() or false ) and HUD.Settings.AgendaPos == "RightBottom" and 115 or 0) - v.h
		
		v.x = Lerp( FrameTime() * 10, v.x, v.time > CurTime() and ScrW() - v.w - 5 or ScrW() + 1 )
		v.y = Lerp( FrameTime() * 10, v.y, ScreenPos - ( k - 1 ) * ( v.h + 5 ) )
	
	end

	for k, v in ipairs( Notifications ) do
		if v.x >= ScrW() and v.time < CurTime() then
			table.remove( Notifications, k )
		end
	end

end )