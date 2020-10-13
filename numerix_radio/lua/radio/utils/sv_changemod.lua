local radio
function Radio.ChangeMod(ply, ent, radio)

    if !IsValid(ent) or !IsValid(radio) then return end

    radio.PauseTime = ent.PauseTime

    radio:SetNWString( "Radio:ID", ent:GetNWString("Radio:ID") )
    radio:SetNWString( "Radio:Author", ent:GetNWString("Radio:Author") )
    radio:SetNWString( "Radio:Title", ent:GetNWString("Radio:Title") )
    radio:SetNWString( "Radio:Mode", ent:GetNWString("Radio:Mode") )
    radio:SetNWString( "Radio:Info", "" )
    radio:SetNWString( "Radio:Visual", ent:GetNWString("Radio:Visual") )
    radio:SetNWString( "Radio:Color", string.FromColor(ent:GetColor()))
    
    radio:SetNWInt( "Radio:Volume", ent:GetNWInt("Radio:Volume") )
    radio:SetNWInt( "Radio:Time", ent:GetNWInt("Radio:Time") )
    radio:SetNWInt( "Radio:Duration", ent:GetNWInt("Radio:Duration"))
    radio:SetNWInt( "Radio:DistanceSound", Radio.IsCar(radio) and 200000 or (radio.DistanceSound*ent:GetNWInt("Radio:Volume")/50))

    radio:SetNWBool( "Radio:Rainbow", ent:GetNWBool("Radio:Rainbow") )
    radio:SetNWBool( "Radio:Pause", ent:GetNWBool("Radio:Pause"))
    radio:SetNWBool( "Radio:Loop", ent:GetNWBool("Radio:Loop"))
    radio:SetNWBool( "Radio:Private", ent:GetNWBool("Radio:Private"))
    radio:SetNWBool( "Radio:PrivateBuddy", ent:GetNWBool("Radio:PrivateBuddy"))

    local station = ent:GetNWEntity("Radio:Entity") == ent and radio or ent:GetNWEntity("Radio:Entity")
    radio:SetNWEntity("Radio:Entity", station)
    station:SetNWInt("Radio:Viewer", station:GetNWInt("Radio:Viewer")+1)

    if radio:IsWeapon() then radio.LastStation = station end

    ent:SetNWString("Radio:ID", "")

    hook.Call("Radio:ChangeMod", nil, ply, ent, radio)
end