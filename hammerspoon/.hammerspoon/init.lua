---@diagnostic disable: undefined-global

local padding = 30

local center_tall = function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    -- Then resize and position it
    f.w = 3 * max.w / 5
    f.h = max.h - padding
    win:setFrame(f)
    win:centerOnScreen()
    f = win:frame()
    f.y = f.y + 10
    win:setFrame(f)
end

local center = function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.w = 3 * max.w / 5
    f.h = max.h / 1.5
    win:setFrame(f)
    win:centerOnScreen()
end

hs.hotkey.bind({ "alt", "shift" }, "G", function()
    center_tall()
end)

hs.hotkey.bind({ "alt", "shift" }, "C", function()
    center()
end)

hs.hotkey.bind({ "alt", "ctrl", "shift" }, "R", function()
    hs.reload()
end)

hs.alert.show("Config loaded")
