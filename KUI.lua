KUI = {}

KUI.Menus = {}

function KUI.CreateMenu(title, subtitle)
    local menu = {
        title = title,
        subtitle = subtitle,
        visible = false,
        options = {},
    }
    table.insert(KUI.Menus, menu)
    return menu
end

function KUI.Visible(menu, state)
    menu.visible = state
end

function KUI.IsVisible(menu, enable, _, _, content)
    if menu.visible and enable then
        content() -- Exécute le contenu du menu
    end
end

function KUI.ButtonWithStyle(title, desc, style, enabled, action)
    local hovered = false -- Placeholder
    local active = false  -- Placeholder
    local selected = false -- Placeholder

    if enabled then
        if selected then
            action(hovered, active, selected)
        end
    end
end

function KUI.Separator(text)
    print("===== " .. text .. " =====")
end

return KUI
