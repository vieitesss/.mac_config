local M = {}

local default = {
    theme = 'habamax',
    bg = 'dark',
}

local colorschemeFile = vim.fn.getenv('HOME') .. "/.local/share/nvim/.colorscheme"

-- Creates file with default values if it does not exit
if io.open(colorschemeFile) == nil then
    os.execute("printf '" .. default["theme"] .. "\n" .. default["bg"] .. "\n' > " .. colorschemeFile)
end

-- Get data from colorscheme file
-- @return table
M._getData = function()
    local data = {}

    local file = io.open(colorschemeFile)

    if file == nil then
        print('nil colorscheme file')
        return default
    end

    data["theme"] = file:read()
    data["bg"] = file:read()

    return data
end

-- Check if the provided theme is a default colorscheme. If it is not, it is considered as plugin
-- @param: theme -> string
-- @return: bool
M._themeIsPlugin = function(theme)
    local tmp = "/tmp/tmp.txt"

    os.execute("ls $VIMRUNTIME/colors/ > " .. tmp) -- habamax.vim

    local file = io.open(tmp)

    if file == nil then
        print('nil tmp file')
        return true
    end

    for line in file:lines() do
        line = string.sub(line, 1, -5)
        if line == theme then
            return false
        end
    end

    return true
end

-- Set the new theme and background provided.
-- It changes the values from the colorscheme file and calls M.setup
M.setTheme = function()
    theme = vim.fn.input("Theme: ")
    bg = vim.fn.input("Background (light|dark): ")

    local data = M._getData()

    if string.len(theme) == 0 then
        theme = data["theme"]
    end

    if not string.match(bg, 'light') and not string.match(bg, 'dark') then
        print('bg do not match light neither dark')
        bg = data["bg"]
    end

    os.execute("printf '" .. theme .. "\n" .. bg .. "\n' > " .. colorschemeFile)

    M.setup()
end

M.setup = function()
    local file = io.open(colorschemeFile)

    if file == nil then
        print('nil file')
        return
    end

    theme = file:read() -- First line -> theme
    bg = file:read() -- Second line -> background

    if M._themeIsPlugin(theme) then
        local status, _ = pcall(require, theme)
        if not status then
            print('the colorscheme "' .. theme .. '" is not installed')
            theme = default["theme"]
            bg = default["bg"]
        end
    end

    vim.api.nvim_command("colorscheme " .. theme)
    vim.o.background = bg
end

return M
