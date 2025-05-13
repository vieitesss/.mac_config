local wezterm = require 'wezterm'
local configs = {}

configs.apply_to_config = function(config)
    -- Font
    -- config.font = wezterm.font_with_fallback { 'Victor Mono', 'Hack Nerd Font' }
    -- config.font = wezterm.font_with_fallback { 'JetBrains Mono', 'Hack Nerd Font' }
    -- config.font = wezterm.font_with_fallback { 'SF Mono', 'Hack Nerd Font Mono' }
    -- config.font = wezterm.font("Victor Mono", { weight = "Medium" })
    config.font = wezterm.font("AnonymicePro Nerd Font Mono", { weight = "Medium" })

    -- Leader
    config.leader = { key = 'Space', mods = 'CTRL' }

    -- Cursor
    config.force_reverse_video_cursor = true

    -- Window
    config.window_padding = {
        left = 0,
        right = 0,
        bottom = 0,
        top = 0,
    }
    config.window_background_opacity = 1
    config.macos_window_background_blur = 10
    config.window_decorations = "RESIZE"

    -- Colorscheme
    -- config.color_scheme = 'Monokai (base16)'
    -- config.color_scheme = 'Kanagawa (Gogh)'
    -- config.color_scheme = 'mellifluous'
    -- config.color_scheme = 'kanso-zen'
    config.color_scheme = 'Catppuccin Mocha (Gogh)'
    -- config.color_scheme = 'tokyonight-storm'
    config.colors = {
        tab_bar = {
            background = "rgba(0, 0, 0, 0)",
            active_tab = {
                bg_color = "rgba(0, 0, 0, 0)",
                fg_color = "#cccc50"
            },
            inactive_tab = {
                bg_color = "rgba(0, 0, 0, 0)",
                fg_color = "#444444"
            },
        }
    }

    config.font_size = 20
    config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

    -- Tabbar
    config.enable_tab_bar = true
    config.tab_bar_at_bottom = true
    -- config.show_new_tab_button_in_tab_bar = false

    -- Ctrl-C not bad exit
    config.clean_exit_codes = { 130 }

    config.send_composed_key_when_left_alt_is_pressed = true
    config.use_fancy_tab_bar = false
    -- Return config
end

return configs
