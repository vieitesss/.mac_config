local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

---@param spec {string,...} A table with the modules to load.
local function apply_to_config(spec)
    for _, s in ipairs(spec) do
        local ok, r = pcall(require, s)
        if ok then
            r.apply_to_config(config)
        else
            wezterm.log_error(string.format("The module '%s' does not exist", s))
        end
    end

end

apply_to_config({
    'configs',
    'keys',
    'keytables',
    'autocmds',
})

-- Plugins

wezterm.plugin.update_all()

local sess = wezterm.plugin.require 'https://github.com/vieitesss/workspacesionizer.wezterm'
-- local sess = wezterm.plugin.require 'file:///Users/vieites/personal/workspacesionizer.wezterm'
local o = sess.apply_to_config(config, {
    paths = { "~/personal", "~/.config", "~/tfg", "~/prefapp" },
})

return config
