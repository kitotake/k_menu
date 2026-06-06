-- server/admin.lua
-- Admin system V3 — kt_lib + kt_inventory

local frozenH, frozenM = 12, 0

-- ─────────────────────────────────────────────────────────────
-- HELPERS
-- ─────────────────────────────────────────────────────────────

---Vérifie si le joueur est admin via Config.Admins (hardcodé)
---puis via la colonne `group` en base (oxmysql).
local function isAdmin(src)
    local identifier = GetPlayerIdentifierByType(src, 'license')
    if not identifier then return false end

    -- 1. Vérif hardcodée (pas de requête SQL, idéal pour le dev/owner)
    for _, id in ipairs(Config.Admins) do
        if id == identifier then return true end
    end

    -- 2. Fallback base de données (group = admin | superadmin)
    local p = promise.new()
    exports.oxmysql:single(
        'SELECT `group` FROM users WHERE identifier = ?',
        { identifier },
        function(result) p:resolve(result) end
    )
    local result = Citizen.Await(p)
    if not result or not result.group then return false end
    local group = string.lower(result.group)
    return group == 'admin' or group == 'superadmin'
end

---Notification kt_lib côté client
local function notify(src, msg, ntype)
    TriggerClientEvent('kt_lib:notify', src, {
        title       = 'Admin',
        description = msg,
        type        = ntype or 'inform',
    })
end

local function deny(src)
    notify(src, "Permission refusée.", "error")
end

local function getPlayer(src, id)
    id = tonumber(id)
    if not id or not GetPlayerName(id) then
        notify(src, "Joueur introuvable.", "error")
        return nil
    end
    return id
end

-- ─────────────────────────────────────────────────────────────
-- Kits d'armes (items kt_inventory)
-- Chaque entrée : { itemName, quantité }
-- Les noms doivent correspondre aux items déclarés dans
-- kt_inventory/data/items.lua (ou votre override).
-- ─────────────────────────────────────────────────────────────

local WeaponKits = {
    combat = {
        { 'weapon_pistol',          1 },
        { 'weapon_combatpistol',    1 },
        { 'weapon_smg',             1 },
        { 'weapon_assaultrifle',    1 },
        { 'weapon_shotgun',         1 },
        { 'weapon_knife',           1 },
        { 'ammo_pistol',          250 },
        { 'ammo_smg',             500 },
        { 'ammo_rifle',           500 },
        { 'ammo_shotgun',         100 },
    },
    sniper = {
        { 'weapon_sniperrifle',     1 },
        { 'weapon_heavysniper',     1 },
        { 'weapon_pistol',          1 },
        { 'ammo_sniper',          200 },
        { 'ammo_pistol',          250 },
    },
    all = {
        -- Pistolets
        { 'weapon_pistol',          1 }, { 'weapon_pistol_mk2',      1 },
        { 'weapon_combatpistol',    1 }, { 'weapon_heavypistol',     1 },
        { 'weapon_stungun',         1 },
        -- SMG
        { 'weapon_smg',             1 }, { 'weapon_microsmg',        1 },
        -- Shotgun
        { 'weapon_shotgun',         1 }, { 'weapon_assaultshotgun',  1 },
        -- Fusils
        { 'weapon_assaultrifle',    1 }, { 'weapon_carbinerifle',    1 },
        { 'weapon_advancedrifle',   1 }, { 'weapon_specialcarbine',  1 },
        -- Sniper
        { 'weapon_sniperrifle',     1 }, { 'weapon_heavysniper',     1 },
        -- Lourdes
        { 'weapon_minigun',         1 }, { 'weapon_rpg',             1 },
        { 'weapon_grenadelauncher', 1 },
        -- Mêlée
        { 'weapon_knife',           1 }, { 'weapon_bat',             1 },
        { 'weapon_crowbar',         1 },
        -- Munitions
        { 'ammo_pistol',          500 }, { 'ammo_smg',             500 },
        { 'ammo_rifle',           500 }, { 'ammo_shotgun',         200 },
        { 'ammo_sniper',          200 }, { 'ammo_mg',              500 },
        { 'ammo_rpg',              10 },
    },
}

-- ─────────────────────────────────────────────────────────────
-- ADMIN CHECK
-- ─────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:checkAdmin', function()
    local src = source
    if isAdmin(src) then
        TriggerClientEvent('k_menu:openAdmin', src)
    else
        deny(src)
    end
end)

-- ─────────────────────────────────────────────────────────────
-- MAIN ADMIN EVENT
-- ─────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:admin', function(action, a1, a2, a3)
    local src = source
    if not isAdmin(src) then return deny(src) end

    -- ── Joueurs ────────────────────────────────────────────────────────────

    if action == 'listPlayers' then
        local list = {}
        for _, id in ipairs(GetPlayers()) do
            list[#list + 1] = ("[%s] %s"):format(id, GetPlayerName(id))
        end
        notify(src, table.concat(list, "\n"), "inform")

    elseif action == 'healAll' then
        for _, id in ipairs(GetPlayers()) do
            TriggerClientEvent('k_menu:fx:heal', tonumber(id))
        end
        notify(src, "Tous les joueurs soignés.", "success")

    elseif action == 'reviveAll' then
        for _, id in ipairs(GetPlayers()) do
            TriggerClientEvent('k_menu:fx:revive', tonumber(id))
        end
        notify(src, "Tous les joueurs revive.", "success")

    elseif action == 'freezeAll' then
        for _, id in ipairs(GetPlayers()) do
            if tonumber(id) ~= src then
                TriggerClientEvent('k_menu:fx:freeze', tonumber(id), true)
            end
        end
        notify(src, "Tous les joueurs freezés.", "success")

    elseif action == 'unfreezeAll' then
        for _, id in ipairs(GetPlayers()) do
            TriggerClientEvent('k_menu:fx:freeze', tonumber(id), false)
        end
        notify(src, "Tous les joueurs unfreezés.", "success")

    elseif action == 'tpToPlayer' then
        local target = getPlayer(src, a1)
        if not target then return end
        local coords = GetEntityCoords(GetPlayerPed(target))
        TriggerClientEvent('k_menu:fx:tpTo', src, coords.x, coords.y, coords.z)

    elseif action == 'bring' then
        local target = getPlayer(src, a1)
        if not target then return end
        local coords = GetEntityCoords(GetPlayerPed(src))
        TriggerClientEvent('k_menu:fx:tpTo', target, coords.x, coords.y, coords.z)
        notify(src, "Joueur ramené.", "success")

    elseif action == 'healPlayer' then
        local target = getPlayer(src, a1)
        if not target then return end
        TriggerClientEvent('k_menu:fx:heal', target)
        notify(src, ("Joueur [%d] soigné."):format(target), "success")

    elseif action == 'revivePlayer' then
        local target = getPlayer(src, a1)
        if not target then return end
        TriggerClientEvent('k_menu:fx:revive', target)
        notify(src, ("Joueur [%d] revive."):format(target), "success")

    elseif action == 'freezePlayer' then
        local target = getPlayer(src, a1)
        if not target then return end
        TriggerClientEvent('k_menu:fx:freeze', target, true)
        notify(src, ("Joueur [%d] freezé."):format(target), "success")

    elseif action == 'spectate' then
        TriggerClientEvent('k_menu:fx:spectate', src, a1)

    elseif action == 'getPlayerCoords' then
        local target = getPlayer(src, a1)
        if not target then return end
        local coords = GetEntityCoords(GetPlayerPed(target))
        notify(src,
            ("Coords [%d] %s\nX: %.2f | Y: %.2f | Z: %.2f")
            :format(target, GetPlayerName(target), coords.x, coords.y, coords.z),
            "inform"
        )

    elseif action == 'getIdentifiers' then
        local target = getPlayer(src, a1)
        if not target then return end
        local ids = {}
        for i = 0, GetNumPlayerIdentifiers(target) - 1 do
            ids[#ids + 1] = GetPlayerIdentifier(target, i)
        end
        notify(src,
            ("[%d] %s\n%s"):format(target, GetPlayerName(target), table.concat(ids, "\n")),
            "inform"
        )

    elseif action == 'healSelf' then
        TriggerClientEvent('k_menu:fx:heal', src)

    elseif action == 'reviveSelf' then
        TriggerClientEvent('k_menu:fx:revive', src)

    -- ── Outils ────────────────────────────────────────────────────────────

    elseif action == 'godMode' then
        TriggerClientEvent('k_menu:fx:godMode', src, a1)

    elseif action == 'invisible' then
        TriggerClientEvent('k_menu:fx:invisible', src, a1)

    elseif action == 'speedBoost' then
        TriggerClientEvent('k_menu:fx:speedBoost', src, a1)

    elseif action == 'noclip' then
        TriggerClientEvent('k_menu:fx:noclip', src)

    elseif action == 'clearWanted' then
        SetPlayerWantedLevel(src, 0, false)
        SetPlayerWantedLevelNow(src, false)
        notify(src, "Niveau recherché effacé.", "success")

    elseif action == 'addWanted' then
        local current = GetPlayerWantedLevel(src)
        SetPlayerWantedLevel(src, math.min(current + 1, 5), false)
        SetPlayerWantedLevelNow(src, false)
        notify(src, "Étoile ajoutée.", "warning")

    -- ── Véhicules ──────────────────────────────────────────────────────────

    elseif action == 'spawnVeh' then
        TriggerClientEvent('k_menu:fx:spawnVeh', src, a1 or 'adder')

    elseif action == 'spawnCat' then
        local cats = {
            sport  = 'adder',
            super  = 'zentorno',
            suv    = 'granger',
            moto   = 'bati801',
            heli   = 'maverick',
            plane  = 'lazer',
            boat   = 'dinghy',
            tank   = 'rhino',
        }
        TriggerClientEvent('k_menu:fx:spawnVeh', src, cats[a1] or 'adder')

    elseif action == 'fixVeh' then
        TriggerClientEvent('k_menu:fx:fixVeh', src)

    elseif action == 'delVeh' then
        TriggerClientEvent('k_menu:fx:delVeh', src)

    elseif action == 'deleteNear' then
        TriggerClientEvent('k_menu:fx:deleteNear', src)

    elseif action == 'boostVeh' then
        TriggerClientEvent('k_menu:fx:boostVeh', src)

    -- ── Armes via kt_inventory ─────────────────────────────────────────────
    -- kt_inventory gère l'inventaire côté serveur.
    -- On utilise exports.kt_inventory:AddItem pour ajouter l'item au joueur,
    -- puis on envoie un event client pour la notif visuelle uniquement.

    elseif action == 'giveWeapon' then
        -- a1 = nom de l'item arme (ex: 'weapon_pistol')
        -- a2 = quantité (défaut 1, les armes sont des items unitaires)
        local itemName = tostring(a1 or 'weapon_pistol'):lower()
        local qty = math.max(1, tonumber(a2) or 1)

        local success = exports.kt_inventory:AddItem(src, itemName, qty)
        if success then
            notify(src, ("Arme donnée : %s ×%d"):format(itemName, qty), "success")
            TriggerClientEvent('k_menu:fx:weaponGiven', src, itemName)
        else
            notify(src, "Échec : item introuvable dans kt_inventory (" .. itemName .. ")", "error")
        end

    elseif action == 'giveAmmo' then
        -- a1 = nom item munition (ex: 'ammo_pistol'), a2 = quantité
        local itemName = tostring(a1 or 'ammo_pistol'):lower()
        local qty = tonumber(a2) or 250

        local success = exports.kt_inventory:AddItem(src, itemName, qty)
        if success then
            notify(src, ("Munitions : %s ×%d"):format(itemName, qty), "success")
        else
            notify(src, "Échec : item introuvable (" .. itemName .. ")", "error")
        end

    elseif action == 'weaponKit' then
        -- a1 = nom du kit ('combat' | 'sniper' | 'all')
        local kit = WeaponKits[a1]
        if not kit then
            return notify(src, "Kit inconnu : " .. tostring(a1), "error")
        end

        local errors = {}
        for _, entry in ipairs(kit) do
            local itemName, qty = entry[1], entry[2]
            local ok = exports.kt_inventory:AddItem(src, itemName, qty)
            if not ok then
                errors[#errors + 1] = itemName
            end
        end

        if #errors == 0 then
            notify(src, ("Kit « %s » distribué."):format(a1), "success")
            TriggerClientEvent('k_menu:fx:weaponKitGiven', src, a1)
        else
            notify(src,
                ("Kit « %s » partiel. Items manquants :\n%s"):format(a1, table.concat(errors, ', ')),
                "warning"
            )
            TriggerClientEvent('k_menu:fx:weaponKitGiven', src, a1)
        end

    elseif action == 'removeWeapons' then
        -- Vide tous les items de type 'weapon_*' et 'ammo_*' de l'inventaire
        local inv = exports.kt_inventory:GetInventory(src)
        if inv and inv.items then
            for slot, item in pairs(inv.items) do
                if item and item.name then
                    local n = item.name:lower()
                    if n:sub(1, 7) == 'weapon_' or n:sub(1, 5) == 'ammo_' then
                        exports.kt_inventory:RemoveItem(src, item.name, item.count, nil, slot)
                    end
                end
            end
        end
        notify(src, "Armes et munitions retirées.", "success")
        TriggerClientEvent('k_menu:fx:weaponsRemoved', src)

    -- ── Téléportation ──────────────────────────────────────────────────────

    elseif action == 'tpTo' then
        TriggerClientEvent('k_menu:fx:tpTo', src, a1, a2, a3)

    -- ── Météo / Heure ──────────────────────────────────────────────────────

    elseif action == 'weather' then
        TriggerClientEvent('k_menu:fx:weather', -1, a1)
        notify(src, "Météo : " .. tostring(a1), "success")

    elseif action == 'setTime' then
        frozenH = math.max(0, math.min(23, tonumber(a1) or 12))
        frozenM = math.max(0, math.min(59, tonumber(a2) or 0))
        TriggerClientEvent('k_menu:fx:time', -1, frozenH, frozenM)
        notify(src, ("Heure : %02d:%02d"):format(frozenH, frozenM), "success")

    elseif action == 'freezeTime' then
        TriggerClientEvent('k_menu:fx:freezeTime', -1, a1, frozenH, frozenM)
        notify(src, a1 and "Temps gelé." or "Temps dégelé.", "inform")

    -- ── Warn ───────────────────────────────────────────────────────────────

    elseif action == 'warn' then
        local target = getPlayer(src, a1)
        if not target then return end
        TriggerClientEvent('kt_lib:notify', target, {
            title       = 'Warning',
            description = a2 or "Avertissement admin",
            type        = 'warning',
            duration    = 8000,
        })
        notify(src, ("Warn envoyé à [%d] %s."):format(target, GetPlayerName(target)), "success")
        print(("^3[ADMIN] WARN : [%d] %s par [%d] %s — %s^7"):format(
            target, GetPlayerName(target),
            src,    GetPlayerName(src),
            tostring(a2)
        ))
    end
end)

-- ─────────────────────────────────────────────────────────────
-- KICK / BAN
-- ─────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:adminKick', function(targetId, reason)
    local src = source
    if not isAdmin(src) then return deny(src) end
    targetId = tonumber(targetId)
    if not targetId or not GetPlayerName(targetId) then
        return notify(src, "ID invalide.", "error")
    end
    print(("^3[ADMIN] KICK : [%d] %s par [%d] %s^7"):format(
        targetId, GetPlayerName(targetId), src, GetPlayerName(src)
    ))
    DropPlayer(targetId, "Kick : " .. (reason or "Aucune raison"))
    notify(src, ("Joueur [%d] kické."):format(targetId), "success")
end)

RegisterNetEvent('k_menu:adminBanTemp', function(targetId, reason, hours)
    local src = source
    if not isAdmin(src) then return deny(src) end
    targetId = tonumber(targetId)
    if not targetId or not GetPlayerName(targetId) then
        return notify(src, "ID invalide.", "error")
    end
    hours = tonumber(hours) or 24
    print(("^1[ADMIN] BAN TEMP %dh : [%d] %s par [%d] %s^7"):format(
        hours, targetId, GetPlayerName(targetId), src, GetPlayerName(src)
    ))
    DropPlayer(targetId, ("Ban temporaire (%dh) : %s"):format(hours, reason or ""))
    notify(src, ("Joueur [%d] banni %dh."):format(targetId, hours), "success")
end)

RegisterNetEvent('k_menu:adminBanPerm', function(targetId, reason)
    local src = source
    if not isAdmin(src) then return deny(src) end
    targetId = tonumber(targetId)
    if not targetId or not GetPlayerName(targetId) then
        return notify(src, "ID invalide.", "error")
    end
    print(("^1[ADMIN] BAN PERM : [%d] %s par [%d] %s — %s^7"):format(
        targetId, GetPlayerName(targetId),
        src,      GetPlayerName(src),
        tostring(reason)
    ))
    DropPlayer(targetId, "BAN PERMANENT : " .. (reason or ""))
    notify(src, ("Joueur [%d] banni définitivement."):format(targetId), "success")
end)

-- ─────────────────────────────────────────────────────────────
-- DEBUG
-- ─────────────────────────────────────────────────────────────

RegisterCommand('admindebug', function(src)
    local identifier = GetPlayerIdentifierByType(src, 'license')
    print("=== ADMIN DEBUG ===")
    print("SRC:", src, "| LICENSE:", identifier)

    -- Vérif hardcodée
    local hardcoded = false
    for _, id in ipairs(Config.Admins) do
        if id == identifier then hardcoded = true break end
    end
    print("HARDCODED ADMIN:", hardcoded)

    -- Vérif SQL
    local result = exports.oxmysql:single_async(
        'SELECT `group` FROM users WHERE identifier = ?', { identifier }
    )
    print("DB GROUP:", result and result.group or "nil")
end, false)

print("^2[k_menu] Admin server V3 (kt_lib + kt_inventory) chargé^7")