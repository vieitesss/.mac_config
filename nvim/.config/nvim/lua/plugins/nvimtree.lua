vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

return {
    "kyazdani42/nvim-tree.lua",
    keys = {
        { "<leader>pv", "<cmd>NvimTreeToggle<cr>" }
    },
    opts = {
        actions = {
            open_file = {
                quit_on_open = true
            }
        },
        view = {
            relativenumber = true,
        },
    }
}
