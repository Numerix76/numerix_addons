--[[ Escape --------------------------------------------------------------------------------------

Escape made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
local colorline_frame = Color( 255, 255, 255, 100 )
local colorbg_frame = Color(0, 0, 0, 200)

local colorbg_text = Color( 30, 30, 30, 100 )


local PANEL = {}

function PANEL:Init()

    Echap.Init = self
    Echap.Init:Dock(FILL)
    Echap.Init:DockMargin(0, 0, 0, 0)
    Echap.Init.Paint = function( self, w, h )
    end

    if !IsValid(Echap.frame) then
        Echap.buildBox()
    end

    Echap.frame:SetParent(Echap.Init)
	Echap.frame:SetSize( ScrW() - Echap.Model:GetWide() + 100, ScrH() - ScrH()/4-10 )
	Echap.frame:SetPos( 0, 0)
	Echap.frame.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, ScrW() - Echap.Model:GetWide() + 100, ScrH() - ScrH()/4-10, colorbg_frame)
        surface.SetDrawColor( colorline_frame )
        surface.DrawOutlinedRect( 0, 0, ScrW() - Echap.Model:GetWide() + 100 , ScrH() - ScrH()/4-10 )
	end 
    Echap.entry:RequestFocus()
	
end
vgui.Register("Echap_Tab_Chat", PANEL, "DPanel")

local AlreadyShow
hook.Remove( "OnPlayerChat", "OnPlayerChat:EscapeChat")
hook.Add("OnPlayerChat", "OnPlayerChat:EscapeChat", function( player, message, bTeamOnly, bPlayerIsDead, prefix, col1, col2 )
	if not Echap.chatLog then
		Echap.buildBox()
	end
		
    if Echap.Settings.timeStamps then
        Echap.chatLog:InsertColorChange( 130, 130, 130, 255 )
        Echap.chatLog:AppendText( "["..os.date("%X").."] ")
    end

    if player:IsPlayer() then
        if Echap.Settings.ChatTags and Echap.Settings.Tags[player:GetUserGroup()] then
            local col = Echap.Settings.Tags[player:GetUserGroup()].color
            Echap.chatLog:InsertColorChange( col.r or 255, col.g or 255, col.b or 255, col.a or 255 )
            Echap.chatLog:AppendText( "["..Echap.Settings.Tags[player:GetUserGroup()].name.."] ")
        end

        if bPlayerIsDead then
            Echap.chatLog:InsertColorChange( 200, 0, 0, 255 )
            Echap.chatLog:AppendText( Echap.GetLanguage("*DEAD*").." " )
        end

        if bTeamOnly then
            local col = GAMEMODE:GetTeamColor( player )
            Echap.chatLog:InsertColorChange( col1 and col1.r or col.r or 255, col1 and col1.g or col.g or 255, col1 and col1.b or col.b or 255, col1 and col1.a or col.a or 255 )
            Echap.chatLog:AppendText( "("..Echap.GetLanguage("TEAM")..") " )
        end

        local col = GAMEMODE:GetTeamColor( player )
        Echap.chatLog:InsertColorChange( col1 and col1.r or col.r or 255, col1 and col1.g or col.g or 255, col1 and col1.b or col.b or 255, col1 and col1.a or col.a or 255 )
        Echap.chatLog:AppendText( prefix or player:Nick() )
    else
        Echap.chatLog:InsertColorChange( 255, 255, 255, 255 )
        Echap.chatLog:AppendText( Echap.GetLanguage("CONSOLE") )
    end

    local col = col2 or 255
    Echap.chatLog:InsertColorChange( col2 and col2.r or 255, col2 and col2.g or 255, col2 and col2.b or 255, col2 and col2.a or 255 )
    Echap.chatLog:AppendText( ": "..message )
	
	Echap.chatLog:AppendText("\n")
	
    Echap.chatLog:InsertColorChange( 255, 255, 255, 255 )
    
    AlreadyShow = true
end)

hook.Remove( "ChatText", "Echap_joinleave")
hook.Add( "ChatText", "Echap_joinleave", function( index, name, text, type )
	if not Echap.chatLog then
		Echap.buildBox()
    end
    
    if type != "chat" and type != "darkrp" then
        if Echap.Settings.timeStamps then
            Echap.chatLog:InsertColorChange( 130, 130, 130, 255 )
            Echap.chatLog:AppendText( "["..os.date("%X").."] ")
        end

		Echap.chatLog:InsertColorChange( 0, 128, 255, 255 )
		Echap.chatLog:AppendText( text.."\n" )
    end
end)


if !oldchat then
    local oldchat = chat.AddText
    function chat.AddText(...)
        if not Echap.chatLog then
            Echap.buildBox()
        end
        
        if !AlreadyShow then
            if Echap.Settings.timeStamps then
                Echap.chatLog:InsertColorChange( 130, 130, 130, 255 )
                Echap.chatLog:AppendText( "["..os.date("%X").."] ")
            end
            
            local tbl = {...}
            for k, v in pairs(tbl) do
                if istable(v) then
                    Echap.chatLog:InsertColorChange( v.r or 255, v.g or 255, v.b or 255, v.a or 255 )
                elseif isstring(v) then
                    Echap.chatLog:AppendText( v )
                end
            end

            Echap.chatLog:AppendText( "\n" )
        else
            AlreadyShow = false
        end
        
        oldchat(...)
    end
end

function Echap.buildBox()

    Echap.ChatType = "general"

    Echap.frame = vgui.Create("DPanel")
	Echap.frame:SetSize(0, 0)
	Echap.frame:SetPos( 0, 0)
	Echap.frame.Paint = function( self, w, h )
	end
	
	Echap.entry = vgui.Create("DTextEntry", Echap.frame) 
	Echap.entry:SetSize( Echap.frame:GetWide() - 50, 30 )
	Echap.entry:SetTextColor( color_white )
	Echap.entry:SetFont("Echap.Chat.Text")
	Echap.entry:SetDrawBorder( false )
	Echap.entry:SetDrawBackground( false )
	Echap.entry:SetCursorColor( color_white )
	Echap.entry:SetHighlightColor( Color(52, 152, 219) )
	Echap.entry:SetPos( 45, Echap.frame:GetTall() - Echap.entry:GetTall() - 5 )
    Echap.entry.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, h, colorbg_frame)
        surface.SetDrawColor( colorline_frame )
        surface.DrawOutlinedRect( 0, 0, w , h )
		derma.SkinHook( "Paint", "TextEntry", self, w, h )
	end

    Echap.entry.OnTextChanged = function( self )
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

    Echap.entry.OnKeyCodeTyped = function( self, code )
        local ply = LocalPlayer()
		if code == KEY_ENTER then			
            if string.Trim( self:GetText() ) != "" then
                if Echap.ChatType == "team" then
                    ply:ConCommand("say_team \"" .. (self:GetText() or "") .. "\"")
                else
                    ply:ConCommand("say \"" .. self:GetText() .. "\"")
                end
            end
            
            Echap.entry:SetText("")
        end
        
        if code == KEY_TAB then
            if Echap.ChatType == "general" then
                Echap.ChatType = "team"
            else
                Echap.ChatType = "general"
            end
            timer.Simple(0.001, function() Echap.entry:RequestFocus() end)
        end
	end

	Echap.chatLog = vgui.Create("RichText", Echap.frame) 
	Echap.chatLog:SetSize( Echap.frame:GetWide() - 10, Echap.frame:GetTall() - 30 )
	Echap.chatLog:SetPos( 5, 0 )
	Echap.chatLog.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, colorbg_text )
	end
	Echap.chatLog.Think = function( self )
		self:SetSize( Echap.frame:GetWide() - 10, Echap.frame:GetTall() - Echap.entry:GetTall() - 20 )
	end
	Echap.chatLog.PerformLayout = function( self )
		self:SetFontInternal("Echap.Chat.Text")
		self:SetFGColor( color_white )
	end
	
	local text = Echap.GetLanguage("Say").." :"

	local say = vgui.Create("DLabel", Echap.frame)
	say:SetText("")
	surface.SetFont( "Echap.Chat.Text")
	local w, h = surface.GetTextSize( text )
	say:SetSize( w + 5, 30 )
	say:SetPos( 5, Echap.frame:GetTall() - Echap.entry:GetTall() - 2.5 )
	
	say.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, colorbg_text )
		draw.DrawText( text, "Echap.Chat.Text", 2, 1, color_white )
	end

	say.Think = function( self )
		local s = {}

        if Echap.ChatType == "team" then
            text = Echap.GetLanguage("Say").." ("..Echap.GetLanguage("TEAM")..") :"
        else
            text = Echap.GetLanguage("Say").." :"
        end

		if s then
			if not s.pw then s.pw = self:GetWide() + 10 end
			if not s.sw then s.sw = Echap.frame:GetWide() - self:GetWide() - 15 end
		end

		local w, h = surface.GetTextSize( text )
		self:SetSize( w + 5, 20 )
		self:SetPos( 5, Echap.frame:GetTall() - Echap.entry:GetTall() - 2.5 )

		Echap.entry:SetSize( s.sw, 30 )
		Echap.entry:SetPos( s.pw, Echap.frame:GetTall() - Echap.entry:GetTall() - 5 )
    end
end


function Echap.HideBox()
    if !Echap.frame then Echap.buildBox() return end

    Echap.frame:SetParent(vgui.GetWorldPanel())
	Echap.frame:SetSize(0,0)
	Echap.frame.Paint = function()
	end
end