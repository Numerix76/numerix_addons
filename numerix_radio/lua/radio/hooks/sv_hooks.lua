--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
hook.Add("OnEntityCreated", "Radio:OnVehiculeCreate", function(ent)
	if ent:IsCarRadio() and Radio.Settings.VehicleSpawnRadio then
		Radio.AllRadio[ent] = true
		ent:InitRadio()
		ent:SetNWBool("Radio:HasRadio", true)
	end
end)

hook.Add("EntityRemoved", "Radio:OnVehiculeRemove", function(ent)
    if ent:IsCarRadio() and ent:GetNWBool("Radio:HasRadio") then           
        ent:DeleteRadio()
    end
end)

hook.Add("canDropWeapon", "Radio:canDropWeapon", function(ply, ent)
	if ent.SWEPRadio then return false end
end)

hook.Add("PlayerEnteredVehicle", "Radio:PlayerEnterVehicle", function(ply, veh)
	local weapon = ply:GetActiveWeapon()
	if IsValid(weapon) and weapon.SWEPRadio then
		weapon.lastvolume = weapon:GetNWInt("Radio:Volume")
		weapon:SetNWInt("Radio:Volume", 0)
	end
end)

hook.Add("PlayerLeaveVehicle", "Radio:PlayerLeaveVehicle", function(ply, veh)
	local weapon = ply:GetActiveWeapon()
	if IsValid(weapon) and weapon.SWEPRadio then
		weapon:SetNWInt("Radio:Volume", weapon.lastvolume or 50)
		weapon.lastvolume = nil
	end
end)

hook.Add( "PlayerCanHearPlayersVoice", "Radio:CanPlayerHearRadioVoice", function( listener, talker ) 
	for ent, _ in pairs( Radio.AllRadio ) do
		if !IsValid(ent) then continue end

		local controler = ent:GetControlerRadio(ent)
		
		if ent:IsCarRadio() and !ent:CanHearInCarRadio(listener) or !ent:IsCarRadio() and ent:GetPos():DistToSqr( listener:GetPos() ) < ent.DistanceSound then continue end

		if 	ent:CanHearRadio(listener) and ( IsValid(controler) and controler != ent and controler:GetNWBool("Radio:Voice") ) and
			( talker:GetPos():DistToSqr( controler:GetPos() ) < 100000 ) then
				
			return true, false
		end
	end
end)

hook.Add( "playerGetSalary", "Radio:AnimSalary", function(ply, amount)
    if Radio.Settings.MakeSalary then
        if ply:Team() == Radio.Settings.TeamRadio then 
            local total = 0
            for _, ent in ipairs(Radio.AllServer) do
                if ent.FPPOwner != ply then continue end
                total = total + ent:GetNWInt("Radio:Viewer")*Radio.Settings.Salary
            end

            return false, DarkRP.getPhrase("payday_message", amount).." (+"..DarkRP.formatMoney(total)..")", total+amount
        end
    end
end)