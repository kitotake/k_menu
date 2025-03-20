

if not Utils then
    print("^1[ERROR] Utils n'est pas encore chargé ! Assure-toi que utils.lua est exécuté avant manager.lua.^7")
    return
end


CreateThread(function()
    while not Utils do
        Citizen.Wait(0) -- Attendre jusqu'à ce que Utils soit défini
    end
end)


KMenu.menus = {} -- Store all created menus

-- Create a menu
function KMenu.createMenu(id, title, subtitle)
    if KMenu.menus[id] then
        Utils.log("Menu with ID " .. id .. " already exists. Returning existing menu.", "yellow")
        return KMenu.menus[id]
    end
    
    local menu = {
        id = id,
        title = title,
        subtitle = subtitle,
        options = {},
        visible = false,
        currentIndex = 1
    }
    
    KMenu.menus[id] = menu
    Utils.log("Created menu: " .. title, "green")
    return menu
end

-- Add an option to a menu
function KMenu.addOption(menu, label, callback)
    if not menu then
        Utils.log("Cannot add option: Menu is nil", "red")
        return
    end
    
    table.insert(menu.options, { label = label, callback = callback })
    return #menu.options
end

-- Set menu visibility
function KMenu.setVisible(menu, state)
    if not menu then
        Utils.log("Cannot set visibility: Menu is nil", "red")
        return
    end
    
    -- Hide all other menus if showing this one
    if state then
        for _, otherMenu in pairs(KMenu.menus) do
            if otherMenu.id ~= menu.id then
                otherMenu.visible = false
            end
        end
        
        -- Set NUI focus when showing a menu
        SetNuiFocus(true, true)
    end
    
    menu.visible = state
    
    -- Send visibility state to NUI
    SendNUIMessage({
        action = "toggleMenu",
        menuData = {
            id = menu.id,
            title = menu.title,
            subtitle = menu.subtitle,
            options = menu.options,
            visible = state
        }
    })
    
    -- If hiding all menus, release NUI focus
    if not state then
        local anyVisible = false
        for _, otherMenu in pairs(KMenu.menus) do
            if otherMenu.visible then
                anyVisible = true
                break
            end
        end
        
        if not anyVisible then
            SetNuiFocus(false, false)
        end
    end
    
    return state
end

-- Execute a menu option
function KMenu.executeOption(menuId, optionIndex)
    local menu = KMenu.menus[menuId]
    if not menu then 
        Utils.log("Cannot execute option: Menu not found", "red")
        return false
    end
    
    local option = menu.options[optionIndex]
    if not option then
        Utils.log("Cannot execute option: Option not found", "red")
        return false
    end
    
    if type(option.callback) == "function" then
        option.callback()
        return true
    end
    
    return false
end

-- Close all menus
function KMenu.closeAll()
    for _, menu in pairs(KMenu.menus) do
        menu.visible = false
    end
    
    SendNUIMessage({ action = "closeAllMenus" })
    SetNuiFocus(false, false)
    
    Utils.log("All menus closed", "blue")
end

return KMenu