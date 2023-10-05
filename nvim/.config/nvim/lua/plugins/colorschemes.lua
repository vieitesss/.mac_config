return {
    {
        "morhetz/gruvbox",
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
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
        config = function ()
            vim.api.nvim_exec2("colorscheme basic", {})
        end
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
    },
    {
        "rktjmp/lush.nvim",
        lazy = false,
    },
    {
        "jesseleite/nvim-noirbuddy",
        dependencies = {
            "tjdevries/colorbuddy.nvim",
            branch = "dev"
        },
        config = function ()
            require('noirbuddy').setup{
                preset = 'kiwi'
            }
        end

    },
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        config = function ()
            require'kanagawa'.setup({
                overrides = function (_)
                    return {
                        String = { italic = true }
                    }
                end,
            })
            vim.api.nvim_exec2("colorscheme kanagawa-wave", {})
        end,
    },
    {
        "olimorris/onedarkpro.nvim",
        priority = 1000,
        opts = {
            styles = {
                strings = "italic"
            },
            style = 'warmer',
            -- transparent = true,
            code_style = {
                keywords = "italic",
                functions = "italic",
                strings = "italic",
            },
            diagnostics = {
                darker = false
            }
        }
    }
}
