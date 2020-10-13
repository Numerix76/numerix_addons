--[[ Timer Prison --------------------------------------------------------------------------------------

Timer Prison made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

util.AddNetworkString("TimerPrison:UpdateInfo")

local timeduration
local actualwork
local sendtime
local work
function TimerPrison.StartTimerPrison()
    timeduration = 0
    actualwork = 1
    if timer.Exists("TimerChange") then timer.Destroy("TimerChange") end
    timer.Create("TimerChange", timeduration, 0, function()
        timeduration = TimerPrison.Settings.Work[actualwork].duration
        work = TimerPrison.Settings.Work[actualwork].work
        if actualwork == #TimerPrison.Settings.Work then
            actualwork = 1
        else
            actualwork = actualwork + 1
        end
        timer.Adjust("TimerChange", timeduration, 0)

        sendtime = CurTime() + timeduration

        for _, ply in pairs(player.GetAll()) do
            net.Start("TimerPrison:UpdateInfo")
            net.WriteString(work)
            net.WriteInt(sendtime,32)
            net.Send(ply)
        end
    end)
end

hook.Add("PlayerInitialSpawn", "UpdateTimer_OnPlayerSpawn", function(ply)
    if timer.Exists("TimerChange") then
        timer.Simple(5, function()
            net.Start("TimerPrison:UpdateInfo")
            net.WriteString(work)
            net.WriteInt(timer.TimeLeft("TimerChange") + CurTime(),32)
            net.Send(ply)
        end)
    end
end)

timer.Create("StartTimerPrison", 1, 1, function()
    TimerPrison.StartTimerPrison()
end)