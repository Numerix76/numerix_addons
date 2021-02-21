--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

Radio = Radio or {}

Radio.Settings = Radio.Settings or {}
Radio.Language = Radio.Language or {}

Radio.Color = Radio.Color or {}

Radio.AllRadio = Radio.AllRadio or {}
Radio.AllServer = Radio.AllServer or {}

local FileSystem = "radio"
local AddonName = "Radio"
local Version = "2.0.1"
local FromWorkshop = false

MsgC( Color( 225, 20, 30 ), "\n-------------------------------------------------------------------\n")
MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Version : "..Version.."\n")
MsgC( Color( 225, 20, 30 ), "-------------------------------------------------------------------\n\n")

if SERVER then

    for k, file in pairs (file.Find(FileSystem.."/config/*", "LUA")) do
        include(FileSystem.."/config/"..file)
        AddCSLuaFile(FileSystem.."/config/"..file)
        MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Loading : "..FileSystem.."/config/"..file.."\n")
    end

    local _, folders = file.Find(FileSystem.."/*", "LUA")

    for k, folder in ipairs(folders) do
        if folder == "config" then continue end

        for k, file in pairs (file.Find(FileSystem.."/"..folder.."/*", "LUA")) do
            if string.StartWith(file, "cl_") then
                AddCSLuaFile(FileSystem.."/"..folder.."/"..file)
            elseif string.StartWith(file, "sh_") then
                include(FileSystem.."/"..folder.."/"..file)
                AddCSLuaFile(FileSystem.."/"..folder.."/"..file)
            else
                include(FileSystem.."/"..folder.."/"..file)
            end
    
            MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Loading : "..FileSystem.."/"..folder.."/"..file.."\n")
        end
    end

    if FromWorshop then
        if Radio.Settings.VersionDefault != Radio.Settings.VersionCustom then
            hook.Add("PlayerInitialSpawn", "Radio:PlayerInitialSpawnCheckVersionConfig", function(ply)
                if ply:IsSuperAdmin() then
                    timer.Simple(10, function()
                        ply:RadioChatInfo(Radio.GetLanguage("A new version of the config file is available. Please download it."), 1)
                    end)
                end
            end)
        end

        if Radio.Language.VersionDefault != Radio.Language.VersionCustom then
            hook.Add("PlayerInitialSpawn", "Radio:PlayerInitialSpawnCheckVersionLanguage", function(ply)
                if ply:IsSuperAdmin() then
                    timer.Simple(10, function()
                        ply:RadioChatInfo(Radio.GetLanguage("A new version of the language file is available. Please download it."), 1)
                    end)
                end
            end)
        end
    end

    hook.Add("PlayerConnect", "Radio:Connect", function()
        if !game.SinglePlayer() then
            http.Post("https://gmod-radio-numerix.mtxserv.com/api/connect.php", { script = FileSystem, ip = game.GetIPAddress() }, 
            function(result)
                if result then 
                    MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Connection established\n") 
                end
            end, 
            function(failed)
                MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Connection failed : "..failed.."\n")
            end)
        end

        if !FromWorshop then
            http.Fetch( "https://gmod-radio-numerix.mtxserv.com/api/version/"..FileSystem..".txt",
                function( body, len, headers, code )
                    if body != Version then
                        hook.Add("PlayerInitialSpawn", "Radio:PlayerInitialSpawnCheckVersionAddon", function(ply)
                            if ply:IsSuperAdmin() then
                                timer.Simple(10, function()
                                    ply:RadioChatInfo(Radio.GetLanguage("A new version of the addon is available. Please download it."), 1)
                                end)
                            end
                        end)
                    end 
                end,
                function( error )
                    MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Failed to retrieve version infomation\n") 
                end
            )
        end

        hook.Remove("PlayerConnect", "Radio:Connect")
    end)

    hook.Add("ShutDown", "Radio:Disconnect", function()
        if !game.SinglePlayer() then
            http.Post("https://gmod-radio-numerix.mtxserv.com/api/disconnect.php", { script = FileSystem, ip = game.GetIPAddress() }, 
            function(result)
                if result then 
                    MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Disconnection\n") 
                end
            end, 
            function(failed)
                MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Disconnection failed : "..failed.."\n")
            end)
        end
    end)

end

if CLIENT then

    for k, file in SortedPairs(file.Find(FileSystem.."/config/*", "LUA")) do
        include(FileSystem.."/config/"..file)

        MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Loading : "..FileSystem.."/config/"..file.."\n")
    end

    local _, folders = file.Find(FileSystem.."/*", "LUA")

    for k, folder in ipairs(folders) do
        if folder == "config" then continue end

        for k, file in pairs (file.Find(FileSystem.."/"..folder.."/*", "LUA")) do
            include(FileSystem.."/"..folder.."/"..file)
    
            MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Loading : "..FileSystem.."/"..folder.."/"..file.."\n")
        end
    end

    local files = file.Find( "numerix_images/radio/*", "DATA" )
    for k, v in ipairs(files) do
        file.Delete("numerix_images/radio/"..v )
    end

end