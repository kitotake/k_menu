-- server/main.lua

print("^2[k_menu] Server chargé avec succès")

-- Exemple : Event pour ouvrir le menu depuis le serveur
RegisterNetEvent('k_menu:openFromServer', function()
    local src = source
    TriggerClientEvent('k_menu:open', src)
end)

-- Exemple de callback serveur (si tu veux faire des actions côté serveur depuis le menu)
RegisterNetEvent('k_menu:serverAction', function(actionType, data)
    local src = source
    print("^3[Menu Server] Action reçue de "..GetPlayerName(src)..": "..actionType)

    if actionType == "heal" then
        TriggerClientEvent('kt_lib:notify', src, {
            title = 'Soins',
            description = 'Tu as été soigné',
            type = 'success'
        })
    end
end)