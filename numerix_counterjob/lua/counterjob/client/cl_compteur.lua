--[[ Counter Job --------------------------------------------------------------------------------------

Counter Job made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local text = ""
local value = 0

local function StartCounter()
if timer.Exists("CounterUpdate") then timer.Destroy("CounterUpdate") end
    timer.Create("CounterUpdate",CounterJob.Settings.Refresh,0,function()
        text = ""
        value = 0
        for k, v in ipairs(CounterJob.Settings.Team) do
                   
            for job, val in pairs(v.teams) do
                if val == true then
                    value = value + team.NumPlayers(job)
                end
            end

            if k == 1 then
                text = v.name..": "..value
            else
                text = text.." | "..v.name..": "..value
            end
            value = 0
        end
    end) 
end
StartCounter()

if CounterJob.Settings.DrawHUD then
    hook.Add( "HUDPaint", "JobCounter", function()
        draw.SimpleText( text, "Compteur.Metier.Texte", CounterJob.Settings.PosX() ,CounterJob.Settings.PosY(), CounterJob.Settings.TextColor, CounterJob.Settings.AlignX, CounterJob.Settings.AlignY)
    end)
else
    hook.Remove( "HUDPaint", "JobCounter")
end

function CounterJob.GetInfo()
    return text
end

surface.CreateFont( "Compteur.Metier.Texte", {
    font = "Roboto",
    extended = false,
    size = CounterJob.Settings.TextFont,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
} )