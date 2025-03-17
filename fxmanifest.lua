fx_version 'cerulean'
game 'gta5'

author 'kitotake'

-- Fichiers à charger pour la NUI
ui_page 'nui/dist/index.html'

files {
    'nui/dist/index.html', -- On charge les fichiers compilés
    'nui/dist/assets/**/*'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua'
}
