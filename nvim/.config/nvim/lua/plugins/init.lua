return {
    ---- colorschemes
    "ellisonleao/gruvbox.nvim",
    "neanias/everforest-nvim",
    -- "catppuccin/nvim"

    ---- cmp
    -- "hrsh7th/nvim-cmp",
    -- "hrsh7th/cmp-buffer",
    -- "hrsh7th/cmp-cmdline",
    -- "hrsh7th/cmp-path",

    ---- lsp
    -- "neovim/nvim-lspconfig",
    -- "williamboman/mason.nvim",
    -- "williamboman/mason-lspconfig.nvim",
    -- "hrsh7th/cmp-nvim-lsp",
    -- { "glepnir/lspsaga.nvim", branch = "main" },

    ---- telescope
    -- "nvim-telescope/telescope.nvim",
    -- "nvim-lua/plenary.nvim",
    -- "nvim-lua/popup.nvim",

    ---- treesitter
    -- "nvim-treesitter/nvim-treesitter",

    ---- snippets
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        }
    },

    ---- programming utils
    { "iamcco/markdown-preview.nvim" },
    "windwp/nvim-ts-autotag",
    { "lewis6991/gitsigns.nvim", config = true },
    -- "windwp/nvim-autopairs",
    -- "terrortylor/nvim-comment",

    ---- other
    "christoomey/vim-tmux-navigator",
    "kyazdani42/nvim-web-devicons",
    { "j-hui/fidget.nvim", config = true },
    -- "nvim-lualine/lualine.nvim",
    -- "szw/vim-maximizer",
    -- "kyazdani42/nvim-tree.lua",

    -- Local plugins
    {
        dir = "~/projects/nvim/colors.nvim/",
        opts = {
            "catppuccin-mocha",
            "catppuccin-latte",
            "gruvbox"
        }
    }
}
