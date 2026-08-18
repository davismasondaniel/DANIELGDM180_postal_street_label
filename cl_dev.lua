local insert = table.insert
local remove = table.remove

--- [[ Development tools for building the postal json ]]

local devLocal = {}
local next = 0

RegisterCommand('setnext', function(_, args)
    local n = tonumber(args[1])
    if n ~= nil then
        next = n
        print('next ' .. next)
        return
    end
    print('invalid ' .. tostring(n))
end)

RegisterCommand('nextpostal', function()
    for _, d in ipairs(devLocal) do
        if d.code == tostring(next) then
            print('duplicate ' .. next)
            return
        end
    end
    local coords = GetEntityCoords(PlayerPedId())
    insert(devLocal, { code = tostring(next), x = coords.x, y = coords.y })
    print('insert ' .. next)
    next = next + 1
end)

RegisterCommand('rlpostal', function()
    if #devLocal > 0 then
        local data = remove(devLocal, #devLocal)
        print('remove ' .. data.code)
        print('next ' .. next)
        next = next - 1
    else
        print('invalid')
    end
end)

RegisterCommand('removepostal', function(_, args)
    if #args < 1 then
        print('invalid')
    else
        for i, d in ipairs(devLocal) do
            if d.code == args[1] then
                remove(devLocal, i)
                print('remove ' .. d.code)
                return
            end
        end
        print('invalid')
    end
end)

RegisterCommand('jsonpostal', function()
    print(json.encode(devLocal))
end)
