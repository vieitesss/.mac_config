return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require('nvim-treesitter.configs').setup({
            ensure_installed = {
                "bash",
                "c",
                "java",
                "javascript",
                "json",
                "lua",
                "vim",
                -- "python",
                -- "latex",
                -- "html",
            }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true, -- false will disable the whole extension
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
            autotag = { enable = true },
        })
    end
}
