lib.callback.register('toolbox_crafting:getInventory', function(source)

    local inventory = {}

    local items = exports.ox_inventory:GetInventoryItems(source)

    for _, item in pairs(items) do
        inventory[item.name] = item.count
    end

    return inventory
end)

RegisterNetEvent('toolbox_crafting:craft', function(recipeId, craftAmount)

    local src = source

    local recipe = Recipes[recipeId]

    if not recipe then
        return
    end

    craftAmount = tonumber(craftAmount) or 1

    if craftAmount < 1 then
        craftAmount = 1
    end

    if craftAmount > 100 then
        craftAmount = 100
    end
    
    for item, amount in pairs(recipe.ingredients) do

        local requiredAmount = amount * craftAmount

        local playerAmount = exports.ox_inventory:GetItemCount(
            src,
            item
        )

        if playerAmount < requiredAmount then

            TriggerClientEvent(
                'toolbox_crafting:notify',
                src,
                {
                    type = 'error',
                    title = 'クラフト',
                    description = '素材が足りません'
                }
            )

            return
        end
    end

    for item, amount in pairs(recipe.ingredients) do

        exports.ox_inventory:RemoveItem(
            src,
            item,
            amount * craftAmount
        )
    end

    exports.ox_inventory:AddItem(
        src,
        recipe.item,
        recipe.amount * craftAmount
    )

    TriggerClientEvent(
        'toolbox_crafting:notify',
        src,
        {
            type = 'success',
            title = 'クラフト',
            description = string.format(
                '%s x%s を作成しました',
                recipe.label,
                craftAmount
            )
        }
    )

    TriggerClientEvent(
        'toolbox_crafting:updateInventory',
        src
    )
end)