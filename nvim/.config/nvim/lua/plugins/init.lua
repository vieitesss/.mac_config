return {
    "neanias/everforest-nvim",
    ---- snippets
    ---- programming utils
    {
        "iamcco/markdown-preview.nvim",
        event = "BufEnter *.md",
        cmd = "MarkdownPreview",
        -- build = "cd app && npm install"
    },
    {
        "windwp/nvim-ts-autotag",
        lazy = false
    },
    {
        "lewis6991/gitsigns.nvim",
        lazy = false,
        config = true,
    },

    ---- other
    {
        "kyazdani42/nvim-web-devicons",
    },
    {
        "j-hui/fidget.nvim",
        event = "BufEnter",
        tag = "legacy",
        config = true
    },

    -- Local plugins
    {
        dir = "~/projects/nvim/colors.nvim/",
        opts = {
            "catppuccin-mocha",
            "catppuccin-latte",
            "gruvbox",
            "onedark"
        }
    },
    {
        dir = "~/richmd.nvim/",
        event = "BufEnter *.md",
    },
}
