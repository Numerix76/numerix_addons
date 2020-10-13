--[[ HUD Identity --------------------------------------------------------------------------------------

HUD Identity made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local HideElement = {
    ["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,

    ["DarkRP_HUD"] = true,
    ["DarkRP_EntityDisplay"] = true,
    ["DarkRP_LocalPlayerHUD"] = true,
    ["DarkRP_Hungermod"] = true,
    ["DarkRP_Agenda"] = true,
    ["DarkRP_LockdownHUD"] = true,    
    ["DarkRP_ArrestedHUD"] = true,   
    ["DarkRP_ChatReceivers"] = HUD.Settings.ChatReceiverHUD,

    ["HUD.Identity:LocalPlayerHUD"] = HUD.Settings.LocalPlayerHUD,
    ["HUD.Identity:AbovePlayerHUD"] = HUD.Settings.AbovePlayerHUD,
    ["HUD.Identity:AgendaHUD"] = HUD.Settings.AgendaHUD,
    ["HUD.Identity:NotificationHUD"] = HUD.Settings.NotificationHUD,
    ["HUD.Identity:PickupHUD"] = HUD.Settings.PickupHUD,
    ["HUD.Identity:NoticeHUD"] = HUD.Settings.NoticeHUD,
    ["HUD.Identity:IconVoiceHUD"] = HUD.Settings.IconVoiceHUD,
    ["HUD.Identity:DoorHUD"] = HUD.Settings.DoorHUD,
    ["HUD.Identity:DoorStateHUD"] = HUD.Settings.DoorStateHUD,
    ["HUD.Identity:DeathHUD"] = HUD.Settings.DeathHUD,
}

hook.Add("HUDShouldDraw", "HUD.Identity:ShouldDraw", function(name)
    if HideElement[name] then return false end
end)

local InfoWide
local InfoHeight
local ply
local numinfo = 0
local text = ""

HUD.LeftBottomLastPos = ScrH() - 5
HUD.LeftTopLastPos = 5
HUD.RightBottomLastPos = ScrH() - 5
HUD.RightTopLastPos = 5

hook.Add("OnScreenSizeChanged", "HUD.Identity:UpdatePos", function()
    HUD.LeftBottomLastPos = ScrH() - 5
    HUD.LeftTopLastPos = 5
    HUD.RightBottomLastPos = ScrH() - 5
    HUD.RightTopLastPos = 5
end)

hook.Add("HUDPaint", "HUD.Identity:LocalPlayerHUD", function()
    ply = LocalPlayer()

    if not IsValid(ply) then return end

    local ShouldDraw = hook.Call("HUDShouldDraw", GAMEMODE, "HUD.Identity:LocalPlayerHUD")

    if ShouldDraw == false then return end

    InfoWide = 290
    InfoHeight = 42
    text = ""
    surface.SetFont("HUD.Identity.LocalHUD.Text")
    for k, v in SortedPairsByMemberValue(HUD.Settings.ElementLeftBottom, "sortOrder", true) do

        if v.visible and !v.visible(ply) then continue end

        text = surface.GetTextSize(text) > surface.GetTextSize(v.text.." "..(v.drawinfo and v.drawinfo(v.newvalue) or v.newvalue and math.Round(v.newvalue) or v.value(ply)) ) and text or ( v.text.." "..(v.drawinfo and v.drawinfo(v.newvalue) or v.newvalue and math.Round(v.newvalue) or v.value(ply) ) )
    end

    for k, v in SortedPairsByMemberValue(HUD.Settings.ElementRightBottom, "sortOrder", true) do

        if v.visible and !v.visible(ply) then continue end

        text = surface.GetTextSize(text) > surface.GetTextSize(v.text.." "..(v.drawinfo and v.drawinfo(v.newvalue) or v.newvalue and math.Round(v.newvalue) or v.value(ply)) ) and text or ( v.text.." "..(v.drawinfo and v.drawinfo(v.newvalue) or v.newvalue and math.Round(v.newvalue) or v.value(ply) ) )
    end

    for k, v in SortedPairsByMemberValue(HUD.Settings.ElementLeftTop, "sortOrder", true) do

        if v.visible and !v.visible(ply) then continue end

        text = surface.GetTextSize(text) > surface.GetTextSize(v.text.." "..(v.drawinfo and v.drawinfo(v.newvalue) or v.newvalue and math.Round(v.newvalue) or v.value(ply)) ) and text or ( v.text.." "..(v.drawinfo and v.drawinfo(v.newvalue) or v.newvalue and math.Round(v.newvalue) or v.value(ply) ) )
    end

    for k, v in SortedPairsByMemberValue(HUD.Settings.ElementRightTop, "sortOrder", true) do

        if v.visible and !v.visible(ply) then continue end

        text = surface.GetTextSize(text) > surface.GetTextSize(v.text.." "..(v.drawinfo and v.drawinfo(v.newvalue) or v.newvalue and math.Round(v.newvalue) or v.value(ply)) ) and text or ( v.text.." "..(v.drawinfo and v.drawinfo(v.newvalue) or v.newvalue and math.Round(v.newvalue) or v.value(ply) ) )
    end

    InfoWide = surface.GetTextSize(text) + 42 + 10

    -------------------------------------------------------------
    ------------------------  Left Bottom  ----------------------
    -------------------------------------------------------------

    numinfo = 0
    for k, v in SortedPairsByMemberValue(HUD.Settings.ElementLeftBottom, "sortOrder", true) do

        if v.visible and !v.visible(ply) then continue end

        HUD.DrawBarInfo(5, ScrH() - InfoHeight - numinfo*(InfoHeight+5) - 5, InfoWide, InfoHeight, v, ply)
        
        numinfo = numinfo + 1
    end
    HUD.LeftBottomLastPos = ScrH() - InfoHeight - numinfo*(InfoHeight+5) - 5

    numinfo = 0
    for k, v in SortedPairsByMemberValue(HUD.Settings.InfoLeftBottom, "sortOrder", true) do

        if v.visible and !v.visible(ply) then continue end

        HUD.DrawIconInfo(5 + numinfo*(42+5), HUD.LeftBottomLastPos, 42, InfoHeight, v.icon, ply)

        numinfo = numinfo + 1
    end
    HUD.LeftBottomLastPos = numinfo > 0 and HUD.LeftBottomLastPos - 5 or HUD.LeftBottomLastPos + InfoHeight

    ------------------------------------------------------------
    ----------------------  Right Bottom  ----------------------
    ------------------------------------------------------------

    numinfo = 0
    for k, v in SortedPairsByMemberValue(HUD.Settings.ElementRightBottom, "sortOrder", true) do
        
        if v.visible and !v.visible(ply) then continue end
    
        HUD.DrawBarInfo(ScrW() - InfoWide - 5, ScrH() - InfoHeight - numinfo*(InfoHeight+5) - 5, InfoWide, InfoHeight, v, ply)

        numinfo = numinfo + 1
    end
    HUD.RightBottomInfo = numinfo --Need for Ammo
    HUD.RightBottomLastPos = ScrH() - InfoHeight - numinfo*(InfoHeight+5) - 5

    numinfo = 0
    for k, v in SortedPairsByMemberValue(HUD.Settings.InfoRightBottom, "sortOrder", true) do

        if v.visible and !v.visible(ply) then continue end

        HUD.DrawIconInfo(ScrW() - 5 - 42 - numinfo*(42+5), HUD.RightBottomLastPos, 42, InfoHeight, v.icon, ply)

        numinfo = numinfo + 1
    end
    HUD.RightBottomInfo2 = numinfo --Need for Ammo
    HUD.RightBottomLastPos = numinfo > 0 and HUD.RightBottomLastPos - 5 or HUD.RightBottomLastPos + InfoHeight

    ------------------------------------------------------------
    ------------------------  Left Top  ------------------------
    ------------------------------------------------------------

    numinfo = 0
    for k, v in SortedPairsByMemberValue(HUD.Settings.ElementLeftTop, "sortOrder", false) do

        if v.visible and !v.visible(ply) then continue end
   
        HUD.DrawBarInfo(5, numinfo*(InfoHeight+5) + 5, InfoWide, InfoHeight, v, ply)

        numinfo = numinfo + 1
    end
    HUD.LeftTopLastPos = numinfo*(InfoHeight+5) + 5

    numinfo = 0
    for k, v in SortedPairsByMemberValue(HUD.Settings.InfoLeftTop, "sortOrder", true) do

        if v.visible and !v.visible(ply) then continue end

        HUD.DrawIconInfo(5 + numinfo*(42+5), HUD.LeftTopLastPos, 42, InfoHeight, v.icon, ply)

        numinfo = numinfo + 1
    end
    HUD.LeftTopLastPos =  numinfo > 0 and HUD.LeftTopLastPos + InfoHeight + 5 or HUD.LeftTopLastPos

    ------------------------------------------------------------
    ------------------------  Right Top  -----------------------
    ------------------------------------------------------------

    numinfo = 0
    for k, v in SortedPairsByMemberValue(HUD.Settings.ElementRightTop, "sortOrder", false) do

        if v.visible and !v.visible(ply) then continue end
        
        HUD.DrawBarInfo(ScrW() - InfoWide - 5, numinfo*(InfoHeight+5) + 5, InfoWide, InfoHeight, v, ply)

        numinfo = numinfo + 1
    end
    HUD.RightTopInfo = numinfo
    HUD.RightTopLastPos = numinfo*(InfoHeight+5) + 5

    numinfo = 0
    for k, v in SortedPairsByMemberValue(HUD.Settings.InfoRightTop, "sortOrder", true) do

        if v.visible and !v.visible(ply) then continue end

        HUD.DrawIconInfo(ScrW() - 5 - 42 - numinfo*(42+5), HUD.RightTopLastPos, 42, InfoHeight, v.icon, ply)

        numinfo = numinfo + 1
    end
    HUD.RightTopLastPos =  numinfo > 0 and HUD.RightTopLastPos + InfoHeight + 5 or HUD.RightTopLastPos

    -------------------------------------------------------------
    ------------------------  Ammo HUD  -------------------------
    -------------------------------------------------------------

    if ply:Alive() and ply:GetActiveWeapon() and ply:GetActiveWeapon():IsValid() and !HUD.Settings.NoAmmoWeapon[ply:GetActiveWeapon():GetClass()] then
        if ply:GetActiveWeapon():Clip1() != -1 then
            text = ply:GetActiveWeapon():Clip1().." / "..ply:GetAmmoCount(ply:GetActiveWeapon():GetPrimaryAmmoType())..(" ("..ply:GetAmmoCount( ply:GetActiveWeapon():GetSecondaryAmmoType() )..")" or "")
        else
            text = ply:GetAmmoCount( ply:GetActiveWeapon():GetPrimaryAmmoType() )
        end

        surface.SetFont("HUD.Identity.LocalHUD.Text")

        local pos = ( HUD.RightBottomInfo > 0 and (  ScrW() - 5 - InfoWide - surface.GetTextSize(text) - 52 - 5 ) ) or ( HUD.RightBottomInfo2 > 0 and (ScrW() - 5 - (42 + 5)*HUD.RightBottomInfo2 - surface.GetTextSize(text) - 52) ) or ( ScrW() - 5 - surface.GetTextSize(text) - 52 )
        draw.RoundedBox(0, pos, ScrH() - InfoHeight - 5, surface.GetTextSize(text) + 52, InfoHeight, Color(52, 55, 64, 200))

        surface.SetDrawColor( Color( 255, 255, 255, 200 ) )
        surface.DrawOutlinedRect( pos, ScrH() - InfoHeight - 5, surface.GetTextSize(text) + 52, InfoHeight )

        surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
        surface.SetMaterial(HUD.Settings.IconWeapon)
        surface.DrawTexturedRect( pos + 5, (ScrH() - InfoHeight - 5) + InfoHeight/2 - 32/2, 32, 32 ) 
        
        
        draw.SimpleText(text, "HUD.Identity.LocalHUD.Text", pos + 45, (ScrH() - InfoHeight - 5) + InfoHeight/2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        
        if HUD.RightBottomInfo == 0 then
            HUD.RightBottomLastPos = ScrH() - 42 - 10
        end
    end
    
    if ply:Health() <= HUD.Settings.LowHealth and ply:Alive() then
        DrawMotionBlur( 0.09, 0.8, 0.01 )
    end
end)

hook.Add("DarkRPFinishedLoading", "HUD.Identity:ArrestHUD", function()
    usermessage.Hook("GotArrested", function(msg)
        LocalPlayer().TimeArrested = CurTime() + msg:ReadFloat()
    end)
end)

hook.Add("PostGamemodeLoaded", "HUD.Identity:RemoveTargetHUD", function()
    function GAMEMODE:HUDDrawTargetID()
        return false
    end
end)