local wezterm = require 'wezterm'

local M = {}

M.apply_to_config = function(config)
    wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
        local zoomed = ""
        if tab.active_pane.is_zoomed then
            zoomed = "[Z]"
        end

        return '  ' .. zoomed .. tab.active_pane.title .. '  '
    end)

    wezterm.on('update-right-status', function(window, _)
        local text = wezterm.format {
            { Text = window:active_workspace() },
        }
        window:set_right_status(text)
    end)
end

return M
