

function createSubMenu()
    local submenu = KMenu.createMenu("submenu", "Sous-Menu", "Options avancées")

    KMenu.addOption(submenu, "Retour", function()
        KMenu.setVisible(submenu, false)
        KMenu.setVisible(KMenu.menus["main"], true)
    end)

    KMenu.setVisible(submenu, true)
end
