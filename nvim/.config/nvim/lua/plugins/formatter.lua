return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        formatters_by_ft = {
            python = { "black" },
            json = { "clang-format" },
            java = { "google-java-format" }
        },
        -- format_on_save = {
        --     lsp_fallback = true,
        --     async = false,
        --     timeout_ms = 500,
        -- }
    }
}
