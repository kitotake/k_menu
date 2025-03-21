local KMenu = {}

-- S'assurer que Utils est bien chargé
if not _G.Utils then
    print("^1[ERROR] Utils n'est pas encore chargé ! Assurez-vous que utils.lua est exécuté avant manager.lua.^7")
    return
end

KMenu.menus = {} -- Stocke tous les menus créés
KMenu.history = {} -- Stocke l'historique de navigation
KMenu.config = {
    defaultTransition = "fade", -- Options: fade, slide, none
    transitionDuration = 300,   -- Durée d'animation en ms
    enableSounds = true,        -- Activer les sons UI
    enableKeyboardNav = true,   -- Activer la navigation clavier
    maxOptionsPerPage = 10      -- Nombre max d'options par page
}

-- Créer un menu
function KMenu.createMenu(id, title, subtitle, options)
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
        currentIndex = 1,
        parent = nil,
        pagination = {
            currentPage = 1,
            totalPages = 1,
            itemsPerPage = KMenu.config.maxOptionsPerPage
        }
    }
    
    KMenu.menus[id] = menu
    
    -- Ajouter les options si elles sont fournies
    if options and type(options) == "table" then
        for _, option in ipairs(options) do
            KMenu.addOption(menu, option.label, option.callback, option)
        end
    end
    
    Utils.log("Created menu: " .. title, "green")
    return menu
end

-- Ajouter une option à un menu
function KMenu.addOption(menu, label, callback, params)
    if not menu then
        Utils.log("Cannot add option: Menu is nil", "red")
        return
    end
    
    params = params or {}
    local option = {
        label = label,
        callback = callback,
        type = params.type or "button",
        icon = params.icon,
        description = params.description,
        disabled = params.disabled or false,
        disabledReason = params.disabledReason,
        style = params.style,
        confirmText = params.confirmText,
        params = params.params
    }
    
    table.insert(menu.options, option)
    
    -- Mettre à jour la pagination
    menu.pagination.totalPages = math.ceil(#menu.options / menu.pagination.itemsPerPage)
    
    return #menu.options
end

-- Ajouter un séparateur
function KMenu.addSeparator(menu, label)
    return KMenu.addOption(menu, label or "---", nil, { type = "separator", disabled = true })
end

-- Définir la visibilité du menu
function KMenu.setVisible(menu, state)
    if not menu then
        Utils.log("Cannot set visibility: Menu is nil", "red")
        return
    end
    
    -- Cacher tous les autres menus si on affiche celui-ci
    if state then
        -- Ajouter à l'historique si c'est un nouveau menu
        if not menu.visible and not KMenu.isInHistory(menu.id) then
            table.insert(KMenu.history, menu.id)
        end
        
        for _, otherMenu in pairs(KMenu.menus) do
            if otherMenu.id ~= menu.id then
                otherMenu.visible = false
            end
        end
        
        -- Définir le focus NUI lors de l'affichage d'un menu
        SetNuiFocus(true, true)
    else
        -- Si on cache ce menu, on va vérifier s'il faut en afficher un autre de l'historique
        if menu.visible and #KMenu.history > 1 then
            -- Retirer ce menu de l'historique
            for i = #KMenu.history, 1, -1 do
                if KMenu.history[i] == menu.id then
                    table.remove(KMenu.history, i)
                    break
                end
            end
            
            -- Si on a un menu parent, l'afficher
            if menu.parent and KMenu.menus[menu.parent] then
                KMenu.menus[menu.parent].visible = true
            end
        end
    end
    
    menu.visible = state
    
    -- Envoyer l'état de visibilité à l'interface NUI
    SendNUIMessage({
        action = "toggleMenu",
        menuData = KMenu.getMenuData(menu),
        transition = KMenu.config.defaultTransition,
        duration = KMenu.config.transitionDuration
    })
    
    -- Si on cache tous les menus, relâcher le focus NUI
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

-- Obtenir les données du menu pour l'interface NUI
function KMenu.getMenuData(menu)
    if not menu then return nil end
    
    -- Calculer les options pour la page actuelle
    local startIdx = (menu.pagination.currentPage - 1) * menu.pagination.itemsPerPage + 1
    local endIdx = math.min(startIdx + menu.pagination.itemsPerPage - 1, #menu.options)
    
    local visibleOptions = {}
    for i = startIdx, endIdx do
        if menu.options[i] then
            table.insert(visibleOptions, menu.options[i])
        end
    end
    
    return {
        id = menu.id,
        title = menu.title,
        subtitle = menu.subtitle,
        options = visibleOptions,
        visible = menu.visible,
        pagination = menu.pagination,
        hasParent = menu.parent ~= nil
    }
end

-- Exécuter une option de menu
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
    
    if option.disabled then
        if option.disabledReason then
            Utils.notify(option.disabledReason, "warning")
        end
        return false
    end
    
    if type(option.callback) == "function" then
        option.callback(option.params)
        
        -- Son de clic si activé
        if KMenu.config.enableSounds then
            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
        end
        
        return true
    end
    
    return false
end

-- Fermer tous les menus
function KMenu.closeAll()
    for _, menu in pairs(KMenu.menus) do
        menu.visible = false
    end
    
    -- Vider l'historique
    KMenu.history = {}
    
    SendNUIMessage({ action = "closeAllMenus" })
    SetNuiFocus(false, false)
    
    Utils.log("All menus closed", "blue")
end

-- Vérifier si un menu est dans l'historique
function KMenu.isInHistory(menuId)
    for _, id in ipairs(KMenu.history) do
        if id == menuId then
            return true
        end
    end
    return false
end

-- Définir le menu parent
function KMenu.setParent(menu, parentId)
    if not menu then return false end
    
    menu.parent = parentId
    return true
end

-- Créer un sous-menu et le lier au parent
function KMenu.createSubMenu(parentMenu, id, title, subtitle)
    if not parentMenu then
        Utils.log("Cannot create submenu: Parent menu is nil", "red")
        return nil
    end
    
    local submenu = KMenu.createMenu(id, title, subtitle)
    submenu.parent = parentMenu.id
    
    return submenu
end

-- Passer à la page suivante
function KMenu.nextPage(menu)
    if not menu then return false end
    
    if menu.pagination.currentPage < menu.pagination.totalPages then
        menu.pagination.currentPage = menu.pagination.currentPage + 1
        
        -- Mettre à jour le menu si visible
        if menu.visible then
            SendNUIMessage({
                action = "updateMenu",
                menuData = KMenu.getMenuData(menu)
            })
        end
        
        return true
    end
    
    return false
end

-- Passer à la page précédente
function KMenu.prevPage(menu)
    if not menu then return false end
    
    if menu.pagination.currentPage > 1 then
        menu.pagination.currentPage = menu.pagination.currentPage - 1
        
        -- Mettre à jour le menu si visible
        if menu.visible then
            SendNUIMessage({
                action = "updateMenu",
                menuData = KMenu.getMenuData(menu)
            })
        end
        
        return true
    end
    
    return false
end

-- Configurer le menu
function KMenu.configure(config)
    for k, v in pairs(config) do
        if KMenu.config[k] ~= nil then
            KMenu.config[k] = v
        end
    end
end

-- Exporter KMenu globalement
_G.KMenu = KMenu

return KMenu