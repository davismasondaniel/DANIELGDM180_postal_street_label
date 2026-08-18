-- server-side postal lookup from a vec3/vec2 coord

local postals = nil
CreateThread(function()
    postals = LoadResourceFile(GetCurrentResourceName(), config.postalFile)
    postals = json.decode(postals)
    for i, postal in ipairs(postals) do
        postals[i] = { vec(postal.x, postal.y), code = postal.code }
    end
end)

local function getPostalServer(coords)
    while postals == nil do
        Wait(1)
    end
    local total = #postals
    local nearestIndex, nearestD
    coords = vec(coords[1], coords[2])

    for i = 1, total do
        local D = #(coords - postals[i][1])
        if not nearestD or D < nearestD then
            nearestIndex = i
            nearestD = D
        end
    end
    local code = postals[nearestIndex].code
    return { code = code, dist = nearestD }
end

exports('getPostalServer', function(coords)
    return getPostalServer(coords)
end)
