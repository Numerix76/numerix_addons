if file.Exists("radio/config/sh_config.lua", "LUA") then
	if SERVER then
		AddCSLuaFile("radio/config/sh_config.lua")
	end
    include("radio/config/sh_config.lua")
else
	if SERVER then
		AddCSLuaFile("radio/config/sh_config_default.lua")
	end
    include("radio/config/sh_config_default.lua")
end

if !Radio.Settings.EnableSWEP then return end

AddCSLuaFile()

local color_orange = Color(255,69,0)

SWEP.ViewModelFlip 			= false
SWEP.Author					= "Numerix"
SWEP.Instructions			= "Click Left : Open the radio menu\nClick Right : If look a vehicle then put the radio in it or put it at floor"

SWEP.HoldType = "melee"

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.ViewModel				= Model( "models/weapons/cstrike/c_knife_t.mdl" )
SWEP.WorldModel 			= "models/sligwolf/grocel/radio/ghettoblaster.mdl"

SWEP.UseHands				= true

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= false

SWEP.Primary.Damage         = 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay 			= 2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Category 				= "Numerix Scripts"
SWEP.PrintName				= "Radio"
SWEP.Slot					= 2
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end

	self:SetNextPrimaryFire( CurTime() + 1 )

	if CLIENT then
		Radio.OpenStreamMenu(self)
	end
end


function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end

	self:SetNextPrimaryFire( CurTime() + 0.2 )
	
	local trace = self.Owner:GetEyeTrace()

	if self.Owner:GetPos():DistToSqr( trace.HitPos) > 22500 then return end

	if SERVER then
		if self.IsBeingDrop then return end
		if Radio.IsCar(trace.Entity) and (!Radio.CanModificateRadio(self.Owner, trace.Entity) or trace.Entity:GetNWBool("Radio:HasRadio")) then return end 
		
		self.IsBeingDrop = true
		local radio = Radio.Settings.EnableVehicle and Radio.IsCar(trace.Entity) and trace.Entity or Radio.Settings.EnableEntity and ents.Create( "numerix_radio" ) or nil

		if !IsValid(radio) then return end

		if isentity(radio) and !Radio.IsCar(radio) then
			radio:SetPos( trace.HitPos )
			radio:Spawn()
			if FPP then
				radio:CPPISetOwner(self.Owner)
			end

			radio:SetColor(string.ToColor(self:GetNWString("Radio:Color")))
		elseif Radio.IsCar(radio) and !radio:GetNWBool("Radio:HasRadio") then
			radio:SetNWBool("Radio:HasRadio", true)
			Radio.Vehicle[radio] = true
			Radio.AllRadio[radio] = true
	
			net.Start("Radio:SendVehicleData")
			net.WriteEntity(radio)
			net.Broadcast()
		end

		timer.Simple(0.1, function()
			Radio.ChangeMod(self.Owner, self, radio)
			
			self.LastStation = self:GetNWEntity("Radio:Entity")

			self.Owner:StripWeapon("numerix_radio_swep")
		end)
	end
end

hook.Add("Think", "Radio:ThinkSwep", function()
	for ent, _ in pairs(Radio.Weapon) do
		if IsValid(ent) and IsValid(ent.Owner) and ent.Owner:Alive() then
			Radio.Think(ent, ent:GetNWEntity("Radio:Entity"))
		end
	end
end)

hook.Add("PlayerEnteredVehicle", "Radio:PlayerEnterVehicle", function(ply, veh)
	local weapon = ply:GetActiveWeapon()
	if IsValid(weapon) and weapon:GetClass() == "numerix_radio_swep" then
		weapon.lastvolume = weapon:GetNWInt("Radio:Volume")
		weapon:SetNWInt("Radio:Volume", 0)
	end
end)

hook.Add("PlayerLeaveVehicle", "Radio:PlayerLeaveVehicle", function(ply, veh)
	local weapon = ply:GetWeapon("numerix_radio_swep")
	if IsValid(weapon) then
		weapon:SetNWInt("Radio:Volume", weapon.lastvolume or 50)
		weapon.lastvolume = nil
	end
end)

local color
function DrawRadioInfo(self)
	color = string.ToColor(self:GetNWString("Radio:Visual"))

	local ent = self:GetNWEntity("Radio:Entity")
	surface.SetFont( "Radio.Video.Info" )

	if self:GetNWInt("Radio:Info") != "" then
		surface.SetTextColor( color_orange )
		surface.SetTextPos( -45, 0 )
		surface.DrawText( self:GetNWInt("Radio:Info") )	
	elseif self.station and IsValid(self.station) then
		surface.SetTextColor( color_white )
		surface.SetTextPos( -40, 10-50 )

		local Title = ent:GetNWString("Radio:Title")
		local w, _ = surface.GetTextSize( Title );
		if( w > 270 ) then

			for i = string.len( Title ), 1, -1 do

				w, _ = surface.GetTextSize( string.sub( Title, 1, i ) );
				if( w <= 290 ) then

					surface.DrawText( string.sub( Title, 1, i ) .. "..." );
					break;

				end

			end

		else
			surface.DrawText( Title );
		end

		surface.SetTextPos( -40, 30-50 )

		local Author = ent:GetNWString("Radio:Author")
		local w, _ = surface.GetTextSize( Author );
		if( w > 270 ) then

			for i = string.len( Author ), 1, -1 do

				local w, _ = surface.GetTextSize( string.sub( Author, 1, i ) );
				if( w <= 290 ) then

					surface.DrawText( string.sub( Author, 1, i ) .. "..." );
					break;

				end

			end

		else
			surface.DrawText( Author );
		end

		if ent:GetNWInt("Radio:Duration") != 0 then
			local time = self.station:GetTime()
			if ent:GetNWString("Radio:Mode") != "3" then
				surface.SetDrawColor(color)
				surface.DrawRect( -50, 45, 315*time/ent:GetNWInt("Radio:Duration"), 5)
			else
				surface.SetTextColor( color_white )
				surface.SetTextPos( 0, 0 )
				surface.DrawText( Radio.SecondsToClock(self.station:GetTime()) )	
			end
		end
	end
end

function DrawRadioInfo_View(self)
	color = string.ToColor(self:GetNWString("Radio:Visual"))

	local ent = self:GetNWEntity("Radio:Entity")
	surface.SetFont( "Radio.Video.Info" )

	if self:GetNWInt("Radio:Info") != "" then
		surface.SetTextColor( color_orange )
		surface.SetTextPos( -30, 0 )
		surface.DrawText( self:GetNWInt("Radio:Info") )	
	elseif self.station and IsValid(self.station) then
		surface.SetTextColor( color_white )
		surface.SetTextPos( -20, 10-50 )

		local Title = ent:GetNWString("Radio:Title")
		local w, _ = surface.GetTextSize( Title );
		if( w > 270 ) then

			for i = string.len( Title ), 1, -1 do

				w, _ = surface.GetTextSize( string.sub( Title, 1, i ) );
				if( w <= 290 ) then

					surface.DrawText( string.sub( Title, 1, i ) .. "..." );
					break;

				end

			end

		else
			surface.DrawText( Title );
		end

		surface.SetTextPos( -20, 30-50 )

		local Author = ent:GetNWString("Radio:Author")
		local w, _ = surface.GetTextSize( Author );
		if( w > 270 ) then

			for i = string.len( Author ), 1, -1 do

				local w, _ = surface.GetTextSize( string.sub( Author, 1, i ) );
				if( w <= 290 ) then

					surface.DrawText( string.sub( Author, 1, i ) .. "..." );
					break;

				end

			end

		else
			surface.DrawText( Author );
		end

		if ent:GetNWInt("Radio:Duration") != 0 then
			local time = self.station:GetTime()
			if ent:GetNWString("Radio:Mode") != "3" then
				surface.SetDrawColor(color)
				surface.DrawRect( -40, 60, 315*time/ent:GetNWInt("Radio:Duration"), 5)
			else
				surface.SetTextColor( color_white )
				surface.SetTextPos( 0, 0 )
				surface.DrawText( Radio.SecondsToClock(self.station:GetTime()) )	
			end
		end
	end
end

local bar = 128
local maxw = 2980
local prevFrame = {}
local bar_w = math.Round(maxw/(bar+1))
function DrawRadioFFT(self)
	color = string.ToColor(self:GetNWString("Radio:Visual"))

	if self.station and IsValid(self.station) then
		if !self.FTT then
			self.FTT = {}
		end
		
		if( self.station:GetState() == GMOD_CHANNEL_PLAYING ) then
			self.station:FFT(self.FTT, FFT_256)
		
			surface.SetDrawColor(color)
	
			for i = 1, bar do
				if (i-1) * (bar_w+10) + bar_w > maxw then
					break
				end

				if not prevFrame[i] then prevFrame[i] = 0 end
				prevFrame[i] = math.Clamp(Lerp(2.5 * FrameTime(), prevFrame[i], -self.FTT[i] * 100 * self:GetNWInt("Radio:Volume")), -850, 0 )

				if self:GetNWBool("Radio:Rainbow") then
					local c = HSVToColor( i * 360 / bar, 1, 1 );
					surface.SetDrawColor( c ); --Rainbow 
				end
				surface.DrawRect((i-1) * (bar_w+10)- 550, 1400, bar_w, prevFrame[i])
			end
		end
	end
end

function DrawRadioFFT_View(self)
	color = string.ToColor(self:GetNWString("Radio:Visual"))

	if self.station and IsValid(self.station) then
		if !self.FTT then
			self.FTT = {}
		end
		
		if( self.station:GetState() == GMOD_CHANNEL_PLAYING ) then
			self.station:FFT(self.FTT, FFT_256)
		
			surface.SetDrawColor(color)
		
			for i = 1, bar do
				if (i-1) * (bar_w+10) + bar_w > maxw then
					break
				end

				if not prevFrame[i] then prevFrame[i] = 0 end
				prevFrame[i] = math.Clamp(Lerp(2.5 * FrameTime(), prevFrame[i], -self.FTT[i] * 100 * self:GetNWInt("Radio:Volume")), -850, 0 )

				if self:GetNWBool("Radio:Rainbow") then
					local c = HSVToColor( i * 360 / bar, 1, 1 );
					surface.SetDrawColor( c ); --Rainbow 
				end
				surface.DrawRect((i-1) * (bar_w+10)- 500, 1500, bar_w, prevFrame[i])
			end
		end
	end
end

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 52.222, 0) },
	["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 25.555, 0) },
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(1, -5.678, 4.5), angle = Angle(0, 50, 0) },
	["ValveBiped.Bip01_R_Finger42"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -76.667, 0) },
	["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 45.555, 0) },
	["ValveBiped.Bip01_R_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -52.223, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -1.111, 72.222) },
	["ValveBiped.Bip01_R_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 90, 0) },
	["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 52.222, 0) },
	["v_weapon.Knife_Handle"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 67.777, 0) },
	["ValveBiped.Bip01_R_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 43.333, 0) },
	["ValveBiped.Bip01_R_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -72.223, 0) },
	["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 43.333, 0) },
	["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -52.223, 0) },
	["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(6.48, 0, -0.186), angle = Angle(0, -25.556, -23.334) },
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(-6.782, -7.099, 9.432), angle = Angle(10.057, 3.332, 39.819) }
}

SWEP.WElements = {
	["radio"] = { type = "Model", model = "models/sligwolf/grocel/radio/ghettoblaster.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-12.605, 3.368, -6.555), angle = Angle(-9.277, -82.798, -124.943), size = Vector(1, 1, 1), color = modelcolor, surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["info"] = { type = "Quad", bone = "ValveBiped.Bip01_R_Hand", rel = "radio", pos = Vector(1.934, 4.441, 7.102), angle = Angle(0, 90, 90), size = 0.04, draw_func = DrawRadioInfo},
	["info2"] = { type = "Quad", bone = "ValveBiped.Bip01_R_Hand", rel = "radio", pos = Vector(2.1, 4.441, 7.102), angle = Angle(0, 90, 90), size = 0.005, draw_func = DrawRadioFFT},
}

SWEP.VElements = {
	["radio"] = { type = "Model", model = "models/sligwolf/grocel/radio/ghettoblaster.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.15, 1.065, 0.423), angle = Angle(0, -97.014, -92.641), size = Vector(0.5, 0.5, 0.5), color = modelcolor, surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["info"] = { type = "Quad", bone = "ValveBiped.Bip01", rel = "radio", pos = Vector(0.902, 2.374, 3.789), angle = Angle(0, 90, 90), size = 0.02, draw_func = DrawRadioInfo_View},
	["info2"] = { type = "Quad", bone = "ValveBiped.Bip01", rel = "radio", pos = Vector(1.1, 2.374, 3.789), angle = Angle(0, 90, 90), size = 0.0025, draw_func = DrawRadioFFT_View}
}

function SWEP:Initialize()
	self:SetHoldType("melee")
	self.DistanceSound = Radio.Settings.DistanceSound^2

	self:SetNWString( "Radio:ID", "" )
    self:SetNWString( "Radio:Author", "" )
    self:SetNWString( "Radio:Title", "" )
    self:SetNWString( "Radio:Mode", "0" )
    self:SetNWString( "Radio:Info", "" )
    self:SetNWString( "Radio:Visual", "255 255 255" )
	self:SetNWString( "Radio:Color", "255 255 255" )

    self:SetNWInt( "Radio:Volume", 50 )
    self:SetNWInt( "Radio:Time", CurTime() )
    self:SetNWInt( "Radio:Duration", 0)
    self:SetNWInt( "Radio:DistanceSound", self.DistanceSound)

    self:SetNWBool( "Radio:Pause", false)
	self:SetNWBool("Radio:Rainbow", false)
	self:SetNWBool("Radio:Private", false)
    self:SetNWBool("Radio:PrivateBuddy", false)

	self:SetNWEntity("Radio:Entity", self)
	self.LastStation = self

	Radio.Weapon[self] = true
	Radio.AllRadio[self] = true
	
	// other initialize code goes here
	if CLIENT then
	
		// Create a new table for every weapon instance
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )
		self:CreateModels(self.VElements) // create viewmodels
		self:CreateModels(self.WElements) 

		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				

				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else

					vm:SetColor(Color(255,255,255,1))

					vm:SetMaterial("Debug/hsv")			
				end
			end
		end
		
	end
end

function SWEP:Holster()
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end

	if self.station and IsValid(self.station) then
		self.station:SetVolume(0)
	end
	
	return true
end

function SWEP:OnRemove()
	self:Holster()

	Radio.Weapon[self] = nil
	Radio.AllRadio[self] = nil	

	if CLIENT then
		Radio.StopMusic(self)
	end

	if SERVER and IsValid(self.LastStation) then
		self.LastStation:SetNWInt("Radio:Viewer", self.LastStation:GetNWInt("Radio:Viewer")-1)
	end
end

hook.Add("canDropWeapon", "Radio:canDropWeapon", function(ply, ent)
	if ent:GetClass() == "numerix_radio_swep" then return false end
end)

if CLIENT then
	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		
		if (!self.VElements) then return end
		
		self:UpdateBonePositions(vm)
		if (!self.vRenderOrder) then
			
			self.vRenderOrder = {}
			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end
		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				model:SetAngles(ang)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
	
				local color = string.ToColor(self:GetNWString("Radio:Color"))
				render.SetColorModulation(color.r/255,color.g/255, color.b/255 )
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()
			end
			
		end
		
	end
	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then
			self.wRenderOrder = {}
			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end
		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				model:SetAngles(ang)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				local color = string.ToColor(self:GetNWString("Radio:Color"))
				render.SetColorModulation(color.r/255,color.g/255, color.b/255 )
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()
			end
			
		end
		
	end
	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)
			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r
			end
		
		end
		
		return pos, ang
	end
	function SWEP:CreateModels( tab )
		if (!tab) then return end

		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.modelEnt:SetColor(self.Color)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end

			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				// !! WORKAROUND !! //
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				// !! ----------- !! //
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end

	function table.FullCopy( tab )
		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) // recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
	
end