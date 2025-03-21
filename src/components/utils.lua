local Utils = {}

-- ✅ 1. Formater un titre avec des bordures
function Utils.formatTitle(text, style)
    local styles = {
        double = "==== %s ====",
        single = "---- %s ----",
        star = "**** %s ****",
        bracket = "[[ %s ]]",
        default = "==== %s ===="
    }
    return string.format(styles[style] or styles.default, text)
end

-- ✅ 2. Afficher un message dans la console avec une couleur
function Utils.log(text, color, prefix)
    local colors = {
        red = "^1",
        green = "^2",
        blue = "^4",
        yellow = "^3",
        purple = "^6",
        gray = "^5",
        white = "^7",
        default = "^7"
    }
    local prefixText = prefix or "[k_lib]"
    print((colors[color] or colors.default) .. prefixText .. " " .. text .. "^7")
end

-- ✅ 3. Vérifier si une variable est vide
function Utils.isEmpty(value)
    return value == nil or value == "" or (type(value) == "table" and next(value) == nil)
end

-- ✅ 4. Attendre quelques millisecondes (utile pour les animations)
function Utils.wait(ms)
    Citizen.Wait(ms)
end

-- ✅ 5. Fonction de débogage qui affiche la structure d'une table
function Utils.debugTable(tbl, indent)
    if not tbl then return "nil" end
    if type(tbl) ~= "table" then return tostring(tbl) end
    
    indent = indent or 0
    local spaces = string.rep("  ", indent)
    local output = "{\n"
    
    for k, v in pairs(tbl) do
        output = output .. spaces .. "  " .. tostring(k) .. " = "
        if type(v) == "table" then
            output = output .. Utils.debugTable(v, indent + 1)
        else
            output = output .. tostring(v)
        end
        output = output .. ",\n"
    end
    
    output = output .. spaces .. "}"
    return output
end

-- ✅ 6. Fonction pour créer une notification à l'écran
function Utils.notify(message, type, duration)
    type = type or "info"
    duration = duration or 5000
    
    local types = {
        info = { color = "#3498db", icon = "info-circle" },
        success = { color = "#2ecc71", icon = "check-circle" },
        warning = { color = "#f39c12", icon = "exclamation-triangle" },
        error = { color = "#e74c3c", icon = "times-circle" }
    }
    
    local style = types[type] or types.info
    
    SendNUIMessage({
        action = "showNotification",
        message = message,
        color = style.color,
        icon = style.icon,
        duration = duration
    })
end

-- ✅ 7. Vérification de droits administrateur
function Utils.isAdmin(source)
    local isAdmin = false
    if IsPlayerAceAllowed then -- Vérification que la fonction existe (au cas où)
        isAdmin = IsPlayerAceAllowed(source, "command")
    end
    return isAdmin
end

-- Déclarer Utils comme global pour être accessible partout
_G.Utils = Utils

return Utils