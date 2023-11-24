return {
    {
        "morhetz/gruvbox",
        enable = false,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        enable = false,
        -- priority = 1000,
        opts = {
            styles = {
                comments = { "italic" },
                conditionals = { "italic" },
                keywords = { "italic" },
                strings = { "italic" },
                booleans = { "italic" },
            }
        }
    },
    {
        dir = "~/projects/nvim/basic/",
    },
    {
        "rktjmp/lush.nvim",
        enable = false,
        -- lazy = false,
        -- config = function ()
        --     vim.api.nvim_exec2("colorscheme basic", {})
        -- end
    },
    {
        "rebelot/kanagawa.nvim",
        enable = false,
        priority = 9999,
        config = function()
            require('kanagawa').setup({
                theme = "wave",
                transparent = true,
                colors = {
                    palette = {
                        -- kanagawa wave fg
                        fujiWhite = "#e8e8d8",
                    },
                }
            })
            -- vim.api.nvim_exec2("colorscheme kanagawa", {})
        end,
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        config = function ()
            require("tokyonight").setup({
                style = "storm",
                transparent = true,
                styles = {
                    comments = { italic = false },
                    keywords = { italic = false }
                }
            })
            vim.api.nvim_exec2("colorscheme tokyonight", {})
        end
    },
    {
        "loctvl842/monokai-pro.nvim",
        enable = false,
        name = "monokai-pro",
        -- lazy = false,
        -- priority = 9999,
        config = function()
            require 'monokai-pro'.setup({
                filter = "spectrum",
                styles = {
                    comment = { italic = false },
                    keyword = { italic = false },       -- any other keyword
                    type = { italic = false },          -- (preferred) int, long, char, etc
                    storageclass = { italic = false },  -- static, register, volatile, etc
                    structure = { italic = false },     -- struct, union, enum, etc
                    parameter = { italic = false },     -- parameter pass in function
                    annotation = { italic = false },
                    tag_attribute = { italic = false }, -- attribute of tag in reactjs
                }
            })
            vim.api.nvim_exec2("colorscheme monokai-pro", {})
        end
    },
}
