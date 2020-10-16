--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
function Radio.SetMusicYT(ply, ent, id)
    if ent.isloading then return end

    local entity = tostring(ent)
    if timer.Exists("Radio.YT:GetPercentage"..entity) then
        timer.Destroy("Radio.YT:GetPercentage"..entity)
    end

    ent:SetNWString( "Radio:ID", "")
    ent:SetNWString( "Radio:Mode", "0")

    ent.isloading = true

    ent:SetNWString( "Radio:Info", Radio.GetLanguage("Retrieving data"))
    
    Radio.getVideoInfo(ply, ent, id)
end

function Radio.getVideoInfo(ply, ent, id)
    local info = {}
    http.Fetch( "https://www.googleapis.com/youtube/v3/videos?part=snippet%2CcontentDetails&id="..id.."&key="..Radio.Settings.APIKey,
    function( body, len, headers, code )
        local data = util.JSONToTable(body)

        if data and data.items and data.items[1] then
            local str = data.items[1].contentDetails.duration
                local h = str:match("(%d+)H") or 0
                local m = str:match("(%d+)M") or 0
                local s = str:match("(%d+)S") or 0
               
                info.Author = data.items[1].snippet.channelTitle or Radio.GetLanguage("No information")
                info.Title = data.items[1].snippet.title
                info.Duration = h*(60*60) + m*60 + s
                
                if info.Duration > Radio.Settings.MaxDuration then 
                    ent.isloading = false
                    ply:RadioChatInfo(string.format(Radio.GetLanguage("The duration of the sound is too big. Max : %s"), string.NiceTime(Radio.Settings.MaxDuration) ), 3)
                    ent:SetNWString( "Radio:Info", "")
                    return
                end
                
                Radio.StartConversion(ply, ent, id, info)
            else
                Radio.Error(ply, Radio.GetLanguage("An error occurred while retrieving the data. Contact an administrator if this persists."))
                ent.isloading = false
            end
        end,
        function( error )
            Radio.Error(ply, string.format(Radio.GetLanguage("An error occurred while converting. Contact an administrator if this persists. Error : %s"), error))
            ent.isloading = false
        end
    )
end

function Radio.StartConversion(ply, ent, id, info)
    local entity = tostring(ent)

    http.Fetch( "http://92.222.234.121:8080/"..id, 
    function( body, len, headers, code )
        local data = util.JSONToTable(body)
        
        if istable(data) and data.link then
            info.Link = data.link
            info.Already = data.already
            
            if !info.Already and !timer.Exists("Radio.YT:GetPercentage"..entity) then
                    timer.Create("Radio.YT:GetPercentage"..entity, 1, 0, function()
                        Radio.StatusConversion(ply, ent, id, info)
                    end)
                else
                    ent:SetNWString( "Radio:ID", info.Link)
                    ent:SetNWString( "Radio:Author", info.Author)
                    ent:SetNWString( "Radio:Title", info.Title)
                    ent:SetNWString( "Radio:Mode", "1")
                    
                    ent:SetNWInt( "Radio:Duration", info.Duration)
                    ent:SetNWInt( "Radio:Time", CurTime())
                    ent:SetNWString( "Radio:Info", "")
                    
                    ent.isloading = false
                end
            else
                Radio.Error(ply, Radio.GetLanguage("An error occurred while retrieving the data. Contact an administrator if this persists."))
                ent.isloading = false
            end
        end,
        
        function( error )
            ent:SetNWString( "Radio:Info", Radio.GetLanguage("An error occured. Check the message in chat") )
            Radio.Error(ply, string.format(Radio.GetLanguage("An error occurred while converting. Contact an administrator if this persists. Error : %s"), error))
            
            if timer.Exists("Radio.YT:GetPercentage"..entity) then
                timer.Destroy("Radio.YT:GetPercentage"..entity)
            end
            
            ent.isloading = false
        end
    )
end

function Radio.StatusConversion(ply, ent, id, info)
    local entity = tostring(ent)

    http.Fetch( "http://92.222.234.121:8080/logs/"..id..".txt", 
        function( body, len, headers, code )
            if (code != 200 or body == "") and timer.Exists("Radio.YT:GetPercentage"..entity) then 
                timer.Destroy("Radio.YT:GetPercentage"..entity)
                
                Radio.Error(ply, string.format(Radio.GetLanguage("An error occurred while converting. Contact an administrator if this persists. Error : %s"), error))
                ent.isloading = false
            end
            
            local data = util.JSONToTable(body)
            if istable(data) then
                if (data.progress and data.progress.percentage != 100) and !data.videoTitle then
                    ent:SetNWString( "Radio:Info", string.format(Radio.GetLanguage("Conversion %d%% | Estimated time left : %d seconds"), math.Round(data.progress.percentage), data.progress.eta))
                elseif (data.progress and data.progress.percentage == 100) or data.videoTitle then
                    ent:SetNWString( "Radio:ID", info.Link)
                    ent:SetNWString( "Radio:Author", info.Author)
                    ent:SetNWString( "Radio:Title", info.Title)
                    ent:SetNWString( "Radio:Mode", "1")
                    
                    ent:SetNWInt( "Radio:Duration", info.Duration)
                    ent:SetNWInt( "Radio:Time", CurTime())
                    ent:SetNWString( "Radio:Info", "")
                    
                    if timer.Exists("Radio.YT:GetPercentage"..entity) then
                        timer.Destroy("Radio.YT:GetPercentage"..entity)
                    end
                    
                    ent.isloading = false
                else
                    ent:SetNWString( "Radio:Info", Radio.GetLanguage("An error occured. Check the message in chat") )
                    Radio.Error(ply, Radio.GetLanguage("An error occurred while retrieving the data. Contact an administrator if this persists.") )
                        
                    if timer.Exists("Radio.YT:GetPercentage"..entity) then
                        timer.Destroy("Radio.YT:GetPercentage"..entity)
                    end
        
                    ent.isloading = false
                end
            end
        end,
        
        function( error )
            ent:SetNWString( "Radio:Info", Radio.GetLanguage("An error occured. Check the message in chat") )
            Radio.Error(ply, string.format(Radio.GetLanguage("An error occurred while retrieving the data. Contact an administrator if this persists. Error : %s"), error))
                
            if timer.Exists("Radio.YT:GetPercentage"..entity) then
                timer.Destroy("Radio.YT:GetPercentage"..entity)
            end
            
            ent.isloading = false
        end
    )
end