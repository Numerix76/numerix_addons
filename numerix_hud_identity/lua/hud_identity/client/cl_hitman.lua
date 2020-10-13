local PANEL
local minHitDistanceSqr

--[[---------------------------------------------------------------------------
Hitman menu
---------------------------------------------------------------------------]]
PANEL = {}

AccessorFunc(PANEL, "hitman", "Hitman")
AccessorFunc(PANEL, "target", "Target")
AccessorFunc(PANEL, "selected", "Selected")

function PANEL:Init()
    self.BaseClass.Init(self)

    self.btnClose = vgui.Create("DButton", self)
    self.btnClose:SetText("X")
    self.btnClose:SetTextColor(color_white)
    self.btnClose.DoClick = function() self:Remove() end
    self.btnClose.Paint = function(self, w, h) 
        local GetColorInner = draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(33, 31, 35, 200))
        
        surface.SetDrawColor( Color( 255, 255, 255, 100 ) )
        surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
        
        if self:IsHovered() or self:IsDown() then
            draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 100 ) )
        end
    end

    self.icon = vgui.Create("SpawnIcon", self)
    self.icon:SetDisabled(true)
    self.icon.PaintOver = function(icon) icon:SetTooltip() end
    self.icon:SetTooltip()

    self.title = vgui.Create("DLabel", self)
    self.title:SetText(DarkRP.getPhrase("hitman"))

    self.name = vgui.Create("DLabel", self)
    self.price = vgui.Create("DLabel", self)

    self.playerList = vgui.Create("DScrollPanel", self)

    self.btnRequest = vgui.Create("HitmanMenuButton_Modificate", self)
    self.btnRequest:SetText(DarkRP.getPhrase("hitmenu_request"))
    self.btnRequest.DoClick = function()
        if IsValid(self:GetTarget()) then
            RunConsoleCommand("darkrp", "requesthit", self:GetTarget():SteamID(), self:GetHitman():UserID())
            self:Remove()
        end
    end

    self.btnCancel = vgui.Create("HitmanMenuButton_Modificate", self)
    self.btnCancel:SetText(DarkRP.getPhrase("cancel"))
    self.btnCancel.DoClick = function() self:Remove() end

    self:SetSkin(GAMEMODE.Config.DarkRPSkin)

    self:InvalidateLayout()
end

function PANEL:Think()
    if not IsValid(self:GetHitman()) or self:GetHitman():GetPos():DistToSqr(LocalPlayer():GetPos()) > minHitDistanceSqr then
        self:Remove()
        return
    end

    -- update the price (so the hitman can't scam)
    self.price:SetText(DarkRP.getPhrase("priceTag", DarkRP.formatMoney(self:GetHitman():getHitPrice()), ""))
    self.price:SizeToContents()
end

function PANEL:PerformLayout()
    local w, h = self:GetSize()

    self:SetSize(500, 700)
    self:Center()

    self.btnClose:SetSize(24, 24)
    self.btnClose:SetPos(w - 24 - 5, 5)

    self.icon:SetSize(128, 128)
    self.icon:SetModel(self:GetHitman():GetModel())
    self.icon:SetPos(20, 20)

    self.title:SetFont("HUD.Identity.DarkRP.Text")
    self.title:SetPos(20 + 128 + 20, 20)
    self.title:SizeToContents(true)

    self.name:SizeToContents(true)
    self.name:SetText(DarkRP.getPhrase("name", self:GetHitman():Nick()))
    self.name:SetFont("HUD.Identity.DarkRP.Text")
    self.name:SetPos(20 + 128 + 20, 20 + self.title:GetTall())

    self.price:SetFont("HUD.Identity.DarkRP.Text")
    self.price:SetColor(Color(255, 255, 255, 255))
    self.price:SetText(DarkRP.getPhrase("priceTag", DarkRP.formatMoney(self:GetHitman():getHitPrice()), ""))
    self.price:SetPos(20 + 128 + 20, 20 + self.title:GetTall() + 20)
    self.price:SizeToContents(true)

    self.playerList:SetPos(20, 20 + self.icon:GetTall() + 20)
    self.playerList:SetWide(self:GetWide() - 40)

    self.btnRequest:SetPos(20, h - self.btnRequest:GetTall() - 20)
    self.btnRequest:SetButtonColor(Color(0, 120, 30, 255))

    self.btnCancel:SetPos(w - self.btnCancel:GetWide() - 20, h - self.btnCancel:GetTall() - 20)
    self.btnCancel:SetButtonColor(Color(140, 0, 0, 255))

    self.playerList:StretchBottomTo(self.btnRequest, 20)

    self.BaseClass.PerformLayout(self)
end

function PANEL:Paint()
    local w, h = self:GetSize()

    surface.SetDrawColor(Color(0, 0, 0, 200))
    surface.DrawRect(0, 0, w, h)
end

function PANEL:AddPlayerRows()
    local players = table.Copy(player.GetAll())

    table.sort(players, function(a, b)
        local aTeam, bTeam, aNick, bNick = team.GetName(a:Team()), team.GetName(b:Team()), string.lower(a:Nick()), string.lower(b:Nick())
        return aTeam == bTeam and aNick < bNick or aTeam < bTeam
    end)

    for _, v in ipairs(players) do
        local canRequest = hook.Call("canRequestHit", DarkRP.hooks, self:GetHitman(), LocalPlayer(), v, self:GetHitman():getHitPrice())
        if not canRequest then continue end

        local line = vgui.Create("HitmanMenuPlayerRow_Modificate")
        line:SetPlayer(v)
        self.playerList:AddItem(line)
        line:SetWide(self.playerList:GetWide() - 100)
        line:Dock(TOP)
        line:DockMargin(0, 0, 0, 5)

        line.DoClick = function()
            self:SetTarget(line:GetPlayer())

            if IsValid(self:GetSelected()) then
                self:GetSelected():SetSelected(false)
            end

            line:SetSelected(true)
            self:SetSelected(line)
        end
    end
end

vgui.Register("HitmanMenu_Modificate", PANEL, "DPanel")

--[[---------------------------------------------------------------------------
Hitmenu button
---------------------------------------------------------------------------]]
PANEL = {}

AccessorFunc(PANEL, "btnColor", "ButtonColor")

function PANEL:PerformLayout()
    self:SetSize(self:GetParent():GetWide() / 2 - 30, 100)
    self:SetFont("HUD.Identity.DarkRP.Text")
    self:SetTextColor(Color(255, 255, 255, 255))

    self.BaseClass.PerformLayout(self)
end

function PANEL:Paint()
    local GetColorInner = draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(33, 31, 35, 200))
        
    surface.SetDrawColor( Color( 255, 255, 255, 100 ) )
    surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
    
    if self:IsHovered() or self:IsDown() then
        draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 100 ) )
    end
end

vgui.Register("HitmanMenuButton_Modificate", PANEL, "DButton")

--[[---------------------------------------------------------------------------
Player row
---------------------------------------------------------------------------]]
PANEL = {}

AccessorFunc(PANEL, "player", "Player")
AccessorFunc(PANEL, "selected", "Selected", FORCE_BOOL)

function PANEL:Init()
    self.lblName = vgui.Create("DLabel", self)
    self.lblName:SetMouseInputEnabled(false)
    self.lblName:SetColor(Color(255,255,255,200))

    self.lblTeam = vgui.Create("DLabel", self)
    self.lblTeam:SetMouseInputEnabled(false)
    self.lblTeam:SetColor(Color(255,255,255,200))

    self:SetText("")

    self:SetCursor("hand")
end

function PANEL:PerformLayout()
    local ply = self:GetPlayer()
    if not IsValid(ply) then self:Remove() return end

    self.lblName:SetFont("HUD.Identity.DarkRP.Text")
    self.lblName:SetText(DarkRP.deLocalise(ply:Nick()))
    self.lblName:SizeToContents()
    self.lblName:SetPos(10, 1)

    self.lblTeam:SetFont("HUD.Identity.DarkRP.Text")
    self.lblTeam:SetText((ply.DarkRPVars and DarkRP.deLocalise(ply:getDarkRPVar("job") or "")) or team.GetName(ply:Team()))
    self.lblTeam:SizeToContents()
    self.lblTeam:SetPos(self:GetWide() / 2, 1)
end

function PANEL:Paint()
    if not IsValid(self:GetPlayer()) then self:Remove() return end

    local GetColorInner = draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(33, 31, 35, 200))
        
    surface.SetDrawColor( Color( 255, 255, 255, 100 ) )
    surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
    
    if self:IsHovered() or self:GetSelected() then
        draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 100 ) )
    end

end

vgui.Register("HitmanMenuPlayerRow_Modificate", PANEL, "Button")

--[[---------------------------------------------------------------------------
Open the hit menu
---------------------------------------------------------------------------]]
hook.Add("DarkRPFinishedLoading", "HUD.Identity:RemoveBasicAnimHUD", function()
    timer.Simple(1, function()
        minHitDistanceSqr = GAMEMODE.Config.minHitDistance * GAMEMODE.Config.minHitDistance
        function DarkRP.openHitMenu(hitman)
            local frame = vgui.Create("HitmanMenu_Modificate")
            frame:SetHitman(hitman)
            frame:AddPlayerRows()
            frame:SetVisible(true)
            frame:MakePopup()
            frame:ParentToHUD()
            frame.Paint = function(self, w, h)
                HUD.DrawRect(0, 0, w, h)
            end
        end
    end)
end)