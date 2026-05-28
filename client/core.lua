-- client/core.lua
-- Moteur principal du menu côté client

local Menu = {}
Menu._stack  = {}
Menu._open   = false
Menu._inputs = {}

-- ─────────────────────────────────────────────────────────────────────────────
-- Helpers
-- ─────────────────────────────────────────────────────────────────────────────

local function dbg(...)
    if Config.Debug then print("^3[k_menu]^7", ...) end
end

local function sendNUI(data)
    SendNUIMessage(data)
end

local function focus(state)
    SetNuiFocus(state, state)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- API publique
-- ─────────────────────────────────────────────────────────────────────────────

function Menu.open(menu)
    if not menu or not menu.id then return end
    Menu._open = true
    table.insert(Menu._stack, menu)
    sendNUI({
        action   = "open",
        id       = menu.id,
        title    = menu.title,
        subtitle = menu.subtitle or "",
        items    = menu.items or {},
    })
    focus(true)
    dbg("open →", menu.id)
end

function Menu.close()
    Menu._open   = false
    Menu._stack  = {}
    Menu._inputs = {}
    sendNUI({ action = "close" })
    focus(false)
    dbg("close")
end

function Menu.back()
    if #Menu._stack <= 1 then
        Menu.close()
        return
    end
    table.remove(Menu._stack)
    local prev = Menu._stack[#Menu._stack]
    sendNUI({
        action   = "open",
        id       = prev.id,
        title    = prev.title,
        subtitle = prev.subtitle or "",
        items    = prev.items or {},
    })
    dbg("back →", prev.id)
end

function Menu.input(id)
    return Menu._inputs[id]
end

function Menu.isOpen()
    return Menu._open
end

_G.K = Menu

-- ─────────────────────────────────────────────────────────────────────────────
-- NUI Callbacks
-- ─────────────────────────────────────────────────────────────────────────────

RegisterNUICallback('close', function(_, cb)
    Menu.close()
    cb({})
end)

RegisterNUICallback('back', function(_, cb)
    Menu.back()
    cb({})
end)

RegisterNUICallback('button', function(data, cb)
    dbg("button →", data.id)
    -- FIX #6 : TriggerEvent (local) → AddEventHandler dans admin.lua
    TriggerEvent('k_menu:button', data.id, data.menuId)
    cb({})
end)

RegisterNUICallback('submenu', function(data, cb)
    dbg("submenu →", data.submenuId)
    -- FIX #6 : TriggerEvent (local) → AddEventHandler dans admin.lua
    TriggerEvent('k_menu:submenu', data.submenuId, data.menuId)
    cb({})
end)

RegisterNUICallback('input', function(data, cb)
    if data.id then
        Menu._inputs[data.id] = data.value
    end
    dbg("input →", data.id, "=", data.value)
    cb({})
end)

RegisterNUICallback('toggle', function(data, cb)
    if data.id then
        Menu._inputs[data.id] = data.value
        -- FIX #6 : TriggerEvent (local)
        TriggerEvent('k_menu:toggle', data.id, data.value, data.menuId)
    end
    cb({})
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Commande de démonstration
-- ─────────────────────────────────────────────────────────────────────────────

RegisterCommand('menu', function()
    if Menu.isOpen() then
        Menu.close()
        return
    end
    Menu.open({
        id       = "demo",
        title    = "K_MENU",
        subtitle = "Démo",
        items    = {
            { id = "sep1", type = "separator", label = "Véhicule" },
            { id = "b1",   type = "button",    label = "Réparer",   color = "success" },
            { id = "b2",   type = "button",    label = "Supprimer", color = "danger" },
            { id = "sep2", type = "separator", label = "Joueur" },
            { id = "i1",   type = "input",     label = "Montant",   placeholder = "0", inputType = "number" },
            { id = "t1",   type = "toggle",    label = "God Mode",  value = false },
            { id = "sep3", type = "separator" },
            { id = "s1",   type = "submenu",   label = "Plus",      submenuId = "demo_sub" },
        }
    })
end, false)

RegisterKeyMapping('menu', 'Ouvrir le menu', 'keyboard', Config.MenuKey)

-- FIX #6 : AddEventHandler (local) au lieu de RegisterNetEvent
AddEventHandler('k_menu:submenu', function(submenuId, _menuId)
    if submenuId == "demo_sub" then
        Menu.open({
            id    = "demo_sub",
            title = "OPTIONS",
            items = {
                { id = "so1", type = "button", label = "Option A", color = "success" },
                { id = "so2", type = "button", label = "Option B" },
            }
        })
    end
end)

RegisterNetEvent('k_menu:openFromServer', function(menu)
    Menu.open(menu)
end)

print("^2[k_menu] Core chargé^7")
