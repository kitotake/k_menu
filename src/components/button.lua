 
local Button = {}

function Button.create(label, callback)
    return {
        label = label,
        callback = callback
    }
end

return Button
