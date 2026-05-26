-- server/admin.lua

local frozenH, frozenM = 12, 0

-- ─────────────────────────────────────────────────────────────────────────────
-- Helpers
-- ─────────────────────────────────────────────────────────────────────────────

local function isAdmin(src)
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        for _, adminId in ipairs(Config.Admins) do
            if id == adminId then return true end
        end
    end
    return false
end

local function notify(src, msg, ntype)
    TriggerClientEvent('kt_lib:notify', src, {
        title       = 'Admin',
        description = msg,
        type        = ntype or 'info',
    })
end

local function deny(src)
    notify(src, "Permission refusée.", 'error')
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Vérification admin
-- ─────────────────────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:checkAdmin', function()
    local src = source
    if isAdmin(src) then
        TriggerClientEvent('k_menu:openAdmin', src)
    else
        notify(src, "Vous n'avez pas les droits admin.", 'error')
    end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Handler principal
-- ─────────────────────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:admin', function(action, a1, a2, a3)
    local src = source
    if not isAdmin(src) then deny(src) return end

    -- Joueurs
    if action == 'listPlayers' then
        local list = {}
        for _, id in ipairs(GetPlayers()) do
            list[#list+1] = ("[%s] %s"):format(id, GetPlayerName(id))
        end
        notify(src, table.concat(list, "\n"), 'info')

    elseif action == 'healAll' then
        for _, id in ipairs(GetPlayers()) do
            TriggerClientEvent('k_menu:fx:heal', tonumber(id))
        end
        notify(src, "Tous les joueurs soignés.", 'success')

    elseif action == 'freezeAll' then
        for _, id in ipairs(GetPlayers()) do
            if tonumber(id) ~= src then
                TriggerClientEvent('k_menu:fx:freeze', tonumber(id), true)
            end
        end
        notify(src, "Tous les joueurs freezés.", 'success')

    elseif action == 'tpToPlayer' then TriggerClientEvent('k_menu:fx:tpTo', src, GetEntityCoords(GetPlayerPed(a1)))
    elseif action == 'bring'       then TriggerClientEvent('k_menu:fx:tpTo', a1, GetEntityCoords(GetPlayerPed(src)))
    elseif action == 'healPlayer'  then TriggerClientEvent('k_menu:fx:heal', a1)
    elseif action == 'revivePlayer'then TriggerClientEvent('k_menu:fx:revive', a1)
    elseif action == 'spectate'    then TriggerClientEvent('k_menu:fx:spectate', src)

    -- Outils
    elseif action == 'godMode'    then TriggerClientEvent('k_menu:fx:godMode',    src, a1)
    elseif action == 'invisible'  then TriggerClientEvent('k_menu:fx:invisible',  src, a1)
    elseif action == 'speedBoost' then TriggerClientEvent('k_menu:fx:speedBoost', src, a1)
    elseif action == 'noclip'     then TriggerClientEvent('k_menu:fx:noclip',     src)

    -- Véhicules
    elseif action == 'spawnVeh'  then TriggerClientEvent('k_menu:fx:spawnVeh',  src, a1 or 'adder')
    elseif action == 'spawnCat'  then
        local cats = {
            sport = 'adder', suv = 'granger', moto = 'bati801',
            heli  = 'maverick', plane = 'lazer',
        }
        TriggerClientEvent('k_menu:fx:spawnVeh', src, cats[a1] or 'adder')
    elseif action == 'fixVeh'    then TriggerClientEvent('k_menu:fx:fixVeh',    src)
    elseif action == 'delVeh'    then TriggerClientEvent('k_menu:fx:delVeh',    src)
    elseif action == 'deleteNear'then TriggerClientEvent('k_menu:fx:deleteNear',src)

    -- Téléportation
    elseif action == 'tpTo' then TriggerClientEvent('k_menu:fx:tpTo', src, a1, a2, a3)

    -- Météo (broadcast)
    elseif action == 'weather' then
        TriggerClientEvent('k_menu:fx:weather', -1, a1)
        notify(src, "Météo : " .. a1, 'success')

    -- Heure (broadcast)
    elseif action == 'setTime' then
        frozenH = math.max(0, math.min(23, tonumber(a1) or 12))
        frozenM = math.max(0, math.min(59, tonumber(a2) or 0))
        TriggerClientEvent('k_menu:fx:time', -1, frozenH, frozenM)
        notify(src, ("Heure : %02d:%02d"):format(frozenH, frozenM), 'success')

    elseif action == 'freezeTime' then
        TriggerClientEvent('k_menu:fx:freezeTime', -1, a1, frozenH, frozenM)

    -- Warn
    elseif action == 'warn' then
        notify(a1, "Avertissement de l'admin : " .. (a2 or ""), 'warning')
        notify(src, "Warn envoyé à " .. tostring(a1), 'success')
    end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Kick / Ban
-- ─────────────────────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:adminKick', function(targetId, reason)
    local src = source
    if not isAdmin(src) then deny(src) return end
    DropPlayer(targetId, "Kick : " .. (reason or "Aucune raison"))
    notify(src, "Joueur " .. tostring(targetId) .. " kické.", 'success')
end)

RegisterNetEvent('k_menu:adminBanTemp', function(targetId, reason)
    local src = source
    if not isAdmin(src) then deny(src) return end
    -- Intégrer ici ton système de ban (ex: oxmysql, ESX ban, etc.)
    DropPlayer(targetId, "Ban temporaire : " .. (reason or ""))
    notify(src, "Joueur banni temporairement.", 'success')
end)

RegisterNetEvent('k_menu:adminBanPerm', function(targetId, reason)
    local src = source
    if not isAdmin(src) then deny(src) return end
    DropPlayer(targetId, "BAN PERMANENT : " .. (reason or ""))
    print(("^1[admin] BAN PERM : %s par %s^7"):format(
        GetPlayerName(targetId), GetPlayerName(src)))
    notify(src, "Joueur banni définitivement.", 'success')
end)

print("^2[k_menu] Admin serveur chargé^7")
