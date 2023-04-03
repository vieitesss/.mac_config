return {
    "morhetz/gruvbox",
    {
        "catppuccin/nvim",
        name = "catppuccin",
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
        "navarasu/onedark.nvim",
        name = "onedark",
        opts = {
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
