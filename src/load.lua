-- load.lua - Point d'entrée principal pour k_lib
local modules = {}
local button = {}
local input = {}
local title = {}
local utils = {}
local init = {}
local manager = {}
local menu = {}
local submenu = {}
local nui_bridge = {}



-- ✅ Chargement des modules
local function loadModules()
    -- Définir les fichiers à charger avec leur correspondance
    local moduleFiles = {
        ["utils"] = "src/components/utils.lua",
        ["button"] = "src/components/button.lua",
        ["input"] = "src/components/input.lua",
        ["title"] = "src/components/title.lua",
        ["manager"] = "src/menu/manager.lua",
        ["menu"] = "src/menu/menu.lua",
        ["submenu"] = "src/menu/submenu.lua",
        ["init"] = "src/menu/init.lua",
        ["nui_bridge"] = "src/nui/nui_bridge.lua"
    }
    
    -- Charger les modules dans l'ordre approprié (Utils en premier)
    local loadOrder = {
        "utils", "title", "button", "input", "manager", "menu", "submenu", "init", "nui_bridge"
    }
    
    -- Charger d'abord les fichiers core (utils)
    for _, moduleName in ipairs(loadOrder) do
        local filePath = moduleFiles[moduleName]
        print("^2[INFO] Tentative de chargement du module : " .. filePath .. "^7")
        
        -- Essayer de charger le fichier directement
        local loaded = false
        local fileContent = LoadResourceFile(GetCurrentResourceName(), filePath)
        
        if fileContent then
            local func, err = load(fileContent, filePath, "t")
            if func then
                local success, result = pcall(func)
                if success then
                    -- Assigner le résultat à la variable locale correspondante
                    if moduleName == "utils" then
                        utils = result
                        _G.Utils = result  -- Rendre Utils globalement accessible
                    elseif moduleName == "button" then
                        button = result
                    elseif moduleName == "input" then
                        input = result
                    elseif moduleName == "title" then
                        title = result
                    elseif moduleName == "manager" then
                        manager = result
                        _G.KMenu = result  -- Rendre KMenu globalement accessible
                    elseif moduleName == "menu" then
                        menu = result
                    elseif moduleName == "submenu" then
                        submenu = result
                    elseif moduleName == "init" then
                        init = result
                    elseif moduleName == "nui_bridge" then
                        nui_bridge = result
                    end
                    
                    -- Stocker le module dans la table modules
                    modules[moduleName] = result
                    loaded = true
                    print("^2[SUCCESS] Module chargé : " .. filePath .. "^7")
                else
                    print(("^1[ERROR] Erreur d'exécution du module : %s - %s^7"):format(filePath, result))
                end
            else
                print(("^1[ERROR] Erreur de compilation du module : %s - %s^7"):format(filePath, err))
            end
        else
            -- Essayer de charger comme un module standard (fallback)
            local success, mod = pcall(function() 
                return require(moduleFiles[moduleName]:gsub("%.lua$", ""))
            end)
            
            if success then
                -- Assigner le résultat à la variable locale correspondante comme ci-dessus
                if moduleName == "utils" then
                    utils = mod
                    _G.Utils = mod
                elseif moduleName == "button" then
                    button = mod
                elseif moduleName == "input" then
                    input = mod
                elseif moduleName == "title" then
                    title = mod
                elseif moduleName == "manager" then
                    manager = mod
                    _G.KMenu = mod
                elseif moduleName == "menu" then
                    menu = mod
                elseif moduleName == "submenu" then
                    submenu = mod
                elseif moduleName == "init" then
                    init = mod
                elseif moduleName == "nui_bridge" then
                    nui_bridge = mod
                end
                
                modules[moduleName] = mod
                loaded = true
                print("^2[SUCCESS] Module chargé via require : " .. filePath .. "^7")
            else
                print(("^1[ERROR] Impossible de charger le module : %s - %s^7"):format(filePath, mod))
            end
        end
        
        if not loaded then
            print("^3[WARNING] Le module n'a pas pu être chargé : " .. filePath .. "^7")
        end
    end
end

-- ✅ Obtenir un module par son nom
function GetModule(moduleName)
    if not modules[moduleName] then
        print("^1[ERROR] Module non trouvé: " .. moduleName .. "^7")
        return nil
    end
    return modules[moduleName]
end

-- ✅ Fonctions d'accès aux modules
function GetUtils() return utils end
function GetButton() return button end
function GetInput() return input end
function GetTitle() return title end
function GetManager() return manager end
function GetMenu() return menu end
function GetSubmenu() return submenu end
function GetInit() return init end
function GetNuiBridge() return nui_bridge end

-- ✅ Initialisation
Citizen.CreateThread(function()
    -- Attendre que la session soit prête
    while not NetworkIsSessionStarted() do
        Wait(100)
    end

    -- Charger les modules
    loadModules()

    -- Enregistrer la commande du menu
    RegisterCommand("kmenu", function()
        if _G.Utils then
            _G.Utils.log("Version 1.1.0 - k_lib menu system", "blue")
        end
        if modules["menu"] then
            modules["menu"].createMainMenu()
        end
    end, false)

    -- Message de confirmation
    if _G.Utils then
        _G.Utils.log("k_lib v1.1.0 chargée avec succès", "green")
    end
end)

-- ✅ Exporter les fonctions
exports("GetModule", GetModule)
exports("GetUtils", GetUtils)
exports("GetButton", GetButton)
exports("GetInput", GetInput)
exports("GetTitle", GetTitle)
exports("GetManager", GetManager)
exports("GetMenu", GetMenu)
exports("GetSubmenu", GetSubmenu)
exports("GetInit", GetInit)
exports("GetNuiBridge", GetNuiBridge)

-- ✅ Retourner les modules exportés
return {
    GetModule = GetModule,
    GetUtils = GetUtils,
    GetButton = GetButton,
    GetInput = GetInput,
    GetTitle = GetTitle,
    GetManager = GetManager,
    GetMenu = GetMenu,
    GetSubmenu = GetSubmenu,
    GetInit = GetInit,
    GetNuiBridge = GetNuiBridge
}