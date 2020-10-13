--[[ Escape --------------------------------------------------------------------------------------

Escape made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
local colorline_frame = Color( 255, 255, 255, 100 )
local colorbg_frame = Color(0, 0, 0, 200)

local colorbg_text = Color( 30, 30, 30, 100 )

local PANEL = {}

function PANEL:Init()

    F4Menu.Init = self
    F4Menu.Init:Dock(FILL)
    F4Menu.Init:DockMargin(0, 0, 0, 0)
    F4Menu.Init.Paint = function( self, w, h )
    end

    if !IsValid(F4Menu.frame) then
        F4Menu.buildBox()
    end

    F4Menu.frame:SetParent(F4Menu.Init)
	F4Menu.frame:SetSize( ScrW() - F4Menu.Model:GetWide() + 100, ScrH() - ScrH()/4-10 )
	F4Menu.frame:SetPos( 0, 0)
	F4Menu.frame.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, ScrW() - F4Menu.Model:GetWide() + 100, ScrH() - ScrH()/4-10, colorbg_frame)
        surface.SetDrawColor( colorline_frame )
        surface.DrawOutlinedRect( 0, 0, ScrW() - F4Menu.Model:GetWide() + 100 , ScrH() - ScrH()/4-10 )
	end 
    F4Menu.entry:RequestFocus()
	
end
vgui.Register("F4Menu_Tab_Chat", PANEL, "DPanel")

local AlreadyShow
hook.Remove( "OnPlayerChat", "OnPlayerChat:F4MenuChat")
hook.Add("OnPlayerChat", "OnPlayerChat:F4MenuChat", function( player, message, bTeamOnly, bPlayerIsDead, prefix, col1, col2 )
	if not F4Menu.chatLog then
		F4Menu.buildBox()
	end
		
    if F4Menu.Settings.timeStamps then
        F4Menu.chatLog:InsertColorChange( 130, 130, 130, 255 )
        F4Menu.chatLog:AppendText( "["..os.date("%X").."] ")
    end

    if player:IsPlayer() then
        if F4Menu.Settings.ChatTags and F4Menu.Settings.Tags[player:GetUserGroup()] then
            local col = F4Menu.Settings.Tags[player:GetUserGroup()].color
            F4Menu.chatLog:InsertColorChange( col.r or 255, col.g or 255, col.b or 255, col.a or 255 )
            F4Menu.chatLog:AppendText( "["..F4Menu.Settings.Tags[player:GetUserGroup()].name.."] ")
        end

        if bPlayerIsDead then
            F4Menu.chatLog:InsertColorChange( 200, 0, 0, 255 )
            F4Menu.chatLog:AppendText( F4Menu.GetLanguage("*DEAD*").." " )
        end

        if bTeamOnly then
            local col = GAMEMODE:GetTeamColor( player )
            F4Menu.chatLog:InsertColorChange( col1 and col1.r or col.r or 255, col1 and col1.g or col.g or 255, col1 and col1.b or col.b or 255, col1 and col1.a or col.a or 255 )
            F4Menu.chatLog:AppendText( "("..F4Menu.GetLanguage("TEAM")..") " )
        end

        local col = GAMEMODE:GetTeamColor( player )
        F4Menu.chatLog:InsertColorChange( col1 and col1.r or col.r or 255, col1 and col1.g or col.g or 255, col1 and col1.b or col.b or 255, col1 and col1.a or col.a or 255 )
        F4Menu.chatLog:AppendText( prefix or player:Nick() )
    else
        local col = GAMEMODE:GetTeamColor( player )
        F4Menu.chatLog:InsertColorChange( 255, 255, 255, 255 )
        F4Menu.chatLog:AppendText( F4Menu.GetLanguage("CONSOLE") )
    end

    local col = col2 or 255
    F4Menu.chatLog:InsertColorChange( col2 and col2.r or 255, col2 and col2.g or 255, col2 and col2.b or 255, col2 and col2.a or 255 )
    F4Menu.chatLog:AppendText( ": "..message )
	
	F4Menu.chatLog:AppendText("\n")
	
    F4Menu.chatLog:InsertColorChange( 255, 255, 255, 255 )
    
    AlreadyShow = true
end)

hook.Remove( "ChatText", "ChatText:F4MenuChat")
hook.Add( "ChatText", "ChatText:F4MenuChat", function( index, name, text, type )
	if not F4Menu.chatLog then
		F4Menu.buildBox()
    end
    
    if type != "chat" and type != "darkrp" then
        if F4Menu.Settings.timeStamps then
            F4Menu.chatLog:InsertColorChange( 130, 130, 130, 255 )
            F4Menu.chatLog:AppendText( "["..os.date("%X").."] ")
        end

		F4Menu.chatLog:InsertColorChange( 0, 128, 255, 255 )
		F4Menu.chatLog:AppendText( text.."\n" )
    end
end)


if !oldchat then
    local oldchat = chat.AddText
    function chat.AddText(...)
        if not F4Menu.chatLog then
            F4Menu.buildBox()
        end
        
        if !AlreadyShow then
            if F4Menu.Settings.timeStamps then
                F4Menu.chatLog:InsertColorChange( 130, 130, 130, 255 )
                F4Menu.chatLog:AppendText( "["..os.date("%X").."] ")
            end
            
            local tbl = {...}
            for k, v in pairs(tbl) do
                if istable(v) then
                    F4Menu.chatLog:InsertColorChange( v.r or 255, v.g or 255, v.b or 255, v.a or 255 )
                elseif isstring(v) then
                    F4Menu.chatLog:AppendText( v )
                end
            end

            F4Menu.chatLog:AppendText( "\n" )
        else
            AlreadyShow = false
        end
        
        oldchat(...)
    end
end

function F4Menu.buildBox()
    F4Menu.ChatType = "general"

    F4Menu.frame = vgui.Create("DPanel")
	F4Menu.frame:SetSize(0, 0)
	F4Menu.frame:SetPos( 0, 0)
	F4Menu.frame.Paint = function( self, w, h )
	end
	
	F4Menu.entry = vgui.Create("DTextEntry", F4Menu.frame) 
	F4Menu.entry:SetSize( F4Menu.frame:GetWide() - 50, 30 )
	F4Menu.entry:SetTextColor( color_white )
	F4Menu.entry:SetFont("F4Menu.Chat.Text")
	F4Menu.entry:SetDrawBorder( false )
	F4Menu.entry:SetDrawBackground( false )
	F4Menu.entry:SetCursorColor( color_white )
	F4Menu.entry:SetHighlightColor( Color(52, 152, 219) )
	F4Menu.entry:SetPos( 45, F4Menu.frame:GetTall() - F4Menu.entry:GetTall() - 5 )
    F4Menu.entry.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, h, colorbg_frame)
        surface.SetDrawColor( colorline_frame )
        surface.DrawOutlinedRect( 0, 0, w , h )
		derma.SkinHook( "Paint", "TextEntry", self, w, h )
	end

    F4Menu.entry.OnTextChanged = function( self )
        local value = self:GetText()
        local length = string.len(value)
        
        if (length >= 127) then
            surface.PlaySound("common/talk.wav")
            
            value = string.sub(value, 0, 127)
            
            local position = self:GetCaretPos()
            
            self:SetText(value)
            self:SetCaretPos(position)
		end
	end

    F4Menu.entry.OnKeyCodeTyped = function( self, code )
        local ply = LocalPlayer()
		if code == KEY_ENTER then			
            if string.Trim( self:GetText() ) != "" then
                if F4Menu.ChatType == "team" then
                    ply:ConCommand("say_team \"" .. (self:GetText() or "") .. "\"")
                else
                    ply:ConCommand("say \"" .. self:GetText() .. "\"")
                end
            end
            
            F4Menu.entry:SetText("")
        end
        
        if code == KEY_TAB then
            if F4Menu.ChatType == "general" then
                F4Menu.ChatType = "team"
            else
                F4Menu.ChatType = "general"
            end
            timer.Simple(0.001, function() F4Menu.entry:RequestFocus() end)
        end
	end

	F4Menu.chatLog = vgui.Create("RichText", F4Menu.frame) 
	F4Menu.chatLog:SetSize( F4Menu.frame:GetWide() - 10, F4Menu.frame:GetTall() - 30 )
	F4Menu.chatLog:SetPos( 5, 0 )
	F4Menu.chatLog.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
	end
	F4Menu.chatLog.Think = function( self )
		self:SetSize( F4Menu.frame:GetWide() - 10, F4Menu.frame:GetTall() - F4Menu.entry:GetTall() - 20 )
	end
	F4Menu.chatLog.PerformLayout = function( self )
		self:SetFontInternal("F4Menu.Chat.Text")
		self:SetFGColor( color_white )
	end
	
	local text = F4Menu.GetLanguage("Say").." :"

	local say = vgui.Create("DLabel", F4Menu.frame)
	say:SetText("")
	surface.SetFont( "F4Menu.Chat.Text")
	local w, h = surface.GetTextSize( text )
	say:SetSize( w + 5, 30 )
	say:SetPos( 5, F4Menu.frame:GetTall() - F4Menu.entry:GetTall() - 2.5 )
	
	say.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, colorbg_text )
		draw.DrawText( text, "F4Menu.Chat.Text", 2, 1, color_white )
	end

	say.Think = function( self )
		local s = {}

        if F4Menu.ChatType == "team" then
            text = F4Menu.GetLanguage("Say").." ("..F4Menu.GetLanguage("TEAM")..") :"
        else
            text = F4Menu.GetLanguage("Say").." :"
        end

		if s then
			if not s.pw then s.pw = self:GetWide() + 10 end
			if not s.sw then s.sw = F4Menu.frame:GetWide() - self:GetWide() - 15 end
		end

		local w, h = surface.GetTextSize( text )
		self:SetSize( w + 5, 20 )
		self:SetPos( 5, F4Menu.frame:GetTall() - F4Menu.entry:GetTall() - 2.5 )

		F4Menu.entry:SetSize( s.sw, 30 )
		F4Menu.entry:SetPos( s.pw, F4Menu.frame:GetTall() - F4Menu.entry:GetTall() - 5 )
    end
end


function F4Menu.HideBox()
    if !F4Menu.frame then F4Menu.buildBox() return end

    F4Menu.frame:SetParent(vgui.GetWorldPanel())
	F4Menu.frame:SetSize(0,0)
	F4Menu.frame.Paint = function()
	end
end