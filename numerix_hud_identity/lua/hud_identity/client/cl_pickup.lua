--[[ HUD Identity --------------------------------------------------------------------------------------

HUD Identity made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

HUD.PickupHistory = {}
HUD.PickupHistoryLast = 0
HUD.PickupHistoryTop = ScrH() / 2
HUD.PickupHistoryWide = 200

local function AddGenericPickup( self, itemname )
	local pickup		= {}
	pickup.time			= CurTime()
	pickup.name			= itemname
	pickup.holdtime		= 5
	pickup.font			= "HUD.Identity.PickupHUD.Text"
	pickup.fadein		= 0.04
	pickup.fadeout		= 0.3

	surface.SetFont( pickup.font )
	local w, h = surface.GetTextSize( pickup.name )
	pickup.height		= h
	pickup.width		= w

	table.insert( self.PickupHistory, pickup )
	self.PickupHistoryLast = pickup.time

	return pickup
end

hook.Add("HUDWeaponPickedUp", "HUD.Identity:WeaponPickedUp", function(wep)
    if ( !IsValid( LocalPlayer() ) || !LocalPlayer():Alive() ) then return end
	if ( !IsValid( wep ) ) then return end
	if ( !isfunction( wep.GetPrintName ) ) then return end

	local pickup = AddGenericPickup( HUD, wep:GetPrintName() )
	pickup.color = Color( 255, 200, 50, 255 )
end)

hook.Add("HUDItemPickedUp", "HUD.Identity:ItemPickedUp", function(itemname)
    if ( !IsValid( LocalPlayer() ) || !LocalPlayer():Alive() ) then return end

	local pickup = AddGenericPickup( HUD, "#" .. itemname )
	pickup.color = Color( 180, 255, 180, 255 )
end)

hook.Add("HUDAmmoPickedUp", "HUD.Identity:AmmoPickedUp", function(itemname, amount)
    if ( !IsValid( LocalPlayer() ) || !LocalPlayer():Alive() ) then return end

	-- Try to tack it onto an exisiting ammo pickup
	if ( HUD.PickupHistory ) then

		for k, v in pairs( HUD.PickupHistory ) do

			if ( v.name == "#" .. itemname .. "_ammo" ) then

				v.amount = tostring( tonumber( v.amount ) + amount )
				v.time = CurTime() - v.fadein
				return

			end

		end

	end

	local pickup = AddGenericPickup( HUD, "#" .. itemname .. "_ammo" )
	pickup.color = Color( 180, 200, 255, 255 )
	pickup.amount = tostring( amount )

	local w, h = surface.GetTextSize( pickup.amount )
	pickup.width = pickup.width + w + 16
end)

hook.Add("HUDItemPickedUp", "HUD.Identity:ItemPickedUp", function(itemname)
    if ( !IsValid( LocalPlayer() ) || !LocalPlayer():Alive() ) then return end

	local pickup = AddGenericPickup( HUD, "#" .. itemname )
	pickup.color = Color( 180, 255, 180, 255 )
end)

hook.Add("HUDDrawPickupHistory", "HUD.Identity:PickupHUD", function()
	local ShouldDraw = hook.Call("HUDShouldDraw", GAMEMODE, "HUD.Identity:PickupHUD")

	if ShouldDraw == false then return false end
	
    if ( HUD.PickupHistory == nil ) then return end

	local x, y = ScrW() - HUD.PickupHistoryWide - 20, HUD.PickupHistoryTop
	local tall = 0
	local wide = 0

	for k, v in pairs( HUD.PickupHistory ) do

		if ( !istable( v ) ) then

			Msg( tostring( v ) .. "\n" )
			PrintTable( HUD.PickupHistory )
			HUD.PickupHistory[ k ] = nil
			return
		end

		if ( v.time < CurTime() ) then

			if ( v.y == nil ) then v.y = y end

			v.y = ( v.y * 5 + y ) / 6

			local delta = ( v.time + v.holdtime ) - CurTime()
			delta = delta / v.holdtime

			local alpha = 255
			local colordelta = math.Clamp( delta, 0.6, 0.7 )

			-- Fade in/out
			if ( delta > 1 - v.fadein ) then
				alpha = math.Clamp( ( 1.0 - delta ) * ( 255 / v.fadein ), 0, 255 )
			elseif ( delta < v.fadeout ) then
				alpha = math.Clamp( delta * ( 255 / v.fadeout ), 0, 255 )
			end

			v.x = x + HUD.PickupHistoryWide - ( HUD.PickupHistoryWide * ( alpha / 255 ) )

			local rx, ry, rw, rh = math.Round( v.x - 4 ), math.Round( v.y - ( v.height / 2 ) - 4 ), math.Round( HUD.PickupHistoryWide + 9 ), math.Round( v.height + 8 )
			
			HUD.DrawRect(rx, ry, rw, rh)

			if ( v.amount ) then

				draw.SimpleText( v.name, v.font, v.x, ry + ( rh / 2 ), Color( 255, 255, 255, alpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( v.amount, v.font, v.x + HUD.PickupHistoryWide + 1, ry + ( rh / 2 ) + 1, Color( 0, 0, 0, alpha * 0.5 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				draw.SimpleText( v.amount, v.font, v.x + HUD.PickupHistoryWide, ry + ( rh / 2 ), Color( 255, 255, 255, alpha ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			
			else

				draw.SimpleText( v.name, v.font, v.x + rw/2 - 5 , ry + ( rh / 2 ), Color( 255, 255, 255, alpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			end

			y = y + ( v.height + 16 )
			tall = tall + v.height + 18
			wide = math.max( wide, v.width + v.height + 24 )

			if ( alpha == 0 ) then HUD.PickupHistory[ k ] = nil end

		end

	end

	HUD.PickupHistoryTop = ( HUD.PickupHistoryTop * 5 + ( ScrH() * 0.75 - tall ) / 2 ) / 6
    HUD.PickupHistoryWide = ( HUD.PickupHistoryWide * 5 + wide ) / 6
    
    return false
end)