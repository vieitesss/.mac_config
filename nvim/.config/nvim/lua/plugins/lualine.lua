return {
    "nvim-lualine/lualine.nvim",
    event = { "BufNewFile", "BufRead", "BufWritePost" },
    dependencies = {
        -- "folke/tokyonight.nvim",
        "rebelot/kanagawa.nvim"
    },
    opts = {
        options = {
            theme = "kanagawa",
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { 'filename' },
            lualine_x = { 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = { 'location' }
        },
    }
}
