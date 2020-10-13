--[[ Escape --------------------------------------------------------------------------------------

Escape made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
local colorline_frame = Color( 255, 255, 255, 100 )
local colorbg_frame = Color(0, 0, 0, 200)

local colorline_button = Color( 255, 255, 255, 100 )
local colorbg_button = Color(33, 31, 35, 200)
local color_hover = Color(0, 0, 0, 100)

local color_button_scroll = Color( 255, 255, 255, 5)
local color_scrollbar = Color( 175, 175, 175, 150 )

local color_text = Color(255,255,255,255)

local function checkerror(code)
    if code == 500 then
        print("Error while retrieving data. is cURL installed on the site and is the config correct?")
    elseif code == 404 then
        print("API not found. The files are installed on the site and is the config correct ?")
    end
end

function Echap:GetServerInfo(ip, port, callback)
    http.Fetch(Echap.Settings.URLServesTabs.."?ip="..ip.."&port="..port,
        function(body, len, headers, code)
            checkerror(code)
            callback(util.JSONToTable(body))
        end,
        function(err)
            print("Error while retrieving data : "..err)  
        end
    )
end

local PANEL = {}

function PANEL:Init()

    local ply = LocalPlayer()

    local numserver = 0

	Echap.Init = self
    Echap.Init:Dock(FILL)
    Echap.Init:DockMargin(0, 0, 0, 0)
    Echap.Init.Paint = function( obj, w, h )
        draw.SimpleText(Echap.GetLanguage("Loading").."...", "Echap.Server.Spam",w/2,h/4,color_text,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    Echap.Serverlist = vgui.Create( "DPanelList", Echap.Init )
    Echap.Serverlist:SetPos( 5, 5 )
    Echap.Serverlist:SetSize( ScrW() - Echap.Model:GetWide() + 50 , ScrH() - ScrH()/4-10 )
    Echap.Serverlist:EnableVerticalScrollbar( true )
    Echap.Serverlist:SetSpacing( 20 )
    Echap.Serverlist:DockPadding( 0, 5, 10, 0 )
    Echap.Serverlist.VBar.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_hover )
    end
    Echap.Serverlist.VBar.btnUp.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    Echap.Serverlist.VBar.btnDown.Paint = function( s, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, color_button_scroll )
    end
    Echap.Serverlist.VBar.btnGrip.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_scrollbar )
	end

    local data = false    
    timer.Create( "Echap.NoSpam", 1.5, 1, function() 
        for k, v in pairs(Echap.Settings.Server) do
            if not v.Enabled then continue end 
            Echap:GetServerInfo(v.IP, v.Port, function(data)
                
                if !IsValid(Echap.Serverlist) then return end
                if not data then return end
                if data.players == nil or data.maxplayers == nil then return end
                if v.Map and data.map == nil then return end

                Echap.Server = vgui.Create("DPanel")
                Echap.Server:SetSize(10, v.Map and 220 or 200)
                Echap.Server:SetPos(0,0)
                Echap.Server.Paint = function(self,w,h)
                    draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), colorbg_frame)
                    surface.SetDrawColor( colorline_frame )
                    surface.DrawOutlinedRect( 0, 0, w , h )
                    
                    draw.SimpleText(v.Name,"Echap.Server.Name",w/2,5,color_text,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
                    draw.SimpleText(Echap.GetLanguage("Players").." : "..data.players.."/"..data.maxplayers,"Echap.Server.Text",8,50,color_text,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)

                    if v.Map then
                        draw.SimpleText(Echap.GetLanguage("Map").." : "..data.map,"Echap.Server.Text",8,70,color_text,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
                    end
                end

                Echap.Server_Desc = vgui.Create("RichText", Echap.Server)
                Echap.Server_Desc:SetPos(5, v.Map and 90 or 70)
                Echap.Server_Desc:AppendText(v.Desc)
                Echap.Server_Desc:SetSize(Echap.Serverlist:GetWide() - 20, 70)
                Echap.Server_Desc:SizeToContentsY()
                function Echap.Server_Desc:PerformLayout()
                    self:SetFontInternal( "Echap.Server.Text" )
                    self:SetFGColor( color_text )
                    self:SetVerticalScrollbarEnabled(true)
                end

                Echap.Connect = vgui.Create("DButton", Echap.Server)
                Echap.Connect:SetSize(Echap.Serverlist:GetWide(),50)
                Echap.Connect:SetPos(0, v.Map and 170 or 150)
                Echap.Connect:SetText(Echap.GetLanguage("Join"))
                Echap.Connect:SetTextColor(color_text)
                Echap.Connect:SetFont("Echap.Server.Text")
                Echap.Connect.DoClick = function()
                    ply:ConCommand("connect "..v.IP..":"..v.Port)
                end
                Echap.Connect.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, colorbg_button)
                    surface.SetDrawColor( colorline_button )
                    surface.DrawOutlinedRect( 0, 0, w, h )

                    if self:IsHovered() or self:IsDown() then
                        draw.RoundedBox( 0, 0, 0, w, h, color_hover )
                    end
                end
                Echap.Serverlist:AddItem( Echap.Server )

                Echap.Server:SizeToContentsY()
                numserver = numserver + 1
            end)
        end
        if !IsValid(Echap.Init) then return end
        Echap.Init.Paint = function( obj, w, h )
            if numserver == 0 then
                draw.SimpleText(Echap.GetLanguage("No server found"), "Echap.Server.Spam",w/2,h/4,color_text,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
            end
        end
    end)  
end
vgui.Register("Echap_Tab_Servers", PANEL, "DPanel")
