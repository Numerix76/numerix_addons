--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local radio_open_menu = CreateClientConVar( "radio_open_menu", 23 )
local radio_retrieve = CreateClientConVar( "radio_retrieve", 18 )

hook.Add( "AddToolMenuCategories", "Radio:MakeCategoryOption", function()
	spawnmenu.AddToolCategory( "Options", "Radio", "Radio" )
end )

hook.Add( "PopulateToolMenu", "Radio:MakeOptions", function()
	spawnmenu.AddToolMenuOption( "Options", "Radio", "Radio_Numerix_Config", "Config", "", "", function( panel )
		panel:SetName("Radio Config")
		panel:AddControl("Numpad", {
			Label = Radio.GetLanguage("Open menu in car"),
			Command = "radio_open_menu"
		})

		panel:AddControl("Numpad", {
			Label = Radio.GetLanguage("Take the radio in the car"),
			Command = "radio_retrieve"
		})
	end )
end )