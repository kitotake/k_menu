-- client/noclip.lua

local active = false

local function notify(msg)
    TriggerEvent('kt_lib:notify', { title = 'NoClip', description = msg, type = 'info' })
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Toggle noclip
-- Déclenché depuis le serveur ET en local (les deux cas)
-- ─────────────────────────────────────────────────────────────────────────────

local function toggleNoclip()
    active = not active
    local ped = PlayerPedId()

    if active then
        -- Fermer le menu pour libérer le focus NUI (sinon les touches ne passent pas à GTA)
        K.close()

        SetEntityInvincible(ped, true)
        SetEntityCollision(ped, false, false)
        SetEntityAlpha(ped, 180, false)
        FreezeEntityPosition(ped, false)   -- laisser le thread gérer le freeze
        notify("ON")
    else
        SetEntityInvincible(ped, false)
        SetEntityCollision(ped, true, true)
        ResetEntityAlpha(ped)
        SetEntityVelocity(ped, 0.0, 0.0, 0.0)
        FreezeEntityPosition(ped, false)   -- dégeler proprement
        notify("OFF")
    end
end

-- Event réseau (depuis server/admin.lua → TriggerClientEvent)
RegisterNetEvent('k_menu:fx:noclip', function()
    toggleNoclip()
end)

-- Event local (si jamais déclenché directement côté client)
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

            -- Vitesse : shift = rapide, ctrl = lent
            local speed = 0.5
            if IsControlPressed(0, 21) then speed = 3.0   -- SHIFT
            elseif IsControlPressed(0, 36) then speed = 0.1 end  -- CTRL (bas) → on gère séparément

            -- Direction caméra
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

            -- Avancer / reculer
            if IsControlPressed(0, 32) then move = move + fwd   end  -- W / joystick haut
            if IsControlPressed(0, 33) then move = move - fwd   end  -- S / joystick bas
            -- Gauche / droite
            if IsControlPressed(0, 34) then move = move - right end  -- A
            if IsControlPressed(0, 35) then move = move + right end  -- D
            -- Monter / descendre
            if IsControlPressed(0, 22) then move = move + up    end  -- SPACE
            if IsControlPressed(0, 36) then move = move - up    end  -- CTRL

            -- Appliquer seulement si mouvement
            if move ~= vector3(0,0,0) then
                local pos = GetEntityCoords(ped) + (move * speed)
                SetEntityCoordsNoOffset(ped, pos.x, pos.y, pos.z, false, false, false)
            end

            -- Annuler la physique / gravité en permanence
            SetEntityVelocity(ped, 0.0, 0.0, 0.0)
            SetPedGravity(ped, false)
            FreezeEntityPosition(ped, true)

            -- Masquer le ped (optionnel, évite l'animation de chute)
            SetEntityAnimationFlag(ped, 1, true)
        end
    end
end)

-- Remettre la gravité quand on désactive
Citizen.CreateThread(function()
    local wasActive = false
    while true do
        Citizen.Wait(100)
        if wasActive and not active then
            SetPedGravity(PlayerPedId(), true)
        end
        wasActive = active
    end
end)

print("^2[k_menu] NoClip chargé^7")
