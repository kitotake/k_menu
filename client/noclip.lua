-- client/noclip.lua

local active = false

local function notify(msg)
    TriggerEvent('kt_lib:notify', { title = 'NoClip', description = msg, type = 'info' })
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Toggle noclip
-- ─────────────────────────────────────────────────────────────────────────────

local function toggleNoclip()
    active = not active
    local ped = PlayerPedId()

    if active then
        -- Fermer le menu pour libérer le focus NUI
        K.close()
        SetEntityInvincible(ped, true)
        SetEntityCollision(ped, false, false)
        SetEntityAlpha(ped, 180, false)
        FreezeEntityPosition(ped, false)
        notify("ON")
    else
        SetEntityInvincible(ped, false)
        SetEntityCollision(ped, true, true)
        ResetEntityAlpha(ped)
        SetEntityVelocity(ped, 0.0, 0.0, 0.0)
        FreezeEntityPosition(ped, false)
        -- FIX #3 : remettre la gravité proprement ici
        SetPedGravity(ped, true)
        notify("OFF")
    end
end

RegisterNetEvent('k_menu:fx:noclip', function()
    toggleNoclip()
end)

AddEventHandler('k_menu:localNoclip', function()
    toggleNoclip()
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Thread de mouvement
-- ─────────────────────────────────────────────────────────────────────────────

Citizen.CreateThread(function()
    while true do
        if not active then
            Citizen.Wait(300)
        else
            Citizen.Wait(0)

            local ped = PlayerPedId()

            -- FIX #2 : CTRL séparé de la vitesse de base
            -- SHIFT  (21) = rapide
            -- normal       = normal
            -- pas de conflit avec descente
            local speed = 0.5
            if IsControlPressed(0, 21) then speed = 3.0 end  -- SHIFT = rapide

            local camRot  = GetGameplayCamRot(2)
            local heading = camRot.z
            local pitch   = camRot.x

            local fwd = vector3(
                -math.sin(math.rad(heading)) * math.cos(math.rad(pitch)),
                 math.cos(math.rad(heading)) * math.cos(math.rad(pitch)),
                 math.sin(math.rad(pitch))
            )
            local right = vector3(
                 math.cos(math.rad(heading)),
                 math.sin(math.rad(heading)),
                 0.0
            )
            local up = vector3(0.0, 0.0, 1.0)

            local move = vector3(0.0, 0.0, 0.0)

            if IsControlPressed(0, 32) then move = move + fwd   end  -- W
            if IsControlPressed(0, 33) then move = move - fwd   end  -- S
            if IsControlPressed(0, 34) then move = move - right end  -- A
            if IsControlPressed(0, 35) then move = move + right end  -- D
            if IsControlPressed(0, 22) then move = move + up    end  -- SPACE = monter
            if IsControlPressed(0, 36) then move = move - up    end  -- CTRL  = descendre (FIX #2 : vitesse normale)

            if move ~= vector3(0.0, 0.0, 0.0) then
                local pos = GetEntityCoords(ped) + (move * speed)
                SetEntityCoordsNoOffset(ped, pos.x, pos.y, pos.z, false, false, false)
            end

            -- Annuler physique / gravité
            SetEntityVelocity(ped, 0.0, 0.0, 0.0)
            SetPedGravity(ped, false)
            FreezeEntityPosition(ped, true)
        end
    end
end)

print("^2[k_menu] NoClip chargé^7")
