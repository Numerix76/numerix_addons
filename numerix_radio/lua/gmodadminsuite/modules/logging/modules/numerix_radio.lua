--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local MODULE = GAS.Logging:MODULE() 
MODULE.Category = "Numerix Addons"
MODULE.Name = "Radio"
MODULE.Colour = Color(255,0,0)

MODULE:Setup(function()

    MODULE:Hook("Radio:PlayerStopMusic", "StopMusic", function(ply, ent)
      MODULE:Log("{1} has stopped the music on the {2}", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent))
    end)

    MODULE:Hook("Radio:PlayerUpdateVolume", "UpdateVolume", function(ply, ent, volume)
      MODULE:Log("{1} has changed the volume on the {2} to {3}", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent), GAS.Logging:Escape(volume))
    end)
      
    MODULE:Hook("Radio:PlayerSetMusic", "SetMucic", function(ply, ent, id, mode)
      MODULE:Log("{1} has changed the music on the {2} to ID : {3}, Mode : {4}", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent), GAS.Logging:Escape(id), GAS.Logging:Escape(mode))
    end)
      
    MODULE:Hook("Radio:PlayerPauseMusic", "PauseMusic", function(ply, ent, pause)
      MODULE:Log("{1} has {3} the music on the {2}", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent), GAS.Logging:Escape(pause and 'paused' or 'unpaused'))
    end)
      
    MODULE:Hook("Radio:PlayerSeekMusic", "SeekMusic", function(ply, ent, time)
      MODULE:Log("{1} has seek the music on the {2} to {3}", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent), GAS.Logging:Escape(Radio.SecondsToClock(time)))
    end)
      
    MODULE:Hook("Radio:PlayerUpdateVisual", "UpdateVisual", function(ply, ent, color, rainbow)
      MODULE:Log("{1} has update the visual on the {2} to Color : {3}, Rainbow : {4}", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent), GAS.Logging:Escape(color), GAS.Logging:Escape(rainbow))
    end)
      
    MODULE:Hook("Radio:ChangeMod", "ChangeMod", function(ply, ent, radio)
      MODULE:Log("{1} has change the mod of the {2} and now it's a {3}", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent), GAS.Logging:FormatEntity(radio))
    end)
      
    MODULE:Hook("Radio:ConnectRadio", "ConnectRadio", function(ply, ent, server)
      MODULE:Log("{1} has connected {2} to {3}", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent), GAS.Logging:FormatEntity(ent))
    end)

    MODULE:Hook("Radio:DisconnectRadio", "DisconnectRadio", function(ply, ent, server)
      MODULE:Log("{1} has disconnected {2} from {3}", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent), GAS.Logging:FormatEntity(ent))
    end)
      
    MODULE:Hook("Radio:SetNameServer", "SetNameServer", function(ply, ent, name)
      MODULE:Log("{1} has changed the station name of {2} to {3}", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent), GAS.Logging:Escape(name))
    end)
      
    MODULE:Hook("Radio:ChangeLoopState", "ChangeLoopState", function(ply, ent, loop)
      MODULE:Log("{1} has {3} the music loop on the {2}", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent), GAS.Logging:Escape(loop and 'enable' or 'disable'))
    end)
      
    MODULE:Hook("Radio:ChangePrivateState", "ChangePrivateState", function(ply, ent, private)
      MODULE:Log("{1} has {3} the private mode on the {2}", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent), GAS.Logging:Escape(private and 'enable' or 'disable'))
    end)
      
    MODULE:Hook("Radio:ChangePrivateBuddyState", "ChangePrivateBuddyState", function(ply, ent, privatebuddy)
      MODULE:Log("{1} has {3} the private buddy on the {2}", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent), GAS.Logging:Escape(privatebuddy and 'enable' or 'disable'))
    end)
end)

GAS.Logging:AddModule(MODULE)