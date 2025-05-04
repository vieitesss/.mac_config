local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

M.apply_to_config = function(config)
    local search_mode = nil
    local copy_mode = nil

    if wezterm.gui then
        search_mode = wezterm.gui.default_key_tables().search_mode
        copy_mode = wezterm.gui.default_key_tables().copy_mode
        table.insert(
            search_mode,
            { key = 'Enter', mods = '', action = act.CopyMode 'AcceptPattern' }
        )
        table.insert(
            search_mode,
            { key = 'u', mods = 'CTRL', action = act.CopyMode 'ClearPattern' }
        )
        table.insert(
            copy_mode,
            { key = '-', mods = '', action = act.CopyMode 'ClearPattern' }
        )
        table.insert(
            copy_mode,
            { key = '/', mods = '', action = act.CopyMode 'EditPattern' }
        )
    end

    config.key_tables = {
        search_mode = search_mode,
        copy_mode = copy_mode
    }
end

return M
