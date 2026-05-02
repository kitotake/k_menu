-- client/noclip.lua

local noclipOn = false
local noclipEntity = nil

RegisterNetEvent('k_menu:adminNoclip', function()
    noclipOn = not noclipOn
    local ped = PlayerPedId()
    if noclipOn then
        noclipEntity = ped
        SetEntityInvincible(noclipEntity, true)
        SetEntityCollision(noclipEntity, false, false)
        FreezeEntityPosition(noclipEntity, false)
        TriggerEvent('kt_lib:notify', { title = 'Admin', description = "NoClip ON", type = 'info' })
    else
        SetEntityInvincible(ped, false)
        SetEntityCollision(ped, true, true)
        ResetEntityAlpha(ped)
        FreezeEntityPosition(ped, false)
        SetEntityVelocity(ped, 0.0, 0.0, 0.0)
        noclipEntity = nil
        TriggerEvent('kt_lib:notify', { title = 'Admin', description = "NoClip OFF", type = 'info' })
    end
end)

Citizen.CreateThread(function()
    while true do
        if noclipOn and noclipEntity then
            Citizen.Wait(0)
            local ped = noclipEntity
            local coords = GetEntityCoords(ped)
            local speed = 0.5
            if IsControlPressed(0, 21) then speed = 2.0 end
            local camRot = GetGameplayCamRot(2)
            local heading = camRot.z
            local pitch = camRot.x
            local forward = vector3(
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
            if IsControlPressed(0, 32) then move = move + forward end
            if IsControlPressed(0, 33) then move = move - forward end
            if IsControlPressed(0, 34) then move = move - right end
            if IsControlPressed(0, 35) then move = move + right end
            if IsControlPressed(0, 22) then move = move + up end
            if IsControlPressed(0, 36) then move = move - up end
            local newPos = coords + (move * speed)
            SetEntityCoordsNoOffset(ped, newPos.x, newPos.y, newPos.z, true, true, true)
            SetEntityVelocity(ped, 0.0, 0.0, 0.0)
            FreezeEntityPosition(ped, true)
        else
            Citizen.Wait(250)
        end
    end
end)