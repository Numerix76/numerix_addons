--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

hook.Add("Think", "Radio:ThinkServer", function()
    for ent, _ in pairs(Radio.Vehicle) do
		if Radio.IsCar(ent) then
			Radio.Think(ent, ent:GetNWEntity("Radio:Entity"))
        end
    end
end)

hook.Add("EntityRemoved", "Radio:OnRemovedVehicle", function(ent)
    if Radio.IsCar(ent) and ent:GetNWBool("Radio:HasRadio") then
		Radio.StopMusic(ent)
		Radio.Vehicle[ent] = nil
		Radio.AllRadio[ent] = nil
    end
end)

local alreadystart
hook.Add( "PlayerButtonDown", "Radio:KeyPressVehicle", function(ply, button)
	if input.IsKeyDown(GetConVar("radio_open_menu"):GetInt()) and !alreadystart then
		alreadystart = true

		timer.Simple(0.5, function()
			alreadystart = false
		end)
	
		if IsValid( ply ) and ply:InVehicle() then
			local plyvehicle = ply:GetVehicle()
			local vehicle = IsValid(plyvehicle:GetParent()) and plyvehicle:GetParent() or plyvehicle

			if vehicle:GetNWBool("Radio:HasRadio") then  
				Radio.OpenStreamMenu(vehicle)
			else   
				ply:RadioChatInfo(Radio.GetLanguage("Please install a radio in the vehicle."), 1)                  
			end
		end
	end

	if input.IsKeyDown(GetConVar("radio_retrieve"):GetInt()) and !alreadystart then
		alreadystart = true

		timer.Simple(0.5, function()
			alreadystart = false
		end)

		if IsValid( ply ) and !ply:InVehicle() then
            local tr = util.TraceLine(util.GetPlayerTrace( ply ))
            if IsValid(tr.Entity) and Radio.IsCar(tr.Entity) then 
				net.Start("Radio:RetrieveFromVehicle")
				net.WriteEntity(tr.Entity)
                net.SendToServer()
            end
        end
    end
end)

hook.Add("OnEntityCreated", "Radio:UpdateData", function(ent)
	if Radio.IsCar(ent) and ent:GetNWBool("Radio:HasRadio") then
		Radio.Vehicle[ent] = true
		Radio.AllRadio[ent] = true
	end

	if ent:GetClass() == "numerix_radio_swep" then
		Radio.Weapon[ent] = true
		Radio.AllRadio[ent] = true
	end
end)


net.Receive("Radio:RemoveFromVehicle", function()
	local ent = net.ReadEntity()
	Radio.Vehicle[ent] = nil
	Radio.AllRadio[ent] = nil
end)

local function ReceiveVehicleData()
    local ent = net.ReadEntity()
	Radio.Vehicle[ent] = true
	Radio.AllRadio[ent] = true
end
net.Receive("Radio:SendVehicleData", ReceiveVehicleData)