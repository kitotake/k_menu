-- client/admin.lua
-- Menu Admin — utilise K (core.lua)

-- ─────────────────────────────────────────────────────────────────────────────
-- Menus
-- ─────────────────────────────────────────────────────────────────────────────

local function menuPrincipal()
    K.open({
        id       = "admin",
        title    = "ADMIN",
        subtitle = "Panel de gestion",
        items    = {
            { id = "sep_joueurs",   type = "separator", label = "Joueurs" },
            { id = "nav_joueurs",   type = "submenu",   label = "Joueurs",                  submenuId = "admin_joueurs" },
            { id = "nav_sanctions", type = "submenu",   label = "Sanctions",                submenuId = "admin_sanctions" },

            { id = "sep_veh",       type = "separator", label = "Véhicules" },
            { id = "nav_veh",       type = "submenu",   label = "Véhicules",                submenuId = "admin_veh" },
            { id = "del_veh_near",  type = "button",    label = "Suppr. véhicules proches", color = "danger" },

            { id = "sep_monde",     type = "separator", label = "Monde" },
            { id = "nav_meteo",     type = "submenu",   label = "Météo / Heure",            submenuId = "admin_monde" },
            { id = "nav_tp",        type = "submenu",   label = "Téléportation",            submenuId = "admin_tp" },

            { id = "sep_outils",    type = "separator", label = "Outils" },
            { id = "godmode",       type = "toggle",    label = "God Mode",     value = false },
            { id = "invisible",     type = "toggle",    label = "Invisible",    value = false },
            { id = "noclip",        type = "button",    label = "NoClip" },
            { id = "speedboost",    type = "toggle",    label = "Speed Boost",  value = false },
        }
    })
end

local function menuJoueurs()
    K.open({
        id    = "admin_joueurs",
        title = "JOUEURS",
        items = {
            { id = "sep_global", type = "separator", label = "Global" },
            { id = "list_all",   type = "button",    label = "Lister tous",      color = "success" },
            { id = "heal_all",   type = "button",    label = "Heal tous",        color = "success" },
            { id = "freeze_all", type = "button",    label = "Freeze tous",      color = "danger" },

            { id = "sep_cible",  type = "separator", label = "Cible" },
            { id = "target_id",  type = "input",     label = "ID joueur",        placeholder = "1", inputType = "number" },
            { id = "tp_to",      type = "button",    label = "TP vers joueur" },
            { id = "bring",      type = "button",    label = "Ramener" },
            { id = "heal_p",     type = "button",    label = "Heal joueur",      color = "success" },
            { id = "revive_p",   type = "button",    label = "Revive joueur",    color = "success" },
            { id = "spectate",   type = "button",    label = "Spectate" },
        }
    })
end

local function menuSanctions()
    K.open({
        id    = "admin_sanctions",
        title = "SANCTIONS",
        items = {
            { id = "sanc_id",     type = "input",     label = "ID joueur", placeholder = "1", inputType = "number" },
            { id = "sanc_raison", type = "input",     label = "Raison",    placeholder = "Motif..." },
            { id = "sep_acts",    type = "separator", label = "Actions" },
            { id = "kick",        type = "button",    label = "Kick",      color = "danger" },
            { id = "ban_temp",    type = "button",    label = "Ban temp.", color = "danger" },
            { id = "ban_perm",    type = "button",    label = "Ban perm.", color = "danger" },
            { id = "warn",        type = "button",    label = "Warn",      color = "warning" },
        }
    })
end

local function menuVehicules()
    K.open({
        id    = "admin_veh",
        title = "VÉHICULES",
        items = {
            { id = "veh_model",  type = "input",     label = "Modèle",         placeholder = "adder" },
            { id = "spawn_veh",  type = "button",    label = "Spawner",        color = "success" },
            { id = "sep_cats",   type = "separator", label = "Catégories rapides" },
            { id = "cat_sport",  type = "button",    label = "Sport" },
            { id = "cat_suv",    type = "button",    label = "SUV" },
            { id = "cat_moto",   type = "button",    label = "Moto" },
            { id = "cat_heli",   type = "button",    label = "Hélico" },
            { id = "cat_avion",  type = "button",    label = "Avion" },
            { id = "sep_mon",    type = "separator", label = "Mon véhicule" },
            { id = "fix_veh",    type = "button",    label = "Réparer" },
            { id = "del_veh",    type = "button",    label = "Supprimer",      color = "danger" },
        }
    })
end

local function menuMonde()
    K.open({
        id    = "admin_monde",
        title = "MONDE",
        items = {
            { id = "sep_meteo",  type = "separator", label = "Météo" },
            { id = "w_sun",      type = "button",    label = "Ensoleillé" },
            { id = "w_cloud",    type = "button",    label = "Nuageux" },
            { id = "w_rain",     type = "button",    label = "Pluie" },
            { id = "w_thunder",  type = "button",    label = "Orage" },
            { id = "w_snow",     type = "button",    label = "Neige" },
            { id = "w_fog",      type = "button",    label = "Brouillard" },
            { id = "sep_time",   type = "separator", label = "Heure" },
            { id = "time_h",     type = "input",     label = "Heures (0-23)",   placeholder = "12", inputType = "number", min = 0, max = 23 },
            { id = "time_m",     type = "input",     label = "Minutes (0-59)",  placeholder = "0",  inputType = "number", min = 0, max = 59 },
            { id = "set_time",   type = "button",    label = "Appliquer",       color = "success" },
            { id = "sep_freeze", type = "separator" },
            { id = "freeze_t",   type = "toggle",    label = "Geler le temps",  value = false },
        }
    })
end

local function menuTeleport()
    K.open({
        id    = "admin_tp",
        title = "TÉLÉPORTATION",
        items = {
            { id = "sep_lieux",  type = "separator", label = "Lieux" },
            { id = "tp_lsia",    type = "button",    label = "LSIA (Aéroport)" },
            { id = "tp_pillbox", type = "button",    label = "Pillbox Hill" },
            { id = "tp_paleto",  type = "button",    label = "Paleto Bay" },
            { id = "tp_sandy",   type = "button",    label = "Sandy Shores" },
            { id = "tp_zancudo", type = "button",    label = "Fort Zancudo" },
            { id = "tp_lspd",    type = "button",    label = "Commissariat LSPD" },
            { id = "sep_coords", type = "separator", label = "Coordonnées" },
            { id = "tp_x",       type = "input",     label = "X", placeholder = "0.0", inputType = "number" },
            { id = "tp_y",       type = "input",     label = "Y", placeholder = "0.0", inputType = "number" },
            { id = "tp_z",       type = "input",     label = "Z", placeholder = "0.0", inputType = "number" },
            { id = "tp_go",      type = "button",    label = "Téléporter",  color = "success" },
        }
    })
end

-- ─────────────────────────────────────────────────────────────────────────────
-- FIX #1 + #7 : AddEventHandler (local) au lieu de RegisterNetEvent
-- Un seul point d'entrée pour tous les sous-menus admin
-- ─────────────────────────────────────────────────────────────────────────────

local submenus = {
    admin_joueurs   = menuJoueurs,
    admin_sanctions = menuSanctions,
    admin_veh       = menuVehicules,
    admin_monde     = menuMonde,
    admin_tp        = menuTeleport,
    admin           = menuPrincipal,
}

AddEventHandler('k_menu:submenu', function(submenuId, _)
    local fn = submenus[submenuId]
    if fn then fn() end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- FIX #7 : AddEventHandler (local) pour les boutons admin
-- ─────────────────────────────────────────────────────────────────────────────

AddEventHandler('k_menu:button', function(id, _menuId)
    -- Véhicules
    if     id == "del_veh_near" then TriggerServerEvent('k_menu:admin', 'deleteNear')
    elseif id == "fix_veh"      then TriggerServerEvent('k_menu:admin', 'fixVeh')
    elseif id == "del_veh"      then TriggerServerEvent('k_menu:admin', 'delVeh')
    elseif id == "spawn_veh"    then TriggerServerEvent('k_menu:admin', 'spawnVeh', K.input("veh_model"))
    elseif id == "cat_sport"    then TriggerServerEvent('k_menu:admin', 'spawnCat', 'sport')
    elseif id == "cat_suv"      then TriggerServerEvent('k_menu:admin', 'spawnCat', 'suv')
    elseif id == "cat_moto"     then TriggerServerEvent('k_menu:admin', 'spawnCat', 'moto')
    elseif id == "cat_heli"     then TriggerServerEvent('k_menu:admin', 'spawnCat', 'heli')
    elseif id == "cat_avion"    then TriggerServerEvent('k_menu:admin', 'spawnCat', 'plane')

    -- Joueurs
    elseif id == "list_all"     then TriggerServerEvent('k_menu:admin', 'listPlayers')
    elseif id == "heal_all"     then TriggerServerEvent('k_menu:admin', 'healAll')
    elseif id == "freeze_all"   then TriggerServerEvent('k_menu:admin', 'freezeAll')
    elseif id == "tp_to"        then TriggerServerEvent('k_menu:admin', 'tpToPlayer',  tonumber(K.input("target_id")))
    elseif id == "bring"        then TriggerServerEvent('k_menu:admin', 'bring',        tonumber(K.input("target_id")))
    elseif id == "heal_p"       then TriggerServerEvent('k_menu:admin', 'healPlayer',   tonumber(K.input("target_id")))
    elseif id == "revive_p"     then TriggerServerEvent('k_menu:admin', 'revivePlayer', tonumber(K.input("target_id")))
    elseif id == "spectate"     then TriggerServerEvent('k_menu:admin', 'spectate',     tonumber(K.input("target_id")))

    -- Sanctions
    elseif id == "kick"         then TriggerServerEvent('k_menu:adminKick',    tonumber(K.input("sanc_id")), K.input("sanc_raison"))
    elseif id == "ban_temp"     then TriggerServerEvent('k_menu:adminBanTemp', tonumber(K.input("sanc_id")), K.input("sanc_raison"))
    elseif id == "ban_perm"     then TriggerServerEvent('k_menu:adminBanPerm', tonumber(K.input("sanc_id")), K.input("sanc_raison"))
    elseif id == "warn"         then TriggerServerEvent('k_menu:admin', 'warn', tonumber(K.input("sanc_id")), K.input("sanc_raison"))

    -- Téléportation prédéfinie
    elseif id == "tp_lsia"      then TriggerServerEvent('k_menu:admin', 'tpTo', -1037.7, -2738.5, 20.2)
    elseif id == "tp_pillbox"   then TriggerServerEvent('k_menu:admin', 'tpTo',   357.8,  -594.0, 28.7)
    elseif id == "tp_paleto"    then TriggerServerEvent('k_menu:admin', 'tpTo',  -243.4,  6331.3, 32.4)
    elseif id == "tp_sandy"     then TriggerServerEvent('k_menu:admin', 'tpTo',  1853.0,  3686.5, 34.3)
    elseif id == "tp_zancudo"   then TriggerServerEvent('k_menu:admin', 'tpTo', -2047.6,  3132.1, 32.8)
    elseif id == "tp_lspd"      then TriggerServerEvent('k_menu:admin', 'tpTo',   441.8,  -980.0, 30.7)
    elseif id == "tp_go"        then
        local x = tonumber(K.input("tp_x")) or 0.0
        local y = tonumber(K.input("tp_y")) or 0.0
        local z = tonumber(K.input("tp_z")) or 0.0
        TriggerServerEvent('k_menu:admin', 'tpTo', x, y, z)

    -- Météo
    elseif id == "w_sun"        then TriggerServerEvent('k_menu:admin', 'weather', 'EXTRASUNNY')
    elseif id == "w_cloud"      then TriggerServerEvent('k_menu:admin', 'weather', 'CLOUDS')
    elseif id == "w_rain"       then TriggerServerEvent('k_menu:admin', 'weather', 'RAIN')
    elseif id == "w_thunder"    then TriggerServerEvent('k_menu:admin', 'weather', 'THUNDER')
    elseif id == "w_snow"       then TriggerServerEvent('k_menu:admin', 'weather', 'SNOW')
    elseif id == "w_fog"        then TriggerServerEvent('k_menu:admin', 'weather', 'FOGGY')
    elseif id == "set_time"     then
        TriggerServerEvent('k_menu:admin', 'setTime',
            tonumber(K.input("time_h")) or 12,
            tonumber(K.input("time_m")) or 0)

    -- Noclip
    elseif id == "noclip"       then TriggerServerEvent('k_menu:admin', 'noclip')
    end
end)

-- FIX #7 : AddEventHandler (local) pour les toggles admin
AddEventHandler('k_menu:toggle', function(id, value, _)
    -- FIX #5 : value est un booléen Lua, on le passe directement
    if     id == "godmode"    then TriggerServerEvent('k_menu:admin', 'godMode',    value)
    elseif id == "invisible"  then TriggerServerEvent('k_menu:admin', 'invisible',  value)
    elseif id == "speedboost" then TriggerServerEvent('k_menu:admin', 'speedBoost', value)
    elseif id == "freeze_t"   then TriggerServerEvent('k_menu:admin', 'freezeTime', value)
    end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Commande admin
-- ─────────────────────────────────────────────────────────────────────────────

RegisterCommand('admin', function()
    if K.isOpen() then
        K.close()
        return
    end
    TriggerServerEvent('k_menu:checkAdmin')
end, false)

RegisterKeyMapping('admin', 'Ouvrir Menu Admin', 'keyboard', Config.AdminKey)

RegisterNetEvent('k_menu:openAdmin', function()
    menuPrincipal()
end)

print("^2[k_menu] Admin client chargé^7")
