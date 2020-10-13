local Anims = {}

-- Load animations after the languages for translation purposes
hook.Add("loadCustomDarkRPItems", "HUD.Identity:CreateAnim", function()
    Anims[ACT_GMOD_GESTURE_BOW] = DarkRP.getPhrase("bow")
    Anims[ACT_GMOD_TAUNT_MUSCLE] = DarkRP.getPhrase("sexy_dance")
    Anims[ACT_GMOD_GESTURE_BECON] = DarkRP.getPhrase("follow_me")
    Anims[ACT_GMOD_TAUNT_LAUGH] = DarkRP.getPhrase("laugh")
    Anims[ACT_GMOD_TAUNT_PERSISTENCE] = DarkRP.getPhrase("lion_pose")
    Anims[ACT_GMOD_GESTURE_DISAGREE] = DarkRP.getPhrase("nonverbal_no")
    Anims[ACT_GMOD_GESTURE_AGREE] = DarkRP.getPhrase("thumbs_up")
    Anims[ACT_GMOD_GESTURE_WAVE] = DarkRP.getPhrase("wave")
    Anims[ACT_GMOD_TAUNT_DANCE] = DarkRP.getPhrase("dance") 
end)

local AnimFrame
local function AnimationMenu_Remake()
    if AnimFrame then return end

    local Panel = vgui.Create("Panel")
    Panel:SetPos(0,0)
    Panel:SetSize(ScrW(), ScrH())
    function Panel:OnMousePressed()
        AnimFrame:Close()
    end

    AnimFrame = AnimFrame or vgui.Create("DFrame", Panel)
    local Height = table.Count(Anims) * 55 + 32
    AnimFrame:SetSize(130, Height)
    AnimFrame:SetPos(ScrW() / 2 + ScrW() * 0.1, ScrH() / 2 - (Height / 2))
    AnimFrame:SetTitle(DarkRP.getPhrase("custom_animation"))
    AnimFrame.btnMaxim:SetVisible(false)
    AnimFrame.btnMinim:SetVisible(false)
    AnimFrame:SetVisible(true)
    AnimFrame:ShowCloseButton(false)
    AnimFrame:MakePopup()
    AnimFrame:ParentToHUD()
    AnimFrame.Paint = function(self, w, h)
        HUD.DrawRect(0, 0, w, h)
    end

    function AnimFrame:Close()
        Panel:Remove()
        AnimFrame:Remove()
        AnimFrame = nil
    end

    local close = vgui.Create("DButton", AnimFrame)
    close:SetPos(AnimFrame:GetWide() - 25, 5)
    close:SetSize(20 , 20)
    close:SetText("X")
    close:SetTextColor(color_white)
    close.Paint = function(self, w, h)
        local GetColorInner = draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(33, 31, 35, 200))
        
        surface.SetDrawColor( Color( 255, 255, 255, 100 ) )
        surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
        
        if self:IsHovered() or self:IsDown() then
            draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
        end
    end
    close.DoClick = function() AnimFrame:Close() end

    local i = 0
    for k, v in SortedPairs(Anims) do
        i = i + 1
        local button = vgui.Create("DButton", AnimFrame)
        button:SetPos(10, (i - 1) * 55 + 30)
        button:SetSize(110, 50)
        button:SetText(v)
        button:SetTextColor(color_white)
        button.Paint = function(self, w, h)
            local GetColorInner = draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(33, 31, 35, 200))
            
            surface.SetDrawColor( Color( 255, 255, 255, 100 ) )
            surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
            
            if self:IsHovered() or self:IsDown() then
                draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
            end
        end

        button.DoClick = function()
            RunConsoleCommand("_DarkRP_DoAnimation", k)
        end
    end
end

hook.Add("DarkRPFinishedLoading", "HUD.Identity:AnimationHUD", function()
    timer.Simple(1, function()
        concommand.Remove("_DarkRP_AnimationMenu")
        concommand.Add("_DarkRP_AnimationMenu", AnimationMenu_Remake)
    end)
end)