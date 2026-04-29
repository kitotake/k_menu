-- client/main.lua

local isMenuOpen = false
local menuStack = {}

-- =========================
-- 🔹 SEND MENU TO NUI
-- =========================
local function sendMenu(menu)
    SendNUIMessage({
        action = "openMenu",
        menuId = menu.menuId or menu.id,
        title = menu.title,
        subtitle = menu.subtitle,
        banner = menu.banner,
        items = menu.items,
        visible = true
    })
end

-- =========================
-- 🔹 OPEN MENU
-- =========================
local function openMenu(menu)
    print("^3[k_menu] openMenu")

    if not menu then
        print("^1[k_menu] menu nil")
        return
    end

    isMenuOpen = true

    table.insert(menuStack, menu)

    print("^2[k_menu] stack size:", #menuStack)
    print("^2[k_menu] open:", menu.menuId or menu.id)

    sendMenu(menu)

    SetNuiFocus(true, true)
end

-- =========================
-- 🔹 CLOSE MENU
-- =========================
local function closeMenu()
    print("^3[k_menu] closeMenu")

    isMenuOpen = false
    menuStack = {}

    SendNUIMessage({
        action = "closeMenu",
        visible = false
    })

    SetNuiFocus(false, false)
end

-- =========================
-- 🔹 GO BACK (SUBMENU FIX CORE)
-- =========================
local function goBack()
    print("^3[k_menu] goBack")

    if #menuStack <= 1 then
        closeMenu()
        return
    end

    table.remove(menuStack)

    local menu = menuStack[#menuStack]

    print("^2[k_menu] back to:", menu.menuId or menu.id)

    sendMenu(menu)
end

-- =========================
-- 🔹 MAIN MENU
-- =========================
local function openMainMenu()
    openMenu({
        menuId = "demo_main",
        title = "K_MENU DEMO",
        subtitle = "Navigation FiveM",
        items = {
            { id = "s1", type = "title", label = "Actions" },

            { id = "1", type = "button", label = "Réparer véhicule", icon = "🔧" },
            { id = "2", type = "button", label = "Laver véhicule", icon = "🚿" },

            { id = "sep1", type = "separator" },

            { id = "3", type = "button", label = "Inventaire", icon = "🎒" },

            { id = "4", type = "input", label = "Montant", icon = "💰", inputType = "number" },

            { id = "sep2", type = "separator" },

            -- 🔥 SUBMENU TRIGGER PROPRE
            { id = "5", type = "submenu", label = "Plus d'options", icon = "⚙️" },

            { id = "6", type = "button", label = "Action dangereuse", icon = "⚠️", color = "danger" }
        }
    })
end

-- =========================
-- 🔹 SUBMENU
-- =========================
local function openSubMenu()
    print("^3[k_menu] openSubMenu")

    openMenu({
        menuId = "sub_options",
        title = "OPTIONS",
        subtitle = "Sous-menu",
        items = {
            { id = "so1", type = "button", label = "Option A", color = "success" },
            { id = "so2", type = "button", label = "Option B", color = "warning" },

            -- 🔥 IMPORTANT RETURN
            { id = "so3", type = "button", label = "← Retour" }
        }
    })
end

-- =========================
-- 🔹 COMMAND
-- =========================
RegisterCommand('menu', function()
    print("^5[k_menu] /menu")

    if isMenuOpen then
        closeMenu()
        return
    end

    openMainMenu()
end, false)

RegisterKeyMapping('menu', 'Ouvrir Menu', 'keyboard', 'F9')

-- =========================
-- 🔹 CLOSE CALLBACK
-- =========================
RegisterNUICallback('closeMenu', function(_, cb)
    print("^5[k_menu] NUI close")

    closeMenu()

    cb({})
end)

-- =========================
-- 🔹 ACTION CALLBACK
-- =========================
RegisterNUICallback('action', function(data, cb)
    print("^5[k_menu] action:", json.encode(data or {}))

    if not data or not data.id then
        cb({})
        return
    end

    local id = data.id

    if id == "1" then
        print("^2Réparer véhicule")

    elseif id == "2" then
        print("^2Laver véhicule")

    elseif id == "3" then
        print("^2Inventaire")

    elseif id == "4" then
        print("^2Montant:", data.value)

    elseif id == "5" then
        print("^2SUBMENU OPEN")
        openSubMenu()

    elseif id == "so3" then
        print("^2BACK")
        goBack()
    end

    cb({})
end)

-- =========================
-- 🔹 EVENTS
-- =========================
RegisterNetEvent('k_menu:open', function(menu)
    openMenu(menu)
end)

RegisterNetEvent('k_menu:close', function()
    closeMenu()
end)

print("^2[k_menu] Client READY (SUBMENU FIXED)")