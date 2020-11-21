--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

Radio = Radio or {}

Radio.Settings = Radio.Settings or {}
Radio.Language = Radio.Language or {}

Radio.Vehicle = Radio.Vehicle or {}
Radio.Weapon = Radio.Weapon or {}
Radio.AllRadio = Radio.AllRadio or {}
Radio.AllServer = Radio.AllServer or {}

local FileSystem = "radio"
local FileSystem_Web = "radio_paid"
local AddonName = "Radio"
local Version = "1.1.5"
local FromWorkshop = false

if SERVER then

    MsgC( Color( 225, 20, 30 ), "\n-------------------------------------------------------------------\n")
    MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Version : "..Version.."\n")
    MsgC( Color( 225, 20, 30 ), "-------------------------------------------------------------------\n\n")

    for k, file in pairs (file.Find(FileSystem.."/config/*", "LUA")) do
        include(FileSystem.."/config/"..file)
        AddCSLuaFile(FileSystem.."/config/"..file)
        MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Loading : "..FileSystem.."/config/"..file.."\n")
    end

    for k, file in pairs (file.Find(FileSystem.."/mp3/*", "LUA")) do
        if string.StartWith(file, "cl_") then
            AddCSLuaFile(FileSystem.."/mp3/"..file)
        elseif string.StartWith(file, "sh_") then
            include(FileSystem.."/mp3/"..file)
            AddCSLuaFile(FileSystem.."/mp3/"..file)
        else
            include(FileSystem.."/mp3/"..file)
        end

        MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Loading : "..FileSystem.."/mp3/"..file.."\n")
    end

    for k, file in pairs (file.Find(FileSystem.."/soundcloud/*", "LUA")) do
        if string.StartWith(file, "cl_") then
            AddCSLuaFile(FileSystem.."/soundcloud/"..file)
        elseif string.StartWith(file, "sh_") then
            include(FileSystem.."/soundcloud/"..file)
            AddCSLuaFile(FileSystem.."/soundcloud/"..file)
        else
            include(FileSystem.."/soundcloud/"..file)
        end
        
        MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Loading : "..FileSystem.."/soundcloud/"..file.."\n")
    end

    for k, file in pairs (file.Find(FileSystem.."/utils/*", "LUA")) do
        if string.StartWith(file, "cl_") then
            AddCSLuaFile(FileSystem.."/utils/"..file)
        elseif string.StartWith(file, "sh_") then
            include(FileSystem.."/utils/"..file)
            AddCSLuaFile(FileSystem.."/utils/"..file)
        else
            include(FileSystem.."/utils/"..file)
        end
        
        MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Loading : "..FileSystem.."/utils/"..file.."\n")
    end

    if Radio.Settings.EnableVehicle then
        for k, file in pairs (file.Find(FileSystem.."/vehicle/*", "LUA")) do
            if string.StartWith(file, "cl_") then
                AddCSLuaFile(FileSystem.."/vehicle/"..file)
            elseif string.StartWith(file, "sh_") then
                include(FileSystem.."/vehicle/"..file)
                AddCSLuaFile(FileSystem.."/vehicle/"..file)
            else
                include(FileSystem.."/vehicle/"..file)
            end
            
            MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Loading : "..FileSystem.."/vehicle/"..file.."\n")
        end
    end

    for k, file in pairs (file.Find(FileSystem.."/youtube/*", "LUA")) do
        if string.StartWith(file, "cl_") then
            AddCSLuaFile(FileSystem.."/youtube/"..file)
        elseif string.StartWith(file, "sh_") then
            include(FileSystem.."/youtube/"..file)
            AddCSLuaFile(FileSystem.."/youtube/"..file)
        else
            include(FileSystem.."/youtube/"..file)
        end
        
        MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Loading : "..FileSystem.."/youtube/"..file.."\n")
    end

    for k, file in pairs (file.Find(FileSystem.."/menu/*", "LUA")) do
        if string.StartWith(file, "cl_") then
            AddCSLuaFile(FileSystem.."/menu/"..file)
        elseif string.StartWith(file, "sh_") then
            include(FileSystem.."/menu/"..file)
            AddCSLuaFile(FileSystem.."/menu/"..file)
        else
            include(FileSystem.."/menu/"..file)
        end
        
        MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Loading : "..FileSystem.."/menu/"..file.."\n")
    end
    
    for k, file in pairs (file.Find(FileSystem.."/languages/*", "LUA")) do
        AddCSLuaFile(FileSystem.."/languages/"..file)
        include(FileSystem.."/languages/"..file)
        MsgC( Color( 225, 20, 30 ), "["..AddonName.."]", Color(255,255,255), " Loading : "..FileSystem.."/languages/"..file.."\n")
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
            http.Post("https://gmod-radio-numerix.mtxserv.com/api/connect.php", { script = FileSystem_Web, ip = game.GetIPAddress() }, 
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
            http.Fetch( "https://gmod-radio-numerix.mtxserv.com/api/version/"..FileSystem_Web..".txt",
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
            http.Post("https://gmod-radio-numerix.mtxserv.com/api/disconnect.php", { script = FileSystem_Web, ip = game.GetIPAddress() }, 
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

    for k, file in SortedPairs (file.Find(FileSystem.."/config/*", "LUA")) do
        include(FileSystem.."/config/"..file)
    end

    for k, file in pairs (file.Find(FileSystem.."/mp3/*", "LUA")) do
        if string.StartWith(file, "cl_") then
            include(FileSystem.."/mp3/"..file)
        end
    end

    for k, file in pairs (file.Find(FileSystem.."/soundcloud/*", "LUA")) do
        if string.StartWith(file, "cl_") then
            include(FileSystem.."/soundcloud/"..file)
        end
    end

    for k, file in pairs (file.Find(FileSystem.."/menu/*", "LUA")) do
        if string.StartWith(file, "cl_") then
            include(FileSystem.."/menu/"..file)
        end
    end

    for k, file in pairs (file.Find(FileSystem.."/utils/*", "LUA")) do
        if string.StartWith(file, "cl_") or string.StartWith(file, "sh_") then
            include(FileSystem.."/utils/"..file)
        end
    end

    if Radio.Settings.EnableVehicle then
        for k, file in pairs (file.Find(FileSystem.."/vehicle/*", "LUA")) do
            if string.StartWith(file, "cl_") then
                include(FileSystem.."/vehicle/"..file)
            end
        end
    end

    for k, file in pairs (file.Find(FileSystem.."/youtube/*", "LUA")) do
        if string.StartWith(file, "cl_") then
            include(FileSystem.."/youtube/"..file)
        end
    end

    for k, file in pairs (file.Find(FileSystem.."/languages/*", "LUA")) do
        include(FileSystem.."/languages/"..file)
    end

end