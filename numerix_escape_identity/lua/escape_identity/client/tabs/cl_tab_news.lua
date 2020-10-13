--[[ Escape --------------------------------------------------------------------------------------

Escape made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]
local colorline_frame = Color( 255, 255, 255, 100 )
local colorbg_frame = Color(0, 0, 0, 200)

local color_text = Color(255,255,255,255)
local color_title = Color(255,255,255,200)

local PANEL = {}

function PANEL:Init()

    Echap.Init = self
    Echap.Init:Dock(FILL)
    Echap.Init:DockMargin(0, 0, 0, 0)
    Echap.Init.Paint = function( self, w, h )
    end

    if Echap.Settings.UseUpdateNotify then
        if UpdateNotify.ActiveUpdate then
            Echap.News_Title = vgui.Create( "DPanel",Echap.Init )
            Echap.News_Title:SetSize( ScrW() - Echap.Model:GetWide() +100, ScrH() - ScrH()/4-10 )
            Echap.News_Title:SetPos(0 ,0)
            Echap.News_Title.Paint = function( self, w, h )
                draw.RoundedBox(0, 0, 0, w, h, colorbg_frame)
                surface.SetDrawColor( colorline_frame )
                surface.DrawOutlinedRect( 0, 0, w , h )
                surface.DrawOutlinedRect( 0, 40, w, 1 )
                    
                local gettime = os.time()
                local date = UpdateNotify.ActiveUpdate.date or os.date("%d/%m/%Y",gettime)
                draw.SimpleText(UpdateNotify.ActiveUpdate.name.." ("..date..")","Echap.News.Title",10,10,color_title,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
            end

            if UpdateNotify.ActiveUpdate.formatting then 
                Echap.News_Content = vgui.Create("DHTML", Echap.News_Title)
                Echap.News_Content:SetPos(10, 45)
                Echap.News_Content:SetSize(ScrW() - Echap.Model:GetWide() + 88, Echap.News_Title:GetTall() - 50)
                local htmlPreset
                if center then
                    htmlPreset = "<div style='color: white; font-family: Calibri; word-wrap:break-word; text-align: center;'>"
                else
                    htmlPreset = "<div style='color: white; font-family: Calibri; word-wrap:break-word;'>"
                end
                Echap.News_Content:SetHTML( htmlPreset..UpdateNotify.ActiveUpdate.content.."</div>" )
            else
                local text = string.Replace(UpdateNotify.ActiveUpdate.content, [[

                ]], "\n")
                text = string.Replace(text, "\\n", "\n")
                Echap.News_Content = vgui.Create("RichText", Echap.News_Title)
                Echap.News_Content:SetPos(10, 45)
                Echap.News_Content:SetSize(ScrW() - Echap.Model:GetWide() + 90, Echap.News_Title:GetTall()-50)
                function Echap.News_Content:PerformLayout()
                    self:SetFontInternal( "Echap.News.Text" )
                    self:SetFGColor( color_text )
                    self:SetVerticalScrollbarEnabled(true)
                end

                Echap.News_Content:AppendText(text)
            end
        else
            Echap.Init.Paint = function( self, w, h )
                draw.SimpleText(Echap.GetLanguage("No news available"), "Echap.News.Nothing",w/2,h/4,color_text,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
            end
        end
    elseif Echap.Settings.News.content != "" then
        Echap.News_Title = vgui.Create( "DPanel",Echap.Init )
        Echap.News_Title:SetSize( ScrW() - Echap.Model:GetWide() +100, ScrH() - ScrH()/4-10 )
        Echap.News_Title:SetPos(0 ,0)
        Echap.News_Title.Paint = function( self, w, h )
            draw.RoundedBox(0, 0, 0, w, h, colorbg_frame)
            surface.SetDrawColor( colorline_frame )
            surface.DrawOutlinedRect( 0, 0, w , h )
            surface.DrawOutlinedRect( 0, 40, w, 1 )
                    
            local date = Echap.Settings.News.date
            local name = Echap.Settings.News.name
            draw.SimpleText(name.." ("..date..")","Echap.News.Title",10,10,color_title,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
        end

        Echap.News_Content = vgui.Create("RichText", Echap.News_Title)
        Echap.News_Content:SetPos(10, 45)
        Echap.News_Content:SetSize(ScrW() - Echap.Model:GetWide() + 90, Echap.News_Title:GetTall()-50)
        function Echap.News_Content:PerformLayout()
            self:SetFontInternal( "Echap.News.Text" )
            self:SetFGColor( color_text )
            self:SetVerticalScrollbarEnabled(true)
         end
        Echap.News_Content:AppendText(Echap.Settings.News.content)
    else
        Echap.Init.Paint = function( self, w, h )
            draw.SimpleText(Echap.GetLanguage("No news available"), "Echap.News.Nothing",w/2,h/4,color_text,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) 
        end
    end
end
vgui.Register("Echap_Tab_News", PANEL, "DPanel")