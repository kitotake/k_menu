fx_version 'cerulean'
game 'gta5'

author 'Kitotake'
description 'Librairie de menu pour FiveM'
version '1.1.0'

-- Charger les fichiers NUI (React + TypeScript)
ui_page 'nui/dist/index.html'

files {
    'nui/dist/index.html',
    'nui/dist/assets/**/*'
}

-- ✅ Ordre de chargement des scripts
client_scripts {
    'src/components/utils.lua',     -- Charger Utils en premier
    'src/components/button.lua',         -- Charger tous les composants
    'src/components/input.lua',         
    'src/components/title.lua',         
    'src/menu/manager.lua',         -- Charger le gestionnaire de menu
    'src/menu/init.lua',              
           
    'src/menu/menu.lua',              
    'src/menu/submenu.lua',              
    'src/nui/nui_bridge.lua',               -- Charger les fichiers nui_bridge
    'client/client.lua'             -- Charger le point d'entrée principal en dernier
}

server_scripts {
    'server/server.lua'             -- Ajoute un fichier serveur pour gérer les événements réseau
}

-- ✅ Exporte les fonctions pour qu'elles soient accessibles aux autres scripts
exports {
    'CreateMenu',
    'AddOption',
    'SetMenuVisible',
    'AddSeparator',
    'CreateSubMenu',
    'CloseAllMenus',
    'CreateQuickMenu',
    'GetModule',
    'Notify'
}