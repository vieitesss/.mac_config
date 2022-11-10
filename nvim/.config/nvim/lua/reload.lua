local status, plenary = pcall(require, "plenary.reload")
if not status then
    print("Please install plenary")
    return
end

local M = {}

local lua_dir = vim.fn.getenv("HOME") .. "/.config/nvim/lua"
local len_lua_dir = string.len(lua_dir)

M.reload_nvim = function()
    local files = M._get_files(lua_dir)

    for _, v in ipairs(files) do
        plenary.reload_module(v)
        require(v)
        -- print(v)
    end
end

M._get_files = function(dir)
    local files = {}

    local list = vim.fn.glob(dir .. "/*", 0, 1)
    for _, v in ipairs(list) do
        if vim.fn.isdirectory(v) > 0 then
            for _, file in ipairs(M._get_files(v)) do
                table.insert(files, file)
            end
        elseif string.match(v, "%.lua$") then
            local entry = string.sub(v, len_lua_dir + 2, string.len(v) + 1)
            entry = string.gsub(entry, "%.lua", "")
            entry = string.gsub(entry, "/", ".")
            table.insert(files, entry)
        end
    end

    return files
end

return M
