-- client/effects.lua
-- Effets visuels et locaux — V3 (kt_lib + kt_inventory)

local state = {
    godMode    = false,
    invisible  = false,
    speedBoost = false,
    timeFrozen = false,
}

-- ─────────────────────────────────────────────────────────────
-- Notification via kt_lib
-- ─────────────────────────────────────────────────────────────

local function notify(msg, ntype)
    lib.notify({
        title       = 'Admin',
        description = msg,
        type        = ntype or 'inform',
    })
end

-- ─────────────────────────────────────────────────────────────
-- God Mode
-- ─────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:fx:godMode', function(enabled)
    state.godMode = enabled == true
    SetEntityInvincible(PlayerPedId(), state.godMode)
    notify(state.godMode and "God Mode ON" or "God Mode OFF",
           state.godMode and "success" or "inform")
end)

-- ─────────────────────────────────────────────────────────────
-- Invisible
-- ─────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:fx:invisible', function(enabled)
    state.invisible = enabled == true
    SetEntityVisible(PlayerPedId(), not state.invisible, false)
    notify(state.invisible and "Invisible ON" or "Invisible OFF",
           state.invisible and "success" or "inform")
end)

-- ─────────────────────────────────────────────────────────────
-- Speed Boost
-- ─────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:fx:speedBoost', function(enabled)
    state.speedBoost = enabled == true
    notify(state.speedBoost and "Speed Boost ON" or "Speed Boost OFF",
           state.speedBoost and "success" or "inform")
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(state.speedBoost and 0 or 500)
        if state.speedBoost then
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            if DoesEntityExist(veh) then
                SetVehicleMaxSpeed(veh, 999.0)
                SetVehicleCheatPowerIncrease(veh, 10.0)
            end
        end
    end
end)

-- ─────────────────────────────────────────────────────────────
-- Heal / Revive
-- ─────────────────────────────────────────────────────────────

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

-- ─────────────────────────────────────────────────────────────
-- Freeze
-- ─────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:fx:freeze', function(enabled)
    FreezeEntityPosition(PlayerPedId(), enabled)
    notify(enabled and "Freezé." or "Unfreeze.", enabled and "warning" or "success")
end)

-- ─────────────────────────────────────────────────────────────
-- Téléportation
-- ─────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:fx:tpTo', function(x, y, z)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local entity = DoesEntityExist(veh) and veh or ped
    SetEntityCoords(entity, x, y, z, false, false, false, true)
    notify("Téléporté !", "success")
end)

-- ─────────────────────────────────────────────────────────────
-- Véhicules
-- ─────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:fx:spawnVeh', function(model)
    local hash = GetHashKey(model)
    RequestModel(hash)
    while not HasModelLoaded(hash) do Citizen.Wait(10) end
    local coords  = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
    local veh = CreateVehicle(hash, coords.x + 3.0, coords.y, coords.z, heading, true, false)
    SetPedIntoVehicle(PlayerPedId(), veh, -1)
    SetModelAsNoLongerNeeded(hash)
    notify(model .. " spawné.", "success")
end)

RegisterNetEvent('k_menu:fx:fixVeh', function()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if not DoesEntityExist(veh) then
        return notify("Pas dans un véhicule.", "error")
    end
    SetVehicleFixed(veh)
    SetVehicleEngineHealth(veh, 1000.0)
    SetVehicleBodyHealth(veh, 1000.0)
    SetVehiclePetrolTankHealth(veh, 1000.0)
    SetVehicleDirtLevel(veh, 0.0)
    notify("Véhicule réparé.", "success")
end)

RegisterNetEvent('k_menu:fx:delVeh', function()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if DoesEntityExist(veh) then
        TaskLeaveVehicle(PlayerPedId(), veh, 0)
        Citizen.Wait(500)
        DeleteVehicle(veh)
    end
    notify("Véhicule supprimé.", "success")
end)

RegisterNetEvent('k_menu:fx:deleteNear', function()
    local coords = GetEntityCoords(PlayerPedId())
    local count  = 0
    for _, veh in ipairs(GetGamePool('CVehicle')) do
        if #(GetEntityCoords(veh) - coords) < 30.0
        and not IsPedInVehicle(PlayerPedId(), veh, false) then
            DeleteVehicle(veh)
            count = count + 1
        end
    end
    notify(count .. " véhicule(s) supprimé(s).", "success")
end)

RegisterNetEvent('k_menu:fx:boostVeh', function()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if not DoesEntityExist(veh) then
        return notify("Pas dans un véhicule.", "error")
    end
    SetVehicleCheatPowerIncrease(veh, 10.0)
    SetVehicleMaxSpeed(veh, 300.0)
    notify("Moteur boosté ×10 !", "success")
end)

-- ─────────────────────────────────────────────────────────────
-- Armes — kt_inventory
-- Les armes sont des items gérés par kt_inventory côté serveur.
-- Le client reçoit uniquement un event de confirmation visuelle.
-- L'ajout réel se fait dans server/admin.lua via exports.kt_inventory.
-- ─────────────────────────────────────────────────────────────

-- Confirmation visuelle après don d'arme par le serveur
RegisterNetEvent('k_menu:fx:weaponGiven', function(label)
    notify("Arme reçue : " .. tostring(label), "success")
end)

-- Confirmation visuelle après kit
RegisterNetEvent('k_menu:fx:weaponKitGiven', function(kitName)
    notify("Kit « " .. tostring(kitName) .. " » reçu !", "success")
end)

-- Confirmation visuelle après suppression
RegisterNetEvent('k_menu:fx:weaponsRemoved', function()
    notify("Inventaire vidé.", "success")
end)

-- ─────────────────────────────────────────────────────────────
-- Météo
-- ─────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:fx:weather', function(weather)
    SetWeatherTypePersist(weather)
    SetWeatherTypeNowPersist(weather)
    SetWeatherTypeNow(weather)
end)

-- ─────────────────────────────────────────────────────────────
-- Heure
-- ─────────────────────────────────────────────────────────────

RegisterNetEvent('k_menu:fx:time', function(h, m)
    NetworkOverrideClockTime(h, m, 0)
    notify(("Heure : %02d:%02d"):format(h, m), "success")
end)

RegisterNetEvent('k_menu:fx:freezeTime', function(enabled, h, m)
    state.timeFrozen = enabled == true
    if state.timeFrozen then
        NetworkOverrideClockTime(h or 12, m or 0, 0)
        notify("Temps gelé.", "inform")
    else
        notify("Temps dégelé.", "inform")
    end
end)

-- ─────────────────────────────────────────────────────────────
-- Spectate
-- ─────────────────────────────────────────────────────────────

local spectating = false

RegisterNetEvent('k_menu:fx:spectate', function()
    spectating = not spectating
    NetworkSetInSpectatorMode(spectating, GetPlayerPed(-1))
    notify(spectating and "Spectate ON" or "Spectate OFF",
           spectating and "success" or "inform")
end)

print("^2[k_menu] Effects V3 (kt_lib + kt_inventory) chargé^7")