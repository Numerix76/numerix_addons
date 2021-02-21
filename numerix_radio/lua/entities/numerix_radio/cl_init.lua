--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

include("shared.lua")

local InfoTable = {
	InfoPos = Vector(3.1, 12.5, 9),
	InfoAng = Angle( 0, 90, 90),

	InfoOffsetFFT = 0.005,

	InfoMaxWFFT = 1550*2,
	InfoMaxHFFT = 900,

	InfoPosXFFT = 1000,
	InfoPosYFFT = 1800,

	InfoOffsetText = 0.04,

	InfoPosXText = 170,
	InfoPosYText = 10,
	InfoPosYTextError = 50,

	InfoMaxWText = 270,

	InfoPosXTimeBar = 155,
	InfoPosYTimeBar = 95,
	InfoMaxWTimeBar = 315,
}

function ENT:Draw()
	self:DrawModel()
	self:Draw3DInfo(InfoTable)
end