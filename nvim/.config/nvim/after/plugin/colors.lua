vim.opt.termguicolors = true

local api = vim.api

-- api.nvim_set_hl(0, "Normal", { bg = "none" })
-- api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- vim.keymap.set("n", "<leader>st", ":lua require('colors').setTheme()<cr>")
vim.keymap.set("n", "<leader>sb", ":lua require('colors').setBackground()<cr>")

vim.cmd("colorscheme kanagawa")
-- api.nvim_command("set background=dark")
