local Button = {}

-- Crée un bouton simple
function Button.create(label, callback, params)
    return {
        label = label,
        callback = callback,
        params = params or {},
        type = "button"
    }
end

-- Crée un bouton avec une icône
function Button.withIcon(label, icon, callback, params)
    return {
        label = label,
        icon = icon, -- Icône FontAwesome (ex: "fa-user")
        callback = callback,
        params = params or {},
        type = "button"
    }
end

-- Crée un bouton de confirmation
function Button.confirm(label, confirmText, callback, params)
    return {
        label = label,
        confirmText = confirmText,
        callback = callback,
        params = params or {},
        type = "confirm"
    }
end

-- Crée un bouton désactivé
function Button.disabled(label, reason)
    return {
        label = label,
        disabled = true,
        disabledReason = reason or "Non disponible",
        type = "button"
    }
end

return Button