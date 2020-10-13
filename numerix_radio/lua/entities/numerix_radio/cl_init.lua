--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
local color_orange = Color(255,69,0)

include("shared.lua")
local bar = 128
local maxw = 1550*2
local prevFrame = {}
local bar_w = math.Round(maxw/(bar+1))
local color
local ent
local p
local a
function ENT:Draw()    
	self:DrawModel()

	ent = self:GetNWEntity("Radio:Entity")
	
	if LocalPlayer():GetPos():DistToSqr(self:GetPos()) < 100000 then
		p = self:GetPos();
		p = p + self:GetForward() * 3.1;
		p = p + self:GetRight() * 12.5;
		p = p + self:GetUp() * 9;
		p = p + self:GetForward() * -1;
		a = self:GetAngles();
		a:RotateAroundAxis( a:Up(), 90 );
		a:RotateAroundAxis( a:Forward(), 90 );
		
		color = string.ToColor(self:GetNWString("Radio:Visual"))

		--Draw FFT vizualizer
		if self.station and IsValid(self.station) then
			cam.Start3D2D( p, a, 0.005 );
				if !self.FTT then
					self.FTT = {}
				end
				
				if( self.station:GetState() == GMOD_CHANNEL_PLAYING ) then
					self.station:FFT(self.FTT, FFT_256)
				
					surface.SetDrawColor(color)
				
					for i = 1, bar do
						if (i-1) * (bar_w+10) + bar_w > maxw then
							break
						end

						if not prevFrame[i] then prevFrame[i] = 0 end
						prevFrame[i] = math.Clamp(Lerp(2.5 * FrameTime(), prevFrame[i], -self.FTT[i] * 100 * self:GetNWInt("Radio:Volume")), -900, 0 )

						if self:GetNWBool("Radio:Rainbow") then
							local c = HSVToColor( i * 360 / bar, 1, 1 );
							surface.SetDrawColor( c ); --Rainbow 
						end
						surface.DrawRect((i-1) * (bar_w+10)+ 1000, 1800, bar_w, prevFrame[i])
					end
				end
			cam.End3D2D()
		end

		cam.Start3D2D( p, a, 0.04 );

			surface.SetFont( "Radio.Video.Info" )

			if self:GetNWInt("Radio:Info") != "" then
				surface.SetTextColor( color_orange )
				surface.SetTextPos( 170, 50 )
				surface.DrawText( self:GetNWInt("Radio:Info") )	
			elseif self.station and IsValid(self.station) then
				surface.SetTextColor( color_white )
				surface.SetTextPos( 170, 10 )

				local Title = ent:GetNWString("Radio:Title")
				local w, _ = surface.GetTextSize( Title );
				if( w > 270 ) then

					for i = string.len( Title ), 1, -1 do

						w, _ = surface.GetTextSize( string.sub( Title, 1, i ) );
						if( w <= 290 ) then

							surface.DrawText( string.sub( Title, 1, i ) .. "..." );
							break;

						end

					end

				else
					surface.DrawText( Title );
				end

				surface.SetTextPos( 170, 30 )

				local Author = ent:GetNWString("Radio:Author")
				local w, _ = surface.GetTextSize( Author );
				if( w > 270 ) then

					for i = string.len( Author ), 1, -1 do

						local w, _ = surface.GetTextSize( string.sub( Author, 1, i ) );
						if( w <= 290 ) then

							surface.DrawText( string.sub( Author, 1, i ) .. "..." );
							break;

						end

					end

				else
					surface.DrawText( Author );
				end

				if ent:GetNWInt("Radio:Duration") != 0 then
					local time = self.station:GetTime()
					if ent:GetNWString("Radio:Mode") != "3" then
						surface.SetDrawColor(color)
						surface.DrawRect( 155, 95, 315*time/ent:GetNWInt("Radio:Duration"), 5)
					else
						surface.SetTextColor( color_white )
						surface.SetTextPos( 170, 50 )
						surface.DrawText( Radio.SecondsToClock(self.station:GetTime()) )	
					end
				end
			end
		cam.End3D2D()
	end
end

function ENT:Think()
	Radio.Think(self, self:GetNWEntity("Radio:Entity"))
end

function ENT:OnRemove()
	Radio.StopMusic(self)
	Radio.AllRadio[self] = nil
end