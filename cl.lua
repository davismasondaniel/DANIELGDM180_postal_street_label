-- optimizations
local ipairs = ipairs
local pairs = pairs
local format = string.format
local Wait = Wait
local abs = math.abs
local max = math.max
-- end optimizations

---@class PostalData : table<number, vec>
---@field code string
---@type table<number, PostalData>
postals = nil

CreateThread(function()
    postals = LoadResourceFile(GetCurrentResourceName(), config.postalFile)
    postals = json.decode(postals)
    for i, postal in ipairs(postals) do postals[i] = { vec(postal.x, postal.y), code = postal.code } end
end)

---@class NearestResult
---@field code string
---@field dist number
nearest = nil

---@class PostalBlip
---@field 1 vec
---@field p PostalData
---@field hndl number
pBlip = nil

exports('getPostal', function() return nearest and nearest.code or nil end)
exports('getDistance', function() return nearest and nearest.dist or nil end)
exports('getNearest', function() return nearest end)

-- ===== compass directions =====
local directions = {
    N = 360, NE = 315, E = 270, SE = 225,
    S = 180, SW = 135, W = 90, NW = 45,
}

-- ===== main HUD thread: compass, street/zone, nearest postal, all pushed to one NUI panel =====
CreateThread(function()
    -- wait for postals to load
    while postals == nil do Wait(1) end

    local delay = max(tonumber(config.updateDelay) or 300, 50)
    local deleteDist = config.blip.distToDelete
    local total = #postals
    local hudColor = format('rgb(%d,%d,%d)', config.hud.color.r, config.hud.color.g, config.hud.color.b)
    local postalFormat = config.postal.format

    while true do
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        local coords = GetEntityCoords(ped)
        local zone = GetNameOfZone(coords.x, coords.y, coords.z)

        local var1, var2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
        local streetName = GetStreetNameFromHashKey(var1)
        local crossStreet = GetStreetNameFromHashKey(var2)

        local heading = GetEntityHeading(ped)
        local dirLabel = 'N'
        for k, v in pairs(directions) do
            if abs(heading - v) < 22.5 then
                dirLabel = k
                break
            end
        end

        local zoneLabel = crossStreet ~= '' and (crossStreet .. ', ' .. GetLabelText(zone)) or GetLabelText(zone)

        -- nearest postal calculation
        local vcoords = vec(coords.x, coords.y)
        local nearestIndex, nearestD
        for i = 1, total do
            local D = #(vcoords - postals[i][1])
            if not nearestD or D < nearestD then
                nearestIndex = i
                nearestD = D
            end
        end
        local code = postals[nearestIndex].code
        nearest = { code = code, dist = nearestD }

        if pBlip and #(pBlip.p[1] - vcoords) < deleteDist then
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0 },
                args = { 'Postals', "You've reached your postal destination!" }
            })
            TriggerEvent('nearest-postal:arrivedAtPostal', pBlip.p.code)
            RemoveBlip(pBlip.hndl)
            pBlip = nil
        end

        local show = not config.hud.vehicleOnly or veh ~= 0

        SendNUIMessage({
            type = 'update',
            active = show,
            posX = config.hud.posX,
            posY = config.hud.posY,
            color = hudColor,
            direction = dirLabel,
            street = streetName,
            zone = zoneLabel,
            postal = format(postalFormat, code),
        })

        Wait(delay)
    end
end)

-- ===== hide/show the whole panel while the pause menu is open =====
local uiHidden = false
CreateThread(function()
    while true do
        Wait(250)
        local pauseOpen = IsPauseMenuActive()
        if pauseOpen and not uiHidden then
            uiHidden = true
            SendNUIMessage({ action = 'hideUI' })
        elseif not pauseOpen and uiHidden then
            uiHidden = false
            SendNUIMessage({ action = 'showUI' })
        end
    end
end)
