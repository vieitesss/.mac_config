return {
    "nvim-lualine/lualine.nvim",
    event = { "BufNewFile", "BufRead", "BufWritePost" },
    opts = {
        options = {
            theme = "gruvbox",
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { 'filename' },
            lualine_x = { 'filetype' },
            lualine_y = {
                'progress',
                {
                    require("lazy.status").updates,
                    cond = require("lazy.status").has_updates,
                    color = { fg = "#ff9e64" },
                },
            },
            lualine_z = { 'location' }
        },
    }
}
