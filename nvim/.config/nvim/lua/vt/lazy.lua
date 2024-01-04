local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>ps", "<cmd>lua require('lazy').sync()<cr>", { silent = true })

local config = {}

config.plugins = {
    { import = 'plugins' },
    { import = 'plugins.colorschemes' }
}

config.opts = {
    defaults = {
        lazy = true,
        version = false
    },
    install = {
        colorscheme = { "gruvbox", "kanagawa", "default" }
    },
    checker = { enabled = true, notify = false },
    change_detection = { notify = false }
}


return require("lazy").setup(config.plugins, config.opts)
