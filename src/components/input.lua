local Input = {}

-- Crée un champ de saisie texte
function Input.text(label, placeholder, callback, defaultValue)
    return {
        label = label,
        placeholder = placeholder or "",
        defaultValue = defaultValue or "",
        callback = callback,
        type = "input:text"
    }
end

-- Crée un champ de saisie numérique
function Input.number(label, placeholder, callback, min, max, defaultValue)
    return {
        label = label,
        placeholder = placeholder or "",
        defaultValue = defaultValue or 0,
        min = min,
        max = max,
        callback = callback,
        type = "input:number"
    }
end

-- Crée un sélecteur
function Input.select(label, options, callback, defaultValue)
    return {
        label = label,
        options = options or {},
        defaultValue = defaultValue or options[1],
        callback = callback,
        type = "input:select"
    }
end

-- Crée un slider
function Input.slider(label, min, max, step, callback, defaultValue)
    return {
        label = label,
        min = min or 0,
        max = max or 100,
        step = step or 1,
        defaultValue = defaultValue or min,
        callback = callback,
        type = "input:slider"
    }
end

-- Crée une case à cocher
function Input.checkbox(label, callback, defaultChecked)
    return {
        label = label,
        defaultChecked = defaultChecked or false,
        callback = callback,
        type = "input:checkbox"
    }
end

return Input