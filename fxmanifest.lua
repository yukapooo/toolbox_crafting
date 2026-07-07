fx_version 'cerulean'
game 'gta5'
author 'Yukapo Original'
description 'QBox craft toolbox'
version '1.0.2'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/recipes.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

dependencies {
    'ox_lib',
    'ox_inventory',
    'qbx_core'
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/app.js'
}