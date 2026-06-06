-- client/admin.lua
-- Menu Admin V3 — utilise K (core.lua)

-- ─────────────────────────────────────────────────────────────────────────────
-- Menus
-- ─────────────────────────────────────────────────────────────────────────────

local function menuPrincipal()
    Menu.open({
        id       = "admin",
        title    = "ADMIN",
        subtitle = "Panel de gestion",
        items    = {
            { id = "sep_joueurs",   type = "separator", label = "Joueurs" },
            { id = "nav_joueurs",   type = "submenu",   label = "Joueurs",                     submenuId = "admin_joueurs" },
            { id = "nav_sanctions", type = "submenu",   label = "Sanctions",                   submenuId = "admin_sanctions" },

            { id = "sep_veh",       type = "separator", label = "Véhicules" },
            { id = "nav_veh",       type = "submenu",   label = "Véhicules",                   submenuId = "admin_veh" },
            { id = "del_veh_near",  type = "button",    label = "Suppr. véhicules proches",    color = "danger" },

            { id = "sep_monde",     type = "separator", label = "Monde" },
            { id = "nav_meteo",     type = "submenu",   label = "Météo / Heure",               submenuId = "admin_monde" },
            { id = "nav_tp",        type = "submenu",   label = "Téléportation",               submenuId = "admin_tp" },

            { id = "sep_outils",    type = "separator", label = "Outils" },
            { id = "godmode",       type = "toggle",    label = "God Mode",       value = false },
            { id = "invisible",     type = "toggle",    label = "Invisible",      value = false },
            { id = "noclip",        type = "button",    label = "NoClip" },
            { id = "speedboost",    type = "toggle",    label = "Speed Boost",    value = false },

            -- Nouveaux outils
            { id = "sep_extras",    type = "separator", label = "Extras" },
            { id = "nav_perso",     type = "submenu",   label = "Personnage",                  submenuId = "admin_perso" },
            { id = "nav_armes",     type = "submenu",   label = "Armes",                       submenuId = "admin_armes" },
            { id = "nav_effets",    type = "submenu",   label = "Effets visuels",              submenuId = "admin_effets" },
            { id = "supergravite",  type = "toggle",    label = "Gravité réduite",value = false },
        }
    })
end

local function menuJoueurs()
    Menu.open({
        id    = "admin_joueurs",
        title = "JOUEURS",
        items = {
            { id = "sep_global",    type = "separator", label = "Global" },
            { id = "list_all",      type = "button",    label = "Lister tous",       color = "success" },
            { id = "heal_all",      type = "button",    label = "Heal tous",         color = "success" },
            { id = "revive_all",    type = "button",    label = "Revive tous",       color = "success" },
            { id = "freeze_all",    type = "button",    label = "Freeze tous",       color = "danger" },
            { id = "unfreeze_all",  type = "button",    label = "Unfreeze tous",     color = "success" },

            { id = "sep_cible",     type = "separator", label = "Cible" },
            { id = "target_id",     type = "input",     label = "ID joueur",         placeholder = "1", inputType = "number" },
            { id = "tp_to",         type = "button",    label = "TP vers joueur" },
            { id = "bring",         type = "button",    label = "Ramener ici" },
            { id = "heal_p",        type = "button",    label = "Heal joueur",       color = "success" },
            { id = "revive_p",      type = "button",    label = "Revive joueur",     color = "success" },
            { id = "freeze_p",      type = "button",    label = "Freeze joueur",     color = "warning" },
            { id = "spectate",      type = "button",    label = "Spectate" },
            { id = "copy_coords",   type = "button",    label = "Copier ses coords" },
        }
    })
end

local function menuSanctions()
    Menu.open({
        id    = "admin_sanctions",
        title = "SANCTIONS",
        items = {
            { id = "sanc_id",       type = "input",     label = "ID joueur",         placeholder = "1",      inputType = "number" },
            { id = "sanc_raison",   type = "input",     label = "Raison",            placeholder = "Motif..." },
            { id = "sanc_duree",    type = "input",     label = "Durée (heures)",    placeholder = "24",     inputType = "number" },
            { id = "sep_acts",      type = "separator", label = "Actions" },
            { id = "kick",          type = "button",    label = "Kick",              color = "danger" },
            { id = "ban_temp",      type = "button",    label = "Ban temp.",         color = "danger" },
            { id = "ban_perm",      type = "button",    label = "Ban perm.",         color = "danger" },
            { id = "warn",          type = "button",    label = "Warn",              color = "warning" },
            { id = "sep_infos",     type = "separator", label = "Infos" },
            { id = "get_id",        type = "button",    label = "Voir identifiants" },
        }
    })
end

local function menuVehicules()
    Menu.open({
        id    = "admin_veh",
        title = "VÉHICULES",
        items = {
            { id = "veh_model",     type = "input",     label = "Modèle",            placeholder = "adder" },
            { id = "spawn_veh",     type = "button",    label = "Spawner",           color = "success" },

            { id = "sep_cats",      type = "separator", label = "Catégories rapides" },
            { id = "cat_sport",     type = "button",    label = "Sport" },
            { id = "cat_super",     type = "button",    label = "Super Sport" },
            { id = "cat_suv",       type = "button",    label = "SUV" },
            { id = "cat_moto",      type = "button",    label = "Moto" },
            { id = "cat_heli",      type = "button",    label = "Hélico" },
            { id = "cat_avion",     type = "button",    label = "Avion" },
            { id = "cat_bateau",    type = "button",    label = "Bateau" },
            { id = "cat_tank",      type = "button",    label = "Tank" },

            { id = "sep_mon",       type = "separator", label = "Mon véhicule" },
            { id = "fix_veh",       type = "button",    label = "Réparer",           color = "success" },
            { id = "veh_invincible",type = "toggle",    label = "Invincible",        value = false },
            { id = "boost_veh",     type = "button",    label = "Boost moteur ×10",  color = "warning" },
            { id = "veh_couleur",   type = "submenu",   label = "Couleur rapide",    submenuId = "admin_veh_color" },
            { id = "del_veh",       type = "button",    label = "Supprimer",         color = "danger" },
        }
    })
end

local function menuVehColor()
    Menu.open({
        id    = "admin_veh_color",
        title = "COULEUR VÉH.",
        items = {
            { id = "vc_noir",   type = "button", label = "Noir" },
            { id = "vc_blanc",  type = "button", label = "Blanc" },
            { id = "vc_rouge",  type = "button", label = "Rouge" },
            { id = "vc_bleu",   type = "button", label = "Bleu" },
            { id = "vc_vert",   type = "button", label = "Vert" },
            { id = "vc_or",     type = "button", label = "Or" },
            { id = "vc_chrome", type = "button", label = "Chrome" },
        }
    })
end

local function menuMonde()
    Menu.open({
        id    = "admin_monde",
        title = "MONDE",
        items = {
            { id = "sep_meteo",   type = "separator", label = "Météo" },
            { id = "w_sun",       type = "button",    label = "Ensoleillé" },
            { id = "w_cloud",     type = "button",    label = "Nuageux" },
            { id = "w_rain",      type = "button",    label = "Pluie" },
            { id = "w_thunder",   type = "button",    label = "Orage" },
            { id = "w_snow",      type = "button",    label = "Neige" },
            { id = "w_fog",       type = "button",    label = "Brouillard" },
            { id = "w_xmas",      type = "button",    label = "Noël" },
            { id = "w_halloween", type = "button",    label = "Halloween" },

            { id = "sep_time",    type = "separator", label = "Heure" },
            { id = "time_h",      type = "input",     label = "Heures (0-23)",      placeholder = "12", inputType = "number", min = 0, max = 23 },
            { id = "time_m",      type = "input",     label = "Minutes (0-59)",     placeholder = "0",  inputType = "number", min = 0, max = 59 },
            { id = "set_time",    type = "button",    label = "Appliquer",          color = "success" },
            { id = "t_midi",      type = "button",    label = "Midi" },
            { id = "t_minuit",    type = "button",    label = "Minuit" },
            { id = "t_aube",      type = "button",    label = "Aube (6h)" },
            { id = "t_soir",      type = "button",    label = "Soir (20h)" },

            { id = "sep_freeze",  type = "separator" },
            { id = "freeze_t",    type = "toggle",    label = "Geler le temps",     value = false },
        }
    })
end

local function menuTeleport()
    Menu.open({
        id    = "admin_tp",
        title = "TÉLÉPORTATION",
        items = {
            { id = "sep_lieux",   type = "separator", label = "Lieux" },
            { id = "tp_lsia",     type = "button",    label = "LSIA (Aéroport)" },
            { id = "tp_pillbox",  type = "button",    label = "Pillbox Hill" },
            { id = "tp_paleto",   type = "button",    label = "Paleto Bay" },
            { id = "tp_sandy",    type = "button",    label = "Sandy Shores" },
            { id = "tp_zancudo",  type = "button",    label = "Fort Zancudo" },
            { id = "tp_lspd",     type = "button",    label = "Commissariat LSPD" },
            { id = "tp_prison",   type = "button",    label = "Prison Bolingbroke" },
            { id = "tp_maze",     type = "button",    label = "Maze Tower" },
            { id = "tp_vinewood", type = "button",    label = "Panneau Vinewood" },
            { id = "tp_port",     type = "button",    label = "Port LS" },

            { id = "sep_coords",  type = "separator", label = "Coordonnées" },
            { id = "tp_x",        type = "input",     label = "X",                  placeholder = "0.0", inputType = "number" },
            { id = "tp_y",        type = "input",     label = "Y",                  placeholder = "0.0", inputType = "number" },
            { id = "tp_z",        type = "input",     label = "Z",                  placeholder = "0.0", inputType = "number" },
            { id = "tp_go",       type = "button",    label = "Téléporter",         color = "success" },

            { id = "sep_mark",    type = "separator", label = "Marqueur" },
            { id = "tp_waypoint", type = "button",    label = "TP au waypoint" },
            { id = "print_coords",type = "button",    label = "Afficher mes coords" },
        }
    })
end

-- ─── NOUVEAU : Menu Personnage ─────────────────────────────────────────────

local function menuPerso()
    Menu.open({
        id    = "admin_perso",
        title = "PERSONNAGE",
        items = {
            { id = "sep_sante",     type = "separator", label = "Santé" },
            { id = "heal_me",       type = "button",    label = "Heal total",         color = "success" },
            { id = "revive_me",     type = "button",    label = "Revive",             color = "success" },
            { id = "set_armor",     type = "button",    label = "Armure 100%",        color = "success" },

            { id = "sep_anim",      type = "separator", label = "Animations" },
            { id = "anim_danse",    type = "button",    label = "Danser" },
            { id = "anim_assis",    type = "button",    label = "S'asseoir" },
            { id = "anim_stop",     type = "button",    label = "Stop animation",     color = "warning" },

            { id = "sep_skin",      type = "separator", label = "Modèle" },
            { id = "skin_model",    type = "input",     label = "Modèle de ped",      placeholder = "mp_m_freemode_01" },
            { id = "apply_skin",    type = "button",    label = "Appliquer",          color = "success" },
            { id = "reset_skin",    type = "button",    label = "Réinitialiser" },

            { id = "sep_move",      type = "separator", label = "Déplacements" },
            { id = "super_jump",    type = "toggle",    label = "Super Saut",         value = false },
            { id = "fast_run",      type = "toggle",    label = "Courir vite",        value = false },
        }
    })
end

-- ─── NOUVEAU : Menu Armes ─────────────────────────────────────────────────

local function menuArmes()
    Menu.open({
        id    = "admin_armes",
        title = "ARMES",
        items = {
            { id = "sep_kits",      type = "separator", label = "Kits" },
            { id = "kit_combat",    type = "button",    label = "Kit combat",         color = "success" },
            { id = "kit_sniper",    type = "button",    label = "Kit sniper",         color = "success" },
            { id = "kit_tout",      type = "button",    label = "Toutes les armes",   color = "warning" },

            { id = "sep_arme",      type = "separator", label = "Arme custom" },
            { id = "arme_name",     type = "input",     label = "Nom arme",           placeholder = "WEAPON_PISTOL" },
            { id = "arme_ammo",     type = "input",     label = "Munitions",          placeholder = "999", inputType = "number" },
            { id = "give_weapon",   type = "button",    label = "Donner",             color = "success" },

            { id = "sep_divers",    type = "separator", label = "Divers" },
            { id = "infini_ammo",   type = "toggle",    label = "Munitions infinies", value = false },
            { id = "remove_all",    type = "button",    label = "Retirer tout",       color = "danger" },
        }
    })
end

-- ─── NOUVEAU : Menu Effets visuels ────────────────────────────────────────

local function menuEffets()
    Menu.open({
        id    = "admin_effets",
        title = "EFFETS VISUELS",
        items = {
            { id = "sep_filtre",    type = "separator", label = "Filtre écran" },
            { id = "fx_night",      type = "button",    label = "Vision nocturne" },
            { id = "fx_thermal",    type = "button",    label = "Vision thermique" },
            { id = "fx_normal",     type = "button",    label = "Normal",             color = "success" },
            { id = "sep_drunk",     type = "separator", label = "Effets joueur" },
            { id = "fx_drunk",      type = "toggle",    label = "Ivre",               value = false },
            { id = "fx_ragdoll",    type = "button",    label = "Ragdoll" },
            { id = "sep_cop",       type = "separator", label = "Étoiles" },
            { id = "clear_wanted",  type = "button",    label = "Effacer recherché",  color = "success" },
            { id = "add_wanted",    type = "button",    label = "Ajouter étoile",     color = "warning" },
        }
    })
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Registre des sous-menus
-- ─────────────────────────────────────────────────────────────────────────────

local submenus = {
    admin           = menuPrincipal,
    admin_joueurs   = menuJoueurs,
    admin_sanctions = menuSanctions,
    admin_veh       = menuVehicules,
    admin_veh_color = menuVehColor,
    admin_monde     = menuMonde,
    admin_tp        = menuTeleport,
    admin_perso     = menuPerso,
    admin_armes     = menuArmes,
    admin_effets    = menuEffets,
}

AddEventHandler('k_menu:submenu', function(submenuId, _)
    local fn = submenus[submenuId]
    if fn then fn() end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Handler boutons
-- ─────────────────────────────────────────────────────────────────────────────

AddEventHandler('k_menu:button', function(id, _menuId)

    -- ── Véhicules ──────────────────────────────────────────────────────────
    if     id == "del_veh_near"  then TriggerServerEvent('k_menu:admin', 'deleteNear')
    elseif id == "fix_veh"       then TriggerServerEvent('k_menu:admin', 'fixVeh')
    elseif id == "del_veh"       then TriggerServerEvent('k_menu:admin', 'delVeh')
    elseif id == "boost_veh"     then TriggerServerEvent('k_menu:admin', 'boostVeh')
    elseif id == "spawn_veh"     then TriggerServerEvent('k_menu:admin', 'spawnVeh', Menu.input("veh_model"))
    elseif id == "cat_sport"     then TriggerServerEvent('k_menu:admin', 'spawnCat', 'sport')
    elseif id == "cat_super"     then TriggerServerEvent('k_menu:admin', 'spawnCat', 'super')
    elseif id == "cat_suv"       then TriggerServerEvent('k_menu:admin', 'spawnCat', 'suv')
    elseif id == "cat_moto"      then TriggerServerEvent('k_menu:admin', 'spawnCat', 'moto')
    elseif id == "cat_heli"      then TriggerServerEvent('k_menu:admin', 'spawnCat', 'heli')
    elseif id == "cat_avion"     then TriggerServerEvent('k_menu:admin', 'spawnCat', 'plane')
    elseif id == "cat_bateau"    then TriggerServerEvent('k_menu:admin', 'spawnCat', 'boat')
    elseif id == "cat_tank"      then TriggerServerEvent('k_menu:admin', 'spawnCat', 'tank')

    -- Couleurs véh (local, pas besoin serveur)
    elseif id == "vc_noir"       then TriggerEvent('k_menu:localVehColor', 0,   0)
    elseif id == "vc_blanc"      then TriggerEvent('k_menu:localVehColor', 134, 134)
    elseif id == "vc_rouge"      then TriggerEvent('k_menu:localVehColor', 27,  27)
    elseif id == "vc_bleu"       then TriggerEvent('k_menu:localVehColor', 64,  64)
    elseif id == "vc_vert"       then TriggerEvent('k_menu:localVehColor', 53,  53)
    elseif id == "vc_or"         then TriggerEvent('k_menu:localVehColor', 99,  99)
    elseif id == "vc_chrome"     then TriggerEvent('k_menu:localVehColor', 120, 120)

    -- ── Joueurs ────────────────────────────────────────────────────────────
    elseif id == "list_all"      then TriggerServerEvent('k_menu:admin', 'listPlayers')
    elseif id == "heal_all"      then TriggerServerEvent('k_menu:admin', 'healAll')
    elseif id == "revive_all"    then TriggerServerEvent('k_menu:admin', 'reviveAll')
    elseif id == "freeze_all"    then TriggerServerEvent('k_menu:admin', 'freezeAll')
    elseif id == "unfreeze_all"  then TriggerServerEvent('k_menu:admin', 'unfreezeAll')
    elseif id == "tp_to"         then TriggerServerEvent('k_menu:admin', 'tpToPlayer',  tonumber(Menu.input("target_id")))
    elseif id == "bring"         then TriggerServerEvent('k_menu:admin', 'bring',        tonumber(Menu.input("target_id")))
    elseif id == "heal_p"        then TriggerServerEvent('k_menu:admin', 'healPlayer',   tonumber(Menu.input("target_id")))
    elseif id == "revive_p"      then TriggerServerEvent('k_menu:admin', 'revivePlayer', tonumber(Menu.input("target_id")))
    elseif id == "freeze_p"      then TriggerServerEvent('k_menu:admin', 'freezePlayer', tonumber(Menu.input("target_id")))
    elseif id == "spectate"      then TriggerServerEvent('k_menu:admin', 'spectate',     tonumber(Menu.input("target_id")))
    elseif id == "copy_coords"   then TriggerServerEvent('k_menu:admin', 'getPlayerCoords', tonumber(Menu.input("target_id")))
    elseif id == "get_id"        then TriggerServerEvent('k_menu:admin', 'getIdentifiers', tonumber(Menu.input("sanc_id")))

    -- ── Sanctions ──────────────────────────────────────────────────────────
    elseif id == "kick"          then TriggerServerEvent('k_menu:adminKick',    tonumber(Menu.input("sanc_id")), Menu.input("sanc_raison"))
    elseif id == "ban_temp"      then TriggerServerEvent('k_menu:adminBanTemp', tonumber(Menu.input("sanc_id")), Menu.input("sanc_raison"), tonumber(Menu.input("sanc_duree")))
    elseif id == "ban_perm"      then TriggerServerEvent('k_menu:adminBanPerm', tonumber(Menu.input("sanc_id")), Menu.input("sanc_raison"))
    elseif id == "warn"          then TriggerServerEvent('k_menu:admin', 'warn', tonumber(Menu.input("sanc_id")), Menu.input("sanc_raison"))

    -- ── Téléportation prédéfinie ───────────────────────────────────────────
    elseif id == "tp_lsia"       then TriggerServerEvent('k_menu:admin', 'tpTo', -1037.7, -2738.5, 20.2)
    elseif id == "tp_pillbox"    then TriggerServerEvent('k_menu:admin', 'tpTo',   357.8,  -594.0, 28.7)
    elseif id == "tp_paleto"     then TriggerServerEvent('k_menu:admin', 'tpTo',  -243.4,  6331.3, 32.4)
    elseif id == "tp_sandy"      then TriggerServerEvent('k_menu:admin', 'tpTo',  1853.0,  3686.5, 34.3)
    elseif id == "tp_zancudo"    then TriggerServerEvent('k_menu:admin', 'tpTo', -2047.6,  3132.1, 32.8)
    elseif id == "tp_lspd"       then TriggerServerEvent('k_menu:admin', 'tpTo',   441.8,  -980.0, 30.7)
    elseif id == "tp_prison"     then TriggerServerEvent('k_menu:admin', 'tpTo',  1667.9,  2525.5, 45.6)
    elseif id == "tp_maze"       then TriggerServerEvent('k_menu:admin', 'tpTo',  -75.0,  -818.0, 326.2)
    elseif id == "tp_vinewood"   then TriggerServerEvent('k_menu:admin', 'tpTo',   -443.0, 1200.0, 326.0)
    elseif id == "tp_port"       then TriggerServerEvent('k_menu:admin', 'tpTo',  -448.0, -2766.0, 6.0)
    elseif id == "tp_go"         then
        local x = tonumber(Menu.input("tp_x")) or 0.0
        local y = tonumber(Menu.input("tp_y")) or 0.0
        local z = tonumber(Menu.input("tp_z")) or 0.0
        TriggerServerEvent('k_menu:admin', 'tpTo', x, y, z)
    elseif id == "tp_waypoint"   then TriggerEvent('k_menu:localTpWaypoint')
    elseif id == "print_coords"  then TriggerEvent('k_menu:localPrintCoords')

    -- ── Météo ──────────────────────────────────────────────────────────────
    elseif id == "w_sun"         then TriggerServerEvent('k_menu:admin', 'weather', 'EXTRASUNNY')
    elseif id == "w_cloud"       then TriggerServerEvent('k_menu:admin', 'weather', 'CLOUDS')
    elseif id == "w_rain"        then TriggerServerEvent('k_menu:admin', 'weather', 'RAIN')
    elseif id == "w_thunder"     then TriggerServerEvent('k_menu:admin', 'weather', 'THUNDER')
    elseif id == "w_snow"        then TriggerServerEvent('k_menu:admin', 'weather', 'XMAS')
    elseif id == "w_fog"         then TriggerServerEvent('k_menu:admin', 'weather', 'FOGGY')
    elseif id == "w_xmas"        then TriggerServerEvent('k_menu:admin', 'weather', 'XMAS')
    elseif id == "w_halloween"   then TriggerServerEvent('k_menu:admin', 'weather', 'HALLOWEEN')
    elseif id == "set_time"      then
        TriggerServerEvent('k_menu:admin', 'setTime',
            tonumber(Menu.input("time_h")) or 12,
            tonumber(Menu.input("time_m")) or 0)
    elseif id == "t_midi"        then TriggerServerEvent('k_menu:admin', 'setTime', 12, 0)
    elseif id == "t_minuit"      then TriggerServerEvent('k_menu:admin', 'setTime', 0,  0)
    elseif id == "t_aube"        then TriggerServerEvent('k_menu:admin', 'setTime', 6,  0)
    elseif id == "t_soir"        then TriggerServerEvent('k_menu:admin', 'setTime', 20, 0)

    -- ── Noclip ─────────────────────────────────────────────────────────────
    elseif id == "noclip"        then TriggerServerEvent('k_menu:admin', 'noclip')

    -- ── Personnage ─────────────────────────────────────────────────────────
    elseif id == "heal_me"       then TriggerServerEvent('k_menu:admin', 'healSelf')
    elseif id == "revive_me"     then TriggerServerEvent('k_menu:admin', 'reviveSelf')
    elseif id == "set_armor"     then TriggerEvent('k_menu:localSetArmor')
    elseif id == "anim_danse"    then TriggerEvent('k_menu:localAnim', 'anim@amb@nightclub@dancers@crowddance_factoredist@hi@male@', 'hi_dance_factoredist_crowd_16_v2_male^6')
    elseif id == "anim_assis"    then TriggerEvent('k_menu:localAnim', 'amb@world_human_seat_steps@male@idle_a', 'idle_a')
    elseif id == "anim_stop"     then TriggerEvent('k_menu:localAnimStop')
    elseif id == "apply_skin"    then TriggerEvent('k_menu:localSkin', Menu.input("skin_model"))
    elseif id == "reset_skin"    then TriggerEvent('k_menu:localSkin', 'mp_m_freemode_01')
    elseif id == "fx_ragdoll"    then TriggerEvent('k_menu:localRagdoll')

    -- ── Armes ──────────────────────────────────────────────────────────────
    elseif id == "kit_combat"    then TriggerServerEvent('k_menu:admin', 'weaponKit', 'combat')
    elseif id == "kit_sniper"    then TriggerServerEvent('k_menu:admin', 'weaponKit', 'sniper')
    elseif id == "kit_tout"      then TriggerServerEvent('k_menu:admin', 'weaponKit', 'all')
    elseif id == "give_weapon"   then
        TriggerServerEvent('k_menu:admin', 'giveWeapon',
            Menu.input("arme_name"),
            tonumber(Menu.input("arme_ammo")) or 999)
    elseif id == "remove_all"    then TriggerServerEvent('k_menu:admin', 'removeWeapons')

    -- ── Effets visuels ─────────────────────────────────────────────────────
    elseif id == "fx_night"      then TriggerEvent('k_menu:localNightVision', true)
    elseif id == "fx_thermal"    then TriggerEvent('k_menu:localThermal', true)
    elseif id == "fx_normal"     then
        TriggerEvent('k_menu:localNightVision', false)
        TriggerEvent('k_menu:localThermal', false)
    elseif id == "clear_wanted"  then TriggerServerEvent('k_menu:admin', 'clearWanted')
    elseif id == "add_wanted"    then TriggerServerEvent('k_menu:admin', 'addWanted')
    end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Handler toggles
-- ─────────────────────────────────────────────────────────────────────────────

AddEventHandler('k_menu:toggle', function(id, value, _)
    if     id == "godmode"       then TriggerServerEvent('k_menu:admin', 'godMode',      value)
    elseif id == "invisible"     then TriggerServerEvent('k_menu:admin', 'invisible',    value)
    elseif id == "speedboost"    then TriggerServerEvent('k_menu:admin', 'speedBoost',   value)
    elseif id == "freeze_t"      then TriggerServerEvent('k_menu:admin', 'freezeTime',   value)
    elseif id == "veh_invincible" then TriggerEvent('k_menu:localVehInvincible',         value)
    elseif id == "infini_ammo"   then TriggerEvent('k_menu:localInfiniAmmo',             value)
    elseif id == "super_jump"    then TriggerEvent('k_menu:localSuperJump',              value)
    elseif id == "fast_run"      then TriggerEvent('k_menu:localFastRun',                value)
    elseif id == "supergravite"  then TriggerEvent('k_menu:localGravity',                value)
    elseif id == "fx_drunk"      then TriggerEvent('k_menu:localDrunk',                  value)
    end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Handlers locaux (effets sans passer par le serveur)
-- ─────────────────────────────────────────────────────────────────────────────

-- Couleur véhicule
AddEventHandler('k_menu:localVehColor', function(primary, secondary)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if DoesEntityExist(veh) then
        SetVehicleColours(veh, primary, secondary)
    end
end)

-- Véhicule invincible
local vehInvincible = false
AddEventHandler('k_menu:localVehInvincible', function(value)
    vehInvincible = value
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(vehInvincible and 1000 or 2000)
        if vehInvincible then
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            if DoesEntityExist(veh) then
                SetVehicleCanBeVisiblyDamaged(veh, false)
                SetVehicleEngineCanDegrade(veh, false)
            end
        end
    end
end)

-- Armure
AddEventHandler('k_menu:localSetArmor', function()
    SetPedArmour(PlayerPedId(), 100)
end)

-- Munitions infinies
local infiniAmmo = false
AddEventHandler('k_menu:localInfiniAmmo', function(value)
    infiniAmmo = value
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(infiniAmmo and 0 or 500)
        if infiniAmmo then
            SetPedInfiniteAmmoClip(PlayerPedId(), true)
        end
    end
end)

-- Super saut
local superJumpActive = false
AddEventHandler('k_menu:localSuperJump', function(value)
    superJumpActive = value
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(superJumpActive and 0 or 500)
        if superJumpActive then
            SetSuperJumpThisFrame(PlayerPedId())
        end
    end
end)

-- Courir vite
local fastRunActive = false
AddEventHandler('k_menu:localFastRun', function(value)
    fastRunActive = value
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(fastRunActive and 0 or 500)
        if fastRunActive then
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
        else
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
        end
    end
end)

-- Gravité réduite
local lowGravity = false
AddEventHandler('k_menu:localGravity', function(value)
    lowGravity = value
    SetGravityLevel(value and 1 or 0)
end)

-- Vision nocturne
AddEventHandler('k_menu:localNightVision', function(value)
    SetNightvision(value)
end)

-- Vision thermique
AddEventHandler('k_menu:localThermal', function(value)
    SetThermalVision(value)
end)

-- Animation
AddEventHandler('k_menu:localAnim', function(dict, anim)
    local ped = PlayerPedId()
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Citizen.Wait(10) end
    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 1, 0.0, false, false, false)
end)

AddEventHandler('k_menu:localAnimStop', function()
    ClearPedTasks(PlayerPedId())
end)

-- Ragdoll
AddEventHandler('k_menu:localRagdoll', function()
    SetPedToRagdoll(PlayerPedId(), 3000, 3000, 0, false, false, false)
end)

-- Skin
AddEventHandler('k_menu:localSkin', function(model)
    if not model or model == "" then return end
    local hash = GetHashKey(model)
    RequestModel(hash)
    while not HasModelLoaded(hash) do Citizen.Wait(10) end
    SetPlayerModel(PlayerId(), hash)
    SetModelAsNoLongerNeeded(hash)
    TriggerEvent('kt_lib:notify', { title = 'Admin', description = 'Modèle : ' .. model, type = 'success' })
end)

-- TP au waypoint
AddEventHandler('k_menu:localTpWaypoint', function()
    local blip = GetFirstBlipInfoId(8)
    if DoesBlipExist(blip) then
        local coords = GetBlipInfoIdCoord(blip)
        local ped = PlayerPedId()
        local groundZ = 0.0
        -- Cherche le sol autour du waypoint
        for i = 0, 10 do
            local found, z = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z + i * 5.0, true)
            if found then groundZ = z break end
        end
        SetEntityCoords(ped, coords.x, coords.y, groundZ + 1.0, false, false, false, true)
        TriggerEvent('kt_lib:notify', { title = 'Admin', description = 'TP au waypoint.', type = 'success' })
    else
        TriggerEvent('kt_lib:notify', { title = 'Admin', description = 'Aucun waypoint défini.', type = 'error' })
    end
end)

-- Afficher coords
AddEventHandler('k_menu:localPrintCoords', function()
    local coords = GetEntityCoords(PlayerPedId())
    TriggerEvent('kt_lib:notify', {
        title = 'Coords',
        description = ("X: %.1f | Y: %.1f | Z: %.1f"):format(coords.x, coords.y, coords.z),
        type = 'info'
    })
end)

-- Ivre
AddEventHandler('k_menu:localDrunk', function(value)
    if value then
        AnimpostfxPlay("DrugsMichaelAliensFightIn", 0, true)
        SetPedMotionBlur(PlayerPedId(), true)
    else
        AnimpostfxStop("DrugsMichaelAliensFightIn")
        SetPedMotionBlur(PlayerPedId(), false)
    end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Commande admin
-- ─────────────────────────────────────────────────────────────────────────────

RegisterCommand('admin', function()
    if Menu.isOpen() then
        Menu.close()
        return
    end
    TriggerServerEvent('k_menu:checkAdmin')
end, false)

RegisterKeyMapping('admin', 'Ouvrir Menu Admin', 'keyboard', Config.AdminKey)

RegisterNetEvent('k_menu:openAdmin', function()
    menuPrincipal()
end)

print("^2[k_menu] Admin V3 client chargé^7")