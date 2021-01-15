--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

include("shared.lua")

function ENT:OnRemove()
    self:StopMusicRadio()
    
    if self.IsServer then
        Radio.AllServer[self] = nil
    end
    
    Radio.AllRadio[self] = nil
end