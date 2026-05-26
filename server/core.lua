-- server/core.lua

-- Ouvrir un menu depuis le serveur
RegisterNetEvent('k_menu:openMenu', function(menu)
    local src = source
    TriggerClientEvent('k_menu:openFromServer', src, menu)
end)

print("^2[k_menu] Server core chargé^7")
