KUI = {}

KUI.Menus = {}

function KUI.CreateMenu(title, subtitle)
    local menu = {
        title = title,
        subtitle = subtitle,
        visible = false,
        options = {}
    }
    table.insert(KUI.Menus, menu)
    return menu
end

function KUI.Visible(menu, state)
    menu.visible = state

    -- Transformer les options pour enlever les fonctions
    local optionsData = {}
    for _, option in ipairs(menu.options) do
        table.insert(optionsData, { label = option.label }) -- Envoie uniquement le label
    end

    -- ✅ Envoie uniquement les données compatibles avec JSON
    SendNUIMessage({
        action = "toggleMenu",
        title = menu.title,
        subtitle = menu.subtitle,
        visible = state,
        options = optionsData
    })

    -- ✅ Active/Désactive la NUI
    SetNuiFocus(state, state)
end

function KUI.AddOption(menu, label, callback)
    table.insert(menu.options, { label = label, callback = callback })
end

function KUI.IsVisible(menu, enable, _, _, content)
    if menu.visible and enable then
        content()
    end
end

RegisterCommand("testmenu", function()
    local menu = KUI.CreateMenu("KUI Menu", "Mon sous-titre")
    KUI.AddOption(menu, "Option 1", function() print("Option 1 sélectionnée") end)
    KUI.AddOption(menu, "Option 2", function() print("Option 2 sélectionnée") end)
    KUI.AddOption(menu, "Option 3", function() print("Option 3 sélectionnée") end)
    KUI.AddOption(menu, "Option 4", function() print("Option 4 sélectionnée") end)
    KUI.AddOption(menu, "Option 5", function() print("Option 5 sélectionnée") end)
    KUI.AddOption(menu, "Option 6", function() print("Option 6 sélectionnée") end)
    KUI.AddOption(menu, "Option 7", function() print("Option 7 sélectionnée") end)
    KUI.AddOption(menu, "Option 8", function() print("Option 8 sélectionnée") end)
    KUI.AddOption(menu, "Option 9", function() print("Option 9 sélectionnée") end)
    KUI.AddOption(menu, "Option 0", function() print("Option 0   sélectionnée") end)
    KUI.Visible(menu, not menu.visible)
end, false)

RegisterNUICallback("closeMenu", function(_, cb)
    for _, menu in ipairs(KUI.Menus) do
        menu.visible = false
    end

    SetNuiFocus(false, false)
    SendNUIMessage({ action = "toggleMenu", visible = false })
    cb("ok")
end)

RegisterNUICallback("selectOption", function(data, cb)
    local menu = KUI.Menus[1] -- Supposons un seul menu
    if menu and menu.options[data.index] then
        menu.options[data.index].callback()
    end
    cb("ok")
end)

return KUI
