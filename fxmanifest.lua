fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'k_menu'
author 'Kitotake'
description 'Librairie de menu pour FiveM'
version '2.1'

ui_page 'web/dist/index.html'

files {
    'web/dist/**/*.*'
}

client_scripts {
    'client/main.lua',
    'client/admin.lua',
    'client/admin_effects.lua',
    'client/noclip.lua'
}

server_scripts {
    'server/main.lua',
    'server/admin.lua'
}
