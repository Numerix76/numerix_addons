--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

function Radio.SetMusicSC(ply, ent, id)
    
    if ent.isloading then return end
    
    ent:SetNWString( "Radio:ID", "")
    ent:SetNWString( "Radio:Mode", "0")
    ent.isloading = true
    
    local info = {}

    ent:SetNWString( "Radio:Info", Radio.GetLanguage("Loading"))

    http.Fetch( "http://92.222.234.121/soundcloud/download.php?url="..id, 
        function( body, len, headers, code )
            local data = util.JSONToTable(body)
            
            if istable(data) and data.link != "" then

                if data.duration/1000 > Radio.Settings.MaxDuration then 
                    ent.isloading = false
                    ply:RadioChatInfo(string.format(Radio.GetLanguage("The duration of the sound is too big. Max : %s"), string.NiceTime(Radio.Settings.MaxDuration) ), 3)
                    ent:SetNWString( "Radio:Info", "")
                    
                    return
                end

                ent:SetNWString( "Radio:ID", data.link)
                ent:SetNWString( "Radio:Author", data.author or Radio.GetLanguage("No information"))
                ent:SetNWString( "Radio:Title", data.title)
                ent:SetNWString( "Radio:Mode", "4")

                ent:SetNWInt( "Radio:Duration", data.duration/1000)
                ent:SetNWInt( "Radio:Time", CurTime())
                ent:SetNWString( "Radio:Info", "")

                ent.isloading = false
            elseif istable(data) then
                ent:SetNWString( "Radio:Info", "")
                Radio.Error(ply, string.format(Radio.GetLanguage("An error occurred while retrieving the data. Contact an administrator if this persists. Error : %s"), data.error))
                
                ent.isloading = false
            end
        end,

        function( error )
            ent:SetNWString( "Radio:Info", "")
            Radio.Error(ply, string.format(Radio.GetLanguage("An error occurred while retrieving the data. Contact an administrator if this persists. Error : %s"), error))
        
            ent.isloading = false
        end
    )  
end