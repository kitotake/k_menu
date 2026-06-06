-- client/noclip.lua
-- NoClip V2 — touches depuis Config + scaleform instructional_buttons

local active       = false
local noclipEntity = nil
local speedIndex   = Config.Noclip.defaultSpeedIndex
local scaleform    = nil

-- ─────────────────────────────────────────────────────────────
-- Raccourcis locaux vers la config (lisibilité)
-- ─────────────────────────────────────────────────────────────
local K       = Config.Noclip          -- Config.Noclip (pas le menu K)
local Speeds  = K.speeds

-- ─────────────────────────────────────────────────────────────
-- Notification kt_lib
-- ─────────────────────────────────────────────────────────────
local function notify(msg, ntype)
    lib.notify({ title = 'NoClip', description = msg, type = ntype or 'inform' })
end

-- ─────────────────────────────────────────────────────────────
-- Scaleform instructional_buttons
-- Affiche le bandeau de touches en bas de l'écran.
-- Reconstruit uniquement à l'activation et au changement de vitesse.
-- ─────────────────────────────────────────────────────────────
local function buildScaleform()
    local sf = RequestScaleformMovie("instructional_buttons")
    while not HasScaleformMovieLoaded(sf) do
        Citizen.Wait(0)
    end

    PushScaleformMovieFunction(sf, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    -- Slot 0 : Toggle (F9)
    PushScaleformMovieFunction(sf, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    ScaleformMovieMethodAddParamPlayerNameString("~INPUT_REPLAY_SHOWHOTKEY~")
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform("Toggle NoClip")
    EndTextCommandScaleformString()
    PopScaleformMovieFunctionVoid()

    -- Slot 1 : Déplacement ZQSD / WASD
    PushScaleformMovieFunction(sf, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    ScaleformMovieMethodAddParamPlayerNameString("~INPUT_MOVE_UP_ONLY~")
    ScaleformMovieMethodAddParamPlayerNameString("~INPUT_MOVE_DOWN_ONLY~")
    ScaleformMovieMethodAddParamPlayerNameString("~INPUT_MOVE_LEFT_ONLY~")
    ScaleformMovieMethodAddParamPlayerNameString("~INPUT_MOVE_RIGHT_ONLY~")
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform("Déplacer")
    EndTextCommandScaleformString()
    PopScaleformMovieFunctionVoid()

    -- Slot 2 : Monter (ESPACE — INPUT_JUMP = 22)
    PushScaleformMovieFunction(sf, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    ScaleformMovieMethodAddParamPlayerNameString("~INPUT_JUMP~")
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform("Monter")
    EndTextCommandScaleformString()
    PopScaleformMovieFunctionVoid()

    -- Slot 3 : Descendre (CTRL — INPUT_DUCK = 36)
    PushScaleformMovieFunction(sf, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(3)
    ScaleformMovieMethodAddParamPlayerNameString("~INPUT_DUCK~")
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform("Descendre")
    EndTextCommandScaleformString()
    PopScaleformMovieFunctionVoid()

    -- Slot 4 : Boost SHIFT
    PushScaleformMovieFunction(sf, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(4)
    ScaleformMovieMethodAddParamPlayerNameString("~INPUT_SPRINT~")
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform("Boost x2.5")
    EndTextCommandScaleformString()
    PopScaleformMovieFunctionVoid()

    -- Slot 5 : Changer vitesse ALT — affiche la vitesse courante
    PushScaleformMovieFunction(sf, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(5)
    ScaleformMovieMethodAddParamPlayerNameString("~INPUT_FRONTEND_CANCEL~")
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform("Vitesse: " .. Speeds[speedIndex].label)
    EndTextCommandScaleformString()
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(sf, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    -- Fond semi-transparent
    PushScaleformMovieFunction(sf, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return sf
end

-- ─────────────────────────────────────────────────────────────
-- Vecteurs de direction basés sur la caméra
-- ─────────────────────────────────────────────────────────────
local function getCameraVectors()
    local rot  = GetGameplayCamRot(2)
    local hRad = math.rad(rot.z)
    local pRad = math.rad(rot.x)
    return
        vector3(-math.sin(hRad) * math.cos(pRad),
                 math.cos(hRad) * math.cos(pRad),
                 math.sin(pRad)),
        vector3(math.cos(hRad), math.sin(hRad), 0.0),
        vector3(0.0, 0.0, 1.0)
end

-- ─────────────────────────────────────────────────────────────
-- Cycle vitesse (ALT)
-- ─────────────────────────────────────────────────────────────
local function cycleSpeed()
    speedIndex = speedIndex % #Speeds + 1
    scaleform  = buildScaleform()   -- met à jour le label dans le bandeau
    notify("Vitesse : " .. Speeds[speedIndex].label, "inform")
end

-- ─────────────────────────────────────────────────────────────
-- Toggle noclip
-- ─────────────────────────────────────────────────────────────
local function toggleNoclip(forcedState)
    local ped = PlayerPedId()

    noclipEntity = IsPedInAnyVehicle(ped, false)
        and GetVehiclePedIsIn(ped, false)
        or  ped

    active = (forcedState ~= nil) and forcedState or (not active)

    -- Fermer le menu NUI si ouvert
    if active and Menu and Menu.close then Menu.close() end

    if active then
        SetEntityInvincible(noclipEntity, true)
        SetEntityCollision(noclipEntity, false, false)
        SetEntityAlpha(noclipEntity, K.alpha, false)
        FreezeEntityPosition(noclipEntity, false)
        SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)

        if IsPedInAnyVehicle(ped, false) then
            SetVehicleRadioEnabled(noclipEntity, false)
        end

        scaleform = buildScaleform()
        notify("ON — " .. Speeds[speedIndex].label, "success")
    else
        SetEntityInvincible(noclipEntity, false)
        SetEntityCollision(noclipEntity, true, true)
        ResetEntityAlpha(noclipEntity)
        SetEntityAlpha(noclipEntity, 255, false)
        SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
        FreezeEntityPosition(noclipEntity, false)
        SetEntityVisible(noclipEntity, true, false)

        noclipEntity = nil
        notify("OFF", "error")
    end
end

-- ─────────────────────────────────────────────────────────────
-- Events entrants
-- ─────────────────────────────────────────────────────────────
RegisterNetEvent('k_menu:fx:noclip', function()
    toggleNoclip()
end)

AddEventHandler('k_menu:localNoclip', function()
    toggleNoclip()
end)

AddEventHandler('k_menu:setNoclip', function(state)
    if state ~= active then toggleNoclip(state) end
end)

-- ─────────────────────────────────────────────────────────────
-- Thread principal
-- ─────────────────────────────────────────────────────────────
Citizen.CreateThread(function()
    -- Pré-charger le scaleform au démarrage
    scaleform = buildScaleform()

    while true do
        if not active then
            Citizen.Wait(300)

            -- Écouter le toggle même quand inactif
            if IsControlJustPressed(0, K.toggleKey) then
                toggleNoclip()
            end
        else
            Citizen.Wait(0)

            local entity = noclipEntity
            if not entity or not DoesEntityExist(entity) then
                active       = false
                noclipEntity = nil
                goto continue
            end

            -- Toggle (désactiver)
            if IsControlJustPressed(0, K.toggleKey) then
                toggleNoclip()
                goto continue
            end

            -- Afficher le bandeau de touches
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)

            -- Vecteurs de direction
            local fwd, right, up = getCameraVectors()

            -- Vitesse : base + boost SHIFT temporaire
            local speed = Speeds[speedIndex].speed
            if IsControlPressed(0, K.sprint) then
                speed = speed * 2.5
            end

            -- Désactiver les contrôles du jeu (évite que le ped bouge tout seul)
            DisableControlAction(0, K.forward,  true)
            DisableControlAction(0, K.backward, true)
            DisableControlAction(0, K.left,     true)
            DisableControlAction(0, K.right,    true)
            DisableControlAction(0, K.up,       true)
            DisableControlAction(0, K.down,     true)

            -- Accumulation du vecteur de déplacement
            local move = vector3(0.0, 0.0, 0.0)

            if IsControlPressed(0, K.forward)  then move = move + fwd   end
            if IsControlPressed(0, K.backward) then move = move - fwd   end
            if IsControlPressed(0, K.left)     then move = move - right end
            if IsControlPressed(0, K.right)    then move = move + right end
            if IsControlPressed(0, K.up)       then move = move + up    end
            if IsControlPressed(0, K.down)     then move = move - up    end

            -- Cycle vitesse ALT
            if IsControlJustPressed(0, K.cycleSpeed) then
                cycleSpeed()
            end

            -- Appliquer la position (frametime pour rester fluide à tout FPS)
            if move ~= vector3(0.0, 0.0, 0.0) then
                local dt  = GetFrameTime() * 60.0
                local pos = GetEntityCoords(entity) + (move * speed * dt * 0.016)
                SetEntityCoordsNoOffset(entity, pos.x, pos.y, pos.z, false, false, false)
            end

            -- Anti-physique
            SetEntityVelocity(entity, 0.0, 0.0, 0.0)
            FreezeEntityPosition(entity, false)
            SetEntityAlpha(entity, K.alpha, false)

            ::continue::
        end
    end
end)

print("^2[k_menu] NoClip V2 chargé^7")