# toolbox_crafting
- アイテムによるクラフトスクリプト

# Frameworks
- [qbx_core](https://github.com/Qbox-project/qbx_core)
- [qb_core](https://github.com/qbcore-framework/qb-core)

# Dependencies
- [oxmysql](https://github.com/overextended/oxmysql)
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_inventory](https://github.com/overextended/ox_inventory)

# Installation
- 必要な依存リソース（ox_lib、ox_inventory、qbx_core など）を導入し、`toolbox_crafting` より先に起動してください。
- `toolbox_crafting` フォルダをサーバーの `resources` フォルダへ配置してください。
- `server.cfg` に追加してください
- `INSTALL`フォルダにox_inventory用コードと画像がありますので追加してください

# functions
- ox_inventory画像対応
- 数量指定クラフト
- クラフトアニメーション
- クラフト時間設定
- 所持数表示
- 最大作成可能数表示
- 検索機能

# recipes
- `shared/recipes.lua`にクラフト内容（使用素材、クラフト所要時間）の設定ができます
- アイテム追加可能
```lua
    {
        label = 'ロックピック',
        item = 'lockpick',
        amount = 1,
        craftTime = 5000,
        category = 'tools',
        ingredients = {
            iron = 1
        }
    },
```
