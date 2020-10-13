local function CanPlayerHearRadioVoice ( listener, talker )
    
	for ent, _ in pairs( Radio.AllRadio ) do
	
		if Radio.IsCar(ent) and (listener:InVehicle() and ( !IsValid(listener:GetVehicle():GetParent()) and listener:GetVehicle() != ent or IsValid(listener:GetVehicle():GetParent()) and listener:GetVehicle():GetParent() != ent) or !listener:InVehicle()) then continue end
	
		if( listener:GetPos():DistToSqr( ent:GetPos() ) < ent:GetNWInt("Radio:DistanceSound") ) then
			
			if( IsValid(ent:GetNWEntity("Radio:Entity")) and ent:GetNWEntity("Radio:Entity") != ent and ent:GetNWEntity("Radio:Entity"):GetNWBool("Radio:Voice") ) then

				if( talker:GetPos():DistToSqr( ent:GetNWEntity("Radio:Entity"):GetPos() ) < 100000 ) then
            
					return true, false

				end

			end

		end

	end

end
hook.Add( "PlayerCanHearPlayersVoice", "Radio:CanPlayerHearRadioVoice", CanPlayerHearRadioVoice )