--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local function PlayerRadioStartVoice( ply )
	ply.RadioVoice = true;
end
hook.Add( "PlayerStartVoice", "Radio:PlayerRadioStartVoice", PlayerRadioStartVoice )

local function PlayerRadioEndVoice( ply )
	ply.RadioVoice = false;
end
hook.Add( "PlayerEndVoice", "Radio:PlayerRadioEndVoice", PlayerRadioEndVoice )