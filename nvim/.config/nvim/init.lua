require("globals")

vim.g.mapleader = " "

if require("vt/first_load")() then
	return
end

require("plugins")
require("reload")

require("vt/lualine")
require("vt/lsp")
require("vt/mason")
require("vt/treesitter")
require("vt/telescope")
require("vt/vimtex")
require("vt/code_runner")
require("vt/nvimtree")
require("vt/lspsaga")
require("vt/autopairs")
require("vt/null-ls")
