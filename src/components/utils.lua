Utils = {}

-- ✅ 1. Formater un titre avec des bordures
function Utils.formatTitle(text)
    return "==== " .. text .. " ===="
end

-- ✅ 2. Afficher un message dans la console avec une couleur
function Utils.log(text, color)
    local colors = {
        red = "^1",
        green = "^2",
        blue = "^4",
        yellow = "^3",
        default = "^7"
    }
    print((colors[color] or colors.default) .. "[k_lib] " .. text .. "^7")
end

-- ✅ 3. Vérifier si une variable est vide
function Utils.isEmpty(value)
    return value == nil or value == "" or (type(value) == "table" and next(value) == nil)
end

-- ✅ 4. Attendre quelques millisecondes (utile pour les animations)
function Utils.wait(ms)
    Citizen.Wait(ms)
end

return Utils
