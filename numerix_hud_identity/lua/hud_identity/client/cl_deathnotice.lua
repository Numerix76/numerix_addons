--[[ HUD Identity  --------------------------------------------------------------------------------------

HUD Identity made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local hud_deathnotice_time = CreateConVar( "hud_deathnotice_time", "6", FCVAR_REPLICATED, "Amount of time to show death notice" )

local Deaths = {}

local function PlayerIDOrNameToString( var )

	if ( isstring( var ) ) then
		if ( var == "" ) then return "" end
		return "#" .. var
	end

	local ply = Entity( var )

	if ( !IsValid( ply ) ) then return "NULL!" end

	return ply:Name()

end


local function RecvPlayerKilledByPlayer()

	local victim	= net.ReadEntity()
	local inflictor	= net.ReadString()
	local attacker	= net.ReadEntity()

	if ( !IsValid( attacker ) ) then return end
	if ( !IsValid( victim ) ) then return end

	GAMEMODE:AddDeathNotice( attacker:Name(), attacker:Team(), inflictor, victim:Name(), victim:Team() )

end
net.Receive( "PlayerKilledByPlayer", RecvPlayerKilledByPlayer )

local function RecvPlayerKilledSelf()

	local victim = net.ReadEntity()
	if ( !IsValid( victim ) ) then return end
	GAMEMODE:AddDeathNotice( nil, 0, "suicide", victim:Name(), victim:Team() )

end
net.Receive( "PlayerKilledSelf", RecvPlayerKilledSelf )

local function RecvPlayerKilled()

	local victim	= net.ReadEntity()
	if ( !IsValid( victim ) ) then return end
	local inflictor	= net.ReadString()
	local attacker	= "#" .. net.ReadString()

	GAMEMODE:AddDeathNotice( attacker, -1, inflictor, victim:Name(), victim:Team() )

end
net.Receive( "PlayerKilled", RecvPlayerKilled )

local function RecvPlayerKilledNPC()

	local victimtype = net.ReadString()
	local victim	= "#" .. victimtype
	local inflictor	= net.ReadString()
	local attacker	= net.ReadEntity()

	--
	-- For some reason the killer isn't known to us, so don't proceed.
	--
	if ( !IsValid( attacker ) ) then return end

	GAMEMODE:AddDeathNotice( attacker:Name(), attacker:Team(), inflictor, victim, -1 )

	local bIsLocalPlayer = ( IsValid(attacker) && attacker == LocalPlayer() )

	local bIsEnemy = IsEnemyEntityName( victimtype )
	local bIsFriend = IsFriendEntityName( victimtype )

	if ( bIsLocalPlayer && bIsEnemy ) then
		achievements.IncBaddies()
	end

	if ( bIsLocalPlayer && bIsFriend ) then
		achievements.IncGoodies()
	end

	if ( bIsLocalPlayer && ( !bIsFriend && !bIsEnemy ) ) then
		achievements.IncBystander()
	end

end
net.Receive( "PlayerKilledNPC", RecvPlayerKilledNPC )

local function RecvNPCKilledNPC()

	local victim	= "#" .. net.ReadString()
	local inflictor	= net.ReadString()
	local attacker	= "#" .. net.ReadString()

	GAMEMODE:AddDeathNotice( attacker, -1, inflictor, victim, -1 )

end
net.Receive( "NPCKilledNPC", RecvNPCKilledNPC )

local text
local function DrawDeath( x, y, death, hud_deathnotice_time )
    
    surface.SetFont("HUD.Identity.DeathHUD.Text")
    if death.left and death.left == "#worldspawn" then 
		text = string.format(HUD.GetLanguage("%s has falled from too high"), death.right)
		
    elseif death.left and table.HasValue({"#prop_physics", "#prop_ragdoll", "#func_pushable", "#func_physbox"}, death.left) then 
		text = string.format(HUD.GetLanguage("%s has taked something in his face"), death.right)
		
    elseif death.left and !string.StartWith(death.left, "#") then 
        text =  string.format(HUD.GetLanguage("%s killed %s with %s"), death.left, death.right, (istable(weapons.Get(death.type) ) and weapons.Get(death.type).PrintName or language.GetPhrase("#"..death.type) or death.type))
	
	elseif death.left then
        text = string.format(HUD.GetLanguage("%s died with %s"), death.right, (istable(weapons.Get(death.type) ) and weapons.Get(death.type).PrintName or language.GetPhrase("#"..death.type) or death.type))
	
	else
        text = string.format(HUD.GetLanguage("%s commited to suicide"), death.right)
	end

    local w = surface.GetTextSize(text) + 10
    
    HUD.DrawRect(x - w/2, y - 42, w, 42)

    draw.SimpleText( text,	"HUD.Identity.DeathHUD.Text", x, y - 42/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	return ( y + 42 + 5 )

end

hook.Add("PostGamemodeLoaded", "HUD.Identity:DeathHUD", function()
	--[[---------------------------------------------------------
   	Name: gamemode:AddDeathNotice( Attacker, team1, Inflictor, Victim, team2 )
   	Desc: Adds an death notice entry
	-----------------------------------------------------------]]
	function GAMEMODE:AddDeathNotice( Attacker, team1, Inflictor, Victim, team2 )

		local Death = {}
		Death.time		= CurTime()

		Death.left		= Attacker
		Death.right		= Victim
		Death.type		= Inflictor

		table.insert( Deaths, Death )

	end

	function GAMEMODE:DrawDeathNotice( x, y )
		local ShouldDraw = hook.Call("HUDShouldDraw", GAMEMODE, "HUD.Identity:DeathHUD")
	
		if ShouldDraw == false then return end
		
		if ( GetConVarNumber( "cl_drawhud" ) == 0 ) then return end
	
		local hud_deathnotice_time = hud_deathnotice_time:GetFloat()
	
		x = ScrW()/2
		y = y * ScrH() + 5
	
		-- Draw
		for k, Death in pairs( Deaths ) do
	
			if ( Death.time + hud_deathnotice_time > CurTime() ) then
	
				if ( Death.lerp ) then
					x = x * 0.3 + Death.lerp.x * 0.7
					y = y * 0.3 + Death.lerp.y * 0.7
				end
	
				Death.lerp = Death.lerp or {}
				Death.lerp.x = x
				Death.lerp.y = y
	
				y = DrawDeath( x, y, Death, hud_deathnotice_time )
	
			end
	
		end
	
		-- We want to maintain the order of the table so instead of removing
		-- expired entries one by one we will just clear the entire table
		-- once everything is expired.
		for k, Death in pairs( Deaths ) do
			if ( Death.time + hud_deathnotice_time > CurTime() ) then
				return
			end
		end
	
		Deaths = {}
	
	end
end)