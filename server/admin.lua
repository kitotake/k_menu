local frozenH, frozenM = 12, 0

-- ─────────────────────────────────────────────────────────────
-- HELPERS
-- ─────────────────────────────────────────────────────────────

local function getIdentifier(src)
    return GetPlayerIdentifierByType(src, 'license')
end

local function isAdmin(src)
    local identifier = GetPlayerIdentifierByType(src, 'license')
    if not identifier then return false end

    local p = promise.new()

    exports.oxmysql:single('SELECT `group` FROM users WHERE identifier = ?', {
        identifier
    }, function(result)
        p:resolve(result)
    end)

    local result = Citizen.Await(p)

    if not result or not result.group then return false end

    local group = string.lower(result.group)
    return group == 'admin' or group == 'superadmin'
end

local function notify(src, msg, ntype)
    TriggerClientEvent('kt_lib:notify', src, {
        title = 'Admin',
        description = msg,
        type = ntype or 'info',
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
-- ADMIN CHECK MENU
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

    if action == 'listPlayers' then
        local list = {}

        for _, id in ipairs(GetPlayers()) do
            list[#list+1] = ("[%s] %s"):format(id, GetPlayerName(id))
        end

        notify(src, table.concat(list, "\n"), "info")

    elseif action == 'healAll' then
        for _, id in ipairs(GetPlayers()) do
            TriggerClientEvent('k_menu:fx:heal', tonumber(id))
        end
        notify(src, "Tous les joueurs soignés.", "success")

    elseif action == 'freezeAll' then
        for _, id in ipairs(GetPlayers()) do
            if tonumber(id) ~= src then
                TriggerClientEvent('k_menu:fx:freeze', tonumber(id), true)
            end
        end
        notify(src, "Tous les joueurs freezés.", "success")

    elseif action == 'tpToPlayer' then
        local target = getPlayer(src, a1)
        if not target then return end

        local ped = GetPlayerPed(target)
        local coords = GetEntityCoords(ped)

        TriggerClientEvent('k_menu:fx:tpTo', src, coords.x, coords.y, coords.z)

    elseif action == 'bring' then
        local target = getPlayer(src, a1)
        if not target then return end

        local adminPed = GetPlayerPed(src)
        local coords = GetEntityCoords(adminPed)

        TriggerClientEvent('k_menu:fx:tpTo', target, coords.x, coords.y, coords.z)

    elseif action == 'healPlayer' then
        local target = getPlayer(src, a1)
        if not target then return end

        TriggerClientEvent('k_menu:fx:heal', target)

    elseif action == 'revivePlayer' then
        local target = getPlayer(src, a1)
        if not target then return end

        TriggerClientEvent('k_menu:fx:revive', target)

    elseif action == 'spectate' then
        TriggerClientEvent('k_menu:fx:spectate', src, a1)

    elseif action == 'godMode' then
        TriggerClientEvent('k_menu:fx:godMode', src, a1)

    elseif action == 'invisible' then
        TriggerClientEvent('k_menu:fx:invisible', src, a1)

    elseif action == 'speedBoost' then
        TriggerClientEvent('k_menu:fx:speedBoost', src, a1)

    elseif action == 'noclip' then
        TriggerClientEvent('k_menu:fx:noclip', src)

    elseif action == 'spawnVeh' then
        TriggerClientEvent('k_menu:fx:spawnVeh', src, a1 or 'adder')

    elseif action == 'spawnCat' then
        local cats = {
            sport = 'adder',
            suv = 'granger',
            moto = 'bati801',
            heli = 'maverick',
            plane = 'lazer',
        }

        TriggerClientEvent('k_menu:fx:spawnVeh', src, cats[a1] or 'adder')

    elseif action == 'fixVeh' then
        TriggerClientEvent('k_menu:fx:fixVeh', src)

    elseif action == 'delVeh' then
        TriggerClientEvent('k_menu:fx:delVeh', src)

    elseif action == 'deleteNear' then
        TriggerClientEvent('k_menu:fx:deleteNear', src)

    elseif action == 'tpTo' then
        TriggerClientEvent('k_menu:fx:tpTo', src, a1, a2, a3)

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
        notify(src, a1 and "Temps gelé." or "Temps dégelé.", "info")

    elseif action == 'warn' then
        local target = getPlayer(src, a1)
        if not target then return end

        TriggerClientEvent('kt_lib:notify', target, {
            title = 'Warning',
            description = a2 or "Avertissement admin",
            type = 'warning'
        })

        notify(src, "Warn envoyé à " .. target, "success")
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

    DropPlayer(targetId, "Kick : " .. (reason or "Aucune raison"))
    notify(src, "Joueur kické.", "success")
end)

RegisterNetEvent('k_menu:adminBanTemp', function(targetId, reason)
    local src = source
    if not isAdmin(src) then return deny(src) end

    targetId = tonumber(targetId)
    if not targetId or not GetPlayerName(targetId) then
        return notify(src, "ID invalide.", "error")
    end

    DropPlayer(targetId, "Ban temporaire : " .. (reason or ""))
    notify(src, "Joueur banni temporairement.", "success")
end)

RegisterNetEvent('k_menu:adminBanPerm', function(targetId, reason)
    local src = source
    if not isAdmin(src) then return deny(src) end

    targetId = tonumber(targetId)
    if not targetId or not GetPlayerName(targetId) then
        return notify(src, "ID invalide.", "error")
    end

    DropPlayer(targetId, "BAN PERMANENT : " .. (reason or ""))

    print(("^1[ADMIN] BAN PERM : %s par %s^7"):format(
        GetPlayerName(targetId),
        GetPlayerName(src)
    ))

    notify(src, "Joueur banni définitivement.", "success")
end)

-- ─────────────────────────────────────────────────────────────
-- DEBUG
-- ─────────────────────────────────────────────────────────────
RegisterCommand("admindebug", function(source)
    local src = source
    local identifier = GetPlayerIdentifierByType(src, 'license')

    print("=== ADMIN DEBUG ===")
    print("SRC:", src)
    print("LICENSE:", identifier)

    local result = exports.oxmysql:single_async(
        'SELECT `group` FROM users WHERE identifier = ?',
        { identifier }
    )

    print("GROUP:", result and result.group or "nil")
end)

print("^2[k_menu] Admin system V3 NO CACHE chargé^7")