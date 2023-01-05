vim.opt.termguicolors = true

local api = vim.api

-- api.nvim_set_hl(0, "Normal", { bg = "none" })
-- api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

vim.keymap.set("n", "<leader>st", ":so $HOME/.config/nvim/lua/vt/color-picker.lua<cr>")

api.nvim_command("colorscheme everforest")
api.nvim_command("set background=dark")
