--[[ HUD Identity  --------------------------------------------------------------------------------------

HUD Identity made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

function HUD.DrawRect(x, y, w, h)
    draw.RoundedBox(0, x, y, w, h, Color(52, 55, 64, 200))

    surface.SetDrawColor( Color( 255, 255, 255, 200 ) )
    surface.DrawOutlinedRect( x, y, w, h )
end

function HUD.DrawBarInfo(x, y, w, h, v, ply)

    HUD.DrawRect(x, y, w, h)

    if isnumber(v.value(ply)) and v.animspeed then
        v.fraction = v.newvalue != v.value(ply) and math.Clamp( (v.fraction or 0) + FrameTime()*v.animspeed, 0, 1) or 0
        v.newvalue = v.newvalue or v.value(ply)
        v.newvalue = math.Round(Lerp(v.fraction, v.newvalue, v.value(ply)))            
    end

    if v.bar then
        local value = math.Clamp(v.newvalue, v.min or 0, v.max(ply) or 100)
        draw.RoundedBox(0, x + 1 , y + 1,  w*value/(v.max(ply) or 100) - 2, h - 2, v.bar_color)
    end

    surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
    surface.SetMaterial(v.icon)
    surface.DrawTexturedRect( x + 5, y + h/2 - 32/2, 32, 32 )

    draw.SimpleText(v.text.." "..(v.drawinfo and v.drawinfo(v.newvalue) or v.newvalue and math.Round(v.newvalue) or v.value(ply)) , "HUD.Identity.LocalHUD.Text", x + 45, y + h/2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

end

function HUD.DrawIconInfo(x, y, w, h, icon)

    HUD.DrawRect(x, y, w, h)

    surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
    surface.SetMaterial(icon)
    surface.DrawTexturedRect( x + 5, y + h/2 - (w-10)/2, w-10, w-10 )

end

local function charWrap(text, remainingWidth, maxWidth)
    local totalWidth = 0

    text = text:gsub(".", function(char)
        totalWidth = totalWidth + surface.GetTextSize(char)

        -- Wrap around when the max width is reached
        if totalWidth >= remainingWidth then
            -- totalWidth needs to include the character width because it's inserted in a new line
            totalWidth = surface.GetTextSize(char)
            remainingWidth = maxWidth
            return "\n" .. char
        end

        return char
    end)

    return text, totalWidth
end

function HUD.textWrap(text, font, maxWidth)
    local totalWidth = 0

    surface.SetFont(font)

    local spaceWidth = surface.GetTextSize(' ')
    text = text:gsub("(%s?[%S]+)", function(word)
            local char = string.sub(word, 1, 1)
            if char == "\n" or char == "\t" then
                totalWidth = 0
            end

            local wordlen = surface.GetTextSize(word)
            totalWidth = totalWidth + wordlen

            -- Wrap around when the max width is reached
            if wordlen >= maxWidth then -- Split the word if the word is too big
                local splitWord, splitPoint = charWrap(word, maxWidth - (totalWidth - wordlen), maxWidth)
                totalWidth = splitPoint
                return splitWord
            elseif totalWidth < maxWidth then
                return word
            end

            -- Split before the word
            if char == ' ' then
                totalWidth = wordlen - spaceWidth
                return '\n' .. string.sub(word, 2)
            end

            totalWidth = wordlen
            return '\n' .. word
        end)

    return text
end