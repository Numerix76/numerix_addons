--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

function Radio.SetMusicMP3(ply, ent, id)
    
    if ent.isloading then return end
    
    ent:SetNWString( "Radio:ID", "")
    ent:SetNWString( "Radio:Mode", "0")
    
    ent:SetNWString("Radio:Info", Radio.GetLanguage("Loading"))

    ent.isloading = true

    http.Fetch( "http://92.222.234.121/mp3/mp3api.php?id="..id,
        function( body, len, headers, code )
            local data = util.JSONToTable(string.Explode("}", body)[1].."}")
               
            if istable(data) then
                if data["exist"] == "true" then
                    if data["duration"] == "live" then
                        ent:SetNWString( "Radio:Mode", "3")
                        ent:SetNWInt( "Radio:Duration", -1)
                    else

                        if data["duration"] > Radio.Settings.MaxDuration then 
                            ent.isloading = false
                            ply:RadioChatInfo(string.format(Radio.GetLanguage("The duration of the sound is too big. Max : %s"), string.NiceTime(Radio.Settings.MaxDuration) ), 3)
                            ent:SetNWString("Radio:Info", "")
                            
                            return
                        end

                        ent:SetNWString( "Radio:Mode", "2")
                        ent:SetNWInt( "Radio:Duration", data["duration"])
                    end

                    if data["title"] ==  "live" then
                        ent:SetNWString( "Radio:Title", Radio.GetLanguage("Internet Radio"))
                    else
                        ent:SetNWString( "Radio:Title", data["title"] or Radio.GetLanguage("No information"))
                    end

                    if data["artist"] == "live" then
                        ent:SetNWString( "Radio:Author", "")
                    else
                        ent:SetNWString( "Radio:Author", data["artist"])
                    end

                    ent:SetNWString( "Radio:ID", id)
                    ent:SetNWInt( "Radio:Time", CurTime())
                    ent:SetNWString("Radio:Info", "")

                    ent.isloading = false
                else
                    ent:SetNWString("Radio:Info", "")
                    ply:RadioChatInfo(Radio.GetLanguage("The file does not exist."), 3)

                    ent.isloading = false
                end
            else
                ent:SetNWString("Radio:Info", "")
                ply:RadioChatInfo(Radio.GetLanguage("Check the URL of .mp3."), 3)

                ent.isloading = false
            end
        end,
        function( error ) 
            ent:SetNWString("Radio:Info", "")
            Radio.Error(ply, string.format(Radio.GetLanguage("An error occurred while retrieving the data. Contact an administrator if this persists. Error : %s"), error))
            ent.isloading = false
        end
    )
end