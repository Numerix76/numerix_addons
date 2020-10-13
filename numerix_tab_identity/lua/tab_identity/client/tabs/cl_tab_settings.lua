--[[ TAB --------------------------------------------------------------------------------------

TAB made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local PANEL = {}

function PANEL:Init()
    local ply = LocalPlayer()

    TAB.Init = self
    TAB.Init:Dock(FILL)
    TAB.Init:DockMargin(0, 0, 0, 0)
    TAB.Init.Paint = function( self, w, h )
    end

    TAB.ServerActionsCat = vgui.Create("FAdminPlayerCatagory", TAB.Init)
    TAB.ServerActionsCat:SetLabel("  Server Actions")
    TAB.ServerActionsCat.CatagoryColor = Color(155, 0, 0, 255)
    TAB.ServerActionsCat:SetSize(TAB.Content:GetWide()/3.2, 200)
    TAB.ServerActionsCat:SetPos(5, 0)
    TAB.ServerActionsCat:SetVisible(true)
    function TAB.ServerActionsCat:Toggle()
    end

    TAB.ServerActions = vgui.Create("FAdminPanelList")
    TAB.ServerActionsCat:SetContents(TAB.ServerActions)
    TAB.ServerActions:SetTall(20000)
    for k, v in ipairs(TAB.ServerActions:GetChildren()) do
        if k == 1 then continue end
        v:Remove()
    end

    TAB.PlayerActionsCat = vgui.Create("FAdminPlayerCatagory", TAB.Init)
    TAB.PlayerActionsCat:SetLabel("  Player Actions")
    TAB.PlayerActionsCat.CatagoryColor = Color(0, 155, 0, 255)
    TAB.PlayerActionsCat:SetSize(TAB.Content:GetWide()/3.2, 200)
    TAB.PlayerActionsCat:SetPos(TAB.Content:GetWide()/2-TAB.Content:GetWide()/3.2/2, 0)
    TAB.PlayerActionsCat:SetVisible(true)
    function TAB.PlayerActionsCat:Toggle()
    end

    TAB.PlayerActions = vgui.Create("FAdminPanelList")
    TAB.PlayerActionsCat:SetContents(TAB.PlayerActions)
    TAB.PlayerActions:SetTall(200)
    for k, v in ipairs(TAB.PlayerActions:GetChildren()) do
        if k == 1 then continue end
        v:Remove()
    end

    TAB.ServerSettingsCat = vgui.Create("FAdminPlayerCatagory", TAB.Init)
    TAB.ServerSettingsCat:SetLabel("  Server Settings")
    TAB.ServerSettingsCat.CatagoryColor = Color(0, 0, 155, 255)
    TAB.ServerSettingsCat:SetSize(TAB.Content:GetWide()/3.2, 200)
    TAB.ServerSettingsCat:SetPos(TAB.Content:GetWide() - TAB.Content:GetWide()/3.2 - 5 , 0)
    TAB.ServerSettingsCat:SetVisible(true)
    function TAB.ServerSettingsCat:Toggle()
    end

    TAB.ServerSettings = vgui.Create("FAdminPanelList")
    TAB.ServerSettingsCat:SetContents(TAB.ServerSettings)
    TAB.ServerSettings:SetTall()
    for k, v in ipairs(TAB.ServerSettings:GetChildren()) do
        if k == 1 then continue end
        v:Remove()
    end

    for k, v in ipairs(FAdmin.ScoreBoard.Server.ActionButtons) do
        local visible = v.Visible == true or (isfunction(v.Visible) and v.Visible(ply) == true)

        local ActionButton = vgui.Create("FAdminActionButton")
        local imageType = TypeID(v.Image)
        if imageType == TYPE_STRING then
            ActionButton:SetImage(v.Image or "icon16/exclamation")
        elseif imageType == TYPE_TABLE then
            ActionButton:SetImage(v.Image[1])
            if v.Image[2] then ActionButton:SetImage2(v.Image[2]) end
        elseif imageType == TYPE_FUNCTION then
            local img1, img2 = v.Image()
            ActionButton:SetImage(img1)
            if img2 then ActionButton:SetImage2(img2) end
        else
            ActionButton:SetImage("icon16/exclamation")
        end
        local name = v.Name
        if isfunction(name) then name = name() end
        ActionButton:SetText(DarkRP.deLocalise(name))
        ActionButton:SetBorderColor(visible and v.color or Color(120, 120, 120))
        ActionButton:SetDisabled(not visible)
        ActionButton:Dock(TOP)

        function ActionButton:DoClick()
            return v.Action(self)
        end

        TAB[v.TYPE]:Add(ActionButton)
        if v.OnButtonCreated then
            v.OnButtonCreated(ActionButton)
        end
    end


end
vgui.Register("TAB_Tab_Settings", PANEL, "DPanel")
