 

function createMainMenu()
    local menu = KMenu.createMenu("main", "Menu Principal", "Choisissez une option")
    KMenu.addOption(menu, "Option 1", function() print("Option 1 sélectionnée") end)
    KMenu.setVisible(menu, true)
end

RegisterCommand("openmenu", function()
    createMainMenu()
end, false)
