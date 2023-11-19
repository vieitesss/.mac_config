return {
    "williamboman/mason-lspconfig.nvim",
    -- enable = false,
    cmd = "Mason",
    name = "mason-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        name = "mason",
        opts = {
            ui = {
                icons = {
                    package_installed = "",
                    package_pending = "➜",
                    package_uninstalled = "",
                },
            }
        }
    },
    opts = {
        ensure_installed = {
            "lua_ls",
            "bashls",
            "clangd",
            "jdtls",
            "marksman",
            "pyright",
        },
    }
}
