local wezterm = require 'wezterm'
-- local act = wezterm.action

-- This table will hold the configuration.
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

wezterm.on('update-right-status', function (window, _)
    local final = {}

    local workspaces = wezterm.mux.get_workspace_names()
    local current_workspace = wezterm.mux.get_active_workspace()

    for _,ws in ipairs(workspaces) do
        if ws == current_workspace then
            table.insert(final, { Text = ' ' .. ws .. ' * ' })
        else
            table.insert(final, { Text = ' ' .. ws .. ' ' })
        end
    end
    window:set_right_status(wezterm.format(final))
end)

wezterm.GLOBAL.tab_titles = wezterm.GLOBAL.tab_titles or {}

wezterm.on('format-tab-title', function (tab, _, _, _, _, _)
    local pane_title = tab.active_pane.title
    local user_title = tab.active_pane.user_vars.tabname
    if user_title ~= nil and #user_title > 0 then
        pane_title = user_title
    end


    if tab.is_active then
        return {
            { Background = { Color = '#5b5b5b' } },
            { Text = ' ' .. pane_title .. ' ' }
        }
    end
    return tab.active_pane.title
end)

-- Leader
config.leader = { key = 'm', mods = 'CTRL' }

-- Cursor
config.force_reverse_video_cursor = true

-- Window
config.window_padding = {
    left = 0,
    right = 0,
    bottom = 0,
    top = 0,
}
config.window_background_opacity = 0.95
config.macos_window_background_blur = 10
config.window_decorations = "RESIZE"

-- Colorscheme
-- config.color_scheme = 'Monokai (base16)'
config.color_scheme = 'Kanagawa (Gogh)'
-- config.color_scheme = 'tokyonight-storm'
-- config.colors = {
--     background = '#222222'
-- }

-- Font
-- config.font = wezterm.font_with_fallback { 'Victor Mono', 'Hack Nerd Font' }
-- config.font = wezterm.font_with_fallback { 'JetBrains Mono', 'Hack Nerd Font' }
-- config.font = wezterm.font_with_fallback { 'SF Mono', 'Hack Nerd Font Mono' }
config.font = wezterm.font("Victor Mono", { weight = "Medium" })
config.font_size = 17
-- ->
-- hola que tal COMO estas () {} [] <> '' "" ``

-- Tabbar
config.enable_tab_bar = false
config.tab_bar_at_bottom = true

-- Ctrl-C not bad exit
config.clean_exit_codes = { 130 }

-- Return config
return config
