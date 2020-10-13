--[[ ServerInfo --------------------------------------------------------------------------------------

ServerInfo made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

include('shared.lua')

hook.Add("PostDrawTranslucentRenderables", "ServerInfo:Draw3DName", function() 
	for _, ent in pairs (ents.FindByClass("numerix_serverinfo")) do
		if ServerInfo.Settings.ShowName3D then
			if ent:GetPos():Distance(LocalPlayer():GetPos()) < 1000 then
				local Ang = ent:GetAngles()

				Ang:RotateAroundAxis( Ang:Forward(), 90)
				Ang:RotateAroundAxis( Ang:Right(), -90)
		
				cam.Start3D2D(ent:GetPos()+ent:GetUp()*80, Ang, 0.20)
					draw.SimpleTextOutlined( ServerInfo.Settings.Name, "DermaLarge", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))			
				cam.End3D2D()
			end
		end
	end
end)