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
    },
    {
        "rktjmp/lush.nvim",
        -- lazy = false,
        -- config = function ()
        --     vim.api.nvim_exec2("colorscheme basic", {})
        -- end
    },
    {
        "jesseleite/nvim-noirbuddy",
        dependencies = {
            "tjdevries/colorbuddy.nvim",
            branch = "dev"
        },
        config = function()
            require('noirbuddy').setup {
                preset = 'kiwi'
            }
        end

    },
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        config = function()
            require 'kanagawa'.setup({
                overrides = function(_)
                    return {
                        String = { italic = true }
                    }
                end,
                -- vim.api.nvim_exec2("colorscheme kanagawa-wave", {})
            })
        end,
    },
    {
        "loctvl842/monokai-pro.nvim",
        name = "monokai-pro",
        lazy = false,
        priority = 9999,
        config = function()
            require 'monokai-pro'.setup({
                filter = "spectrum",
                styles = {
                    comment = { italic = false },
                    keyword = { italic = false }, -- any other keyword
                    type = { italic = false }, -- (preferred) int, long, char, etc
                    storageclass = { italic = false }, -- static, register, volatile, etc
                    structure = { italic = false }, -- struct, union, enum, etc
                    parameter = { italic = false }, -- parameter pass in function
                    annotation = { italic = false },
                    tag_attribute = { italic = false }, -- attribute of tag in reactjs
                }
            })
            vim.api.nvim_exec2("colorscheme monokai-pro", {})
        end
    },
    {
        "olimorris/onedarkpro.nvim",
        name = "onedark",
        -- config = function ()
        --     require'onedarkpro'.setup({
        --         styles = {
        --             strings = "italic"
        --         },
        --         style = 'warmer',
        --         -- transparent = true,
        --         code_style = {
        --             keywords = "italic",
        --             functions = "italic",
        --             strings = "italic",
        --         },
        --         diagnostics = {
        --             darker = false
        --         }
        --     })
        --     vim.api.nvim_exec2("colorscheme onedark", {})
        -- end,
    }
}
