--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

hook.Add("Think", "Radio:Think", function()
	for ent, _ in pairs(Radio.AllRadio) do
		if !IsValid(ent) then continue end
		if ent.SWEPRadio and (!IsValid(ent.Owner) or !ent.Owner:Alive()) then continue end

		ent:ThinkRadio()
	end
end)