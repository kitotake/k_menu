-- client/admin.lua
-- Menu Admin pour k_Menu

local isAdminMenuOpen = false

-- ============================================================
-- 🔹 HELPERS
-- ============================================================
local function sendMenu(menu)
    SendNUIMessage({
        action   = "openMenu",
        menuId   = menu.menuId or menu.id,
        title    = menu.title,
        subtitle = menu.subtitle,
        banner   = menu.banner,
        items    = menu.items,
        visible  = true
    })
end

local menuStack = {}

-- FIX: adminInputs déclaré au niveau du module (scope fichier),
-- accessible par TOUS les callbacks de ce fichier.
local adminInputs = {}

local function openMenu(menu)
    if not menu then return end
    isAdminMenuOpen = true
    table.insert(menuStack, menu)
    sendMenu(menu)
    SetNuiFocus(true, true)
end

local function closeMenu()
    isAdminMenuOpen = false
    menuStack = {}
    SendNUIMessage({ action = "closeMenu", visible = false })
    SetNuiFocus(false, false)
end

local function goBack()
    if #menuStack <= 1 then
        closeMenu()
        return
    end
    table.remove(menuStack)
    sendMenu(menuStack[#menuStack])
end

-- ============================================================
-- 🔹 MENUS
-- ============================================================

local function openAdminMenu()
    openMenu({
        menuId   = "admin_main",
        title    = "ADMIN PANEL",
        subtitle = "Gestion du serveur",
        items    = {
            { id = "t1",  type = "title",     label = "Joueurs" },
            { id = "1",   type = "submenu",   label = "Gestion des joueurs", icon = "👤", submenuId = "admin_players" },
            { id = "2",   type = "submenu",   label = "Sanctions",           icon = "🔨", submenuId = "admin_sanctions" },

            { id = "sep1", type = "separator", label = "Véhicules" },
            { id = "3",   type = "submenu",   label = "Spawn véhicule",      icon = "🚗", submenuId = "admin_vehicles" },
            { id = "4",   type = "button",    label = "Supprimer les véhicules proches", icon = "🗑️", color = "warning" },
            { id = "5",   type = "button",    label = "Fixer mon véhicule",  icon = "🔧" },

            { id = "sep2", type = "separator", label = "Téléportation" },
            { id = "6",   type = "submenu",   label = "Téléportation",       icon = "📍", submenuId = "admin_teleport" },

            { id = "sep3", type = "separator", label = "Monde" },
            { id = "7",   type = "submenu",   label = "Météo / Heure",       icon = "🌤️", submenuId = "admin_world" },

            { id = "sep4", type = "separator", label = "Outils" },
            { id = "8",   type = "button",    label = "God Mode",            icon = "🛡️" },
            { id = "9",   type = "button",    label = "Invisible",           icon = "👻" },
            { id = "10",  type = "button",    label = "NoClip",              icon = "🌀" },
            { id = "11",  type = "button",    label = "Vitesse illimitée",   icon = "⚡" },

            { id = "sep5", type = "separator" },
            { id = "12",  type = "button",    label = "Fermer le menu",      icon = "✖️", color = "danger" },
        }
    })
end

local function openPlayersMenu()
    openMenu({
        menuId   = "admin_players",
        title    = "JOUEURS",
        subtitle = "Gestion des joueurs",
        items    = {
            { id = "t1",  type = "title",  label = "Actions globales" },
            { id = "p1",  type = "button", label = "Lister tous les joueurs",  icon = "📋" },
            { id = "p2",  type = "button", label = "Freeze tous les joueurs",  icon = "🧊", color = "warning" },
            { id = "p3",  type = "button", label = "Heal tous les joueurs",    icon = "💚" },

            { id = "sep1", type = "separator", label = "Joueur ciblé" },
            { id = "p4",  type = "input",  label = "ID du joueur",    icon = "🔢", placeholder = "Ex: 1", inputType = "number", min = 1 },
            { id = "p5",  type = "button", label = "Téléporter vers le joueur", icon = "📍" },
            { id = "p6",  type = "button", label = "Ramener le joueur",         icon = "🔗" },
            { id = "p7",  type = "button", label = "Spectate joueur",           icon = "👁️" },
            { id = "p8",  type = "button", label = "Heal joueur",               icon = "💊" },
            { id = "p9",  type = "button", label = "Revive joueur",             icon = "💉" },
            { id = "p10", type = "button", label = "Donner de l'argent",        icon = "💰" },

            { id = "sep2", type = "separator" },
            { id = "p99", type = "button", label = "← Retour",                 icon = "←" },
        }
    })
end

local function openSanctionsMenu()
    openMenu({
        menuId   = "admin_sanctions",
        title    = "SANCTIONS",
        subtitle = "Gestion des punitions",
        items    = {
            { id = "t1",  type = "title",  label = "Cible" },
            { id = "s0",  type = "input",  label = "ID du joueur",  icon = "🔢", placeholder = "Ex: 2", inputType = "number", min = 1 },
            { id = "s1",  type = "input",  label = "Raison",        icon = "📝", placeholder = "Motif de la sanction" },

            { id = "sep1", type = "separator", label = "Actions" },
            { id = "s2",  type = "button", label = "Kick joueur",   icon = "👢", color = "warning" },
            { id = "s3",  type = "button", label = "Ban temporaire", icon = "⏳", color = "danger" },
            { id = "s4",  type = "button", label = "Ban permanent",  icon = "🔨", color = "danger" },
            { id = "s5",  type = "button", label = "Warn joueur",    icon = "⚠️", color = "warning" },
            { id = "s6",  type = "button", label = "Mute joueur",    icon = "🔇" },

            { id = "sep2", type = "separator" },
            { id = "s99", type = "button", label = "← Retour",      icon = "←" },
        }
    })
end

local function openVehiclesMenu()
    openMenu({
        menuId   = "admin_vehicles",
        title    = "VÉHICULES",
        subtitle = "Spawn & gestion",
        items    = {
            { id = "t1",  type = "title",  label = "Spawn" },
            { id = "v1",  type = "input",  label = "Nom du modèle", icon = "🔑", placeholder = "Ex: adder, zentorno..." },
            { id = "v2",  type = "button", label = "Spawner le véhicule", icon = "🚗", color = "success" },

            { id = "sep1", type = "separator", label = "Catégories rapides" },
            { id = "v3",  type = "button", label = "Voitures de sport",  icon = "🏎️" },
            { id = "v4",  type = "button", label = "SUV / 4x4",          icon = "🚙" },
            { id = "v5",  type = "button", label = "Motos",              icon = "🏍️" },
            { id = "v6",  type = "button", label = "Hélicoptères",       icon = "🚁" },
            { id = "v7",  type = "button", label = "Avions",             icon = "✈️" },
            { id = "v8",  type = "button", label = "Bateaux",            icon = "⛵" },

            { id = "sep2", type = "separator", label = "Mon véhicule" },
            { id = "v9",  type = "button", label = "Réparer",     icon = "🔧" },
            { id = "v10", type = "button", label = "Supprimer",   icon = "🗑️", color = "danger" },

            { id = "sep3", type = "separator" },
            { id = "v99", type = "button", label = "← Retour",    icon = "←" },
        }
    })
end

local function openTeleportMenu()
    openMenu({
        menuId   = "admin_teleport",
        title    = "TÉLÉPORTATION",
        subtitle = "Lieux & coordonnées",
        items    = {
            { id = "t1",  type = "title",  label = "Lieux prédéfinis" },
            { id = "tp1", type = "button", label = "LSIA (Aéroport)",   icon = "✈️" },
            { id = "tp2", type = "button", label = "Pillbox Hill",      icon = "🏥" },
            { id = "tp3", type = "button", label = "Paleto Bay",        icon = "🏖️" },
            { id = "tp4", type = "button", label = "Sandy Shores",      icon = "🏜️" },
            { id = "tp5", type = "button", label = "Fort Zancudo",      icon = "🪖" },
            { id = "tp6", type = "button", label = "Commissariat LSPD", icon = "👮" },
            { id = "tp7", type = "button", label = "Maison Maze Bank",  icon = "🏢" },
            { id = "tp8", type = "button", label = "Hippodrome",        icon = "🐎" },

            { id = "sep1", type = "separator", label = "Coordonnées" },
            { id = "tp9",  type = "input",  label = "X", placeholder = "0.0", inputType = "number" },
            { id = "tp10", type = "input",  label = "Y", placeholder = "0.0", inputType = "number" },
            { id = "tp11", type = "input",  label = "Z", placeholder = "0.0", inputType = "number" },
            { id = "tp12", type = "button", label = "Téléporter aux coordonnées", icon = "📍", color = "success" },

            { id = "sep2", type = "separator" },
            { id = "tp99", type = "button", label = "← Retour", icon = "←" },
        }
    })
end

local function openWorldMenu()
    openMenu({
        menuId   = "admin_world",
        title    = "MONDE",
        subtitle = "Météo & heure",
        items    = {
            { id = "t1",  type = "title",  label = "Météo" },
            { id = "w1",  type = "button", label = "Ensoleillé",  icon = "☀️" },
            { id = "w2",  type = "button", label = "Nuageux",     icon = "🌥️" },
            { id = "w3",  type = "button", label = "Pluie",       icon = "🌧️" },
            { id = "w4",  type = "button", label = "Orage",       icon = "⛈️" },
            { id = "w5",  type = "button", label = "Neige",       icon = "🌨️" },
            { id = "w6",  type = "button", label = "Brouillard",  icon = "🌫️" },
            { id = "w7",  type = "button", label = "Tempête",     icon = "🌪️" },

            { id = "sep1", type = "separator", label = "Heure" },
            { id = "w8",  type = "input",  label = "Heures (0-23)",  placeholder = "12", inputType = "number", min = 0, max = 23 },
            { id = "w9",  type = "input",  label = "Minutes (0-59)", placeholder = "0",  inputType = "number", min = 0, max = 59 },
            { id = "w10", type = "button", label = "Appliquer l'heure", icon = "🕐", color = "success" },

            { id = "sep2", type = "separator" },
            { id = "w11", type = "button", label = "Geler le temps",   icon = "🧊" },
            { id = "w12", type = "button", label = "Dégeler le temps", icon = "🔥" },

            { id = "sep3", type = "separator" },
            { id = "w99", type = "button", label = "← Retour", icon = "←" },
        }
    })
end

-- ============================================================
-- 🔹 COMMANDE
-- ============================================================
RegisterCommand('admin', function()
    if isAdminMenuOpen then
        closeMenu()
        return
    end
    TriggerServerEvent('k_menu:checkAdmin')
end, false)

RegisterKeyMapping('admin', 'Ouvrir Menu Admin', 'keyboard', 'F10')

-- ============================================================
-- 🔹 EVENT: Permission accordée par le serveur
-- ============================================================
RegisterNetEvent('k_menu:openAdmin', function()
    openAdminMenu()
end)

-- ============================================================
-- 🔹 CALLBACKS NUI
-- ============================================================
RegisterNUICallback('closeMenu', function(_, cb)
    closeMenu()
    cb({})
end)

-- FIX: ajout de la gestion du retour vers admin_main depuis un sous-menu
RegisterNUICallback('openSubmenu', function(data, cb)
    local submenuId = data.submenuId or data.id

    if     submenuId == "admin_players"   then openPlayersMenu()
    elseif submenuId == "admin_sanctions" then openSanctionsMenu()
    elseif submenuId == "admin_vehicles"  then openVehiclesMenu()
    elseif submenuId == "admin_teleport"  then openTeleportMenu()
    elseif submenuId == "admin_world"     then openWorldMenu()
    -- FIX: permettre le retour vers le menu principal depuis un sous-menu
    elseif submenuId == "admin_main"      then openAdminMenu()
    end

    cb({})
end)

RegisterNUICallback('buttonClick', function(data, cb)
    local id = data.id
    print("^5[admin] buttonClick:", id)

    -- ── Menu principal ──
    if     id == "4"  then TriggerServerEvent('k_menu:admin', 'deleteNearVehicles')
    elseif id == "5"  then TriggerServerEvent('k_menu:admin', 'fixMyVehicle')
    elseif id == "8"  then TriggerServerEvent('k_menu:admin', 'godMode')
    elseif id == "9"  then TriggerServerEvent('k_menu:admin', 'invisible')
    elseif id == "10" then TriggerServerEvent('k_menu:admin', 'noclip')
    elseif id == "11" then TriggerServerEvent('k_menu:admin', 'speedBoost')
    elseif id == "12" then closeMenu()

    -- ── Joueurs ──
    elseif id == "p1"  then TriggerServerEvent('k_menu:admin', 'listPlayers')
    elseif id == "p2"  then TriggerServerEvent('k_menu:admin', 'freezeAll')
    elseif id == "p3"  then TriggerServerEvent('k_menu:admin', 'healAll')
    elseif id == "p5"  then TriggerServerEvent('k_menu:admin', 'tpToPlayer')
    elseif id == "p6"  then TriggerServerEvent('k_menu:admin', 'bringPlayer')
    elseif id == "p7"  then TriggerServerEvent('k_menu:admin', 'spectate')
    elseif id == "p8"  then TriggerServerEvent('k_menu:admin', 'healPlayer')
    elseif id == "p9"  then TriggerServerEvent('k_menu:admin', 'revivePlayer')
    elseif id == "p10" then TriggerServerEvent('k_menu:admin', 'giveMoney')
    elseif id == "p99" then goBack()

    -- ── Sanctions ──
    -- FIX: passer les inputs s0 (targetId) et s1 (reason) au serveur
    elseif id == "s2"  then
        TriggerServerEvent('k_menu:adminDoKick',    tonumber(adminInputs["s0"]), adminInputs["s1"])
    elseif id == "s3"  then TriggerServerEvent('k_menu:admin', 'tempban')
    elseif id == "s4"  then
        TriggerServerEvent('k_menu:adminDoPermban', tonumber(adminInputs["s0"]), adminInputs["s1"])
    elseif id == "s5"  then TriggerServerEvent('k_menu:admin', 'warn')
    elseif id == "s6"  then TriggerServerEvent('k_menu:admin', 'mute')
    elseif id == "s99" then goBack()

    -- ── Véhicules ──
    elseif id == "v2"  then TriggerServerEvent('k_menu:admin', 'spawnVehicle', adminInputs["v1"])
    elseif id == "v3"  then TriggerServerEvent('k_menu:admin', 'spawnCategory', 'sport')
    elseif id == "v4"  then TriggerServerEvent('k_menu:admin', 'spawnCategory', 'suv')
    elseif id == "v5"  then TriggerServerEvent('k_menu:admin', 'spawnCategory', 'moto')
    elseif id == "v6"  then TriggerServerEvent('k_menu:admin', 'spawnCategory', 'heli')
    elseif id == "v7"  then TriggerServerEvent('k_menu:admin', 'spawnCategory', 'plane')
    elseif id == "v8"  then TriggerServerEvent('k_menu:admin', 'spawnCategory', 'boat')
    elseif id == "v9"  then TriggerServerEvent('k_menu:admin', 'fixMyVehicle')
    elseif id == "v10" then TriggerServerEvent('k_menu:admin', 'deleteMyVehicle')
    elseif id == "v99" then goBack()

    -- ── Téléportation ──
    elseif id == "tp1"  then TriggerServerEvent('k_menu:admin', 'tpTo', -1037.7, -2738.5, 20.2)
    elseif id == "tp2"  then TriggerServerEvent('k_menu:admin', 'tpTo', 357.8,   -594.0,  28.7)
    elseif id == "tp3"  then TriggerServerEvent('k_menu:admin', 'tpTo', -243.4,  6331.3,  32.4)
    elseif id == "tp4"  then TriggerServerEvent('k_menu:admin', 'tpTo', 1853.0,  3686.5,  34.3)
    elseif id == "tp5"  then TriggerServerEvent('k_menu:admin', 'tpTo', -2047.6, 3132.1,  32.8)
    elseif id == "tp6"  then TriggerServerEvent('k_menu:admin', 'tpTo', 441.8,   -980.0,  30.7)
    elseif id == "tp7"  then TriggerServerEvent('k_menu:admin', 'tpTo', -75.5,   -818.6,  326.2)
    elseif id == "tp8"  then TriggerServerEvent('k_menu:admin', 'tpTo', -329.0,  -103.0,  35.6)
    elseif id == "tp12" then
        -- FIX: passer les coordonnées X, Y, Z depuis les inputs
        local x = tonumber(adminInputs["tp9"])  or 0.0
        local y = tonumber(adminInputs["tp10"]) or 0.0
        local z = tonumber(adminInputs["tp11"]) or 0.0
        TriggerServerEvent('k_menu:admin', 'tpTo', x, y, z)
    elseif id == "tp99" then goBack()

    -- ── Météo ──
    elseif id == "w1"  then TriggerServerEvent('k_menu:admin', 'setWeather', 'EXTRASUNNY')
    elseif id == "w2"  then TriggerServerEvent('k_menu:admin', 'setWeather', 'CLOUDS')
    elseif id == "w3"  then TriggerServerEvent('k_menu:admin', 'setWeather', 'RAIN')
    elseif id == "w4"  then TriggerServerEvent('k_menu:admin', 'setWeather', 'THUNDER')
    elseif id == "w5"  then TriggerServerEvent('k_menu:admin', 'setWeather', 'SNOW')
    elseif id == "w6"  then TriggerServerEvent('k_menu:admin', 'setWeather', 'FOGGY')
    elseif id == "w7"  then TriggerServerEvent('k_menu:admin', 'setWeather', 'SMOG')
    elseif id == "w10" then
        -- FIX: transmettre h et m lus depuis les inputs
        local h = adminInputs["w8"] or "12"
        local m = adminInputs["w9"] or "0"
        TriggerServerEvent('k_menu:admin', 'setTime', h, m)
    elseif id == "w11" then TriggerServerEvent('k_menu:admin', 'freezeTime', true)
    elseif id == "w12" then TriggerServerEvent('k_menu:admin', 'freezeTime', false)
    elseif id == "w99" then goBack()
    end

    cb({})
end)

-- ── inputChange — stocker les valeurs ─────────────────────────
RegisterNUICallback('inputChange', function(data, cb)
    if data.id then
        adminInputs[data.id] = data.value
    end
    cb({})
end)

RegisterNUICallback('inputConfirm', function(data, cb)
    if data.id then
        adminInputs[data.id] = data.value
    end
    cb({})
end)

-- FIX: event pour appliquer le temps reçu du serveur (broadcast à tous)
RegisterNetEvent('k_menu:adminApplyTime', function(h, m)
    NetworkOverrideClockTime(h, m, 0)
end)

print("^2[k_menu] Admin Client READY")