--[[ HUD Identity --------------------------------------------------------------------------------------

HUD Identity made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local ply
hook.Add("HUDPaint", "HUD.Identity:AgendaHUD", function()
    local shouldDraw = hook.Call("HUDShouldDraw", GAMEMODE, "HUD.Identity:AgendaHUD")
    if shouldDraw == false or !DarkRP then return end

    ply = LocalPlayer()
    local x = HUD.Settings.AgendaPos == "LeftBottom" and 5 or HUD.Settings.AgendaPos == "RightBottom" and ScrW() - 5 - 460 or HUD.Settings.AgendaPos == "LeftTop" and 5 or HUD.Settings.AgendaPos == "RightTop" and ScrW() - 5 - 460
    local y = HUD.Settings.AgendaPos == "LeftBottom" and HUD.LeftBottomLastPos - 110 or HUD.Settings.AgendaPos == "RightBottom" and HUD.RightBottomLastPos - 110 or HUD.Settings.AgendaPos == "LeftTop" and HUD.LeftTopLastPos or HUD.Settings.AgendaPos == "RightTop" and HUD.RightTopLastPos

    local agenda = ply:getAgendaTable()
    if not agenda then return end
    local agendaText = HUD.textWrap((ply:getDarkRPVar("agenda") or ""):gsub("//", "\n"):gsub("\\n", "\n"), "HUD.Identity.AgendaHUD.Text", 440)

    HUD.DrawRect(x, y, 460, 110)

    surface.DrawLine(x, y + 30, x + 459, y + 30)

    draw.DrawNonParsedText(agenda.Title, "HUD.Identity.AgendaHUD.Text", x + 10, y + 5, color_white, 0)
    draw.DrawNonParsedText(agendaText, "HUD.Identity.AgendaHUD.Text", x + 10, y + 40, color_white, 0)
end)