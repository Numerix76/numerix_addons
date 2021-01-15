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
    
    local info = {}
    Radio.StartConversion(ply, ent, id, info)
end

function Radio.StartConversion(ply, ent, id, info)
    local entity = tostring(ent)

    http.Fetch( "http://92.222.234.121:8082/"..id, 
        function( body, len, headers, code )
            local data = util.JSONToTable(body)
            
            if istable(data) and data.link then
                info.Link = data.link
                info.Already = data.already
               
                if Radio.getDurationYT(data.duration) > Radio.Settings.MaxDuration then
                    ent.isloading = false
                    ply:RadioChatInfo(string.format(Radio.GetLanguage("The duration of the sound is too big. Max : %s"), string.NiceTime(Radio.Settings.MaxDuration) ), 3)
                    ent:SetNWString( "Radio:Info", "")
                    return
                end

                if !info.Already and !timer.Exists("Radio.YT:GetPercentage"..entity) then
                    timer.Create("Radio.YT:GetPercentage"..entity, 1, 0, function()
                        Radio.StatusConversion(ply, ent, id, info)
                    end)
                else
                    Radio.StatusConversion(ply, ent, id, info)
                    
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

    http.Fetch( "http://92.222.234.121:8082/logs/"..id..".txt", 
        function( body, len, headers, code )
            if (code != 200 or body == "") and timer.Exists("Radio.YT:GetPercentage"..entity) then 
                timer.Destroy("Radio.YT:GetPercentage"..entity)
                
                Radio.Error(ply, string.format(Radio.GetLanguage("An error occurred while converting. Contact an administrator if this persists. Error : %s"), error))
                ent.isloading = false
            end
            
            local data = util.JSONToTable(body)
            if istable(data) then
                if (data.percent and data.percent < 100) and !data.title then
                    ent:SetNWString( "Radio:Info", string.format(Radio.GetLanguage("Conversion %d%%"), math.Round(data.percent)))
                elseif (data.percent and data.percent == 100) or data.title then
                    ent:SetNWString( "Radio:ID", info.Link)
                    ent:SetNWString( "Radio:Author", data.artist)
                    ent:SetNWString( "Radio:Title", data.title)
                    ent:SetNWString( "Radio:Mode", "1")
                    
                    ent:SetNWInt( "Radio:Duration", Radio.getDurationYT(data.duration))
                    ent:SetNWInt( "Radio:Time", CurTime())
                    ent:SetNWString( "Radio:Info", "")

                    ent:SetNWString( "Radio:Thumbnail", data.thumbnail)
                    ent:SetNWString( "Radio:ThumbnailName", id)
                    
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
