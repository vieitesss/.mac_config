require("vt/plugins")
require("vt/keymaps")
require("vt/configs")

local ok, plenary_reload = pcall(require, "plenary.reload")
if not ok then
	reloader = require
else
	reloader = plenary_reload.reload_module
end

P = function(v)
	print(vim.inspect(v))
	return v
end

RELOAD = function(...)
	return reloader(...)
end

R = function(name)
	RELOAD(name)
	return require(name)
end

-- Status line
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		vim.api.nvim_command("set laststatus=3")
	end,
})

-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = { "*.js", "*.c", "*.h", "*.lua", "*.sh", "*.java" },
-- 	callback = function()
-- 		vim.lsp.buf.format()
-- 	end,
-- })
