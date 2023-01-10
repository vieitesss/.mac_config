return {
    "nvim-lualine/lualine.nvim",
    opts = {
        options = {
            icons_enabled = true,
            theme = "auto",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            -- component_separators = { left = "", right = "" },
            -- section_separators = { left = "", right = "" },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = {
                { "branch", icon = "" },
                { "diagnostics", sources = { "nvim_diagnostic", "coc" } },
            },
            lualine_c = { "filename" },
            lualine_x = { "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
        inactive_sections = {
            -- lualine_a = {},
            -- lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            -- lualine_y = {},
            -- lualine_z = {},
        },
        winbar = {
            lualine_b = { "diagnostics" },
            lualine_c = { "filename" },
        },
        inactive_winbar = {
            lualine_b = { "diagnostics" },
            lualine_c = { "filename" },
        }
        -- tabline = {},
        -- extensions = {},
    }
}
