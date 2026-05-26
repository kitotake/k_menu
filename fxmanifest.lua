fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name        'k_menu'
author      'Kitotake'
description 'Menu NUI minimaliste pour FiveM'
version     '3.0.0'

ui_page 'web/dist/index.html'

files {
    'web/dist/**/*.*'
}

shared_scripts {
    'shared/config.lua'
}

client_scripts {
    'client/core.lua',
    'client/admin.lua',
    'client/noclip.lua',
    'client/effects.lua'
}

server_scripts {
    'server/core.lua',
    'server/admin.lua'
}
