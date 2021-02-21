--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

include("shared.lua")

local InfoTable = {
	InfoPos = Vector(10.8, 24, 20.5),
	InfoAng = Angle( 0, 90, 82.5),

	InfoOffsetFFT = 0.005,

	InfoMaxWFFT = 2750,
	InfoMaxHFFT = 1200,

	InfoPosXFFT = 1150,
	InfoPosYFFT = 2250,

	InfoOffsetText = 0.04,

	InfoPosXText = 150,
	InfoPosYText = 10,
	InfoPosYTextError = 50,

	InfoMaxWText = 290,

	InfoPosXTimeBar = 140,
	InfoPosYTimeBar = 95,
	InfoMaxWTimeBar = 315,

	InfoBlackPosBack = -0.19,
	InfoBlackPosX = 140,
	InfoBlackPosY = -15,
	InfoBlackPosW = 350,
	InfoBlackPosH = 300,

	InfoPosVoice = Vector(11.5, 39.8, 48.7),
	InfoAngVoice = Angle( 0, 90, 90),
	InfoOffsetVoice = 0.05,

	InfoVoiceBackX = -10,
	InfoVoiceBackY = -65,
	InfoVoiceBackW = 245,
	InfoVoiceBackH = 200,

	InfoVoiceTextX = 10,
	InfoVoiceTextY = -10,
}

function ENT:Draw()
	self:DrawModel()
	self:Draw3DInfo(InfoTable)
end