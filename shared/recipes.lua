-- ツールボックスの種類を追加する場合、client/main.luaのlocal currentRecipes = {}下よりの部分にコード追加
Recipes = {
    basic = {
        {
            label = 'スケートボード',
            item = 'skateboard_01',
            amount = 1,
            craftTime = 5000,
            ingredients = {
                iron = 1,
                plastic = 1
            }
        },
    },
    robbery = {
        {
            label = 'ロックピック',
            item = 'lockpick',
            amount = 1,
            craftTime = 5000,
            ingredients = {
                iron = 1
            }
        },
    },
    medical = {
        {
            label = '包帯',
            item = 'bandage',
            amount = 1,
            craftTime = 5000,
            ingredients = {
                cloth = 2
            }
        },
    }
}