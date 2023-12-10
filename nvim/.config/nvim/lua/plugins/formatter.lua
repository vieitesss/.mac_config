return {
    "stevearc/conform.nvim",
    cmd = { "ConfromInfo" },
    keys = {
        {
            "<Leader>fo",
            function ()
                require'conform'.format({ async = true, lsp_fallback = true })
            end,
            mode = "",
            desc = "Format the current buffer",
        }
    },
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
