-- server/admin.lua
-- Gestion admin côté serveur

-- ============================================================
-- 🔹 CONFIG — liste des admins (Steam IDs ou License)
-- ============================================================
local ADMIN_IDS = {
    "license:5dd163d48114f6f827098ac7b57fdad1c087f5bb",
    "steam:11000010xxxxxxxx",
}

local timeFrozen = false
local frozenHour = 12
local frozenMin  = 0

-- ============================================================
-- 🔹 HELPERS
-- ============================================================
local function isAdmin(src)
    local ids = GetPlayerIdentifiers(src)
    for _, id in ipairs(ids) do
        for _, adminId in ipairs(ADMIN_IDS) do
            if id == adminId then return true end
        end
    end
    return false
end

local function notify(src, msg, type)
    TriggerClientEvent('kt_lib:notify', src, {
        title       = 'Admin',
        description = msg,
        type        = type or 'info'
    })
end

-- ============================================================
-- 🔹 VÉRIF ADMIN
-- ============================================================
RegisterNetEvent('k_menu:checkAdmin', function()
    local src = source
    if isAdmin(src) then
        TriggerClientEvent('k_menu:openAdmin', src)
    else
        notify(src, "Vous n'avez pas les permissions admin.", 'error')
    end
end)

-- ============================================================
-- 🔹 HANDLER PRINCIPAL
-- ============================================================
RegisterNetEvent('k_menu:admin', function(action, arg1, arg2, arg3)
    local src = source

    if not isAdmin(src) then
        notify(src, "Permission refusée.", 'error')
        return
    end

    print("^3[admin server] " .. GetPlayerName(src) .. " -> " .. action)

    -- ── Joueurs ─────────────────────────────────────────────
    if action == "listPlayers" then
        local list = "Joueurs connectés:\n"
        for _, id in ipairs(GetPlayers()) do
            list = list .. "[" .. id .. "] " .. GetPlayerName(id) .. "\n"
        end
        notify(src, list, 'info')

    elseif action == "freezeAll" then
        for _, id in ipairs(GetPlayers()) do
            if tonumber(id) ~= src then
                TriggerClientEvent('k_menu:adminFreeze', tonumber(id), true)
            end
        end
        notify(src, "Tous les joueurs ont été freezés.", 'success')

    elseif action == "healAll" then
        for _, id in ipairs(GetPlayers()) do
            TriggerClientEvent('k_menu:adminHeal', tonumber(id))
        end
        notify(src, "Tous les joueurs ont été soignés.", 'success')

    elseif action == "tpToPlayer" then
        TriggerClientEvent('k_menu:adminTpToPlayer', src)

    elseif action == "bringPlayer" then
        TriggerClientEvent('k_menu:adminBringPlayer', src)

    elseif action == "spectate" then
        TriggerClientEvent('k_menu:adminSpectate', src)

    elseif action == "healPlayer" then
        TriggerClientEvent('k_menu:adminHealTarget', src)

    elseif action == "revivePlayer" then
        TriggerClientEvent('k_menu:adminReviveTarget', src)

    elseif action == "giveMoney" then
        TriggerClientEvent('k_menu:adminGiveMoney', src)

    -- ── Sanctions ───────────────────────────────────────────
    elseif action == "kick" then
        TriggerClientEvent('k_menu:adminKick', src)

    elseif action == "tempban" then
        TriggerClientEvent('k_menu:adminTempban', src)

    elseif action == "permban" then
        TriggerClientEvent('k_menu:adminPermban', src)

    elseif action == "warn" then
        TriggerClientEvent('k_menu:adminWarn', src)

    elseif action == "mute" then
        TriggerClientEvent('k_menu:adminMute', src)

    -- ── Véhicules ───────────────────────────────────────────
    elseif action == "spawnVehicle" then
        TriggerClientEvent('k_menu:adminSpawnVehicle', src)

    elseif action == "spawnCategory" then
        TriggerClientEvent('k_menu:adminSpawnCategory', src, arg1)

    elseif action == "deleteNearVehicles" then
        TriggerClientEvent('k_menu:adminDeleteNearVehicles', src)

    elseif action == "deleteMyVehicle" then
        TriggerClientEvent('k_menu:adminDeleteMyVehicle', src)

    elseif action == "fixMyVehicle" then
        TriggerClientEvent('k_menu:adminFixVehicle', src)

    -- ── Téléportation ───────────────────────────────────────
    elseif action == "tpTo" then
        TriggerClientEvent('k_menu:adminTpTo', src, arg1, arg2, arg3)

    elseif action == "tpToCoords" then
        TriggerClientEvent('k_menu:adminTpToCoords', src)

    -- ── Outils ──────────────────────────────────────────────
    elseif action == "godMode" then
        TriggerClientEvent('k_menu:adminGodMode', src)

    elseif action == "invisible" then
        TriggerClientEvent('k_menu:adminInvisible', src)

    elseif action == "noclip" then
        TriggerClientEvent('k_menu:adminNoclip', src)

    elseif action == "speedBoost" then
        TriggerClientEvent('k_menu:adminSpeedBoost', src)

    -- ── Météo ────────────────────────────────────────────────
    elseif action == "setWeather" then
        TriggerClientEvent('k_menu:adminSetWeather', -1, arg1)
        notify(src, "Météo changée : " .. arg1, 'success')

    -- FIX: setTime reçoit maintenant h et m depuis le client
    elseif action == "setTime" then
        local h = tonumber(arg1) or 12
        local m = tonumber(arg2) or 0
        -- Clamp valeurs valides
        h = math.max(0, math.min(23, h))
        m = math.max(0, math.min(59, m))
        frozenHour = h
        frozenMin  = m
        TriggerClientEvent('k_menu:adminApplyTime', -1, h, m)
        notify(src, ("Heure définie : %02d:%02d"):format(h, m), 'success')

    elseif action == "freezeTime" then
        timeFrozen = arg1
        if timeFrozen then
            TriggerClientEvent('k_menu:adminFreezeTime', -1, true,  frozenHour, frozenMin)
            notify(src, "Temps gelé.", 'info')
        else
            TriggerClientEvent('k_menu:adminFreezeTime', -1, false, 0, 0)
            notify(src, "Temps dégelé.", 'info')
        end
    end
end)

-- ============================================================
-- 🔹 EVENTS côté serveur (kick / ban réels)
-- ============================================================
RegisterNetEvent('k_menu:adminDoKick', function(targetId, reason)
    local src = source
    if not isAdmin(src) then return end
    DropPlayer(targetId, "Kick Admin: " .. (reason or "Aucune raison"))
    notify(src, "Joueur " .. targetId .. " kické.", 'success')
end)

RegisterNetEvent('k_menu:adminDoPermban', function(targetId, reason)
    local src = source
    if not isAdmin(src) then return end
    DropPlayer(targetId, "BAN PERMANENT: " .. (reason or "Aucune raison"))
    print("^1[admin] BAN PERMANENT " .. GetPlayerName(targetId) .. " par " .. GetPlayerName(src))
    notify(src, "Joueur banni définitivement.", 'success')
end)

print("^2[k_menu] Admin Server READY")