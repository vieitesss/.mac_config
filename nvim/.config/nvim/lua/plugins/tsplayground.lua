return {
    "nvim-treesitter/playground",
    enabled = false,
    event = "BufReadPre",
    dependencies = {
        "nvim-treesitter/nvim-treesitter"
    },
    build = ":TSInstall query"
}
