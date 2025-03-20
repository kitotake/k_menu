
-- Handle closing the menu from the NUI side
RegisterNUICallback("closeMenu", function(_, cb)
    KMenu.closeAll()
    cb("ok")
end)

-- Handle option execution from the NUI side  
RegisterNUICallback("executeOption", function(data, cb)
    local menuId = data.menuId
    local optionIndex = data.optionIndex
    
    local success = KMenu.executeOption(menuId, optionIndex)
    cb(success)
end)

-- Add keyboard controls for navigation
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        -- Check if any menu is visible
        local anyMenuVisible = false
        for _, menu in pairs(KMenu.menus) do
            if menu.visible then
                anyMenuVisible = true
                break
            end
        end
        
        if anyMenuVisible then
            -- Escape key to close menus
            if IsControlJustPressed(0, 177) then -- BACKSPACE
                KMenu.closeAll()
            end
        end
    end
end)