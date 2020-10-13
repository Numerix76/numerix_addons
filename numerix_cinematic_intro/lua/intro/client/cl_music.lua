--[[ Cinematic Intro --------------------------------------------------------------------------------------

Cinematic Intro made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

function Intro.StartYoutube(id)
    local ply = LocalPlayer()
    if timer.Exists("Intro.YT:GetPercentage") then
        timer.Destroy("Intro.YT:GetPercentage")
    end
    
    local info = {}
                
    http.Fetch( "http://92.222.234.121:8080/"..id, 
        function( body, len, headers, code )
            local data = util.JSONToTable(body)
            
            if istable(data) and data.link then
                info.Link = data.link
                info.Already = data.already

                if !info.Already and !timer.Exists("Intro.YT:GetPercentage") then
                    timer.Create("Intro.YT:GetPercentage", 1, 0, function()
                        http.Fetch( "http://92.222.234.121:8080/logs/"..id..".txt", 
                            function( body, len, headers, code )
                                if (code != 200 or body == "") and timer.Exists("Intro.YT:GetPercentage") then 
                                    timer.Destroy("Intro.YT:GetPercentage")

                                    ply:IntroChatInfo(string.format(Intro.GetLanguage("An error occurred while converting. Contact an administrator if this persists. Error : %s"), error), 3)
                                end

                                local data = util.JSONToTable(body)
                    
                                if istable(data) and data.progress then
                                    if data.progress.percentage != 100 then
                                        ply:IntroChatInfo(string.format(Intro.GetLanguage("Conversion %d%% | Estimated time left : %d seconds"), math.Round(data.progress.percentage), data.progress.eta))
                                    else
                                        Intro.PlayMusic(info.Link)
    
                                        if timer.Exists("Intro.YT:GetPercentage") then
                                            timer.Destroy("Intro.YT:GetPercentage")
                                        end
                                    end
                                end
                            end,
    
                            function( error )
                                ply:IntroChatInfo(string.format(Intro.GetLanguage("An error occurred while retrieving the data. Contact an administrator if this persists. Error : %s"), error), 3)
                                
                                if timer.Exists("Intro.YT:GetPercentage") then
                                    timer.Destroy("Intro.YT:GetPercentage")
                                end
                            end
                        )
                    end)
                else
                    Intro.PlayMusic(info.Link)
                end
            else
                ply:IntroChatInfo(Intro.GetLanguage("An error occurred while retrieving the data. Contact an administrator if this persists."), 3) 
            end
        end,

        function( error )
            ply:IntroChatInfo(string.format(Intro.GetLanguage("An error occurred while converting. Contact an administrator if this persists. Error : %s"), error), 3)
        
            if timer.Exists("Intro.YT:GetPercentage") then
                timer.Destroy("Intro.YT:GetPercentage")
            end
        end
    )
end

function Intro.StartSoundCloud(id)
    local ply = LocalPlayer()
    
    local info = {}

    http.Fetch( "http://92.222.234.121/soundcloud/download.php?url="..id, 
        function( body, len, headers, code )
            local data = util.JSONToTable(body)
            
            if istable(data) and data.link != "" then
                Intro.PlayMusic(data.link)
            elseif istable(data) then
                ply:IntroChatInfo(string.format(Intro.GetLanguage("An error occurred while converting. Contact an administrator if this persists. Error : %s"), error), 3)  
            end
        end,

        function( error )
            ply:IntroChatInfo(string.format(Intro.GetLanguage("An error occurred while retrieving the data. Contact an administrator if this persists. Error : %s"), error), 3)
        end
    )  
end

function Intro.PlayMusic(url)

    sound.PlayURL (url, "noplay", function( station )
        if ( IsValid( station ) ) then
            Intro.station = station
            station:Play()
            station:SetVolume(math.Clamp(Intro.Informations.MusicVolume, 0, 1))
        else
            LocalPlayer():IntroChatInfo(Intro.GetLanguage("An error occurred when trying to play music. Please contact server owner if the error persist."), 3)
        end
    end)

end

function Intro.StopMusic()
    if Intro.station and IsValid(Intro.station) then
		Intro.station:Stop()

		Intro.station = nil
	end
end

function Intro.GetYoutubeID( url )

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

function Intro.GetSoundCloud(url)
    id = string.Explode("/", url)
                
    if #id > 4 and id[5] != "" then
        id = id[1].."//"..id[3].."/"..id[4].."/"..id[5]

        return id
    end
end