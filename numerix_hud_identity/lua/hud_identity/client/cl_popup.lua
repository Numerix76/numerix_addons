--[[ HUD Identity --------------------------------------------------------------------------------------

HUD Identity made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

hook.Add("DarkRPFinishedLoading", "HUD.Identity:AdminTellHUD", function()
    usermessage.Hook("AdminTell", function(msg)
        local Message = msg:ReadString()

        HUD:AddNotice(DarkRP.getPhrase("listen_up"), Message, 10, HUD.Settings.ColorTitleAdminTell, HUD.Settings.ColorMessageAdminTell)
    end)
end)

HUD.Notice = {}
function HUD:AddNotice(title, message, time, titlecolor, messsagecolor)
    table.insert(HUD.Notice, #HUD.Notice + 1, {
        title = title,
        message = message,
        time = HUD.Notice[1] and HUD.Notice[1].time + time or CurTime() + time,
        titlecolor = isstring(titlecolor) and string.ToColor(titlecolor) or titlecolor or Color(255,255,255,255),
        messsagecolor = isstring(messsagecolor) and string.ToColor(messsagecolor) or messsagecolor or Color(255,255,255,255)
    })
end

hook.Add("HUDPaint", "HUD.Identity:NoticeHUD", function()
    local ShouldDraw = hook.Call("HUDShouldDraw", GAMEMODE, "HUD.Identity:NoticeHUD")

    if ShouldDraw == false then return end

    if HUD.Notice[1] then
        if HUD.Notice[1].time > CurTime() then

            surface.SetFont("HUD.Identity.NoticeHUD.Title")
            local title = HUD.textWrap((HUD.Notice[1].title or ""):gsub("//", "\n"):gsub("\\n", "\n"), "HUD.Identity.NoticeHUD.Title", ScrW()-40)
            local w, h = surface.GetTextSize(title)


            surface.SetFont("HUD.Identity.NoticeHUD.Text")
            local message = HUD.textWrap((HUD.Notice[1].message or ""):gsub("//", "\n"):gsub("\\n", "\n"), "HUD.Identity.NoticeHUD.Text", ScrW()-40)
            local w2, h2 = surface.GetTextSize(message)
            
            w = w > w2 and w or w2

            w = w + 40
            htotal = h + h2 + 25 + 20

            HUD.DrawRect(ScrW()/2 - w/2, ScrH()/10, w, htotal)

            draw.DrawNonParsedText( title, "HUD.Identity.NoticeHUD.Title", ScrW() / 2, ScrH()/10, HUD.Notice[1].titlecolor, TEXT_ALIGN_CENTER )
            draw.DrawNonParsedText( message, "HUD.Identity.NoticeHUD.Text", ScrW() / 2,  ScrH()/10 + h + 25, HUD.Notice[1].messsagecolor, TEXT_ALIGN_CENTER)
        else
            table.remove(HUD.Notice, 1)
        end
    end

end)

HUD.LastWarningBattery = 0
hook.Add("Think", "HUD.Identity:Think", function()
    if system.BatteryPower() <= 20 and HUD.LastWarningBattery < CurTime() then
        HUD:AddNotice(HUD.GetLanguage("Battery Status"), HUD.GetLanguage("You have less than 20% of battery. Plug your computer to avoid crash."), 10, HUD.Settings.ColorTitleWarningBattery, HUD.Settings.ColorMessageWarningBattery)
        HUD.LastWarningBattery = CurTime() + 60*60
    end
end)