--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

util.AddNetworkString("Radio:OpenStreamMenu")


util.AddNetworkString("Radio:StopMusic")
local function StopMusic(len, ply)
    if !ply:IsValid() then return end
    local ent = net.ReadEntity()

    ent:StopMusicRadio(ply)
end
net.Receive("Radio:StopMusic", StopMusic)

util.AddNetworkString("Radio:UpdateVolume")
local function UpdateVolume(len, ply)
    if !ply:IsValid() then return end
    local ent = net.ReadEntity()
    local volume = net.ReadString()
 
    ent:SetVolumeRadio(ply, volume)
end
net.Receive("Radio:UpdateVolume", UpdateVolume)

util.AddNetworkString("Radio:SetMusic")
local function SetMusic(len, ply)
    if !ply:IsValid() then return end
    local ent = net.ReadEntity()
    
    local url = net.ReadString()
    ent:SetMusicRadio(ply, url)
end
net.Receive("Radio:SetMusic", SetMusic)

util.AddNetworkString("Radio:PauseMusic")
local function PauseMusic(len, ply)
    if !ply:IsValid() then return end
    local ent = net.ReadEntity()
    local pause = net.ReadBool()

    ent:SetPauseRadio(ply, pause)
end
net.Receive("Radio:PauseMusic", PauseMusic)

util.AddNetworkString("Radio:SeekMusic")
local function SeekMusic(len, ply)
    
    if !Radio.Settings.Seek then return end

    if !ply:IsValid() then return end
    local ent = net.ReadEntity()
    local time = tonumber(net.ReadString())

    ent:SeekTimeRadio(ply, time)
end
net.Receive("Radio:SeekMusic", SeekMusic)

util.AddNetworkString("Radio:Take")
local function TakeRadio(len, ply)
    if !Radio.Settings.EnableSWEP then return end
    if !ply:IsValid() then return end
    local ent = net.ReadEntity()

    ent:TakeRadio(ply)
end
net.Receive("Radio:Take", TakeRadio)

util.AddNetworkString("Radio:ConnectRadio")
local function ConnectRadio(len, ply)
    if !ply:IsValid() then return end

    local ent = net.ReadEntity()
    local server = net.ReadEntity() or nil
    local connect = net.ReadBool()

    ent:ConnectDisconnectRadio(ply, server, connect)
end
net.Receive("Radio:ConnectRadio", ConnectRadio)

util.AddNetworkString("Radio:SetNameServer") 
local function SetNameServer(len, ply)
    if !ply:IsValid() then return end

    local ent = net.ReadEntity()
    local name = net.ReadString()

    ent:SetNameServerRadio(ply, name)
end
net.Receive("Radio:SetNameServer", SetNameServer)

util.AddNetworkString("Radio:TransmitVoice")
local function TransmitVoice(len, ply)
    if !ply:IsValid() then return end

    local ent = net.ReadEntity()
    local voice = net.ReadBool()

    ent:SetTransmitVoiceRadio(ply, voice)
end
net.Receive("Radio:TransmitVoice", TransmitVoice)

util.AddNetworkString("Radio:ChangeLoopState")
local function ChangeLoopState(len, ply)
    if !ply:IsValid() then return end

    local ent = net.ReadEntity()
    local loop = net.ReadBool()

    ent:SetLoopRadio(ply, loop)
end
net.Receive("Radio:ChangeLoopState", ChangeLoopState)

util.AddNetworkString("Radio:UpdateSettings")
local function UpdateSettings(len, ply)
    if !ply:IsValid() then return end
    
    local ent = net.ReadEntity()
    local color = net.ReadColor()
    local rainbow = net.ReadBool()
    local private = net.ReadBool()
    local privateBuddy = net.ReadBool()

    ent:SetVisualRadio(ply, color, rainbow)
    ent:SetPrivateRadio(ply, private)
    ent:SetPrivateBuddyRadio(ply, privateBuddy)
end
net.Receive("Radio:UpdateSettings", UpdateSettings)

util.AddNetworkString("Radio:RemoveFromVehicle")
util.AddNetworkString("Radio:SendVehicleData")

util.AddNetworkString("Radio:RetrieveFromVehicle")
function Radio.RetrieveFromVehicle(len, ply)
    local ent = net.ReadEntity()

    if !IsValid(ent) or ply:InVehicle() then return end

    if ent:IsCarRadio(ent) and ent:CanModificateRadio(ply) then
               
        if ent:GetNWBool("Radio:HasRadio") then

            local radio = !ply:HasWeapon("numerix_radio_swep") and Radio.Settings.EnableSWEP and ply:Give("numerix_radio_swep") or Radio.Settings.EnableEntity and ents.Create( "numerix_radio" ) or nil
            if !IsValid(radio) then return end

            if isentity(radio) then
                radio:SetPos( ent:GetPos() + ent:GetRight()*100 + ent:GetUp()*50 )
                radio:Spawn()
                if FPP then
                    radio:CPPISetOwner(ply)
                end
            end

            ent:SetNWBool("Radio:HasRadio", false)
            ent:ChangeModRadio(ply, radio)

            if Radio.AllRadio[ent] then Radio.AllRadio[ent] = nil end

            net.Start("Radio:RemoveFromVehicle")
            net.WriteEntity(ent)
            net.Broadcast()

            ply:RadioChatInfo(Radio.GetLanguage("You have retrieve the radio from the car."), 2)  
        else
            ply:RadioChatInfo(Radio.GetLanguage("There is no radio from the car."), 1)  
        end
    else
        ply:RadioChatInfo(Radio.GetLanguage("You are not the owner the car."), 1)  
    end
end
net.Receive("Radio:RetrieveFromVehicle", Radio.RetrieveFromVehicle)