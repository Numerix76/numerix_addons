--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
util.AddNetworkString("Radio:RetrieveFromVehicle")
util.AddNetworkString("Radio:RemoveFromVehicle")
util.AddNetworkString("Radio:SendVehicleData")

function Radio.RetrieveFromVehicle(len, ply)
    local ent = net.ReadEntity()

    if !IsValid(ent) or ply:InVehicle() then return end

    if Radio.IsCar(ent) and Radio.CanModificateRadio(ply, ent) then
               
        if ent:GetNWBool("Radio:HasRadio") then

            local radio = !ply:HasWeapon("numerix_radio_swep") and Radio.Settings.EnableSWEP and ply:Give("numerix_radio_swep") or Radio.Settings.EnableEntity and ents.Create( "numerix_radio" ) or nil
            if !IsValid(radio) then return end

            if isentity(radio) then
                radio:SetPos( ent:GetPos() + ent:GetRight()*100 + ent:GetUp()*50 )
                radio:Spawn()
                if FPP then
                    radio:CPPISetOwner(ply)
                end
            end

            ent:SetNWBool("Radio:HasRadio", false)
            Radio.ChangeMod(ply, ent, radio)
            if Radio.Vehicle[ent] then
                Radio.Vehicle[ent] = nil
                Radio.AllRadio[ent] = nil
            end

            net.Start("Radio:RemoveFromVehicle")
            net.WriteEntity(ent)
            net.Broadcast()

            ply:RadioChatInfo(Radio.GetLanguage("You have retrieve the radio from the car."), 2)  
        else
            ply:RadioChatInfo(Radio.GetLanguage("There is no radio from the car."), 1)  
        end
    else
        ply:RadioChatInfo(Radio.GetLanguage("You are not the owner the car."), 1)  
    end
end
net.Receive("Radio:RetrieveFromVehicle", Radio.RetrieveFromVehicle)

hook.Add("Think", "Radio:ThinkServer", function()
    for ent, _ in pairs(Radio.Vehicle) do
        if Radio.IsCar(ent) then
            Radio.Think(ent, ent:GetNWEntity("Radio:Entity"))
        end
    end
end)

hook.Add("EntityRemoved", "Radio:OnVehiculeRemove", function(ent)
    if Radio.IsCar(ent) and ent:GetNWBool("Radio:HasRadio") then     
        local station = ent:GetNWEntity("Radio:Entity")
        if station != ent then
            station:SetNWInt("Radio:Viewer", station:GetNWInt("Radio:Viewer")-1)
        end
        
        Radio.Vehicle[ent] = nil
        Radio.AllRadio[ent] = nil
    end
end)