fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'k_menu'
author 'Kitotake'
description 'Librairie de menu pour FiveM'
version '2.0'

ui_page 'web/dist/index.html'

files {
    'web/dist/**/*.*'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}