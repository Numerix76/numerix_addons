--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

util.AddNetworkString("Radio:OpenStreamMenu")
util.AddNetworkString("Radio:StopMusic")
util.AddNetworkString("Radio:UpdateVolume")
util.AddNetworkString("Radio:ChangeMusic")
util.AddNetworkString("Radio:SetMusic")
util.AddNetworkString("Radio:PauseMusic")
util.AddNetworkString("Radio:SeekMusic")
util.AddNetworkString("Radio:UpdateVisual")
util.AddNetworkString("Radio:Take")
util.AddNetworkString("Radio:ConnectRadio")
util.AddNetworkString("Radio:SetNameServer") 
util.AddNetworkString("Radio:TransmitVoice")
util.AddNetworkString("Radio:ChangeLoopState")
util.AddNetworkString("Radio:ChangePrivateState") 
util.AddNetworkString("Radio:ChangePrivateBuddyState") 

function Radio.CanModificateRadio(ply, ent)
    if !IsValid(ent) then return false end
    
    local maxdist = Radio.IsCar(ent) and 22500 or 100000

    local canedit = hook.Call("Radio:CanModificate", nil, ply, ent)

    if canedit == false then return false end
   
    if ent:GetClass() != "numerix_radio" and ent:GetClass() != "numerix_radio_server" and !Radio.IsCar(ent) and ent:GetClass() != "numerix_radio_swep" then return false end
    if ply:GetPos():DistToSqr(ent:GetPos()) > maxdist then return false end
    if Radio.IsCar(ent) then
        if DarkRP and !ply:canKeysLock(ent) and !scripted_ents.IsBasedOn(ent:GetClass(), "wac_hc_base") then return false end
        if FPP and !ent:CPPICanUse(ply) then return false end
    end

    local owner = ent.FPPOwner or ent.Owner
    if FPP and ent:GetNWBool("Radio:Private") and (ent:GetNWBool("Radio:PrivateBuddy") and !ent:CPPICanUse(ply) or !ent:GetNWBool("Radio:PrivateBuddy") and owner != ply) then return false end

    return true
end

local function StopMusic(len, ply)
    if !ply:IsValid() then return end
    local ent = net.ReadEntity()

    if !Radio.CanModificateRadio(ply, ent) then return end 
    if ent != ent:GetNWEntity("Radio:Entity") then return end

    ent:SetNWString( "Radio:ID", "" )
    ent:SetNWString( "Radio:Author", "" )
    ent:SetNWString( "Radio:Title", "" )
    ent:SetNWString( "Radio:Mode", "0" )
    ent:SetNWInt( "Radio:Duration", 0)

    hook.Call("Radio:PlayerStopMusic", nil, ply, ent)

    ServerLog("[Radio] "..ply:Name().."("..ply:SteamID()..") has stopped the music.")
end
net.Receive("Radio:StopMusic", StopMusic)

local function UpdateVolume(len, ply)
    if !ply:IsValid() then return end
    local ent = net.ReadEntity()
    local volume = net.ReadString()

    if !Radio.CanModificateRadio(ply, ent) then return end
    volume = math.Clamp(volume, 0, 100)
    volume = math.Round(volume)

    ent:SetNWInt("Radio:Volume", volume)
    if !Radio.IsCar(ent) then
        ent:SetNWInt("Radio:DistanceSound", (ent.DistanceSound*volume/50))
    else
        ent:SetNWInt("Radio:DistanceSound", 200000)
    end

    hook.Call("Radio:PlayerUpdateVolume", nil, ply, ent, volume)

    ServerLog("[Radio] "..ply:Name().."("..ply:SteamID()..") has changed the volume.")
end
net.Receive("Radio:UpdateVolume", UpdateVolume)

local function SetMusic(len, ply)
    if !ply:IsValid() then return end
    local ent = net.ReadEntity()
    local id = net.ReadString()
    local mode = net.ReadString()

    if !Radio.CanModificateRadio(ply, ent) then return end
    
    if ent.isloading then ply:RadioChatInfo(Radio.GetLanguage("Please wait the end of last loading"),3) return end

    if Radio.Settings.ActivePreset and !Radio.Settings.Preset[id] then return end

    id = Radio.Settings.ActivePreset and Radio.Settings.Preset[id] or id

    if mode == "1" then
        Radio.SetMusicYT(ply, ent, Radio.GetYoutubeID(id))
    elseif mode == "2" then
        Radio.SetMusicMP3(ply, ent, id)
    elseif mode == "3" then
        id = Radio.GetSoundCloud(id)
        if id then
            Radio.SetMusicSC(ply, ent, id)
        else
            ply:RadioChatInfo(Radio.GetLanguage("URL SoundCloud invalid"),3)
        end
    end

    ent:SetNWBool("Radio:Pause", false)
    ent:SetNWEntity("Radio:Entity", ent)

    hook.Call("Radio:PlayerSetMusic", nil, ply, ent, id, mode)

    ServerLog("[Radio] "..ply:Name().."("..ply:SteamID()..") has changed the music.")
end
net.Receive("Radio:SetMusic", SetMusic)

local function PauseMusic(len, ply)
    if !ply:IsValid() then return end
    local ent = net.ReadEntity()
    local pause = net.ReadBool()

    if !Radio.CanModificateRadio(ply, ent) then return end
    if ent != ent:GetNWEntity("Radio:Entity") then return end

    if pause then
        ent.PauseTime = CurTime() - ent:GetNWInt("Radio:Time")
    else
        ent:SetNWInt("Radio:Time", CurTime() - (ent.PauseTime or 0))
        ent.PauseTime = nil
    end

    ent:SetNWBool("Radio:Pause", pause)

    hook.Call("Radio:PlayerPauseMusic", nil, ply, ent, pause)

    ServerLog("[Radio] "..ply:Name().."("..ply:SteamID()..") has paused the music.")
end
net.Receive("Radio:PauseMusic", PauseMusic)

local function SeekMusic(len, ply)

    if !Radio.Settings.Seek then return end

    if !ply:IsValid() then return end
    local ent = net.ReadEntity()
    local time = tonumber(net.ReadString())

    if !Radio.CanModificateRadio(ply, ent) then return end
    if ent != ent:GetNWEntity("Radio:Entity") then return end
    if ent:SetNWString("Radio:Mode") == "3" then return end

    time = math.Clamp(time, 0, ent:GetNWInt("Radio:Duration"))
    ent:SetNWInt("Radio:Time", CurTime() - time)

    ent:SetNWBool("Radio:Pause", false)

    hook.Call("Radio:PlayerSeekMusic", nil, ply, ent, time)

    ServerLog("[Radio] "..ply:Name().."("..ply:SteamID()..") has seeked the music.")
end
net.Receive("Radio:SeekMusic", SeekMusic)

local function UpdateVisual(len, ply)
    if !ply:IsValid() then return end
    local ent = net.ReadEntity()
    local color = net.ReadColor()
    local rainbow = net.ReadBool()

    if !Radio.CanModificateRadio(ply, ent) then return end
    
    color = string.FromColor( color )

    ent:SetNWString("Radio:Visual", color)
    ent:SetNWBool("Radio:Rainbow", rainbow)

    hook.Call("Radio:PlayerUpdateVisual", nil, ply, ent, color, rainbow)

    ServerLog("[Radio] "..ply:Name().."("..ply:SteamID()..") has chnage the visual of the radio.")
end
net.Receive("Radio:UpdateVisual", UpdateVisual)

local function TakeRadio(len, ply)
    if !Radio.Settings.EnableSWEP then return end
    if !ply:IsValid() then return end
    local ent = net.ReadEntity()

    if !Radio.CanModificateRadio(ply, ent) then return end
    if ent:GetClass() != "numerix_radio" then return end
    if ply:HasWeapon("numerix_radio_swep") then return end

    ent:Remove()

    local radio = ply:Give("numerix_radio_swep")

    if not IsValid(radio) then return end

    Radio.ChangeMod(ply, ent, radio)
end
net.Receive("Radio:Take", TakeRadio)

local function ConnectRadio(len, ply)
    if !ply:IsValid() then return end

    local ent = net.ReadEntity()
    local server = net.ReadEntity() or nil
    local connect = net.ReadBool()
    local oldserver = ent:GetNWEntity("Radio:Entity")
    
    if ent.isloading then ply:RadioChatInfo(Radio.GetLanguage("Please wait the end of last loading"),3) return end
    
    if !Radio.CanModificateRadio(ply, ent) then return end
    if !connect then 
        hook.Call("Radio:DisconnectRadio", nil, ply, ent, ent:GetNWEntity("Radio:Entity"))
        ent:GetNWEntity("Radio:Entity"):SetNWInt("Radio:Viewer", ent:GetNWEntity("Radio:Entity"):GetNWInt("Radio:Viewer")-1) 
        ent:SetNWEntity("Radio:Entity", ent) 
        return 
    end
    if !IsValid(server) or server:GetClass() != "numerix_radio_server" or ent:GetNWEntity("Radio:Entity") == server then return end
    
    oldserver:SetNWInt("Radio:Viewer", oldserver:GetNWInt("Radio:Viewer")-1)
    ent:SetNWEntity("Radio:Entity", server)
    server:SetNWInt("Radio:Viewer", server:GetNWInt("Radio:Viewer")+1)
    ent:SetNWString("Radio:ID", "")
    ent:SetNWBool("Radio:Pause", false)

    if ent:IsWeapon() then ent.LastStation = server end

    hook.Call("Radio:ConnectRadio", nil, ply, ent, server)
end
net.Receive("Radio:ConnectRadio", ConnectRadio)

local function SetNameServer(len, ply)
    if !ply:IsValid() then return end

    local ent = net.ReadEntity()
    local name = net.ReadString()
    
    if !Radio.CanModificateRadio(ply, ent) then return end
    if ent:GetClass() != "numerix_radio_server" then return end
    
    ent:SetNWString("Radio:StationName", name) 
    hook.Add("Radio:SetNameServer", nil, ply, ent, name)
end
net.Receive("Radio:SetNameServer", SetNameServer)

local function TransmitVoice(len, ply)
    if !ply:IsValid() then return end

    local ent = net.ReadEntity()
    local voice = net.ReadBool()

    if !Radio.CanModificateRadio(ply, ent) then return end
    if ent:GetClass() != "numerix_radio_server" then return end

    ent:SetNWBool("Radio:Voice", voice)
    hook.Call("Radio:TransmitVoice", nil, ply, ent, voice)
end
net.Receive("Radio:TransmitVoice", TransmitVoice)

local function ChangeLoopState(len, ply)
    if !ply:IsValid() then return end

    local ent = net.ReadEntity()
    local loop = net.ReadBool()

    if !Radio.CanModificateRadio(ply, ent) then return end
    if ent != ent:GetNWEntity("Radio:Entity") then return end

    ent:SetNWBool("Radio:Loop", loop)
    hook.Call("Radio:ChangeLoopState", nil, ply, ent, loop)
end
net.Receive("Radio:ChangeLoopState", ChangeLoopState)

local function ChangePrivateState(len, ply)
    if !ply:IsValid() then return end

    local ent = net.ReadEntity()
    local private = net.ReadBool()

    if !Radio.CanModificateRadio(ply, ent) then return end

    ent:SetNWBool("Radio:Private", private)
    hook.Call("Radio:ChangePrivateState", nil, ply, ent, private)
end
net.Receive("Radio:ChangePrivateState", ChangePrivateState)

local function ChangePrivateBuddyState(len, ply)
    if !ply:IsValid() then return end

    local ent = net.ReadEntity()
    local privatebuddy = net.ReadBool()

    if !Radio.CanModificateRadio(ply, ent) then return end

    ent:SetNWBool("Radio:PrivateBuddy", privatebuddy)
    hook.Call("Radio:ChangePrivateBuddyState", nil, ply, ent, privatebuddy)
end
net.Receive("Radio:ChangePrivateBuddyState", ChangePrivateBuddyState)

function Radio.Think(self)

    if IsValid(self:GetParent()) and !self:GetParent():IsPlayer() then return end
    
    if self:GetNWString("Radio:ID") == "" and self:GetNWInt("Radio:Duration") != 0 then
        self:SetNWString("Radio:Author", "")
        self:SetNWString("Radio:Title", "")
        self:SetNWString("Radio:Mode", "0")

        self:SetNWInt("Radio:Duration", 0)
        self:SetNWInt("Radio:Time", 0)

        return -- No need to check after
    end

    if ( IsValid(self:GetParent()) and self:GetParent():IsPlayer() and self.Owner:WaterLevel() == 3 or !IsValid(self:GetParent()) and self:WaterLevel() == 3  or ( Radio.IsCar(self) and !self:GetNWBool("Radio:HasRadio") ) ) and self:GetNWString("Radio:ID") != "" then
        self:SetNWString("Radio:ID", "")

        if IsValid(self:GetParent()) and self:GetParent():IsPlayer() and self.Owner:WaterLevel() == 3 then
            self.Owner:EmitSound("ambient/energy/spark5.wav")
        else
            self:EmitSound("ambient/energy/spark5.wav")
        end

        return -- No need to check after
    end

    if !self:GetNWBool("Radio:Pause") and CurTime() - self:GetNWInt("Radio:Time") > self:GetNWInt("Radio:Duration") and self:GetNWString("Radio:Mode") != "3" and self:GetNWString("Radio:ID") !="" then
        
        if self:GetNWBool("Radio:Loop") then
            self:SetNWInt("Radio:Time", CurTime())
        else
            self:SetNWString("Radio:ID", "")
        end

        return -- No need to check after
    end
end

local total
local function AnimSalary(ply, amount)
    if Radio.Settings.MakeSalary then
        if ply:Team() == Radio.Settings.TeamRadio then 
            total = 0
            for _, ent in ipairs(Radio.AllServer) do
                if ent.FPPOwner != ply then continue end
                total = total + ent:GetNWInt("Radio:Viewer")*Radio.Settings.Salary
            end

            return false, DarkRP.getPhrase("payday_message", amount).." (+"..DarkRP.formatMoney(total)..")", total+amount
        end
    end
end
hook.Add( "playerGetSalary", "Radio:AnimSalary", AnimSalary )