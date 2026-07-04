local isOpen = false

local function OpenCrafting()
    if isOpen then return end
    local data = lib.callback.await(
        'toolbox_crafting:getInventory',
        false
    ) or {}
    local inventory = data.inventory or {}
    local labels = data.labels or {}
    isOpen = true
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({
        action = 'open',
        recipes = Recipes,
        inventory = inventory,
        labels = labels
    })
end

local function CloseCrafting()
    if not isOpen then return end
    isOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'close'
    })
end

RegisterNetEvent('toolbox_crafting:open', function()
    OpenCrafting()
end)

CreateThread(function()
    while true do
        if isOpen then
            Wait(0)
            if IsControlJustReleased(0, 322) then
                CloseCrafting()
            end
        else
            Wait(1000)
        end
    end
end)

RegisterNUICallback('close', function(_, cb)
    CloseCrafting()
    cb('ok')
end)

RegisterNUICallback('craft', function(data, cb)
    if not data or not data.recipeId then
        cb('ok')
        return
    end
    local recipeId = tonumber(data.recipeId)
    local amount = tonumber(data.amount) or 1
    CloseCrafting()
    local success = lib.progressCircle({
        duration = amount * 5000,
        position = 'bottom',
        label = ('作成中 x%s'):format(amount),
        canCancel = true,
        disable = {
            move = true,
            combat = true,
            car = true
        },
        anim = {
            dict = 'mini@repair',
            clip = 'fixing_a_player'
        }
    })
    if success then
        TriggerServerEvent(
            'toolbox_crafting:craft',
            recipeId,
            amount
        )
    end
    cb('ok')
end)

RegisterNUICallback('getRecipes', function(_, cb)
    cb(Recipes)
end)

RegisterNetEvent('toolbox_crafting:notify', function(data)
    lib.notify({
        title = data.title or 'クラフト',
        description = data.description or '',
        type = data.type or 'inform'
    })
end)

RegisterNetEvent('toolbox_crafting:refresh', function()
    if not isOpen then return end
    local inventory = lib.callback.await(
        'toolbox_crafting:getInventory',
        false
    ) or {}
    SendNUIMessage({
        action = 'refresh',
        recipes = Recipes,
        inventory = inventory
    })
end)

RegisterNetEvent('toolbox_crafting:updateInventory', function()
    if not isOpen then return end
    local inventory = lib.callback.await(
        'toolbox_crafting:getInventory',
        false
    ) or {}
    SendNUIMessage({
        action = 'inventory',
        inventory = inventory
    })
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end
    SetNuiFocus(false, false)
end)

exports('OpenCrafting', function()
    OpenCrafting()
end)

exports('CloseCrafting', function()
    CloseCrafting()
end)