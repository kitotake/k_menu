-- client/main.lua

local isMenuOpen = false

-- Fonction pour ouvrir/fermer le menu
local function toggleMenu()
    isMenuOpen = not isMenuOpen
    
    SendNUIMessage({
        action = "toggleMenu",
        data = {
            visible = isMenuOpen,
            -- Tu peux envoyer ici des données du joueur si besoin
            playerName = GetPlayerName(PlayerId()),
            playerId = GetPlayerServerId(PlayerId())
        }
    })

    SetNuiFocus(isMenuOpen, isMenuOpen)
end

-- Commande pour ouvrir le menu (ex: /menu)
RegisterCommand('menu', function()
    toggleMenu()
end, false)

-- Touche par défaut (F9 par exemple)
RegisterKeyMapping('menu', 'Ouvrir le Menu', 'keyboard', 'F9')

-- Écoute des messages venant du NUI (React)
RegisterNUICallback('closeMenu', function(data, cb)
    isMenuOpen = false
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('action', function(data, cb)
    -- Exemple : actions envoyées depuis React
    if data.type == "example" then
        print("^2[Menu] Action reçue du NUI:", json.encode(data))
        -- Tu peux déclencher des events ici (TriggerEvent, TriggerServerEvent, etc.)
    end
    
    cb('ok')
end)

-- Event pour ouvrir le menu depuis un autre script
RegisterNetEvent('k_menu:open', function()
    if not isMenuOpen then
        toggleMenu()
    end
end)

print("^2[k_menu] Client chargé avec succès")