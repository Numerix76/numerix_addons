--[[ Phone --------------------------------------------------------------------------------------

Phone made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

include('shared.lua')

function ENT:Draw()    
    self:DrawModel() 
end

hook.Add("PostDrawTranslucentRenderables", "Phone:Draw3DName", function() 
	for _, ent in ipairs(ents.FindByClass("numerix_phone")) do
		if Phone.Settings.ShowName3D then
			if ent:GetPos():Distance(LocalPlayer():GetPos()) < 1000 then
				local Ang = ent:GetAngles()

				Ang:RotateAroundAxis( Ang:Forward(), 90)
				Ang:RotateAroundAxis( Ang:Right(), -90)
		
				cam.Start3D2D(ent:GetPos()+ent:GetUp()*50, Ang, 0.20)
					draw.SimpleTextOutlined( Phone.GetLanguage("Phone"), "DermaLarge", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))			
				cam.End3D2D()
			end
		end
	end
end)