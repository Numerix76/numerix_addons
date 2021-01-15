--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

Radio.Settings.VersionDefault = "1.0.6" --DON'T TOUCH THIS

--If debug true then if there is a problem you will have the line related in the console
Radio.Settings.Debug = false

--Change the language
Radio.Settings.Language = "en"

--Put you API Key for youtube (Tutorial to get it : https://www.slickremix.com/docs/get-api-key-for-youtube/)
Radio.Settings.APIKey = "AIzaSyBirtV8uYXXMPQbMQ63_a9TngiGrxoq4dE"

--Change the distance max of the radio
Radio.Settings.DistanceSound = 400

--The player is not able to put his music ?
Radio.Settings.ActivePreset = false

--Player are able to change the time of the music ? (This can cause a little freeze on all player during this)
Radio.Settings.Seek = true

--Max duration for a sound. (Don't put it too high or when a player will switch between swep to entities or to vehicle all player can freeze)
Radio.Settings.MaxDuration = 15*60

--Do you want to enable the radio entity ?
Radio.Settings.EnableEntity = true

--Do you want to enable the radio swep ?
Radio.Settings.EnableSWEP = true

--Do you want to enable the radio in vehicle ?
Radio.Settings.EnableVehicle = true

--The job radio win more money on how much auditors he has ?
Radio.Settings.MakeSalary = true

--How much the job radio win more on how much auditors he has ?
Radio.Settings.Salary = 10

hook.Add( "DarkRPFinishedLoading", "Radio:DarkRPInitialized", function() --DON'T TOUCH THIS
    --Put the TEAM of your job radio
    Radio.Settings.TeamRadio = TEAM_CITIZEN

end)--DON'T TOUCH THIS

--Add music preset (only available when Radio.Settings.ActivePreset = true)
Radio.Settings.Preset = {
    ["DownTown | Jazzhop"] = "https://www.youtube.com/watch?v=GGBm9gTY2NU&list=RDMM&index=27",
    ["Cowboy Bebop | Lofi Jazzhop Mix"] = "https://www.youtube.com/watch?v=Z-Rl3LhVakc&list=RDMM&index=27",
    ["NeverMind"] = "https://gmod-radio-numerix.mtxserv.com/exemple/Dennis%20Lloyd%20-%20NEVERMIND.mp3",
    ["The Box"] = "https://soundcloud.com/roddyricch/the-box",
    ["DownTown | Jazzhopd"] = "https://www.youtube.com/watch?v=GGBm9gTY2NU&list=RDMM&index=27",
    ["Test"] = "https://www.youtube.com/watch?v=83uaH3b1wtI&list=RDMM&index=27",
}

Radio.Settings.Navigation =
{
    {
        Enabled = true,
        Name = "MAIN",
        Desc = "Main.",
        DoLoadPanel = "Radio_Main",
        OnLoadInit = true,
        Icon = "numerix_f4menu/shipments.png",
        IconName = "your_server_name/icon7.png",
        Visible = function(ply) return true end,
    },
    {
        Enabled = true,
        Name = "SEARCH YOUTUBE",
        Desc = "Search.",
        DoLoadPanel = "Radio_Search",
        type = 1,
        OnLoadInit = false,
        Icon = "numerix_f4menu/shipments.png",
        IconName = "your_server_name/icon7.png",
        Visible = function(ply) return true end,
    },
    {
        Enabled = true,
        Name = "SEARCH SOUDCLOUD",
        Desc = "Search.",
        DoLoadPanel = "Radio_Search",
        type = 2,
        OnLoadInit = false,
        Icon = "numerix_f4menu/shipments.png",
        IconName = "your_server_name/icon7.png",
        Visible = function(ply) return true end,
    },
    {
        Enabled = true,
        Name = "PlayList",
        Desc = "PlayList.",
        DoLoadPanel = "Radio_PlayList",
        OnLoadInit = false,
        Icon = "numerix_f4menu/shipments.png",
        IconName = "your_server_name/icon7.png",
        Visible = function(ply) return true end,
    }, 
    {
        Enabled = true,
        Name = "PRESET",
        Desc = "Preset.",
        DoLoadPanel = "Radio_Preset",
        OnLoadInit = false,
        Icon = "numerix_f4menu/shipments.png",
        IconName = "your_server_name/icon7.png",
        Visible = function(ply) return true end,
    }, 
    {
        Enabled = true,
        Name = "SETTINGS",
        Desc = "Settings.",
        DoLoadPanel = "Radio_Settings",
        OnLoadInit = false,
        Icon = "numerix_f4menu/shipments.png",
        IconName = "your_server_name/icon7.png",
        Visible = function(ply) return true end,
    }, 
    
    {
        Enabled = true,
        Name = "PICK UP",
        Desc = "Pick Up.",
        OnLoadInit = false,
        Icon = "numerix_f4menu/shipments.png",
        IconName = "your_server_name/icon7.png",
        DoFunc = function(menu, ent)
            net.Start("Radio:Take")
			net.WriteEntity(ent)
			net.SendToServer()

			menu:Close()
        end,
        Visible = function(ply, ent) return Radio.Settings.EnableSWEP and ent:GetClass() == "numerix_radio" and !LocalPlayer():HasWeapon("numerix_radio_swep") end,
    },
}