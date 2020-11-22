--[[ Cinematic Intro --------------------------------------------------------------------------------------

Cinematic Intro made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
local function getDuration(str)
    local h = str:match("(%d+)H") or 0
    local m = str:match("(%d+)M") or 0
    local s = str:match("(%d+)S") or 0

    return h*(60*60) + m*60 + s
end

function Intro.StartYoutube(id)
    local ply = LocalPlayer()
    if timer.Exists("Intro.YT:GetPercentage") then
        timer.Destroy("Intro.YT:GetPercentage")
    end
    
    local info = {}

    local port
    if Intro.Informations.PlayVideo then 
        port = 8081
    else
        port = 8082
    end
                
    http.Fetch( "http://92.222.234.121:"..port.."/"..id, 
        function( body, len, headers, code )
            local data = util.JSONToTable(body)
            
            if istable(data) and data.link then
                info.Link = data.link
                info.Already = data.already

                if !info.Already and !timer.Exists("Intro.YT:GetPercentage") then
                    timer.Create("Intro.YT:GetPercentage", 1, 0, function()
                        Intro.StatusConversion(ply, id, info)   
                    end)
                else
                    if Intro.Informations.PlayVideo then 
                        Intro.PlayVideo(info.Link, getDuration(data.duration))
                    else
                        Intro.PlayMusic(info.Link)
                    end
                end
            else
                ply:IntroChatInfo(Intro.GetLanguage("An error occurred while retrieving the data. Contact an administrator if this persists."), 3) 
                Intro.StopVideo()
            end
        end,

        function( error )
            ply:IntroChatInfo(string.format(Intro.GetLanguage("An error occurred while converting. Contact an administrator if this persists. Error : %s"), error), 3)
        
            if timer.Exists("Intro.YT:GetPercentage") then
                timer.Destroy("Intro.YT:GetPercentage")
            end

            Intro.StopVideo()
        end
    )
end

function Intro.StatusConversion(ply, id, info)
    local entity = tostring(ent)

    local port
    if Intro.Settings.Map[game.GetMap()].PlayVideo then 
        port = 8081
    else
        port = 8082
    end

    http.Fetch( "http://92.222.234.121:"..port.."/logs/"..id..".txt", 
        function( body, len, headers, code )
            if (code != 200 or body == "") and timer.Exists("Intro.YT:GetPercentage") then 
                timer.Destroy("Intro.YT:GetPercentage")

                ply:IntroChatInfo(string.format(Intro.GetLanguage("An error occurred while converting. Contact an administrator if this persists. Error : %s"), error), 3)
            
                Intro.StopVideo()
            end

            local data = util.JSONToTable(body)

            if istable(data) then
                if (data.percent and data.percent != 100) and !data.title then
                    ply:IntroChatInfo(string.format(Intro.GetLanguage("Conversion %d%%"), math.Round(data.percent) ) )
                elseif (data.percent and data.percent == 100) or data.title then
                    if Intro.Informations.PlayVideo then 
                        Intro.PlayVideo(info.Link, getDuration(data.duration))
                    else
                        Intro.PlayMusic(info.Link)
                    end

                    if timer.Exists("Intro.YT:GetPercentage") then
                        timer.Destroy("Intro.YT:GetPercentage")
                    end
                else
                    ply:IntroChatInfo(Intro.GetLanguage("An error occurred while converting. Contact an administrator if this persists.") )

                    if timer.Exists("Intro.YT:GetPercentage") then
                        timer.Destroy("Intro.YT:GetPercentage")
                    end

                    Intro.StopVideo()
                end
            end
        end,

        function( error )
            ply:IntroChatInfo(string.format(Intro.GetLanguage("An error occurred while retrieving the data. Contact an administrator if this persists. Error : %s"), error), 3)
            
            if timer.Exists("Intro.YT:GetPercentage") then
                timer.Destroy("Intro.YT:GetPercentage")
            end

            Intro.StopVideo()
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

function Intro.PlayVideo(url, duration)
    Intro.frame = vgui.Create("DHTML")
    Intro.frame:SetPos(0,0)
    Intro.frame:SetSize(ScrW(), ScrH())
    Intro.frame:OpenURL(url)
    Intro.frame:AddFunction("console", "time", function(str)
        if math.Round(tonumber(str)) >= duration-1 then
            Intro.StopVideo()
        end   
    end)
    Intro.frame:SetAllowLua( true )
    Intro.frame:RunJavascript("vid.volume = "..Intro.Informations.MusicVolume)
    Intro.frame.Think = function()
        if input.IsKeyDown(Intro.Settings.ExitKey) then
            Intro.StopVideo()
        end

        Intro.frame:RunJavascript("console.time(vid.currentTime);")
    end
end

function Intro.StopVideo()
    if IsValid(Intro.frame) then
        Intro.frame:Remove()
    end

    Intro.EndIntro()
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