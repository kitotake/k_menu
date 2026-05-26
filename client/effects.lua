-- client/effects.lua
-- Effets visuels et locaux reçus depuis le serveur

local state = {
    godMode    = false,
    invisible  = false,
    speedBoost = false,
    timeFrozen = false,
}

local function notify(msg, ntype)
    TriggerEvent('kt_lib:notify', { title = 'Admin', description = msg, type = ntype or 'info' })
end

-- ─────────────────────────────────────────────────────────────────────────────
-- God Mode
-- ─────────────────────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:fx:godMode', function(enabled)
    state.godMode = enabled
    SetEntityInvincible(PlayerPedId(), enabled)
    notify(enabled and "God Mode ON" or "God Mode OFF")
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Invisible
-- ─────────────────────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:fx:invisible', function(enabled)
    state.invisible = enabled
    SetEntityVisible(PlayerPedId(), not enabled, false)
    notify(enabled and "Invisible ON" or "Invisible OFF")
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Speed Boost
-- ─────────────────────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:fx:speedBoost', function(enabled)
    state.speedBoost = enabled
    notify(enabled and "Speed Boost ON" or "Speed Boost OFF")
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if state.speedBoost then
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            if DoesEntityExist(veh) then
                SetVehicleMaxSpeed(veh, 999.0)
                SetVehicleCheatPowerIncrease(veh, 10.0)
            end
        end
    end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Heal / Revive
-- ─────────────────────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:fx:heal', function()
    local ped = PlayerPedId()
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    SetPedArmour(ped, 100)
    notify("Soigné !", "success")
end)

RegisterNetEvent('k_menu:fx:revive', function()
    local ped = PlayerPedId()
    NetworkResurrectLocalPlayer(0, 0, 0, 0, true, false)
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    SetPedArmour(ped, 100)
    notify("Revive !", "success")
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Freeze
-- ─────────────────────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:fx:freeze', function(enabled)
    FreezeEntityPosition(PlayerPedId(), enabled)
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Téléportation
-- ─────────────────────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:fx:tpTo', function(x, y, z)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local entity = DoesEntityExist(veh) and veh or ped
    SetEntityCoords(entity, x, y, z, false, false, false, true)
    notify("Téléporté !", "success")
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Véhicules
-- ─────────────────────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:fx:spawnVeh', function(model)
    local hash = GetHashKey(model)
    RequestModel(hash)
    while not HasModelLoaded(hash) do Citizen.Wait(10) end
    local coords = GetEntityCoords(PlayerPedId())
    local veh = CreateVehicle(hash, coords.x + 3.0, coords.y, coords.z,
        GetEntityHeading(PlayerPedId()), true, false)
    SetPedIntoVehicle(PlayerPedId(), veh, -1)
    SetModelAsNoLongerNeeded(hash)
    notify(model .. " spawné.", "success")
end)

RegisterNetEvent('k_menu:fx:fixVeh', function()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if not DoesEntityExist(veh) then return end
    SetVehicleFixed(veh)
    SetVehicleEngineHealth(veh, 1000.0)
    SetVehicleBodyHealth(veh, 1000.0)
    notify("Véhicule réparé.", "success")
end)

RegisterNetEvent('k_menu:fx:delVeh', function()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if DoesEntityExist(veh) then DeleteVehicle(veh) end
    notify("Véhicule supprimé.", "success")
end)

RegisterNetEvent('k_menu:fx:deleteNear', function()
    local coords = GetEntityCoords(PlayerPedId())
    local count = 0
    for _, veh in ipairs(GetGamePool('CVehicle')) do
        if #(GetEntityCoords(veh) - coords) < 30.0
        and not IsPedInVehicle(PlayerPedId(), veh, false) then
            DeleteVehicle(veh)
            count = count + 1
        end
    end
    notify(count .. " véhicule(s) supprimé(s).", "success")
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Météo
-- ─────────────────────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:fx:weather', function(weather)
    SetWeatherTypePersist(weather)
    SetWeatherTypeNowPersist(weather)
    SetWeatherTypeNow(weather)
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Heure
-- ─────────────────────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:fx:time', function(h, m)
    NetworkOverrideClockTime(h, m, 0)
    notify(("Heure : %02d:%02d"):format(h, m), "success")
end)

RegisterNetEvent('k_menu:fx:freezeTime', function(enabled, h, m)
    state.timeFrozen = enabled
    if enabled then
        NetworkOverrideClockTime(h or 12, m or 0, 0)
        notify("Temps gelé.", "info")
    else
        notify("Temps dégelé.", "info")
    end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Spectate
-- ─────────────────────────────────────────────────────────────────────────────

local spectating = false

RegisterNetEvent('k_menu:fx:spectate', function()
    spectating = not spectating
    NetworkSetInSpectatorMode(spectating, GetPlayerPed(-1))
    notify(spectating and "Spectate ON" or "Spectate OFF")
end)

print("^2[k_menu] Effects chargé^7")
