require("vt.plugins")
require("vt.keymaps")
require("vt.configs")
require("vt.autocmds")

P = function(v)
    print(vim.inspect(v))
    return v
end

RELOAD = function(...)
    return require("plenary.reload").reload_module(...)
end

R = function(name)
    RELOAD(name)
    return require(name)
end

OPENPDFVIEWER = function()
    -- Get file path without extension
    local path_no_ext = vim.fn.expand("%:p:r")
    -- Check if Skim is open, if open, check opened file, if not open, open current file
    local skim_is_open = io.popen("ps aux | grep Skim | grep -cv grep")
    if skim_is_open == nil then return end
    local skim_is_open_result = skim_is_open:read("*a")
    if string.sub(skim_is_open_result, 1, 1) ~= '0' then
        -- Check if the current file is opened with Skim
        local handle = io.popen("lsof -p $(ps aux | grep Skim | grep -v grep | awk '{print $2}') | grep -c " ..
        path_no_ext .. ".pdf")
        if handle == nil then return end
        local result = handle:read("*a")
        -- Open this file if not opened
        if string.sub(result, 1, 1) == '0' then
            os.execute("open " .. path_no_ext .. ".pdf -a Skim")
        end
        handle:close()
    else
        os.execute("open " .. path_no_ext .. ".pdf -a Skim")
    end
    skim_is_open:close()
end

