--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

function Radio.GetYoutubeID( url )

	if( string.find( url, "youtu.be/" ) ) then

		local qs = string.Explode( "?", url )[1];
		local qb = string.Explode( "youtu.be/", qs );
		if( #qb == 1 ) then
			if( string.len( qb[1] ) == 11 ) then
				return qb[1];
			end
		end

		if( string.len( qb[2] ) == 11 ) then
			return qb[2];
		end

	end

	local qs = string.Explode( "?", url );
	if( #qs == 1 ) then
		if( string.len( qs[1] ) == 11 ) then
			return qs[1];
		end
		return;
	end

	local a = string.Explode( "v=", qs[2] );

	if( #a == 1 ) then
		if( string.len( a[1] ) == 11 ) then
			return a[1];
		end
		return;
	end

	local b = string.Explode( "&", a[2] );
	
	if( string.len( b[1] ) == 11 ) then
		return b[1];
	end

end

function Radio.GetSoundCloud(url)
    id = string.Explode("/", url)
                
    if #id > 4 and id[5] != "" then
        id = id[1].."//"..id[3].."/"..id[4].."/"..id[5]

        return id
    end
end

function Radio.SecondsToClock(seconds)
    local seconds = tonumber(seconds)
  
    if seconds <= 0 then
      return "00:00:00";
    else
        hours = string.format("%02.f", math.floor(seconds/3600));
        mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
        secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
        return hours..":"..mins..":"..secs
    end
end

function Radio.IsCar(ent)
    if !IsValid(ent) then return false end
	if IsValid(ent:GetParent()) then return false end
	
    if ent:IsVehicle() then return true end
    if simfphys and simfphys.IsCar(ent) then return true end
    if ent:GetClass() == "prop_vehicle_jeep" then return true end
	if scripted_ents.IsBasedOn(ent:GetClass(), "wac_hc_base") then return true end
	
	local iscar = hook.Call("Radio:IsCar", nil, ent)
	if iscar != nil then return iscar end

    return false
end

function Radio.Error(ply, message)
	ply:RadioChatInfo(message, 3) 

	if Radio.Settings.Debug then
		ply:RadioChatInfo(Radio.GetLanguage("Check your console to have a debug trace"), 3) 
		ply:PrintMessage( 2, Radio.Trace() )
	end

end

function Radio.Trace()

	local level = 3
	local msg = ""

	msg = msg.."\nTrace:\n"

	while true do

		local info = debug.getinfo( level, "Sln" )
		if ( !info ) then break end

		if ( info.what ) == "C" then

			msg = msg..string.format( "\t%i: C function\t\"%s\"\n", level, info.name )

		else

			msg = msg..string.format( "\t%i: Line %d\t\"%s\"\t\t%s\n", level, info.currentline, info.name, info.short_src )

		end

		level = level + 1

	end

	msg = msg.."\n"

	return msg

end