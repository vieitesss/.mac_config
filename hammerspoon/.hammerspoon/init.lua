---@diagnostic disable: undefined-global

local padding = 15

local center_tall = function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.w = max.w / 2 - padding * 2
    f.h = max.h - padding * 2
    win:setFrame(f)
    win:centerOnScreen()
end

local center = function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.w = max.w / 2 - padding * 2
    f.h = max.h / 1.5 - padding * 2
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
