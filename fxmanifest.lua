fx_version 'cerulean'
game 'gta5'

author 'Kitotake'
description 'Librairie de menu pour FiveM'
version '1.0.0'

-- Charger les fichiers NUI (React + TypeScript)
ui_page 'nui/dist/index.html'

files {
    'nui/dist/index.html',
    'nui/dist/assets/**/*'
}

-- ✅ Charger le code client et serveur
client_scripts {
    'client/client.lua',      -- Gère les commandes et la logique client
    'src/components/*.lua', -- Charge les composants réutilisables
    'src/menu/*.lua'      -- Charge les fichiers du module menus
}

server_scripts {
    'server/server.lua'  -- Ajoute un fichier serveur pour gérer les événements réseau
}

-- ✅ Exporte les fonctions du menu pour qu'elles soient accessibles aux autres scripts
exports {
    'CreateMenu',
    'AddOption',
    'SetMenuVisible'
}
