local wezterm = require 'wezterm'
local act = wezterm.action

return {
    -- Panes
    {
        key = '\\',
        mods = 'LEADER',
        action = wezterm.action.SplitPane {
            direction = 'Right'
        }
    },
    {
        key = '-',
        mods = 'LEADER',
        action = wezterm.action.SplitPane {
            direction = 'Down'
        }
    },
    -- Zoom pane
    {
        key = 'm',
        mods = 'LEADER',
        action = wezterm.action.TogglePaneZoomState,
    },
    -- Move between panes
    -- {
    --     key = 'h',
    --     mods = 'CTRL',
    --     action = act.ActivatePaneDirection 'Left',
    -- },
    -- {
    --     key = 'l',
    --     mods = 'CTRL',
    --     action = act.ActivatePaneDirection 'Right',
    -- },
    -- {
    --     key = 'k',
    --     mods = 'CTRL',
    --     action = act.ActivatePaneDirection 'Up',
    -- },
    -- {
    --     key = 'j',
    --     mods = 'CTRL',
    --     action = act.ActivatePaneDirection 'Down',
    -- },
    {
        key = 's',
        mods = 'LEADER',
        action = wezterm.action.ShowLauncherArgs { flags = 'WORKSPACES' }
    },
    {
        key = 'j',
        mods = 'CTRL|SHIFT',
        action = act.SwitchToWorkspace {
            name = 'configs',
        },
    },
    {
        key = 'k',
        mods = 'CTRL|SHIFT',
        action = act.SwitchToWorkspace {
            name = 'other',
        },
    },
    {
        key = 'l',
        mods = 'CTRL|SHIFT',
        action = act.SwitchToWorkspace {
            name = 'uni',
        },
    }
}
