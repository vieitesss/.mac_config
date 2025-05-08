local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

M.apply_to_config = function(config)
    config.keys = {
        { key = 'r', mods = 'LEADER', action = act.ReloadConfiguration },
        { key = 's', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'WORKSPACES' } },
        -- Panes
        { key = 'h', mods = 'CTRL',   action = act.ActivatePaneDirection 'Left' },
        { key = 'l', mods = 'CTRL',   action = act.ActivatePaneDirection 'Right' },
        { key = 'k', mods = 'CTRL',   action = act.ActivatePaneDirection 'Up' },
        { key = 'j', mods = 'CTRL',   action = act.ActivatePaneDirection 'Down' },
        { key = '_', mods = 'LEADER', action = act.SplitPane { direction = 'Right' } },
        { key = '-', mods = 'LEADER', action = act.SplitPane { direction = 'Down' } },
        { key = 'm', mods = 'LEADER', action = act.TogglePaneZoomState },
        -- Tabs
        { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
        { key = ',', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
        { key = '.', mods = 'LEADER', action = act.ActivateTabRelative(1) },
        { key = ',', mods = 'CTRL|SHIFT', action = act.MoveTabRelative(-1) },
        { key = '.', mods = 'CTRL|SHIFT', action = act.MoveTabRelative(1) },
        -- Search
        { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },
    }
end

return M
