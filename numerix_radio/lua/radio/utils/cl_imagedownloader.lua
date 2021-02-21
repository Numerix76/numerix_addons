--[[ Radio --------------------------------------------------------------------------------------

Radio made by Numerix (https://steamcommunity.com/id/numerix/)

--------------------------------------------------------------------------------------------------]]

local directory = "numerix_images/radio"

function Radio.GetImage(url, filename, callback)
    local destination = string.Explode("/", filename, true)
    local filename = destination[#destination]
    local finaldirectory = directory
    
    for k, v in pairs(destination) do
        if k != #destination then 
            finaldirectory = finaldirectory.."/"..v
        end
    end
    file.CreateDir(finaldirectory)

    http.Fetch(url, 
        function(data)
            file.Write(finaldirectory.."/"..filename, data)

            if callback then
                callback(url, "data/"..finaldirectory.."/"..filename)
            end
        end
    )
end