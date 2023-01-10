return {
    ---- colorschemes
    "ellisonleao/gruvbox.nvim",
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
    { "iamcco/markdown-preview.nvim", cmd = "MarkdownPreview" },
    ----
    "christoomey/vim-tmux-navigator",
    "windwp/nvim-ts-autotag",
    "kyazdani42/nvim-web-devicons",
    { "j-hui/fidget.nvim", config = true },

    { "lewis6991/gitsigns.nvim", config = true },
}
