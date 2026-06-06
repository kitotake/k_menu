fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name        'k_menu'
author      'Kitotake'
description 'Menu admin NUI pour FiveM — V3'
version     '3.1.0'

dependencies {
    'kt_lib',
    'kt_inventory',
    'oxmysql',
}

ui_page 'web/dist/index.html'

files {
    'web/dist/**/*.*'
}

shared_scripts {
    '@kt_lib/init.lua',
    'shared/config.lua',
}

client_scripts {
    'client/core.lua',
    'client/admin.lua',
    'client/noclip.lua',
    'client/effects.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/core.lua',
    'server/admin.lua',
}