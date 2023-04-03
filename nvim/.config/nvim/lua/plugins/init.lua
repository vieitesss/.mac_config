return {
    "neanias/everforest-nvim",
    ---- snippets
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        }
    },

    ---- programming utils
    {
        "iamcco/markdown-preview.nvim",
        event = "BufEnter *.md",
        build = "cd app && npm install"
    },
    "windwp/nvim-ts-autotag",
    {
        "lewis6991/gitsigns.nvim",
        lazy = false,
        config = true,
    },

    ---- other
    "kyazdani42/nvim-web-devicons",
    {
        "j-hui/fidget.nvim",
        event = "BufEnter",
        config = true
    },

    -- Local plugins
    {
        dir = "~/projects/nvim/colors.nvim/",
        -- opts = {
        --     "catppuccin-mocha",
        --     "catppuccin-latte",
        --     "gruvbox",
        --     "onedark"
        -- }
    }
}
