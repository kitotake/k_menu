-- client/admin_effects.lua
-- Effets locaux reçus depuis le serveur

local godMode     = false
local invisible   = false
local noclipOn    = false
local speedBoost  = false

-- ============================================================
-- 🔹 GOD MODE
-- ============================================================
RegisterNetEvent('k_menu:adminGodMode', function()
    godMode = not godMode
    SetEntityInvincible(PlayerPedId(), godMode)
    TriggerEvent('kt_lib:notify', { title = 'Admin', description = godMode and "God Mode ON" or "God Mode OFF", type = 'info' })
end)

-- ============================================================
-- 🔹 INVISIBLE
-- ============================================================
RegisterNetEvent('k_menu:adminInvisible', function()
    invisible = not invisible
    SetEntityVisible(PlayerPedId(), not invisible, false)
    TriggerEvent('kt_lib:notify', { title = 'Admin', description = invisible and "Invisible ON" or "Invisible OFF", type = 'info' })
end)


-- ============================================================
-- 🔹 HEAL / REVIVE
-- ============================================================
RegisterNetEvent('k_menu:adminHeal', function()
    local ped = PlayerPedId()
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    SetPedArmour(ped, 100)
end)

RegisterNetEvent('k_menu:adminHealTarget', function()
    -- Côté admin : tp vers la cible et la soigne
    -- À implémenter avec ton système joueur ciblé
end)

RegisterNetEvent('k_menu:adminReviveTarget', function()
    -- Revive cible
end)

-- ============================================================
-- 🔹 FREEZE
-- ============================================================
RegisterNetEvent('k_menu:adminFreeze', function(frozen)
    FreezeEntityPosition(PlayerPedId(), frozen)
end)

-- ============================================================
-- 🔹 TÉLÉPORTATION
-- ============================================================
RegisterNetEvent('k_menu:adminTpTo', function(x, y, z)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)

    if DoesEntityExist(veh) then
        SetEntityCoords(veh, x, y, z, false, false, false, true)
    else
        SetEntityCoords(ped, x, y, z, false, false, false, true)
    end

    TriggerEvent('kt_lib:notify', { title = 'Téléportation', description = 'Téléporté !', type = 'success' })
end)

RegisterNetEvent('k_menu:adminTpToPlayer', function()
    -- TP vers le joueur dont l'ID est dans adminInputs["p4"]
    -- À adapter selon ton système
end)

RegisterNetEvent('k_menu:adminBringPlayer', function()
    -- Ramène la cible vers l'admin
end)

RegisterNetEvent('k_menu:adminTpToCoords', function()
    -- Lit les inputs tp9/tp10/tp11
end)

-- ============================================================
-- 🔹 SPECTATE
-- ============================================================
local spectating = false

RegisterNetEvent('k_menu:adminSpectate', function()
    spectating = not spectating
    NetworkSetInSpectatorMode(spectating, GetPlayerPed(-1))
    TriggerEvent('kt_lib:notify', { title = 'Spectate', description = spectating and "Spectate ON" or "Spectate OFF", type = 'info' })
end)

-- ============================================================
-- 🔹 VÉHICULES
-- ============================================================
RegisterNetEvent('k_menu:adminSpawnVehicle', function()
    -- Le modèle est dans adminInputs["v1"] côté admin
    -- À récupérer via le callback ou un event dédié
end)

RegisterNetEvent('k_menu:adminSpawnCategory', function(category)
    local models = {
        sport = { "adder", "zentorno", "t20", "pfister811", "krieger" },
        suv   = { "baller", "granger", "fq2", "rebla", "cavalcade2" },
        moto  = { "bati801", "carbonrs", "hakuchou2", "shotaro", "ruffian" },
        heli  = { "buzzard2", "maverick", "valkyrie", "frogger", "akula" },
        plane = { "lazer", "hydra", "besra", "cuban800", "velum" },
        boat  = { "yacht", "dinghy", "jetmax", "speeder2", "squalo" },
    }

    local list = models[category]
    if not list then return end

    -- Ouvre un menu de sélection
    -- Pour l'instant, spawn le premier de la liste
    local model = list[1]
    local hash  = GetHashKey(model)

    RequestModel(hash)
    while not HasModelLoaded(hash) do Citizen.Wait(10) end

    local coords = GetEntityCoords(PlayerPedId())
    local veh    = CreateVehicle(hash, coords.x + 3.0, coords.y, coords.z, GetEntityHeading(PlayerPedId()), true, false)
    SetPedIntoVehicle(PlayerPedId(), veh, -1)
    SetModelAsNoLongerNeeded(hash)

    TriggerEvent('kt_lib:notify', { title = 'Véhicule', description = model .. " spawné.", type = 'success' })
end)

RegisterNetEvent('k_menu:adminFixVehicle', function()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if DoesEntityExist(veh) then
        SetVehicleFixed(veh)
        SetVehicleEngineHealth(veh, 1000.0)
        SetVehicleBodyHealth(veh, 1000.0)
        TriggerEvent('kt_lib:notify', { title = 'Véhicule', description = "Véhicule réparé.", type = 'success' })
    end
end)

RegisterNetEvent('k_menu:adminDeleteMyVehicle', function()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if DoesEntityExist(veh) then
        DeleteVehicle(veh)
        TriggerEvent('kt_lib:notify', { title = 'Véhicule', description = "Véhicule supprimé.", type = 'success' })
    end
end)

RegisterNetEvent('k_menu:adminDeleteNearVehicles', function()
    local coords = GetEntityCoords(PlayerPedId())
    local vehs   = GetGamePool('CVehicle')
    local count  = 0
    for _, veh in ipairs(vehs) do
        if #(GetEntityCoords(veh) - coords) < 30.0 and not IsPedInVehicle(PlayerPedId(), veh, false) then
            DeleteVehicle(veh)
            count = count + 1
        end
    end
    TriggerEvent('kt_lib:notify', { title = 'Véhicules', description = count .. " véhicule(s) supprimé(s).", type = 'success' })
end)

-- ============================================================
-- 🔹 MÉTÉO
-- ============================================================
RegisterNetEvent('k_menu:adminSetWeather', function(weather)
    SetWeatherTypePersist(weather)
    SetWeatherTypeNowPersist(weather)
    SetWeatherTypeNow(weather)
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist(weather)
    SetWeatherTypeNowPersist(weather)
end)

-- ============================================================
-- 🔹 HEURE
-- ============================================================
RegisterNetEvent('k_menu:adminSetTime', function()
    -- À lire depuis adminInputs["w8"] (h) et adminInputs["w9"] (min)
    -- Envoyer via un event dédié
end)

RegisterNetEvent('k_menu:adminFreezeTime', function(frozen, h, m)
    if frozen then
        NetworkOverrideClockTime(h, m, 0)
    end
    -- Si dégelé, ne plus appeler NetworkOverrideClockTime
end)

-- ============================================================
-- 🔹 SANCTIONS (kick/ban — exécutées depuis le client admin)
-- ============================================================
RegisterNetEvent('k_menu:adminKick', function()
    -- Lit adminInputs["s0"] et adminInputs["s1"]
    -- TriggerServerEvent('k_menu:adminDoKick', targetId, reason)
end)

RegisterNetEvent('k_menu:adminPermban', function()
    -- TriggerServerEvent('k_menu:adminDoPermban', targetId, reason)
end)

RegisterNetEvent('k_menu:adminWarn', function()
    -- Envoie un message à la cible
end)

RegisterNetEvent('k_menu:adminMute', function()
    -- Silence le chat de la cible
end)

-- ============================================================
-- 🔹 SPEED BOOST
-- ============================================================
RegisterNetEvent('k_menu:adminSpeedBoost', function()
    speedBoost = not speedBoost
    TriggerEvent('kt_lib:notify', { title = 'Admin', description = speedBoost and "Speed Boost ON" or "Speed Boost OFF", type = 'info' })
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if speedBoost then
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            if DoesEntityExist(veh) then
                SetVehicleMaxSpeed(veh, 999.0)
                SetVehicleCheatPowerIncrease(veh, 10.0)
            end
        end
    end
end)

print("^2[k_menu] Admin Effects READY")