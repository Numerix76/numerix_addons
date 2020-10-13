--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
local color_orange = Color(255,69,0)
local color_red = Color(255,0,0)
local color_green = Color(0,255,0)
local color_blue = Color(0,0,255)

include("shared.lua")
local bar = 128
local maxw = 2750
local prevFrame = {}
local bar_w = math.Round(maxw/(bar+1))
local color
local p
local a
function ENT:Draw()    
	self:DrawModel()
	
	if LocalPlayer():GetPos():DistToSqr(self:GetPos()) < 100000 then
		p = self:GetPos();
		p = p + self:GetForward() * 9.8;
		p = p + self:GetRight() * 24;
		p = p + self:GetUp() * 20.5;
		a = self:GetAngles();
		a:RotateAroundAxis( a:Up(), 90 );
		a:RotateAroundAxis( a:Forward(), 83 );
		
		color = string.ToColor(self:GetNWString("Radio:Visual"))
		
		cam.Start3D2D( p + self:GetForward() * -0.19, a, 0.04 );
			surface.SetDrawColor(color_black)
			surface.DrawRect(140, -15, 350, 300)
		cam.End3D2D()

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
						prevFrame[i] = math.Clamp(Lerp(2.5 * FrameTime(), prevFrame[i], -self.FTT[i] * 100 * self:GetNWInt("Radio:Volume")), -1200, 0 ) 

						if self:GetNWBool("Radio:Rainbow") then
							local c = HSVToColor( i * 360 / bar, 1, 1 );
							surface.SetDrawColor( c ); --Rainbow 
						end
						surface.DrawRect((i-1) * (bar_w+10)+ 1150, 2250, bar_w, prevFrame[i])
					end
				end
			cam.End3D2D()
		end

		cam.Start3D2D( p, a, 0.04 );
			surface.SetFont( "Radio.Menu" )

			if self:GetNWInt("Radio:Info") != "" then
				surface.SetTextColor( color_orange )
				surface.SetTextPos( 150, 50 )
				surface.DrawText( self:GetNWInt("Radio:Info") )	
			elseif self.station and IsValid(self.station) then
				surface.SetTextColor( color_white )
				surface.SetTextPos( 150, 10 )

				local Title = self:GetNWString("Radio:Title")
				local w, _ = surface.GetTextSize( Title );
				if( w > 290 ) then

					for i = string.len( Title ), 1, -1 do

						w, _ = surface.GetTextSize( string.sub( Title, 1, i ) );
						if( w <= 310 ) then

							surface.DrawText( string.sub( Title, 1, i ) .. "..." );
							break;

						end

					end

				else
					surface.DrawText( Title );
				end

				surface.SetTextPos( 150, 30 )

				local Author = self:GetNWString("Radio:Author")
				local w, _ = surface.GetTextSize( Author );
				if( w > 290 ) then

					for i = string.len( Author ), 1, -1 do

						local w, _ = surface.GetTextSize( string.sub( Author, 1, i ) );
						if( w <= 210 ) then

							surface.DrawText( string.sub( Author, 1, i ) .. "..." );
							break;

						end

					end

				else
					surface.DrawText( Author );
				end

				if self:GetNWInt("Radio:Duration") != 0 then
					local time = self.station:GetTime()
					if self:GetNWString("Radio:Mode") != "3" then
						surface.SetDrawColor(color)
						surface.DrawRect( 140, 95, 350*time/self:GetNWInt("Radio:Duration"), 5)
					else
						surface.SetTextColor( color_white )
						surface.SetTextPos( 150, 50 )
						surface.DrawText( Radio.SecondsToClock(self.station:GetTime()) )	
					end
				end
			end
		cam.End3D2D()
		
		p = self:GetPos();
		p = p + self:GetForward() * 10;
		p = p + self:GetUp() * 48.8;
		p = p + self:GetRight() * 39.5;
		a = self:GetAngles();
		a:RotateAroundAxis( a:Up(), 90 );
		a:RotateAroundAxis( a:Forward(), 90 );

		cam.Start3D2D( p, a, 0.05 );
			surface.SetFont( "Radio.Voice" )

			local _w, _h = surface.GetTextSize( string.upper( Radio.GetLanguage("Voice") ) );

			surface.SetDrawColor( color_black );
			surface.DrawRect(-15, -65, 300, 200)
			if( self:GetNWBool('Radio:Voice') ) then
				if( LocalPlayer().RadioVoice ) then
					surface.SetTextColor( color_green );
				else
					surface.SetTextColor( color_blue );
				end
			else
				surface.SetTextColor( color_red );
			end

			surface.SetTextPos( 0, -10 );
			surface.DrawText( string.upper(  Radio.GetLanguage("Voice") ) );

		cam.End3D2D();
	end
end


function ENT:Think()
	Radio.Think(self, self:GetNWEntity("Radio:Entity"))
end

function ENT:OnRemove()
	Radio.StopMusic(self)
	Radio.AllServer[self] = nil
end