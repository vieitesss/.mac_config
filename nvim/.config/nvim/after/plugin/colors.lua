vim.opt.termguicolors = true

local colors = require("vt/colorscheme")
colors.setup()

vim.keymap.set("n", "<leader>st", ":lua require('vt/colorscheme').setTheme()<cr>")

-- local api = vim.api
-- api.nvim_set_hl(0, "Normal", { bg = "none" })
-- api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
