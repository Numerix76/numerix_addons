--[[ HUD Identity --------------------------------------------------------------------------------------

HUD Identity made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local PlayerMeta = FindMetaTable("Player")

hook.Add("HUDPaint", "HUD.Identity:AbovePlayerHUD", function()
    local ShouldDraw = hook.Call("HUDShouldDraw", GAMEMODE, "HUD.Identity:AbovePlayerHUD")

    if ShouldDraw == false then return end

    local shootPos = LocalPlayer():GetShootPos()
    local aimVec = LocalPlayer():GetAimVector()

    for _, ply in ipairs(player.GetAll()) do
        if not IsValid(ply) or not ply:Alive() or ply:GetNoDraw() or ply:IsDormant() then continue end
        local hisPos = ply:GetShootPos()

        if hisPos:DistToSqr(shootPos) < 160000 then
            local pos = hisPos - shootPos
            local unitPos = pos:GetNormalized()
            if unitPos:Dot(aimVec) > 0.95 then
                local trace = util.QuickTrace(shootPos, pos, LocalPlayer())
                if trace.Hit and trace.Entity ~= ply then
                    -- When the trace says you're directly looking at a
                    -- different player, that means you can draw /their/ info
                    if trace.Entity:IsPlayer() then
                        trace.Entity:drawAbovePlayerInfo()
                    end
                    break
                end
                ply:drawAbovePlayerInfo()
            end
        end
    end

    local ent = LocalPlayer():GetEyeTrace().Entity

    if DarkRP and IsValid(ent) and ent:isKeysOwnable() and ent:GetPos():DistToSqr(LocalPlayer():GetPos()) < 40000 then
        ent:drawOwnableInfo()
    end
end)

local numinfo = 0
local posy
local text = ""
function PlayerMeta:drawAbovePlayerInfo()
    local pos = self:EyePos()

    pos.z = pos.z + 10
    pos = pos:ToScreen()

    numinfo = 0
    text = ""
    surface.SetFont("HUD.Identity.AboveHUD.Text")

    for k, v in SortedPairsByMemberValue(HUD.Settings.AbovePlayerInfo, "sortOrder", true) do
        if v.visible and !v.visible(self) then continue end
        numinfo = numinfo + 1

        text = surface.GetTextSize(text) > surface.GetTextSize( ( v.text.." "..( v.value(self) or "" ) ) ) and text or ( ( v.text.." "..( v.value(self) or "" ) ) )
    end

    if numinfo > 0 then    
        HUD.DrawRect(pos.x-50, pos.y - 20*numinfo, 10 + surface.GetTextSize(text), 20*numinfo + 5)

        posy = 20*numinfo
        numinfo = 0
        for k, v in SortedPairsByMemberValue(HUD.Settings.AbovePlayerInfo, "sortOrder", true) do
            if v.visible and !v.visible(self) then continue end

            draw.SimpleText(v.text.." "..( v.value(self) or "" ) , "HUD.Identity.AboveHUD.Text", pos.x-45, pos.y - posy + 10 + 20*numinfo, v.color(self) or Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            numinfo = numinfo + 1
        end
    end

    local icon = false
    for k, v in SortedPairsByMemberValue(HUD.Settings.AbovePlayerInfoLeft, "priority", false) do
        if v.visible and !v.visible(self) then continue end

        icon = true

        break
    end

    if icon then

        local w = numinfo > 1 and ( 20*numinfo + 5 ) or ( 20*2 + 5 )
        local x, y = numinfo > 1 and ( pos.x - 20*numinfo - 50 - 10 ) or ( pos.x - 20*3 + 5 - (numinfo == 0 and 0 or w )), numinfo > 0 and ( pos.y - 20*numinfo ) or ( pos.y - 20*3 )

        HUD.DrawRect(x, y, w, w)

        for k, v in SortedPairsByMemberValue(HUD.Settings.AbovePlayerInfoLeft, "priority", false) do
            if v.visible and !v.visible(self) then continue end

            surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
            surface.SetMaterial(v.icon)
            surface.DrawTexturedRect( x + w/2 - 16, y + w/2 - 16, 32, 32 )
            
            break
        end
    end
end