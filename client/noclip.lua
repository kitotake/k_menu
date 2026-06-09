-- ============================================================
-- client/noclip.lua
-- KT Menu - NoClip
-- ============================================================

local active       = false
local noclipEntity = nil
local speedIndex   = Config.Noclip.defaultSpeedIndex
local scaleform    = nil

local K      = Config.Noclip
local Speeds = K.speeds

-- ============================================================
-- Notifications
-- ============================================================

local function notify(message, ntype)
    lib.notify({
        title = 'NoClip',
        description = message,
        type = ntype or 'inform'
    })
end

-- ============================================================
-- Scaleform
-- ============================================================

local function buildScaleform()
    local sf = RequestScaleformMovie('instructional_buttons')

    while not HasScaleformMovieLoaded(sf) do
        Wait(0)
    end

    PushScaleformMovieFunction(sf, 'CLEAR_ALL')
    PopScaleformMovieFunctionVoid()

    local slot = 0

    local function addSlot(button, text)
        PushScaleformMovieFunction(sf, 'SET_DATA_SLOT')
        PushScaleformMovieFunctionParameterInt(slot)
        ScaleformMovieMethodAddParamPlayerNameString(button)

        BeginTextCommandScaleformString('STRING')
        AddTextComponentScaleform(text)
        EndTextCommandScaleformString()

        PopScaleformMovieFunctionVoid()

        slot += 1
    end

    addSlot('~INPUT_REPLAY_SHOWHOTKEY~', 'Toggle NoClip')
    addSlot('~INPUT_MOVE_UP_ONLY~',      'Déplacer')
    addSlot('~INPUT_JUMP~',              'Monter')
    addSlot('~INPUT_DUCK~',              'Descendre')
    addSlot('~INPUT_FRONTEND_RRIGHT~',   'Boost x2.5')
    addSlot('~INPUT_SPRINT~',            ('Vitesse : %s'):format(Speeds[speedIndex].label))

    PushScaleformMovieFunction(sf, 'DRAW_INSTRUCTIONAL_BUTTONS')
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(sf, 'SET_BACKGROUND_COLOUR')
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return sf
end

-- ============================================================
-- Camera vectors
-- ============================================================

local function getCameraVectors()
    local rot = GetGameplayCamRot(2)

    local heading = math.rad(rot.z)
    local pitch   = math.rad(rot.x)

    local forward = vector3(
        -math.sin(heading) * math.cos(pitch),
         math.cos(heading) * math.cos(pitch),
         math.sin(pitch)
    )

    local right = vector3(
        math.cos(heading),
        math.sin(heading),
        0.0
    )

    local up = vector3(0.0, 0.0, 1.0)

    return forward, right, up
end

-- ============================================================
-- Speed
-- ============================================================

local function cycleSpeed()
    speedIndex = speedIndex % #Speeds + 1

    scaleform = buildScaleform()

    notify(
        ('Vitesse : %s'):format(Speeds[speedIndex].label),
        'inform'
    )
end

-- ============================================================
-- Toggle
-- ============================================================

local function toggleNoclip(forceState)
    local ped = PlayerPedId()

    noclipEntity = IsPedInAnyVehicle(ped, false)
        and GetVehiclePedIsIn(ped, false)
        or ped

    active = forceState ~= nil and forceState or not active

    if active then

        SetEntityInvincible(noclipEntity, true)
        SetEntityCollision(noclipEntity, false, false)
        SetEntityAlpha(noclipEntity, K.alpha, false)
        SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)

        if IsPedInAnyVehicle(ped, false) then
            SetVehicleRadioEnabled(noclipEntity, false)
        end

        -- Chargement anim dans un thread séparé pour ne pas bloquer le main thread
        if noclipEntity == ped then
            CreateThread(function()
                local animDict = 'skydive@parachute@'
                RequestAnimDict(animDict)
                while not HasAnimDictLoaded(animDict) do
                    Wait(0)
                end
                -- Vérifie que le noclip est toujours actif avant de jouer l'anim
                if active then
                    TaskSetBlockingOfNonTemporaryEvents(ped, true)
                    TaskPlayAnim(ped, animDict, 'chute_loop',
                        8.0, -8.0, -1, 1, 0.0, false, false, false
                    )
                end
            end)
        end

        scaleform = buildScaleform()

        notify(
            ('Activé (%s)'):format(Speeds[speedIndex].label),
            'success'
        )

    else

        SetEntityInvincible(noclipEntity, false)
        SetEntityCollision(noclipEntity, true, true)
        ResetEntityAlpha(noclipEntity)
        SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
        FreezeEntityPosition(noclipEntity, false)
        SetEntityVisible(noclipEntity, true, false)

        if noclipEntity == ped then
            TaskSetBlockingOfNonTemporaryEvents(ped, false)
            ClearPedTasks(ped)
        end

        noclipEntity = nil
        notify('Désactivé', 'error')
    end
end

-- ============================================================
-- Events
-- ============================================================

RegisterNetEvent('k_menu:fx:noclip', function()
    toggleNoclip()
end)

AddEventHandler('k_menu:localNoclip', function()
    toggleNoclip()
end)

AddEventHandler('k_menu:setNoclip', function(state)
    if state ~= active then
        toggleNoclip(state)
    end
end)

-- ============================================================
-- Main Thread
-- ============================================================
CreateThread(function()
    while true do
        Wait(0)
        for i = 0, 400 do
            if IsControlJustPressed(0, i) then
                print('Touche : ' .. i)
            end
        end
    end
end)


CreateThread(function()

    scaleform = buildScaleform()

    while true do

        if not active then

            Wait(250)

            if IsControlJustPressed(0, K.toggleKey) then
                toggleNoclip()
            end

        else

            Wait(0)

            local entity = noclipEntity

            if not entity or not DoesEntityExist(entity) then
                active = false
                noclipEntity = nil
                goto continue
            end

            if IsControlJustPressed(0, K.toggleKey) then
                toggleNoclip()
                goto continue
            end

            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)

            local forward, right, up = getCameraVectors()

            local speed = Speeds[speedIndex].speed

            if IsControlPressed(0, K.sprint) then
                speed = speed * 2.5
            end

            -- Désactive les inputs natifs pour éviter les conflits
            DisableControlAction(0, K.forward,  true)
            DisableControlAction(0, K.backward, true)
            DisableControlAction(0, K.left,     true)
            DisableControlAction(0, K.right,    true)
            DisableControlAction(0, K.up,       true)
            DisableControlAction(0, K.down,     true)

            -- Désactive aussi cycleSpeed (SHIFT) pour éviter qu'il
            -- déclenche le sprint natif et coupe les mouvements
            DisableControlAction(0, K.cycleSpeed, true)

            local move = vector3(0.0, 0.0, 0.0)

            -- IsDisabledControlPressed : lit l'input même après DisableControlAction
          -- Test debug : touches hardcodées
local move = vector3(0.0, 0.0, 0.0)

if IsDisabledControlPressed(0, 32) then move += forward end  -- Z
if IsDisabledControlPressed(0, 33) then move -= forward end  -- S
if IsDisabledControlPressed(0, 34) then move -= right   end  -- Q
if IsDisabledControlPressed(0, 35) then move += right   end  -- D
if IsDisabledControlPressed(0, 44) then move += up      end  -- SPACE
if IsDisabledControlPressed(0, 54) then move -= up      end  -- CTRL


            if IsDisabledControlJustPressed(0, K.cycleSpeed) then
                cycleSpeed()
            end

            if move ~= vector3(0.0, 0.0, 0.0) then
                local pos = GetEntityCoords(entity)
                pos += move * speed * GetFrameTime() * 60.0

                SetEntityCoordsNoOffset(
                    entity,
                    pos.x, pos.y, pos.z,
                    false, false, false
                )
            end

            SetEntityVelocity(entity, 0.0, 0.0, 0.0)
            SetEntityAlpha(entity, K.alpha, false)

            ::continue::
        end
    end
end)

print('^2[kt_menu] NoClip chargé^7')