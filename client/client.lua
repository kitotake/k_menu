-- k_lib Client - Gestion des menus avancés

local Menu = {}
local activeMenu = nil

-- Fonction pour créer un menu
function Menu.createMenu(id, title, subtitle, options)
    return {
        id = id,
        title = title,
        subtitle = subtitle,
        options = options or {},
        parent = nil
    }
end

-- Création des menus
local mainMenu = Menu.createMenu("main", "Menu Principal", "Choisissez une option", {
    { label = "Ouvrir le Sous-Menu", value = "submenu" },
    { label = "Option 2", value = "opt2" }
})

local subMenu = Menu.createMenu("submenu", "Sous-Menu", "Options avancées", {
    { label = "Retour", value = "back" },
    { label = "Option 2 du Sous-Menu", value = "subopt2" }
})
subMenu.parent = mainMenu

-- Fonction pour ouvrir un menu
local function openMenu(menu)
    activeMenu = menu
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openTestMenu",
        menuData = menu
    })
end

-- Commande pour ouvrir le menu principal
RegisterCommand("testmenu2", function()
    openMenu(mainMenu)
end, false)

-- Gestion de la fermeture du menu
RegisterNUICallback("closeMenu", function(_, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeUI" })
    activeMenu = nil
    cb("ok")
end)

-- Gestion de la sélection des options
RegisterNUICallback("menuOptionSelected", function(data, cb)
    if activeMenu then
        if data.value == "back" and activeMenu.parent then
            openMenu(activeMenu.parent)
        elseif data.value == "submenu" then
            openMenu(subMenu)
        else
            print("Option sélectionnée: " .. data.value)
        end
    end
    cb("ok")
end)