--[[ TAB --------------------------------------------------------------------------------------

TAB made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local PANEL = {}

function PANEL:Init()

    TAB.Init = self
    TAB.Init:Dock(FILL)
    TAB.Init:DockMargin(0, 0, 0, 0)
    TAB.Init.Paint = function( self, w, h )
    end

    local victim = TAB.SelectedPlayer
    local ScreenHeight = ScrH()

    TAB.Init.Think = function()
        if !IsValid(victim) then
            if IsValid( TAB.Content ) then
                TAB.Content:Remove()
                TAB.Content = vgui.Create("DPanelList", TAB.Menu)
                TAB.Content:SetSize(TAB.Menu:GetWide()/1.02, TAB.Menu:GetTall()-130)
                TAB.Content:SetPos(TAB.Menu:GetWide()/100,100)
                TAB.Content.Paint = function(self, w, h) end
            end
            vgui.Create("TAB_Tab_Home", TAB.Content)
            TAB.Setting:SetToolTip(TAB.GetLanguage("Settings"))
        end
    end

    TAB.AvatarBackground = vgui.Create("AvatarImage", TAB.Init)
    TAB.AvatarBackground:SetPos(10, 10)
    TAB.AvatarBackground:SetSize(ScrW()/8, ScrW()/8)
    TAB.AvatarBackground:SetPlayer(victim, 184)
    TAB.AvatarBackground:SetVisible(true)

    TAB.InfoPanels = TAB.InfoPanels or {}
    for k, v in ipairs(TAB.InfoPanels) do
        if IsValid(v) then
            v:Remove()
            TAB.InfoPanels[k] = nil
        end
    end

    if IsValid(TAB.InfoPanel1) then
        TAB.InfoPanel1:Remove()
    end

    TAB.InfoPanel1 = vgui.Create("DListLayout", TAB.Init)
    TAB.InfoPanel1:SetPos(15 + TAB.AvatarBackground:GetWide() --[[+ Avatar]], 10)
    TAB.InfoPanel1:SetSize(TAB.Content:GetWide() - TAB.AvatarBackground:GetWide() - 30 - 10, TAB.AvatarBackground:GetTall())
    TAB.InfoPanel1:SetVisible(true)
    TAB.InfoPanel1:Clear(true)

    for k, v in ipairs(FAdmin.ScoreBoard.Player.Information) do
        local Value = v.func(victim)
        if Value and Value ~= "" then

            local Text = vgui.Create("DLabel")
            Text:Dock(LEFT)
            Text:SetFont("TabLarge")
            Text:SetText(v.name .. ": " .. Value)
            Text:SizeToContents()
            Text:SetColor(Color(255,255,255,255))
            Text:SetTooltip(TAB.GetLanguage("Click to copy").. " '" .. v.name .. "' ".. TAB.GetLanguage("to clipboard"))
            Text:SetMouseInputEnabled(true)

            function Text:OnMousePressed(mcode)
                self:SetTooltip("'" .. v.name .. "' ".. TAB.GetLanguage("copied to clipboard!"))
                ChangeTooltip(self)
                SetClipboardText(Value)
                self:SetTooltip(TAB.GetLanguage("Click to copy").. " '" .. v.name .. "' ".. TAB.GetLanguage("to clipboard"))
            end

            TAB.InfoPanel1:Add(Text)
        end
    end

    local CatColor = team.GetColor(victim:Team())
    TAB.ButtonCat = vgui.Create("FAdminPlayerCatagory", TAB.Init)
    TAB.ButtonCat:SetLabel("  ".. TAB.GetLanguage("Player options"))
    TAB.ButtonCat.CatagoryColor = CatColor
    TAB.ButtonCat:SetSize(TAB.Content:GetWide() - 10, 100)
    TAB.ButtonCat:SetPos(10, 10 + TAB.AvatarBackground:GetTall() + 15 )
    TAB.ButtonCat:SetVisible(true)

    function TAB.ButtonCat:Toggle()
    end

    TAB.ButtonPanel = vgui.Create("FAdminPanelList", TAB.ButtonCat)
    TAB.ButtonPanel:SetSpacing(5)
    TAB.ButtonPanel:EnableHorizontal(true)
    TAB.ButtonPanel:EnableVerticalScrollbar(true)
    TAB.ButtonPanel:SizeToContents()
    TAB.ButtonPanel:SetVisible(true)
    TAB.ButtonPanel:SetSize(0, TAB.Content:GetTall() - TAB.AvatarBackground:GetTall())
    TAB.ButtonPanel:Clear()
    TAB.ButtonPanel:DockMargin(5, 5, 5, 5)

    for _, v in ipairs(TAB.ActionButtons) do
        if v.Visible == true or (isfunction(v.Visible) and v.Visible(victim) == true) then
            local ActionButton = vgui.Create("FAdminActionButton")
            local imageType = TypeID(v.Image)
            if imageType == TYPE_STRING then
                ActionButton:SetImage(v.Image or "icon16/exclamation")
            elseif imageType == TYPE_TABLE then
                ActionButton:SetImage(v.Image[1])
                if v.Image[2] then ActionButton:SetImage2(v.Image[2]) end
            elseif imageType == TYPE_FUNCTION then
                local img1, img2 = v.Image(victim)
                ActionButton:SetImage(img1)
                if img2 then ActionButton:SetImage2(img2) end
            else
                ActionButton:SetImage("icon16/exclamation")
            end
            local name = v.Name
            if isfunction(name) then name = name(victim) end
            ActionButton:SetText(DarkRP.deLocalise(name))
            ActionButton:SetBorderColor(v.color)

            function ActionButton:DoClick()
                if not IsValid(victim) then return end
                return v.Action(victim, self)
            end
            TAB.ButtonPanel:AddItem(ActionButton)
            if v.OnButtonCreated then
                v.OnButtonCreated(victim, ActionButton)
            end
        end
    end
    TAB.ButtonPanel:Dock(TOP)
        
end
vgui.Register("TAB_Tab_Player", PANEL, "DPanel")