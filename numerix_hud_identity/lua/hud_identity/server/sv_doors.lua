--[[ HUD Identity  --------------------------------------------------------------------------------------

HUD Identity made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

hook.Add("onKeysLocked", "HUD.Identity:SendDataLock", function(door)
    local doorData = door:getDoorData()
    doorData.islock = true

    DarkRP.updateDoorData(door, "islock")
end)

hook.Add("onKeysUnlocked", "HUD.Identity:SendDataLock", function(door)
    local doorData = door:getDoorData()
    doorData.islock = false
    
    DarkRP.updateDoorData(door, "islock")
end)