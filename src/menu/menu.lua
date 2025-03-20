


-- Exported functions to make them accessible to other resources
function CreateMenu(id, title, subtitle)
    return KMenu.createMenu(id, title, subtitle)
end

function AddOption(menu, label, callback)
    return KMenu.addOption(menu, label, callback)
end

function SetMenuVisible(menu, state)
    return KMenu.setVisible(menu, state)
end

-- Main menu creation function
function createMainMenu()
    Utils.log("Creating main menu", "green")
    
    local menu = KMenu.createMenu("main", "Menu Principal", "Choisissez une option")
    
    KMenu.addOption(menu, "Option 1", function()
        Utils.log("Option 1 sélectionnée", "blue")
    end)
    
    KMenu.addOption(menu, "Aller au sous-menu", function()
        KMenu.setVisible(KMenu.menus["main"], false)
        createSubMenu()
    end)
    
    KMenu.setVisible(menu, true)
    
    return menu
end

-- Sub-menu creation function
function createSubMenu()
    Utils.log("Creating sub-menu", "green")
    
    local submenu = KMenu.createMenu("submenu", "Sous-Menu", "Options avancées")
    
    KMenu.addOption(submenu, "Retour", function()
        KMenu.setVisible(submenu, false)
        KMenu.setVisible(KMenu.menus["main"], true)
    end)
    
    KMenu.setVisible(submenu, true)
    
    return submenu
end

-- Register commands
RegisterCommand("openmenu", function()
    createMainMenu()
end, false)

-- Register NUI callbacks
RegisterNUICallback("closeMenu", function(_, cb)
    for _, menu in pairs(KMenu.menus) do
        menu.visible = false
    end
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "toggleMenu", visible = false })
    cb("ok")
end)

-- Return the module
return {
    createMainMenu = createMainMenu,
    createSubMenu = createSubMenu
}