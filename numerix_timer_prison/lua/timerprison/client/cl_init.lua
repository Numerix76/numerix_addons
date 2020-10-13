--[[ Timer Prison --------------------------------------------------------------------------------------

Timer Prison made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
local color_bg = Color(52, 55, 64, 200)
local color_line = Color(255, 255, 255, 200)
local color_text = Color(255, 255, 255, 255)
local function IsWhitelist()
    if !TimerPrison.Settings.MakeWhitelist then return true end
    
    return !DarkRP and true or TimerPrison.Settings.WhitelistTeam[LocalPlayer():Team()]
end

local work = "no data"
local duration = 0
local timeleft = 0
local text_timer

hook.Add("HUDPaint", "TimerPrison:HUDPaint", function()
    if work != "no data" and IsWhitelist() then
        timeleft = string.ToMinutesSeconds(math.Round(duration - CurTime()) + 1)

        if GetGlobalBool("DarkRP_Lockdown") then
            text_timer = TimerPrison.GetLanguage("Lockdown ! Go to cells !")
        else
            text_timer = string.format(TimerPrison.GetLanguage("Current task: %s for %s"), work, timeleft )
        end
        
        if !TimerPrison.Settings.ShowHUD then return end
        
        surface.SetFont( "Timer.Text" )
        local textlenght = surface.GetTextSize(text_timer)

        if TimerPrison.Settings.Pos == "left" then
            draw.RoundedBox(0, ScrW()/150, ScrH()/100, textlenght + 20, ScrH()/20, color_bg)
            surface.SetDrawColor(color_line)
            surface.DrawOutlinedRect( ScrW()/150, ScrH()/100, textlenght + 20, ScrH()/20 )

            draw.SimpleText(text_timer, "Timer.Text", ScrW()/100, ScrH()/30, color_text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        else
            draw.RoundedBox(0, ScrW()/1.005 - textlenght - 20, ScrH()/100, textlenght + 20, ScrH()/20, color_bg)
            surface.SetDrawColor(color_line)
            surface.DrawOutlinedRect( ScrW()/1.005 - textlenght - 20, ScrH()/100, textlenght + 20, ScrH()/20 )

            draw.SimpleText(text_timer, "Timer.Text", ScrW()/1.01, ScrH()/30, color_text, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end
    end
end)

function TimerPrison.GetText()
    return text_timer or ""
end

net.Receive("TimerPrison:UpdateInfo", function()
    work = net.ReadString()
    duration = net.ReadInt(32)

    if IsWhitelist() and TimerPrison.Settings.SoundFile != "" and !GetGlobalBool("DarkRP_Lockdown") then
        surface.PlaySound(TimerPrison.Settings.SoundFile)
    end
end)

surface.CreateFont( "Timer.Text",{
	size = ScreenScale(8),
	weight = 700,
	antialias = true,
	shadow = false,
	font = "Roboto"
})