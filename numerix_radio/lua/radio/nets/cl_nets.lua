--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local function RemoveFromVehicle()
	local ent = net.ReadEntity()
	Radio.AllRadio[ent] = nil
end
net.Receive("Radio:RemoveFromVehicle", RemoveFromVehicle)

local function ReceiveVehicleData()
    local ent = net.ReadEntity()
	Radio.AllRadio[ent] = true
end
net.Receive("Radio:SendVehicleData", ReceiveVehicleData)