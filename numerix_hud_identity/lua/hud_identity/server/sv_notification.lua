--[[ HUD Identity  --------------------------------------------------------------------------------------

HUD Identity made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

hook.Add("playerWarranted", "HUD.Identity:WarrantHUD", function(ply, warranter, reason)

    local color1 = string.FromColor(HUD.Settings.ColorTitleWarrant or Color(255,255,255))
    local color2 = string.FromColor(HUD.Settings.ColorMessageWarrant or Color(255,255,255))

    for k, v in pairs(player.GetAll()) do
        v:SendLua([[HUD:AddNotice("]]..HUD.GetLanguage('Warrant')..[[", "]]..string.format(HUD.GetLanguage("%s has make a warrant on %s for %s"), IsValid(warranter) and warranter:Nick() or DarkRP.getPhrase("disconnected_player"), ply:Nick(), reason )..[[", 5, "]]..color1..[[", "]]..color2..[[")]])
    end

    return true
end)

hook.Add("playerWanted", "HUD.Identity:WantedHUD", function(ply, actor, reason)

    local color1 = string.FromColor(HUD.Settings.ColorTitleWanted or Color(255,255,255))
    local color2 = string.FromColor(HUD.Settings.ColorMessageWanted or Color(255,255,255))

    for k, v in pairs(player.GetAll()) do
        v:SendLua([[HUD:AddNotice("]]..HUD.GetLanguage('Wanted')..[[", "]]..string.format(HUD.GetLanguage("%s has make wanted %s for %s"), IsValid(actor) and actor:Nick() or DarkRP.getPhrase("disconnected_player"), ply:Nick(), reason )..[[", 5, "]]..color1..[[", "]]..color2..[[")]])
    end

    return true
end)

hook.Add("playerUnWanted", "HUD.Identity:UnWantedHUD", function(ply, actor)

    local color1 = string.FromColor(HUD.Settings.ColorTitleUnWanted or Color(255,255,255))
    local color2 = string.FromColor(HUD.Settings.ColorMessageUnWanted or Color(255,255,255))

    local expiredMessage = IsValid(actor) and string.format(HUD.GetLanguage("%s unwanted %s"), actor:Nick() or "", ply:Nick()) or DarkRP.getPhrase("wanted_expired", self:Nick())

    for k, v in pairs(player.GetAll()) do
        v:SendLua([[HUD:AddNotice("]]..HUD.GetLanguage('Wanted')..[[", "]]..expiredMessage..[[", 5, "]]..color1..[[", "]]..color2..[[")]])
    end

    return true
end)