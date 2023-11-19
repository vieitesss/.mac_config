return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        formatters_by_ft = {
            python = { "black" },
            json = { "clang-format" },
            java = { "google-java-format" },
            sh = { "beautysh" },
            rust = { "rustfmt" }
        },
    }
}
