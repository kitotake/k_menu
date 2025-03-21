RegisterCommand("testmenu", function()
    SetNuiFocus(true, true) -- Active la souris et le focus sur la NUI
    SendNUIMessage({
        action = "openTestMenu", -- Action envoyée à React
        menuData = {
            title = "Menu de Test",
            subtitle = "Choisissez une option",
            options = {
                { label = "Option 1", value = "opt1" },
                { label = "Option 2", value = "opt2" },
                
            }
        }
    })
end, false)

RegisterNUICallback("closeMenu", function(_, cb)
    SetNuiFocus(false, false) -- ✅ Désactive l'interaction avec la NUI
    SendNUIMessage({ action = "closeUI" }) -- ✅ Envoie un message à React pour cacher l'UI
    cb("ok")
end)
