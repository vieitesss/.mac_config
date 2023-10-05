vim.opt.termguicolors = true

return {
    "famiu/feline.nvim",
    event = { "BufNewFile", "BufRead", "BufWritePost" },
    version = false,
    -- lazy = false,
    config = function()
        local components = {
            active = {
                {}, -- Left
                {}, -- Mid
                {}, -- Right
            },
            inactive = {
                {}, -- Left
            }
        }

        -- vim.api.nvim_exec2("colorscheme kanagawa", {})
        local colors = require 'kanagawa.colors'.setup()

        -- Left active components
        table.insert(components.active[1], {
            provider = 'vi_mode',
            icon = '',
            hl = function()
                local tbl = {}

                local mode = require('feline.providers.vi_mode').get_mode_highlight_name()
                tbl.name = mode
                tbl.fg = colors.palette.dragonBlack0
                tbl.style = 'bold'

                if mode == 'StatusComponentVimInsert' then
                    tbl.bg = 'yellow'
                elseif mode == 'StatusComponentVimVisual' then
                    tbl.bg = 'green'
                else
                    tbl.bg = colors.palette.crystalBlue
                end

                return tbl
            end,
            padding = 'center',
            right_sep = {
                str = '',
                always_visible = true
            }
        })

        table.insert(components.active[1], {
            provider = 'git_branch',
            left_sep = '',
            right_sep = '',
        })

        table.insert(components.active[1], {
            provider = {
                name = 'file_info',
                opts = {
                    type = 'unique',
                    file_modified_icon = '%m',
                }
            }
        })

        table.insert(components.active[1], {
            provider = 'diagnostic_errors',
            hl = {
                fg = 'red'
            }
        })

        table.insert(components.active[1], {
            provider = 'diagnostic_warnings',
            hl = {
                fg = 'yellow'
            }
        })

        table.insert(components.active[1], {
            provider = 'diagnostic_hints',
            hl = {
                fg = 'oceanblue'
            }
        })

        table.insert(components.active[1], {
            provider = 'diagnostic_info',
            hl = {
                fg = 'green'
            }
        })

        -- Right active components
        table.insert(components.active[3], {
            provider = 'cmd',
            right_sep = ' ',
        })

        table.insert(components.active[3], {
            provider = 'position',
            right_sep = ' ',
        })

        -- Inactive components
        table.insert(components.inactive[1], {
            provider = {
                name = 'file_info',
                opts = {
                    type = 'unique',
                    file_modified_icon = '%m',
                }
            }
        })

        require 'feline'.setup({
            custom_providers = {
                cmd = function()
                    return "%S"
                end,
            },
            components = components,
        })

        local kanagawa = {
            fg = colors.theme.ui.fg,
            bg = colors.palette.dragonBlack0,
            -- bg = colors.theme.ui.bg_gutter,
            black = colors.palette.dragonBlack0,
            skyblue = colors.palette.dragonBlue,
            cyan = colors.palette.lotusCyan,
            green = colors.palette.springGreen,
            oceanblue = '#0066cc',
            magenta = colors.palette.lotusViolet3,
            orange = colors.palette.surimiOrange,
            red = colors.palette.lotusRed,
            violet = '#8992a7',
            white = '#FFFFFF',
            yellow = colors.palette.lotusYellow3,
        }

        require'feline'.use_theme(kanagawa)
        -- vim.api.nvim_exec2("colorscheme basic", {})
    end
}
